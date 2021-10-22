import de.voidplus.leapmotion.*;
import processing.video.*;

Movie myMovie;
LeapMotion leap;
JSONObject json;
boolean captured = false;
boolean submitedPhoto = false;


void setup(){
  size(800, 500);
  background(255);
  leap = new LeapMotion(this);
}

void draw(){
  colorMode(RGB);
  if (captured || submitedPhoto){
     //background(0);
     fadeOutBackground();
     showSubmititionText();
     //processData();
  }else {
    //background(255);
    //backgroundFaded();
    fadeInBackground();
    addText();
  }
  
  int fps = leap.getFrameRate();
  for (Hand hand : leap.getHands ()) {
    PVector handPosition       = hand.getPosition();
    float   handGrab           = hand.getGrabStrength();
  
    captured  = handGrab > 0.9999999;
    
    if (captured && !submitedPhoto){
      submitedPhoto = true;
      float[] x = getPositions(handPosition);
      processData(x[0],x[1],x[2]);
    }
    
   drawHand(handPosition);
  }
}

void backgroundFaded(){
  
  for (int i = 0; i < width/2; i ++){
     int mapped = int(map(i, 0,width / 2,250,200));
     stroke(mapped);
     line(i,0,i,1000); 
  }
  for (int i = width/2; i < width; i ++){
     int mapped = int(map(i,width / 2 , width,200, 250));
     stroke(mapped);
     line(i,0,i,1000); 
  }
 
}




// HELPERS

void processData(float x ,float y, float z){
  json = new JSONObject();
  json.setFloat("x", x);
  json.setFloat("y", y);
  json.setFloat("z", z);
  saveJSONObject(json, "data/new.json");
}

void addText(){   
  fill(0);
  text("Figrative", 10, 250);
  text("Normative", 720,250);
  text("Landscape", 380,20);
  text(" Portrait", 380,480);
}

void showSubmititionText(){
  fill(200);

  text("Your request is being generated", width/2 - 70,height / 2);
}

void fadeInBackground(){ 
  noStroke(); // turn outlines off
  fill(255,100);
  rect(0, 0, width, height);  
}

void fadeOutBackground(){ 
  noStroke(); // turn outlines off
  fill(100, 100);
  rect(0, 0, width, height);  
}

void drawHand(PVector handPosition){
  colorMode(HSB);
  
  color from = color(100, 102, 0);
  color to = color(120, 102, 153);
  color lerped = lerpColor(from,to,0.5);
  
    //fill(random(100,130),200,200);
    fill(lerped);
    //println(handPosition.x,handPosition.y,handPosition.z);
    
    float zMapped = map(handPosition.z,-30, 150, 10, 200);
    float zMappedPrecent = map(handPosition.z,-30, 150, 0 , 1);
    
    ellipse(handPosition.x,handPosition.y,zMapped,zMapped);
}

float[] getPositions(PVector handPosition){
  
    float zMapped = map(handPosition.z,-30, 150, 10, 200);
    float zMappedPrecent = map(handPosition.z,-30, 150, 0 , 1);
    
    float yMapped = map(handPosition.y,-30, 150, 10, 200);
    float yMappedPrecent = map(handPosition.y,0, 1000, 0 , 1);
    
    float xMapped = map(handPosition.x,-30, 150, 10, 200);
    float xMappedPrecent = map(handPosition.x,0, 1000, 0 , 1);
    
    float[] ret = {xMappedPrecent,yMappedPrecent,zMappedPrecent};
    
    return ret;
}
