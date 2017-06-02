class oneWayLinkedList<E>{
  class Lnode{
    E value;
    Lnode(E x){
      value = x;
    }
    Lnode(E x, Lnode a){
      value = x;
      after = a;
    }
    Lnode after = null;
  }
  
  int size = 0;
  Lnode end = new Lnode(null);
  Lnode start = new Lnode(null,end);
  Lnode current = start;
  Lnode back;
  oneWayLinkedList(){
    }
    synchronized  void add(E x){
      start.after = new Lnode(x,start.after);
      size++;
    }
    synchronized  boolean hasNext(){
      if(current.after == null || current.after.value == null){
        rewind();
        return false;
      }
      else{
        return true;
      }
    }
    synchronized  E next(){
      back = current;
      return (current = current.after).value;
    }
    synchronized  E getCurrent(){
      return current.value;
    }
    synchronized  void rewind(){
      current = start;
    }
    synchronized  void remove(){
      current.value = current.after.value;
      current.after = current.after.after;
      current = back;
      size--;
    }
  }
  
  class SaveSystem{
  SaveSystem(){}
  void save(){
    try{
      File file = new File ("C:/Users/Me/Desktop/directory/file.txt");
      PrintWriter writer = new PrintWriter (file);
      //for(
      //writer.println("The first line");
      //writer.println("The second line");
      writer.close();
    } catch (IOException e) {
    }
  }
}