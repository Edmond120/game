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
  
  bullet createBullet(){
    if(face[0] == -1 && lastk == 1){
      return new bullet(this,field,xcor,ycor+(face[0]*displaySize),0.2 * scale,0,0,10);
    }
    if(face[0] == 1 && lastk == 2){
      return new bullet(this,field,xcor,ycor+(face[0]*displaySize),0.2 * scale,0,0,10);
    }
    if(face[1] == -1 && lastk == 3){
      return new bullet(this,field,xcor+(face[1]*displaySize),ycor,0.2 * scale,0,0,10);
    }
    if(face[1] == 1 && lastk == 4){
      return new bullet(this,field,xcor+(face[1]*displaySize),ycor,0.2 * scale,0,0,10);
    }
    return new bullet(this,field,xcor+(face[1]*displaySize),ycor,0.2 * scale,0,0,10);
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


class PlayerBomber2 extends player{
  float speed = 0.05 * scale;
  PlayerBomber2(entity parent, battleMode field, float xcor, float ycor, float size, float displaySize){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.displaySize = displaySize;
    this.radius = this.size / 2;
    health = 100;
  }
  PlayerBomber2(battleMode field, float xcor, float ycor, float size, float displaySize){
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
  
  void shoot(){
    field.bullets.add(createBullet());
  }
  
  bullet createBullet(){
    if(face[0] == -1 && lastk == 1){
      return new bullet(this,field,xcor,ycor+(face[0]*displaySize),0.2 * scale,0,0,10);
    }
    if(face[0] == 1 && lastk == 2){
      return new bullet(this,field,xcor,ycor+(face[0]*displaySize),0.2 * scale,0,0,10);
    }
    if(face[1] == -1 && lastk == 3){
      return new bullet(this,field,xcor+(face[1]*displaySize),ycor,0.2 * scale,0,0,10);
    }
    if(face[1] == 1 && lastk == 4){
      return new bullet(this,field,xcor+(face[1]*displaySize),ycor,0.2 * scale,0,0,10);
    }
    return new bullet(this,field,xcor+(face[1]*displaySize),ycor,0.2 * scale,0,0,10);
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
  void death(){
    Mode = new gameOver();
    Mode._setup();
  }
}