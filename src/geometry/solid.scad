include <../constants.scad>
use <../util.scad> 
use <../math/affine.scad>
use <../math/coordinates.scad>
use <plane.scad>

function prismPts(sides, sideLen, height, center=false) = [
    let(poly = xyToXYZ(polygonPts(sides, sideLen)))
    each for(_z = [if (center) [-height/2, height/2] else [0, height]].x)
    translatePts(z=_z, pts=poly)
];
// TODO prismFaces
module prism(sides, sideLen, height, center=false) {
    bottomMin = 0;
    bottomMax = sides - 1;
    topMin = sides;
    topMax = (2*sides) - 1;
    polyhedron(
        points=prismPts(sides, sideLen, height, center),
        faces=[
            range(bottomMin, 1, bottomMax), // bottom
            range(topMax, -1, topMin), // top, negative to be clockwise
            each for (s=[0:1:sides-1]) [ // sides
                let(
                    bottomLeft = s,
                    topLeft = s+sides,
                    tr = topLeft + 1, br = bottomLeft + 1,
                    topRight = [if (tr <= topMax) tr else (tr % sides) + sides].x,
                    bottomRight = [if (br <= bottomMax) br else br % sides].x
                )
                [bottomLeft, topLeft, topRight, bottomRight] 
            ]
        ]
    );
}

function torusPts(minorRad, majorRad, minorSegments=undef, majorSegments=undef) = [
    let(c=xyToXYZ(circlePts(minorRad, $fn=minorSegments)))
    each for(t=angles($fn=majorSegments))
        rotZPts(t,
        pts=translatePts(x=majorRad,
        pts=rotXPts(90,

        pts=c
        )))
];

function torusFaces(minorSegments, majorSegments) =
    let(vertexes=(minorSegments*majorSegments))
    [ each for (major=iter(majorSegments), minor=iter(minorSegments))
        let(
            bottomLeft = minor + major*minorSegments,
            topLeft = ((minor+1) % minorSegments) + major*minorSegments,
            topRight = (topLeft + minorSegments) % vertexes,
            bottomRight = (bottomLeft + minorSegments) % vertexes
        )
        [[bottomLeft, topLeft, topRight], [bottomLeft, topRight, bottomRight]]
        // Since 3pts define a plane, these will always be coplanar.

];

module torus(minorRad, majorRad, minorSegments=undef, majorSegments=undef) {
    _minorSegments = findFN($fn=minorSegments);
    _majorSegments = findFN($fn=majorSegments);

    polyhedron(
        points = torusPts(minorRad, majorRad, _minorSegments, majorSegments),
        faces = torusFaces(_minorSegments, _majorSegments)
    );
}
