include <constants.scad>

// Helper function for iterating over a full rotation, a very common operation
// in OpenSCAD. Uses comprehension, rather than ranges, because of floating point
// rounding issues.
// See https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#Ranges
function angles(start=0, end=ROTATION) = let($fa=findFA()) [for (t=start; t<end; t=t+$fa) t];

// Helper functions to allow your caller (or their ancestor caller) to specify
// angular precision using any of the methods available in OpenSCAD.
// TODO implement support for $fs
function findFA() = [if (is_undef($fn) || $fn < 3) $fa else ROTATION / $fn].x;
function findFN() = [if (!is_undef($fn) && $fn >= 3) $fn else ROTATION / $fa].x;

// Convinience functions for working with OpenSCAD ranges
function iter(end, start=0, increment=1) = [start:increment:end-increment];
function range(start, increment, end) = [for (i=[start:increment:end]) i];
// FIXME come up with better names

function defaultValue(v, default) = is_undef(v) ? default : v;

// Helper for debugging functions that return vectors (eg torusPts())
module plot(pts) {
    for(pt=pts)
    translate(pt) color("black") sphere(0.1);
}

module mirrorCopy(v) {
    children();
    mirror(v) children();
}

module rotateCopy(t) {
    for(i=angles($fa=t)) rotate(i) children();
}

module translateX(x) {translate([x, 0]) children(); }
module translateY(y) {translate([0, y]) children(); }
module translateZ(z) {translate([0, 0, z]) children(); }

function randint(min, max, rand) = round(rand*(max-min)) + min;
