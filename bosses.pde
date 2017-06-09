class giantWormBossLevel extends battleMode{
  wormHead head;
  @Override
  void _setup(){
    super._setup();
    head = new wormHead(this,8.0,4.5,2.5,1.75,45,100);
    enemies.add(head);
  }
  @Override
  void tick(){
    super.tick();
    head.angle++;
  }
}

class wormHead extends wormSegment{
  wormHead(battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
    this(null,field,xcor,ycor,sizeX,sizeY,angle,health);
    scaleVars();
  }
  wormHead(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
   }
}
class wormSegment extends unit implements rectangle{
   float angle,sizeX,sizeY;
   float getXcor(){return xcor;}
   float getYcor(){return ycor;}
   float getSizeX(){return sizeX;}
   float getSizeY(){return sizeY;}
   float getAngle(){return angle;}
   boolean hitCheckCircle(bullet Bullet){
    return Bullet.strikeRectangle(this);
   }
   wormSegment(){}
   wormSegment(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor);
     this.sizeX = sizeX;this.sizeY = sizeY;this.health = health;this.angle = angle;
   }
   void scaleVars(){
    super.scaleVars();
    sizeX *= scale;
    sizeY *= scale;
   }
   @Override
   void trueDraw(float xcor,float ycor,PApplet applet){
     pushMatrix();
     stroke(#00F2FC);
     fill(#FFFFFF);
     translate(xcor,ycor);
     rotate(radians(angle));
     rect(sizeX/-2,sizeY/-2,sizeX,sizeY);
     popMatrix();
   }
}
class giantWormBossHead extends wormHead{
  giantWormBossHead(battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
    this(null,field,xcor,ycor,sizeX,sizeY,angle,health);
    scaleVars();
  }
  giantWormBossHead(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
    super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
  }
}




class Metropolis extends battleMode{
  @Override
  void _setup(){
    enemies.add(Lula(this,stuff));
    enemies.add(BunBun(this,stuff));
  }
  @Override
  void tick(){
    super.tick();
  }
}
class Lula extends unit implements rectangle{
  float sizeX,sizeY;
  unit player;
  
  float speed = 0.075 * scale;
  float angle = radians(0);
  Lula(battleMode field,float xcor,float ycor,float _width,float _height,unit player){
    super(field,xcor,ycor);
    this.player = player;
    this.sizeX = _width*scale;
    this.sizeY = _height*scale;
  }
}