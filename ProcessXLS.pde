void processSurvey(String file){
  processing.data.Table s = loadTable(file);
  String[][] survey = new String[s.getRowCount()][s.getColumnCount()];
  print("\nSURVEY LENGTH: "+survey.length);
  for(int i = 0; i<survey.length; i++){
    survey[i] = s.getStringRow(i);
  }//LOADED DATA INTO STRING ARRAY
  
  for(int i = 1; i<survey.length; i++){
    String[] x = survey[i];
    String ssn = x[4].replace("-","");
    Person p;
    if(people.containsKey(ssn)){
      p = people.get(ssn);
    }else{
      p = new Person(ssn);
    }
    p.employee_id = x[5];
    p.screened_elig = x[20];
    p.tg = x[21];
    p.status = x[29];
   
    people.put(p.ssn,p);
  }
}

void processPayroll(String file){
  String [][] payroll = importExcel(file);
  for(int i = 1; i<payroll.length; i++){
    String[] x = payroll[i];
    String ssn = x[2];
    Person p;
    if(people.containsKey(ssn)){
      p = people.get(ssn);
    }else{
      p = new Person(ssn);
    }
    p.fein = x[0];
    p.first = x[3];
    p.last = x[4];
    p.state = x[9];
    p.hiredate = x[12];
    p.start_wage = x[14];
    p.branch = x[16];
    p.loc_id = x[15];
    
    people.put(p.ssn,p); 
  }
}

String[][] convertData(ArrayList<Person> ps){
  String[][] data = new String[ps.size()+1][12];
  data[0] = new String[]{"FEIN","SSN","Employee ID","First Name","Last Name","State","Hire Date",
                         "Starting Wage","Location","Branch","Target Group","Status"};  
  int count = 1;
  for (Person p : ps){
    data[count] = new String[]{p.fein,p.ssn,"",p.first,p.last,p.state,p.hiredate,p.start_wage,p.loc_id,p.branch,p.tg,p.status};
    count++;
  }
  return data;
}

boolean checkMonth(String date, Person p){
    Date other = null;
    boolean state = false;
    try{
      SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
      other = sdf.parse(date);
      if((TODAY.getTime()-other.getTime())<MONTH){
        state = true;
      }
    } catch (Exception e){
      reportError(p.ssn,"MALFORMED DATE",date);
    }
    return state;
}