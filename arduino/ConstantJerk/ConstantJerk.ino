/*
Motor dirver hookup 
(left to right)
MOTOR:BLUE RED GREEN BLACK ---> driver
Vdc --> +48V
GND --> GND

DIP_SWITCH: UUUDDDDD

ENA-  +5V
ENA+  +5V
DIR-  GND
DIR+  Ardino PIN8
PUL-  GND
PUL+  Arduino PIN9
  
*/

int big_ring = 53;
int small_ring = 9;
int steps_per_rev = 200;

int teeth = big_ring / 4 + 1;
int steps_per_tooth = steps_per_rev / small_ring;
int steps = teeth * steps_per_tooth;
  
int driverPul = 8;
int driverDir = 9;

int pd = 50;
boolean setdir = LOW;

void button_setup(){
  pinMode(7, INPUT);
  digitalWrite(7, HIGH);
}
void motor_setup() {
  pinMode(driverPul, OUTPUT);
  pinMode(driverDir, OUTPUT);
}
void setup(){
  Serial.begin(115200);
  Serial.println("ThirdWheel.ino");
  button_setup();
  motor_setup();
}

void step(int pd_us){
  digitalWrite(driverPul,HIGH);
  delayMicroseconds(pd_us/2);
  digitalWrite(driverPul,LOW);
  delayMicroseconds(pd_us/2);
}


/*
rotate at max accel/decel to count
 */
int position = 1;

void slew(int count, long T){// constant jerk (i.e. cubic) movment
  // do count steps in T microseconds
  boolean direction;
  int d; // +1 and -1 for direction
  if(count < 0){
    d = -1;
    direction = LOW;
    count = abs(count);
  }
  else{
    d = 1;
    direction = HIGH;
  }

  unsigned long min_pd = 100;
  unsigned long max_pd = 10000;
  unsigned long delay = min_pd;
  unsigned long pp = 0;
  unsigned long tt = 0;
  float k = -6 * count * 1. / (1. * T * T * T);
  float vv;
  digitalWrite(driverDir,direction);
  while (pp < count && tt < T){
    pp++;
    tt += delay;
    vv = k * tt * tt - k * tt * T; // compute velocity
    // vv = k * tt * (tt - T); (should be same)
    delay = 1. / vv;
    step(delay);position += d;
    delay = constrain(delay, min_pd, max_pd);
  }
  for(int i=0; i < count - pp; i++){
    step(delay);position += d;
  }
}


boolean button_state = true;
void button_loop(){
  bool val = !digitalRead(7);
  for(int i=0; i < 3 && val; i++){
    val = !digitalRead(7); // debounce
    delay(5);
  }
  button_state = val;
}

int count = 0;

void loop() {
  steps = 400;
  long T = 1000000;
  button_loop();
  if(button_state){
    Serial.println(position);
    if(position <= 0){
      slew(steps, T);
    }
    else{
      slew(-steps, T);
    }
    Serial.println(position);
  }
}
