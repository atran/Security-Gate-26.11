
// ****** SUB-ROUTINES ******

/*
 * ht1632_chipselect / ht1632_chipfree
 * Select or de-select a particular ht1632 chip. De-selecting a chip ends the commands being sent to a chip.
 * CD pins are active-low; writing 0 to the pin selects the chip.
 */
void ht1632_chipselect(byte chipno)
{
  DEBUGPRINT("\nHT1632(%d) ", chipno);
  digitalWrite(chipno, 0);
}

void ht1632_chipfree(byte chipno)
{
  DEBUGPRINT(" [done %d]", chipno);
  digitalWrite(chipno, 1);
}


/*
 * ht1632_writebits
 * Write bits (up to 8) to h1632 on pins ht1632_data, ht1632_wrclk Chip is assumed to already be chip-selected
 * Bits are shifted out from MSB to LSB, with the first bit sent being (bits & firstbit), shifted till firsbit is zero.
 */
void ht1632_writebits (byte bits, byte firstbit)
{
  DEBUGPRINT(" ");
  while (firstbit) {
    DEBUGPRINT((bits&firstbit ? "1" : "0"));
    digitalWrite(ht1632_wrclk, LOW);
    if (bits & firstbit) {
      digitalWrite(ht1632_data, HIGH);
    } 
    else {
      digitalWrite(ht1632_data, LOW);
    }
    digitalWrite(ht1632_wrclk, HIGH);
    firstbit >>= 1;
  }
}


/*
 * ht1632_sendcmd
 * Send a command to the ht1632 chip. A command consists of a 3-bit "CMD" ID, an 8bit command, and one "don't care bit".
 *   Select 1 0 0 c7 c6 c5 c4 c3 c2 c1 c0 xx Free
 */
static void ht1632_sendcmd (byte d, byte command)
{
  ht1632_chipselect(ht1632_cs[d]);        // Select chip
  ht1632_writebits(HT1632_ID_CMD, 1<<2);  // send 3 bits of id: COMMMAND
  ht1632_writebits(command, 1<<7);        // send the actual command
  ht1632_writebits(0, 1);         	  // one extra dont-care bit in commands.
  ht1632_chipfree(ht1632_cs[d]);          //done
}


/*
 * ht1632_senddata
 * send a nibble (4 bits) of data to a particular memory location of the
 * ht1632.  The command has 3 bit ID, 7 bits of address, and 4 bits of data.
 *    Select 1 0 1 A6 A5 A4 A3 A2 A1 A0 D0 D1 D2 D3 Free
 * Note that the address is sent MSB first, while the data is sent LSB first!
 * This means that somewhere a bit reversal will have to be done to get
 * zero-based addressing of words and dots within words.
 */
static void ht1632_senddata (byte d, byte address, byte data)
{
  ht1632_chipselect(ht1632_cs[d]);      // Select chip
  ht1632_writebits(HT1632_ID_WR, 1<<2); // Send ID: WRITE to RAM
  ht1632_writebits(address, 1<<6);      // Send address
  ht1632_writebits(data, 1<<3);         // Send 4 bits of data
  ht1632_chipfree(ht1632_cs[d]);        // Done.
}


/*
 * ht1632_setup
 * setup the ht1632 chips
 */
void ht1632_setup()
{
  for (byte d=0; d<NUM_DISPLAYS; d++) {
    pinMode(ht1632_cs[d], OUTPUT);

    digitalWrite(ht1632_cs[d], HIGH);  // Unselect (active low)

    pinMode(ht1632_wrclk, OUTPUT);
    pinMode(ht1632_data, OUTPUT);

    ht1632_sendcmd(d, HT1632_CMD_SYSON);    // System on 
    ht1632_sendcmd(d, HT1632_CMD_LEDON);    // LEDs on 
    ht1632_sendcmd(d, HT1632_CMD_COMS01);   // NMOS Output 24 row x 24 Com mode

    for (byte i=0; i<128; i++)
      ht1632_senddata(d, i, 0);  // clear the display!
  }
}


/*
 * we keep a copy of the display controller contents so that we can know which bits are on without having to (slowly) read the device.
 * Note that we only use the low four bits of the shadow ram, since we're shadowing 4-bit memory.  This makes things faster, and we
 * use the other half for a "snapshot" when we want to plot new data based on older data...
 */
