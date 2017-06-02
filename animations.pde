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

class animation extends unit{
  //constructor + variables
  flipbook movie;
  delay wait;
  PImage currentImage;
  animation(battleMode field,flipbook movie,int xcor,int ycor,int size,int _delay){//_delay is in 60ths of a second
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