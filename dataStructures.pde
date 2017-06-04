class oneWayLinkedListKey<E>{
 Lnode<E> current,back;
 oneWayLinkedListKey(Lnode<E> start){
   current = start;
 }
}
class Lnode<E>{
    E value;
    Lnode(E x){
      value = x;
    }
    Lnode(E x, Lnode a){
      value = x;
      after = a;
    }
    Lnode<E> after = null;
  }
class oneWayLinkedList<E>{//only one thread should be adding or removing from the list
  int size = 0;
  Lnode<E> start = new Lnode<E>(null,null);
  oneWayLinkedListKey<E> FirstKey = createKey();//only to be used by the thread that adds or removes from the list
  oneWayLinkedList(){
    }
    oneWayLinkedList(E...args){
     for(int i = 0; i < args.length;i++){
      add(args[i]); 
     }
    }
    oneWayLinkedListKey<E> createKey(){
     return new oneWayLinkedListKey<E>(start); 
    }
    synchronized  void add(E x){
      start.after = new Lnode(x,start.after);
      size++;
    }
    boolean hasNext(oneWayLinkedListKey<E> Key){
      if(Key.current.after == null){
        rewind(Key);
        return false;
      }
      else{
        return true;
      }
    }
    boolean hasNext(){
      return hasNext(FirstKey);
    }
    E next(oneWayLinkedListKey<E> Key){
      Key.back = Key.current;
      return (Key.current = Key.current.after).value;
    }
    E next(){
     return next(FirstKey); 
    }
    E getCurrent(oneWayLinkedListKey<E> Key){
      return Key.current.value;
    }
    E getCurrent(){
      return getCurrent(FirstKey);
    }
    void rewind(oneWayLinkedListKey<E> Key){
      Key.current = start;
    }
    void rewind(){
     rewind(FirstKey); 
    }
    void remove(){
      FirstKey.back.after = FirstKey.current.after;
      /*Key.current.value = Key.current.after.value;
      Key.current.after = Key.current.after.after;
      Key.current = Key.back;*/
      size--;
    }
  }
  
class SaveSystem{
  String filename;
  SaveSystem(String name){
  filename = name + "";
}
  void save(){
    try{
      File file = new File (dataPath(filename));
      file.createNewFile();
      PrintWriter writer = new PrintWriter (file);
      for(int counter = 0; counter < levels.length ; counter++){
        writer.println("" + levels[counter] + " ");
      }
      writer.close();
    } catch (IOException e) {
    }
  }
}
  




 