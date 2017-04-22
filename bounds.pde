boolean checkBounds(unit x,battleMode field){
  boolean r = false;
  if(x.xcor > field._width - (x.size / 2)){
    x.xcor = field._width - (x.size / 2);
    r = true;
  }
  else if(x.xcor < x.size / 2){
    x.xcor = x.size / 2;
    r = true;
  }
  if(x.ycor > field._height - (x.size / 2)){
    x.ycor = field._height - (x.size / 2);
    r = true;
  }
  else if(x.ycor < x.size / 2){
    x.ycor = x.size / 2;
    r = true;
  }
  return r;
}
boolean inBounds(unit x,battleMode field){
  if(x.xcor > field._width - (x.size / 2)){
    //x.xcor = field._width - (x.size / 2);
    return false;
  }
  else if(x.xcor < x.size / 2){
    //x.xcor = x.size / 2;
    return false;
  }
  if(x.ycor > field._height - (x.size / 2)){
    //x.ycor = field._height - (x.size / 2);
    return false;
  }
  else if(x.ycor < x.size / 2){
    //x.ycor = x.size / 2;
    return false;
  }
  return true;
}