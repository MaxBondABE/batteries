// TODO DRY up when/if first-class functions are released

function _multiplePts(pts) = !is_num(pts.x);

function _xyToXYZ(pt, z=0) = [pt.x, pt.y, z];
function xyToXYZ(pts, z=0) = _multiplePts(pts) ? [ for (pt=pts) _xyToXYZ(pt, z) ] : _xyToXYZ(pts, z);

function _xyzToXY(pt) = [pt.x, pt.y];
function xyzToXY(pts) = _multiplePts(pts) ? [ for (pt=pts) _xyzToXY(pt) ] : _xyzToXY(pts);

function _xyToPolar(pt) = [norm(pt), atan2(pt.y, pt.x)];
function xyToPolar(pts) = _multiplePts(pts) ? [ for (pt=pts) _xyToPolar(pt) ] : _xyToPolar(pts);

function _polarToXY(pt) = let(r=pt.x, p=pt.y) [r*cos(p), r*sin(p)];
function polarToXY(pts) = _multiplePts(pts) ? [ for (pt=pts) _polarToXY(pt) ] : _polarToXY(pts);

function _xyzToSpherical(pt) = let(r=norm(pt)) [r, atan2(pt.y, pt.x), acos(pt.z/r)];
function xyzToSpherical(pts) = _multiplePts(pts) ? [ for (pt=pts) _xyzToSpherical(pt) ] : _xyzToSpherical(pts);

function _sphericalToXYZ(pt) = let(r=pt.x, p=pt.y, t=pt.z) [r*sin(t)*cos(p), r*sin(t)*sin(p), r*cos(t)];
function sphericalToXYZ(pts) = _multiplePts(pts) ? [ for (pt=pts) _sphericalToXYZ(pt) ] : _sphericalToXYZ(pts);

// Homogenous Coordinates for Affine transforms

function _xyzToHmg(xyz) = let(x=xyz.x,y=xyz.y,z=xyz.z) [[x],[y],[z],[1]];
function xyzToHmg(pts) = _multiplePts(pts) ? [ for (pt=pts) _xyzToHmg(pt) ] : _xyzToHmg(pts);

function _hmgToXYZ(hmg) = let(x=hmg.x.x, y=hmg.y.x, z=hmg.z.x) [x,y,z];
function hmgToXYZ(pts) = _multiplePts(pts) ? [ for (pt=pts) _hmgToXYZ(pt) ] : _hmgToXYZ(pts);
