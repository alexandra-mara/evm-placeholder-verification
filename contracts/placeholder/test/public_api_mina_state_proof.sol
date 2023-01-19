// SPDX-License-Identifier: Apache-2.0.
//---------------------------------------------------------------------------//
// Copyright (c) 2022 Mikhail Komarov <nemo@nil.foundation>
// Copyright (c) 2022 Ilias Khairullin <ilias@nil.foundation>
// Copyright (c) 2022 Aleksei Moskvin <alalmoskvin@nil.foundation>
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//---------------------------------------------------------------------------//
pragma solidity >=0.8.4;

import "../../types.sol";
import "../../cryptography/transcript.sol";
import "../proof_map_parser.sol";
import "../placeholder_verifier.sol";
import "../../logging.sol";
import "../../profiling.sol";
import "../init_vars.sol";
import "../../components/mina_base_split_gen.sol";
import "../../components/mina_scalar_split_gen.sol";

contract TestMinaStateProof {
    event gas_usage_emit(uint8 command, string function_name, uint256 gas_usage);

    struct test_local_vars {
        uint256 proofs_num;
        uint256 ind;

        types.placeholder_proof_map proof_map;
        types.arithmetization_params arithmetization_params;
        uint256 proof_offset;
        uint256 proof_size;
        types.transcript_data tr_state;
        types.fri_params_type fri_params;
        types.placeholder_common_data common_data;
    }

    function init_vars(test_local_vars memory vars, uint256[] memory init_params, int256[4][] memory columns_rotations) internal view{
        uint256 idx = 0;
        vars.fri_params.modulus = init_params[idx++];
        vars.fri_params.r = init_params[idx++];
        vars.fri_params.max_degree = init_params[idx++];
        vars.fri_params.lambda = init_params[idx++];

        vars.common_data.rows_amount = init_params[idx++];
        vars.common_data.omega = init_params[idx++];
        vars.fri_params.max_batch = init_params[idx++];
        placeholder_proof_map_parser.init(vars.fri_params, vars.fri_params.max_batch);

        vars.common_data.columns_rotations = columns_rotations;

        vars.fri_params.D_omegas = new uint256[](init_params[idx++]);
        for (uint256 i = 0; i < vars.fri_params.D_omegas.length;) {
            vars.fri_params.D_omegas[i] = init_params[idx];
            unchecked{ i++; idx++;}
        }
        vars.fri_params.q = new uint256[](init_params[idx++]);
        for (uint256 i = 0; i < vars.fri_params.q.length;) {
            vars.fri_params.q[i] = init_params[idx];
            unchecked{ i++; idx++;}
        }

        vars.fri_params.step_list = new uint256[](init_params[idx++]);
        vars.fri_params.max_step = 0;
        for (uint256 i = 0; i < vars.fri_params.step_list.length;) {
            vars.fri_params.step_list[i] = init_params[idx];
            if(vars.fri_params.step_list[i] > vars.fri_params.max_step)
                vars.fri_params.max_step = vars.fri_params.step_list[i];
            unchecked{ i++; idx++;}
        }

        unchecked{
            idx++; // arithmetization_params length;
            vars.arithmetization_params.witness_columns = init_params[idx++];
            vars.arithmetization_params.public_input_columns = init_params[idx++];
            vars.arithmetization_params.constant_columns = init_params[idx++];
            vars.arithmetization_params.selector_columns = init_params[idx++];
            vars.arithmetization_params.permutation_columns = vars.arithmetization_params.witness_columns 
                + vars.arithmetization_params.public_input_columns 
                + vars.arithmetization_params.constant_columns;
        }
    }

    function allocate_all(test_local_vars memory vars, uint256 max_step, uint256 max_batch) internal view{
        uint256 max_coset = 1 << (vars.fri_params.max_step - 1);

        vars.fri_params.s_indices = new uint256[](max_coset);
        vars.fri_params.s = new uint256[](max_coset);

        vars.fri_params.correct_order_idx = new uint256[](max_coset);
        vars.fri_params.tmp_arr = new uint256[](max_coset << 1);
        vars.fri_params.coeffs = new uint256[](max_coset << 1);

        vars.fri_params.b = new bytes(0x40 * vars.fri_params.max_batch * max_coset);
        vars.fri_params.precomputed_eval1 = new uint256[](5);
    }

    function verify(
        bytes calldata blob,
        // 0) modulus
        // 1) r
        // 2) max_degree
        // 3) lambda
        // 4) rows_amount
        // 5) omega
        // 6) max_leaf_size
        // 7) D_omegas_size
        //  [..., D_omegas_i, ...]
        // 8 + D_omegas_size) q_size
        //  [..., q_i, ...]
        uint256[][] calldata init_params,
        int256[4][][2] calldata columns_rotations
    ) public {
        profiling.start_block("public_api_mina_state_proof::verify");
        test_local_vars memory vars;
        uint256 max_step;
        uint256 max_batch;

        require(blob.length == init_params[0][1], "Invalid input length");

        profiling.start_block("public_api_mina_state_proof::verify base proof");
        for( vars.ind = 0; vars.ind < 2; ){
            init_vars(vars, init_params[vars.ind+1], columns_rotations[vars.ind]);
            if(vars.fri_params.max_step > max_step) max_step = vars.fri_params.max_step;
            if(vars.fri_params.max_batch > max_step) max_batch = vars.fri_params.max_batch;
            unchecked{ vars.ind++; }
        }
        allocate_all(vars, vars.fri_params.max_step, vars.fri_params.max_batch);

        // Map parser for each proof.
        vars.proof_offset = 0;
        (vars.proof_map, vars.proof_size) = placeholder_proof_map_parser.parse_be(blob, vars.proof_offset);

        require(vars.proof_size <= blob.length, "Base proof length was detected incorrectly!");
        require(vars.proof_size == init_params[0][0], logging.uint2decstr(vars.proof_size));
        require(vars.proof_size == init_params[0][0], "Invalid first proof length");
        init_vars(vars, init_params[1], columns_rotations[0]);
        transcript.init_transcript(vars.tr_state, hex"");

        types.placeholder_local_variables memory local_vars;

        // 3. append variable commitments to transcript
        transcript.update_transcript_b32_by_offset_calldata(vars.tr_state, blob, basic_marshalling.skip_length(vars.proof_map.variable_values_commitment_offset));

        // 4. prepare evaluaitons of the polynomials that are copy-constrained
        // 5. permutation argument
        profiling.start_block("public_api_mina_state_proof::permutation_argument");
        local_vars.permutation_argument = permutation_argument.verify_eval_be(blob, vars.tr_state,
            vars.proof_map, vars.fri_params,
            vars.common_data, local_vars, vars.arithmetization_params);
        profiling.end_block();
        // 7. gate argument specific for circuit
        profiling.start_block("public_api_mina_state_proof::gate_argument");
        types.gate_argument_local_vars memory gate_params;
        gate_params.modulus = vars.fri_params.modulus;
        gate_params.theta = transcript.get_field_challenge(vars.tr_state, vars.fri_params.modulus);
        gate_params.eval_proof_witness_offset = vars.proof_map.eval_proof_variable_values_offset;
        gate_params.eval_proof_selector_offset = vars.proof_map.eval_proof_fixed_values_offset;
        gate_params.eval_proof_constant_offset = vars.proof_map.eval_proof_fixed_values_offset;

        local_vars.gate_argument = mina_base_split_gen.evaluate_gates_be(blob, gate_params, vars.arithmetization_params, vars.common_data.columns_rotations);
        profiling.end_block();

        require(
            placeholder_verifier.verify_proof_be(blob, vars.tr_state,  vars.proof_map, vars.fri_params,
                                                 vars.common_data, local_vars, vars.arithmetization_params),
            "Base proof is not correct!"
        );

        profiling.end_block();
        profiling.start_block("public_api_mina_state_proof::verify base proof");
        vars.proof_offset += vars.proof_size;

        (vars.proof_map, vars.proof_size) = placeholder_proof_map_parser.parse_be(blob, vars.proof_offset);
        require(vars.proof_size <= blob.length, "Scalar proof length is incorrect!");
        init_vars(vars, init_params[2], columns_rotations[1]);
        transcript.init_transcript(vars.tr_state, hex"");

        types.placeholder_local_variables memory local_vars_scalar;

        // 3. append variable_values commitments to transcript
        transcript.update_transcript_b32_by_offset_calldata(vars.tr_state, blob, basic_marshalling.skip_length(vars.proof_map.variable_values_commitment_offset));

        // 4. prepare evaluaitons of the polynomials that are copy-constrained
        // 5. permutation argument
        profiling.start_block("public_api_mina_state_proof::permutation_argument");
        local_vars_scalar.permutation_argument = permutation_argument.verify_eval_be(blob, vars.tr_state,
            vars.proof_map, vars.fri_params,
            vars.common_data, local_vars_scalar, vars.arithmetization_params);
        profiling.end_block();
        // 7. gate argument specific for circuit
        profiling.start_block("public_api_mina_state_proof::gate_argument");
        gate_params.modulus = vars.fri_params.modulus;
        gate_params.theta = transcript.get_field_challenge(vars.tr_state, vars.fri_params.modulus);
        gate_params.eval_proof_witness_offset = vars.proof_map.eval_proof_variable_values_offset;
        gate_params.eval_proof_selector_offset = vars.proof_map.eval_proof_fixed_values_offset;
        gate_params.eval_proof_constant_offset = vars.proof_map.eval_proof_fixed_values_offset;

        local_vars_scalar.gate_argument = mina_split_gen.evaluate_gates_be(blob, gate_params, vars.arithmetization_params, vars.common_data.columns_rotations);

        require(
            placeholder_verifier.verify_proof_be(blob, vars.tr_state,  vars.proof_map, vars.fri_params,
                                                 vars.common_data, local_vars_scalar, vars.arithmetization_params),
            "Scalar proof is not correct!"
        );
        profiling.end_block();
        profiling.end_block();
    }
}
