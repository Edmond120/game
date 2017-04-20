class mode{
  void _setup(){
  }
  void tick(){
  }
}
class testButton extends button{
  testButton(int x, int y,int xSize,int ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode = new battleMode();
    Mode._setup();
  }
  void pushed(){
  }
  void hover(){
    _draw();
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
  ArrayList<button>buttons = new ArrayList<button>();
  void _setup(){
    buttons.add(new testButton(1,6,3,2));
    buttons.add(new muteButton(4,6));
    playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
  }
  void tick(){
    background(#F0F0F0);
    for(int i = 0; i < buttons.size(); i++){
      buttons.get(i).tick();
    }
  }
}