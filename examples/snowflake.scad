include <../src/constants.scad>
use <../src/geometry/plane.scad>
use <../src/util.scad>

module branch(depth, aspectRatio=6, width=10, angle=60, seed=0, d=0) {
    random = rands(0,1,2,seed);

    if(d < depth) {
        branch(depth, aspectRatio, width, angle, seed, d+1)

        mirrorCopy([0,1])
        rotate(angle)
        union() {
            a = d/depth;
            w = a*width;
            h = w*aspectRatio;
            isoTriangle(w, h);

            translateX(h/2)
            children();
        }
    }
    else children();

}

module arm(radius, maxBranches=2, branchDepth=3, aspectRatio=6, angle=60, seed=0) {
    random = rands(0,1, maxBranches + 1,seed);
    branches = randint(1, maxBranches, random[0]);

    width = radius/aspectRatio;
    isoTriangle(width, radius);
    for (i=iter(branches)) {
        secondarySeed = random[1+i];
        proportion = randint(1, 9, random[1+i])/10;
        distance = randint(1, radius, random[1+1]);
        translateX(distance);
        branch(branchDepth, aspectRatio, width*proportion, angle, secondarySeed);
    }
}

module snowflake(radius, branches=2, branchDepth=3, branches=3, aspectRatio=6, angle=60, seed=0) {
    rotateCopy(angle) arm(radius, branches, branchDepth, aspectRatio, angle, seed);
}

snowflake(100, branches=5);
//branch(4, seed=1);
