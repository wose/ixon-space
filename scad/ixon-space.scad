H = 1;
L = 0;
step = 1;

$fn=360/step;

ring_height = 10.75;
ring_inner_r = 12.4;
ring_outer_r = 14.5;
bayonet_inner_r = 11.0;

R = ring_inner_r;

module bayonet() {
    rotate([90, 0, 0])
        for (i=[0:step:360])
        {
          radian = R*PI/180;
          rotate([0, i, 0])   translate([0,0,R-H/2])
          intersection()
          {
            translate([L-i*radian, 0, 0])
            linear_extrude(height = H, center = true, convexity = 4)
            {
                 polygon(points=[[0,0],[5,0],[5,5], [18, 9.0], [18, 10.75], [11, 10.75], [0,5]]);
            }
            cube([radian*step, 100, H+1], center = true);
          }
        }
}

module wing() {
    intersection() {
        linear_extrude(height= ring_height, center = false, convexity = 4, twist= 10)
        {
            translate([ring_outer_r+1.5, 0, 0])
                circle(5.5, $fn=3);
        }
        translate([ring_outer_r-2, 0, 0])
            cylinder(h= 12, r= 7, center=false);
    }
}

module clamp_hook() {
    translate([ring_inner_r, 0, 4.175])
    union() {
        translate([-2.15, 1.7, 0])
            cylinder(h= 2, r= 0.3, center=true);
        difference() {
            translate([-2.25, -2.0, -1])
                cube(size=[4.0, 4, 2], center=false);
            translate([-2.5, -1, 0])
                rotate([0, 0, 25])
                    cube(size=[3, 5, 3], center=true);
        }
    }
}

module clamp() {
    union() {
        ext_angle = 60;
        rotate_extrude(angle = ext_angle, convexity = 10)
            translate([ring_outer_r - 2.5, 1.75, 0.0])
                square([5.0, 0.5],  false);
        rotate([-3, 0, -5])
            rotate_extrude(angle = ext_angle, convexity = 10)
                translate([ring_outer_r - 2.5, 6.1, 0.0])
                    square([5.0, 0.5],  false);
        rotate([0, 0, ext_angle])
            rotate_extrude(angle = -5, convexity = 10)
                translate([ring_outer_r - 2.5, 1.75, 0.0])
                    square([5.0, 4.25],  false);
    }
}

union() {
    // inner bayonet
    for (i=[1:3])  {
        rotate([0, 0, i*360/3])
            bayonet();
    }

    // base cylinder
    difference() {
        cylinder(h = ring_height, r = ring_outer_r);
        translate([0, 0, 1.5])
            cylinder(h = ring_height, r = ring_inner_r);
        cylinder(h = 4, r =  8.75, center = true);
        for(i=[1:3]) {
            rotate([0, 0, -30 + i * 360/3])
                clamp();
        }
    }

    for (i=[1:3]) {
        rotate([0, 0, -55 + i * 360/3])
            rotate([-3, 0, 0])
                union() {
                    rotate_extrude(angle = 75, convexity = 10)
                        translate([ring_outer_r-0.5, 3.75, 0.0])
                            square([1.5, 1.5],  false);
                    rotate([0, 0, 60])
                        translate([ring_outer_r - 0.5, 3.75, 3.75])
                            cylinder(h=1.5, r=1, center=false);
                }
    }

    // fittings
    for(i=[1:3]) {
        rotate([0, 0, -95 + i*360/3])
            rotate_extrude(angle = 40, convexity = 10)
                translate([ring_outer_r-1.7, -0.75, 0])
                    square([0.8, 0.9], center=false);
    }

    // clamp_hook
    for(i=[1:3]) {
        rotate([0, 0, 15 + i * 360 / 3])
            clamp_hook();
    }
    
    // wings
    intersection() {
        for(i=[1:3]) {
            rotate([0, 0, 60 + i * 360 / 3])
                wing();
        }

        translate([0, 0, -15.5])
            sphere(r=30);
        translate([0, 0,  26.5])
            sphere(r=30);
    }
}