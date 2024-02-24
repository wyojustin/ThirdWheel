inch = 25.4;

l = 19;
w = 15;
h = 3;
sep = (12.8 + 7.8)/2;
d = (12.8 - 7.8)/2;




module pin(){
  rotate([0, 0, 45])cylinder(d=inch/20, h=5, $fn=4);
  translate([0, 0, 4.5])rotate([0, -90, 0])rotate([0, 0, 45])cylinder(d=inch/20, h=5, $fn=4);
}

module led(){
  color("red")cube([2, 1, 1], center=true);
}

module assembly(){
  translate([l/2, 0, 1])rotate([0, 90, 0])scale([.5, 1, 1])cylinder(d1=10, d2=7, h=10, $fn=30);
  difference(){
    cube([l, w, h], center=true);
    //translate([7, sep/2, -5])cylinder(d=d, h=10, $fn=30);
    //translate([7, -sep/2, -5])cylinder(d=d, h=10, $fn=30);
  }
  translate([-8, -.1 * inch, 0])pin();
  translate([-8,   0 * inch, 0])pin();
  translate([-8, +.1 * inch, 0])pin();
  
  translate([2, 5, 1])led();
}

difference(){
  translate([0, 0, 15])cube([10, 20, 30], center=true);
  translate([0, 0, 5])rotate([0, -90, 0])
    assembly();
}
#translate([0, 0, 7])rotate([0, -90, 0])assembly();
