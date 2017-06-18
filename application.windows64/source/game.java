import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.ArrayList; 
import java.awt.Robot; 
import processing.sound.*; 
import java.lang.Math; 
import javax.sound.sampled.*; 
import java.awt.event.KeyEvent; 
import java.awt.MouseInfo; 
import java.awt.Point; 
import java.io.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class game extends PApplet {












int levelnumber = 3; //maunually increase?
boolean[] levels = new boolean[levelnumber];


boolean muted = true;

//settings + variables
int scale = 20;
int fieldHeight;
int fieldWidth;
int frameSizeX;
int frameSizeY;
int centerX;
int centerY;
boolean debug = true;
public void settings(){
  //screen resolution ratio is 16:9
  //to do: store settings in file
  int x = displayWidth / 16;
  int y = displayHeight / 9;
  if(x > y){
    scale = y;
  }
  else{
    scale = x;
  }
  scale = (scale * 3) / 4;
  frameSizeX = 16 * scale;
  frameSizeY = 9 * scale;
  size(frameSizeX,frameSizeY);
  centerX = displayWidth/2-width/2;
  centerY = displayHeight/2-height/2;
  
  /*SAVE SYSTEM TEST
  SaveSystem a = new SaveSystem("savefile.txt");
  levels = a.load(levels);
  a.save();*/
}

//setup + variables
Robot robot;
PApplet mainWindow;
mode Mode;
int expectedFrameRate;
public void setup(){
  frameRate(60);
  mainWindow = this;
  expectedFrameRate = 60;
  surface.setResizable(true);
  centerWindow();
  //frame.setSize(1000,1000);
  //frame.setLocation(100,100);
  Mode = new mainMenu();
  //Mode = new experimentTestEnironment();
  //Mode = new gameOver();
  //Mode = new tempTestEnvironment();
  //Mode = new robotTestEnvironment();
  //Mode = new pushedTestEnvironment();
  //Mode = new soundTestEnvironment();
  //Mode = new sizeTestEnvironment();
  //Mode = new delayAndCooldownTestEnvironment();
  //Mode = new scrapTestEnvironment();
  //Mode = new OneWayLinkedListTestEnvironment();
  //Mode = new newWindowTestEnvironment();
  //Mode = new giantWormBossTestEnvironment();
  //Mode = new oneWayLinkedListTestEnvironment(); 
  //Mode = new giantWormBossLevel();
  //Mode = new Metropolis();
  //Mode = new attractorTestEnvironment();
  Mode._setup();
  try{
  robot = new Robot();
  }
  catch(Throwable e){
    e.printStackTrace();
  }
}

//draw + variables
int tick = 0;
boolean pmousePressed;
public void draw(){
  //try{
    Mode.tick();
    pmousePressed = mousePressed;
    tick++;
  //}
  //catch(Throwable e){
   // e.printStackTrace();
  //  noLoop();
  //}
}

//keyboard + variables
char[]_keys = {'z','x','c','w','a','s','d','v','b','n','m','l','k','j'};
int keyZ = 0;int keyX = 1;int keyC = 2;int keyW = 3;int keyA = 4;int keyS = 5;int keyD = 6;int keyV = 7;int keyB = 8;int keyN = 9;int keyM = 10;int keyL = 11;int keyK = 12;int keyJ = 13;
boolean[]keys = new boolean[_keys.length];
int[] _codedKeys = {UP,DOWN,LEFT,RIGHT,SHIFT,CONTROL,ALT};
int cKeyUP = 0;int cKeyDOWN = 1;int cKeyLEFT = 2;int cKeyRIGHT = 3;int cKeySHIFT = 4;int cKeyCONTROL = 5;
int cKeyALT = 6;
boolean[]codedKeys = new boolean[_codedKeys.length];
int keyPushed;/*Most recent key that was pushed. A push is the process of pressing AND releasing a key.
Only needs to be checked in keyReleased() because a key must be already pressed to be released.*/
boolean codedAndPushed = false;/*True if the last key pushed was coded or not. 
False if there is a key pushed right now. Set to false at draw*/
//^^^ the function these are used for are located at the tab helper

int releasedTick;
public void KP(PApplet x){
  checkKey(true,x);
}
public void KR(PApplet x){
  releasedTick = tick;
  if(x.key == CODED){
    //System.out.println(keyCode + " Coded");
    keyPushed = x.keyCode;
    codedAndPushed = true;
  }
  else{
    //System.out.println(key + " normal");
    keyPushed = x.key;
    codedAndPushed = false;
  }
  checkKey(false,x);
}
public void keyPressed(){
  KP(mainWindow);
}
public void keyReleased(){
  KR(mainWindow);
}
public void checkKey(boolean setValue,PApplet x){
  if(x.key == CODED){
    for(int i = 0; i < _codedKeys.length;i++){
      if(x.keyCode == _codedKeys[i]){
        codedKeys[i] = setValue;
        return;
      }
    }
    if(debug){System.out.println(keyCode);}
  }
  else{
    for(int i = 0; i < keys.length;i++){
      if(java.lang.Character.toLowerCase(x.key) == _keys[i]){
        keys[i] = setValue;
        return;
      }
    }
    if(debug){System.out.println(key);}
  }
}
class flipbook{
 //constructors + variables
 PImage[]book;
 flipbook(PImage[] book){
   this.book = book;
 }
 flipbook(String imageName,String end,int size){
   book = new PImage[size];
   for(int i = 0; i < size; i++){
     book[i] = loadImage(imageName + i + end);
   }
 }
 
 //methods + variables
 int index = 0;
 public boolean hasNext(){
   if(index >= book.length){
     rewind();
     return false;
   }
   else{
     return true;
   }
 }
 public PImage next(){
   return book[index++];
 }
 public void rewind(){
   index = 0;
 }
}
interface fx{
  public void _draw();
}
class attractor implements fx{
  PGraphics layer2;
  attractor(){layer2 = createGraphics(width,height);
}
  attractor(int x,int y){layer2 = createGraphics(x,y);
}
  oneWayLinkedList<PVector> dust = new oneWayLinkedList<PVector>();
  int colour;
  delay Delay;
  float r;
  PVector target;
  float force;
  public void setForce(float s){
    force = s * scale;
  }
  public void setTarget(PVector t){
    target = t.copy();
  }
  public void setFade(float r){
    this.r = r;
  }
  public void setDelay(delay d){
    Delay = d;
  }
  public void setColour(int c){
   colour = c; 
  }
  
  public void _setup(){
     for(int i = PApplet.parseInt((width * height)/1000); i > 0;i--){
      dust.add(new PVector(PApplet.parseInt(random(width)),PApplet.parseInt(random(height))));
     }
     println(dust.size);
  }
  public void _draw(){
    layer2.beginDraw();
    //if(Delay.every()){
      //fade(layer2,r);// not working?!?!
    //}
    layer2.stroke(colour);
    while(dust.hasNext()){
      PVector p = dust.next();
      PVector dist = PVector.sub(target,p);
      if(dist.mag() <= 10){
        dust.remove();
      }
      p.add(dist.setMag(force/(dist.mag()*dist.mag())));
      layer2.point(p.x,p.y);
      //rect(p.x,p.y,10,10);
    }
    layer2.endDraw();
    image(layer2,0,0);
  }
}


class Animation extends unit{
  public boolean hitCheckCircle(bullet Bullet){return false;}
  //constructor + variables
  flipbook movie;
  delay wait;
  PImage currentImage;
  Animation(battleMode field,flipbook movie,int xcor,int ycor,int size,int _delay){//_delay is in 60ths of a second
    this.field = field;
    this.movie = movie;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    wait = new delay(_delay);
    if(movie.hasNext()){
      currentImage = movie.next();
    }
    else{
      currentImage = loadImage("error.png");
    }
  }
  public float getXcor(){return xcor;}
  public float getYcor(){return ycor;}
  public void setXcor(float x){xcor = x;};
  public void setYcor(float x){ycor = x;};
  //methods
  public boolean update(){
   return update(xcor,ycor,mainWindow); 
  }
  public boolean update(float xcor, float ycor,PApplet applet){
    if(!wait.every()){
      applet.image(currentImage,xcor,ycor,size,size);
      return false;
    }
    if(movie.hasNext()){
      applet.image(currentImage = movie.next(),xcor,ycor,size,size);
      return false;
    }
    else{
      return true;
    }
  }
  public void trueDraw(float xcor,float ycor,PApplet applet){
    update(xcor,ycor,applet);
  }
}
interface shape{
  public float getXcor();public float getYcor();
  public void setXcor(float x);public void setYcor(float x);
}
interface circle extends shape{
 public float getSize();
 public void setSize(float x);
}
interface rectangle extends shape{
  public float getSizeX();      public float getSizeY();      public float getAngle();
  public void setSizeX(float x);public void setSizeY(float x);public void setAngle(float x);
}
abstract class entity implements shape{
  public abstract float getXcor();
  public abstract float getYcor();
  public abstract void setXcor(float x);
  public abstract void setYcor(float x);
  entity parent = null;
  float xcor;
  float ycor;
  public boolean update(){
    //true if unit is to be removed
    return false;
  }
  public boolean update(oneWayLinkedList<unit> x){//this is for interaction with other entitys
    //true if unit is to be removed
    return false;
  }
  public void _draw(){
    trueDraw(getXcor(),getYcor(),mainWindow);
  }
  public void trueDraw(float xcor, float ycor,PApplet applet){ 
  }
}

abstract class unit extends entity{
  unit(){}
  unit(battleMode field,float xcor,float ycor){
    this(null,field,xcor,ycor);
    scaleVars();
  }
  unit(entity parent,battleMode field,float xcor,float ycor){
   this.parent = parent;this.field = field;this.xcor = xcor;this.ycor = ycor;
  }
  public abstract boolean hitCheckCircle(bullet Bullet);/*{bullet is cicular
    return Bullet.strikeCircle(this);
  }*/
  battleMode field;
  int health;
  int points;
  float size;
  float radius;
  float displaySize;
  public void scaleVars(){
    size *= scale;
    radius = size / 2;
    if(displaySize == 0){
      displaySize = size;
    }
    else{
      displaySize *= scale;
    }
    xcor *= scale;
    ycor *= scale;
  }
  public void death(){
  }
}

class battleMode extends mode{
  int _width = width;
  int _height = height;
  PApplet selectedWindow = mainWindow;
  oneWayLinkedList<unit> bullets = new oneWayLinkedList<unit>();
  oneWayLinkedList<unit> playerBullets = new oneWayLinkedList<unit>();
  oneWayLinkedList<unit> enemies = new oneWayLinkedList<unit>();
  oneWayLinkedList<unit> players = new oneWayLinkedList<unit>();
  oneWayLinkedList<unit> anime = new oneWayLinkedList<unit>(); //this "anime" stands for animation, not the anime anime (lol)
  oneWayLinkedList[] drawables = {anime,playerBullets,enemies,players,bullets};
  public void _setup(){
   
  }
  public void _background(PApplet applet){
    applet.background(0);
  }
  public void tick(){
    _background(selectedWindow);
    try{
    update(playerBullets,enemies);
    update(bullets,players);
    update(players);
    update(enemies);
    
    //note, animations don't use the _draw method, update includes draw. 
    update(anime);
    //Hence it must be placed in between the update and draw methods.
    //update: anime._draw() now calls anime.update()
    
    _draw(playerBullets);
    _draw(enemies);
    _draw(players);
    _draw(bullets);
    }
    catch(NullPointerException e){
    }
  }
  public void update(oneWayLinkedList<unit> a, oneWayLinkedList<unit> b){
    while(a.hasNext()){
      if(a.next().update(b)){
        a.getCurrent().death();
        a.remove();
      }
    }
    
  }
  public void update(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      if(x.next().update()){
        x.getCurrent().death();
        x.remove();
      }
    }
    
  }
  public void _draw(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      x.next()._draw();
    }
    
  }
}
class giantWormBossLevel extends battleMode{
  wormHead head;fieldPart fp;
  charge coilAttack = new charge(3);
  public @Override
  void _setup(){
    super._setup();
    testunitA xxx = new testunitA(this,0.5f,0.5f,0.20f,0.5f);
    players.add(xxx);
    xxx.health = 100000;
    head = makeWorm(this);
    fp = createFieldPart(this,"worm",PApplet.parseInt(4 * scale),PApplet.parseInt(4*scale),PApplet.parseInt(head.getXcor() + centerX),PApplet.parseInt(head.getYcor() + centerY),true);
  }
  public @Override
  void tick(){
    super.tick();
    //println(head.getAngle());
    if(keys[keyN]){
     head.accelerate(head.accel); 
    }
    if(keys[keyB]){
      head.turnRight(head.turnRate);
    }
    if(keys[keyV]){
      head.turnLeft(head.turnRate);
    }
    if(keys[keyM]){
      head.decelerate(head.decel);
    }
    if(keys[keyL]){
      wormBossOpening += -0.1f * scale;
    }
    if(keys[keyK]){
      wormBossOpening += 0.3f * scale;
      if(wormBossOpening > 0){
       wormBossOpening = 0; 
      }
    }
    if(coilAttack.cooldown(keys[keyJ])){
     head.nodeCommand = new wormNodeCoil()._setup(head);
    }
    if(!out){
      if(head.getXcor() < 0 || head.getXcor() > width || head.getYcor() < 0 || head.getYcor() > height){
        out = true;
        fp.vis();
      }
    }
    else{
      if(head.getXcor() >= 0 && head.getXcor() <= width && head.getYcor() >= 0 && head.getYcor() <= height){
       out = false;
       fp.invis();
      }
    }
    checkDisplayBounds(head.location);
    centerWindow(mainWindow);
    fp.setLocation(PApplet.parseInt(head.getXcor() + centerX - fp.width/2),PApplet.parseInt(head.getYcor() + centerY - fp.height/2));
  }
  boolean out = false;
}
                       //sizeX,sizeY,angle,health,segments
