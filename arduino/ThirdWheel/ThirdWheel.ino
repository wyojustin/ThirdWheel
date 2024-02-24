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

const int BUTTON_PIN = 7;
const int HES_PIN = 2;

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

const bool DEPLOYED = true;
const bool RETRACTED = false;
bool gear_state = DEPLOYED;

void timer_interrupt_setup() {
  pinMode(13, OUTPUT);        //Set the pin to be OUTPUT
  cli();                      //stop interrupts for till we make the settings
  /*1. First we reset the control register to amke sure we start with everything disabled.*/
  TCCR1A = 0;                 // Reset entire TCCR1A to 0 
  TCCR1B = 0;                 // Reset entire TCCR1B to 0
 
  /*2. We set the prescalar to the desired value by changing the CS10 CS12 and CS12 bits. */  
  TCCR1B |= B00000100;        //Set CS12 to 1 so we get prescalar 256  
  
  /*3. We enable compare match mode on register A*/
  TIMSK1 |= B00000010;        //Set OCIE1A to 1 so we enable compare match A 
  
  /*4. Set the value of register A to 31250*/
  //OCR1A = 31250;             //Finally we set compare register A to this value  
  //OCR1A = 3125;             //Finally we set compare register A to this value  50ms
  OCR1A = 62;             //Finally we set compare register A to this value  1ms
  sei();                     //Enable back the interrupts
}

void button_setup(){
  pinMode(BUTTON_PIN, INPUT);
  digitalWrite(BUTTON_PIN, HIGH);
}
void motor_setup() {
  pinMode(driverPul, OUTPUT);
  pinMode(driverDir, OUTPUT);
}

const int N_PULSE_INTERVAL = 100;
int pulse_intervals[N_PULSE_INTERVAL];
int pulse_interval_number = 0;

void reset_intervals(){
  for(int i = 0; i < N_PULSE_INTERVAL; i++){
    pulse_intervals[i] = 10000;
  }
}
void hall_effect_sensor_setup(){
  pinMode(HES_PIN, INPUT_PULLUP);
  pinMode(13, OUTPUT);
  reset_intervals();
}
void setup(){
  Serial.begin(115200);
  Serial.println("ThirdWheel.ino");
  button_setup();
  motor_setup();
  timer_interrupt_setup();
  hall_effect_sensor_setup();
}

float analog_state = 0;
bool digital_state = true;
bool state_changed = false;
unsigned long rising_edge = 0;
unsigned long falling_edge = 0;
unsigned long pulse_interval = 0;

int get_pulse_intervals(int n, int* intervals){
  int j = (pulse_interval_number - n) % N_PULSE_INTERVAL;
  for(int i = 0; i < n; i++){
    intervals[i] = pulse_intervals[j++];
    j %= N_PULSE_INTERVAL;
  }
}

ISR(TIMER1_COMPA_vect){
  unsigned long new_rising_edge;
  TCNT1  = 0;                  //First, set the timer back to 0 so it resets for next interrupt
  analog_state = analog_state * .99 + .01 * digitalRead(HES_PIN);
  // apply mild hyseresis between (.45 - .55) to avoid chatter
  if(digital_state == true && analog_state > .55){ // false === pin is high, true === pin is low
    digital_state = false;
    state_changed = true;
    new_rising_edge = millis();
    pulse_interval = new_rising_edge - rising_edge;// AKA gap
    pulse_intervals[pulse_interval_number++] = pulse_interval;
    pulse_interval_number %= N_PULSE_INTERVAL;
    rising_edge = new_rising_edge;
  }
  if(digital_state == false && analog_state < .45){ // false === pin is high, true === pin is low
    digital_state = true;
    state_changed = true;
    falling_edge = millis();
  }
}

void step(int pd_us){
  digitalWrite(driverPul,HIGH);
  delayMicroseconds(pd_us/2);
  digitalWrite(driverPul,LOW);
  delayMicroseconds(pd_us/2);
}


int position = 0;

/*
rotate (signed) count in T_ms milliseconds
 */
void slew(int count, long T_us){// constant jerk (i.e. cubic) movment
  // move 'count' number of steps in 'T_us' microseconds
  // blocks processor until complete
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
  unsigned long delay_us = min_pd;
  unsigned long pp = 0;
  unsigned long tt = 0;
  float k = -6 * count * 1. / (1. * T_us * T_us * T_us);
  float vv;
  digitalWrite(driverDir,direction);
  while (pp < count && tt < T_us){
    pp++;
    tt += delay_us;
    vv = k * tt * tt - k * tt * T_us; // compute velocity
    // vv = k * tt * (tt - T_us); (should be same)
    delay_us = 1. / vv;
    step(delay_us);position += d;
    delay_us = constrain(delay_us, min_pd, max_pd);
  }
  for(int i=0; i < count - pp; i++){
    step(delay_us);position += d;
  }
}


boolean button_state = true;
void button_loop(){
  bool val = !digitalRead(BUTTON_PIN);
  for(int i=0; i < 3 && val; i++){
    val = !digitalRead(BUTTON_PIN); // debounce (on 4x in a row to count as a press)
    delay(1);
  }
  button_state = val;

  // and respond
  if(button_state){
    if(gear_state == RETRACTED){
      deploy_gear();
    }
    else{
      retract_gear();
    }
  }
}

const float D = .740; // meters diameter
const float C = 3.14159 * D; // meters circumference
const int N_MAGNET = 3;
const float METERS_PER_MAGNET = C / N_MAGNET;
const float MILES = 1609.34; //## meters
const float HOUR = 3600; //## seconds
const int MAX_PULSE_INTERVAL = 1577;

void hall_loop(){
  // copy variables that might be chaned in ISR
  unsigned long my_rising_edge = rising_edge;
  unsigned long my_pulse_interval = pulse_interval;
  bool my_digital_state = digital_state;

  unsigned long now = millis();
  float speed;

  int my_intervals[3];
  
  if(my_rising_edge < now &&
     now - my_rising_edge > MAX_PULSE_INTERVAL){
    speed = 0;
    reset_intervals();
    if(gear_state == RETRACTED){
      deploy_gear();
      Serial.print("Gear down!");
      Serial.println(now - my_rising_edge);
    }
  }
  if(state_changed){
    state_changed = false;
    Serial.print("state changed to: ");
    Serial.println(my_digital_state);
    if(my_digital_state == true){ // deal with new rising edge
      if(gear_state == DEPLOYED){
	get_pulse_intervals(3, my_intervals);
	speed = 100 * MILES / HOUR;
	for(int i = 0; i < 3; i++){
	  float s = METERS_PER_MAGNET / (my_intervals[i] / 1000.);
	  Serial.print(s);
	  Serial.print(" ");
	  if(s < speed){
	    speed = s;
	  }
	}
	Serial.println();
	if(speed > 5 * MILES / HOUR){
	  Serial.print("Gear up!");
	  Serial.print(speed);
	  Serial.print(" ");
	  Serial.println(my_pulse_interval);
	  retract_gear();
	}
      }
    }
    else{ // falling edge (nothing to do)
    }
  }
}

int count = 0;
const int N_STEP = 400;
const int MAX_STEP = 401;
const int MIN_STEP = 0;

const long T_MS = 1000000;

void deploy_gear(){
  if(gear_state == RETRACTED){
    slew(N_STEP, T_MS);
    gear_state = DEPLOYED;
  }
}
void retract_gear(){
  if(gear_state == DEPLOYED){
    slew(-N_STEP, T_MS);
    gear_state = RETRACTED;
  }
}

void loop() {
  button_loop();
  hall_loop();
}
