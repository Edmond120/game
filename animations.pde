class flipbookThread extends Thread{
  flipbook[] data;
  int totalSize = 0;
  int totalLoadedData = 0;
  flipbook current;
  flipbookThread(flipbook[] _data){
    data = _data;
    for(int i = 0; i < data.length; i++){
     totalSize += data[i].getSize();
     data[i].t = this;
    }
    current = data[0];
  }
  @Override
  void run(){
    for(int i = 0; i < data.length;i++){
      current = data[i];
      current.load();
    }
    done = true;
  }
  boolean done = false;
  float currentLoadingBar(){
    println(current.getLoadingProgress());
    return current.getLoadingProgress();
  }
  float mainLoadingBar(){
    return (totalLoadedData * 1.0) / totalSize; 
  }
}
class flipbook{
 //constructors + variables
 PImage[]book;
 flipbook(PImage[] book){
   this.book = book;
 }
 flipbookThread t;
 int size;
 int loaded = 0;
 String imageName;
 String end;
 int w,h;
 flipbook(String imageName,String end,int size,int _w,int _h){
   book = new PImage[size];
   this.size = size;
   this.imageName = imageName;
   this.end = end;
   w = _w;
   h = _h;
 }
 void load(){
  for(int i = 0; i < size; i++){
     book[i] = loadImage(imageName + i + end);
     book[i].resize(w,h);
     loaded++;
     if(t != null){
        t.totalLoadedData++; 
     }
   } 
 }
 int getSize(){return size;}
 float getLoadingProgress(){
   return (loaded * 1.0)/size;
 }
 //methods + variables
 int index = 0;
 boolean hasNext(){//no longer needed
   if(index >= book.length){
     rewind();
     return false;
   }
   else{
     return true;
   }
 }
 PImage next(){
   if(index >= book.length){
     rewind();
   }
   return book[index++];
 }
 PImage current(){
  return book[index - 1]; 
 }
 void rewind(){
   index = 0;
 }
}
interface fx{
  void _draw();
}
class quickAttractor extends attractor{
 quickAttractor(){
  super(false); 
 }
 oneWayLinkedList<particle>dust2 = new oneWayLinkedList<particle>();
 @Override
 void _setup(){
 }
 @Override
 void _draw(){
   //try{
   stroke(colour,getGraphics().colorModeA);
   //}
   //catch(Throwable e){
   // e.printStackTrace(); 
   //}
   
     PVector pp = new PVector(int(random(width)),int(random(height)));
      dust2.add(new particle(pp,pp.copy(),getGraphics().colorModeA));
      //dust.add(new PVector(int(random(width)),int(random(height))));
     
   while(dust2.hasNext()){
     particle p = dust2.next();
     PVector pv = p.vector;
      PVector dist = PVector.sub(target,pv);
      if(dist.mag() <= (20/90) * scale){
        dust2.remove();
        continue;
      }
      else{
        p.previousVector = pv.copy();
        float f = force/dist.mag();
        pv.add(dist.setMag(f));
        if(f < scale){
          line(p.previousVector.x,p.previousVector.y,pv.x,pv.y);
        }
      }
   }
 }
}
class particle{
 particle(PVector vector,float alpha){this.vector = vector;this.alpha = alpha;}
 particle(PVector vector,PVector previousVector,float alpha){this(vector,alpha);this.previousVector = previousVector;}
 PVector vector;
 float alpha;
 PVector previousVector;
}
class attractor implements fx{
  PGraphics layer2;
  attractor(boolean a){
   if(a){
     layer2 = createGraphics(width,height);
   }
  }
  attractor(){layer2 = createGraphics(width,height);
}
  attractor(int x,int y){layer2 = createGraphics(x,y);
}
  //oneWayLinkedList<particle> dust = new oneWayLinkedList<particle>();
  oneWayLinkedList<PVector> dust = new oneWayLinkedList<PVector>();
  //oneWayLinkedList<particle> trail = new oneWayLinkedList<particle>();
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
      //dust.add(new particle(new PVector(int(random(width)),int(random(height))),layer2.colorModeA));
      dust.add(new PVector(int(random(width)),int(random(height))));
     }
     //println(dust.size);
  }
  void _draw(){
    //background(0);
    layer2.beginDraw();
    layer2.stroke(colour,layer2.colorModeA);
    //float rr = layer2.colorModeA * r;
    //int count = 0;
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
      //particle p = dust.next();
       // PVector dist = PVector.sub(target,p.vector);
        //if(dist.mag() <= 10){
       //   dust.remove();
       // }
      //  if(count++ % 10 == 0){
       //   trail.add(new particle(p.vector.copy(),p.alpha));
       // }
      //  p.vector.add(dist.setMag(force/(dist.mag()*dist.mag())));
     // layer2.point(p.vector.x,p.vector.y);
      //rect(p.x,p.y,10,10);
    //}
    //while(trail.hasNext()){
     // particle p = trail.next();
     // layer2.stroke(colour,p.alpha);
     // point(p.vector.x,p.vector.y);
    // if(Delay.every()){
       // p.alpha -= rr;
       // if(p.alpha <= 0){
        //  dust.remove();
       // } 
     // }
  //  }
    if(Delay.every()){
      fade(layer2,r);
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

class petal{
 PVector location;
 petal(float xcor,float ycor){
   location = new PVector(xcor,ycor);
 }
 boolean fall(){
   if(location.y > height){
     return true;
   }
   else{
     return true;
   }
 }
}
class mainMenuAnimation implements fx{
  oneWayLinkedList<petal> petals = new oneWayLinkedList<petal>();
  void _setup(){
  }
  float s;
  float t = 8 * scale;
  float x = 0.1;
  void _draw(){
     stroke(#FF76EF);
     strokeWeight(1 * scale);
     fill(#FFAAF5);
     s = x * t;
     ellipse(8*scale,4.5*scale,s,s);
     while(petals.hasNext()){
        if(petals.next().fall()){
           petals.remove(); 
        }
     }
     strokeWeight(1);
  }
}