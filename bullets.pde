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
    float rectLongSlope = tan(radians(hitbox.getAngle()));
    float rectShortSlope = tan(radians(hitbox.getAngle() + 90));
    float rectLongIntercept = hitbox.getYcor() - hitbox.getXcor() * rectLongSlope;
    float rectShortIntercept = hitbox.getYcor() - hitbox.getXcor() * rectShortSlope;
    float bulletLongIntercept = ycor - xcor * rectLongSlope;
    float bulletShortIntercept = ycor - xcor * rectShortSlope;
    float longInterceptX = (bulletShortIntercept - rectLongIntercept) / (rectShortSlope + rectLongSlope);
    float longInterceptY = longInterceptX * rectLongSlope + rectLongIntercept;
    if(abs(longInterceptX - xcor) + abs(longInterceptY - ycor) <= size/2 + hitbox.getSizeX()/2){
      return true;
    }
    float shortInterceptX = (bulletLongIntercept - rectShortIntercept) / (rectLongSlope + rectShortSlope);
    float shortInterceptY = shortInterceptX * rectShortSlope + rectShortIntercept;
    if(abs(shortInterceptX - xcor) + abs(shortInterceptY - ycor) <= size/2 + hitbox.getSizeY()/2){
      return true;
    }
    return false;
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