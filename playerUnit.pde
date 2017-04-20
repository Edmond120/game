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
  }
  testUnit(battleMode field,float xcor,float ycor,float size,float displaySize){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.displaySize = displaySize * scale;
    this.radius = this.size / 2;
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
      boolean noChange = codedKeys[cKeyALT];
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
  boolean faceLock = false;
  void shoot(){
    float xVector = (face[1] * (0.3 + random(0.1))) + (random(0.05) * positiveOrNegative()); //0.6 is the speed of the bullet
      float yVector = (face[0] * (0.3 + random(0.1))) + (random(0.05) * positiveOrNegative());
      field.playerBullets.add(new bullet(this,field,xcor,ycor,0.2 * scale,xVector * scale,yVector * scale,10));
  }
  charge zCooldown = new charge(0.1);
  boolean update(){
    if(pushed(CONTROL)){
      faceLock = !faceLock;
    }
    move();
    checkBounds(this,field);
    if(zCooldown.cooldown(keys[keyZ])){
      //System.out.print("shoot");
      shoot();
    }
    return false;
  }
  void _draw(){
    fill(#00D81B);
    ellipse(xcor,ycor,displaySize,displaySize);
    if(codedKeys[cKeySHIFT]){
      fill(#FFFFFF);
      ellipse(xcor,ycor,size,size);
    }
  }
}