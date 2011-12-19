Security Gate 26.11
===================
Security Gate 26.11 is an Arduino-based, interactive, electronic art work that detects wireless emissions given off by individuals, including cellular and smartphone transmissions, wifi, bluetooth, RFID, and others. Security Gate 26.11 produces individualized audiovisual responses to these transmissions. Our lives are subjected to daily forms of surveillance via mechanisms that are less recognizable to us as such precisely because they are not visible. Today, wireless transmissions are the corpus of control and repression, as evidenced by sophisticated governmental systems of mass surveillance and snooping (Carnivore and its variants) and corporate monitoring (data-mining and software recommendation systems). 

Shown at Northern Spark, Minneapolis/St. Paul, 6/5/11.

Inputs
------

Inputs were all on a single Arduino 2560 Mega board. Serial communication was one way from the input board to each of the output boards.

* [LT5534 - 50MHz to 3GHz RF Power Detector with 60dB Dynamic Range](http://www.linear.com/product/LT5534)
* [PIR Motion Sensor](http://www.sparkfun.com/products/8630)
* [Infrared Proximity Sensor - Sharp GP2Y0A21YK](http://www.sparkfun.com/products/242)

Outputs
-------

Outputs were all on seperate boards.

* Relay connected to fluorescent lights
* Two LED Matrices (Sure Electronics 1624 5mm Red LED version)
* [Auduino](http://code.google.com/p/tinkerit/wiki/Auduino) - a sound synthesiser based on the Arduino platform
