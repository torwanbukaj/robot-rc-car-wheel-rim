// Robot / RC car wheel rim
// by torwanbukaj @ June 9th, 2022
//
// Description:
// This is customizable robot / RC car wheel rim project.
// This is how to work with it:
// 1. Take measurements of a tire you have.
// 2. Modify below "variables" in the "Tire and rim dimensions" section accordingly. If you do not understand the variable names, consult provided PDF manual.
// 3. Render the final shape (F6), generate STL file (F7), slice it with a slicer of your selection and just print :)
//
// I recommend to tighten a little bit measured "rim_sitting_width" (by 1 or 2mm) so the tire will sit more tightly. 

// -----------------------------------
// Number of fragments used to render a circle (100 should give you pretty "roundy" shape.
$fn=100;

// Tire and rim dimensions
tire_inner_dia = 50;         // outer diameter of the rim (without collars)
rim_sitting_width = 21;      // width of the rim (without collars)
rim_collar_height = 2;
rim_collar_width = 1.6; 
rim_thickness = 3;
rim_mounting_wall_thickness = 3;
center_hole_dia = 10;
mounting_screw_dia = 3.2;
mounting_screw_distance = 8; // from rim center along radius
rim_wall_how_deep = 5;       // 0 means flat with the outer collar wall
holes_spacing_factor = 1.5;  // determines distance between circular cut-offs
arm_width_factor = 0.3;      // 0.4 = 40% of holes_cuts_dia
arm_height_factor = 0.9;     // 0.9 = 90% of available space
add_arms = true;             // "true" adds arms, "false" removes them
add_hole_cuts = true;

// --------------------------------------
// Supporting "variables" - do not change
rim_sit_width_w_collar = rim_sitting_width + 2 * rim_collar_width;
rim_dia_w_collar = tire_inner_dia + (2 * rim_collar_height);
holes_min_circle = 2 * mounting_screw_distance + mounting_screw_dia + 4;
holes_max_circle = tire_inner_dia - rim_mounting_wall_thickness - 4;
holes_circles_diff = holes_max_circle - holes_min_circle;
holes_center_circle_r = (holes_min_circle + holes_circles_diff / 2) / 2;
holes_cuts_dia = holes_circles_diff / 2;

// Calculate max number of holes
center_circle_circumference = 2 * PI * holes_center_circle_r;
num_of_holes = floor(center_circle_circumference / (holes_cuts_dia * holes_spacing_factor));


// For arms
arm_r = tire_inner_dia / 2 - rim_thickness - holes_min_circle  / 2;
arm_height = arm_height_factor * (rim_sit_width_w_collar - rim_wall_how_deep - rim_mounting_wall_thickness);


// --------------------------------------
// PRINT STL FILES -> F5 (preview) + F6 (render) + F7 (save as STL)
// Uncomment one of the "print_..." functions for generating STL file

print_rim();

// --------------------------------------
// Presentation functions

module print_rim() {
    rotate([180, 0, 0]) rim();
}

// --------------------------------------
// All drawing functions below - do not touch unless you know what you do

module rim() {
    // rim base
    difference() {
    cylinder(d = tire_inner_dia, h = rim_sitting_width, center = true);
    cylinder(d = tire_inner_dia - 2 * rim_thickness, h = rim_sitting_width+0.01, center = true);
    }
    // rim collars
    translate([0, 0, rim_sitting_width/2+rim_collar_width/2]) rim_collar();
    translate([0, 0, -(rim_sitting_width/2+rim_collar_width/2)]) rim_collar();
  
    // mounting wall
    translate([0, 0, (rim_sit_width_w_collar / 2) - (rim_mounting_wall_thickness / 2) - rim_wall_how_deep ]) rim_mounting_wall();

    // arms
    if (add_arms==true) {
        for (i = [1:num_of_holes]) {
        rotate(a = 180 + (360/num_of_holes)/2 + (i * 360/num_of_holes), v = [0,0,1])
        translate([-(tire_inner_dia / 2 - rim_thickness), 0, (rim_sit_width_w_collar / 2) - rim_wall_how_deep - rim_mounting_wall_thickness]) arm();
        }
    }
}
module rim_collar() {
    difference() {
    cylinder(d = rim_dia_w_collar, h = rim_collar_width, center = true);
    cylinder(d = rim_dia_w_collar - 2 * rim_collar_height - 2* rim_thickness, h = rim_collar_width+0.001, center = true);
    }
}

module rim_mounting_wall() {
    difference() {
        cylinder(d = tire_inner_dia - rim_thickness, h = rim_mounting_wall_thickness, center = true);
        cylinder(d = center_hole_dia, h = rim_mounting_wall_thickness+0.01, center = true);
            
        // axis / motor mouting holes
        for (i = [0:3]) {
        rotate(a = 0 + (i * 90), v = [0,0,1])
            translate([mounting_screw_distance, 0, 0]) cylinder(d = mounting_screw_dia, h = rim_mounting_wall_thickness+0.001, center = true);
        }
        // circular material cut-outs
        if (add_arms == true) {
            for (i = [0:num_of_holes-1]) {
            rotate(a = 0 + (i * 360/num_of_holes), v = [0,0,1])
                translate([holes_center_circle_r, 0, 0]) cylinder(d = holes_cuts_dia, h = rim_mounting_wall_thickness+0.001, center = true);
            echo(i * 360/num_of_holes);    
            }
        }
    }
}

module arm() {
    rotate([-90, 0, 0]) linear_extrude(arm_width_factor * holes_cuts_dia, center = true) {
    polygon(points=[[0,0], [arm_r, 0], [0, arm_height]]);
    }
}
