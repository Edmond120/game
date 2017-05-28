class entity{
  entity parent = null;
  boolean update(){
    //true if unit is to be removed
    return false;
  }
  boolean update(oneWayLinkedList<unit> x){//this is for interaction with other entitys
    //true if unit is to be removed
    return false;
  }
  void _draw(){
  }
}

class unit extends entity{
  battleMode field;
  int health;
  int points;
  float size;
  float xcor;
  float ycor;
  float radius;
  float displaySize;
  void death(){
  }
}

class battleMode extends mode{
  int _width = width;
  int _height = height;
  oneWayLinkedList<unit> bullets;
  oneWayLinkedList<unit> playerBullets;
  oneWayLinkedList<unit> enemies;
  oneWayLinkedList<unit> players;
  oneWayLinkedList<unit> anime; //this "anime" stands for animation, not the anime anime (lol)
  
  void _setup(){
    tick = 0;
  }
  void tick(){
    background(0);
    try{
    update(playerBullets,enemies);
    update(bullets,players);
    update(players);
    update(enemies);
    
    //note, animations don't use the _draw method, update includes draw. 
    update(anime);
    //Hence it must be placed in between the update and draw methods.
    
    _draw(playerBullets);
    _draw(enemies);
    _draw(players);
    _draw(bullets);
    }
    catch(NullPointerException e){
    }
  }
  void update(oneWayLinkedList<unit> a, oneWayLinkedList<unit> b){
    while(a.hasNext()){
      if(a.next().update(b)){
        a.getCurrent().death();
        a.remove();
      }
    }
    
  }
  void update(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      if(x.next().update()){
        x.getCurrent().death();
        x.remove();
      }
    }
    
  }
  void _draw(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      x.next()._draw();
    }
    
  }
}