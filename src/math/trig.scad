include <../constants.scad>

function TSides(T) = T[T_SIDES];
function TAngles(T) = T[T_ANGLES];

function angleFromCosines(a, b, c) = acos((pow(b, 2) + pow(c, 2) - pow(a, 2))/(2*b*c));
// Returns angle opposite side a using sides a, b, c
// Derived from Law of Cosines
function angleFromAngles(A, B) = TRIANGLE_DEGREES - A - B;
// Calculates the third angle in a triangle from two known angles A & B
function isoscelesAngle(t) = (TRIANGLE_DEGREES - t)/2;
function sideFromSines(s, S, t) = s * sin(t) / sin(S);
// Returns side opposite angle t using side s and it's opposite angle S
// Law of Sines
function sideFromCosines(a, c, B) = sqrt(pow(a, 2) + pow(c, 2) - 2*a*c*cos(B));

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
function area(a, b, c) = let(S=semiperimeter(a, b, c)) sqrt(S*(S-a)*(S-b)*(S-c));
function inradius(a, b, c) = area(a, b, c)/semiperimeter(a, b, c);
function circumradius(a, b, c) = (a*b*c)/sqrt((a+b+c) * (a+b-c) * (a+c-b) * (b+c-a));
