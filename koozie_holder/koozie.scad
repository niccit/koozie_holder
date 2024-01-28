// A customizable Koosie holder with keyhole mounting slots
// Text can be added to one or both sides or not configured
// Default size is 102mm/4" long, 100/4" wide, 240mm/9.7" high

$fa = 1;
$fs = 0.4;

default_font="Roboto:style=Bold";
default_font_size=24;
default_font_direction="ltr";
default_font_spacing=1;
default_holder_height=240;
default_holder_width=100;
default_holder_length=102;

// To change direction of text use ltr = left to right, btt = bottom to top, ttb = top to bottom, rtt = right to left
module add_text(text="TEST", font=default_font, size=default_font_size, height=6, direction=default_font_direction, spacing=default_font_spacing) {
        linear_extrude(height = height) {
            text(text, font=font, size=size, direction="ttb", spacing=spacing, halign="center", valign="center");
        }
}

// Keyhole mounting slots for hanging
module mounting_hole() {
    rotate([90, 0, 0])
        cylinder(r=4.25, h=11);
    translate([0, -5, 7])
        rotate([90, 0, 0])
            minkowski() {
                cube([2, 6, 10], center=true);
                cylinder(1);   
                }
  }
        

module holder(length=default_holder_length, width=default_holder_width, height=default_holder_height, use_text=false, both_sides=false, font=default_font, font_size=default_font_size, text="TEST", direction=default_font_direction, spacing=default_font_spacing, keyhole_slot=false) {
    wall_thickness=10;
    outer_length=length + wall_thickness;
    outer_width=width + wall_thickness;
    outer_height=height + wall_thickness;
    dispenser_height = 22;
    slot_height=(height - 1);
    font_height=(wall_thickness - 5);

    difference() {
        // frame
        cube([outer_length, outer_width, outer_height], center=true);
        translate([0, 2, 6])
            cube([length, width, height], center=true);

        // center slot
       translate([0, outer_width / 2, (outer_height / 2) - (height / 2) + (dispenser_height / 2)])
           cube([70, 6, slot_height], center=true);

        // dispensing slot
        translate([0, outer_width / 2, -(outer_height / 2) + dispenser_height])
            cube([length, wall_thickness, dispenser_height], center = true);

        // keyhole slots for hanging on wall
        if (keyhole_slot == true) {
            // top
            translate([0, -(width / 2) + 5, (height / 2) - (length / 2) + (dispenser_height)])
                mounting_hole();
            // bottom
            translate([0, -(width / 2) + 5, -(height / 2) + (length / 2) - (dispenser_height)])
                mounting_hole();
        }

        // Customize with text
        if (use_text == true) {
           translate([(outer_length / 2) - 4, 0, (outer_height / 2) - (height / 2)])
                rotate([90, 0, 90])
                    add_text(text=text, size=font_size, direction=direction, spacing=spacing, height=font_height, font=font);
            if (both_sides == true) {
                translate([(-outer_length / 2) + 4, 0, (outer_height / 2) - (height / 2)])
                    rotate([90, 0, 270])
                        add_text(text=text, size=font_size, direction=direction, spacing=spacing, height=font_height, font=font);
            }
        }
       
    }
      

    // Rear top lip
    translate([0, (-(width / 2) + 5) - 0.001, (outer_height / 2) - 1.5])
        cube([(length - (3*2)), 10, 3], center=true);
    // Right top lip
    translate([(-(length / 2) + 7) - 0.001, 2, (outer_height / 2) - 1.5])
        cube([18, width, 3], center=true);
    // Left top lip
    translate([((length / 2) - 7) - 0.001, 2, (outer_height / 2) - 1.5])
        cube([18, width, 3], center=true);

}

holder(use_text=true, text="JAXKUZI", both_sides=true, direction="ttb", spacing=0.95,  font_size=24, keyhole_slot=true);
