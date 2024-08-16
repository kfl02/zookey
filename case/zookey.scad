// display top
show_top = true;
// display bottom
show_bottom = true;
// turn on debug cube
debug = true;
debug_x = 0; // [-500:0.1:500]
debug_y = 0; // [-500:0.1:500]
debug_z = 0; // [-500:0.1:500]
debug_dim_x = 10; // [0:0.1:500]
debug_dim_y = 10; // [0:0.1:500]
debug_dim_z = 10; // [0:0.1:500]
// true = intersection, false = difference
debug_intersect = true;

/* Hidden */

wall = 2;

pcb_x = 24;
pcb_y = 30;
pcb_z = 18;

pcb_add = 19;
pcb_floor = 2;
pcb_overhang = 1.4;

module pcb_mount() {
	difference() {
		union() {
			cube([pcb_x + pcb_add * 2, pcb_y + pcb_add * 2, wall]);
			translate([pcb_add - wall, pcb_add - wall, 0])
				cube([pcb_x + 2 * wall, pcb_y + 2 * wall, pcb_floor + 2 * wall]);
		}
		translate([pcb_add, pcb_add, wall])
			cube([pcb_x, pcb_y + wall + 0.1, pcb_floor + wall + 0.1]);
		translate([pcb_add + pcb_overhang, pcb_add - wall - 0.05, 2 * wall])
			cube([pcb_x - pcb_overhang * 2, pcb_y + wall + 0.1, pcb_floor + wall + 0.1]);
	}
}

$fn = 180;

radius1 = 15;
radius2 = 5;
dim_x = 150;
dim_z = 35;
dim_y = pcb_y + 2 * pcb_add + radius2 * 2;
hole_radius = 25 / 2;
x_screw = dim_x / 2 - radius1 + wall;
y_screw = dim_y / 2 - radius1 + wall;

module rim() {
	h_x = dim_x - radius1 * 2 - radius2 * 2;
	h_y = dim_y - radius1 * 2 - radius2 * 2;
	p_x = dim_x / 2 - radius2;
	p_y = dim_y / 2 - radius2;

	rotate([0, 90, 0])
	translate([0, p_y, 0])
	linear_extrude(height = h_x, center = true)
		circle(r = radius2);
	rotate([0, 90, 0])
	translate([0, -p_y, 0])
	linear_extrude(height = h_x, center = true)
		circle(r = radius2);
	rotate([90, 90, 0])
	translate([0, p_x, 0])
	linear_extrude(height = h_y, center = true)
			circle(r = radius2);
	rotate([90, 90, 0])
	translate([0, -p_x, 0])
	linear_extrude(height = h_y, center = true)
			circle(r = radius2);

	translate([h_x / 2, h_y / 2, 0])
	rotate([0,0,0])
	rotate_extrude(angle = 90)
	translate([radius1, 0, 0])
		circle(r = radius2);
	translate([-h_x / 2, h_y / 2, 0])
	rotate([0,0,90])
	rotate_extrude(angle = 90)
	translate([radius1, 0, 0])
		circle(r = radius2);
	translate([-h_x / 2, -h_y / 2, 0])
	rotate([0,0,180])
	rotate_extrude(angle = 90)
	translate([radius1, 0, 0])
		circle(r = radius2);
	translate([h_x / 2, -h_y / 2, 0])
	rotate([0,0,270])
	rotate_extrude(angle = 90)
	translate([radius1, 0, 0])
		circle(r = radius2);
}

module plate() {
	translate([0, 0, radius2])
		difference() {
			hull()
				rim();
			translate([0, 0, 0])
			hull()
			scale([(dim_x - wall * 2) / dim_x, (dim_y - wall * 2) / dim_y, (dim_z - wall * 8) / dim_z])
				rim();
			translate([0, 0, radius2 / 2 + 0.5])
				cube([dim_x + 1, dim_y + 1, radius2 + 1], center = true);

//			translate([x_screw + radius1 / 2 + radius2 / 2, y_screw + radius1 / 2 + radius2 / 2, radius2 / 2])
//			rotate([0, 0, 45])
//#				cube([radius1 * 2, radius1 * 2, radius2], center = true);
		}
}

