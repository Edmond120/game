class window extends PApplet{
  window(){
    super();
    PApplet.runSketch(new String[]{"window"},this);
  }
  int sizeX;
  int sizeY;
  void settings(){
  }
  void setup(){
  }
  void draw(){
  }
}
class windowMob extends window{
  //windowMob still needs a bit tuneing
  //either the equation is slightly off or there is a small percentage error due to only being to use ints when setting location
  unit target;
  windowMob(unit target){
   super();
   this.target = target;
 }
 void settings(){
    sizeX = int(2 * scale);
    sizeY = int(2 * scale);
    if(sizeY < 100){
      sizeY = 100;
    }
    if(sizeX < 100){
      sizeX = 100;
    }
    println(sizeX + " " + sizeY);
    size(sizeX,sizeY);
  }
  void setup(){
    frameRate(60);
    centerWindow();
    getSurface().setAlwaysOnTop(true);
    noLoop();
    //windowPosX += target.displaySize / 2;
    //windowPosY += target.displaySize / 2;
  }
  //pos of target
  //pos of main window, not pos of windowMob
  int windowPosX = ((displayWidth/2- mainWindow.width/2) - sizeX / 2);
  int windowPosY = ((displayHeight/2- mainWindow.height/2) - sizeY / 2);
  void draw(){
    centerWindow();
    background(0);
    fill(#00D81B);
    ellipse(sizeX / 2,sizeY / 2,target.displaySize,target.displaySize);
    if(codedKeys[cKeySHIFT]){
      fill(#FFFFFF);
      ellipse(sizeX/2,sizeY/2,target.size,target.size);
    }
    getSurface().setLocation(windowPosX + round(target.xcor),windowPosY + round(target.ycor));
  }
  void keyPressed(){
    KP(this);
  }
  void keyReleased(){
    KR(this);
  }
}