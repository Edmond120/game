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
import java.io.PrintWriter; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.BufferedWriter; 
import java.io.InputStreamReader; 
import java.io.OutputStreamWriter; 

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
  
  
  levels[0] = true;
  levels[1] = true;
  SaveSystem a = new SaveSystem();
  a.save();
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
  //Mode = new oneWayLinkedListTestEnvironment();
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
  try{
    Mode.tick();
    pmousePressed = mousePressed;
    tick++;
  }
  catch(Throwable e){
    e.printStackTrace();
    noLoop();
  }
}

//keyboard + variables
char[]_keys = {'z','x','c'};
int keyZ = 0;int keyX = 1;int keyC = 2;
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
  }
  else{
    for(int i = 0; i < keys.length;i++){
      if(java.lang.Character.toLowerCase(x.key) == _keys[i]){
        keys[i] = setValue;
        return;
      }
    }
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

class animation extends unit{
  //constructor + variables
  flipbook movie;
  delay wait;
  PImage currentImage;
  animation(battleMode field,flipbook movie,int xcor,int ycor,int size,int _delay){//_delay is in 60ths of a second
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
  
  //methods
  public boolean update(){
    if(!wait.every()){
      image(currentImage,xcor,ycor,size,size);
      return false;
    }
    if(movie.hasNext()){
      image(currentImage = movie.next(),xcor,ycor,size,size);
      return false;
    }
    else{
      return true;
    }
  }
  public void _draw(){
    throw new UnsupportedOperationException();
  }
}
class entity{
  entity parent = null;
  public boolean update(){
    //true if unit is to be removed
    return false;
  }
  public boolean update(oneWayLinkedList<unit> x){//this is for interaction with other entitys
    //true if unit is to be removed
    return false;
  }
  public void _draw(){
  }
  public void trueDraw(){ 
  }
}

class unit extends entity{
  battleMode field;
  int health;
  int points;
  float size;
  float xcor;
  float ycor;
  float radius;
  float displaySize;
  public void death(){
  }
}

class battleMode extends mode{
  int _width = width;
  int _height = height;
  oneWayLinkedList<unit> bullets;
  oneWayLinkedList<unit> playerBullets;
  oneWayLinkedList<unit> enemies;
  oneWayLinkedList<unit> players;
  oneWayLinkedList<unit> anime; //this "anime" stands for animation, not the anime anime (lol)
  
  public void _setup(){
    tick = 0;
  }
  public void tick(){
    background(0);
    try{
    update(playerBullets,enemies);
    update(bullets,players);
    update(players);
    update(enemies);
    
    //note, animations don't use the _draw method, update includes draw. 
    update(anime);
    //Hence it must be placed in between the update and draw methods.
    
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
class bullet extends unit{
  //constructors + variables
  int damage;
  float[] vector = new float[2];
  bullet(){
  }
  bullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.radius = this.size / 2;
    vector[0] = xVector;
    vector[1] = yVector;
    this.damage = damage;
  }
  bullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.radius = this.size / 2;
    vector[0] = xVector * scale;
    vector[1] = yVector * scale;
    this.damage = damage;
  }
  
  //methods
  public boolean hit(unit target){
    target.health -= damage;
    return true;
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
  public void death(){
  }
  public boolean update(oneWayLinkedList<unit> x){
    boolean a = update();
    while(x.hasNext()){
      unit target = x.next();
      if(abs(xcor - target.xcor) + abs(ycor - target.ycor) <= size){
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
  public void _draw(){
    fill(0xffFF0000);
    ellipse(xcor,ycor,size,size);
  }
}


class testBullet extends bullet{
  //constructors
  testBullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    super(parent,field,xcor,ycor,size,xVector,yVector,damage);
   
  }
  testBullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    super(field,xcor,ycor,size,xVector,yVector, damage);
    
  }
  
  //methods
  public void _draw(){
    fill(0xffFF0000);
    if(!checkBoundsGhost(this,field)){
      ellipse(xcor,ycor,size,size);
    }
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


class Ebullet extends bullet{
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
  }
  Ebullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.radius = this.size / 2;
    vector[0] = xVector * scale;
    vector[1] = yVector * scale;
    this.damage = damage;
  }
  
  //methods
  public void _draw(){
    fill(0xff1A03FC);
    ellipse(xcor,ycor,size,size);
  }
}
class button{
  //constructor + variables
  int sizeX,sizeY,x,y,x1,y1;
  //include pic, hover animation, and pressed pic
  button(float x,float y,float sizeX,float sizeY){
    this.x = PApplet.parseInt(x * scale);
    this.y = PApplet.parseInt(y * scale);
    this.sizeX = PApplet.parseInt(sizeX * scale);
    this.sizeY = PApplet.parseInt(sizeY * scale);
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
class oneWayLinkedList<E>{
  class Lnode{
    E value;
    Lnode(E x){
      value = x;
    }
    Lnode(E x, Lnode a){
      value = x;
      after = a;
    }
    Lnode after = null;
  }
  
  int size = 0;
  Lnode end = new Lnode(null);
  Lnode start = new Lnode(null,end);
  Lnode current = start;
  Lnode back;
  oneWayLinkedList(){
    }
    public synchronized  void add(E x){
      start.after = new Lnode(x,start.after);
      size++;
    }
    public synchronized  boolean hasNext(){
      if(current.after == null || current.after.value == null){
        rewind();
        return false;
      }
      else{
        return true;
      }
    }
    public synchronized  E next(){
      back = current;
      return (current = current.after).value;
    }
    public synchronized  E getCurrent(){
      return current.value;
    }
    public synchronized  void rewind(){
      current = start;
    }
    public synchronized  void remove(){
      current.value = current.after.value;
      current.after = current.after.after;
      current = back;
      size--;
    }
  }
  
  class SaveSystem{
  SaveSystem(){}
  public void save(){
    try{
     //Command("pwd");
      File file = new File ("savefile.txt");
      file.createNewFile();
      PrintWriter writer = new PrintWriter (file);
      for(int counter = 0; counter < levels.length ; counter++){
        writer.println("" + levels[counter] + " ");
      }
      writer.close();
    } catch (IOException e) {
    }
  }
  }
  



    public void Command(String arg) {
  try{
      String command = arg;

      Process proc = Runtime.getRuntime().exec(command);

      // Read the output

      BufferedReader reader =
    new BufferedReader(new InputStreamReader(proc.getInputStream()));
    BufferedWriter reader1 = new BufferedWriter(new OutputStreamWriter(proc.getOutputStream()));

      String line = "";
      String line1 = "";
      while((line = reader.readLine()) != null) {
          System.out.print(line + "\n");

      }
      proc.waitFor();
  }
  catch(Throwable e){
      e.printStackTrace();
  }
    }
 
class grunt extends unit{
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
      field.players.rewind();
      float BxVector = player.xcor - xcor;
      float ByVector = player.ycor - ycor;
      float fireAngle;
      if(player.ycor < ycor){
          fireAngle = (degrees(atan(BxVector / ByVector)) + 180 +(positiveOrNegative() * random(3))) % 360;
      }
      else{
        fireAngle = (degrees(atan(BxVector / ByVector))+(positiveOrNegative() * random(2))) % 360;
      }
      field.bullets.add(new Ebullet(this,field,xcor,ycor,size,sin(radians(fireAngle)) * speed,cos(radians(fireAngle)) * speed,damage));
  }
  public void _draw(){
    fill(0xff00FAF8);
    ellipse(xcor,ycor,size,size);
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
class Timer{
  public Timer(){
    }
    private long time;
    public void start(){
  time = System.currentTimeMillis();
    }
    public long stop(){
  return (System.currentTimeMillis() - time) / 1000;
    }
}


public void centerWindow(){
  if(surface != null){
    surface.setLocation(centerX,centerY);
  }
}
public void centerWindow(PApplet x){
  if(x.getSurface() != null){
    x.getSurface().setLocation(x.displayWidth/2-x.width/2,x.displayHeight/2-x.height/2);
  }
}
public String randomSelect(String[]x){
  return x[PApplet.parseInt(random(x.length))];
}
public boolean released(char targetKey){//for regular keys
  if(releasedTick != tick){
    return false;
  }
  else{
    if(!codedAndPushed){
      return keyPushed == targetKey;
    }
    else{
      return false;
    }
  }
}
public boolean released(int targetKey){//for codedKeys
  if(releasedTick != tick){
    return false;
  }
  else{
    if(codedAndPushed){
      return keyPushed == targetKey;
    }
    else{
      return false;
    }
  }
}
public int arrayIndex(String[]ary,String target){
  for(int i = 0; i < ary.length; i++){
    if(ary[i].equals(target)){
      return i;
    }
  }
  return -1;
}
public int arrayIndex(char[]ary,char target){
  for(int i = 0; i < ary.length; i++){
    if(ary[i] == target){
      return i;
    }
  }
  return -1;
}
public int positiveOrNegative(){
  if(random(100) > 50){
    return 1;
  }
  else{
    return -1;
  }
}


class delay{
  int wait;
  int counter = 0;
  public void setWait(float wait){
    this.wait = PApplet.parseInt(wait * expectedFrameRate);
  }
  delay(float wait){
    this.wait = PApplet.parseInt(wait * expectedFrameRate);
  }
  public boolean every(){
    if(counter++ % wait == 0){
      return true;
    }
    else{
      return false;
    }
  }
}


class charge{
  int wait;
  int counter = 0;
  charge(float wait){
    this.wait = PApplet.parseInt(wait * expectedFrameRate);
  }
  public void setWait(float wait){
    this.wait = PApplet.parseInt(wait * expectedFrameRate);
  }
  public boolean cooldown(){
    if(counter++ < wait){
      return false;
    }
    else{
      return true;
    }
  }
  public void resetCooldown(){
    counter = 0;
  }
  public boolean cooldown(boolean activation){
    if(cooldown() && activation){
      resetCooldown();
      return true;
    }
    else{
      return false;
    }
  }
}
//bounds
public boolean checkBounds(unit x,battleMode field){
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
public int checkBoundsAdvanced(unit x,battleMode field){
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
}
public boolean checkBoundsGhost(unit x,battleMode field){
  if(x.xcor > field._width - (x.size / 2)){
    return true;
  }
  else if(x.xcor < x.size / 2){
    return true;
  }
  if(x.ycor > field._height - (x.size / 2)){
    return true;
  }
  else if(x.ycor < x.size / 2){
    return true;
  }
  else{
    return false;
  }
}
public boolean checkDisplayBounds(unit x){
  boolean r = false;
  if(x.xcor + centerX > displayWidth - (x.size / 2)){
    x.xcor = (displayWidth - (x.size / 2)) - centerX;
    r = true;
  }
  else if(x.xcor + centerX < x.size / 2){
    x.xcor = (x.size / 2) - centerX;
    r = true;
  }
  if(x.ycor + centerY > displayHeight - (x.size / 2)){
    x.ycor = (displayHeight - (x.size / 2)) - centerY;
    r = true;
  }
  else if(x.ycor + centerY < x.size / 2){
    x.ycor = (x.size / 2) - centerY;
    r = true;
  }
  return r;
}
public boolean inBounds(unit x,battleMode field){
  if(x.xcor > field._width - (x.size / 2)){
    //x.xcor = field._width - (x.size / 2);
    return false;
  }
  else if(x.xcor < x.size / 2){
    //x.xcor = x.size / 2;
    return false;
  }
  if(x.ycor > field._height - (x.size / 2)){
    //x.ycor = field._height - (x.size / 2);
    return false;
  }
  else if(x.ycor < x.size / 2){
    //x.ycor = x.size / 2;
    return false;
  }
  return true;
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
  testButton(int x, int y,int xSize,int ySize){
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
    text("start",x,y,100,100);
  }
}


class muteButton extends button{
  muteButton(int x,int y){
    super(x,y,1,1);
  }
  muteButton(int x,int y,int w,int h){
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
    playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
  }
  public void tick(){
    background(0xffF0F0F0);
    updateButtons();
  }
}
class player extends unit{
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
  
class oneWayLinkedListTestEnvironment extends testEnvironment{
  public void _setup(){
    oneWayLinkedList<Integer> x = new oneWayLinkedList<Integer>();
    x.add(0);
    x.add(1);
    x.add(2);
    x.add(3);
    x.add(4);
    x.add(5);
    x.add(6);
    String r = "";
    while(x.hasNext()){
      Integer a = x.next();
      if(a == 6){
        x.remove();
      }
      else{
      r += a + " ";
      }
    }
    System.out.println(r);
    x.rewind();
    r = "";
    while(x.hasNext()){
      r += x.next() + " ";
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
  public void _setup(){
    super._setup();
    playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
    bullets = new oneWayLinkedList<unit>();
    playerBullets = new oneWayLinkedList<unit>();
    enemies = new oneWayLinkedList<unit>();
    players = new oneWayLinkedList<unit>();
    anime = new oneWayLinkedList<unit>();
    unit a = new testUnitA(this,0.5f,0.5f,0.20f,0.5f);
    players.add(a);
    spawn = new randomEdgeSpawner(this,a);
    spawn.create();
    background(0);
  }
  public void tick(){
    spawn.spawn();
    super.tick();
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
class testUnit extends player{
  float speed = 0.1f * scale;
  testUnit(entity parent,battleMode field,float xcor,float ycor,float size,float displaySize){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.displaySize = displaySize;
    this.radius = this.size / 2;
    health = 100;
  }
  testUnit(battleMode field,float xcor,float ycor,float size,float displaySize){
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
  public bullet createBullet(){
    return new bullet(this,field,xcor,ycor,0.2f * scale,BxVector * scale,ByVector * scale,10);
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
      field.playerBullets.add(createBullet());
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
  public void _draw(){
    fill(0xff00D81B);
    ellipse(xcor,ycor,displaySize,displaySize);
    if(codedKeys[cKeySHIFT]){
      fill(0xffFFFFFF);
      ellipse(xcor,ycor,size,size);
    }
    if(health > 25){
      fill(255);
    }
    else{
      fill(0xffFF0000);
    }
    textSize(25);
    text("hp: " + health + " kills: " + points + " time: " + tick / expectedFrameRate + " " + achievement,0,25);
  }
}
class testUnitA extends testUnit{
  windowMob test = null;
  testUnitA(entity parent,battleMode field,float xcor,float ycor,float size,float displaySize){
    super(parent,field,xcor,ycor,size,displaySize);
    test = new windowMob(this);
    test.getSurface().setVisible(false);
  }
  testUnitA(battleMode field,float xcor,float ycor,float size,float displaySize){
    super(field,xcor,ycor,size,displaySize);
    test = new windowMob(this);
    test.getSurface().setVisible(false);
  }
  public bullet createBullet(){
    return new testBullet(this,field,xcor,ycor,0.2f * scale,BxVector * scale,ByVector * scale,10);
  }
  boolean visiable = false;
  int riftwalks = 0;
  public void _draw(){
    super._draw();
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
class fieldPart extends window{
  fieldPart(String name){
    super(name);
  }
  public void settings(){
  }
  public void setup(){
  }
  public void draw(){
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
  public void keyPressed(){
    KP(this);
  }
  public void keyReleased(){
    KR(this);
  }
  public void _draw(oneWayLinkedList<unit> x,int ccc){
    while(x.hasNext()){
      try{
      unit b = x.next();
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
