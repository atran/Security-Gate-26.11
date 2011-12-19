#include <NewSoftSerial.h>
#include <MsTimer2.h>

////////////////////////relay globals
#define RELAY_PIN 12
char reader[2];
int low_delay = 500;
int high_delay = 1000;
int full_input = -1;
volatile int counter = 0;
boolean isSolid = false;

NewSoftSerial arduino(8,9); //rx/tx


void setup(){
  pinMode(RELAY_PIN, OUTPUT);
  Serial.begin(9600); // open serial
  arduino.begin(9600);
  pinMode(13, OUTPUT);
  MsTimer2::set(low_delay, servTimer2Interrupt_a); // 500ms period
  MsTimer2::start();
}

void loop()
{
  char header = arduino.read();
  if (header == 'L'){
    Serial.println(header);
    digitalWrite(13, HIGH);
    delay(2);
    char cmd = arduino.read();
    Serial.println(cmd);
    if (cmd == 'S')
    {
      isSolid = true;
      relay_solid();
    }
    else if (cmd == 'R' && !isSolid) 
    {
      relay_rf();
      isSolid = false;
    }
    else if (cmd == 'N')
    {
      relay_nu();
      isSolid = false;
    }
  }
  digitalWrite(13,LOW);
}






