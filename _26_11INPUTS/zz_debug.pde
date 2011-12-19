void printRaw()
{
  int x = analogRead(IR_PIN);
  int y = analogRead(RF_PIN);
  int z = analogRead(PIR_PIN);
  Serial.print("ir: ");
  Serial.print(x);
  Serial.print('\t');
  Serial.print("rf: ");
  Serial.print(y);
  Serial.print('\t');
  Serial.print("pir: ");
  Serial.println(z);
  delay(200);
}


void printRF(){
  int y = analogRead(RF_PIN);
  Serial.println(y);
}

void testMsg(){
  String msg = "LN";
  Serial.print(msg);
  Serial1.print(msg);
  Serial2.print(msg);
  Serial3.print(msg);
}

