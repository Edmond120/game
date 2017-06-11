interface circle{
 float getXcor();float getYcor();float getSize();
}
interface rectangle{
  float getXcor();float getYcor();float getSizeX();float getSizeY();float getAngle();
}
class entity{
  entity parent = null;
  float xcor;
  float ycor;
  boolean update(){
    //true if unit is to be removed
    return false;
  }
  boolean update(oneWayLinkedList<unit> x){//this is for interaction with other entitys
    //true if unit is to be removed
    return false;
  }
  void _draw(){
    trueDraw(xcor,ycor,mainWindow);
  }
  void trueDraw(float xcor, float ycor,PApplet applet){ 
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
  abstract boolean hitCheckCircle(bullet Bullet);/*{bullet is cicular
    return Bullet.strikeCircle(this);
  }*/
  battleMode field;
  int health;
  int points;
  float size;
  float radius;
  float displaySize;
  void scaleVars(){
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
  void death(){
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
  void _setup(){
   
  }
  void _background(PApplet applet){
    applet.background(0);
  }
  void tick(){
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
  void update(oneWayLinkedList<unit> a, oneWayLinkedList<unit> b){
    while(a.hasNext()){
      if(a.next().update(b)){
        a.getCurrent().death();
        a.remove();
      }
    }
    
  }
  void update(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      if(x.next().update()){
        x.getCurrent().death();
        x.remove();
      }
    }
    
  }
  void _draw(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      x.next()._draw();
    }
    
  }
}