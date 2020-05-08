use <coordinates.scad>

// Matrix Definitions

function affineMtx(
    xScale=1, yScale=1, zScale=1,
    xyShear=0, xzShear=0,
    yxShear=0, yzShear=0,
    zxShear=0, zyShear=0,
    xTx=0, yTx=0, zTx=0) = [
        [xScale, xyShear, xzShear, xTx],
        [yxShear, yScale, yzShear, yTx],
        [zxShear, zyShear, zScale, zTx],
        [0,0,0, 1]
];

function rotXMtx(t) = affineMtx(
    yScale=cos(t), yzShear=-sin(t),
    zyShear=sin(t), zScale=cos(t)
);
function rotYMtx(t) = affineMtx(
    xScale=cos(t), xzShear=sin(t),
    zxShear=-sin(t), zScale=cos(t)
);
function rotZMtx(t) = affineMtx(
    xScale=cos(t), xyShear=-sin(t),
    yxShear=sin(t), yScale=cos(t)
);

function translateMtx(x=0, y=0, z=0) = affineMtx(xTx=x, yTx=y, zTx=z);
function scaleMtx(x=1, y=1, z=1) = affineMtx(xScale=x, yScale=y, zScale=z);

// Applying Transformations

function affineTransform(mtx, pts) = hmgToXYZ([for (pt=xyzToHmg(pts)) mtx*pt]);

function rotXPts(t, pts) = affineTransform(rotXMtx(t), pts);
function rotYPts(t, pts) = affineTransform(rotYMtx(t), pts);
function rotZPts(t, pts) = affineTransform(rotZMtx(t), pts);
function rotatePts(x=0, y=0, z=0, pts) = affineTransform(rotXMtx(z) * rotYMtx(y) * rotXMtx(x), pts);

function translatePts(x=0,y=0,z=0, pts) = affineTransform(translateMtx(x,y,z), pts);

function scalePts(s=1, pts, x=undef, y=undef, z=undef) =
    let(
        x = defaultValue(x, s),
        y = defaultValue(y, s),
        z = defaultValue(z, s)
    ) affineTransform(scaleMtx(x,y,z), pts);

