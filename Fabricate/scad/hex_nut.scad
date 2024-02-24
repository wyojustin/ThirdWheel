D = 21.6;
d = 11.72;
H = 11.27;

D = 11.15;
d = 6;
H = 5;

difference(){
  cylinder(d=D, h=H, $fn=6, center=true);
  cylinder(d=d, h=100, center=true, $fn=30);
}