float[] wormBossStats = {1,    0.5f,  0,    2000,  16};
float wormBossOpening = 0 * scale;
float endFriction = 0.90f;
float constantFriction = 0.90f;
boolean snap = false;
boolean useConstantFriction = true;
public wormHead makeWorm(battleMode field){
  float[]s = wormBossStats;
  wormHead head = new wormHead(field,width/scale - s[0]/2,s[1]/2,s[0],s[1],s[2],PApplet.parseInt(s[3]));
  wormSegment currentSegment = head.backNode.createSegment(s[0]*scale,s[1]*scale,s[2],PApplet.parseInt(s[3]));
  for(int n = 0;n < s[4] - 2;n++){
    currentSegment = currentSegment.createBackNode().createSegment(s[0]*scale,s[1]*scale,s[2],PApplet.parseInt(s[3]));
  }
  wormTail tail = currentSegment.createBackNode().createTail(s[0],s[1],s[2],PApplet.parseInt(s[3]));
  wormNode currentNode = head.backNode;
  for(int n = 0;n < s[4] - 1;n++){
    field.enemies.addLast(currentNode);
      currentNode.friction = 1 - n*((1 - endFriction)/s[4]);
    
    currentNode = currentNode.backSegment.backNode;
  }
   field.enemies.addLast(tail.backNode);//debug
   field.enemies.addLast(tail);
  currentSegment = head.backNode.backSegment;
  for(int n = 0;n < s[4] - 2;n++){
    field.enemies.addLast(currentSegment);
    currentSegment = currentSegment.backNode.backSegment;
  }
  field.enemies.addLast(head);
  currentNode = head.backNode;
  while(currentNode.backSegment != null){
    currentNode.leader = head;
    currentNode.backSegment.leader = head;
    currentNode = currentNode.backSegment.backNode;
  }
  return head;
}
abstract class wormSegmentCommand{
  public abstract void tick(wormSegment x);
  public wormSegmentCommand _setup(wormHead x){
    return this;
  }
  public void end(wormHead x){
  }
}
abstract class wormNodeCommand{
  public abstract void tick(wormNode x);
  public wormNodeCommand _setup(wormHead x){
    return this;
  }
  public void end(wormHead x){
  }
  public void headMove(wormHead x){
  }
}
class wormSegmentMove extends wormSegmentCommand{
  public void tick(wormSegment x){
    x.move();
  }
}
class wormNodeMove extends wormNodeCommand{
  public void tick(wormNode x){
    x.move();
  }
  public void headMove(wormHead x){
   x.move(); 
  }
}
class wormNodeCoil extends wormNodeCommand{
 public void tick(wormNode x){
    x.move();
 }
 attractor xx;
 public wormNodeCommand _setup(wormHead x){
  useConstantFriction = true;
  constantFriction = 0.7f;
  x.limit = (40.0f/90)*scale;
  x.velocity.setMag(0);
  //accel = (x.limit - x.velocity.mag())/(2.5 * expectedFrameRate);
  accel = (x.limit)/(2.5f * expectedFrameRate);
  decel = (x.limit)/(2.5f * expectedFrameRate);
  xx = new attractor();
  xx._setup();
  xx.setForce(50);
  xx.setDelay(new delay(0.1f));
  xx.setTarget(new PVector(x.getXcor(),x.getYcor()));
  xx.setFade(0.90f);
  xx.setColour(color(255));
  x.fxEffects = xx;
  return this;
 }
 float accel,decel;
 charge coilTime = new charge(5.5f);
 charge phase1 = new charge(2.5f);
 charge phase2 = new charge(1.5f);
 float r = 8;
 float rChange = (10.125f - 8)/(1.5f * expectedFrameRate);
 public void headMove(wormHead x){
   if(coilTime.cooldown()){
     x.faceTarget();
     x.attackMode = x.ATTACKREADY;
     x.fxEffects = null;
     for(int i = 0; i < 360; i++){
       x.field.bullets.add(new normalBullet(x,x.field,xx.target.copy(),PVector.fromAngle(radians(random(360))).setMag(random((25.0f/45)*scale) + 0.1f * scale),0.2f * scale,10));
     }
     x.chooseCommand();
   }
   else{
     if(!phase1.cooldown()){
       x.accelerate(accel);
       x.turnRight(r); 
       x.field.bullets.add(new normalBullet(x,x.field,xx.target.copy(),PVector.fromAngle(radians(random(360))).setMag((30.0f/90)*scale),0.2f * scale,10));
     }
     else{
       if(!phase2.cooldown()){
         r += rChange;
         x.turnRight(r);
       }
       else{
         x.decelerate(decel);
         x.turnRight(r);
       }
     }
   }
   x.move();
 }
}
class wormHead extends wormSegment{
  fx fxEffects = null;
  wormHead(battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
    this(null,field,xcor,ycor,sizeX,sizeY,angle,health);
    scaleVars();
    //frontNode = new wormNode(this,field,xcor + sizeX/2 + nodeSize/2,ycor,nodeSize,int(health * 0.75));
    backNode = new wormNode(null,field,this.xcor - cos(radians(this.angle))*((this.sizeX + getSizeY())/2),this.ycor - sin(radians(this.angle))*((this.sizeX + getSizeY())/2),getSizeY(),PApplet.parseInt(health * 0.75f),this);
  }
  wormHead(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
     
   }
   wormSegmentCommand segmentCommand = new wormSegmentMove();
   wormNodeCommand nodeCommand = new wormNodeMove();
   public wormSegmentCommand getSegmentCommand(){
     return segmentCommand;
   }
   public wormNodeCommand getNodeCommand(){
     return nodeCommand;
   }
   unit target;
   public unit findTarget(){
     oneWayLinkedListKey<unit> k = field.players.createKey();
     int r = PApplet.parseInt(random(field.players.size)) + 1;
    for(int i = 0; i < r; i++){
      if(field.players.hasNext(k)){
       field.players.next(k); 
      }
      else if(debug){
       println("bosses, unit findTarget(), linkedList error"); 
      }
    }
    return field.players.getCurrent(k);
   }
   public void trueDraw(float xcor,float ycor,PApplet applet){
    super.trueDraw(xcor,ycor,applet);
    if(fxEffects != null && applet == mainWindow){
      fxEffects._draw();
    }
   }
   public void faceTarget(){
    if(target == null){
     target = findTarget();
     if(target == null && debug){
       println("bosses, void faceTarget(), findTarget error");
     }
    }
    angle = degrees((new PVector(target.getXcor(),target.getYcor())).sub(location).heading());
    velocity = PVector.fromAngle(radians(angle)).mult(velocity.mag());
   }
   final int PASSIVE = 0;
   final int ATTACKREADY = 1;
   int attackMode = PASSIVE;
   float limit = (25.0f/90)*scale;
   float accel = (0.1f/90)*scale;// 90 is the scale on my computer - edmond
   float decel = (0.2f/90)*scale;
   float turnRate = 4;//10.125;
   public void chooseCommand(){
     switch(attackMode){
      case ATTACKREADY:
          nodeCommand = new wormNodeMove()._setup(this);
          limit = (50.0f/90) * scale;
          //faceTarget();
          accelerate((50.0f/90) * scale);
     }
   }
   public void accelerate(float x){
     float speed = velocity.mag();
     if(speed + x < 0){
       velocity.setMag(0);
       return;
     }
     if(speed == 0){
      velocity = PVector.fromAngle(radians(angle));
      velocity.setMag(x);
      return;
     }
     if(speed < limit){
       if(speed + x < limit){
         velocity.setMag(speed + x);
       }
       else{
         velocity.setMag(limit);
       }
     }
     else{
       velocity.setMag(limit);
     }
   }
   public void decelerate(float x){
    accelerate(-1*x); 
   }
   public void move(){
     setXcor(getXcor() + velocity.x);
     setYcor(getYcor() + velocity.y);
     setBackNode();
   }
   public boolean update(){
     nodeCommand.headMove(this);
     contactDamage();
     return false;
   }
   public void turnLeft(float degrees){//degrees is less than 90
     angle -= degrees;
     velocity.rotate(radians(-1*degrees));
   }
   public void turnRight(float degrees){//degress is less than 90
     angle += degrees;
     velocity.rotate(radians(degrees));
   }
}
class wormTail extends wormSegment{
  wormTail(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
     createBackNode();
   }
   public boolean update(){
     //backNode.update();
     return super.update();
   }
}
class wormNode extends unit implements circle{
  wormHead leader = null;
  PVector location;
  PVector targetLocation;
  float friction = 1;
  wormSegment frontSegment,backSegment;
  PVector velocity = new PVector(0,0);
  //float limit = 10;//change limit in wormSegment too
  public float getXcor(){return location.x;}
  public float getYcor(){return location.y;}
  public float getSize(){return size;}
  public void setXcor(float x){location.x = x;}
  public void setYcor(float x){location.y = x;}
  public void setSize(float x){size = x;}
  
