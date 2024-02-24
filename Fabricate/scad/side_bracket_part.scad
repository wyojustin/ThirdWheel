inch = 25.4;
rotate([90, -20, 0])
difference(){
  linear_extrude(height=.125 * inch)
    import("../svg/side_bracket_part_v3.svg");
  translate([-22.5+10, 0, -1])
    rotate([0, 0, -20])
    translate([0, 48.5-10, 0])
  linear_extrude(height=1.25 * inch)
    import("../svg/side_bracket_holes.svg");
}
