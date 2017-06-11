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
    super._setup();
    //enemies.add(new Lula(this,20.0,20.0,5.0,6.0,new PVector(centerX,centerY)));
    //players.add(new testunit(this,0.5,0.5,0.20,0.5));
    //enemies.add(BunBun(Lula,stuff));
    //Lula.setChild(BunBun);
  }
  @Override
  void tick(){
    super.tick();
  }
}
class Lula extends unit implements rectangle{
  void setChild(Lula _child){
    this.child = _child;
  }
  
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
  boolean[] ActOptions = new boolean[5]; //0 p>2.5x, 1 p>1.5x, 2 p>r, 3 p<=r, 4 is BunBun alive?
  boolean[] isAttackingStill = new boolean[5]; //0 miniCBs, 1 DuoAttack
  Lula child;
  boolean alive = true;
  boolean indanger;
  
  Lula(battleMode field,float xcor,float ycor,float _width,float _height,PVector playerlocation){
    super(field,xcor,ycor);
    this.sizeX = _width*scale;
    this.sizeY = _height*scale;
    location = new PVector(xcor*scale,ycor*scale);
    velocity = new PVector(0,0);
    ploc = playerlocation;
    health = 100;
  }
  Lula(){}
  /*
  void getVelocityTo(float _speed){
    PVector direction = location.sub(ploc);
    direction.normalize();
    direction.mult(_speed);
    velocity = direction;
  }
  
  
  
  void actions(){
    if (ActOptions[0]){
      attack();
    }
    if(ActOptions[1]){
      if(isAttackingStill[0]){
        attack();
      }else{
        if((int)(Math.random()*2) == 0){
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
    if(ActOptions[3]){
      if(isAttackingStill[1]){
        DuoAttack();
      }else{
        indanger = true;
        DuoAttack();
      }
    }
  }
  
 
  void move(){
    getVelocityTo(mvtspeed);
    if(abs(location.x-0)<abs(location.y-0) || abs(location.x-0)<abs(location.y-height) || abs(location.x-width)<abs(location.y-0) || abs(location.x-width)<abs(location.y-height)){
      PVector a = new PVector(-1*velocity.y, velocity.x);
      location.add(a);
    }else{
      PVector b = new PVector(velocity.y,-1*velocity.x);
      location.add(b);
    }
  }
  
  charge basic = new charge(7);
  charge special = new charge(15);
  charge basiclength = new charge(2);
  int miniCBamt = 0;
  void attack(){
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
  
  void bunBunDied(){
    this.ActOptions[4] = false;
    this.health = 15;
  }
  
  void checkStatus(){//in boundscheck check if ActOptions[4] then checkStatus()
    alive = child.alive;
    if(!alive){
      bunBunDied();
    }
  }
  
  void death(){}
  void throwMiniCB(){}
  void throwBigCB(){}
  void DuoAttack(){}
  void boundsCheck(){}
  */
  
  boolean update(){ 
    //if(ActOptions[4] == false && health < 0){return true;}
    //boundsCheck(); //checks if Lula's on screen and updates ActOptions
    //actions();
    return false;
  }
  @Override
  void trueDraw(float xcor,float ycor,PApplet applet){
    pushMatrix();
    stroke(#000000);
    fill(#E07407);
    translate(xcor,ycor);
    rotate(radians(0));
    rect(sizeX/-2,sizeY/-2,sizeX,sizeY);
    popMatrix();
  }
}



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