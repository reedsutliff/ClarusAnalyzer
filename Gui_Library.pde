import java.lang.reflect.Method;

class SimpleGui {
  FileTile flc;
  HashMap<String, Frame> frames;
  color bg, txt, tile, tileh, outline;
  float textsize, ogtextsize;
  String curframe;
  float ogpadding, padding, startsize, ogx, ogy;
  SimpleGui() {
    curframe = "home";
    frames = new HashMap<String, Frame>();    
  }
  void og(){
    this.ogpadding = this.padding;
    this.ogtextsize = this.textsize;
    this.ogx = width;
    this.ogy = height;
  }
  void scaleto(){
    float xs = width/this.ogx;
    float ys = height/this.ogy;
    if(xs>ys){
      this.padding = ys*ogpadding;
      this.textsize = ys*ogtextsize;
    }else{
      this.padding = xs*ogpadding;
      this.textsize = xs*ogtextsize;
    }
  }
  Frame createFrame(String n){
    Frame f = new Frame(n,this);
    frames.put(n,f);
    return f;
  }
  Frame getFrame(String s){
    return frames.get(s);  
  }
  void changeFrame(String f){
    curframe = f;  
  }
  void render(){
    background(this.bg);
    frames.get(curframe).render();  
  }
}

class Frame {
  int columns;
  SimpleGui parent;
  ArrayList<Tile> tiles;
  String name;
  float textscl;
  Frame(String n, SimpleGui p)  {
    this.name = n;
    this.parent = p;
    columns = 1;
    tiles = new ArrayList<Tile>();
    textscl = 1.0;
  }
  float getHeight(){
    float a = 0.0;
    for(Tile t : tiles){
      a = a + t.relsize;  
    }
    return a;
  }
  Tile createTile(float rs, String tx, String x, String v){
    if(x.equals("method")){
      Tile t = new MethodTile(rs, tx, v, this);
      tiles.add(t);
      return t;
    }
    if(x.equals("frame")){
      Tile t = new FrameTile(rs, tx, v, this);
      tiles.add(t);
      return t;
    }
    if(x.equals("file")){
      Tile t = new FileTile(rs, tx, v, this);
      tiles.add(t);
      return t;
    }
    if(x.equals("input")){
      Tile t = new InputTile(rs, tx, v, this);
      tiles.add(t);
      return t;
    }
    return null;
  }
  Tile createTile(float rs, String tx){
    Tile t = new StaticTile(rs,tx,this);
    tiles.add(t);
    return t;
  }
  ArrayList<String> getFiles(){
    ArrayList<String> files = new ArrayList<String>();
    for(Tile t : this.tiles){
      if(t instanceof FileTile){
        files.add(((FileTile)t).f.getAbsolutePath());
        ((FileTile)t).f = null;
        ((FileTile)t).subtext = "";
      }
    }
    return files;
    
  }
  void modInput(){
    for(Tile t : this.tiles){
      if(t instanceof InputTile){
        if(t.hover){
          ((InputTile)t).modInput();
        }
      }
    }
  }
  ArrayList<InputTile> getInput(){
    ArrayList<InputTile> itiles = new ArrayList<InputTile>();
    for(Tile t : this.tiles){
      if(t instanceof InputTile){
        itiles.add((InputTile)t);        
      }
    }
    return itiles;
  }
  
  void render(){
      rendercol(tiles,0,width,100.0);  
  }
  void rendercol(ArrayList<Tile> tilelist, float xstart, float xwidth, float totsize){
    float cumsize = 0.0;
    float pad = parent.padding*(1+tilelist.size());
    float m = (height-pad)/totsize;
    for(Tile t : tilelist){
      t.render(xstart + parent.padding,(parent.padding*(tilelist.indexOf(t)+1) + m*(cumsize)),(xwidth)-2.0*parent.padding, m*t.relsize); 
      cumsize = cumsize+t.relsize;
    }
  }
}