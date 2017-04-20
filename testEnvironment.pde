class oneWayLinkedListTestEnvironment extends testEnvironment{
  void _setup(){
    oneWayLinkedList<Integer> x = new oneWayLinkedList<Integer>();
    x.add(0);
    x.add(1);
    x.add(2);
    x.add(3);
    x.add(4);
    x.add(5);
    x.add(6);
    String r = "";
    while(x.hasNext()){
      Integer a = x.next();
      if(a == 6){
        x.remove();
      }
      else{
      r += a + " ";
      }
    }
    System.out.println(r);
    x.rewind();
    r = "";
    while(x.hasNext()){
      r += x.next() + " ";
    }
    System.out.println(r);
  }
  void tick(){
  }
}
class testEnvironment extends mode{
  void _setup(){
  }
  void tick(){
  }
}
class scrapTestEnvironment extends testEnvironment{
  void _setup(){
    System.out.println(10.5 % 5);
  }
}
class sizeTestEnvironment extends testEnvironment{
  void _setup(){
    rect(0 * scale,0 * scale, 1 * scale, 1 * scale);
  }
  void tick(){
  }
}
class soundTestEnvironment extends testEnvironment{
  
}
class robotTestEnvironment extends testEnvironment{
   void tick(){
     if(!keys[keyZ]){
       robot.keyPress(KeyEvent.VK_Z);
       robot.keyRelease(KeyEvent.VK_Z);
       //System.out.println("pressed");
     }
     if(pushed('z')){
       System.out.println('z');
     }
     if(keys[keyZ]){
       System.out.println('z');
     }
     System.out.println(keys[keyZ]);
   }
}
class pushedTestEnvironment extends testEnvironment{
  void tick(){
    if(pushed('z')){
      System.out.println('z');
    }
    if(pushed('x')){
      System.out.println('x');
    }
    if(pushed(UP)){
      System.out.println("up");
    }
    if(pushed(DOWN)){
      System.out.println("down");
    }
  }
}
class delayAndCooldownTestEnvironment extends testEnvironment{
  int c = 0;
  int cc = 0;
  charge x;
  delay y;
  void _setup(){
    x = new charge(5);
    y = new delay(3);
  }
  void tick(){
    if(x.cooldown(keys[0])){
      System.out.println(c++);
    }
    if(y.every()){
     // System.out.println(cc++);
    }
  }
}