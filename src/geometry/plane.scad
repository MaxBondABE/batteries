include <../constants.scad>
use <../util.scad>
use <../math/trig.scad>
use <../math/coordinates.scad>

function circlePts(rad) = [
    for(t=angles())
    rad*[cos(t), sin(t)]
];

module batteriesCircle(rad) { polygon(circlePts(rad)); }

function ellipsePts(width, height) = [for(t=angles()) 1/2 * [w*cos(t), h*sin(t)]];

module ellipse(width, height) { polygon(ellipsePts(width, height)); }

function polygonPts(sides, sideLen) = // TODO sideLen or rad
    let(t=findFA($fn=sides))
    circlePts(
        rad=sideFromSines(sideLen, t, isoscelesAngle(t)),
        $fa=t
);

module regularPolygon(sides, sideLen) { polygon(polygonPts(sides, sideLen)); }

// Triangles

function rightTrianglePts(a, b) = [
    ORIGIN_2D,
    [0, a],
    [b, 0],
];

module rightTriangle(a, b) { polygon(rightTrianglePts(a, b)); }

function isoTrianglePts(base, height) = [
    [0, base/2],
    [height, 0],
    [0, -base/2]
]; // TODO center

module isoTriangle(base, height) { polygon(isoTrianglePts(base, height)); }

function triangleFromSASPts(a, B, c) = 
    let(
        T=SAS(a, B, c),
        a=TSides(T).x, b=TSides(T).y, c=TSides(T).z,
        A=TAngles(T).x, B=TAngles(T).y, C=TAngles(T).z,
       
        polarA = 0,
        polarB = angleFromAngles(B/2, A/2),
        w = angleFromAngles(B/2, C/2),
        polarC = polarB + w,

        radA = sideFromSines(c, polarB, B/2),
        radB = sideFromSines(c, polarB, A/2),
        radC = sideFromSines(a, w, B/2)
    )
    // Derived by breaking the triangle ABC into triangles
    // AIB and BIC, where I is the inradius & the origin, and solving
    // for the angles & sides to construct polar coordinates
polarToXY([
    [radA, polarA],
    [radB, polarB],
    [radC, polarC]
    
]);

module triangleFromSAS(a, B, c) { polygon(triangleFromSASPts(a, B, c)); }
