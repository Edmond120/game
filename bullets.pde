class bullet extends unit{
  //constructors + variables
  int damage;
  float[] vector = new float[2];
  int colour = #FF0000;
  bullet(){
  }
  bullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
    super(parent,field,xcor,ycor);
    this.size = size;
    this.radius = this.size / 2;
    vector[0] = xVector;
    vector[1] = yVector;
    this.damage = damage;
    this.displaySize = this.size;
  }
  bullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this(null,field,xcor,ycor,size,xVector,yVector,damage);
    scaleVars();
  }
  boolean hitCheckCircle(bullet Bullet){
    throw new UnsupportedOperationException();
  }
  void scaleVars(){
   super.scaleVars();
   vector[0] *= scale;
   vector[1] *= scale;
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
  }
  boolean strikeCircle(circle hitbox){//target's hitbox is cicular
   return abs(xcor - hitbox.getXcor()) + abs(ycor - hitbox.getYcor()) <= (size / 2) + (hitbox.getSize() / 2); 
  }
  boolean strikeRectangle(rectangle hitbox){
    float slopeLong = tan(radians(hitbox.getAngle()));
    float interceptLong = hitbox.getYcor() - (hitbox.getXcor() * slopeLong);
    float slopeShort = -1/slopeLong;
    float intersectX = (interceptLong - (ycor - (xcor * slopeShort)))/(slopeShort - slopeLong);
    float intersectY = intersectX * slopeLong + interceptLong;
    if(!(distanceEq(intersectX,intersectY,xcor,ycor) <= (hitbox.getSizeY() / 2) + (size / 2))){
      return false;
    }
      float interceptShort = hitbox.getYcor() - (hitbox.getXcor() * slopeShort);
      intersectX = (interceptShort - (ycor - (xcor * slopeLong)))/(slopeLong - slopeShort);
      intersectY = intersectX * slopeShort + interceptShort;
      if(distanceEq(intersectX,intersectY,xcor,ycor) <= (hitbox.getSizeX() / 2) + (size / 2)){
       return true; 
      }
      else{
        return false;
      }
    }
  boolean update(oneWayLinkedList<unit> x){
    boolean a = update();
    while(x.hasNext()){
      unit target = x.next();
      if(target.hitCheckCircle(this)){//bullet is cicular
        if(hit(target)){
          return true;
        }
        else{
          return a;
        }
      }
    }
   
    return a;
  }
  void trueDraw(float xcor, float ycor,PApplet applet){ 
    applet.fill(colour);
    applet.ellipse(xcor,ycor,displaySize,displaySize);
  }
}