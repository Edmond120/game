class flipbook{
 //constructors + variables
 PImage[]book;
 flipbook(PImage[] book){
   this.book = book;
 }
 flipbook(String imageName,String end,int size){
   book = new PImage[size];
   for(int i = 0; i < size; i++){
     book[i] = loadImage(imageName + i + end);
   }
 }
 
 //methods + variables
 int index = 0;
 boolean hasNext(){
   if(index >= book.length){
     rewind();
     return false;
   }
   else{
     return true;
   }
 }
 PImage next(){
   return book[index++];
 }
 void rewind(){
   index = 0;
 }
}
interface fx{
  void _draw();
}
class attractor implements fx{
  PGraphics layer2;
  attractor(){layer2 = createGraphics(width,height);}
  attractor(int x,int y){layer2 = createGraphics(x,y);}
  oneWayLinkedList<PVector> dust = new oneWayLinkedList<PVector>();
  int colour;
  delay Delay;
  float r;
  PVector target;
  float force;
  void setForce(float s){
    force = s * scale;
  }
  void setTarget(PVector t){
    target = t.copy();
  }
  void setFade(float r){
    this.r = r;
  }
  void setDelay(delay d){
    Delay = d;
  }
  void setColour(int c){
   colour = c; 
  }
  
  void _setup(){
     for(int i = int((width * height)/1000); i > 0;i--){
      dust.add(new PVector(int(random(width)),int(random(height))));
     }
     println(dust.size);
  }
  void _draw(){
    layer2.beginDraw();
    if(Delay.every()){
      //fade(layer2,r);// not working?!?!
    }
    layer2.stroke(colour);
    while(dust.hasNext()){
      PVector p = dust.next();
      PVector dist = PVector.sub(target,p);
      if(dist.mag() <= 10){
        dust.remove();
      }
      p.add(dist.setMag(force/(dist.mag()*dist.mag())));
      layer2.point(p.x,p.y);
      //rect(p.x,p.y,10,10);
    }
    layer2.endDraw();
    image(layer2,0,0);
  }
}


class Animation extends unit{
  boolean hitCheckCircle(bullet Bullet){return false;}
  //constructor + variables
  flipbook movie;
  delay wait;
  PImage currentImage;
  Animation(battleMode field,flipbook movie,int xcor,int ycor,int size,int _delay){//_delay is in 60ths of a second
    this.field = field;
    this.movie = movie;
    this.xcor = xcor;
    this.ycor = ycor;
    this.size = size;
    wait = new delay(_delay);
    if(movie.hasNext()){
      currentImage = movie.next();
    }
    else{
      currentImage = loadImage("error.png");
    }
  }
  float getXcor(){return xcor;}
  float getYcor(){return ycor;}
  void setXcor(float x){xcor = x;};
  void setYcor(float x){ycor = x;};
  //methods
  boolean update(){
   return update(xcor,ycor,mainWindow); 
  }
  boolean update(float xcor, float ycor,PApplet applet){
    if(!wait.every()){
      applet.image(currentImage,xcor,ycor,size,size);
      return false;
    }
    if(movie.hasNext()){
      applet.image(currentImage = movie.next(),xcor,ycor,size,size);
      return false;
    }
    else{
      return true;
    }
  }
  void trueDraw(float xcor,float ycor,PApplet applet){
    update(xcor,ycor,applet);
  }
}