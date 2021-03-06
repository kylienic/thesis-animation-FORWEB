// Sketch by Kylie Nicholson

// preload commands for processing.js
/* @pjs preload="data/butterflies_350x458.jpg"; */

import controlP5.*;
ControlP5 cp5;

PImage input;       // Source image
PImage output;  // Destination image
int gutter_size = 300;
int frame_size = 20;
int startcont = 2; 

void setup() {
  size(700+(2*frame_size)+gutter_size, 400+(2*frame_size)+gutter_size);
  //input = loadImage("sunflower.jpg");  
  input = loadImage("data/butterflies_350x458.jpg");
  // Create an empty image with same dimensions as source
  output = createImage(input.width, input.height, RGB);
  cp5 = new ControlP5(this);
  
  cp5.addSlider("startcont")
     .setPosition(300,500)
     .setSize(200,20)
     //.setRange(0,2.0)//used to be 0 to 5, but this makes more sense visually 
     // I want to figure out how to display this as 0-100
     .setRange(0,100.0)
     //.setValue(1.0)
     .setValue(50.0)
     .setDecimalPrecision(2)
     .setColorCaptionLabel(0)
     .setCaptionLabel("Contrast") 
     .getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE).setPaddingX(0);
     ;
     
   cp5.addSlider("startbright")
    .setPosition(600,500)
    .setSize(200,20)
    .setRange(-255,255)
    .setValue(0)
    .setColorCaptionLabel(0)
    .setCaptionLabel("Brightness")
    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    ;
}

void draw() {  
  background(255);
  fill(0); 
  // 1. CALCULATE BRIGHTNESS BASED ON MOUSE LOCATION
  //float contrast = slider.value; 
  // float contrast = cp5.getController("startcont").getValue();  // current working version
  float contrast = (cp5.getController("startcont").getValue())/50;
  //float contrast = 5* ( mouseX / (float)width); //value should go from 0 to 5
  float bright = cp5.getController("startbright").getValue();
  //float bright = 255 * ( 3*mouseY / (float)height - 1); // change so range from black to white
  // print brightness
  
  //2. CALL CHANGE BRIGHTNESS FUNCTION WITH CALCULATED VALUE
  ChangeBrightness(input, output, contrast, bright); 
  
  // 3. DISPLAY IMAGE
  input.updatePixels();
  output.updatePixels();
  image(input,0+frame_size,0+frame_size-2);// frame_size-2 b/c it just looked better
  text("original", 0+frame_size+458-20, 0+frame_size-2+350+15);
  image(output,input.width+2*frame_size,0+frame_size-2); // frame_size-2 b/c it just looked better
  text("processed", 0+2*frame_size+2*458-10, 0+frame_size-2+350+15);
  
  /* //draw axes to illustrate what's going on
  //y axis
  line(width/2, 0, width/2, height);
  text("brightness ", width/2, 20);
  text(bright, width/2, 40);
  //x axis
  line(0, height/2, width, height/2);
  text("contrast: ", width-70, height/2-20);
  text(contrast, width-70, height/2);
*/
}
 void ChangeBrightness(PImage input2, PImage output2, float cont, float bright2) 
  { 
   //we assume the images are of equal dimension 
   //so test this here and if it's not true just return with a warning
   if(input2.width !=output2.width || input2.height != output2.height)
   {
     println("error: image dimensions must agree");
     return;
   }
   
  //loop through source pixels 
  for (int x = 0; x < input2.width; x++) {
    for (int y = 0; y < input2.height; y++ ) {
      // calculate pixel location
      int loc = x + y*input2.width;
      //BRIGHTNESS
      //float bright = 255 * ( 2*mouseY / (float)width - 1); // change so range from black to white
      color inColor = input2.pixels[loc];
      
      int r = (int) red(input2.pixels[loc]);
      int g = (int) green(input2.pixels[loc]);
      int b = (int) blue(input2.pixels[loc]);
      
      // brightness is linear arithmetic
      // contrast is multiplication, but normalize brightness we first subtract 128, multiply, then add back in. 
      // default brightness: 0
      // default contrast: 1
      r = (int)((r-128)*cont +128 + bright2); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
      g = (int)((g-128)*cont +128 + bright2);
      b = (int)((b-128)*cont +128 + bright2);
      
      /*
      // experiment with not adding back in 128 --> IAIP just subtract 100 don't add back in
      r = (int)((r-100)*cont + bright2); //floating point aritmetic so convert back to int with a cast (i.e. '(int)');
      g = (int)((g-100)*cont + bright2);
      b = (int)((b-100)*cont + bright2);*/
      
      // restricts values to between 0 and 255
      r = r < 0 ? 0 : r > 255 ? 255 : r;
      g = g < 0 ? 0 : g > 255 ? 255 : g;
      b = b < 0 ? 0 : b > 255 ? 255 : b;
      
      output.pixels[loc] = color(r,g,b);
    }
  }
 }
 
 /*void slider(float theColor) {
  myColor = color(theColor);
  println("a slider event. setting background to "+theColor);
} */
  
  /*input.updatePixels();
  output.updatePixels();
  // draw black borders
  fill(0);
  rect(18, 16, 204, 204);
  rect(238+gutter_size, 16, 204, 204);
  // display images, source then destination 
  image(source,0+frame_size,0+frame_size-2);// frame_size-2 b/c it just looked better
  image(destination,source.width+2*frame_size+gutter_size,0+frame_size-2); // frame_size-2 b/c it just looked better
  */


