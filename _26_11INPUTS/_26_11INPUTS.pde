///**/TODO:
//tosendPIR needs to only send to audios
//rf thresh



////////////////////HARDWARE globals
#define RF_PIN 15
#define PIR_PIN 14
#define IR_PIN 13

#define RF_THRESH 155
#define IR_THRESH 50
#define PIR_THRESH 300


////ir smoothing
int distRead;

/////////////////globals
int ir, pir, rf;
boolean isSolid, isClose, isDetected;
float rfval;
String p_msg, PIR_p_msg;

void setup()
{
  Serial.begin(9600);
  Serial1.begin(9600);
  Serial2.begin(9600);
  Serial3.begin(9600);
}
void loop()
{ 
  ////////////////////DEBUGZ
//  testMsg();
//   printRaw();
  /////////////////////////

  getSensors();
  filterSensors();
  sendLState();
//  sendXState();
}

void getSensors(){
  ir = getAvg(IR_PIN, 25);
  pir = getAvg(PIR_PIN, 50);
  rf = getAvg(RF_PIN,30);
  Serial.print("ir: ");
  Serial.print(ir);
  Serial.print('\t');
  Serial.print("rf: ");
  Serial.print(rf);
  Serial.print('\t');
  Serial.print("pir: ");
  Serial.println(pir);
  delay(100);
}
void filterSensors(){
  isSolid = ir > IR_THRESH ? 1 : 0;
  isClose = pir > PIR_THRESH ? 1 : 0;
  isDetected = rf > RF_THRESH ? 1 : 0;
}
void sendLState(){
  if (isSolid){
    toSend("LS");
  }
  else if (isDetected){
    toSend("LR", rf);
  }
  else {
    toSend("LN");
  }
}

void sendXState(){
  ///////ONLY SEND TO AUDIO!
  if (isClose){
    toSendPIR("XO");
  } 
  else if (!isClose) {
    toSendPIR("XF");
  }
}








