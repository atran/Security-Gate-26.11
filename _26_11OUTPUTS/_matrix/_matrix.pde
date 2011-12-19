#include <ht1632c.h>                     // Holtek LED driver by WestFW - updated to HT1632C by Nick Hall
#include <avr/pgmspace.h>                // Enable data to be stored in Flash Mem as well as SRAM              
#include <Font.h>                        // Font library
#include <NewSoftSerial.h>
#include <MemoryFree.h>

////////////////////////////HT1632 globals
#define X_MAX 47                         // Matrix X max LED coordinate (for 2 displays placed next to each other)
#define Y_MAX 15                         // Matrix Y max LED coordinate (for 2 displays placed next to each other)
#define NUM_DISPLAYS 2                   // Num displays for shadow ram data allocation
#define plot(x,y,v)  ht1632_plot(x,y,v)  // Plot LED
#define cls          ht1632_clear        // Clear display
static const byte ht1632_data = 10;      // Data pin for sure module
static const byte ht1632_wrclk = 11;     // Write clock pin for sure module
static const byte ht1632_cs[2] = {
  8,9};  // Chip_selects one for each sure module. Remember to set the DIP switches on the modules too.
/////////////////////////

#define pgmRd pgm_read_byte

PROGMEM prog_uint16_t x_s[] = { 
  0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 10};
PROGMEM prog_uint16_t y_s[] = { 
  3, 4, 5, 6, 11, 12, 3, 4, 5, 6, 11, 12, 3, 4, 5, 6, 11, 12, 0, 1, 2, 7, 8, 9, 13, 14, 15, 0, 1, 2, 7, 8, 9, 13, 14, 15, 0, 1, 2, 7, 8, 9, 13, 14, 15, 0, 1, 2, 7, 8, 9, 13, 14, 15, 0, 1, 2, 7, 8, 9,13, 14, 15, 3, 4, 9, 10, 11, 12, 3, 4, 9, 10, 11, 12, 3, 4, 9, 10, 11, 12};
int sz_s = 81;
PROGMEM  prog_uint16_t x_t[] = { 
  12, 12, 12, 12, 13, 13, 13, 13, 14, 14, 14, 14,  15, 15, 15, 15, 16, 16, 16, 16, 17, 17, 17, 17, 18, 18,  18, 18, 19, 19, 19, 19, 20, 20, 20, 20, 21, 21, 21, 21, 22,  22, 22, 22, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 17, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18, 18};
PROGMEM  prog_uint16_t y_t[] = {
  0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2,3, 0, 1, 2, 3, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15};
int sz_t = 80;

PROGMEM  prog_uint16_t x_o[] = {
  24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24, 24,24, 24, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 25, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 26, 27, 27, 27, 27, 27, 27, 28, 28, 28, 28, 28, 28, 29, 29, 29, 29, 29, 29, 30, 30, 30, 30,30, 30, 31, 31, 31, 31, 31, 31, 32, 32, 32, 32, 32, 32,32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 33, 33, 33, 33,33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 33, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34, 34 };
PROGMEM  prog_uint16_t y_o[] = { 
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 13, 14, 15, 0, 1, 2, 13, 14, 15, 0, 1, 2, 13, 14, 15, 0, 1, 2, 13, 14, 15, 0, 1, 2, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15   };
int sz_o = 126;

PROGMEM  prog_uint16_t x_p[] = {
  36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 36, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 37, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 38, 39, 39, 39, 39, 39, 39, 40, 40, 40, 40, 40, 40, 41, 41, 41, 41, 41, 41, 42, 42, 42, 42, 42, 42, 43, 43, 43, 43, 43, 43, 44, 44, 44, 44, 44, 45, 45, 45, 45, 45, 46, 46, 46, 46, 46};
PROGMEM  prog_uint16_t y_p[] = {
  3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0, 1, 2, 8, 9, 10, 0, 1, 2, 8, 9, 10, 0, 1, 2, 8, 9, 10, 0, 1, 2, 8, 9, 10, 0, 1, 2, 8, 9, 10, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7, 3, 4, 5, 6, 7};
int sz_p = 84;





NewSoftSerial arduino(6, 7); //rx/tx
boolean isSolid = false;

//////////preset vars
int counter = 0;
int on;

void setup()
{
  Serial.begin(9600); // open serial
  arduino.begin(9600);
  pinMode(13, OUTPUT);
  ht1632_setup();                         // Setup display (uses flow chart from page 17 of sure datasheet)
  randomSeed(analogRead(A1));             // Setup random number generator
  ht1632_setBrightness(15);
  drawStop();
}

void loop()
{
//  serialCmd();
  if (arduino.available()){
    delay(2);
    char header = arduino.read();
    if (header == 'L'){
      delay(2);
      char cmd = arduino.read();
      Serial.println(cmd);
      if (cmd == 'S')
      {
        isSolid = true;
        drawSolid();
      }
      else if (cmd == 'R' && !isSolid) 
      {
        int qpik = random(0,14);
        drawRf(qpik);
      }
      else //if (cmd == 'N')
      {
        isSolid = false;
        drawStop();
      }
    }
  }
}