  public void contactDamage(){
     while(field.players.hasNext(_key)){
       unit target = field.players.next(_key);
       if(target instanceof circle && circleXcircle((circle)target,this)){
           hit(target);
       }
     }
   }
   public void hit(unit x){
    x.health -= 10; 
   }
  public boolean hitCheckCircle(bullet Bullet){
    if(backSegment != null){//last node (tail node) does not technically exist
      return Bullet.strikeCircle(this);
    }
    else{
      return false;
    }
  }
  oneWayLinkedListKey _key;
  public wormSegment createSegment(float sizeX,float sizeY,float angle,int health){
    PVector l = PVector.add(location,PVector.fromAngle(radians(angle + 180)).mult((sizeX + getSize())/2));
    wormSegment newSegment = new wormSegment(this,field,l.x,l.y,sizeX,sizeY,angle,health);
    newSegment.frontNode = this;
    backSegment = newSegment;
    return newSegment;
  }
  
  public wormTail createTail(float sizeX,float sizeY,float angle,int health){
    PVector l = PVector.add(location,PVector.fromAngle(radians(angle + 180)).mult((sizeX + getSize())/2));
    wormTail newSegment = new wormTail(this,field,l.x,l.y,sizeX,sizeY,angle,health);
    newSegment.frontNode = this;
    backSegment = newSegment;
    return newSegment;
  }
  //entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health
  wormNode(wormNode parent,battleMode field,float xcor,float ycor,float size,int health,wormSegment frontSegment){
    super(parent,field,xcor,ycor);
    this.size = size;this.health = health;
    location = new PVector(xcor,ycor);
    this.frontSegment = frontSegment;
    _key = field.players.createKey();
  }
  public boolean update(){
    if(parent != null){
       leader.getNodeCommand().tick(this);
    }
    contactDamage();
    return false;
  }
  public void move(){
    if(velocity.mag() < 0.15f){//friction
     velocity.set(0,0); 
    }
    else{
     if(useConstantFriction){
       velocity.mult(constantFriction);
     }
     else{
       velocity.mult(friction); 
     }
    }
    location.add(velocity);
    wormNode p = ((wormNode)parent);
    PVector targetLocation = p.location;
    PVector difference = PVector.sub(targetLocation,location);
    difference.setMag(difference.mag() - frontSegment.getSizeX() - (getSize() + (p.getSize()))/2 + wormBossOpening);
    velocity.add(difference);
    location.add(difference);
    PVector angle1 = PVector.fromAngle(radians(frontSegment.getAngle()));
    PVector angle2 = PVector.fromAngle(radians(p.frontSegment.getAngle()));
    float diff = angle2.heading() - angle1.heading();
    //println(tan(radians(p.frontSegment.getAngle())));
    if(abs(diff) > HALF_PI){
      //float t = tan(radians(p.frontSegment.getAngle()));
      //pDir = dir;
      //dir = (t > 0);
        //dir = true;
        //boolean x = diff > 0;
        //if(pDir != dir){x = !x; dir = false;}
        
        //if(keys[keyM]){
        //  x = !x;
        //}
       // PVector oldLocation = location;
       if(snap){
        if(diff <= 0){
          PVector a = new PVector(-angle2.y,angle2.x).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
         location = a;
        }
        else if (diff > 0){
          PVector b = new PVector(-angle2.y,angle2.x).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
         location = b;
        }}
        //println(100.0 / scale);
        //if(abs(getYcor() - pycor) > 1 * scale){
         // location = oldLocation;
        //}
      /*}
      else{
       boolean x = diff > 0;
       if(dir){x = !x; dir = false;}
        if(x){
         location = angle2.rotate(HALF_PI).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
        }
        else{
         location = angle2.rotate(-1*HALF_PI).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
        }
      }*/
    }
    pxcor = getXcor();
        pycor = getYcor();
  }
  float pxcor;
  float pycor;
  public @Override
  void _draw(){
   trueDraw(location.x,location.y,mainWindow); 
  }
  public @Override
  void trueDraw(float xcor,float ycor,PApplet applet){
    if(backSegment == null){return;}
    applet.fill(0xff300DFF);
    applet.stroke(0xff300DFF);
    applet.ellipse(xcor,ycor,size,size);
  }
}
class wormSegment extends unit implements rectangle{
  wormHead leader = null;
  PVector velocity = new PVector(0,0);
  PVector location;
   wormNode frontNode;
   wormNode backNode;
   //float nodeSize = 0.5 * scale;
   float velocityX = 0;
   float velocityY = 0;
   float angle,sizeX,sizeY;
   public float getXcor(){return location.x;}
   public float getYcor(){return location.y;}
   public float getSizeX(){return sizeX;}
   public float getSizeY(){return sizeY;}
   public float getAngle(){return angle;}
   public void setXcor(float x){location.x = x;}
   public void setYcor(float x){location.y = x;}
   public void setSizeX(float x){sizeX = x;}
   public void setSizeY(float x){sizeY = x;}
   public void setAngle(float x){angle = x;}
   public boolean hitCheckCircle(bullet Bullet){
    return Bullet.strikeRectangle(this);
   }
   wormSegment(){}
   wormSegment(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor);
     this.sizeX = sizeX;this.sizeY = sizeY;this.health = health;this.angle = angle;
     location = new PVector(xcor,ycor);
     _key = field.players.createKey();
   }
   oneWayLinkedListKey<unit> _key;
   public wormNode createBackNode(){
    return backNode = new wormNode(frontNode,field,this.xcor - cos(radians(this.angle))*((this.sizeX + getSizeY())/2),this.ycor - sin(radians(this.angle))*((this.sizeX + getSizeY())/2),getSizeY(),PApplet.parseInt(health * 0.75f),this); 
   }
   public boolean update(){
     leader.getSegmentCommand().tick(this);
     contactDamage();
     return false;
   }
   public void contactDamage(){
     while(field.players.hasNext(_key)){
       unit target = field.players.next(_key);
       if(target instanceof circle && circleXrectangle((circle)target,this)){
           hit(target);
       }
     }
   }
   public void hit(unit x){
    x.health -= 10; 
   }
   public void move(){
     angle = degrees(PVector.sub(frontNode.location,backNode.location).heading());
     //location = PVector.fromAngle(radians(angle)).mult(((backNode.getSize() + getSizeX())/2)).add(backNode.location);
     location = PVector.add(frontNode.location,backNode.location).mult(0.5f);
   }
   public void scaleVars(){
    super.scaleVars();
    sizeX *= scale;
    sizeY *= scale;
    location.mult(scale);
   }
   public void setBackNode(){
    backNode.setXcor(getXcor() - cos(radians(angle))*((sizeX + backNode.getSize())/2));
    backNode.setYcor(getYcor() - sin(radians(angle))*((sizeX + backNode.getSize())/2)); 
   }
   public @Override
   void _draw(){
       trueDraw(location.x,location.y,mainWindow); 
   }
   public @Override
   void trueDraw(float xcor,float ycor,PApplet applet){
     applet.pushMatrix();
     applet.stroke(0xff00F2FC);
     applet.fill(0xffFFFFFF);
     applet.translate(xcor,ycor);
     applet.rotate(radians(angle));
     applet.rect(sizeX/-2,sizeY/-2,sizeX,sizeY);
     applet.popMatrix();
   }
}





class Metropolis extends battleMode{
  public @Override
  void _setup(){
    super._setup();
    player a = new testunitA(this,0.5f,0.5f,0.20f,0.5f);
    players.add(a);
    enemies.add(new Lula(this,10,5,0.4f,0.6f,a));
    //enemies.add(BunBun(Lula,stuff));
    //Lula.setChild(BunBun);
  }
  public @Override
  void tick(){
    super.tick();
  }
}
class Lula extends unit implements rectangle{
  public void setChild(Lula _child){
    this.child = _child;
  }
  
  public float getXcor(){return location.x;}
  public float getYcor(){return location.y;}
  public float getSizeX(){return sizeX;}
  public float getSizeY(){return sizeY;}
  public float getAngle(){return radians(0);}
  public void setXcor(float x){xcor = x;}
  public void setYcor(float x){ycor = x;}
  public void setSizeX(float x){sizeX = x;}
  public void setSizeY(float x){sizeY = x;}
  public void setAngle(float x){float angle = x;}
  public boolean hitCheckCircle(bullet Bullet){
     return Bullet.strikeRectangle(this);
  }
  
  
  float sizeX,sizeY;
  float mvtspeed = 2;
  PVector ploc;
  PVector location;
  PVector velocity;
  boolean[] ActOptions = new boolean[5]; //0 p>2.5x, 1 p>1.5x, 2 p>r, 3 is BunBun alive?
  boolean[] isAttackingStill = new boolean[5]; //0 miniCBs, 1 DuoAttack
  Lula child;
  boolean alive = true;
  boolean indanger;
  entity player;
  
  Lula(battleMode field,float xcor,float ycor,float _width,float _height,entity player){
    super();
    this.field = field;
    this.sizeX = _width*scale;
    this.sizeY = _height*scale;
    location = new PVector(xcor*scale,ycor*scale);
    velocity = new PVector(0,0);
    this.player = player;
    ploc = new PVector(player.getXcor(),player.getYcor());
    health = 100;
    setXcor(xcor*scale);
    setYcor(ycor*scale);
  }
  Lula(){}
  
  
  public void getVelocityTo(float _speed){
    PVector direction = ploc.sub(location);
    direction.normalize();
    direction.mult(-1*_speed);
    velocity = direction;
  }
  
  public void actions(){
    if (ActOptions[0]){
      attack();
    }
    if(ActOptions[1]){
      if(isAttackingStill[0]){
        attack();
      }else{
        if((int)(Math.random()*3) == 0){
          attack();
          move();
        }else{
          move();
        }
      }
    }
    if(ActOptions[2]){
      move();
    }
    if(indanger){
      if(isAttackingStill[1]){
        //DuoAttack();
      }else{
        //DuoAttack();
      }
    }
  }
  
 
  public void move(){
    getVelocityTo(mvtspeed);
    /*if(abs(location.x-0)<abs(location.y-0) || 
       abs(location.x-0)<abs(location.y-height) || 
       abs(location.x-width)<abs(location.y-0) || 
       abs(location.x-width)<abs(location.y-height)){
      PVector a = new PVector(-1*velocity.y, velocity.x);
      location.add(a);
      System.out.println(location);
    }else{
      PVector b = new PVector(velocity.y,-1*velocity.x);
      location.add(b);
      System.out.println(location);
    }*/
    location.add(velocity);
  }
  
