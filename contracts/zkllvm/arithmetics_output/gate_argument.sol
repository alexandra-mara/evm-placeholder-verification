
// SPDX-License-Identifier: Apache-2.0.
//---------------------------------------------------------------------------//
// Copyright (c) 2022 Mikhail Komarov <nemo@nil.foundation>
// Copyright (c) 2022 Aleksei Moskvin <alalmoskvin@nil.foundation>
// Copyright (c) 2023 Elena Tatuzova  <alalmoskvin@nil.foundation>
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

import "../../../contracts/types.sol";
import "../../../contracts/basic_marshalling.sol";
import "../../../contracts/commitments/batched_lpc_verifier.sol";
import "../../../contracts/interfaces/gate_argument.sol";

contract arithmetics_output_gate_argument_split_gen  is IGateArgument{
    uint256 constant GATES_N = 4;

    struct local_vars_type{
        // 0x0
        uint256 constraint_eval;
        // 0x20
        uint256 gate_eval;
        // 0x40
        uint256 gates_evaluation;
        // 0x60
        uint256 theta_acc;

		//0x80
		uint256[] witness_evaluations;
		//a0
		uint256[] selector_evaluations;

    }

    uint256 constant MODULUS_OFFSET = 0x0;
    uint256 constant THETA_OFFSET = 0x20;

    uint256 constant CONSTRAINT_EVAL_OFFSET = 0x00;
    uint256 constant GATE_EVAL_OFFSET = 0x20;
    uint256 constant GATES_EVALUATIONS_OFFSET = 0x40;
    uint256 constant THETA_ACC_OFFSET = 0x60;
	uint256 constant WITNESS_EVALUATIONS_OFFSET = 0x80;
	uint256 constant SELECTOR_EVALUATIONS_OFFSET = 0xa0;


        function get_witness_i(uint256 idx, local_vars_type memory local_var)  pure internal returns (uint256 result) {
            return local_var.witness_evaluations[idx];
        }

        function get_selector_i(uint256 idx, local_vars_type memory local_var)  internal pure returns (uint256 result) {
            return local_var.selector_evaluations[idx];
        }

    function evaluate_gates_be(
        bytes calldata blob,
        uint256 eval_proof_combined_value_offset,
        types.gate_argument_params memory gate_params,
        types.arithmetization_params memory ar_params,
        int256[][] calldata columns_rotations
    ) external pure returns (uint256 gates_evaluation) {
        local_vars_type memory local_vars;


        local_vars.witness_evaluations = new uint256[](ar_params.witness_columns);
        for (uint256 i = 0; i < ar_params.witness_columns;) {
            local_vars.witness_evaluations[i] = batched_lpc_verifier.get_variable_values_z_i_j_from_proof_be(
                    blob, eval_proof_combined_value_offset, i, 0
            );
            unchecked{i++;}
        }

        local_vars.selector_evaluations = new uint256[](ar_params.selector_columns);
        for (uint256 i = 0; i < ar_params.selector_columns;) {
            local_vars.selector_evaluations[i] = batched_lpc_verifier.get_fixed_values_z_i_j_from_proof_be(
                blob, eval_proof_combined_value_offset, ar_params.permutation_columns + ar_params.permutation_columns + ar_params.constant_columns + i, 0
            );
            unchecked{i++;}
        }


        local_vars.theta_acc = 1;
        local_vars.gates_evaluation = 0;

        uint256 theta_acc = local_vars.theta_acc;

        uint256 terms;
        uint256 modulus = gate_params.modulus;
        uint256 theta = gate_params.theta;


			//Gate0
			local_vars.gate_eval = 0;
			local_vars.constraint_eval = 0;
			terms=get_witness_i(0, local_vars);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			terms=get_witness_i(1, local_vars);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			terms=0x40000000000000000000000000000000224698fc094cf91b992d30ed00000000;
			terms=mulmod(terms, get_witness_i(2, local_vars), modulus);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			local_vars.gate_eval = addmod(local_vars.gate_eval,mulmod(local_vars.constraint_eval,theta_acc,modulus),modulus);
			theta_acc = mulmod(theta_acc, theta, modulus);
			local_vars.gate_eval = mulmod(local_vars.gate_eval,get_selector_i(0,local_vars),modulus);
			gates_evaluation = addmod(gates_evaluation,local_vars.gate_eval,modulus);

			//Gate1
			local_vars.gate_eval = 0;
			local_vars.constraint_eval = 0;
			terms=get_witness_i(0, local_vars);
			terms=mulmod(terms, get_witness_i(1, local_vars), modulus);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			terms=0x40000000000000000000000000000000224698fc094cf91b992d30ed00000000;
			terms=mulmod(terms, get_witness_i(2, local_vars), modulus);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			local_vars.gate_eval = addmod(local_vars.gate_eval,mulmod(local_vars.constraint_eval,theta_acc,modulus),modulus);
			theta_acc = mulmod(theta_acc, theta, modulus);
			local_vars.gate_eval = mulmod(local_vars.gate_eval,get_selector_i(1,local_vars),modulus);
			gates_evaluation = addmod(gates_evaluation,local_vars.gate_eval,modulus);

			//Gate2
			local_vars.gate_eval = 0;
			local_vars.constraint_eval = 0;
			terms=get_witness_i(0, local_vars);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			terms=0x40000000000000000000000000000000224698fc094cf91b992d30ed00000000;
			terms=mulmod(terms, get_witness_i(1, local_vars), modulus);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			terms=0x40000000000000000000000000000000224698fc094cf91b992d30ed00000000;
			terms=mulmod(terms, get_witness_i(2, local_vars), modulus);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			local_vars.gate_eval = addmod(local_vars.gate_eval,mulmod(local_vars.constraint_eval,theta_acc,modulus),modulus);
			theta_acc = mulmod(theta_acc, theta, modulus);
			local_vars.gate_eval = mulmod(local_vars.gate_eval,get_selector_i(2,local_vars),modulus);
			gates_evaluation = addmod(gates_evaluation,local_vars.gate_eval,modulus);

			//Gate3
			local_vars.gate_eval = 0;
			local_vars.constraint_eval = 0;
			terms=get_witness_i(1, local_vars);
			terms=mulmod(terms, get_witness_i(2, local_vars), modulus);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			terms=0x40000000000000000000000000000000224698fc094cf91b992d30ed00000000;
			terms=mulmod(terms, get_witness_i(0, local_vars), modulus);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			local_vars.gate_eval = addmod(local_vars.gate_eval,mulmod(local_vars.constraint_eval,theta_acc,modulus),modulus);
			theta_acc = mulmod(theta_acc, theta, modulus);
			local_vars.constraint_eval = 0;
			terms=get_witness_i(1, local_vars);
			terms=mulmod(terms, get_witness_i(3, local_vars), modulus);
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			terms=0x40000000000000000000000000000000224698fc094cf91b992d30ed00000000;
			local_vars.constraint_eval = addmod(local_vars.constraint_eval,terms,modulus);
			local_vars.gate_eval = addmod(local_vars.gate_eval,mulmod(local_vars.constraint_eval,theta_acc,modulus),modulus);
			theta_acc = mulmod(theta_acc, theta, modulus);
			local_vars.gate_eval = mulmod(local_vars.gate_eval,get_selector_i(3,local_vars),modulus);
			gates_evaluation = addmod(gates_evaluation,local_vars.gate_eval,modulus);



    }
}