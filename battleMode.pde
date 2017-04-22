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
  int health = 10;
  float size;
  float xcor;
  float ycor;
  float radius;
  float displaySize;
}
class battleMode extends mode{
  int _width = width;
  int _height = height;
  oneWayLinkedList<unit> bullets;
  oneWayLinkedList<unit> playerBullets;
  oneWayLinkedList<unit> enemies;
  oneWayLinkedList<unit> players;
  oneWayLinkedList<unit> anime; //this "anime" stands for animation, not the anime anime
  void _setup(){
    //testing only <start>
    playBgm(randomSelect(new String[]{"song1.mp3","song2.mp3","song3.mp3"}));
    bullets = new oneWayLinkedList<unit>();
    playerBullets = new oneWayLinkedList<unit>();
    enemies = new oneWayLinkedList<unit>();
    players = new oneWayLinkedList<unit>();
    anime = new oneWayLinkedList<unit>();
    //players.add(new testUnit(this,0.5,0.5,0.20,0.5));
    players.add(new testUnitA(this,0.5,0.5,0.20,0.5));
    background(0);
    //testing only <end>
  }
  void tick(){
    background(0);
    update(playerBullets,enemies);
    update(bullets,players);
    update(players);
    update(enemies);
    //note, animations don't use the _draw method, update includes draw. hence it must be placed in between the update and draw methods.
    update(anime);
    //
    _draw(playerBullets);
    _draw(enemies);
    _draw(players);
    _draw(bullets);
  }
  void update(oneWayLinkedList<unit> a,oneWayLinkedList<unit> b){
    while(a.hasNext()){
      if(a.next().update(b)){
        a.remove();
      }
    }
    a.rewind();
  }
  void update(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      if(x.next().update()){
        x.remove();
      }
    }
    x.rewind();
  }
  void _draw(oneWayLinkedList<unit> x){
    while(x.hasNext()){
      x.next()._draw();
    }
    x.rewind();
  }
}