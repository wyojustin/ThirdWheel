use <drive_sprocket.scad>
use <chainring.scad>

inch = 25.4;

module sprocket(){
  import("drive_sprocket_9.stl");
}
module shaft_collar(){
  difference(){
    cylinder(d=17, h=8);
    translate([0, 0, -1])cylinder(d=10, h=10);
  }
}

module stepper(){
  v = .3;
  color([v, v, v])  translate([0, 0, -112/2])cube([56, 56, 112], center=true);
  color("silver")dShaft(10.0, 9.5, 22);
}


module tire(d, t, w){
  color([.7, .7, .7])
  difference(){
    cylinder(d=d, h=w);
    translate([0, 0, -1])cylinder(d=d-2 * t, h=w+2);
  }
}
module wheel(){
  tire(8 * inch, 1 * inch, 1*inch);
  color("white")
  cylinder(h=inch, d=6 * inch);
}

//--------------------------------------------
translate([0, 0, -13])stepper();

sprocket();
color("silver")translate([0, 0, 1])shaft_collar();
color("silver")translate([0, 0, 1-8-2])shaft_collar();

translate([200, 0, 0])chainring();
translate([200, 0, 5])crank();
translate([200 + 170, 0, 100])wheel();
translate([200 + 170, 0, 0])cylinder(r=5* inch/16, h=100);
