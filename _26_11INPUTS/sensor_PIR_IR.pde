int getAvg(int pin, int avgFactor)
{
  int runningTotal = 0;
  int distRead, distAvg;
  for (int i=0; i < avgFactor; i++)
  {
    distRead = analogRead(pin);
    runningTotal += distRead;
  }
  distAvg = (runningTotal / avgFactor);
  return distAvg;
} 

boolean isMoving(){
  int moveVal = analogRead(PIR_PIN);
  if (moveVal > 100) { 
    return true; 
  }
  else { 
    return false; 
  }
}

