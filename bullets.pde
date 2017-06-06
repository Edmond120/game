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
   return abs(xcor - hitbox.xcor) + abs(ycor - hitbox.ycor) <= (size / 2) + (hitbox.size / 2); 
  }
  boolean strikeRectangle(rectangle hitbox){
    float rectLongSlope = tan(radians(hitbox.angle));
    float rectShortSlope = tan(radians(hitbox.angle + 90));
    float rectLongIntercept = hitbox.ycor - hitbox.xcor * rectLongSlope;
    float rectShortIntercept = hitbox.ycor - hitbox.xcor * rectShortSlope;
    float bulletLongIntercept = ycor - xcor * rectLongSlope;
    float bulletShortIntercept = ycor - xcor * rectShortSlope;
    float longInterceptX = (bulletShortIntercept - rectLongIntercept) / (rectShortSlope + rectLongSlope);
    float longInterceptY = longInterceptX * rectLongSlope + rectLongIntercept;
    if(abs(longInterceptX - xcor) + abs(longInterceptY - ycor) <= size/2 + hitbox.sizeX/2){
      return true;
    }
    float shortInterceptX = (bulletLongIntercept - rectshortIntercept) / (rectLongslope + rectShortSlope);
    float shortInterceptY = sortInterceptX * rectShortSlope + rectShortIntercept;
    if(abs(shortInterceptX - xcor) + abs(shortInterceptY - ycor) <= size/2 + hitbox.sizeY/2){
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