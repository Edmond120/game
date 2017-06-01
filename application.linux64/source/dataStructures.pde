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
     //Command("pwd");
      File file = new File ("savefile.txt");
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
  



    public void Command(String arg) {
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
          System.out.print(line + "\n");

      }
      proc.waitFor();
  }
  catch(Throwable e){
      e.printStackTrace();
  }
    }
 