  charge basic = new charge(4);
  charge special = new charge(7);
  charge basiclength = new charge(0.5f);
  int miniCBamt = 0;
  public void attack(){
    if(isAttackingStill[0]){
      if(basiclength.cooldown()){
        basiclength.resetCooldown();
        throwMiniCB();
        miniCBamt++;
      }
      if(miniCBamt == 3){
        basiclength.resetCooldown();
        miniCBamt = 0;
        isAttackingStill[0] = false;
      }
    }else{
      if(basic.cooldown()){
        basic.resetCooldown();
        throwMiniCB();
        miniCBamt++;
        isAttackingStill[0] = true;
      }else{
        if(special.cooldown()){
          special.resetCooldown();
          throwBigCB();
        }
      }
    }
  }
  
  public void bunBunDied(){
    this.ActOptions[4] = false;
    this.health = 15;
  }
  
  public void checkStatus(){//in boundscheck check if ActOptions[4] then checkStatus()
    alive = child.alive;
    if(!alive){
      bunBunDied();
    }
  }
  
  public void death(){}
  public void throwMiniCB(){
    field.bullets.add(createMiniCB());
  }
  public bullet createMiniCB(){//gotta modify this
    return new CB(this,field,getXcor(),getYcor(),0.2f * scale,ploc.sub(location).normalize(),10, ploc);
  }
  public void throwBigCB(){
    field.bullets.add(createBigCB());
  }
  public bullet createBigCB(){//gotta modify this
    return new CB(this,field,getXcor(),getYcor(),0.4f * scale,ploc.sub(location).normalize(),20, ploc);
  }
  public void DuoAttack(){}
  float r = 2*scale;
  public void boundsCheck(){
    if(abs(ploc.x-getXcor())+abs(ploc.y-getYcor())<(4.5f*r)){
      ActOptions[0] = false;
      if(abs(ploc.x-getXcor())+abs(ploc.y-getYcor())<(2.5f*r)){
        ActOptions[1] = false;
        if(abs(ploc.x-getXcor())+abs(ploc.y-getYcor())<r){
          ActOptions[2] = false;
          indanger = true;
        }else{ActOptions[2] = true;}
      }else{ActOptions[1] = true;ActOptions[2] = false;}
    }else{ActOptions[0] = true;ActOptions[1] = false;ActOptions[2] = false;}
    
    if(ActOptions[3]){
      checkStatus();
    }
    
    if(location.x<0){
      location = new PVector(0,location.y);
    }
    if(location.x>width){
      location = new PVector(width,location.y);
    }
    if(location.y<0){
      location = new PVector(location.x,0);
    }
    if(location.y>height){
      location = new PVector(location.x,height);
    }
  }
  
  public boolean update(){ 
    if(ActOptions[4] == false && health < 0){return true;}
    ploc = new PVector(player.getXcor(), player.getYcor());
    boundsCheck(); //checks if Lula's on screen and updates ActOptions
    actions();
    return false;
  }
  public @Override
  void trueDraw(float xcor,float ycor,PApplet applet){
    pushMatrix();
    stroke(0xff000000);
    fill(0xffE07407);
    translate(xcor,ycor);
    rotate(radians(0));
    rect(sizeX/-2,sizeY/-2,sizeX,sizeY);
    popMatrix();
  }
}

class CB extends bullet implements circle{
  //constructors + variables
  public float getXcor(){return location.x;}
  public float getYcor(){return location.y;}
  public float getSize(){return size;}
  public void setXcor(float x){xcor = x;}
  public void setYcor(float x){ycor = x;}
  public void setSize(float x){size = x;}
  public boolean hitCheckCircle(bullet Bullet){
    throw new UnsupportedOperationException();
  }
  
  int damage;
  float[] vector = new float[2];
  int colour = 0xffFF0000;
  PVector location;
  PVector velocity;
  PVector ploc;
  CB(){
  }
  CB(entity parent,battleMode field,float xcor,float ycor,float size,PVector vector,int damage,PVector _ploc){
    this.parent = parent;
    this.field = field;
    location = new PVector(xcor,ycor);
    this.size = size;
    this.radius = this.size / 2;
    velocity = vector;
    this.damage = damage;
    this.displaySize = this.size;
    ploc = _ploc;
    setXcor(xcor);
    setYcor(ycor);
    velocity.mult(scale*0.13f);
  }
  CB(battleMode field,float xcor,float ycor,float size,PVector vector,int damage,PVector ploc){
    this(null,field,xcor,ycor,size,vector,damage,ploc);
    scaleVars();
  }
  public void scaleVars(){
   super.scaleVars();
   velocity.mult(scale*2);
  }
  
  //methods
  public boolean hit(unit target){
    target.health -= damage;
    return true;
  }
  public boolean update(){
    travel();
    if(checkBounds(this,field)){
      return true;
    }
    else{
      return false;
    }
  }
  int t = 0;
  public void travel(){
    t++;
    //float z = (0.5*-9.8*t*t) + velocity.mag();
    PVector a = new PVector(velocity.x,velocity.y);
    location.add(a);
  }
  public void death(){
  }
  public boolean strikeCircle(circle hitbox){//target's hitbox is cicular
   return abs(getXcor() - hitbox.getXcor()) + abs(getYcor() - hitbox.getYcor()) <= (getSize() / 2) + (hitbox.getSize() / 2); 
  }
  public boolean strikeStandingRect(rectangle hitbox){//if angle is 90 or 270 degrees then tan(angle) will cause problems
    if(getXcor() >= hitbox.getXcor() - hitbox.getSizeY()/2 && getXcor() <= hitbox.getXcor() + hitbox.getSizeY()/2
      && getYcor() >= hitbox.getYcor() - hitbox.getSizeX()/2 && getYcor() <= hitbox.getYcor() + hitbox.getSizeX()/2){
       return true; 
      }
      return false;
  }
  public boolean strikeLayingRect(rectangle hitbox){//if angle is 0 ir 180 then slopeShort will have to divide by 0
     if(getXcor() >= hitbox.getXcor() - hitbox.getSizeX()/2 && getXcor() <= hitbox.getXcor() + hitbox.getSizeX()/2
      && getYcor() >= hitbox.getYcor() - hitbox.getSizeY()/2 && getYcor() <= hitbox.getYcor() + hitbox.getSizeY()/2){
       return true; 
      }
      return false;
  }
  public boolean strikeRectangle(rectangle hitbox){
    if(hitbox.getAngle() % 90 == 0 && hitbox.getAngle() % 180 != 0){
      return strikeStandingRect(hitbox);
    }
    else if(hitbox.getAngle() % 180 == 0){
      return strikeLayingRect(hitbox);
    }
    float slopeLong = tan(radians(hitbox.getAngle()));
    float interceptLong = hitbox.getYcor() - (hitbox.getXcor() * slopeLong);
    float slopeShort = -1/slopeLong;
    float intersectX = (interceptLong - (getYcor() - (getXcor() * slopeShort)))/(slopeShort - slopeLong);
    float intersectY = intersectX * slopeLong + interceptLong;
    if(!(distanceEq(intersectX,intersectY,getXcor(),getYcor()) <= (hitbox.getSizeY() / 2) + (getSize() / 2))){
      return false;
    }
      float interceptShort = hitbox.getYcor() - (hitbox.getXcor() * slopeShort);
      intersectX = (interceptShort - (getYcor() - (getXcor() * slopeLong)))/(slopeLong - slopeShort);
      intersectY = intersectX * slopeShort + interceptShort;
      if(distanceEq(intersectX,intersectY,getXcor(),getYcor()) <= (hitbox.getSizeX() / 2) + (getSize() / 2)){
       return true; 
      }
      else{
        return false;
      }
    }
  public boolean update(oneWayLinkedList<unit> x){
    boolean a = update();
    while(x.hasNext()){
      unit target = x.next();
      if(target.hitCheckCircle(this)){//bullet is cicular
        if(hit(target)){
          return true;
        }
        else{
          return a;
        }
      }
    }
   
    return a;
  }
  public void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(colour);
    applet.ellipse(xcor,ycor,displaySize,displaySize);
  }
}




/*
hitCheckCircle(bullet x){
    if(x.strikeCircle()){
         if(stamina > 0){
              stamina--;
               return false;
             }
          else{
                 return true;
           }
         }
      else{ return false;}
}
*/


