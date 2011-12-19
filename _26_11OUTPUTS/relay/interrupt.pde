//////two interrupts: one where l<h; other h<l
void servTimer2Interrupt_a() {
  if (counter == (high_delay / low_delay) + 1){
    counter = 0;
    digitalWrite(RELAY_PIN, LOW);
  } 
  else{
    counter++;
    digitalWrite(RELAY_PIN, HIGH);
  }
}
void servTimer2Interrupt_b() {
  if (counter == (low_delay / high_delay) + 1){
    counter = 0;
    digitalWrite(RELAY_PIN, LOW);
  } 
  else{
    counter++;
    digitalWrite(RELAY_PIN, HIGH);
  }
}
void resetTimer(){
  counter = 0;
  MsTimer2::stop();
  if (low_delay < high_delay) {
    MsTimer2::set(low_delay, servTimer2Interrupt_a);
  } 
  else {
    MsTimer2::set(high_delay, servTimer2Interrupt_b);
  }
  MsTimer2::start();
}
