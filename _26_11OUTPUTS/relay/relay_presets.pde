void relay_solid(){
  MsTimer2::stop();
  digitalWrite(RELAY_PIN, HIGH);
}

void relay_rf(){
  char input[2];
  input[0] = arduino.read();
  input[1] = arduino.read();
  full_input = atoi(input);
  Serial.print("rf: ");
  int l_map = map(full_input, 0,99,50,200) + random(-50,50);
  int h_map = map(full_input, 0,99,30, 75) + random(-10,10);
  Serial.print(full_input);
  Serial.print("\t");
  Serial.print(l_map);
  Serial.print("\t");
  Serial.println(h_map);
//  low_delay = 100;
//  high_delay = 20;
  low_delay = l_map;
  high_delay = h_map;
  resetTimer();
}

void relay_nu(){
  low_delay = 1000;
  high_delay = 1001;
  resetTimer();
}

void relay_around(){
  low_delay = 500;
  high_delay = 1000;
  resetTimer();
}