/*
class BunBun extends Lula implements rectangle{
  float getXcor(){return location.x;}
  float getYcor(){return location.y;}
  float getSizeX(){return sizeX;}
  float getSizeY(){return sizeY;}
  float getAngle(){return radians(0);}
  boolean hitCheckCircle(bullet Bullet){
     return Bullet.strikeRectangle(this);
  }
  
  float sizeX,sizeY;
  float mvtspeed = 0.75 * scale;
  PVector ploc;
  PVector location;
  PVector velocity;
  boolean[] ActOptions = new boolean[3]; //0 p>=2.5x, 1 p>x, 2 p<=x
  boolean[] isAttackingStill = new boolean[5]; //0 charge, 1 kicks, 2 punchcombo, 3 armhammer
  boolean alive = true;
  Lula parent;
  
  BunBun(Lula parent, battleMode field,float xcor,float ycor,float _width,float _height,PVector playerlocation){
    super();
    this.field = field;
    location = new PVector(xcor,ycor);
    this.xcor = location.x;
    this.ycor = location.y;
    this.sizeX = _width*scale;
    this.sizeY = _height*scale;
    velocity = new PVector(0,0);
    ploc = playerlocation;
    health = 100;
    this.parent = parent;
  }
  
  boolean update(){ 
    if(health < 0){alive = !alive; return true;}
    boundsCheck(); //checks if BunBun's on screen and updates ActOptions
    actions();
    return false;
  }
  
  void actions(){
    if (ActOptions[0] || isAttackingStill[0]){
      chargeattack();
    }
    if(ActOptions[1] || isAttackingStill[1]){
      kickattack();
    }
    if(ActOptions[2] || isAttackingStill[2] || isAttackingStill[3]){
      armsattack();
    }
    if(parent.indanger){
      DuoAttack();
    }
  }
  
 
  void move(speed){
    if(abs(ploc.x-locationx)+abs(ploc.y-location.y)>(sizeX*2)){
      getVelocityTo(speed);
      location.add(velocity);
    }
  }
  
  charge basic = new charge(7);
  charge special = new charge(15);
  charge basiclength = new charge(2);
  void chargeattack(){
    if(isAttackingStill[0]){
      location.add(velocity);
        basiclength.resetCooldown();
        throwMiniCB();
        miniCBamt++;
      }
      if(miniCBamt == 3){
        basiclength.resetCooldown();
        miniCBamt = 0;
        isAttackingStill = false;
      }
    }else{
      if(basic.cooldown()){
        basic.resetCooldown();
        throwMiniCB();
        miniCBamt++;
        isAttackingStill = true;
      }else{
        if(special.cooldown()){
          special.resetCooldown();
          throwBigCB();
        }
      }
    }
  }
  
  void switchStatus(){
    alive = !alive;
  }
  
  void death(){}
  void throwMiniCB(){}
  void throwBigCB(){}
  void DuoAttack(){}
  void boundsCheck(){}
  
  void trueDraw(){}
}


*/
abstract class bullet extends unit{
  //constructors + variables
  int damage;
  float[] vector = new float[2];
  int colour = 0xffFF0000;
  bullet(){
  }
  bullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    super(parent,field,xcor,ycor);
    this.size = size;
    this.radius = this.size / 2;
    vector[0] = xVector;
    vector[1] = yVector;
    this.damage = damage;
    this.displaySize = this.size;
  }
  bullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this(null,field,xcor,ycor,size,xVector,yVector,damage);
    scaleVars();
  }
  public float getSize(){throw new UnsupportedOperationException();}
  public float getXcor(){return xcor;}
  public float getYcor(){return ycor;}
  public void setXcor(float x){xcor = x;}
  public void setYcor(float x){ycor = x;}
  public boolean hitCheckCircle(bullet Bullet){
    throw new UnsupportedOperationException();
  }
  public void scaleVars(){
   super.scaleVars();
   vector[0] *= scale;
   vector[1] *= scale;
  }
  //methods
  public boolean hit(unit target){
    target.health -= damage;
    return true;
  }
  public abstract boolean update();
  /*
    xcor += vector[0];
    ycor += vector[1];
    if(checkBounds(this,field)){
      return true;
    }
    else{
      return false;
    }*/
  public void death(){
  }
  public boolean strikeCircle(circle hitbox){//target's hitbox is cicular
  //println("hi");
   return abs(getXcor() - hitbox.getXcor()) + abs(getYcor() - hitbox.getYcor()) <= (getSize() / 2) + (hitbox.getSize() / 2); 
  }
  public boolean strikeStandingRect(rectangle hitbox){//if angle is 90 or 270 degrees then tan(angle) will cause problems
    if(getXcor() >= hitbox.getXcor() - hitbox.getSizeY()/2 && getXcor() <= hitbox.getXcor() + hitbox.getSizeY()/2
      && getYcor() >= hitbox.getYcor() - hitbox.getSizeX()/2 && getYcor() <= hitbox.getYcor() + hitbox.getSizeX()/2){
       return true; 
      }
      return false;
  }
  public boolean strikeLayingRect(rectangle hitbox){//if angle is 0 ir 180 then slopeShort will have to divide by 0
     if(getXcor() >= hitbox.getXcor() - hitbox.getSizeX()/2 && xcor <= hitbox.getXcor() + hitbox.getSizeX()/2
      && getYcor() >= hitbox.getYcor() - hitbox.getSizeY()/2 && ycor <= hitbox.getYcor() + hitbox.getSizeY()/2){
       return true; 
      }
      return false;
  }
  public abstract boolean strikeRectangle(rectangle hitbox);//{
    //return circleXrectangle((circle)this,hitbox);
    //}
  public boolean update(oneWayLinkedList<unit> x){
    boolean a = update();
    while(x.hasNext()){
      unit target = x.next();
      if(target.hitCheckCircle(this)){//bullet is cicular
        if(hit(target)){
          return true;
        }
        else{
          return a;
        }
      }
    }
   
    return a;
  }
  public void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(colour);
    applet.ellipse(xcor,ycor,displaySize,displaySize);
  }
}

class normalBullet extends bullet implements circle{
 normalBullet(entity parent,battleMode field,PVector location,PVector velocity,float size,int damage){
   this.parent = parent;
   this.field = field;
   this.location = location;
   this.size = size;
   this.radius = size / 2;
   this.damage = damage;
   this.velocity = velocity;
 }
 PVector velocity;
 int colour = 0xff2C9EFF;
 PVector location;
 public float getXcor(){return location.x;}
 public float getYcor(){return location.y;}
 public float getSize(){return size;}
 public void setXcor(float x){location.x = x;}
 public void setYcor(float x){location.y = x;}
 public void setSize(float x){size = x;}
 public boolean hitCheckCircle(bullet Bullet){
   return Bullet.strikeCircle(this); 
 }
 public boolean update(){
   location.add(velocity);
   return checkDisplayBounds(this);
 }
 public boolean strikeRectangle(rectangle hitbox){
    return circleXrectangle(this,hitbox);
    }
 public void trueDraw(float xcor,float ycor,PApplet applet){
  applet.stroke(colour);
  applet.fill(colour);
  applet.ellipse(xcor,ycor,size,size); 
 }
}
class oneWayLinkedListKey<E>{
 Lnode<E> current,back;
 oneWayLinkedListKey(Lnode<E> start){
   current = start;
 }
}
class Lnode<E>{
    E value;
    Lnode(E x){
      value = x;
    }
    Lnode(E x, Lnode a){
      value = x;
      after = a;
    }
    Lnode<E> after = null;
  }
class oneWayLinkedList<E>{//only one thread should be adding or removing from the list
  int size = 0;
  Lnode<E> end = new Lnode<E>(null,null);
  Lnode<E> start = new Lnode<E>(null,end);
  oneWayLinkedListKey<E> FirstKey = createKey();//only to be used by the thread that adds or removes from the list
  oneWayLinkedList(){
    end.after = start;//end's after is actually before
    }
    oneWayLinkedList(E...args){
      this();
     for(int i = 0; i < args.length;i++){
      add(args[i]); 
     }
    }
    public oneWayLinkedListKey<E> createKey(){
     return new oneWayLinkedListKey<E>(start); 
    }
    public synchronized  void add(E x){
      start.after = new Lnode(x,start.after);
      size++;
    }
    public synchronized void addLast(E x){
      Lnode newNode = new Lnode(x,end);
      end.after.after = newNode;
      end.after = newNode;
    }
    public boolean hasNext(oneWayLinkedListKey<E> Key){
      if(Key.current.after == end){
        rewind(Key);
        return false;
      }
      else{
        return true;
      }
    }
    public boolean hasNext(){
      return hasNext(FirstKey);
    }
    public E next(oneWayLinkedListKey<E> Key){
      Key.back = Key.current;
      return (Key.current = Key.current.after).value;
    }
    public E next(){
     return next(FirstKey); 
    }
    public E getCurrent(oneWayLinkedListKey<E> Key){
      return Key.current.value;
    }
    public E getCurrent(){
      return getCurrent(FirstKey);
    }
    public void rewind(oneWayLinkedListKey<E> Key){
      Key.current = start;
    }
    public void rewind(){
     rewind(FirstKey); 
    }
    public void remove(){
      FirstKey.back.after = FirstKey.current.after;
      /*Key.current.value = Key.current.after.value;
      Key.current.after = Key.current.after.after;
      Key.current = Key.back;*/
      size--;
    }
  }
  
class SaveSystem{
  String filename;
  SaveSystem(String name){
    filename = name + "";
  }
  public void save(){
    try{
      File file = new File (dataPath(filename));
      file.createNewFile();
      PrintWriter writer = new PrintWriter (file);
      for(int counter = 0; counter < levels.length ; counter++){
        writer.println("" + levels[counter]);
      }
      writer.close();
    } catch (IOException e) {
    }
  }
  public boolean[] load(boolean[] levels){
    try{
      File file = new File (dataPath(filename));
      file.createNewFile();
      FileReader fr = new FileReader(file); 
      BufferedReader br = new BufferedReader(fr); 
      String s; 
      int i = 0;
      while((s = br.readLine()) != null) { 
        if(s.equals("true")){
          levels[i] = true;
        }else{
          levels[i] = false;
        }
        i++;
      }
      fr.close();
    } catch (IOException e) {
    }
    return levels;
  }
}
  




 
class grunt extends unit implements circle{
  public float getXcor(){return xcor;}
   public float getYcor(){return ycor;}
   public float getSize(){return size;}
   public void setXcor(float x){xcor = x;}
public void setYcor(float x){ycor = x;}
public void setSize(float x){size = x;}
   public boolean hitCheckCircle(bullet Bullet){
    return Bullet.strikeCircle(this); 
   }
  grunt(battleMode field, float xcor, float ycor, float size,int health,unit player){
    this.health = health;// + int(tick / 60 * 0.1);
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size * scale;
    this.player = player;
  }
  unit player;
  delay special = new delay(5);
  charge basic = new charge(0.2f);
  float angle = 0;
  float speed = 0.075f * scale;
  public boolean update(){
    if(health <= 0){return true;}
    int a = checkBoundsAdvanced(this,field);
    float changeX = sin(radians(angle)) * speed;
    float changeY = sin(radians(angle)) * speed;
    if(a != 0){
      if(a == 1 || a == 2){
        angle = angle + 90;
      }
      else{
        angle = angle + 90;
      }
    }
    angle = angle % 360;
    xcor += changeX;
    ycor += changeY;
    angle += positiveOrNegative() * random(5);
    angle = angle % 360;
    if(basic.cooldown()){
      basic.resetCooldown();
      shoot(0.2f * scale,10,(0.05f + random(0.03f)) * scale);
    }
    if(special.every()){
      shoot(0.5f * scale,30,(0.05f + random(0.1f)) * scale);
    }
    return false;
  }
  public void death(){
    player.points++;
  }
  public void shoot(float size,int damage,float speed){
      //field.players.rewind();
      float BxVector = player.xcor - xcor;
      float ByVector = player.ycor - ycor;
      float fireAngle;
      if(player.ycor < ycor){
          fireAngle = (degrees(atan(BxVector / ByVector)) + 180 +(positiveOrNegative() * random(3))) % 360;
      }
      else{
        fireAngle = (degrees(atan(BxVector / ByVector))+(positiveOrNegative() * random(2))) % 360;
      }
      testbullet x = (new testbullet(this,field,xcor,ycor,size,sin(radians(fireAngle)) * speed,cos(radians(fireAngle)) * speed,damage));
      x.colour = 0xff1A03FC;
      field.bullets.add(x);
  }
  public void trueDraw(float xcor, float ycor, PApplet applet){ 
    applet.fill(0xff00FAF8);
    applet.ellipse(xcor,ycor,size,size);
  }
}


class randomEdgeSpawner{
  charge spawnRate = new charge(5);
  battleMode field;
  unit player;
  randomEdgeSpawner(battleMode field, unit player){
    this.field = field;
    this.player = player;
  }
  public void create(){
    field.enemies.add(new grunt(field, random(width), random(height / 20),0.5f,10,player));
  }
  public void spawn(){
    if(spawnRate.cooldown(field.enemies.size <= 10)){
      create();
    }
    if(field.enemies.size <= 3){
      spawnRate.setWait(2);
    }
    else{
      spawnRate.setWait(5);
    }
  }
}
/*
CopyPasta
 
 Circle:
 float getXcor(){return xcor;}
 float getYcor(){return ycor;}
 float getSize(){return size;}
 void setXcor(float x){xcor = x;}
 void setYcor(float x){ycor = x;}
 void setSize(float x){size = x;}
 boolean hitCheckCircle(bullet Bullet){
 return Bullet.strikeCircle(this); 
 }
 
 Rectangle:
 float getXcor(){return xcor;}
 float getYcor(){return ycor;}
 float getSizeX(){return sizeX;}
 float getSizeY(){return sizeY;}
 float getAngle(){return angle;}
 void setXcor(float x){xcor = x;}
 void setYcor(float x){ycor = x;}
 void setSizeX(float x){sizeX = x;}
 void setSizeY(float x){sizeY = x;}
 void setAngle(float x){angle = x;}
 boolean hitCheckCircle(bullet Bullet){
 return Bullet.strikeRectangle(this);
 }
 */
 
