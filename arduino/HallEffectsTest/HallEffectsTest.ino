const int HES_PIN = 2;
const float MAX_GAP = 577; // 3 mph with 29" wheels with 3 magnets

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

void setup(){
  Serial.begin(115200);
  Serial.println("HallEffectsTest.ino");
  
  pinMode(HES_PIN, INPUT_PULLUP);
  pinMode(13, OUTPUT);
  timer_interrupt_setup();
}

float analog_state = 0;
bool digital_state = false;
ISR(TIMER1_COMPA_vect){
  TCNT1  = 0;                  //First, set the timer back to 0 so it resets for next interrupt
  analog_state = analog_state * .9 + .1 * digitalRead(HES_PIN);
  // apply mild hyseresis between (.45 - .55) to avoid chatter
  if(digital_state == false && analog_state > .55){ // false=== pin is high, true === pin is low
    digital_state = true;
  }
  if(digital_state == true && analog_state < .45){ // false=== pin is high, true === pin is low
    digital_state = false;
  }
}
unsigned long rising_edge = 0;
unsigned long falling_edge = 0;

const float D = .740; // meters diameter
const float C = 3.14159 * D; // meters circumference
const int N_MAGNET = 3;
const float METERS_PER_MAGNET = C / N_MAGNET;
const float MILES = 1609.34; //## meters
const float HOUR = 3600; //## seconds


bool gear_down = true;

void loop(){
  float speed;
  unsigned long new_rising_edge;
  int gap;
  unsigned long now = millis();
  if(now - rising_edge > MAX_GAP){
    speed = 0;
    if(!gear_down){
      Serial.print("Gear down!");
      Serial.println(now - rising_edge);
      gear_down = true;
    }
  }
  if(analog_state < .5){
    if(digital_state == false){
      new_rising_edge = millis();
      gap = new_rising_edge - rising_edge;
      speed = METERS_PER_MAGNET / (gap/1000.);
      if(gear_down && speed > 5 * MILES / HOUR){
	gear_down = false;
	Serial.println("Gear up!");
      }
      Serial.println(speed / (MILES / HOUR));
      digitalWrite(13, HIGH);
      rising_edge = new_rising_edge;
    }
    digital_state = true;
  }
  else{
    if(digital_state == true){
      digitalWrite(13, LOW);
      falling_edge = millis();
    }
    digital_state = false;
  }
}
