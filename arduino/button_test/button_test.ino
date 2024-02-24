void setup(){
  Serial.begin(115200);
  Serial.println("button_test.ino on pin 7");
  pinMode(7, INPUT);
  digitalWrite(7, HIGH);
}

bool readButton(){
  return digitalRead(7);
}

boolean state = true;
void loop(){
  boolean new_state = readButton();
  if(new_state != state){
    Serial.println(new_state);
    state = new_state;
  }
}