public void fade(PGraphics pic,float reduction){//beginDraw has already been called
  if(reduction == 0){
    return;
  }
 
 pic.loadPixels();
 for(int i = 0; i < pic.pixels.length;i++){
  pic.pixels[i] = color(red(pic.pixels[i]),green(pic.pixels[i]),blue(pic.pixels[i]),alpha(pic.pixels[i]) - (pic.colorModeA * reduction));
 }
 pic.updatePixels();
 
}
public boolean circleXcircle(circle a, circle b) {//target's hitbox is cicular
  return abs(a.getXcor() - b.getXcor()) + abs(a.getYcor() - b.getYcor()) <= (a.getSize() / 2) + (b.getSize() / 2);
}
public boolean circleXrectangleHstanding(circle a,rectangle b) {//if angle is 90 or 270 degrees then tan(angle) will cause problems
  if (a.getXcor() >= b.getXcor() - b.getSizeY()/2 && a.getXcor() <= b.getXcor() + b.getSizeY()/2
    && a.getYcor() >= b.getYcor() - b.getSizeX()/2 && a.getYcor() <= b.getYcor() + b.getSizeX()/2) {
    return true;
  }
  return false;
}
public boolean circleXrectangleHlaying(circle a,rectangle b) {//if angle is 0 ir 180 then slopeShort will have to divide by 0
  if (a.getXcor() >= b.getXcor() - b.getSizeX()/2 && a.getXcor() <= b.getXcor() + b.getSizeX()/2
    && a.getYcor() >= b.getYcor() - b.getSizeY()/2 && a.getYcor() <= b.getYcor() + b.getSizeY()/2) {
    return true;
  }
  return false;
}
public boolean circleXrectangle(circle a,rectangle b) {
  if (b.getAngle() % 90 == 0 && b.getAngle() % 180 != 0) {
    return circleXrectangleHstanding(a,b);
  } else if (b.getAngle() % 180 == 0) {
    return circleXrectangleHlaying(a,b);
  }
  float slopeLong = tan(radians(b.getAngle()));
  float interceptLong = b.getYcor() - (b.getXcor() * slopeLong);
  float slopeShort = -1/slopeLong;
  float intersectX = (interceptLong - (a.getYcor() - (a.getXcor() * slopeShort)))/(slopeShort - slopeLong);
  float intersectY = intersectX * slopeLong + interceptLong;
  if (!(distanceEq(intersectX, intersectY, a.getXcor(), a.getYcor()) <= (b.getSizeY() / 2) + (a.getSize() / 2))) {
    return false;
  }
  float interceptShort = b.getYcor() - (b.getXcor() * slopeShort);
  intersectX = (interceptShort - (a.getYcor() - (a.getXcor() * slopeLong)))/(slopeLong - slopeShort);
  intersectY = intersectX * slopeShort + interceptShort;
  if (distanceEq(intersectX, intersectY, a.getXcor(), a.getYcor()) <= (b.getSizeX() / 2) + (a.getSize() / 2)) {
    return true;
  } else {
    return false;
  }
}


public float toPositiveAngle(float angle) {//uses degrees
  if (angle < 0) {
    return 360 + (angle%360);
  } else {
    return angle%360;
  }
}
public float distanceEq(float x1, float y1, float x2, float y2) {
  return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
}
class Timer {
  public Timer() {
  }
  private long time;
  public void start() {
    time = System.currentTimeMillis();
  }
  public long stop() {
    return (System.currentTimeMillis() - time) / 1000;
  }
}


public void centerWindow() {
  if (surface != null) {
    surface.setLocation(centerX, centerY);
  }
}
public void centerWindow(PApplet x) {
  if (x.getSurface() != null) {
    x.getSurface().setLocation(x.displayWidth/2-x.width/2, x.displayHeight/2-x.height/2);
  }
}
public String randomSelect(String[]x) {
  return x[PApplet.parseInt(random(x.length))];
}
public boolean released(char targetKey) {//for regular keys
  if (releasedTick != tick) {
    return false;
  } else {
    if (!codedAndPushed) {
      return keyPushed == targetKey;
    } else {
      return false;
    }
  }
}
public boolean released(int targetKey) {//for codedKeys
  if (releasedTick != tick) {
    return false;
  } else {
    if (codedAndPushed) {
      return keyPushed == targetKey;
    } else {
      return false;
    }
  }
}
public int arrayIndex(String[]ary, String target) {
  for (int i = 0; i < ary.length; i++) {
    if (ary[i].equals(target)) {
      return i;
    }
  }
  return -1;
}
public int arrayIndex(char[]ary, char target) {
  for (int i = 0; i < ary.length; i++) {
    if (ary[i] == target) {
      return i;
    }
  }
  return -1;
}
public int positiveOrNegative() {
  if (random(100) > 50) {
    return 1;
  } else {
    return -1;
  }
}


class delay {
  int wait;
  int counter = 0;
  public void setWait(float wait) {
    this.wait = PApplet.parseInt(wait * expectedFrameRate);
  }
  delay(float wait) {
    this.wait = PApplet.parseInt(wait * expectedFrameRate);
  }
  public boolean every() {
    if (counter++ % wait == 0) {
      return true;
    } else {
      return false;
    }
  }
}


class charge {
  int wait;
  int counter = 0;
  charge(float wait) {
    this.wait = PApplet.parseInt(wait * expectedFrameRate);
  }
  public void setWait(float wait) {
    this.wait = PApplet.parseInt(wait * expectedFrameRate);
  }
  public boolean cooldown() {
    if (counter++ < wait) {
      return false;
    } else {
      return true;
    }
  }
  public void resetCooldown() {
    counter = 0;
  }
  public boolean cooldown(boolean activation) {
    if (cooldown() && activation) {
      resetCooldown();
      return true;
    } else {
      return false;
    }
  }
}
//bounds
/*boolean checkBounds(unit x,battleMode field){
 boolean r = false;
 if(x.xcor > field._width - (x.size / 2)){
 x.xcor = field._width - (x.size / 2);
 r = true;
 }
 else if(x.xcor < x.size / 2){
 x.xcor = x.size / 2;
 r = true;
 }
 if(x.ycor > field._height - (x.size / 2)){
 x.ycor = field._height - (x.size / 2);
 r = true;
 }
 else if(x.ycor < x.size / 2){
 x.ycor = x.size / 2;
 r = true;
 }
 return r;
 }
 int checkBoundsAdvanced(unit x,battleMode field){
 int r = 0;
 if(x.xcor > field._width - (x.size / 2)){
 x.xcor = field._width - (x.size / 2);
 r = 1;
 }
 else if(x.xcor < x.size / 2){
 x.xcor = x.size / 2;
 r = 2;
 }
 if(x.ycor > field._height - (x.size / 2)){
 x.ycor = field._height - (x.size / 2);
 r = 3;
 }
 else if(x.ycor < x.size / 2){
 x.ycor = x.size / 2;
 r = 4;
 }
 return r;
 }*/
public boolean checkBoundsGhost(unit x, battleMode field) {
  if (x.xcor > field._width - (x.size / 2)) {
    return true;
  } else if (x.xcor < x.size / 2) {
    return true;
  }
  if (x.ycor > field._height - (x.size / 2)) {
    return true;
  } else if (x.ycor < x.size / 2) {
    return true;
  } else {
    return false;
  }
}
public boolean checkDisplayBounds(unit x) {
  boolean r = false;
  if (x.xcor + centerX > displayWidth - (x.size / 2)) {
    x.xcor = (displayWidth - (x.size / 2)) - centerX;
    r = true;
  } else if (x.xcor + centerX < x.size / 2) {
    x.xcor = (x.size / 2) - centerX;
    r = true;
  }
  if (x.ycor + centerY > displayHeight - (x.size / 2)) {
    x.ycor = (displayHeight - (x.size / 2)) - centerY;
    r = true;
  } else if (x.ycor + centerY < x.size / 2) {
    x.ycor = (x.size / 2) - centerY;
    r = true;
  }
  return r;
}
public boolean inBounds(unit x, battleMode field) {
  if (x.xcor > field._width - (x.size / 2)) {
    //x.xcor = field._width - (x.size / 2);
    return false;
  } else if (x.xcor < x.size / 2) {
    //x.xcor = x.size / 2;
    return false;
  }
  if (x.ycor > field._height - (x.size / 2)) {
    //x.ycor = field._height - (x.size / 2);
    return false;
  } else if (x.ycor < x.size / 2) {
    //x.ycor = x.size / 2;
    return false;
  }
  return true;
}

//circle bounds
public boolean checkBounds(circle x, battleMode field) {
  boolean r = false;
  if (x.getXcor() > field._width - (x.getSize() / 2)) {
    x.setXcor(field._width - (x.getSize() / 2));
    r = true;
  } else if (x.getXcor() < x.getSize() / 2) {
    x.setXcor(x.getSize() / 2);
    r = true;
  }
  if (x.getYcor() > field._height - (x.getSize() / 2)) {
    x.setYcor(field._height - (x.getSize() / 2));
    r = true;
  } else if (x.getYcor() < x.getSize() / 2) {
    x.setYcor(x.getSize() / 2);
    r = true;
  }
  return r;
}
public boolean checkDisplayBounds(PVector x) {//assumes its main window
  boolean r = false;
  if (x.x > mainWindow.width + centerX) {
    x.x = (mainWindow.width + centerX);
    r = true;
  } else if (x.x < 0 - centerX) {
    x.x = 0 - centerX;
    r = true;
  }
  if (x.y > mainWindow.height + centerY) {
    x.y=(mainWindow.height + centerY);
    r = true;
  } else if (x.y < 0-centerY) {
    x.y = 0-centerY;
    r = true;
  }
  return r;
}
public int checkBoundsAdvanced(circle x, battleMode field) {
  int r = 0;
  if (x.getXcor() > field._width - (x.getSize() / 2)) {
    x.setXcor(field._width - (x.getSize() / 2));
    r = 1;
  } else if (x.getXcor() < x.getSize() / 2) {
    x.setXcor(x.getSize() / 2);
    r = 2;
  }
  if (x.getYcor() > field._height - (x.getSize() / 2)) {
    x.setYcor(field._height - (x.getSize() / 2));
    r = 3;
  } else if (x.getYcor() < x.getSize() / 2) {
    x.setYcor(x.getSize() / 2);
    r = 4;
  }
  return r;
}

public String Command(String arg) {
  String something = "";
  try {
    String command = arg;
    Process proc = Runtime.getRuntime().exec(command);

    // Read the output

    BufferedReader reader =
      new BufferedReader(new InputStreamReader(proc.getInputStream()));
    BufferedWriter reader1 = new BufferedWriter(new OutputStreamWriter(proc.getOutputStream()));

    String line = "";
    String line1 = "";
    while ((line = reader.readLine()) != null) {
      something += line + "\n";
    }
    proc.waitFor();
  }
  catch(Throwable e) {
    e.printStackTrace();
  }
  return something;
}
class button{
  //constructor + variables
  float sizeX,sizeY,x,y,x1,y1;
  //include pic, hover animation, and pressed pic
  button(float x,float y,float sizeX,float sizeY){
    this.x = x * scale;
    this.y = y * scale;
    this.sizeX = sizeX * scale;
    this.sizeY = sizeY * scale;
    x1 = this.x + this.sizeX;
    y1 = this.y + this.sizeY;
  }
  
