class giantWormBossLevel extends battleMode{
  wormHead head;fieldPart fp;
  @Override
  void _setup(){
    super._setup();
    players.add(new testunit(this,0.5,0.5,0.20,0.5));
    head = makeWorm(this);
    fp = createFieldPart(this,"worm",int(4 * scale),int(4*scale),int(head.getXcor() + centerX),int(head.getYcor() + centerY),true);
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
    if(keys[keyL]){
      wormBossOpening += -0.1 * scale;
    }
    if(keys[keyK]){
      wormBossOpening += 0.3 * scale;
      if(wormBossOpening > 0){
       wormBossOpening = 0; 
      }
    }
    if(!out){
      if(head.getXcor() < 0 || head.getXcor() > width || head.getYcor() < 0 || head.getYcor() > height){
        out = true;
        fp.vis();
      }
    }
    else{
      if(head.getXcor() >= 0 && head.getXcor() <= width && head.getYcor() >= 0 && head.getYcor() <= height){
       out = false;
       fp.invis();
      }
    }
    checkDisplayBounds(head.location);
    centerWindow(mainWindow);
    fp.setLocation(int(head.getXcor() + centerX - fp.width/2),int(head.getYcor() + centerY - fp.height/2));
  }
  boolean out = false;
}                           
                             //sizeX,sizeY,angle,health,segments
float[] wormBossStats = {1,    0.5,  0,    2000,  16};
float wormBossOpening = 0 * scale;
float endFriction = 0.85;
float constantFriction = 0.97;
boolean snap = false;
boolean useConstantFriction = false;
wormHead makeWorm(battleMode field){
  float[]s = wormBossStats;
  wormHead head = new wormHead(field,width/scale - s[0]/2,s[1]/2,s[0],s[1],s[2],int(s[3]));
  wormSegment currentSegment = head.backNode.createSegment(s[0]*scale,s[1]*scale,s[2],int(s[3]));
  for(int n = 0;n < s[4] - 2;n++){
    currentSegment = currentSegment.createBackNode().createSegment(s[0]*scale,s[1]*scale,s[2],int(s[3]));
  }
  wormTail tail = currentSegment.createBackNode().createTail(s[0],s[1],s[2],int(s[3]));
  wormNode currentNode = head.backNode;
  for(int n = 0;n < s[4] - 1;n++){
    field.enemies.addLast(currentNode);
    if(useConstantFriction){
      currentNode.friction = constantFriction;
    }
    else{
      currentNode.friction = 1 - n*((1 - endFriction)/s[4]);
    }
    currentNode = currentNode.backSegment.backNode;
  }
   field.enemies.addLast(tail.backNode);//debug
   field.enemies.addLast(tail);
  currentSegment = head.backNode.backSegment;
  for(int n = 0;n < s[4] - 2;n++){
    field.enemies.addLast(currentSegment);
    currentSegment = currentSegment.backNode.backSegment;
  }
  field.enemies.addLast(head);
  return head;
}
class wormHead extends wormSegment{
  wormHead(battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
    this(null,field,xcor,ycor,sizeX,sizeY,angle,health);
    scaleVars();
    //frontNode = new wormNode(this,field,xcor + sizeX/2 + nodeSize/2,ycor,nodeSize,int(health * 0.75));
    backNode = new wormNode(null,field,this.xcor - cos(radians(this.angle))*((this.sizeX + getSizeY())/2),this.ycor - sin(radians(this.angle))*((this.sizeX + getSizeY())/2),getSizeY(),int(health * 0.75),this);
  }
  wormHead(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
     
   }
   float limit = 25;//change limit in wormNode too
   float accel = 0.1;
   float decel = 0.2;
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
   void move(){
     setXcor(getXcor() + velocity.x);
     setYcor(getYcor() + velocity.y);
     setBackNode();
   }
   boolean update(){
     move();
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
class wormTail extends wormSegment{
  wormTail(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor,sizeX,sizeY,angle,health);
     createBackNode();
   }
   boolean update(){
     //backNode.update();
     return super.update();
   }
}
class wormNode extends unit implements circle{
  PVector location;
  PVector targetLocation;
  float friction = 1;
  wormSegment frontSegment,backSegment;
  PVector velocity = new PVector(0,0);
  //float limit = 10;//change limit in wormSegment too
  float getXcor(){return location.x;}
  float getYcor(){return location.y;}
  float getSize(){return size;}
  void setXcor(float x){location.x = x;}
  void setYcor(float x){location.y = x;}
  void setSize(float x){size = x;}
  boolean hitCheckCircle(bullet Bullet){
    return Bullet.strikeCircle(this); 
  }
  wormSegment createSegment(float sizeX,float sizeY,float angle,int health){
    PVector l = PVector.add(location,PVector.fromAngle(radians(angle + 180)).mult((sizeX + getSize())/2));
    wormSegment newSegment = new wormSegment(this,field,l.x,l.y,sizeX,sizeY,angle,health);
    newSegment.frontNode = this;
    backSegment = newSegment;
    return newSegment;
  }
  
