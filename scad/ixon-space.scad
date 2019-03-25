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
        scale([1.5, 2, 1])
            sphere(1.25);
}

module clamp() {
    union() {
        ext_angle = 60;
        rotate_extrude(angle = ext_angle, convexity = 10)
            translate([ring_outer_r - 2.5, 1.75, 0.0])
                square([5.0, 1.0],  false);
        rotate_extrude(angle = ext_angle, convexity = 10)
            translate([ring_outer_r - 2.5, 5.5, 0.0])
                square([5.0, 1.0],  false);
        rotate([0, 0, ext_angle])
            rotate_extrude(angle = -5, convexity = 10)
                translate([ring_outer_r - 2.5, 2.5, 0.0])
                    square([5.0, 3.75],  false);
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
        translate([0, 0, 1])
            cylinder(h = ring_height, r = ring_inner_r);
        cylinder(h = 3, r =  8.75, center = true);
        for(i=[1:3]) {
            rotate([0, 0, -30 + i * 360/3])
                clamp();
        }
    }

    // fittings
    for(i=[1:3]) {
        rotate([0, 0, -95 + i*360/3])
            rotate_extrude(angle = 40, convexity = 10)
                translate([ring_outer_r-1.2, -0.75, 0])
                    square([0.8, 0.9], center=false);
    }

    // clamp_hook
    for(i=[1:3]) {
        rotate([0, 0, 15 + i * 360 / 3])
            clamp_hook();
    }
    
    // wings
    for(i=[1:3]) {
        rotate([0, 0, 60 + i * 360 / 3])
            wing();
    }
}