  //methods
  public void action(){
  }
  public void pushed(){
  }
  public void hover(){
    _draw();
  }
  public void _draw(){
    fill(0xffFFFFFF);
    rect(x,y,sizeX,sizeY);
  }
  public void tick(){
    if(mouseX >= x && mouseX <= x1 && mouseY >= y && mouseY <= y1){
      if(mousePressed){
        pushed();
      }
      else{
        if(pmousePressed){
          action();
        }
        else{
          hover();
        }
      }
    }
    else{
      _draw();
    }
  }
}
class mode{
  ArrayList<button>buttons = new ArrayList<button>();
  public void _setup(){
  }
  public void tick(){
  }
  public void updateButtons(){
    for(int i = 0; i < buttons.size(); i++){
      buttons.get(i).tick();
    }
  }
}


class gameOver extends mode{
  public void _setup(){
    background(0xffFF0000);
    buttons.add(new testButton(1,6,3,2));
    buttons.add(new muteButton(4,6));
    buttons.add(new mmButton(5,6,3,2));
  }
  public void tick(){
    background(0xffFF0000);
    textSize(5 * scale);
    fill(0);
    text("R.I.P.",3 * scale,4.5f * scale);
    updateButtons();
  }
}


class testButton extends button{
  testButton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  public void action(){
    Mode = new testBattleMode();
    Mode._setup();
  }
  public void pushed(){
  }
  public void hover(){
    _draw();
  }
  public void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Test Game",x+sizeX/4,y+sizeY/2.5f,400,400);
  }
}


class muteButton extends button{
  muteButton(float x,float y){
    super(x,y,1,1);
  }
  muteButton(float x,float y,float w,float h){
    super(x,y,w,h);
  }
  PImage mutedButton = loadImage("muteButtonMuted.png");
  PImage unmutedButton = loadImage("muteButton.png");
  public void action(){
    muted = !muted;
    if(muted){
      bgmMute();
    }
    else{
      refreshBgmVolume();
    }
  }
  public void pushed(){
  }
  public void hover(){
    _draw();
  }
  public void _draw(){
    if(muted){
      image(mutedButton,x,y,sizeX,sizeY);
    }
    else{
      image(unmutedButton,x,y,sizeX,sizeY);
    }
  }
}


class mainMenu extends mode{
  public void _setup(){
    buttons.add(new testButton(1,6,3,2));
    buttons.add(new muteButton(4,6));
    buttons.add(new MetropolisButton(1,3.5f,3,2));
    buttons.add(new WormButton(1,1,3,2));
    //playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
    playBgm("song2.mp3");
  }
  public void tick(){
    background(0xffF0F0F0);
    updateButtons();
  }
}


class MetropolisButton extends button{
  MetropolisButton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  public void action(){
    Mode = new Metropolis();
    Mode._setup();
  }
  public void pushed(){
  }
  public void hover(){
    _draw();
  }
  public void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Metropolis Level",x+(x/3),y+(y/4.3f),500,500);
  }
}
class WormButton extends button{
  WormButton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  public void action(){
    Mode = new giantWormBossLevel();
    Mode._setup();
  }
  public void pushed(){
  }
  public void hover(){
    _draw();
  }
  public void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Worm Level",x+(x/1.5f),y+(y/1.2f),500,500);
  }
}


class mmButton extends button{
  mmButton(int x, int y,int xSize,int ySize){
    super(x,y,xSize,ySize);
  }
  public void action(){
    Mode = new mainMenu();
    Mode._setup();
  }
  public void pushed(){
  }
  public void hover(){
    _draw();
  }
  public void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Main Menu",x+sizeX/4,y+sizeY/2.5f,400,400);
  }
}
abstract class player extends unit{
  
}
float bgmVolume = 1;
float seVolume = 1;
SoundFile bgm;
  public SoundFile getSound(String fileName){
    return new SoundFile(game.this,fileName);
  }
  public void playBgm(String fileName){
    try{
      if(bgm != null){
        bgm.stop();
      }
      bgm = getSound(fileName);
      refreshBgmVolume();
      if(muted){
        bgmMute();
      }
      bgm.play();
    }
    catch(NullPointerException e){
      //if(!fileName.equals("error.mp3")){
        //playBgm("error.mp3");
      //}
    }
  }
  public void refreshBgmVolume(){
    if(bgm != null){
    bgm.amp(bgmVolume);
    }
  }
  public void bgmMute(){
    if(bgm != null){
      bgm.amp(0);
    }
  }
  public void playSe(String fileName){
    try{
      if(!muted){
        SoundFile x = getSound(fileName);
        x.amp(seVolume);
        x.play();
      }
    }
    catch(NullPointerException e){
      return;
    }
  }
  
class attractorTestEnvironment extends testEnvironment{
 attractor x;
 public void _setup(){
  x = new attractor();
  x._setup();
  x.setForce(20);
  x.setDelay(new delay(0.1f));
  x.setTarget(new PVector(8*scale,4.5f*scale));
  x.setFade(0.0f);
  x.setColour(color(0,0,255));
 }
 public void tick(){
  x._draw(); 
 }
}
class newWindowTestEnvironment extends testEnvironment{
  fieldPart x;
 public void _setup(){
  //x = new fieldPart("test",500,500,500,100);
 }
}
class oneWayLinkedListTestEnvironment extends testEnvironment{
  public void _setup(){
    oneWayLinkedList<Integer> x = new oneWayLinkedList<Integer>();
    oneWayLinkedListKey<Integer> k = x.createKey();
    x.add(0);
    x.add(1);
    x.add(2);
    x.add(3);
    x.add(4);
    x.add(5);
    x.add(6);
    String r = "";
    while(x.hasNext(k)){
      Integer a = x.next(k);
      r += a + " ";
      }
    System.out.println(r);
    //x.rewind(k);
    r = "";
    while(x.hasNext(k)){
      r += x.next(k) + " ";
    }
    System.out.println(r);
  }
  public void tick(){
  }
}
class testEnvironment extends mode{
  public void _setup(){
  }
  public void tick(){
  }
}
class experimentTestEnironment extends testEnvironment{
  int x = 0;
  public void _setup(){
  }
  public void tick(){
    if(released('z')){
      System.out.println(x++);
    }
  }
}
class tempTestEnvironment extends testEnvironment{
  delay x;
  public void _setup(){
    x = new delay(1);
  }
  public void tick(){
    if(x.every()){
      println(mouseX + " " + mouseY);
    }
  }
}
class scrapTestEnvironment extends testEnvironment{
  public void _setup(){
    System.out.println(10.5f % 5);
  }
}
class sizeTestEnvironment extends testEnvironment{
  public void _setup(){
    rect(0 * scale,0 * scale, 1 * scale, 1 * scale);
  }
  public void tick(){
  }
}
class soundTestEnvironment extends testEnvironment{
  
}
class robotTestEnvironment extends testEnvironment{
   public void tick(){
     if(!keys[keyZ]){
       robot.keyPress(KeyEvent.VK_Z);
       robot.keyRelease(KeyEvent.VK_Z);
       //System.out.println("pressed");
     }
     if(released('z')){
       System.out.println('z');
     }
     if(keys[keyZ]){
       System.out.println('z');
     }
     System.out.println(keys[keyZ]);
   }
}
class testBattleMode extends battleMode{
      randomEdgeSpawner spawn;
      fieldPart window;
  public void _setup(){
    super._setup();
   // playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
   playBgm("song2.mp3");
    unit a = new testunitA(this,0.5f,0.5f,0.20f,0.5f);
    a.health = 100000;
    players.add(a);
    window = createFieldPart(this,"test",500,500,displayWidth / 2,displayHeight / 2,true);
    spawn = new randomEdgeSpawner(this,a);
    spawn.create();
    background(0);
  }
  public void tick(){
    //System.out.println(frameRate);
    if(released('z')){
      //window = createFieldPart(this,"test",500,500,window.xcor,window.ycor,true);
    }
    spawn.spawn();
    super.tick();
    if(keys[keyW]){
      window.move(0,-2);
    }
    if(keys[keyA]){
      window.move(-2,0);
    }
    if(keys[keyS]){
     window.move(0,2);
    }
    if(keys[keyD]){
      window.move(2,0);
    }
  }
}
class pushedTestEnvironment extends testEnvironment{
  public void tick(){
    if(released('z')){
      System.out.println('z');
    }
    if(released('x')){
      System.out.println('x');
    }
    if(released(UP)){
      System.out.println("up");
    }
    if(released(DOWN)){
      System.out.println("down");
    }
  }
}
class delayAndCooldownTestEnvironment extends testEnvironment{
  int c = 0;
  int cc = 0;
  charge x;
  delay y;
  public void _setup(){
    x = new charge(5);
    y = new delay(3);
  }
  public void tick(){
    if(x.cooldown(keys[0])){
      System.out.println(c++);
    }
    if(y.every()){
     // System.out.println(cc++);
    }
  }
}
class testunit extends player implements circle{
  public float getXcor(){return xcor;}
public float getYcor(){return ycor;}
public float getSize(){return size;}
public void setXcor(float x){xcor = x;}
public void setYcor(float x){ycor = x;}
public void setSize(float x){size = x;}
public boolean hitCheckCircle(bullet Bullet){
  return Bullet.strikeCircle(this); 
}
  float speed = 0.1f * scale;
  testunit(entity parent,battleMode field,float xcor,float ycor,float size,float displaySize){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.displaySize = displaySize;
    this.radius = this.size / 2;
    health = 100;
  }
  testunit(battleMode field,float xcor,float ycor,float size,float displaySize){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.displaySize = displaySize * scale;
    this.radius = this.size / 2;
    health = 100;
  }
  int[] face = {-1,0};// -1 = up 1 = down, -1 = left 1 = right
  //face must never be {0,0}
  public void move(){
    int a = face[0];
    int b = face[1];
    float mSpeed = speed;
    if(codedKeys[cKeySHIFT]){
      mSpeed *= 0.50f;//focus speed ratio
    }
    if(codedKeys[cKeyUP] || codedKeys[cKeyDOWN] || codedKeys[cKeyLEFT] || codedKeys[cKeyRIGHT] && 
      !(codedKeys[cKeyUP] && codedKeys[cKeyDOWN] && codedKeys[cKeyLEFT] && codedKeys[cKeyRIGHT])){
      if(!(codedKeys[cKeyUP] && codedKeys[cKeyDOWN])){
        face[0] = 0;
        if(codedKeys[cKeyUP]){
          face[0]--;
          ycor -= mSpeed;
        }
        if(codedKeys[cKeyDOWN]){
          face[0]++;
          ycor += mSpeed;
        }
      }
      if(!(codedKeys[cKeyLEFT] && codedKeys[cKeyRIGHT])){
        face[1] = 0;
        if(codedKeys[cKeyLEFT]){
           face[1]--;
           xcor -= mSpeed;
        }
        if(codedKeys[cKeyRIGHT]){
          face[1]++;
          xcor += mSpeed;
        }
      }
      boolean noChange = keys[keyC];
      if(faceLock){
        noChange = !noChange;
      }
      if(noChange){
        face[0] = a;
        face[1] = b;
      }
      else{
      if(abs(face[0]) > 1){
        face[0] = abs(face[0]) / face[0];
      }
      if(abs(face[1]) > 1){
        face[1] = abs(face[1]) / face[1];
      }
      }
    }
  }
  public bullet createbullet(){
    return new testbullet(this,field,xcor,ycor,0.2f * scale,BxVector * scale,ByVector * scale,10);
  }
  float BxVector;
  float ByVector;
  float spread = 0.05f;
  boolean faceLock = false;
  public void shoot(){
    if(codedKeys[cKeySHIFT]){
      spread = 0.015f;
    }
    else{
      spread = 0.05f;
    }
    BxVector = (face[1] * (0.3f + random(0.1f))) + (random(spread) * positiveOrNegative());
      ByVector = (face[0] * (0.3f + random(0.1f))) + (random(spread) * positiveOrNegative());
      field.playerBullets.add(createbullet());
  }
  charge zCooldown = new charge(0.1f);
  public void death(){
    Mode = new gameOver();
    Mode._setup();
  }
  public boolean update(){
    if(health <=0){
      return true;
    }
    if(released(CONTROL)){
      faceLock = !faceLock;
    }
    move();
    checkBounds(this,field);
    if(codedKeys[cKeySHIFT]){
      zCooldown.setWait(0.075f);
    }
    else{
      zCooldown.setWait(0.1f);
    }
    if(zCooldown.cooldown(keys[keyZ])){
      //System.out.print("shoot");
      shoot();
    }
    return false;
  }
  String achievement = "status: trapped in a box of death";
  public void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(0xff00D81B);
    applet.ellipse(xcor,ycor,displaySize,displaySize);
    if(codedKeys[cKeySHIFT]){
      applet.fill(0xffFFFFFF);
      applet.ellipse(xcor,ycor,size,size);
    }
    if(health > 25){
      applet.fill(255);
    }
    else{
      applet.fill(0xffFF0000);
    }
    applet.textSize(25);
    applet.text("hp: " + health + " kills: " + points + " time: " + tick / expectedFrameRate + " " + achievement,0,25);
  }
}
class testunitA extends testunit{
  windowMob test = null;
  testunitA(entity parent,battleMode field,float xcor,float ycor,float size,float displaySize){
    super(parent,field,xcor,ycor,size,displaySize);
    test = new windowMob(this);
    test.getSurface().setVisible(false);
  }
  testunitA(battleMode field,float xcor,float ycor,float size,float displaySize){
    super(field,xcor,ycor,size,displaySize);
    test = new windowMob(this);
    test.getSurface().setVisible(false);
  }
  public bullet createbullet(){
    return new testbullet(this,field,xcor,ycor,0.2f * scale,BxVector * scale,ByVector * scale,10);
  }
  public void death(){
    super.death();
    test._exit();
  }
  boolean visiable = false;
  int riftwalks = 0;
  public void trueDraw(float xcor, float ycor,PApplet applet){
    super.trueDraw(xcor,ycor,applet);
    if(out && !visiable){
      test.getSurface().setVisible(true);
      visiable = true;
      test.loop();
      if(riftwalks++ < 10){
          achievement = "status: error404 player not found";
      }
      else{
          achievement = "D:< come back and die plz";
      }
    }
    if(!out && visiable){
      test.getSurface().setVisible(false);
      visiable = false;
      test.noLoop();
      if(riftwalks++ < 10){
        achievement = "status: hacks detected";
      }
      else{
        achievement = "so, how's the outside world?";
      }
    }
    if(out){
      
    }
  }
  boolean out = false;
  public boolean update(){
    if(health <= 0){
      return true;
    }
    if(released(CONTROL)){
      faceLock = !faceLock;
    }
    move();
    checkDisplayBounds(this);
    if(inBounds(this,field)){
      out = false;
    }
    else{
      out = true;
    }
    if(zCooldown.cooldown(keys[keyZ])){
      //System.out.print("shoot");
      shoot();
    }
    return false;
  }
}

