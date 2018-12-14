class Tile {
  Frame parent;
  Boolean hover;
  String text, subtext;
  float relsize;
  Tile(float rs, String t, Frame p){
    hover = false;
    text = t;
    parent = p;
    relsize = rs;
    subtext = "";
  }
  void render(float x, float y, float xx, float yy){
    if(mouseX>x && mouseY>y && mouseX<x+xx && mouseY<y+yy){
      hover = true;  
    }else{
      hover = false;
    }
    rectMode(CORNER);
    stroke(parent.parent.outline);
    fill(hover?parent.parent.tileh:parent.parent.tile);
    rect(x,y,xx,yy);
    fill(parent.parent.txt);
    textSize(parent.parent.textsize*parent.textscl);
    textLeading(parent.parent.textsize*parent.textscl);
    text(text, x+xx/2.0, y+(yy*0.9)/2.0);
    textSize((parent.parent.textsize*parent.textscl)/2);
    fill(200,0,0);
    text(subtext, x+xx/2.0, y+(yy)/1.2);
  }
  void onclick(){
  }
}
///END OF MAIN CLASS


//STATIC TILE EXTENDS TILE, VOID ONCLICK METHOD AND NO HOVER CONDITIONAL
class StaticTile extends Tile{
  StaticTile(float rs, String n, Frame p){
    super(rs, n, p);
  }
  void onclick(){      
  }
  void render(float x, float y, float xx, float yy){
    rectMode(CORNER);
    stroke(parent.parent.outline);
    fill(parent.parent.tile);
    rect(x,y,xx,yy);
    fill(parent.parent.txt);
    textSize(parent.parent.textsize);
    textLeading(parent.parent.textsize*parent.textscl);
    text(text, x+xx/2.0, y+(yy*0.9)/2.0);
    textSize(parent.parent.textsize/2);
    fill(200,0,0);
    text(subtext, x+xx/2.0, y+(yy)/1.2);
  }
}
///END OF STATIC TILE

//FRAME TILE EXTENDS TILE, ONCLICK CHANGES FRAME
class FrameTile extends Tile{
  String frame;
  FrameTile(float rs, String n, String f, Frame p){
    super(rs, n, p);
    frame = f;
  }
  void onclick(){
    if(hover){
      parent.parent.changeFrame(frame);
    }
  }
}
//END OF FRAME TILE

///METHOD TILE EXTENDS METHOD, ONCLICK CALLS METHOD
class MethodTile extends Tile{
  String method;
  MethodTile(float rs, String n, String m, Frame p){
    super(rs, n ,p);
    method = m;
  }
  void onclick(){
    if(hover){
      switch(method){
        case "exit":
          exit();
          break;
        case "getInput":
          selectInput("Select Input","inputSelected");
          break;
        case "getOutput":
          selectOutput("Select Output","outputSelected");
          break;
        case "run":
          Boolean x = true;
          for(int i = 0; i<this.parent.tiles.size(); i++){
            Tile t = this.parent.tiles.get(i);
            if(t instanceof FileTile){
              if(x){
                x = ((FileTile)t).valid();
              }else{
                ((FileTile)t).valid();
              }
            }
            if(t instanceof InputTile){
              if(x){
                x = ((InputTile)t).valid();
              }else{
                ((InputTile)t).valid();
              }
            }
          }
          if(x){
            run(this.parent);
          }
          break;
        default:
          break;
      }
    }
  }
}
//END OF METHOD TILE

//FILE TILE EXTENDS METHOD, ONCLICK CALLS I/O METHOD AND ADDS 'THIS' TO GUI OBJECT
class FileTile extends Tile{
  File f;
  String io;
  FileTile(float rs, String n, String io, Frame p){
    super(rs, n, p);
    this.io = io;
    this.f = null;
  }
  void onclick(){
    if(hover){
      parent.parent.flc = this;
      switch(io){    
        case "i":
          selectInput("Select Input","inputSelected");
          break;
        case "o":
          selectOutput("Select Output","outputSelected");
          break;
      }
    }
  }
  Boolean valid(){
    String type;
    if(this.text.contains("XLSX")){
      type = ".xlsx";
    }else if(this.text.contains("TXT")){
      type = ".txt";
    }else if(this.text.contains("CSV")){
      type = ".csv";
    }else{
      println("CAN'T DETERMINE TYPE OF IO");
      return false;
    }
    if(this.io.equals("i")){
      if(this.f != null){
         if(this.f.exists()){
           if(this.f.getAbsolutePath().contains(type)){
             return true;
           }else{
             this.subtext = "Invalid file type!";
             return false;
           }
         }else{
           this.subtext = "File does not exist!";
           return false;
         }
       }else{
         this.subtext = "No file selected!";
         return false;
       }
    }else{
      if(this.f !=null){
        if(!this.f.exists()){
          if(this.f.getAbsolutePath().contains(".xlsx")){
            return true;
          }else{
            this.f = new File(this.f.getAbsolutePath()+".xlsx");
            return true;
          }
        }else{
          this.subtext = "File already exists!";
          return false;
        }
      }else{
        this.subtext = "No file selected!";
        return false; 
      }
    }
  }
}

class InputTile extends Tile{
  String input;
  String validity;
  InputTile(float rs, String n, String i, Frame p){
    super(rs, n, p);
    this.input = i;
    validity = "(VALID)";
  }
  void render(float x, float y, float xx, float yy){
    if(mouseX>x && mouseY>y && mouseX<x+xx && mouseY<y+yy){
      hover = true;  
    }else{
      hover = false;
    }
    rectMode(CORNER);
    stroke(parent.parent.outline);
    fill(parent.parent.tile);
    rect(x,y,xx,yy);
    fill(parent.parent.txt);
    textSize(parent.parent.textsize*parent.textscl);
    textLeading(parent.parent.textsize*parent.textscl);
    text(text, x+xx/2.0, y+(yy*0.9)/4.0);
    textSize(parent.parent.textsize/1.8);
    fill(230);
    rect(x+parent.parent.padding,y+yy/2.0+parent.parent.padding,xx-parent.parent.padding*2,yy/2.0-parent.parent.padding*2);
    fill(200,0,0);
    text(subtext+input+" "+validity, x+xx/2.0, y+(yy)/1.4);
  }
  void modInput(){
    if (key != CODED) {
      if (key == BACKSPACE){
        if(input.length() > 0){
        input = input.substring(0,input.length()-1);
        }
      }else{
        input = input + key;  
      } 
    }
    validity = this.valid()?"(VALID)":"(INVALID)";
  }
  boolean valid(){
    SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/YYYY");
    if(input.length() !=10){
      return false;  
    }
    try{
      TODAY = sdf.parse(this.input);
      return true;
    }catch(Exception e){
      return false;  
    } 
  }
}
  //VERIFIES THAT THE INPUT/OUTPUT MATCHES TYPE, EXISTS/DOESN'T EXIST, AND IS NOT NULL
  //DEPENDENT ON OBJECT 'io' VALUE TO DETERMINE IN VS OUT

//END OF FILE TILE