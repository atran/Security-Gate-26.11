int rf_detected(){
  float rf_value = analogRead(RF_PIN);
  if (rf_value > rf_avg){
    float dev_value = (rf_value - rf_avg) / rf_avg;
    if (dev_value > rfdev_value){
      return (int)rf_value;
          Serial.print(rf_avg);
          Serial.print(rf_value);
          Serial.println(dev_value, 4);
    }
  }
  return -1;  
}


// this function samples the environment to establish a "room tone" it updates
// this info according to freq_rfsample_millis, a constant set above
void rf_setSample(){
  int currentTime = millis();
  if (currentTime - startTime > freq_rfsample_millis){
    rf_avg = 0;
    while (moving_count < rfsample_size){ 
      float rf_value = analogRead(RF_PIN);   
      moving_count++;
      rf_avg = ((rf_avg * (moving_count-1)) + rf_value) / moving_count;  
          Serial.print(rf_avg);
          Serial.print(rf_value);
          Serial.println(moving_count);
    }
    moving_count = 0;
    startTime = millis();
        Serial.print("calibration rf ");
        Serial.println(rf_avg);  
  }
}


