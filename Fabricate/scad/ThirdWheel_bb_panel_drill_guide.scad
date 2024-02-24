use<ubolt.scad>;
t = 2;
base_dims = [20.0, 80.0, 95.0];
module alex(l){
  color("silver")
    scale([20, 80, l])import("/home/justin/code/Alex/part_libraries/Main/STL/2080 Alex.stl");
}

module bb_panel(){
  alex(base_dims[2]);
}



module base(){
  rotate([180, 0, 0])rotate([0, 90, 0])translate([-base_dims[0]/2+t, -base_dims[1]/2-t, -t])
    difference(){
    cube([base_dims[0], base_dims[1] + 2 * t, base_dims[2] + t]);
    translate([-t, t, t])cube([base_dims[0], base_dims[1], base_dims[2] + 1]);
  }
}
module center_punch_old(){
  translate([0, 0, -.3])cylinder(d1=0, d2=4.3, h=3, $fn=50);
  intersection(){
    cylinder(d1=0, d2=11, h=41, $fn=50);
    cylinder(d=11, h=41, $fn=6);
  }
  translate([0, 0, 41])cylinder(d=11, h=70, $fn=6);
}
module center_punch(d){
translate([0, 0, 5])cylinder(d1=d, d2=d, h=5, $fn=30);
}

hh = 7.6/2;
sep = 54;
d = 6; 
D = 40 + 6;
H = 90;
holes = [
	 [10, -30, hh],
	 //[10, -10, hh],
	 //[10,  10, hh],
	 [10,  30, hh],
	 [10+sep, -30, hh],
	 //[10+sep, -10, hh],
	 //[10+sep,  10, hh],
	 [10+sep,  30, hh],
	 [base_dims[2]-10, D/2, hh],
	 [base_dims[2]-10, -D/2, hh],
	 [base_dims[2]-5-60, D/2, hh],
	 [base_dims[2]-5-60, -D/2, hh]
	 ];
difference(){
  base();
  for(center = holes){
    #translate(center)center_punch(5);
  }
  #translate([0, 0, -5])cube([200, 200, 20], center=true);
}
//rotate([0, 90, 0])bb_panel();
//#translate([base_dims[2]-10, 0, D])rotate([0, 0, 90])ubolt(D, H, d);
//#translate([base_dims[2]-10-60, 0, D])rotate([0, 0, 90])ubolt(D, H, d);
//translate([10, 0, 10])alex(100);
//rotate([0, 90, 0])alex(base_dims[2]);
