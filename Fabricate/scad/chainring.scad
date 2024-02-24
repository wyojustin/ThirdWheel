use<drive_sprocket.scad>
inch = 25.4;
N = 39;

Dr = .35 * inch; // roller diameter
P = 0.5 * inch;   // chain pitch
R = pitch_radius(P, N);
T = 2;

theta = 360 / N;
difference(){
  cylinder(r=R, h=T, center=true);
  cylinder(r=60, h=T + 2, center=true);
  //cylinder(d=10, h=T + 2, center=true);
  for(i=[1:N]){
    rotate([0, 0, theta * i])
      translate([R, 0, 0])
      cylinder(d=Dr, h=T + 2, center=true);
  }
  /*
  for(i=[1:5]){
    rotate([0, 0, i * 72])
      translate([60, 0, 0])cylinder(d=60, h=T+2, center=true);
      }
  */
  for(i=[1:5]){
    rotate([0, 0, i * 72 + 36])
      translate([67, 0, 0])cylinder(d=10, h=T+2, center=true);
  }
}