module box() {
	h_x = dim_x - radius1 * 2 -radius2 - wall * 2;
	h_y = dim_y - radius1 * 2 -radius2 - wall * 2;
	h_z = dim_z - radius2 * 2;
	p_x = dim_x / 2 - wall / 2;
	p_y = dim_y / 2 - wall / 2;
	q_x = p_x - radius1 - radius2 / 2 - wall / 2;
	q_y = p_y - radius1 - radius2 / 2 - wall / 2;

	translate([0, 0, h_z / 2]) {
		translate([p_x, 0, 0])
			cube([wall, h_y, h_z], center = true);
		translate([-p_x, 0, 0])
			cube([wall, h_y, h_z], center = true);
		translate([0, p_y, 0])
			cube([h_x, wall, h_z], center = true);
		translate([0, -p_y, 0])
			cube([h_x, wall, h_z], center = true);
		translate([q_x, q_y, -h_z / 2])
		rotate([0, 0, 0])
		rotate_extrude(angle = 90)
		translate([radius1 + radius2 / 2, 0, 0])
			square([wall, h_z]);
		translate([-q_x, q_y, -h_z / 2])
		rotate([0, 0, 90])
		rotate_extrude(angle = 90)
		translate([radius1 + radius2 / 2, 0, 0])
			square([wall, h_z]);
		translate([-q_x, -q_y, -h_z / 2])
		rotate([0, 0, 180])
		rotate_extrude(angle = 90)
		translate([radius1 + radius2 / 2, 0, 0])
			square([wall, h_z]);
		translate([q_x, -q_y, -h_z / 2])
		rotate([0, 0, 270])
		rotate_extrude(angle = 90)
		translate([radius1 + radius2 / 2, 0, 0])
			square([wall, h_z]);
	}
}

module lower() {
	plate();
}

module upper() {
	translate([0, 0, radius2])
	rotate([180, 0, 0])
	difference() {
		union() {
			translate([0, 0, radius2])
			rotate([0, 180, 0])
				lower();
			translate([0, (dim_y -radius2 - 36) / 2, wall])
				cylinder(h = 3, r = hole_radius * 1.2);
			translate([40, (dim_y -radius2 - 36) / 2, wall])
				cylinder(h = 3, r = hole_radius * 1.2);
			translate([-40, (dim_y -radius2 - 36) / 2, wall])
				cylinder(h = 3, r = hole_radius * 1.2);
		}
		translate([0, (dim_y -radius2 - 36) / 2, 0])
			cylinder(h = 12, r = hole_radius);
		translate([40, (dim_y -radius2 - 36) / 2, 0])
			cylinder(h = 12, r = hole_radius);
		translate([-40, (dim_y -radius2 - 36) / 2, 0])
			cylinder(h = 12, r = hole_radius);
	}
}

nut_dim = 6.8;
nut_height = 8;
screw_dim = 3.3;
screw_head_dim = 5.5;

module nut_holder() {
	d = radius2 * 2.36;

	difference() {
		hull() {
			cylinder(d = radius2 * 2, h = radius2 * 2, center = true, $fn = 30);
			translate([radius2 / 2, -d / 2, 0])
				cube([radius2, d, radius2 * 2], center = true);
			translate([-d / 2, radius2 / 2, -0])
				cube([d, radius2, radius2 * 2], center = true);
			translate([radius2 / 2, -d + wall / 4, radius2])
				cube([radius2, wall / 2, radius2 * 4], center = true);
			translate([-d + wall / 4, radius2 / 2, radius2])
				cube([wall / 2, radius2, radius2 * 4], center = true);
		}
		cylinder(d = screw_dim, h = 17, center = true, $fn = 30);
		// translate([0, 0, -0.6])
		// 	cylinder(d = nut_dim, h = 2.8, center = true, $fn = 6);

		rotate([0, 90, 60])
		translate([0.6, 0, 3])
			cube([2.8, 6, 13.5], center = true);
	}
}

