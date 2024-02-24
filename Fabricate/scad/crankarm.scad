r_nut = 67;

dims = [35, 16, 170];

r_edge = 7;

module arm(){
translate([0, 0, dims[2]/2])
  minkowski(){
    cube([dims[0] - 2 * r_edge,
	  dims[1] - 2 * r_edge,
	  dims[2] - 2], center=true); 
    cylinder(r=r_edge, h=1, $fn=30);
  }
  translate([0, 0, dims[2]])minkowski(){
    rotate([90, 0, 0])
      cylinder(d=dims[0] - 2 * r_edge, h=dims[1] - 2 * r_edge, center=true);
    sphere(r=r_edge, $fn=30);
  }
}

module assembly(){
  translate([0, 0, 17])
    rotate([-90, 0, 0])
    arm();

  difference(){
    union(){
      cylinder(r=r_nut+7, h=5);
      cylinder(r1=50, r2=14, h=25);
    }
    rotate([0, 0, 54])linear_extrude(height=100, center=true)
      import("../svg/crank_spider_holes.svg");
  }

}
difference(){
  assembly();
  cylinder(d=22, h=100, center=true);
  translate([0, dims[2], 0])cylinder(d=13, h=100, center=true);
  for(i=[72:72:360]){
    rotate([0, 0, i + 36])
    translate([0, r_nut, 0])cylinder(d=10, h=100, center=true);
  }
  translate([0, 0, -10])cylinder(r1=50, r2=14, h=25);

}
