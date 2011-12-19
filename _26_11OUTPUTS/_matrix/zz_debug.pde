void serialPreset(char qpik){
  int preset = int(qpik);
  if (qpik == '0'){
    drawStop();
  }
  else if( qpik == '1'){
    drawInvStop();    drawInvStop();    drawInvStop();
  }
  else if( qpik == '2'){
    flashingSquare();
  }
  else if( qpik == '3'){
    drawUpsideDown();
  }
  else if( qpik == '4'){
    multiShiftXY();
  }
  else if( qpik == '5'){
    flicker();
  }
  else if (qpik == '6'){
    drawInvStop();
  }
  else if (qpik == '7'){
    scanRight();
  }
  else if (qpik == '8'){
    scanY();    scanY();    scanY();    scanY();
  }
  else if (qpik == '9'){
    for (int i=0;i<10;i++){
      noise();
    }
  }
  else if( qpik == 'a'){
    for (int i=0; i<15; i++){
      randomTopBottom();
    }
  }
}


void serialCmd(){
  if (Serial.available()){
    char cmd = Serial.read();
    cls();
    int qpik = random(0,14);
    if (cmd == ' ') {
      drawRf(qpik);
    } 
    else{
      serialPreset(cmd);
    }
    Serial.print(qpik);
    Serial.print("freeMemory()=");
    Serial.println(freeMemory());
  }
}


