 

void drawStop(){
  cls();
  for (int i=0; i < sz_s; i++){
    plot(pgmRd(&x_s[i]), pgmRd(&y_s[i]), 1);
  } 
  for (int i=0; i < sz_t; i++){
    plot(pgmRd(&x_t[i]), pgmRd(&y_t[i]), 1);
  }
  for (int i=0; i < sz_o; i++){
    plot(pgmRd(&x_o[i]), pgmRd(&y_o[i]), 1);
  }  
  for (int i=0; i < sz_p; i++){
    plot(pgmRd(&x_p[i]), pgmRd(&y_p[i]), 1);
  }  
}

void drawSolid(){
  cls();
  for (float x = 0; x<X_MAX+1;x++){
    for (float y = 0; y<Y_MAX+1; y++){
      plot(x,y,1);
    }
  }
}

void cls2(){
  if (random(0,2)){
    cls(); 
  }
}

