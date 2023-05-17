// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "../../src/gost3410/intModInverse.sol";

contract intModInverseTest is Test {
    using uintModInverse for uint;

    function test_bgcd_1() external {
        assertEq(uintModInverse.bgcd(11, 35), 1);
    }

    function test_bgcd_2() external {
        assertEq(
            uintModInverse.bgcd(
                6322610860491544216932366519095,
                177213750118348710766018615863777
            ),
            180646024585472691912353329117
        );
    }

    function test_ext_bgcd() external {
        (int a, int b, int v) = uintModInverse.ext_bgcd(693, 609);
        assertEq(a, -181);
        assertEq(b, 206);
        assertEq(v, 21);
    }

    function test_ext_bgcd_v2() external {
        (uint v, uint a, bool isAPos, uint b, bool isBPos) = uintModInverse
            .ext_bgcd_v2(693, 609);
        assertEq(a, 181);
        assertFalse(isAPos);
        assertEq(b, 206);
        assertTrue(isBPos);
        assertEq(v, 21);
    }

    function test_modinv() external {
        assertEq(uint(23).modinv(97), 38);
        assertEq(uint(23).modinv(99), 56);
        assertEq(uint(11).modinv(35), 16);
        assertEq(uint(38).modinv(93), 71);
    }

    function test_modulo_operation() external {
        assertEq(uintModInverse.modulo_v2(145, true, 51), 43);
        assertEq(uintModInverse.modulo_v2(145, false, 51), 8);
    }
}
