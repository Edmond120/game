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
  testButton(int x, int y,int xSize,int ySize){
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
  muteButton(int x,int y){
    super(x,y,1,1);
  }
  muteButton(int x,int y,int w,int h){
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


class mainMenu extends mode{
  void _setup(){
    buttons.add(new testButton(1,6,3,2));
    buttons.add(new muteButton(4,6));
    buttons.add(new Bombombutton(1,3,3,2));
    playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
  }
  void tick(){
    background(#F0F0F0);
    updateButtons();
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