class window extends PApplet{
  window(String name){
    super();
    PApplet.runSketch(new String[]{name},this);
  }
  int sizeX;
  int sizeY;
  void settings(){
  }
  void setup(){
  }
  void draw(){
  }
  void keyPressed(){
    KP(this);
  }
  void keyReleased(){
    KR(this);
  }
}
class fieldPart extends window{
  fieldPart(String name){
    super(name);
  }
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
   super("windowMob");
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
  int xcor = 0;
  int ycor = 0;
  void draw(){
    centerWindow();
    background(0);
    getSurface().setLocation(xcor = (windowPosX + round(target.xcor)),ycor = (windowPosY + round(target.ycor)));
        _draw(target.field.playerBullets,#FF0000);
        _draw(target.field.bullets,#1A03FC);
    fill(#00D81B);
    ellipse(sizeX / 2,sizeY / 2,target.displaySize,target.displaySize);
    if(codedKeys[cKeySHIFT]){
      fill(#FFFFFF);
      ellipse(sizeX/2,sizeY/2,target.size,target.size);
    }
  }
  void keyPressed(){
    KP(this);
  }
  void keyReleased(){
    KR(this);
  }
  void _draw(oneWayLinkedList<unit> x,color ccc){
    while(x.hasNext()){
      try{
      unit b = x.next();
      int trueXcor = int(b.xcor + centerX);
      int trueYcor = int(b.ycor + centerY);
      if(trueXcor < xcor + width && trueXcor >=xcor && trueYcor < ycor + height && trueYcor >= ycor){
        fill(ccc);
        ellipse(trueXcor - xcor,trueYcor - ycor,b.size,b.size);
      }
      }
      catch(NullPointerException e){
      }
    }
    
  }
}