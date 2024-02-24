$fn=360;
d = 38.2;
D = 44;

h = 76;
H = 10;
module bottom_bracket(){
  cylinder(d2=D, d1=D-2, h=H);
  translate([0, 0, H])cylinder(d=d, h=h);
  translate([0, 0, h + H])cylinder(d1=D, d2=D-2, h=H);
  translate([0, 0, H + h + H])import("../stl/bb_washer.stl");
}
module mount(){
  thickness = 8;
  difference(){
    union(){
      translate([0, d/4 + thickness/2, h/2])cube([d + 2 * thickness, d/2 + thickness, h], center=true);
      cylinder(d=d + 2 * thickness, h=h);
      translate([0, d/2+10, h/2])cube([80, 2 * thickness, h], center=true);
    }
    union(){
      translate([0, 0, -1])cylinder(d=d, h=h+2);
    }
  }
}
translate([0, 0, H])
mount();

