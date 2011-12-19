void drawRf(int preset){
  //  int rf = readRf();
  //  preset = 12;
  //flicker anything
  if (preset != 0){
    cls2();
  }
  if (preset == 0){
    flicker();
  }
  else if( preset == 1){
    drawRandom();
    drawRandom();   
  }
  else if( preset == 2){
    flashingSquare();
  }
  else if( preset == 3){
    drawUpsideDown();
  }
  else if( preset == 4){
    multiShiftXY();
  }
  else if( preset == 5){
    flicker();
  }
  else if (preset == 6){
    drawInvStop();
    drawInvStop();    
    drawInvStop();
    drawInvStop();
  }
  else if (preset == 7){
    scanRight();
    drawStop();
    scanRight();
    drawStop();
  }
  else if (preset == 8){
    scanDown();
    drawStop();
    scanDown();
    drawStop();
  }
  else if (preset == 9){
    txtLoading();
  }
  else if (preset == 10){
    txtDetecting();
  }
  else if (preset == 11){
    for (int i=0;i<10;i++){
      noise();
    }
  }
  else if (preset == 12){
    scanY();
    scanY();
    scanY();
  }
  else if (preset == 13){
    for (int i=0; i<12; i++){
      randomTopBottom();
    }
  }
}

char readRf(){
  char input[2];
  input[0] = arduino.read();
  input[1] = arduino.read();
  return input[2];
}





















