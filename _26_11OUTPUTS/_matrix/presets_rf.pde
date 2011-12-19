void drawInvStop(){
  drawSolid();
  for (int i=0; i < sz_s; i++){
    plot(pgmRd(&x_s[i]), pgmRd(&y_s[i]), 0);
  } 
  for (int i=0; i < sz_t; i++){
    plot(pgmRd(&x_t[i]), pgmRd(&y_t[i]), 0);
  }
  for (int i=0; i < sz_o; i++){
    plot(pgmRd(&x_o[i]), pgmRd(&y_o[i]), 0);
  }  
  for (int i=0; i < sz_p; i++){
    plot(pgmRd(&x_p[i]), pgmRd(&y_p[i]), 0);
  }  
}

void drawRandom(){
  for (int i=0; i < sz_s; i++){
    on = random(2);
    if (on){
      plot(pgmRd(&x_s[i]), pgmRd(&y_s[i]), on);
    }
  } 
  for (int i=0; i < sz_t; i++){
    on = random(2);
    if (on){
      plot(pgmRd(&x_t[i]), pgmRd(&y_t[i]), on);
    }
  }
  for (int i=0; i < sz_o; i++){
    on = random(2);
    if (on){
      plot(pgmRd(&x_o[i]), pgmRd(&y_o[i]), on);
    }
  }  
  for (int i=0; i < sz_p; i++){
    on = random(2);
    if (on){
      plot(pgmRd(&x_p[i]), pgmRd(&y_p[i]), on);
    }
  }  
}

void drawUpsideDown(){
  for (int z=0; z< 14; z++){
    //    boolean shift = random(0,2);
    for (int i=0; i < sz_s; i++){
      plot(X_MAX - pgmRd(&x_s[i]), Y_MAX -  pgmRd(&y_s[i]), 1);
    } 
    for (int i=0; i < sz_t; i++){
      plot(X_MAX - pgmRd(&x_t[i]), Y_MAX -  pgmRd(&y_t[i]), 1);
    }
    for (int i=0; i < sz_o; i++){
      plot(X_MAX - pgmRd(&x_o[i]), Y_MAX -  pgmRd(&y_o[i]), 1);
    }  
    for (int i=0; i < sz_p; i++){
      plot(X_MAX - pgmRd(&x_p[i]), Y_MAX -  pgmRd(&y_p[i]), 1);
    }
    cls();
    drawStop();
    boolean shift = random(0,2);
    if (shift){
      cls(); 
      shiftXY(false, true);
    }
    if (random(0,2)){
      cls();
    }
  }
}



void flashingSquare(){
  for (int z=0; z<14;z++){
    for (int i=0;i<sz_s;i++){
      if (pgmRd(&x_s[i]) < 5 && pgmRd(&x_s[i]) > 2){
        plot(pgmRd(&x_s[i])-1,pgmRd(&y_s[i]),1);
      }
      else{
        plot(pgmRd(&x_s[i]),pgmRd(&y_s[i]),1);
      }
    }
    for (int i=0; i < sz_t; i++){
      if (pgmRd(&x_t[i]) > 20){
        plot(pgmRd(&x_t[i])-10, pgmRd(&y_t[i]), 1);
      } //try overlapping
      else {
        plot(pgmRd(&x_t[i]), pgmRd(&y_t[i]), 1);
      }
    }
    for (int i=0; i < sz_o; i++){
      if (pgmRd(&x_t[i]) < 30){
        plot(pgmRd(&x_o[i])-10, pgmRd(&y_o[i]), 1);
      } //try overlapping
      else {
        plot(pgmRd(&x_o[i]), pgmRd(&y_o[i]), 1);
      }
    }  
    for (int i=0; i < sz_p; i++){
      plot(pgmRd(&x_p[i]), pgmRd(&y_p[i]), 1);
    }  
    drawStop();
    cls2();
  } 
}



void flicker(){
  char intensity;
  for (int i=0; i < 15; i++){
    intensity = random(7,15);
    ht1632_sendcmd(0, HT1632_CMD_PWM + intensity);
    ht1632_sendcmd(1, HT1632_CMD_PWM + intensity);
    //    ht1632_setBrightness(intensity);
  }
  ht1632_setBrightness(15);
}





void scanDown(){
  for (int y=0; y <= Y_MAX+1; y++){
    drawYLine(y);
  }
}


void drawYLine(int y){
  for(int x = 0; x <= X_MAX; x++){
    plot(x,y-1,0);
  }
  for(int x = 0; x <= X_MAX; x++){
    plot(x,y,1);
  }
}


void scanRight(){
  for (int x=0; x <= X_MAX+1; x++){
    drawXLine(x);
  }
}


void drawXLine(int x){
  for(int y = 0; y <= Y_MAX; y++){
    plot(x-1,y,0);
  }
  for(int y = 0; y <= Y_MAX; y++){
    plot(x,y,1);
  }
}


void noise(){
  for (int x = 0; x < X_MAX; x++){
    plot(x,random(0,Y_MAX),random(0,2));
    plot(x,random(0,Y_MAX),random(0,2));
  }
}
void randomTopBottom(){
  for (int x = 0; x < X_MAX; x++){
    plot(x,0,random(0,2));
    plot(x,Y_MAX,random(0,2));
  }
}


