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
  void action(){
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    fill(#FFFFFF);
    rect(x,y,sizeX,sizeY);
  }
  void tick(){
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
  void _setup(){
  }
  void tick(){
  }
  void updateButtons(){
    for(int i = 0; i < buttons.size(); i++){
      buttons.get(i).tick();
    }
  }
}


class gameOver extends mode{
  void _setup(){
    background(#FF0000);
    buttons.add(new testButton(1,6,3,2));
    buttons.add(new muteButton(4,6));
    buttons.add(new mmButton(5,6,3,2));
  }
  void tick(){
    background(#FF0000);
    textSize(5 * scale);
    fill(0);
    text("R.I.P.",3 * scale,4.5 * scale);
    updateButtons();
  }
}


class testButton extends button{
  testButton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode = new testBattleMode();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Test Game",x+sizeX/4,y+sizeY/2.5,400,400);
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
  void action(){
    muted = !muted;
    if(muted){
      bgmMute();
    }
    else{
      refreshBgmVolume();
    }
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    if(muted){
      image(mutedButton,x,y,sizeX,sizeY);
    }
    else{
      image(unmutedButton,x,y,sizeX,sizeY);
    }
  }
}
String graphicQualityToString(){
  int[]q = {LOW_QUALITY,DEFAULT_QUALITY,HIGH_QUALITY};
  String[]s = {"LOW_QUALITY","DEFAULT_QUALITY","HIGH_QUALITY"};
  return s[arrayIndex(q,graphicQuality)];
}
class qualityButton extends button{
  qualityButton(float x,float y,float sizeX,float sizeY){
   super(x,y,sizeX,sizeY); 
  }
  void action(){
    int[] q = new int[]{LOW_QUALITY,DEFAULT_QUALITY,HIGH_QUALITY};
    int index = arrayIndex(q,graphicQuality);
    if(index >= q.length - 1){
      index = 0;
    }
    else{
      index++;
    }
    graphicQuality = q[index];
  }
  void _draw(){
    super._draw();
   fill(0);
    textSize(25);
    text("Graphic Quality:" + graphicQualityToString(),x + 0.1*scale,y + sizeY/2 - 0.1*scale); 
  }
  
}

class mainMenu extends mode{
  void _setup(){
    buttons.add(new testButton(1,6,3,2));
    buttons.add(new muteButton(4,6));
    buttons.add(new MetropolisButton(1,3.5,3,2));
    buttons.add(new WormButton(1,1,3,2));
    buttons.add(new qualityButton(5,1,6,1));
    //playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
    playBgm("song2.mp3");
  }
  void tick(){
    background(#F0F0F0);
    updateButtons();
  }
}


class MetropolisButton extends button{
  MetropolisButton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode = new Metropolis();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Metropolis Level",x+(x/3),y+(y/4.3),500,500);
  }
}
class WormButton extends button{
  WormButton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode = new giantWormBossLevel();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Worm Level",x+(x/1.5),y+(y/1.2),500,500);
  }
}


class mmButton extends button{
  mmButton(int x, int y,int xSize,int ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode = new mainMenu();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
  }
  void _draw(){
    super._draw();
    fill(0);
    textSize(25);
    text("Main Menu",x+sizeX/4,y+sizeY/2.5,400,400);
  }
}