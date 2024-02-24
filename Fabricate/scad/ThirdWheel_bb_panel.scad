use <ubolt.scad>;

t = 2;
base_dims = [20.0, 80.0, 94.0];
module bb_panel(){
  translate([0, 0, 0])
    rotate(a=0.00, v=[0.0000, 0.000000, 0.000000])
    color("silver")
    scale(base_dims)import("/home/justin/code/Alex/part_libraries/Main/STL/2080 Alex.stl");
}



module base(){
  rotate([180, 0, 0])rotate([0, 90, 0])translate([-base_dims[0]/2+t, -base_dims[1]/2-t, -t])
    difference(){
    cube([base_dims[0], base_dims[1] + 2 * t, base_dims[2]]);
    translate([-t, t, t])cube(base_dims);
  }
}

module center_punch(){
  translate([0, 0, -.3])cylinder(d1=0, d2=4.3, h=3, $fn=50);
  intersection(){
    cylinder(d1=0, d2=11, h=41, $fn=50);
    cylinder(d=11, h=41, $fn=6);
  }
  translate([0, 0, 41])cylinder(d=11, h=70, $fn=6);
}

hh = 7.6/2;
sep = 54;
holes = [
	 [10, -30, hh],
	 [10, -10, hh],
	 [10,  10, hh],
	 [10,  30, hh],
	 [10+sep, -30, hh],
	 [10+sep, -10, hh],
	 [10+sep,  10, hh],
	 [10+sep,  30, hh],
	 ];
difference(){
  base();
  for(center = holes){
    translate(center)center_punch();
  }
}

ubolt();
//rotate([0, 90, 0])bb_panel();
