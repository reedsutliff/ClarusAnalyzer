import java.util.Date;
import java.util.Calendar;
import java.text.*;
final static long MONTH = 2592000000L;
final static String TITLE = "ClarusAnalyzer_v2.0";
Date TODAY = new Date();
DataProcess d;
String datestring = "";
String process_status = "";
String process_percent = "";
SimpleGui g;
Location x;
HashMap<String,Person> people;
HashMap<String,Location> loci;
ArrayList<String[]> errors;

String[] filelist;
String output;
void setup(){
  surface.setTitle(TITLE);
  x = new Location("N/A");
  x.entity_name = "N/A";
  size(450,750);
  surface.setResizable(true);
  textAlign(CENTER,CENTER);
  g = new SimpleGui();
  g.bg = color(200);
  g.tile = color(255);
  g.tileh = color(230);
  g.outline = color(0);
  g.txt = color(0);
  g.padding = 7.0;
  g.textsize = 52.5;
  g.og();
  //created gui and set variables
  
  Frame home = g.createFrame("home");
    home.createTile(40.0,"Process\nTXT File","frame","txt");
    home.createTile(40.0,"Combine\nXLS and CSV\nFiles","frame","xls");
    home.createTile(20.0,"Exit","method","exit");
  Frame txt = g.createFrame("txt");
    txt.createTile(30.0,"Select Input\nTXT File","file","i");
    txt.createTile(30.0,"Select Output\nXLSX File","file","o");
    txt.createTile(20.0,"Run","method","run");
    txt.createTile(20.0,"Back","frame","home");
  Frame runtxt = g.createFrame("runtxt");
    runtxt.createTile(80.0,"Running..");
    runtxt.createTile(20.0,"Back","frame","txt");
  Frame xls = g.createFrame("xls");
    xls.textscl = 0.65;
    xls.createTile(20,"Select Survey\nCSV Input","file","i");
    xls.createTile(20,"Select Payroll\nXLSX Input","file","i");
    xls.createTile(20,"Select XLSX Output","file","o");
    Tile x = xls.createTile(20,"Date (MM/DD/YYYY)","input",new SimpleDateFormat("dd/MM/yyyy").format(TODAY));
    x.subtext = "Date: ";  
    xls.createTile(10,"Run","method","run");
    xls.createTile(10,"Back","frame","home");
  Frame runxls = g.createFrame("runxls");
    runxls.createTile(80.0,"Running..");
    runxls.createTile(20.0,"Back","frame","xls");
}
void draw(){
  update_time();
  g.scaleto();
  g.render();
}

void mousePressed(){
  for(Tile t : g.getFrame(g.curframe).tiles){
    t.onclick();  
  }
}

void run(Frame f){
  if(f.name.equals("txt")){
    d = new DataProcess("txt",f);
    new Thread(d).start();
    g.changeFrame("runtxt");
    redraw();
  }
  if(f.name.equals("xls")){
    d = new DataProcess("xls",f);
    new Thread(d).start();
    g.changeFrame("runxls");
    redraw();
  }
}
void update_status(String s){
  if(d.running){
    g.getFrame(g.curframe).tiles.get(0).text = s;
  }
}

void update_time(){
  if(d != null && d.running){
    float t = (millis() - d.startTime);
    g.getFrame(g.curframe).tiles.get(0).subtext = new DecimalFormat("###.0").format(t/1000);
  }
}






  
  