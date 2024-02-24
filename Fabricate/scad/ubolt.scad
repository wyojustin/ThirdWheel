inch = 25.4;

d = 6;
D = 40 + 6;
H = 90;

module alex_2080(h){
  color("silver")scale([20, 80, h])import("/home/justin/code/Alex/part_libraries/Main/STL/2080 Alex.stl");
}

module ubolt(D, H, d){
  hh = H - d/2 - D/2;
  color("silver"){
    rotate([90, 0, 0])rotate_extrude(angle=180, $fa=1){
      translate([D/2, 0, 0])circle(d=d+1, $fn=180);
    }

    translate([D/2, 0, -hh])cylinder(d=6+1, h=hh, $fn=180);
    translate([-D/2, 0, -hh])cylinder(d=6+1, h=hh, $fn=180);
  }
}

module bb(){
  black = .2;
  hh = 12.8-2-2.4;
  
  rotate([90, 0, 0]){
    color("silver")cylinder(d=38, h=74, center=true, $fn=180);
    
    color([black, black, black])translate([0, 0, -74/2-10])cylinder(d=44, h=10-2, $fn=180);
    color([black, black, black])translate([0, 0, -74/2-2])cylinder(d2=38, d1=44, h=2, $fn=180);

    color([black, black, black])translate([0, 0, 74/2])cylinder(d=40, h=2.4, $fn=180);
    color([black, black, black])translate([0, 0, 74/2+2.4])cylinder(d1=40, d2=44, h=2, $fn=180);
    color([black, black, black])translate([0, 0, 74/2+2 + 2.4])cylinder(d=44, h=hh, $fn=180);
  }
}


module negative_space(){
  bb();
  translate([0, 0, -2]){
    translate([0, 30, 0])ubolt(D, H, d);
    translate([0, -30, 0])ubolt(D, H, d);
    translate([0, 0, -44]){
      color("silver")rotate([0, 90, 90])translate([-10, 0, -94/2+10])alex_2080(94);
      //translate([0, 0, (20+inch/2)/2])color([.1, .1, .1])cube([80, 74, inch/2], center=true);
    }
  }
}
module positive_space(){
  rotate([90, 0, 0])cylinder(d=46, h=12, $fn=50, center=true);
  translate([0, -0, -25/2])cube([56, 12, 25],center=true);
}

module block(){
  difference(){
    translate([0, 30, 0])positive_space();
    negative_space();
    //translate([0, 0, -500])cube(1000);
    translate([-500, 0, 0])cube(1000);
  }
}
//negative_space();
block();
/*
translate([0, -60, 0])block();

translate([0, 74/2+10, 0])rotate([-90, 0, 0]){
  color("purple")import("/home/justin/code/ThirdWheel/Fabricate/stl/bb_washer.stl");
  color([.2, .2, .2])translate([0, 0, 12])cylinder(d=22, h=4);
}
			  
//alex_2080(100);

*/
