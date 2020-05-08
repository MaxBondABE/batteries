function midpoint(a, b) = a + norm(a, b)/2;

function slope(a, b) = len(a) == 3 ? [a.x - b.x, a.y - b.y, a.z - b.z] : [a.x - b.x, a.y - b.y];
function angleToSlope(t) = tan(t);
function slopeToAngle(m) = atan2(m, 1);
