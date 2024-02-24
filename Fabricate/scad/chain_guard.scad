use <drive_sprocket.scad>
use <chain.scad>

inch = 25.4;
Dr = .35 * inch; // roller diameter
T = 2;            // thickness of cog // sram 11 speed

P = 0.5*inch;
r_cog = pitch_radius(P, 9);
r_ring = pitch_radius(P, 53);
echo(r_cog, r_ring);
echo(r_cog * 2, r_ring * 2);

//cog(9, P, Dr, T);
module hub(){
  color("grey")import("../stl/cog_09.stl");
  translate([0, 0, T/2])color("silver")cylinder(d=17, h=13);
}

module chain(){
  theta = 360/53;
  nn = (53-20)/2;
  translate([223, -107+r_cog, 0])
    mirror([1, 0, 0])rotate([0, 0, 180])
    chain_arc(nn, r_ring, 360/53);
  translate([-7,r_cog, 0])
    chain_segment(9);
  translate([157, -173, 0])rotate([0, 0, -43.5])mirror([-1, 0, 0])
    chain_segment(9);
  rotate([0, 0, 165])chain_arc(2, r_cog, 360/9);
}
//projection(cut=false)chain();
//chain();

nema_r = 47/2;
z_offset = -9.7;
module nema_holes(){
  h = 100;
  for(i=[-1,1]){
    for(j=[-1,1]){
      translate([nema_r * i, nema_r * j, z_offset])
	cylinder(d=5.5, h=h, $fn=30);
    }
  }
}

// start guard
thickness = 2;
module top_guard(){
  difference(){
    //nema_holes();
  }
  //import("../svg/chain_centerline.svg");
  module keepout(){
    linear_extrude(11, center=true)import("../svg/chain_outer.svg");
  }
  difference(){
    union(){
      minkowski(){
	keepout();
	sphere(r=thickness, $fn=20);
      }
      translate([0, 0, -6.5])cube([56, 56, thickness],center=true);
    }
    keepout();
    //cylinder(r=r_ring, h=100, center=true);
    translate([223, -88.5, 0])cylinder(r=200, h=100, $fn=360,center=true);
    cylinder(d=25, h=100);
    translate([0, 0, -100])cylinder(d=r_cog+30, h=100);
    translate([nema_r, -nema_r, 0])
      cylinder(d=5.5, h=100, $fn=30, center=true);
    translate([nema_r, -nema_r, -100])
      cylinder(d=14, h=100, $fn=30, center=false);
    translate([nema_r, nema_r, -100])
      cylinder(d=14, h=100, $fn=30, center=false);
    nema_holes();
    translate([50, 0, -5])cube([100, 25, 12], center=true);
  }
}

module wedge(r, h, angle, center=false) {
    poly = concat([[0, 0]], [for (t = [0:angle]) r * [cos(t), sin(t)]]);
    intersection() {
      cylinder(r = r, h = h, center=center);
        linear_extrude(h, center=center) polygon(poly);
    }
}
module ring(R, r, t, fn=30){
  difference(){
    cylinder(r=R, h=t, $fn=fn, center=true);
    cylinder(r=r, h=t+2, $fn=fn, center=true);
  }
}
module bottom_guard(){
  ang = atan2(offset[1], offset[0]) + 180;
  arc = 120;
  intersection(){
    translate(offset)
      rotate([0, 0, ang-arc/2])
      wedge(300, 100, arc, center=true);
    difference(){
      translate([223, -88.5, 0])
	minkowski(){
	cylinder(r=r_ring+8, h=11, $fn=53, center=true);
	sphere(r=thickness, $fn=20);
      }
      translate([223, -88.5, 0])
	cylinder(r=r_ring-10, h=100, $fn=53, center=true);
      translate([223, -88.5, -50])
	cylinder(r=r_ring, h=100, $fn=53, center=true);
      translate([223, -88.5, 0])
	cylinder(r=r_ring + 8, h=11, center=true);
      translate([180, r_cog, -thickness])cube([100, 12, 12], center=true);
      rotate([0, 0, -43])translate([180, -r_cog, -thickness])
	cube([100, 12, 12], center=true);
    }
  }

  difference(){
    intersection(){
      union(){
	translate([0, 0, -34])translate(offset)difference()
	  ring(135, 107, 2, fn=360);
	translate([0, 0, -20])translate(offset)difference()
	  ring(117, 107, 27, fn=360);
      }
      color("green")translate(offset)rotate([0, 0, 140])
	wedge(300, 100, 55, center=true);
    }
    intersection(){
      translate(offset)ring(130, 124, 100, fn=360);
      translate(offset)rotate([0, 0, 145])
	wedge(300, 100, 45, center=true);
    }      
  }
}

offset = [223, -88.5, 10];
color("red")translate(offset)ring(125, 221/2-26, thickness);
color("red")translate([224, -88.5, 0])ring(80, 50, thickness);
translate([223, -88.5, 4])rotate_extrude(angle=360){
  translate([80, 0, 0])rotate([0, 0, -30])circle(r=6, $fn=3);
}

top_guard();
//color("blue")bottom_guard();
//chain();
hub();

