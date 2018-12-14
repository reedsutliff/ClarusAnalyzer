class DataProcess extends Thread {
  boolean running;
  String function;
  Frame f;
  int startTime = millis();
  DataProcess(String func, Frame f){
    this.function = func;
    this.f = f;
    running = false;
  }
  void start(){
    super.start();
  }
  void run(){
    running = true;
    SXSSFWorkbook workbook = new SXSSFWorkbook(100);
    people = new HashMap<String,Person>();
    errors = new ArrayList<String[]>();
    loci = new HashMap<String,Location>();
    ArrayList<String> files = f.getFiles();
    //SETUP VARIABLES
    
    //TEXT FILE TO XLSX PROCESSING
    if(function.equals("txt")){
      update_status("Processing\nText File");
      String[][] data = convertData(processtxt(files.get(0)));
      createSheet(workbook,"Data",data);
    }
    //TEXT FILE TO XLSX PROCESSING
    
    //MERGING OF CSV AND XLSX
    if(function.equals("xls")){
      update_status("Importing\nSurvey\nData");
      processSurvey(files.get(0));
      update_status("Importing\nPayroll Data");
      processPayroll(files.get(1));
      ArrayList<Person> recents = new ArrayList<Person>(); 
      for(Person p : people.values()){
        if(p.tg != null && p.tg.length() > 0 && p.status != null){
          if(checkMonth(p.hiredate, p)){
            recents.add(p);
          }
        }
      }
      String [][] data = convertData(recents);
      createSheet(workbook,"Data",data);
    }
    //MERGING OF CSV AND XLSX
    
    //ERROR REPORTING
    update_status("Processing\nErrors");
    if(errors.size()>0){
      String[][] data = new String[errors.size()+1][3];
      data[0] = new String[]{"Line Number","Error","Text"};
      int a = 1;
      for(String [] s : errors){
       data[a] = s;
       a++;
      }
      createSheet(workbook,"Errors",data);
    }
    update_status("Exporting\nXLSX");
    exportExcel(workbook,files.get(files.size()-1));
    String s = files.get(files.size()-1);
    //t.subtext = "Saved: \""+s.substring(s.lastIndexOf("\\")+1)+"\"";
    people = null;
    loci = null;
    errors = null;
    update_status("Finished!");
    running = false;
  }
}