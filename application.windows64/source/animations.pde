class flipbook{
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
 int index = 0;
 boolean hasNext(){
   if(index >= book.length){
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
  boolean update(){
    if(!wait.every()){
      image(currentImage,xcor,ycor,size,size);
      return false;
    }
    if(movie.hasNext()){
      image(currentImage = movie.next(),xcor,ycor,size,size);
      return false;
    }
    else{
      return true;
    }
  }
  void _draw(){
    throw new UnsupportedOperationException();
  }
}