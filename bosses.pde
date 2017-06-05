class giantWormBossLevel extends battleMode{
  @Override
  void _setup(){
    enemies.add(wormHead(this,8,4.5,2.5,1.75,0,100));
  }
  @Override
  void tick(){
    super.tick();
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
class wormSegment extends unit{
   float halfHeight,angle,sizeX,sizeY;
   wormSegment(){}
   wormSegment(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor);
     this.sizeX = sizeX;this.sizeY = sizeY;this.health = health;this.angle = angle;
     halfHeight = sizeY / 2;
   }
   void scaleVars(){
    super.scaleVars();
    halfHeight *= scale;
    sizeX *= scale;
    sizeY *= scale;
   }
}
class giantWormBossHead extends wormHead{
  giantWormBossHead(battleMode field,float xcor,float ycor,float sizeX,sizeY,float angle,int health){
    this(null,field,xcor,ycor,sizeX,sizeY,angle,health);
    scaleVars();
  }
  giantWormBossHead(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
    super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
  }
}