byte ht1632_shadowram[NUM_DISPLAYS * 96];  // our copy of the display's RAM


/*
 * plot a point on the display, with the upper left hand corner being (0,0).
 * Note that Y increases going "downward" in contrast with most mathematical coordiate systems, but in common with many displays
 * No error checking; bad things may happen if arguments are out of bounds!  (The ASSERTS compile to nothing by default
 */
void ht1632_plot (char x, char y, char val)
{

  char addr, bitval;

  //  ASSERT(x >= 0);
  //  ASSERT(x <= X_MAX);
  //  ASSERT(y >= 0);
  //  ASSERT(y <= y_MAX);

  // custom code
  x = X_MAX - x;
  y = Y_MAX - y;
  if (x<0 || x>X_MAX || y<0 || y>Y_MAX){
  } 
  else{
    byte d;
    //select display depending on plot values passed in
    if (x >= 0 && x <=23 ) {
      d = 0;
    }  
    if (x >=24 && x <=47) {
      d = 1;
      x = x-24; 
    }   

    /*
   * The 4 bits in a single memory word go DOWN, with the LSB (first transmitted) bit being on top.  However, writebits()
     * sends the MSB first, so we have to do a sort of bit-reversal somewhere.  Here, this is done by shifting the single bit in
     * the opposite direction from what you might expect.
     */

    bitval = 8>>(y&3);  // compute which bit will need set

    addr = (x<<2) + (y>>2);  // compute which memory word this is in 

    if (val) {  // Modify the shadow memory
      ht1632_shadowram[(d * 96)  + addr] |= bitval;
    } 
    else {
      ht1632_shadowram[(d * 96) + addr] &= ~bitval;
    }
    // Now copy the new memory value to the display
    ht1632_senddata(d, addr, ht1632_shadowram[(d * 96) + addr]);
  }
}


/*
 * get_shadowram
 * return the value of a pixel from the shadow ram.
 */
byte get_shadowram(byte x, byte y)
{
  byte addr, bitval, d;

  //select display depending on plot values passed in
  if (x >= 0 && x <=23 ) {
    d = 0;
  }  
  if (x >=24 && x <=47) {
    d = 1;
    x = x-24; 
  }  

  bitval = 8>>(y&3);  // compute which bit will need set
  addr = (x<<2) + (y>>2);       // compute which memory word this is in 
  return (0 != (ht1632_shadowram[(d * 96) + addr] & bitval));
}


/*
 * snapshot_shadowram
 * Copy the shadow ram into the snapshot ram (the upper bits)
 * This gives us a separate copy so we can plot new data while
 * still having a copy of the old data.  snapshotram is NOT
 * updated by the plot functions (except "clear")
 */
void snapshot_shadowram()
{
  for (byte i=0; i< sizeof ht1632_shadowram; i++) {
    ht1632_shadowram[i] = (ht1632_shadowram[i] & 0x0F) | ht1632_shadowram[i] << 4;  // Use the upper bits
  }

}

/*
 * get_snapshotram
 * get a pixel value from the snapshot ram (instead of
 * the actual displayed (shadow) memory
 */
byte get_snapshotram(byte x, byte y)
{

  byte addr, bitval;
  byte d = 0;

  //select display depending on plot values passed in 
  if (x >=24 && x <=47) {
    d = 1;
    x = x-24; 
  }  

  bitval = 128>>(y&3);  // user upper bits!
  addr = (x<<2) + (y>>2);   // compute which memory word this is in 
  if (ht1632_shadowram[(d * 96) + addr] & bitval)
    return 1;
  return 0;
}


/*
 * ht1632_clear
 * clear the display, and the shadow memory, and the snapshot
 * memory.  This uses the "write multiple words" capability of
 * the chipset by writing all 96 words of memory without raising
 * the chipselect signal.
 */
void ht1632_clear()
{
  char i;
  for(byte d=0; d<NUM_DISPLAYS; d++)
  {
    ht1632_chipselect(ht1632_cs[d]);  // Select chip
    ht1632_writebits(HT1632_ID_WR, 1<<2);  // send ID: WRITE to RAM
    ht1632_writebits(0, 1<<6); // Send address
    for (i = 0; i < 96/2; i++) // Clear entire display
      ht1632_writebits(0, 1<<7); // send 8 bits of data
    ht1632_chipfree(ht1632_cs[d]); // done
    for (i=0; i < 96; i++)
      ht1632_shadowram[96*d + i] = 0;
  }
}


