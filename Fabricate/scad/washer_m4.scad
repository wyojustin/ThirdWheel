$fn=100;
D = 6.87;
d = 4.5;
h = 2;

difference(){
  cylinder(d=D, h=h, center=true);
  cylinder(d=d, h+100, center=true);
}