module top() {
	difference() {
		union() {
			upper();
			translate([0, 0, radius2])
				box();
			translate([0, 0, dim_z - radius2 * 2])
			rotate([180, 0, 0]) {
				translate([-x_screw, -y_screw, 0])
					nut_holder();
				translate([-x_screw, y_screw, 0])
					rotate([0,0, 270])
						nut_holder();
				translate([x_screw, y_screw, 0])
					rotate([0,0, 180])
						nut_holder();
				translate([x_screw, -y_screw, 0])
					rotate([0,0, 90])
						nut_holder();
			}
		}
		translate([dim_x / 2, 0, - (dim_z - radius2 * 2) / 2 + 2])
		rotate([0, 90, 0]) {
			cylinder(d = 4, h = 10, center = true);
			translate([2.6, 0, 0])
				cube([4, 4, 10], center = true);
		}
	}
}

module screw_stencil() {
	cylinder(d = radius2 * 2, h = radius2, center = true, $fn = 30);
}

module screw_stencils() {
	translate([0, 0, radius2 / 2]) 
	scale([1, 1, 1.1]) {
		translate([-x_screw, -y_screw, 0])
			screw_stencil();
		translate([-x_screw, y_screw, 0])
			screw_stencil();
		translate([x_screw, y_screw, 0])
			screw_stencil();
		translate([x_screw, -y_screw, 0])
			screw_stencil();
	}
}

module screw_hole() {
	difference() {
		screw_stencil();
		cylinder(d = screw_dim, h = radius2 + 0.4, center = true, $fn = 30);
		translate([0, 0, -radius2 / 2 + wall / 2 - 0.001])
			cylinder(d1 = screw_head_dim, d2 = screw_dim, h = wall + 0.2, center = true, $fn = 30);
	}
}

module screw_holes() {
	translate([0, 0, radius2 / 2]) {
		translate([-x_screw, -y_screw, 0])
			screw_hole();
		translate([-x_screw, y_screw, 0])
			screw_hole();
		translate([x_screw, y_screw, 0])
			screw_hole();
		translate([x_screw, -y_screw, 0])
			screw_hole();
	}
}

module bottom() {
	difference() {
		lower();
		screw_stencils();
	}
	screw_holes();
	translate([-(pcb_x + pcb_add * 2) / 2, -(pcb_y + pcb_add * 2) / 2, 0])
		pcb_mount();

	o_x = dim_x / 2 - wall / 2 - wall;
	o_y = dim_y / 2 - wall / 2 - wall;
	d_x = dim_x - radius1 * 2 - radius2 - wall * 4;
	d_y = dim_y - radius1 * 2 - radius2 - wall * 4;

	translate([0, o_y, 2 * wall])
	difference() {
		cube([d_x, wall * 0.87, wall * 3], center = true);
		cube([wall * 2.1, wall * 2.1, wall * 3.1], center = true);
	}
	translate([0, -o_y, 2 * wall])
	difference() {
		cube([d_x, wall * 0.87, wall * 3], center = true);
		cube([wall * 2.1, wall * 2.1, wall * 3.1], center = true);
	}
	translate([o_x, 0, 2 * wall])
	difference() {
		cube([wall * 0.87, d_y, wall * 3], center = true);
		cube([wall * 2.1, wall * 2.1, wall * 3.1], center = true);
	}
	translate([-o_x, 0, 2 * wall])
	difference() {
		cube([wall * 0.87, d_y, wall * 3], center = true);
		cube([wall * 2.1, wall * 2.1, wall * 3.1], center = true);
	}
}

module debug_box() {
#	translate([debug_x, debug_y, debug_z])
		cube([debug_dim_x, debug_dim_y, debug_dim_z], center = true);
}

module show() {
	if(show_top)
		top();
	if(show_bottom)
		translate([0, 80, 0])
			bottom();
}

if(debug) {
	if(debug_intersect) {
			intersection() {
				show();
				debug_box();
			}
		} else {
			difference() {
				show();
				debug_box();
			}
		}
} else {
	show();
}

