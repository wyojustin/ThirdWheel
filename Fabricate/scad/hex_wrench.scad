d = 16;

r = sqrt(4 ^ 2 + 8 ^ 2);
  
color("red")translate([0, 0, d/2])cylinder(r=r, h=3.4, $fn=6);
difference(){
  cylinder(r=r*3, h=d/2);
  translate([0, 0, -1])
  for(theta=[0:60:360]){
     translate(3.25 * r * [cos(theta), sin(theta), 0]) cylinder(r=r, h=d + 2, $fn=20);
  }
}
