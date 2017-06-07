/*
CopyPasta

Circle:

float getXcor(){return xcor;}
float getYcor(){return ycor;}
float getSize(){return size;}
boolean hitCheckCircle(bullet Bullet){
  return Bullet.strikeCircle(this); 
}

Rectangle:
float getXcor(){return xcor;}
float getYcor(){return ycor;}
float getSizeX(){return sizeX;}
float getSizeY(){return sizeY;}
float getAngle(){return angle;}
boolean hitCheckCircle(bullet Bullet){
   return Bullet.strikeRectangle(this);
}
*/

class Timer{
  public Timer(){
    }
    private long time;
    public void start(){
  time = System.currentTimeMillis();
    }
    public long stop(){
  return (System.currentTimeMillis() - time) / 1000;
    }
}


void centerWindow(){
  if(surface != null){
    surface.setLocation(centerX,centerY);
  }
}
void centerWindow(PApplet x){
  if(x.getSurface() != null){
    x.getSurface().setLocation(x.displayWidth/2-x.width/2,x.displayHeight/2-x.height/2);
  }
}
String randomSelect(String[]x){
  return x[int(random(x.length))];
}
boolean released(char targetKey){//for regular keys
  if(releasedTick != tick){
    return false;
  }
  else{
    if(!codedAndPushed){
      return keyPushed == targetKey;
    }
    else{
      return false;
    }
  }
}
boolean released(int targetKey){//for codedKeys
  if(releasedTick != tick){
    return false;
  }
  else{
    if(codedAndPushed){
      return keyPushed == targetKey;
    }
    else{
      return false;
    }
  }
}
int arrayIndex(String[]ary,String target){
  for(int i = 0; i < ary.length; i++){
    if(ary[i].equals(target)){
      return i;
    }
  }
  return -1;
}
int arrayIndex(char[]ary,char target){
  for(int i = 0; i < ary.length; i++){
    if(ary[i] == target){
      return i;
    }
  }
  return -1;
}
int positiveOrNegative(){
  if(random(100) > 50){
    return 1;
  }
  else{
    return -1;
  }
}


class delay{
  int wait;
  int counter = 0;
  void setWait(float wait){
    this.wait = int(wait * expectedFrameRate);
  }
  delay(float wait){
    this.wait = int(wait * expectedFrameRate);
  }
  boolean every(){
    if(counter++ % wait == 0){
      return true;
    }
    else{
      return false;
    }
  }
}


class charge{
  int wait;
  int counter = 0;
  charge(float wait){
    this.wait = int(wait * expectedFrameRate);
  }
  void setWait(float wait){
    this.wait = int(wait * expectedFrameRate);
  }
  boolean cooldown(){
    if(counter++ < wait){
      return false;
    }
    else{
      return true;
    }
  }
  void resetCooldown(){
    counter = 0;
  }
  boolean cooldown(boolean activation){
    if(cooldown() && activation){
      resetCooldown();
      return true;
    }
    else{
      return false;
    }
  }
}
//bounds
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
int checkBoundsAdvanced(unit x,battleMode field){
  int r = 0;
  if(x.xcor > field._width - (x.size / 2)){
    x.xcor = field._width - (x.size / 2);
    r = 1;
  }
  else if(x.xcor < x.size / 2){
    x.xcor = x.size / 2;
    r = 2;
  }
  if(x.ycor > field._height - (x.size / 2)){
    x.ycor = field._height - (x.size / 2);
    r = 3;
  }
  else if(x.ycor < x.size / 2){
    x.ycor = x.size / 2;
    r = 4;
  }
  return r;
}
boolean checkBoundsGhost(unit x,battleMode field){
  if(x.xcor > field._width - (x.size / 2)){
    return true;
  }
  else if(x.xcor < x.size / 2){
    return true;
  }
  if(x.ycor > field._height - (x.size / 2)){
    return true;
  }
  else if(x.ycor < x.size / 2){
    return true;
  }
  else{
    return false;
  }
}
boolean checkDisplayBounds(unit x){
  boolean r = false;
  if(x.xcor + centerX > displayWidth - (x.size / 2)){
    x.xcor = (displayWidth - (x.size / 2)) - centerX;
    r = true;
  }
  else if(x.xcor + centerX < x.size / 2){
    x.xcor = (x.size / 2) - centerX;
    r = true;
  }
  if(x.ycor + centerY > displayHeight - (x.size / 2)){
    x.ycor = (displayHeight - (x.size / 2)) - centerY;
    r = true;
  }
  else if(x.ycor + centerY < x.size / 2){
    x.ycor = (x.size / 2) - centerY;
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


public String Command(String arg) {
  String something = "";
  try{
    String command = arg;
    Process proc = Runtime.getRuntime().exec(command);

      // Read the output

    BufferedReader reader =
    new BufferedReader(new InputStreamReader(proc.getInputStream()));
    BufferedWriter reader1 = new BufferedWriter(new OutputStreamWriter(proc.getOutputStream()));

    String line = "";
    String line1 = "";
    while((line = reader.readLine()) != null) {
      something += line + "\n";
    }
    proc.waitFor();
  }
  catch(Throwable e){
    e.printStackTrace();
  }
  return something;
}