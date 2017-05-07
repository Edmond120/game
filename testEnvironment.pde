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
class experimentTestEnironment extends testEnvironment{
  int x = 0;
  void _setup(){
  }
  void tick(){
    if(released('z')){
      System.out.println(x++);
    }
  }
}
class tempTestEnvironment extends testEnvironment{
  delay x;
  void _setup(){
    x = new delay(1);
  }
  void tick(){
    if(x.every()){
      println(mouseX + " " + mouseY);
    }
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
     if(released('z')){
       System.out.println('z');
     }
     if(keys[keyZ]){
       System.out.println('z');
     }
     System.out.println(keys[keyZ]);
   }
}
class testBattleMode extends battleMode{
      randomEdgeSpawner spawn;
  void _setup(){
    super._setup();
    playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
    bullets = new oneWayLinkedList<unit>();
    playerBullets = new oneWayLinkedList<unit>();
    enemies = new oneWayLinkedList<unit>();
    players = new oneWayLinkedList<unit>();
    anime = new oneWayLinkedList<unit>();
    unit a = new testUnitA(this,0.5,0.5,0.20,0.5);
    players.add(a);
    spawn = new randomEdgeSpawner(this,a);
    spawn.create();
    background(0);
  }
  void tick(){
    spawn.spawn();
    super.tick();
  }
}
class pushedTestEnvironment extends testEnvironment{
  void tick(){
    if(released('z')){
      System.out.println('z');
    }
    if(released('x')){
      System.out.println('x');
    }
    if(released(UP)){
      System.out.println("up");
    }
    if(released(DOWN)){
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