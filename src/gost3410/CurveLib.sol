// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./intModInverse.sol";

library CurveLib {
    using intModInverse for int;
    using intModInverse for uint;

    struct Curve {
        uint p; // Characteristic of the underlying prime field
        uint q; // Elliptic curve subgroup order
        // Equation coefficients of the elliptic curve in canonical form
        uint a;
        uint b;
        // // Equation coefficients of the elliptic curve in twisted Edwards form
        // int e;
        // int d;
        // Basic point X and Y coordinates
        uint x;
        uint y;
        uint cofactor;
    }

    function newCurve(
        uint p,
        uint q,
        uint a,
        uint b,
        uint x,
        uint y,
        // int e,
        // int d,
        uint cofactor
    ) internal pure returns (Curve memory) {
        Curve memory curve = Curve({
            p: p,
            q: q,
            a: a,
            b: b,
            // e: e,
            // d: d,
            x: x,
            y: y,
            cofactor: cofactor
        });

        require(contains(curve, x, y), "Invalid curve parameters");

        return curve;
    }

    function contains(
        Curve memory curve,
        uint x,
        uint y
    ) internal pure returns (bool) {
        uint r1 = (y * y) % curve.p;
        uint r2 = ((x * x + curve.a) * x + curve.b) % curve.p;
        return r1 == pos(curve, r2);
    }

    /**
     * Make positive number
     */
    function pos(Curve memory curve, uint v) internal pure returns (uint) {
        if (v < 0) {
            return v + curve.p;
        } else {
            return v;
        }
    }

    function _add(
        Curve memory curve,
        uint p1x,
        uint p1y,
        uint p2x,
        uint p2y
    ) internal pure returns (uint, uint) {
        uint t;
        uint tx_;
        uint ty;
        if (p1x == p2x && p1y == p2y) {
            // double
            t =
                ((uint(3) * p1x * p1x + curve.a) *
                    intModInverse.modinv(uint(2) * p1y, curve.p)) %
                curve.p;
        } else {
            tx_ = pos(curve, p2x - p1x) % curve.p;
            ty = pos(curve, p2y - p1y) % curve.p;
            t = (ty * intModInverse.modinv(tx_, curve.p)) % curve.p;
        }
        tx_ = pos(curve, t * t - p1x - p2x) % curve.p;
        ty = pos(curve, t * (p1x - tx_) - p1y) % curve.p;
        return (tx_, ty);
    }

    function exp(
        Curve memory curve,
        int degree,
        int x,
        int y
    ) internal pure returns (int, int) {
        x = x != 0 ? x : curve.x;
        y = y != 0 ? y : curve.y;
        int tx_ = x;
        int ty = y;

        require(degree != 0, "Bad degree value");

        while (degree != 0) {
            if (degree & 1 == 1) {
                (tx_, ty) = _add(curve, tx_, ty, x, y);
            }
            degree = degree >> 1;
            (x, y) = _add(curve, x, y, x, y);
        }
        return (tx_, ty);
    }
}
