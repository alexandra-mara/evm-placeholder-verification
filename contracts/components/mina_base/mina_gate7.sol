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
import "../../logging.sol";

// TODO: name component
library mina_gate7 {
    uint256 constant MODULUS_OFFSET = 0x0;
    uint256 constant THETA_OFFSET = 0x20;
    uint256 constant CONSTRAINT_EVAL_OFFSET = 0x40;
    uint256 constant GATE_EVAL_OFFSET = 0x60;
    uint256 constant WITNESS_EVALUATIONS_OFFSET_OFFSET = 0x80;
    uint256 constant SELECTOR_EVALUATIONS_OFFSET = 0xa0;
    uint256 constant EVAL_PROOF_WITNESS_OFFSET_OFFSET = 0xc0;
    uint256 constant EVAL_PROOF_SELECTOR_OFFSET_OFFSET = 0xe0;
    uint256 constant GATES_EVALUATION_OFFSET = 0x100;
    uint256 constant THETA_ACC_OFFSET = 0x120;
    uint256 constant SELECTOR_EVALUATIONS_OFFSET_OFFSET = 0x140;
    uint256 constant OFFSET_OFFSET = 0x160;
    uint256 constant WITNESS_EVALUATIONS_OFFSET = 0x180;
    uint256 constant CONSTANT_EVALUATIONS_OFFSET = 0x1a0;
    uint256 constant PUBLIC_INPUT_EVALUATIONS_OFFSET = 0x1c0;

    // TODO: columns_rotations could be hard-coded
    function evaluate_gate_be(
        types.gate_argument_local_vars memory gate_params,
        int256[][] memory columns_rotations
    ) external pure returns (uint256 gates_evaluation, uint256 theta_acc) {
        gates_evaluation = gate_params.gates_evaluation;
        theta_acc = gate_params.theta_acc;
        uint256 x;
        assembly {
            let modulus := mload(gate_params)
            mstore(add(gate_params, GATE_EVAL_OFFSET), 0)

            function get_eval_i_by_rotation_idx(idx, rot_idx, ptr) -> result {
                result := mload(
                    add(
                        add(mload(add(add(ptr, 0x20), mul(0x20, idx))), 0x20),
                        mul(0x20, rot_idx)
                    )
                )
            }

            function get_C_i_by_rotation_idx(idx, rot_idx, ptr) -> result {
                result := mload(add(add(mload(add(add(ptr, 0x20), mul(0x20, idx))), 0x20),mul(0x20, rot_idx)))
            }

            function get_selector_i(idx, ptr) -> result {
                result := mload(add(add(ptr, 0x20), mul(0x20, idx)))
            }
            let x1 := add(gate_params, CONSTRAINT_EVAL_OFFSET)
            let x2 := mload(add(gate_params, WITNESS_EVALUATIONS_OFFSET))
            // TODO: insert generated code for gate argument evaluation here
            mstore(add(gate_params, GATE_EVAL_OFFSET), 0)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x298f3df7f0d69a412c0b624f49c510a0cc1b6489d4304d4b7045b870e337ded1,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1d70822e80b8581cfb5ab2c8822851174db06f98c33edea8c227e30dc22a6b3,mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),get_eval_i_by_rotation_idx(0,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0xf24f954496903346d4d753deb0b76c2e26e4dbebf04906842d108dc883cda01,mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),get_eval_i_by_rotation_idx(1,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x28beef43e4fa739fe900a17ead54c004b4182caf07ae3e235c20915be480a9c7,mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),get_eval_i_by_rotation_idx(2,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(3,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x1efa9addb1d119b22b8641c569623cf3bcb365a94ef9866bebb2bf2f40b7a8be,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x2d2c9057cafceb967f3fa5e2b7432af2f3a9556b26410784eb48b2a2d4b514f5,mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),get_eval_i_by_rotation_idx(0,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x154e83714c9641589160f3c7a17450390d0fda1f7b8dd86db5ead4b016b263ac,mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),get_eval_i_by_rotation_idx(1,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3f336eacd7e9a3ec67950ed81ef7461a48a08c9e40666a67558e2746a4b57aca,mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),get_eval_i_by_rotation_idx(2,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(4,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x36583922b72040af4ecfaa4cf017a06cd65d47707ea43424fca9066f209769eb,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3b26592d8f96997714bcb9eac4c7f39ee808ce0b0e3a8a5a0c0650405ebc2ce6,mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),mulmod(get_eval_i_by_rotation_idx(0,0, x2),get_eval_i_by_rotation_idx(0,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3d57fa111cce837451e082ea541b2d8033e6ed2c6f61740c012db87dc88b3cdd,mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),mulmod(get_eval_i_by_rotation_idx(1,0, x2),get_eval_i_by_rotation_idx(1,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x264f6d16392002e14e4920d243ff44dd9e8cf174e256dd2ff0b96153afd48444,mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),mulmod(get_eval_i_by_rotation_idx(2,0, x2),get_eval_i_by_rotation_idx(2,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(5,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x206ee97ee155209881934af04a631f057126ef0b2ba365b988e5dd07cd5855e5,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1d70822e80b8581cfb5ab2c8822851174db06f98c33edea8c227e30dc22a6b3,mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),get_eval_i_by_rotation_idx(3,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0xf24f954496903346d4d753deb0b76c2e26e4dbebf04906842d108dc883cda01,mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),get_eval_i_by_rotation_idx(4,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x28beef43e4fa739fe900a17ead54c004b4182caf07ae3e235c20915be480a9c7,mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),get_eval_i_by_rotation_idx(5,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(6,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x264ae5b73dda25064cb9ee333a45f8816685f75f0cf8ed060168d95159aaf8a2,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x2d2c9057cafceb967f3fa5e2b7432af2f3a9556b26410784eb48b2a2d4b514f5,mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),get_eval_i_by_rotation_idx(3,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x154e83714c9641589160f3c7a17450390d0fda1f7b8dd86db5ead4b016b263ac,mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),get_eval_i_by_rotation_idx(4,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3f336eacd7e9a3ec67950ed81ef7461a48a08c9e40666a67558e2746a4b57aca,mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),get_eval_i_by_rotation_idx(5,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(7,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0xd792d6149f3c29dfb14acb2ec0bf2e52c1049ec28327ecad1e74ab77790ce03,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3b26592d8f96997714bcb9eac4c7f39ee808ce0b0e3a8a5a0c0650405ebc2ce6,mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),mulmod(get_eval_i_by_rotation_idx(3,0, x2),get_eval_i_by_rotation_idx(3,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3d57fa111cce837451e082ea541b2d8033e6ed2c6f61740c012db87dc88b3cdd,mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),mulmod(get_eval_i_by_rotation_idx(4,0, x2),get_eval_i_by_rotation_idx(4,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x264f6d16392002e14e4920d243ff44dd9e8cf174e256dd2ff0b96153afd48444,mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),mulmod(get_eval_i_by_rotation_idx(5,0, x2),get_eval_i_by_rotation_idx(5,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(8,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x3642bfc2fa24ec81586c0ef4922f7858d7cdcf4bedc7393fdd0d3bf20a82cb93,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1d70822e80b8581cfb5ab2c8822851174db06f98c33edea8c227e30dc22a6b3,mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),get_eval_i_by_rotation_idx(6,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0xf24f954496903346d4d753deb0b76c2e26e4dbebf04906842d108dc883cda01,mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),get_eval_i_by_rotation_idx(7,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x28beef43e4fa739fe900a17ead54c004b4182caf07ae3e235c20915be480a9c7,mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),get_eval_i_by_rotation_idx(8,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(9,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x58e9abfdc1bcc9c19f776153af14e0ea64252f5812d36f2dcc1cf6e2ff4c516,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x2d2c9057cafceb967f3fa5e2b7432af2f3a9556b26410784eb48b2a2d4b514f5,mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),get_eval_i_by_rotation_idx(6,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x154e83714c9641589160f3c7a17450390d0fda1f7b8dd86db5ead4b016b263ac,mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),get_eval_i_by_rotation_idx(7,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3f336eacd7e9a3ec67950ed81ef7461a48a08c9e40666a67558e2746a4b57aca,mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),get_eval_i_by_rotation_idx(8,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(10,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0xbea46b09d3a6b990efdbbd4b45182946efe008ab4c7c771babf98c6904a4bbe,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3b26592d8f96997714bcb9eac4c7f39ee808ce0b0e3a8a5a0c0650405ebc2ce6,mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),mulmod(get_eval_i_by_rotation_idx(6,0, x2),get_eval_i_by_rotation_idx(6,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3d57fa111cce837451e082ea541b2d8033e6ed2c6f61740c012db87dc88b3cdd,mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),mulmod(get_eval_i_by_rotation_idx(7,0, x2),get_eval_i_by_rotation_idx(7,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x264f6d16392002e14e4920d243ff44dd9e8cf174e256dd2ff0b96153afd48444,mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),mulmod(get_eval_i_by_rotation_idx(8,0, x2),get_eval_i_by_rotation_idx(8,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(11,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x35ca0f0399ff6d47e0ea2290f4c2e860ba645b3faa1afa78f5ee443f265cb9b,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1d70822e80b8581cfb5ab2c8822851174db06f98c33edea8c227e30dc22a6b3,mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),get_eval_i_by_rotation_idx(9,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0xf24f954496903346d4d753deb0b76c2e26e4dbebf04906842d108dc883cda01,mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),get_eval_i_by_rotation_idx(10,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x28beef43e4fa739fe900a17ead54c004b4182caf07ae3e235c20915be480a9c7,mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),get_eval_i_by_rotation_idx(11,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(12,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x191ec9f5080239d1641f79ae3d3a6ff14c979c4b31496e34fe119ebaa75f879e,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x2d2c9057cafceb967f3fa5e2b7432af2f3a9556b26410784eb48b2a2d4b514f5,mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),get_eval_i_by_rotation_idx(9,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x154e83714c9641589160f3c7a17450390d0fda1f7b8dd86db5ead4b016b263ac,mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),get_eval_i_by_rotation_idx(10,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3f336eacd7e9a3ec67950ed81ef7461a48a08c9e40666a67558e2746a4b57aca,mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),get_eval_i_by_rotation_idx(11,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(13,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0xf2fa77be8b285e2162cb376ddb2e80c686ab94b9059541cb99c3c3333ca842b,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3b26592d8f96997714bcb9eac4c7f39ee808ce0b0e3a8a5a0c0650405ebc2ce6,mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),mulmod(get_eval_i_by_rotation_idx(9,0, x2),get_eval_i_by_rotation_idx(9,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3d57fa111cce837451e082ea541b2d8033e6ed2c6f61740c012db87dc88b3cdd,mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),mulmod(get_eval_i_by_rotation_idx(10,0, x2),get_eval_i_by_rotation_idx(10,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x264f6d16392002e14e4920d243ff44dd9e8cf174e256dd2ff0b96153afd48444,mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),mulmod(get_eval_i_by_rotation_idx(11,0, x2),get_eval_i_by_rotation_idx(11,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(14,0, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x138099074fa7fdc90fda229d9adffb661864d8fcfb34cee6ef8a7a460f53a93d,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1d70822e80b8581cfb5ab2c8822851174db06f98c33edea8c227e30dc22a6b3,mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),get_eval_i_by_rotation_idx(12,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0xf24f954496903346d4d753deb0b76c2e26e4dbebf04906842d108dc883cda01,mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),get_eval_i_by_rotation_idx(13,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x28beef43e4fa739fe900a17ead54c004b4182caf07ae3e235c20915be480a9c7,mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),get_eval_i_by_rotation_idx(14,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(0,1, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x33a3465caf2d23b9c22fa2429691edd3b92ee195b57c9cab530f0c3cb394146e,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x2d2c9057cafceb967f3fa5e2b7432af2f3a9556b26410784eb48b2a2d4b514f5,mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),get_eval_i_by_rotation_idx(12,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x154e83714c9641589160f3c7a17450390d0fda1f7b8dd86db5ead4b016b263ac,mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),get_eval_i_by_rotation_idx(13,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3f336eacd7e9a3ec67950ed81ef7461a48a08c9e40666a67558e2746a4b57aca,mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),get_eval_i_by_rotation_idx(14,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(1,1, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(x1, 0)
            mstore(x1,addmod(mload(x1),0x2b2b28662bc26e4b2f6263d4023ec59b6db980870491769a2a4d2bae9813646f,modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3b26592d8f96997714bcb9eac4c7f39ee808ce0b0e3a8a5a0c0650405ebc2ce6,mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),mulmod(get_eval_i_by_rotation_idx(12,0, x2),get_eval_i_by_rotation_idx(12,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x3d57fa111cce837451e082ea541b2d8033e6ed2c6f61740c012db87dc88b3cdd,mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),mulmod(get_eval_i_by_rotation_idx(13,0, x2),get_eval_i_by_rotation_idx(13,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x264f6d16392002e14e4920d243ff44dd9e8cf174e256dd2ff0b96153afd48444,mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),mulmod(get_eval_i_by_rotation_idx(14,0, x2),get_eval_i_by_rotation_idx(14,0, x2), modulus), modulus), modulus), modulus), modulus), modulus),modulus),modulus))
            mstore(x1,addmod(mload(x1),mulmod(0x1,get_eval_i_by_rotation_idx(2,1, x2),modulus),modulus))
            mstore(add(gate_params, GATE_EVAL_OFFSET),addmod(mload(add(gate_params, GATE_EVAL_OFFSET)),mulmod(mload(x1),theta_acc,modulus),modulus))
            theta_acc := mulmod(theta_acc,mload(add(gate_params, THETA_OFFSET)),modulus)
            mstore(add(gate_params, GATE_EVAL_OFFSET),mulmod(mload(add(gate_params, GATE_EVAL_OFFSET)),get_selector_i(7,mload(add(gate_params, SELECTOR_EVALUATIONS_OFFSET))),modulus))
            gates_evaluation := addmod(gates_evaluation,mload(add(gate_params, GATE_EVAL_OFFSET)),modulus)

        }
    }
}
