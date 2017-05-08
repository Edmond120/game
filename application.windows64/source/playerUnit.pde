class player extends unit{
}
class testUnit extends player{
  float speed = 0.1 * scale;
  testUnit(entity parent,battleMode field,float xcor,float ycor,float size,float displaySize){
    this.parent = parent;
    this.field = field;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    this.displaySize = displaySize;
    this.radius = this.size / 2;
    health = 100;
  }
  testUnit(battleMode field,float xcor,float ycor,float size,float displaySize){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.displaySize = displaySize * scale;
    this.radius = this.size / 2;
    health = 100;
  }
  int[] face = {-1,0};// -1 = up 1 = down, -1 = left 1 = right
  //face must never be {0,0}
  void move(){
    int a = face[0];
    int b = face[1];
    float mSpeed = speed;
    if(codedKeys[cKeySHIFT]){
      mSpeed *= 0.50;//focus speed ratio
    }
    if(codedKeys[cKeyUP] || codedKeys[cKeyDOWN] || codedKeys[cKeyLEFT] || codedKeys[cKeyRIGHT] && 
      !(codedKeys[cKeyUP] && codedKeys[cKeyDOWN] && codedKeys[cKeyLEFT] && codedKeys[cKeyRIGHT])){
      if(!(codedKeys[cKeyUP] && codedKeys[cKeyDOWN])){
        face[0] = 0;
        if(codedKeys[cKeyUP]){
          face[0]--;
          ycor -= mSpeed;
        }
        if(codedKeys[cKeyDOWN]){
          face[0]++;
          ycor += mSpeed;
        }
      }
      if(!(codedKeys[cKeyLEFT] && codedKeys[cKeyRIGHT])){
        face[1] = 0;
        if(codedKeys[cKeyLEFT]){
           face[1]--;
           xcor -= mSpeed;
        }
        if(codedKeys[cKeyRIGHT]){
          face[1]++;
          xcor += mSpeed;
        }
      }
      boolean noChange = keys[keyC];
      if(faceLock){
        noChange = !noChange;
      }
      if(noChange){
        face[0] = a;
        face[1] = b;
      }
      else{
      if(abs(face[0]) > 1){
        face[0] = abs(face[0]) / face[0];
      }
      if(abs(face[1]) > 1){
        face[1] = abs(face[1]) / face[1];
      }
      }
    }
  }
  bullet createBullet(){
    return new bullet(this,field,xcor,ycor,0.2 * scale,BxVector * scale,ByVector * scale,10);
  }
  float BxVector;
  float ByVector;
  float spread = 0.05;
  boolean faceLock = false;
  void shoot(){
    if(codedKeys[cKeySHIFT]){
      spread = 0.015;
    }
    else{
      spread = 0.05;
    }
    BxVector = (face[1] * (0.3 + random(0.1))) + (random(spread) * positiveOrNegative());
      ByVector = (face[0] * (0.3 + random(0.1))) + (random(spread) * positiveOrNegative());
      field.playerBullets.add(createBullet());
  }
  charge zCooldown = new charge(0.1);
  void death(){
    Mode = new gameOver();
    Mode._setup();
  }
  boolean update(){
    if(health <=0){
      return true;
    }
    if(released(CONTROL)){
      faceLock = !faceLock;
    }
    move();
    checkBounds(this,field);
    if(codedKeys[cKeySHIFT]){
      zCooldown.setWait(0.075);
    }
    else{
      zCooldown.setWait(0.1);
    }
    if(zCooldown.cooldown(keys[keyZ])){
      //System.out.print("shoot");
      shoot();
    }
    return false;
  }
  String achievement = "status: trapped in a box of death";
  void _draw(){
    fill(#00D81B);
    ellipse(xcor,ycor,displaySize,displaySize);
    if(codedKeys[cKeySHIFT]){
      fill(#FFFFFF);
      ellipse(xcor,ycor,size,size);
    }
    if(health > 25){
      fill(255);
    }
    else{
      fill(#FF0000);
    }
    textSize(25);
    text("hp: " + health + " kills: " + points + " time: " + tick / expectedFrameRate + " " + achievement,0,25);
  }
}
class testUnitA extends testUnit{
  windowMob test = null;
  testUnitA(entity parent,battleMode field,float xcor,float ycor,float size,float displaySize){
    super(parent,field,xcor,ycor,size,displaySize);
    test = new windowMob(this);
    test.getSurface().setVisible(false);
  }
  testUnitA(battleMode field,float xcor,float ycor,float size,float displaySize){
    super(field,xcor,ycor,size,displaySize);
    test = new windowMob(this);
    test.getSurface().setVisible(false);
  }
  bullet createBullet(){
    return new testBullet(this,field,xcor,ycor,0.2 * scale,BxVector * scale,ByVector * scale,10);
  }
  boolean visiable = false;
  int riftwalks = 0;
  void _draw(){
    super._draw();
    if(out && !visiable){
      test.getSurface().setVisible(true);
      visiable = true;
      test.loop();
      if(riftwalks++ < 10){
          achievement = "status: error404 player not found";
      }
      else{
          achievement = "D:< come back and die plz";
      }
    }
    if(!out && visiable){
      test.getSurface().setVisible(false);
      visiable = false;
      test.noLoop();
      if(riftwalks++ < 10){
        achievement = "status: hacks detected";
      }
      else{
        achievement = "so, how's the outside world?";
      }
    }
    if(out){
      
    }
  }
  boolean out = false;
  boolean update(){
    if(health <= 0){
      return true;
    }
    if(released(CONTROL)){
      faceLock = !faceLock;
    }
    move();
    checkDisplayBounds(this);
    if(inBounds(this,field)){
      out = false;
    }
    else{
      out = true;
    }
    if(zCooldown.cooldown(keys[keyZ])){
      //System.out.print("shoot");
      shoot();
    }
    return false;
  }
}