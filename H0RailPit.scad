$fn = 32;
length = 50;
width  = 35;


rail_width = 17.3;

bias=0.001;

stand_distance = 10;

yn = floor((length - 6) / stand_distance);

pitt = true;

difference() {
    union() {
        stands();
        board();
        if (pitt) translate([0,0,-5.5/2- 2.5]) cube([10.3+.7*2, 30+.7*2, 5.5], true);
    }
    rails();
    if (!pitt) cylinder(d=3, h=100, center=true);
    echo((yn % 2 == 0));
    for(a=[0, 180]) rotate(a) {
        translate([rail_width/2, (yn % 2 == 0) ? stand_distance / 2 : 0, -1.5]) {
            cube([7, 2, 2], true);
        }
    }
    if (pitt) for (z=[0:1.2:8]) {
        cube([10.3,30 - z * 2,z * 2 + .8], true);
    }
}

module board() {
    rotate(90, [1, 0, 0]) linear_extrude(length, center=true) {
        union() {
            difference() {
                translate([0, -3+0.7/2]) square([width,0.7], true);
                m = (rail_width - 7 - 0.5) / 3;
                for(x=[-1.5*m:m:1.5*m]) translate([x, -3 + 0.5/2 + 0.5]) {
                    square(0.5, true);
                }
                for(xs=[-1,1]) for(x=[(rail_width + 7 + 0.5) / 2: m: width /2]) {
                    translate([x*xs,-3 + 0.5/2 + 0.5]) {
                        square(0.5, true);
                    }
                }
                
            }
            
            l = rail_width / 2;
            for(x=[-l,l]) translate([x, 0]) {
                hull() {
                    translate([0, -2]) square([6, 1], true);
                    translate([0, -2.5]) square([7, 1], true);
                }
            }
        }
    }
    
    translate([0,0, -3+0.5/2])cube([width, length, 0.5], true);
}

module stands() {
    
    for (yi = [-yn / 2: yn/2], y = yi* stand_distance) {
        l = rail_width / 2;
        for(x=[-l,l]) translate([x, y]) {
            stand();
        }
    }
}

module stand() {
    translate([0,0,-1.55]) cube([5,5, .6], true);
    rotate(90, [1, 0,0])linear_extrude(4, center = true) {
        union() {
            hull() {
                translate([0,-1/2]) square([2,1], true);
                translate([0,-1/2 -.8]) square([4,1], true);
            }
        }
    }
}

module rails() {
    rotate(90, [1, 0, 0]) {
        linear_extrude(length + bias, center = true) {
            l = rail_width / 2;
            for(x=[-l,l]) translate([x, 0]) {
                rail_2d();
            }
        }
    }
}

module rail_2d() {
    square([.85,3], true);
    hull() {
        translate([0, -1.5 + .6 / 2])square([2.4,.6], true);
        translate([0, -1.0 + .5 / 2])square([  1,.5], true);
    }
}