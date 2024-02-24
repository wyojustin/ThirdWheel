inch = 25.4;
pitch = .5 * inch;

function pitch_radius(P, N) = P / (2 *sin(180/N));
N = 53;
n = 9;
w = 9;
D = pitch_radius(pitch, N)*2;
d = pitch_radius(pitch, n)*2;
separation = 250;
rotate([0, 0, 180])
hull(){
  cylinder(d=D, h=w);
  translate([separation, 0, 0])cylinder(d=d, h=w);
}
