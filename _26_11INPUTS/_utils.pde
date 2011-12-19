void toSend(String msg){
  if (msg != p_msg){
    Serial.println(msg);
    Serial1.print(msg);
    Serial2.print(msg);
    Serial3.print(msg);
    //    Serial.println(msg);
    p_msg = msg;  
  }
}
void toSendPIR(String msg){
  if (msg != PIR_p_msg){
    Serial.println(msg);
//    Serial1.print(msg);
//    Serial2.print(msg);
    Serial3.print(msg);
    //    Serial.println(msg);
    PIR_p_msg = msg;  
  }
}
void toSend(String msg, int rf_val){
  if (msg != p_msg){
    Serial.println(msg);
    Serial1.print(msg);
    Serial2.print(msg);
    Serial3.print(msg);
    int rf = map(rf_val,0,400,0,99);
    Serial1.print(rf);
    Serial2.print(rf);
    Serial3.print(rf);
    //    Serial.print(msg);
    //    Serial.print(":    ");
    //    Serial.println(rf_val);
    p_msg = msg;  

    //delay(2500);
  }
}











