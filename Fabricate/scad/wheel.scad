inch = 25.4;

module bottom_bracket(){
  color("gray")translate([0, 125, 7*inch])rotate([90,0,0])cylinder(d=1.5*inch, h=73.5, center=true);
}
rotate([0, 0, 0])union(){
  scale([10/8, 10/8, 2./2.4])rotate([0, 90, 0])import("../stl/RUBBER_TREAD_WHEELS_ASM.stl");
  //color("red")rotate([0, 0, 0])cylinder(d=10*inch, h=2*inch,center=true);
  //cylinder(d=8*inch, h=1.5*inch, center=true);
  //color("red")translate([0, 0, 2.5 * inch])rotate([0, 90, 0])import("../stl/threaded_9_16_rod.stl");
  //translate([0, 0, -3*inch])cylinder(d=9/16 *inch, h=6 * inch);
  //color("blue")translate([0, 0, -3.5 * inch])rotate([90, 0, 0])import("../stl/threaded_9_16_nut.stl");
  //color("blue")translate([0, 0, -(1.75 + 31/64) * inch])rotate([90, 0, 0])import("../stl/threaded_9_16_nut.stl");
  //color("blue")translate([0, 0, -1.75 * inch])rotate([90, 0, 0])import("../stl/threaded_9_16_nut.stl");
  //color("blue")translate([0, 0, 1.16 * inch])rotate([90, 0, 0])import("../stl/threaded_9_16_nut.stl");
  //color("blue")translate([0, 0, (1.16 + 31/64) * inch])rotate([90, 0, 30])import("../stl/threaded_9_16_nut.stl");
  
  //color("silver")translate([-35/2, -0, -75])cube([35, 7 * inch, 20]);
}
//translate([0, 80, 140])rotate([0, 0, -30])color("blue")translate([0, 0, (1.16 + 31/64) * inch])rotate([90, 0, 30])
//import("../stl/chainring_53.stl");
//color("blue")translate([0, 0, -10])cylinder(r=110, h=1);


//bottom_bracket();
//color("red")translate([0, 100, 177])rotate([90, -20, 0])import("../stl/UBolt.stl");
//color("red")translate([0, 160, 177])rotate([90, -20, 0])import("../stl/UBolt.stl");
