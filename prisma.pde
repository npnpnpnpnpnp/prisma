//video-import

import processing.video.*;
Capture webcam;

boolean mode = true;
float sumR, sumG, sumB, ampR, ampG, ampB, quanR, quanG, quanB, strokeR, strokeG, strokeB, diameter;
float stroke = 1.8;
float mx = 1450;
float my = 400;
float widthSunB = 300;
float heightSunB = 300;


//fader-import

import controlP5.*;
ControlP5 cp5;
ColorPicker cp;


//pdf-export-import

import processing.pdf.*;
boolean record = false;


// loading font: standard 07 58 (controlp5)

PFont font;


void setup () {
  //size (1700, 1000);
fullScreen();
  webcam = new Capture(this, 160, 120);
  webcam.start();

  cp5 = new ControlP5(this);


  // slider for stroke

  cp5.addSlider("stroke")
    .setColorActive(color(125))
    .setColorForeground(color(125))
    .setColorValue(color(255))
    .setColorBackground(color(80))
    .setPosition(60, 312)
    .setRange(1.8, 5);


  // toggle bar for changing the mode

  cp5.addToggle("mode")
    .setColorActive(color(125))
    .setColorForeground(color(125))
    .setColorValue(color(255))
    .setColorBackground(color(80))
    .setPosition(60, 370)
    .setSize(40, 9)
    .setMode(Toggle.SWITCH)
    ;
}

