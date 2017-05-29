class Bombomb extends battleMode{
  void _setup(){
    super._setup();
    playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
    bullets = new oneWayLinkedList<unit>();
    playerBullets = new oneWayLinkedList<unit>();
    enemies = new oneWayLinkedList<unit>();
    players = new oneWayLinkedList<unit>();
    anime = new oneWayLinkedList<unit>();
    unit a = new PlayerBomber1(this,0.5,0.5,0.20,0.5);
    players.add(a);
    unit b = new PlayerBomber2(this,displayWidth-20,displayHeight-20,0.20,0.5);
    players.add(b);
    /*enemies.add(new grunt(this, width-3, height-3,0.5,10,a));
    enemies.add(new grunt(this, 0, height-3,0.5,10,a));
    enemies.add(new grunt(this, width-3, 0,0.5,10,a));*/
    background(0);
  }
  void tick(){
    super.tick();
  }
}

class PlayerBomber1 extends player{
  float speed = 0.05 * scale;
  PlayerBomber1(entity parent, battleMode field, float xcor, float ycor, float size, float displaySize){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.displaySize = displaySize;
    this.radius = this.size / 2;
    health = 100;
  }
  PlayerBomber1(battleMode field, float xcor, float ycor, float size, float displaySize){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.displaySize = displaySize * scale;
    this.radius = this.size / 2;
    health = 100;
  }
  
  int[] face = {-1,1};// -1 = up 1 = down, -1 = left 1 = right
  int lastk = 1;
  void move(){
   if(codedKeys[cKeyUP]){
     ycor -= speed;
     face[0] = -1;
     lastk = 1;
   }
   if(codedKeys[cKeyDOWN]){
     ycor += speed;
     face[0] = 1;
     lastk = 2;
   }
   if(codedKeys[cKeyLEFT]){
     xcor -= speed;
     face[1] = -1;
     lastk = 3;
   }
   if(codedKeys[cKeyRIGHT]){
     xcor += speed;
     face[1] = 1;
     lastk = 4;
   }
  }
  
  void shoot(){
    field.bullets.add(createBullet());
  }
  
  bomb createBullet(){
    if(face[0] == -1 && lastk == 1){
      return new bomb(this,field,xcor,ycor+(face[0]*displaySize),0.2 * scale,0,0,10);
    }
    if(face[0] == 1 && lastk == 2){
      return new bomb(this,field,xcor,ycor+(face[0]*displaySize),0.2 * scale,0,0,10);
    }
    if(face[1] == -1 && lastk == 3){
      return new bomb(this,field,xcor+(face[1]*displaySize),ycor,0.2 * scale,0,0,10);
    }
    if(face[1] == 1 && lastk == 4){
      return new bomb(this,field,xcor+(face[1]*displaySize),ycor,0.2 * scale,0,0,10);
    }
    return new bomb(this,field,xcor+(face[1]*displaySize),ycor,0.2 * scale,0,0,10);
  }
  
  charge Cooldown = new charge(1);
  boolean update(){
    if(health <=0){
      return true;
    }
    move();
    checkBounds(this,field);
    Cooldown.setWait(1);
    if(Cooldown.cooldown(codedKeys[cKeySHIFT])){
      shoot();
    }
    return false;
  }
  
