// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Test.sol";
import "../../src/gost3410/intModInverse.sol";

contract intModInverseTest is Test {
    using uintModInverse for uint;

    function test_ext_bgcd_1() external {
        (uint v, uint a) = uintModInverse.ext_bgcd(609, 693);
        assertEq(a, 173);
        // assertTrue(isAPos);
        // assertEq(b, 206);
        // assertTrue(isBPos);
        assertEq(v, 21);
    }

    function test_modinv_case_1() external {
        uint x = uintModInverse.modinv(
            0xffff030700000000ffffffffffffff030000000000f8ffffffff0300c0ffffff,
            0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141
        );

        assertEq(
            x,
            0xe06f56d8558f81fddbd19d1d68aee4415a7184142d76b9dd8368e243b2fcdaa8
        );
    }

    function test_modinv() external {
        assertEq(uint(23).modinv(97), 38);
        assertEq(uint(23).modinv(99), 56);
        assertEq(uint(11).modinv(35), 16);
        assertEq(uint(38).modinv(93), 71);
    }

    function test_addmod() external {
        uint a = 0xffff030700000000ffffffffffffff030000000000f8ffffffff0300c0ffffff;
        uint b = 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141;
        assertEq(addmod(a, b, b), a);
    }

    function test_half_mod() external {
        uint256 m = 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141;

        uint256 a = 75313263260372118731839045140086074368609092721610431952916918272182169528832;

        uint256 expected = 37656631630186059365919522570043037184304546360805215976458459136091084764416;

        a >>= 1;
        a %= m;
        assertEq(a, expected);
    }

    function test_add_half_mod() external {
        uint256 m = 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141;
        uint u = 83708101695996040773037510185625196353029773574196578422353318136102080164379;
        uint expected = 99750095466656118098304247597156552102933668926635741402479240638810120829358;
        uint res = addmod(u >> 1, m >> 1, m) + 1; // + 1 because both values are odd

        assertEq(res, expected);
    }

    function test_sub_mod_pos() external {
        uint256 m = 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141;
        uint256 u = 82758633207846904525693592903585777003797553896272955065549324246553315365664;
        uint256 v = 29312517105362078603095942119863526380153986412488894394134626179902126151432;
        uint expected = 53446116102484825922597650783722250623643567483784060671414698066651189214232;
        uint res = (u - v) % m;
        assertEq(res, expected);
    }

    function test_sub_mod_neg() external {
        uint256 m = 0xFFFFFFFF_FFFFFFFF_FFFFFFFF_FFFFFFFE_BAAEDCE6_AF48A03B_BFD25E8C_D0364141;
        uint256 u = 45488092400473077854092192326585030216327243241538941051816679109547003781512;
        uint256 v = 65612738249535451346280450948421901410383956162624235651761151512915805419226;
        uint expected = 95667443388253821931382726386851036658780851357989609782660690738149359856623;
        uint res = addmod(u, ~v, m);

        if (u > v) {
            // just for reference
            assert(false);
        } else {
            uint d = v - u;
            assertEq(
                d,
                20124645849062373492188258621836871194056712921085294599944472403368801637714
            );
            uint rem = d % m;
            res = m - d;
        }
        assertEq(res, expected);
    }
}
