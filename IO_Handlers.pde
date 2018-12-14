void inputSelected(File selection){
  if(selection == null){
    g.flc.subtext = "No selection made!";
  }else{
    g.flc.f = selection;
    String t = selection.getAbsolutePath();
    if(g.flc.valid()){
      int length = (int)(30.0/g.getFrame(g.curframe).textscl);
      if(t.length() > length){
        g.flc.subtext = "\"..."+t.substring(t.length()-(length-3))+"\"";
      }else{
        g.flc.subtext = "\""+t+"\"";
      }
    }
  }
}

void outputSelected(File selection){
  if(selection == null){
    g.flc.subtext = "No selection made!";
  }else if(selection.exists()){
    g.flc.subtext = "File already exists!";
  }else{
    g.flc.f = selection;
    String t = selection.getName();
    if(!t.contains(".xls")){
      selection = new File(selection.getAbsolutePath()+".xlsx");
      t = selection.getAbsolutePath();
    }
    if(g.flc.valid()){
      int length = (int)(30.0/g.getFrame(g.curframe).textscl);
      if(t.length() > length){
        
        g.flc.subtext = "\"..."+t.substring(t.length()-(length-3))+"\"";
      }else{
        g.flc.subtext = "\""+t+"\"";
      }
    }
  }
}

void keyPressed(){
  g.getFrame(g.curframe).modInput();  
}