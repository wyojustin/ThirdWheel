
hole_d = 16;
d2 = 23;
d1 = 28;
h = 7;
H = 2 * h;

difference(){
  cylinder(d1=d1, d2=d2, h=H);
  translate([0, 0, -1]){
    cylinder(d=hole_d, h=H+2);
    cylinder(d1=d2, d2=d2, h=h+2);
  }
  
}