class testbullet extends bullet implements circle{
  public boolean strikeRectangle(rectangle hitbox){
    return circleXrectangle(this,hitbox);
    }
  public float getXcor(){return xcor;}
public float getYcor(){return ycor;}
public float getSize(){return size;}
public void setXcor(float x){xcor = x;}
public void setYcor(float x){ycor = x;}
public void setSize(float x){size = x;}
public boolean hitCheckCircle(bullet Bullet){
  return Bullet.strikeCircle(this); 
}
  //constructors
  testbullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    super(parent,field,xcor,ycor,size,xVector,yVector,damage);
   
  }
  testbullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this(null,field,xcor,ycor,size,xVector,yVector,damage);
    scaleVars();
  }
  
  //methods
  public void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(colour);
    //if(!checkBoundsGhost(this,field)){
      applet.ellipse(xcor,ycor,displaySize,displaySize);
    //}
  }
  public boolean update(){
    xcor += vector[0];
    ycor += vector[1];
    if(checkDisplayBounds(this)){
      return true;
    }
    else{
      return false;
    }
  }
}


class Ebullet extends bullet implements circle{
  public boolean strikeRectangle(rectangle hitbox){
    return circleXrectangle(this,hitbox);
    }
  public float getXcor(){return xcor;}
public float getYcor(){return ycor;}
public float getSize(){return size;}
public void setXcor(float x){xcor = x;}
public void setYcor(float x){ycor = x;}
public void setSize(float x){size = x;}
public boolean hitCheckCircle(bullet Bullet){
  return Bullet.strikeCircle(this); 
}
  //constructors
   Ebullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.radius = this.size / 2;
    vector[0] = xVector;
    vector[1] = yVector;
    this.damage = damage;
    displaySize = size;
  }
  Ebullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this(null,field,xcor,ycor,size,xVector,yVector,damage);
    scaleVars();
  }
  
  public boolean update(){
    xcor += vector[0];
    ycor += vector[1];
    if(checkBounds(this,field)){
      return true;
    }
    else{
      return false;
    }
  }
  
  //methods
  public void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(0xff1A03FC);
    applet.ellipse(xcor,ycor,displaySize,displaySize);
  }
}
class window extends PApplet{
  window(String name){
    super();
    PApplet.runSketch(new String[]{name},this);
  }
  int sizeX;
  int sizeY;
  public void settings(){
  }
  public void setup(){
  }
  public void draw(){
  }
  public void keyPressed(){
    KP(this);
  }
  public void keyReleased(){
    KR(this);
  }
}
public synchronized fieldPart createFieldPart(battleMode field,String name, int Width, int Height, int xcor, int ycor,boolean onTop){
  newWindowWidth = Width;
  newWindowHeight = Height;
  return new fieldPart(field,name,xcor,ycor,onTop);
}
int newWindowWidth,newWindowHeight;//to be used only by fieldPart;
class fieldPart extends PApplet{
  fieldPart(battleMode field,String name,int xcor, int ycor, boolean onTop){
    super();
    this.xcor = xcor;
    this.ycor = ycor;
    this.onTop = onTop;
    this.name = name;
    this.field = field;
    visiable = true;
    PApplet.runSketch(new String[]{name},this);
  }
  String name;
  int Width,Height,xcor,ycor;
  boolean onTop;
  boolean visiable;
  battleMode field;
  oneWayLinkedListKey<unit>[] keys;
  public void settings(){
    size(newWindowWidth,newWindowHeight);
  }
  public void invis(){
   visiable = false;
   getSurface().setVisible(false);
  }
  public void vis(){
   visiable = true;
   getSurface().setVisible(true);
  }
  public void setup(){
    frameRate(20);
    getSurface().setAlwaysOnTop(onTop);
    getSurface().setLocation(xcor,ycor);
    keys = new oneWayLinkedListKey[field.drawables.length];
    for(int i = 0;i < keys.length;i++){
     keys[i] = field.drawables[i].createKey();
    }
  }
  public void draw(){
    getSurface().setLocation(xcor,ycor);
    drawAll(field);
  }
  public void skin(){
    field._background(this);
  }
  public void drawAll(battleMode field){
    skin();
   for(int i = 0; i < field.drawables.length; i++){
    _draw((oneWayLinkedList<unit>)field.drawables[i],keys[i]);
   }
  }
  public void keyPressed(){
    KP(this);
  }
  public void keyReleased(){
    KR(this);
  }
  public void move(int x, int y){
   xcor = xcor + x;
   ycor = ycor + y;
  }
  public void setLocation(int x,int y){
   xcor = x;
   ycor = y;
  }
  public void _exit(){
   dispose();
   getSurface().setVisible(false); 
  }
  public void _draw(oneWayLinkedList<unit>x,oneWayLinkedListKey<unit> k){
   while(x.hasNext(k)){
      try{
      unit b = x.next(k);
      int trueXcor = PApplet.parseInt(b.getXcor() + centerX);
      int trueYcor = PApplet.parseInt(b.getYcor() + centerY);
      if(trueXcor < xcor + width && trueXcor >=xcor && trueYcor < ycor + height && trueYcor >= ycor){
        b.trueDraw(trueXcor - xcor,trueYcor - ycor,this);
      }
      }
      catch(NullPointerException e){
      }
    } 
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
 public void settings(){
    sizeX = PApplet.parseInt(2 * scale);
    sizeY = PApplet.parseInt(2 * scale);
    if(sizeY < 100){
      sizeY = 100;
    }
    if(sizeX < 100){
      sizeX = 100;
    }
    println(sizeX + " " + sizeY);
    size(sizeX,sizeY);
  }
  public void setup(){
    frameRate(30);
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
  public void draw(){
    centerWindow();
    background(0);
    getSurface().setLocation(xcor = (windowPosX + round(target.xcor)),ycor = (windowPosY + round(target.ycor)));
        _draw(target.field.playerBullets,0xffFF0000);
        _draw(target.field.bullets,0xff1A03FC);
    fill(0xff00D81B);
    ellipse(sizeX / 2,sizeY / 2,target.displaySize,target.displaySize);
    if(codedKeys[cKeySHIFT]){
      fill(0xffFFFFFF);
      ellipse(sizeX/2,sizeY/2,target.size,target.size);
    }
  }
  public void _exit(){
   dispose();
   getSurface().setVisible(false); 
  }
  public void keyPressed(){
    KP(this);
  }
  public void keyReleased(){
    KR(this);
  }
  public void _draw(oneWayLinkedList<unit> x,int ccc){
    oneWayLinkedListKey<unit> k = x.createKey();
    while(x.hasNext(k)){
      try{
      unit b = x.next(k);
      int trueXcor = PApplet.parseInt(b.xcor + centerX);
      int trueYcor = PApplet.parseInt(b.ycor + centerY);
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "game" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
