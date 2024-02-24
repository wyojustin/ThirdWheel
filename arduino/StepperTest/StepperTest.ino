/*

*/
int driverPul = 8;
int driverDir = 9;

int pd = 50;
boolean setdir = HIGH;
  
void setup() {
  pinMode(driverPul, OUTPUT);
  pinMode(driverDir, OUTPUT);
    
}

int count = 0;
void loop() {
  digitalWrite(driverDir,setdir);
  digitalWrite(driverPul,HIGH);
  delayMicroseconds(pd);
  digitalWrite(driverPul,LOW);
  delayMicroseconds(pd);
}
