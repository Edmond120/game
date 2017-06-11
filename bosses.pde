class giantWormBossLevel extends battleMode{
  wormHead head;
  @Override
  void _setup(){
    super._setup();
    head = new wormHead(this,8.0,4.5,2.5,1.75,0,100);
    enemies.add(head);
    players.add(new testunit(this,0.5,0.5,0.20,0.5));
    enemies.add(head.backNode);
  }
  @Override
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
  }
}

class wormHead extends wormSegment{
  wormHead(battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
    this(null,field,xcor,ycor,sizeX,sizeY,angle,health);
    scaleVars();
    //frontNode = new wormNode(this,field,xcor + sizeX/2 + nodeSize/2,ycor,nodeSize,int(health * 0.75));
    backNode = new wormNode(this,field,this.xcor - cos(radians(this.angle))*((this.sizeX + nodeSize)/2),this.ycor - sin(radians(this.angle))*((this.sizeX + nodeSize)/2),nodeSize,int(health * 0.75));
  }
  wormHead(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
   }
   float accel = 0.1;
   float decel = 0.1;
   float turnRate = 4;
   void accelerate(float x){
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
   void decelerate(float x){
    accelerate(-1*x); 
   }
   boolean update(){
     xcor += velocity.x;
     ycor += velocity.y;
     setBackNode();
     return false;
   }
   void turnLeft(float degrees){//degrees is less than 90
     angle -= degrees;
     velocity.rotate(radians(-1*degrees));
   }
   void turnRight(float degrees){//degress is less than 90
     angle += degrees;
     velocity.rotate(radians(degrees));
   }
}
class wormNode extends unit implements circle{
  PVector velocity = new PVector(0,0);
  float limit = 10;//change limit in wormSegment too
  float getXcor(){return xcor;}
  float getYcor(){return ycor;}
  float getSize(){return size;}
  boolean hitCheckCircle(bullet Bullet){
    return Bullet.strikeCircle(this); 
  }
  wormNode(entity parent,battleMode field,float xcor,float ycor,float size,int health){
    super(parent,field,xcor,ycor);
    this.size = size;this.health = health;
  }
  @Override
  void trueDraw(float xcor,float ycor,PApplet applet){
    applet.fill(#300DFF);
    applet.stroke(#300DFF);
    applet.ellipse(xcor,ycor,size,size);
  }
}
class wormSegment extends unit implements rectangle{
  PVector velocity = new PVector(0,0);
  float limit = 10;//change limit in wormNode too
   wormNode frontNode;
   wormNode backNode;
   float nodeSize = 0.5 * scale;
   float velocityX = 0;
   float velocityY = 0;
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
   void setBackNode(){
    backNode.xcor = xcor - cos(radians(angle))*((sizeX + nodeSize)/2);
    backNode.ycor = ycor - sin(radians(angle))*((sizeX + nodeSize)/2); 
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
    //so the code compiles
    //enemies.add(Lula(this,stuff));
    //enemies.add(BunBun(this,stuff));
  }
  @Override
  void tick(){
    super.tick();
  }
}
class Lula extends unit implements rectangle{
  //so the code compiles
  float getXcor(){return xcor;}
  float getYcor(){return ycor;}
  float getSizeX(){return sizeX;}
  float getSizeY(){return sizeY;}
  float getAngle(){return angle;}
  boolean hitCheckCircle(bullet Bullet){
     return Bullet.strikeRectangle(this);
  }
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