  wormTail createTail(float sizeX,float sizeY,float angle,int health){
    PVector l = PVector.add(location,PVector.fromAngle(radians(angle + 180)).mult((sizeX + getSize())/2));
    wormTail newSegment = new wormTail(this,field,l.x,l.y,sizeX,sizeY,angle,health);
    newSegment.frontNode = this;
    backSegment = newSegment;
    return newSegment;
  }
  //entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health
  wormNode(wormNode parent,battleMode field,float xcor,float ycor,float size,int health,wormSegment frontSegment){
    super(parent,field,xcor,ycor);
    this.size = size;this.health = health;
    location = new PVector(xcor,ycor);
    this.frontSegment = frontSegment;
  }
  boolean update(){
    if(parent != null){
       move();
    }
    return false;
  }
  void move(){
    if(velocity.mag() < 0.15){//friction
     velocity.set(0,0); 
    }
    else{
     velocity.mult(friction); 
    }
    location.add(velocity);
    wormNode p = ((wormNode)parent);
    PVector targetLocation = p.location;
    PVector difference = PVector.sub(targetLocation,location);
    difference.setMag(difference.mag() - frontSegment.getSizeX() - (getSize() + (p.getSize()))/2 + wormBossOpening);
    velocity.add(difference);
    location.add(difference);
    PVector angle1 = PVector.fromAngle(radians(frontSegment.getAngle()));
    PVector angle2 = PVector.fromAngle(radians(p.frontSegment.getAngle()));
    float diff = angle2.heading() - angle1.heading();
    //println(tan(radians(p.frontSegment.getAngle())));
    if(abs(diff) > HALF_PI){
      //float t = tan(radians(p.frontSegment.getAngle()));
      //pDir = dir;
      //dir = (t > 0);
        //dir = true;
        //boolean x = diff > 0;
        //if(pDir != dir){x = !x; dir = false;}
        
        //if(keys[keyM]){
        //  x = !x;
        //}
       // PVector oldLocation = location;
       if(snap){
        if(diff <= 0){
          PVector a = new PVector(-angle2.y,angle2.x).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
         location = a;
        }
        else if (diff > 0){
          PVector b = new PVector(-angle2.y,angle2.x).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
         location = b;
        }}
        //println(100.0 / scale);
        //if(abs(getYcor() - pycor) > 1 * scale){
         // location = oldLocation;
        //}
      /*}
      else{
       boolean x = diff > 0;
       if(dir){x = !x; dir = false;}
        if(x){
         location = angle2.rotate(HALF_PI).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
        }
        else{
         location = angle2.rotate(-1*HALF_PI).setMag(frontSegment.getSizeX() + (getSize() + p.getSize())/2).add(targetLocation);
        }
      }*/
    }
    pxcor = getXcor();
        pycor = getYcor();
  }
  float pxcor;
  float pycor;
  @Override
  void _draw(){
   trueDraw(location.x,location.y,mainWindow); 
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
  PVector location;
   wormNode frontNode;
   wormNode backNode;
   //float nodeSize = 0.5 * scale;
   float velocityX = 0;
   float velocityY = 0;
   float angle,sizeX,sizeY;
   float getXcor(){return location.x;}
   float getYcor(){return location.y;}
   float getSizeX(){return sizeX;}
   float getSizeY(){return sizeY;}
   float getAngle(){return angle;}
   void setXcor(float x){location.x = x;}
   void setYcor(float x){location.y = x;}
   void setSizeX(float x){sizeX = x;}
   void setSizeY(float x){sizeY = x;}
   void setAngle(float x){angle = x;}
   boolean hitCheckCircle(bullet Bullet){
    return Bullet.strikeRectangle(this);
   }
   wormSegment(){}
   wormSegment(entity parent,battleMode field,float xcor,float ycor,float sizeX,float sizeY,float angle,int health){
     super(parent,field,xcor,ycor);
     this.sizeX = sizeX;this.sizeY = sizeY;this.health = health;this.angle = angle;
     location = new PVector(xcor,ycor);
   }
   wormNode createBackNode(){
    return backNode = new wormNode(frontNode,field,this.xcor - cos(radians(this.angle))*((this.sizeX + getSizeY())/2),this.ycor - sin(radians(this.angle))*((this.sizeX + getSizeY())/2),getSizeY(),int(health * 0.75),this); 
   }
   boolean update(){
     move();
     return false;
   }
   void move(){
     angle = degrees(PVector.sub(frontNode.location,backNode.location).heading());
     //location = PVector.fromAngle(radians(angle)).mult(((backNode.getSize() + getSizeX())/2)).add(backNode.location);
     location = PVector.add(frontNode.location,backNode.location).mult(0.5);
   }
   void scaleVars(){
    super.scaleVars();
    sizeX *= scale;
    sizeY *= scale;
    location.mult(scale);
   }
   void setBackNode(){
    backNode.setXcor(getXcor() - cos(radians(angle))*((sizeX + backNode.getSize())/2));
    backNode.setYcor(getYcor() - sin(radians(angle))*((sizeX + backNode.getSize())/2)); 
   }
   @Override
   void _draw(){
       trueDraw(location.x,location.y,mainWindow); 
   }
   @Override
   void trueDraw(float xcor,float ycor,PApplet applet){
     applet.pushMatrix();
     applet.stroke(#00F2FC);
     applet.fill(#FFFFFF);
     applet.translate(xcor,ycor);
     applet.rotate(radians(angle));
     applet.rect(sizeX/-2,sizeY/-2,sizeX,sizeY);
     applet.popMatrix();
   }
}





class Metropolis extends battleMode{
  @Override
  void _setup(){
    super._setup();
    player a = new testunit(this,0.5,0.5,0.20,0.5);
    players.add(a);
    enemies.add(new Lula(this,10,5,0.4,0.6,a));
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
  void setXcor(float x){xcor = x;}
  void setYcor(float x){ycor = x;}
  void setSizeX(float x){sizeX = x;}
  void setSizeY(float x){sizeY = x;}
  void setAngle(float x){float angle = x;}
  boolean hitCheckCircle(bullet Bullet){
     return Bullet.strikeRectangle(this);
  }
  
  
  float sizeX,sizeY;
  float mvtspeed = 2;
  PVector ploc;
  PVector location;
  PVector velocity;
  boolean[] ActOptions = new boolean[5]; //0 p>2.5x, 1 p>1.5x, 2 p>r, 3 is BunBun alive?
  boolean[] isAttackingStill = new boolean[5]; //0 miniCBs, 1 DuoAttack
  Lula child;
  boolean alive = true;
  boolean indanger;
  entity player;
  
  Lula(battleMode field,float xcor,float ycor,float _width,float _height,entity player){
    super();
    this.field = field;
    this.sizeX = _width*scale;
    this.sizeY = _height*scale;
    location = new PVector(xcor*scale,ycor*scale);
    velocity = new PVector(0,0);
    this.player = player;
    ploc = new PVector(player.getXcor(),player.getYcor());
    health = 100;
    setXcor(xcor*scale);
    setYcor(ycor*scale);
  }
  Lula(){}
  
  
  void getVelocityTo(float _speed){
    PVector direction = ploc.sub(location);
    direction.normalize();
    direction.mult(-1*_speed);
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
    if(indanger){
      if(isAttackingStill[1]){
        //DuoAttack();
      }else{
        //DuoAttack();
      }
    }
  }
  
 
  void move(){
    getVelocityTo(mvtspeed);
    /*if(abs(location.x-0)<abs(location.y-0) || 
       abs(location.x-0)<abs(location.y-height) || 
       abs(location.x-width)<abs(location.y-0) || 
       abs(location.x-width)<abs(location.y-height)){
      PVector a = new PVector(-1*velocity.y, velocity.x);
      location.add(a);
      System.out.println(location);
    }else{
      PVector b = new PVector(velocity.y,-1*velocity.x);
      location.add(b);
      System.out.println(location);
    }*/
    location.add(velocity);
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
      }/*else{
        if(special.cooldown()){
          special.resetCooldown();
          throwBigCB();
        }
      }*/
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
  void throwMiniCB(){
    field.playerBullets.add(createMiniCB());
  }
  bullet createMiniCB(){//gotta modify this
    return new testbullet(this,field,getXcor(),getYcor(),0.2 * scale,ploc.x * scale,ploc.y * scale,10);
  }
  void throwBigCB(){}
  void DuoAttack(){}
  float r = 2*scale;
  void boundsCheck(){
    if(abs(ploc.x-getXcor())+abs(ploc.y-getYcor())<(4.5*r)){
      ActOptions[0] = false;
      if(abs(ploc.x-getXcor())+abs(ploc.y-getYcor())<(2.5*r)){
        ActOptions[1] = false;
        if(abs(ploc.x-getXcor())+abs(ploc.y-getYcor())<r){
          ActOptions[2] = false;
          indanger = true;
        }else{ActOptions[2] = true;}
      }else{ActOptions[1] = true;ActOptions[2] = false;}
    }else{ActOptions[0] = true;ActOptions[1] = false;ActOptions[2] = false;}
    
    if(ActOptions[3]){
      checkStatus();
    }
  }
  
  boolean update(){ 
    if(ActOptions[4] == false && health < 0){return true;}
    ploc = new PVector(player.getXcor(), player.getYcor());
    boundsCheck(); //checks if Lula's on screen and updates ActOptions
    actions();
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