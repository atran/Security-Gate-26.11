void multiShiftXY(){
  int rotations  = random(6,12);
  for (int i=0;i<rotations; i++){
    shiftXY(true, true);
    cls2();
  }
}


void shiftXY(boolean x, boolean y){
  int x_shift = 0;
  int y_shift = 0;
  if (x){
    x_shift = random(-20,20);
  }
  if (y){
    y_shift = random(-10,10);
  }
  for (int i=0; i < sz_s; i++){
    plot(pgmRd(&x_s[i])+x_shift, pgmRd(&y_s[i])+y_shift, 1);
  } 
  //  shift = random(-10,10);
  for (int i=0; i < sz_t; i++){
    plot(pgmRd(&x_t[i])+x_shift, pgmRd(&y_t[i])+y_shift, 1);
  }
  //  shift = random(-10,10);
  for (int i=0; i < sz_o; i++){
    plot(pgmRd(&x_o[i])+x_shift, pgmRd(&y_o[i])+y_shift, 1);
  }  
  //  shift = random(-10,10);
  for (int i=0; i < sz_p; i++){
    plot(pgmRd(&x_p[i])+x_shift, pgmRd(&y_p[i])+y_shift, 1);
  }  
}

void shiftY(int mod_y){
  int shift = random(-10,10);
  for (int i=0; i < sz_s; i++){
    if (pgmRd(&y_s[i]) == mod_y) {
      plot(pgmRd(&x_s[i])+shift, pgmRd(&y_s[i]), 1);
    } 
    else{
      plot(pgmRd(&x_s[i]), pgmRd(&y_s[i]), 1);
    }
  }
  for (int i=0; i < sz_t; i++){    
    if (pgmRd(&y_t[i]) == mod_y) {
      plot(pgmRd(&x_t[i])+shift, pgmRd(&y_t[i]), 1);
    } 
    else {
      plot(pgmRd(&x_t[i]), pgmRd(&y_t[i]), 1);
    }
  }
  for (int i=0; i < sz_o; i++){
    if (pgmRd(&y_o[i]) == mod_y) {
      plot(pgmRd(&x_o[i])+shift, pgmRd(&y_o[i]), 1);
    } 
    else{
      plot(pgmRd(&x_o[i]), pgmRd(&y_o[i]), 1);
    }
  }
  for (int i=0; i < sz_p; i++){
    if (pgmRd(&y_p[i]) == mod_y) {
      plot(pgmRd(&x_p[i])+shift, pgmRd(&y_p[i]), 1);
    } 
    else {
      plot(pgmRd(&x_p[i]), pgmRd(&y_p[i]), 1);
    }
  }
  cls();
}


void scanY(){
  if (random(0,2)) {
    int r = random(1,11);
    for (int j=0; j < r;j++){
      shiftY(random(3,11));
    } 
  }
  else {
    for (int i=0;i<Y_MAX;i++){
      shiftY(i);
    }
  }
}