  void _draw(){
    fill(#00D81B);
    ellipse(xcor,ycor,displaySize,displaySize);
    if(health > 25){
      fill(255);
    }
    else{
      fill(#FF0000);
    }
    textSize(25);
    text("PL1 hp: " + health + " kills: " + points,0,25);
  }
  void death(){
    Mode = new gameOver();
    Mode._setup();
  }
}


class PlayerBomber2 extends PlayerBomber1{
  float speed = 0.05 * scale;
  PlayerBomber2(entity parent, battleMode field, float xcor, float ycor, float size, float displaySize){
    super(parent,field,xcor,ycor,size,displaySize);
    health = 100;
  }
  PlayerBomber2(battleMode field, float xcor, float ycor, float size, float displaySize){
    super(field,xcor,ycor,size,displaySize);
    health = 100;
  }
  
  int[] face = {-1,1};// -1 = up 1 = down, -1 = left 1 = right
  int lastk = 1;
  void move(){
   if(keys[keyW]){
     ycor -= speed;
     face[0] = -1;
     lastk = 1;
   }
   if(keys[keyS]){
     ycor += speed;
     face[0] = 1;
     lastk = 2;
   }
   if(keys[keyA]){
     xcor -= speed;
     face[1] = -1;
     lastk = 3;
   }
   if(keys[keyD]){
     xcor += speed;
     face[1] = 1;
     lastk = 4;
   }
  }
  
  charge Cooldown = new charge(1);
  boolean update(){
    if(health <=0){
      return true;
    }
    move();
    checkBounds(this,field);
    Cooldown.setWait(1);
    if(Cooldown.cooldown(keys[keyQ])){
      shoot();
    }
    return false;
  }
  
  void _draw(){
    fill(#00D81B);
    ellipse(xcor,ycor,displaySize,displaySize);
    if(health > 25){
      fill(255);
    }
    else{
      fill(#FF0000);
    }
    textSize(25);
    text("PL2 hp: " + health + " kills: " + points,0,50);
  }
}


class bomb extends bullet{
  int damage;
  float[] vector = new float[2];
  bomb(){
  }
  bomb(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.radius = this.size / 2;
    vector[0] = xVector;
    vector[1] = yVector;
    this.damage = damage;
  }
  bomb(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.radius = this.size / 2;
    vector[0] = xVector * scale;
    vector[1] = yVector * scale;
    this.damage = damage;
  }
  
  //methods
  boolean hit(unit target){
    target.health -= damage;
    return true;
  }
  boolean update(){
    xcor += vector[0];
    ycor += vector[1];
    if(checkBounds(this,field)){
      return true;
    }
    else{
      return false;
    }
  }
  void death(){
    field.bullets.add(new boom(field,xcor, ycor, size,damage));
  }
  delay noboom = new delay(3);
  boolean update(oneWayLinkedList<unit> x){
    if (noboom.every()){
      while(x.hasNext()){
        unit target = x.next();
        if((abs(xcor - target.xcor) <= 50 && ycor - target.ycor == 0) || (abs(ycor - target.ycor) <= 50 && xcor - target.xcor == 0)){
          hit(target);
        }
      }
      return true;
    }
    return false;
  }
  void _draw(){
    fill(#FFFFFF);
    ellipse(xcor,ycor,size,size);
  }
}


class boom extends bullet{
  boom(battleMode field,float xcor,float ycor,float size,int damage){
    super();
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.damage = damage;
  }
  
  //methods
  delay time = new delay(5); // set to 5 seconds for debugging
  delay explosionDamageTick = new delay(0.1); //this is for damage over time areas, but in bomberman you take damage only once from each bomb, this is still do-able by giving bombs IDs.
  boolean update(oneWayLinkedList<unit> x){
    if(time.every()){
      //stroke(#000000);
      return true;
    }
    else{
      if(explosionDamageTick.every()){
      while(x.hasNext()){
        unit target = x.next();
        if((abs(xcor - target.xcor) <= target.size / 2 && abs(ycor - target.ycor) <= 50) || (abs(ycor - target.ycor) <= target.size / 2 && abs(xcor - target.xcor) <= 50)){
          hit(target);
        }
      }
    }
    return false;
  }
}
  void _draw(){
      fill(#FF0000);
      ellipse(xcor,ycor,size,size);
      line(xcor+50,ycor, xcor-50,ycor);
      line(xcor,ycor+50, xcor,ycor-50);      
      stroke(#FF0000);
  }
}
   
   
/*
class boom extends animation{
  boom(battleMode field,float xcor,float ycor,float size){
    super(field,xcor,ycor,size);
  }
  
  delay time = new delay(0.5);
  boolean update(){
    if(time.every()){
      stroke(#000000);
      return true;
    }
    else{
      fill(#FF0000);
      ellipse(xcor,ycor,size,size);
      line(xcor+50,ycor, xcor-50,ycor);
      line(xcor,ycor+50, xcor,ycor-50);      
      stroke(#FF0000);
      return false;
    }
  }
}*/

class Bombombutton extends button{
  Bombombutton(float x, float y,float xSize,float ySize){
    super(x,y,xSize,ySize);
  }
  void action(){
    Mode = new Bombomb();
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
    text("Bomberman",x+sizeX/4.5,y+sizeY/2.4,300,300);
  }
}

    
      
