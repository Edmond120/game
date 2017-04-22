class bullet extends unit{
  int damage;
  float[] vector = new float[2];
  bullet(){
  }
  bullet(entity parent,battleMode field,float xcor,float ycor,float size,float xVector,float yVector,int damage){
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
  bullet(battleMode field,float xcor,float ycor,float size,float xVector,float yVector, int damage){
    this.field = field;
    this.xcor = xcor * scale;
    this.ycor = ycor * scale;
    this.size = size * scale;
    this.radius = this.size / 2;
    vector[0] = xVector * scale;
    vector[1] = yVector * scale;
    this.damage = damage;
  }
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
  boolean update(oneWayLinkedList<unit> x){
    boolean a = update();
    while(x.hasNext()){
      unit target = x.next();
      if(abs(xcor - target.xcor) + abs(ycor - target.ycor) <= radius){
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
  void _draw(){
    fill(#FF0000);
    ellipse(xcor,ycor,size,size);
  }
}