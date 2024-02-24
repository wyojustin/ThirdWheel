inch = 25.4;

pitch = .5 * inch;

module roller(d=.33 * inch){
  h = 6 - 4 * .8;
  color("silver")translate([0, 0, -h/2])difference(){
    cylinder(d=d, h=h, $fn=30);
    translate([0, 0, -1])cylinder(d=3, h=h+2);
  }
}
module chain_piece(){
  difference(){
    linear_extrude(height=.8)import("../svg/link.svg");
    translate([0, 0, -.1])cylinder(h=6.2, d=3, $fn=20);
    translate([pitch, 0, -.1])cylinder(h=6.2, d=3, $fn=20);
  }
}

color = "black";
module link(angle=0, half=-1){
  translate([0, 0, -3]){
    if(color == "silver" && (half==-1 || half==1)) {
      color("black"){
	translate([0, 0, -.1])cylinder(h=6.2, d=3, $fn=20);
	translate([pitch, 0, -.1])cylinder(h=6.2, d=3, $fn=20);
      }
      color("silver"){
	chain_piece();
	translate([0, 0, 6-.8])chain_piece();
      }
      translate([0, 0, 3])roller();
      translate([pitch, 0, 3])roller();
    }
    if(color == "black" && (half==-1 || half==2)) {
      color("grey"){
	translate([pitch, 0, .8])rotate([0, 0, angle])chain_piece();
	translate([pitch, 0, 6-2*.8])rotate([0, 0, angle])chain_piece();
      }
    }
  }
}

module chain_segment(n_link){
  for(i=[0:n_link-1]){
    translate([1 * inch*i, 0, 0])link(0);
  }
}
module chain_arc(n_link, radius, theta){
  for(i=[0:n_link-1]){
    rotate([0, 0, 2 * i * theta])translate([0, -radius, 0])rotate([0, 0, theta/2])link(theta);
  }
}

function pitch_radius(P, N) = P / (2 *sin(180/N)); // Pitch radius (using regular n-gon geometry)
// Pr = P/(2 sin(180/N))
// 180/N = arcsin(P / 2 Pr)
// 180 / arcsin(P / 2 Pr) = N


N = 52;
Rp = pitch_radius(pitch, N);
n_around = 15;
n_straight = 10;

rotate([0, 0, -360/N-7])chain_arc(n_around, Rp, 360/N);
theta = 360 / N;
//rotate([0, 0, 12])import("cogs/cog_20.stl");

translate([Rp * cos(n_around * theta), Rp * sin(theta * n_around), 0])
rotate([0, 0, 200])
translate([0, 0, 0])chain_segment(n_straight-1);
translate([0, -36, 0])
translate([cos(200) * n_straight * pitch*2,
	   sin(200) * n_straight * pitch*2 ,
	   0]) 
translate([Rp * cos(n_around * theta)+12, Rp * sin(theta * n_around)+4, 0])
rotate([0, 0, 160])
translate([-230, 2, 0])chain_segment(n_straight-1);

translate([-250, 0, 0])
rotate([0, 0, 170])
rotate([180, 0, 0])chain_arc(2, pitch_radius(pitch, 9), 360/9);

translate([-48, -93.5, 0])
rotate([0, 0, -20])
link(half=2);
translate([-251, 19, 0])
rotate([0, 0, 20])link(half=1);
