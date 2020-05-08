include <../constants.scad>

// Throughout this file, a capital letter (A) is used for an angle and a lower
// case letter (a) is used for a side length. The same letter is opposite it's
// corresponding side or angle, eg 'A' is the angle opposite side 'a'.

function TSides(T) = T[T_SIDES];
function TAngles(T) = T[T_ANGLES];

// Trig helpers
// These functions help make your intention & the derivation of your math
// more apparent.

// Returns angle opposite side a using sides a, b, c
// Derived from Law of Cosines
function angleFromCosines(a, b, c) = acos((pow(b, 2) + pow(c, 2) - pow(a, 2))/(2*b*c));

// Calculates the third angle in a triangle from two known angles A & B
function angleFromAngles(A, B) = TRIANGLE_DEGREES - A - B;

function isoscelesAngle(t) = (TRIANGLE_DEGREES - t)/2;

// Returns side opposite angle t using side s and it's opposite angle S
// Derived from Law of Sines
function sideFromSines(s, S, t) = s * sin(t) / sin(S);

function sideFromCosines(a, c, B) = sqrt(pow(a, 2) + pow(c, 2) - 2*a*c*cos(B));

// Helpers for solving triangles
function SSS(a, b, c) =
    let(
        A = angleFromCosines(a, b, c),
        B = angleFromCosines(b, c, a),
        C = angleFromAngles(A, B)
    )
    [[a, b, c], [A,B,C]];

function ASA(A, c, B) = 
    let(
        C = angleFromAngles(A, B),
        a = sideFromSines(c, C, A),
        b = sideFromSines(c, C, B)
    )
    [[a, b, c], [A,B,C]];

function AAS(C, B, c) = 
    let(
        A = angleFromAngles(C, B),
        a = sideFromSines(c, C, A),
        b = sideFromSines(c, C, B)
    )
    [[a, b, c], [A,B,C]];

function SAS(a, B, c) =
    let(
        b = sideFromCosines(a, c, B),
        A = angleFromCosines(a, b, c),
        C = angleFromAngles(A, B)
    )
    [[a, b, c], [A,B,C]];

function RHS(s, h) =
    let(
        a = s,
        b = h,

        B = 90,
        c = sqrt(pow(b, 2) - pow(a, 2)),
        C = atan2(c, a),
        A = angleFromAngles(B, C)
    )
    [[a, b, c], [A,B,C]];

function semiperimeter(a, b, c) = (a+b+c)/2;

// Heron's formula for the area of a triangle
function area(a, b, c) = let(S=semiperimeter(a, b, c)) sqrt(S*(S-a)*(S-b)*(S-c));

// Triangle Centers
// There are thousands of ways to define the center of a triangle.
// The intention is to include the common & useful ones.

function inradius(a, b, c) = area(a, b, c)/semiperimeter(a, b, c);

function circumradius(a, b, c) = (a*b*c)/sqrt((a+b+c) * (a+b-c) * (a+c-b) * (b+c-a));
