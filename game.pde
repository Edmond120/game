import java.util.ArrayList;
import java.awt.Robot;
import processing.sound.*;
import java.lang.Math;
import javax.sound.sampled.*;
import java.awt.event.KeyEvent;
int scale = 20;
int fieldHeight;
int fieldWidth;
boolean pmousePressed;
boolean muted = true;
int tick = 0;
int expectedFrameRate;
int frameSizeX;
int frameSizeY;
mode Mode;
void settings(){
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
}
Robot robot;
void setup(){
  frameRate(60);
  expectedFrameRate = 60;
  surface.setResizable(true);
  centerWindow();
  //frame.setSize(1000,1000);
  //frame.setLocation(100,100);
  Mode = new mainMenu();
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
void draw(){
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

//keyboard
char[]_keys = {'z','x'};
int keyZ = 0;int keyX = 1;
boolean[]keys = new boolean[_keys.length];
int[] _codedKeys = {UP,DOWN,LEFT,RIGHT,SHIFT,CONTROL,ALT};
int cKeyUP = 0;int cKeyDOWN = 1;int cKeyLEFT = 2;int cKeyRIGHT = 3;int cKeySHIFT = 4;int cKeyCONTROL = 5;
int cKeyALT = 6;
boolean[]codedKeys = new boolean[_codedKeys.length];
int keyPushed;/*most recently key that was push, a push is the process of pressing AND releasing a key
this only need to be checked in keyReleased() because a key must be already pressed to be released.*/
boolean codedAndPushed = false;/*codedAndPushed[0] == if the last key pushed was coded or not.
codedAndPushed[1] == if there is a key pushed right now.
codedAndPushed[1] is set to false at draw*/
//^^^ the function these are used for are located at the tab helper
int releasedTick;
void keyPressed(){
  checkKey(true);
}
void keyReleased(){
  releasedTick = tick;
  if(key == CODED){
    //System.out.println(keyCode + " Coded");
    keyPushed = keyCode;
    codedAndPushed = true;
  }
  else{
    //System.out.println(key + " normal");
    keyPushed = key;
    codedAndPushed = false;
  }
  checkKey(false);
}
void checkKey(boolean setValue){
  if(key == CODED){
    for(int i = 0; i < _codedKeys.length;i++){
      if(keyCode == _codedKeys[i]){
        codedKeys[i] = setValue;
        return;
      }
    }
  }
  else{
    for(int i = 0; i < keys.length;i++){
      if(java.lang.Character.toLowerCase(key) == _keys[i]){
        keys[i] = setValue;
        return;
      }
    }
  }
}