/* ht1632_putchar
 * Copy a 5x7 character glyph from the myfont data structure to display memory, with its upper left at the given coordinate
 * This is unoptimized and simply uses plot() to draw each dot.
 */
void ht1632_putchar(byte x, byte y, char c)
{
  byte dots;
  if (c >= 'A' && c <= 'Z' || (c >= 'a' && c <= 'z') ) {
    c &= 0x1F;   // A-Z maps to 1-26
  } 
  else if (c >= '0' && c <= '9') {
    c = (c - '0') + 31;
  } 
  else if (c == ' ') {
    c = 0; // space
  }
  else if (c == '.') {
    c = 27; // full stop
  }
  else if (c == '\'') {
    c = 28; // single quote mark
  }  
  else if (c == ':') {
    c = 29; // clock_mode selector arrow
  }
  else if (c == '>') {
    c = 30; // clock_mode selector arrow
  }

  for (char col=0; col< 5; col++) {
    dots = pgm_read_byte_near(&myfont[c][col]);
    for (char row=0; row < 7; row++) {
      if (dots & (64>>row))   	     // only 7 rows.
        plot(x+col, y+row, 1);
      else 
        plot(x+col, y+row, 0);
    }
  }
}


/* ht1632_putbigchar
 * Copy a 10x14 character glyph from the myfont data structure to display memory, with its upper left at the given coordinate
 * This is unoptimized and simply uses plot() to draw each dot.
 */
void ht1632_putbigchar(byte x, byte y, char c)
{
  byte dots;
  if (c >= 'A' && c <= 'Z' || (c >= 'a' && c <= 'z') ) {
    return;   //return, as the 10x14 font contains only numeric characters 
  } 
  if (c >= '0' && c <= '9') {
    c = (c - '0');
    c &= 0x1F;
  } 

  for (char col=0; col< 10; col++) {
    dots = pgm_read_byte_near(&mybigfont[c][col]);
    for (char row=0; row < 8; row++) {
      if (dots & (128>>row))   	   
        plot(x+col, y+row, 1);
      else 
        plot(x+col, y+row, 0);
    }

    dots = pgm_read_byte_near(&mybigfont[c][col+10]);
    for (char row=0; row < 8; row++) {
      if (dots & (128>>row))   	   
        plot(x+col, y+row+8, 1);
      else 
        plot(x+col, y+row+8, 0);
    } 
  }  
}


/* ht1632_puttinychar
 * Copy a 3x5 character glyph from the myfont data structure to display memory, with its upper left at the given coordinate
 * This is unoptimized and simply uses plot() to draw each dot.
 */
void ht1632_puttinychar(byte x, byte y, char c)
{
  byte dots;
  if (c >= 'A' && c <= 'Z' || (c >= 'a' && c <= 'z') ) {
    c &= 0x1F;   // A-Z maps to 1-26
  } 
  else if (c >= '0' && c <= '9') {
    c = (c - '0') + 31;
  } 
  else if (c == ' ') {
    c = 0; // space
  }
  else if (c == '.') {
    c = 27; // full stop
  }
  else if (c == '\'') {
    c = 28; // single quote mark
  } 
  else if (c == '!') {
    c = 29; // single quote mark
  }  
  else if (c == '?') {
    c = 30; // single quote mark
  }

  for (char col=0; col< 3; col++) {
    dots = pgm_read_byte_near(&mytinyfont[c][col]);
    for (char row=0; row < 5; row++) {
      if (dots & (16>>row))   	   
        plot(x+col, y+row, 1);
      else 
        plot(x+col, y+row, 0);
    }
  }  
}

void ht1632_setBrightness(int i){
  if (i > 0 && i < 16){
    ht1632_sendcmd(0, HT1632_CMD_PWM + i); //send intensity commands using CS0 for display 0
    ht1632_sendcmd(1, HT1632_CMD_PWM + i); //send intensity commands using CS0 for display 1
  }
}





