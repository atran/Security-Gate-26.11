void txtDetecting(){
  char pre[10] = "detecting";
//  char input[2] = {'2','3'};
//  input[0] = arduino.read();
//  input[1] = arduino.read();
  for (int i=0; i < 10; i++){
    ht1632_puttinychar((i*4) + 1, 1, pre[i]);
  }
//  for (int i=0; i < 2; i++){
//    ht1632_puttinychar(29 + (i*4) + 1, 1, input[i]);
//  }
}
void txtLoading(){
  char pre[8] = "loading";
  for (int i=0; i < 8; i++){
    ht1632_putchar((i*6), 1, pre[i]);
  }
}