void draw () {

  if (mode) {

    // MODE 1

    font = createFont("standard 07_58", 8);


    // start recording fr pdf-export in the end by pressing 's'

    if (record) beginRecord(PDF, "prisma_###.pdf");
    background(0);
    textFont(font);


    // activate internal webcam

    if (webcam.available()) {
      webcam.read();
      webcam.loadPixels();
    }


    // WAVE VISUALIZATION
    // underlined description text

    fill(255, 255, 255);
    text("WAVE VISUALIZATION", 300, 67);
    stroke(255);
    strokeWeight(0.5);
    line (300, 69, 399, 69);


    // loop for gathering the color values; extracting and adding them together

    for (int x = 0; x < webcam.width; x += 1) {
      for (int y = 0; y < webcam.height; y += 1) {
        int c = webcam.pixels[y*webcam.width + x];
        int red = (c >> 16) & 0xff;
        int green = (c >> 8) & 0xff;
        int blue = c & 0xff;

        sumR = sumR + red;
        sumG = sumG + green;
        sumB = sumB + blue;
      }
    }


    // calculation of the average values of r, g, b in the current frame

    sumR = sumR/(webcam.width*webcam.height);
    sumG = sumG/(webcam.width*webcam.height);
    sumB = sumB/(webcam.width*webcam.height);


    // mapping the calculated rgb-values for using it for the amplitude of sinus-functions
    // according to the saturation of the rgb-values found out.

    float deg = 0;
    float ampR = map(sumR, 255, 0, 100, 0);
    float ampG = map(sumG, 255, 0, 100, 0);
    float ampB = map(sumB, 255, 0, 100, 0);

    println("R=" + sumR);
    println("G=" + sumG);
    println("B=" + sumB);

    strokeWeight(stroke); 


    // red

    strokeCap(ROUND);

    for (int x = 0; x < 800; x = x + 1) {
      deg = deg + PI/2;
      stroke (sumR, 0, 0);
      point (300 + x, 300 + sin(radians(deg))*ampR);
    }

    fill(255, 0, 0);
    text("RED 710 NM", 300, 400); 
    text(sumR, 297, 415); 


    // green

    for (int x = 0; x < 800; x = x + 1) {
      deg = deg + PI;
      stroke (0, sumG, 0);
      point (300 + x, 525 + sin(radians(deg))*ampG);
    }

    fill(0, 255, 0);
    text("GREEN 510 NM", 300, 650); 
    text(sumG, 297, 665);


    // blue

    for (int x = 0; x < 800; x = x + 1) {
      deg = deg + TWO_PI;
      stroke (0, 0, sumB);
      point (300 + x, 800 + sin(radians(deg))*ampB);
    }

    fill(0, 0, 255);
    text("BLUE 465 NM", 300, 900); 
    text(sumB, 297, 915);


    //SUNBURST-VISUALIZATION
    // underlined description text

    fill(255, 255, 255);
    text("SUNBURST VISUALIZATION", 1290, 67);
    stroke(255);
    strokeWeight(0.5);
    line (1290, 69, 1405, 69); 

    // mappen des errechneten durchschnittswertes auf winkelmaße

    float quanR = map(sumR, 255, 0, 120, 0);
    float quanG = map(sumG, 255, 0, 240, 120);
    float quanB = map(sumB, 255, 0, 360, 240);

    float strokeR = map(sumR, 255, 0, 50, 10);
    float strokeG = map(sumG, 255, 0, 50, 10);
    float strokeB = map(sumB, 255, 0, 50, 10);

    strokeCap(SQUARE);
    strokeWeight(strokeR); 
    stroke (sumR, 0, 0);
    noFill();

    arc (mx, my, widthSunB, heightSunB, radians(0), radians(quanR));

    strokeWeight(strokeG);
    stroke (0, sumG, 0);
    noFill();
    arc (mx, my, widthSunB, heightSunB, radians(120), radians(quanG));

    strokeWeight(strokeB);
    stroke (0, 0, sumB);
    noFill();
    arc (mx, my, widthSunB, heightSunB, radians(240), radians(quanB));


    // options: text of description 
    // underlined description text

    fill(255, 255, 255);
    text("OPTIONS", 60, 67); 
    stroke(255);
    strokeWeight(0.5);
    line (59, 69, 97, 69); 

    fill(125, 125, 125);
    text("FADING OPTIONS", 60, 307); 
    text("KEY OPTIONS", 60, 342); 

    fill(255, 255, 255);
    text("S = SAVE AS PDF", 60, 355); 

    if (record) { 
      endRecord(); 
      record = false;
    }
  } else {

    // MODE 2

    if (record) beginRecord(PDF, "prisma_###.pdf");
    background(0);
    textFont(font);


    // activate internal webcam

    if (webcam.available()) {
      webcam.read();
      webcam.loadPixels();
    }


    // loop for gathering the color values; extracting and adding them together

    for (int x = 0; x < webcam.width; x += 1) {
      for (int y = 0; y < webcam.height; y += 1) {
        int c = webcam.pixels[y*webcam.width + x];
        int rot = (c >> 16) & 0xff;
        int gruen = (c >> 8) & 0xff;
        int blau = c & 0xff;

        sumR = sumR + rot;
        sumG = sumG + gruen;
        sumB = sumB + blau;
      }
    }


    // calculation of the average values of r, g, b in the current frame

    sumR = sumR/(webcam.width*webcam.height);
    sumG = sumG/(webcam.width*webcam.height);
    sumB = sumB/(webcam.width*webcam.height);


    // mapping the calculated rgb-values for using it for the amplitude of sinus-functions
    // according to the saturation of the rgb-values found out.

    float deg = 0;
    float ampR = map(sumR, 255, 0, 100, 0);
    float ampG = map(sumG, 255, 0, 100, 0);
    float ampB = map(sumB, 255, 0, 100, 0);

    strokeWeight(stroke);


    // red

    for (int x = 0; x < 800; x = x + 5) {
      deg = deg + PI/2;
      diameter = sin(radians(deg))*ampR;
      stroke (sumR, 0, 0);
      noFill();
      rect (300 + x, 300 + tan(radians(deg))*ampR, diameter, diameter);
    }

    fill(255, 0, 0);
    text("RED 710 NM", 1290, 307); 
    text(sumR, 1286, 322);  


    // green

    for (int x = 0; x < 800; x = x + 5) {
      deg = deg + PI;
      diameter = sin(radians(deg))*ampG;
      stroke (0, sumG, 0);
      noFill();
      cross (300 + x, 525 + tan(radians(deg))*ampG, diameter);
    }

    fill(0, 255, 0);
    text("GREEN 510 NM", 1290, 350); 
    text(sumG, 1286, 365);


    // blue

    for (int x = 0; x < 800; x = x + 5) {
      deg = deg + TWO_PI;
      diameter = sin(radians(deg))*ampB;
      stroke (0, 0, sumB);
      noFill();
      ellipse (300 + x, 800 + tan(radians(deg))*ampB, diameter, diameter);
    }

    fill(0, 0, 255);
    text("BLUE 465 NM", 1290, 393); 
    text(sumB, 1286, 405);


    // options: text of description 

    fill(255, 255, 255);
    text("OPTIONS", 60, 67); 
    stroke(255);
    strokeWeight(0.5);
    line (59, 69, 97, 69); 

    fill(125, 125, 125);
    text("FADING OPTIONS", 60, 307); 
    text("KEY OPTIONS", 60, 342); 

    fill(255, 255, 255);
    text("S = SAVE AS PDF", 60, 355);
  }
}


// visual function: cross for mode 2

void cross(float x, float y, float d) {
  line(x, y, x, y-d);
  line (x, y, x+d, y);
  line(x, y, x, y+d);
  line(x, y, x-d, y);
}


// saving functions: save by pressing 's'

void keyPressed() {
  if (key == 's' || key == 'S') {
    record = true;
  }
}