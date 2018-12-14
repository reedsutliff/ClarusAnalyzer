int line;
HashMap<String,Person> processtxt(String file){
  //Load file and import values
  String[] lines = loadStrings(file);
  for(line = 1; line<lines.length; line++){
    String values = lines[line];
    sortCat(values.substring(0,2),values);
  }
  
  //Reconcile locations and people
  for(Person p : people.values()){
    if(p.fein != null && loci.containsKey(p.fein)){
      p.l = loci.get(p.fein);
    }else{
      //println("\nMISSING LOCATION DATA: "+p.ssn);
      p.l = x;
    }
  }
  return people;
}

void reportError(String linenum, String error, String line){
  errors.add(new String[]{linenum,error,line==null?"NO DATA":line});  
}
String[][] convertData(HashMap<String,Person> people){
  //Format data for "People" sheet
  String[][] data = new String[people.size()+1][21];
  data[0] = new String[]{"FEIN","Entity Name","SSN","First Name","Last Name","Middle Initial","Address Line 1",
  "Address Line 2","City","State","Zip","Date of Birth","Hire Date","Start Date","Starting Wage","Location",
  "Branch","Hours Worked*","Year 1 Wages","Year 2 Wages","Termination Date*"};
  int count = 1;
  for (Person p : people.values()){
    data[count] = new String[]{p.l.fein,p.l.entity_name,p.ssn,p.first,p.last,p.middle,p.addrOne,p.addrTwo,p.city,
    p.state,p.zip,p.dob,p.hiredate, p.startdate,p.start_wage,p.loc_id,p.branch,p.hrs,p.yone_wages,p.ytwo_wages,p.term_date};
  count++;
  }
  return data;
}

String datef(String d){
  d = trim(d);
  if(d.length() > 1){
    String month = d.substring(0,2);
    String day = d.substring(2,4);
    String year = d.substring(4,8);
    return month + "/" + day + "/" + year;
  }
  return "";
}