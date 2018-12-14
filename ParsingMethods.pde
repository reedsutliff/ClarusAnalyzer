//based on the category, feeds values into 
void sortCat(String cat, String values){
  switch (cat) {
    case "E1":
      if(values.length()<69){
        reportError(line+"","Line too short!",values);
        break;
      }
      Eone(values);
      break;
    case "E2":
      if(values.length()<88){
        reportError(line+"","Line too short!",values);
        break;
      }
      Etwo(values);
      break;
    case "E3":
      if(values.length()<102){
        reportError(line+"","Line too short!",values);
        break;
      }
      Ethree(values);
      break;
    case "L1":
      if(values.length()<180){
        reportError(line+"","Line too short!",values);
        break;
      }
      Lone(values);
      break;
    case "P4":
      if(values.length()<156){
        reportError(line+"","Line too short!",values);
        break;
      }
      Pfour(values);
      break;
    case "P5":
      if(values.length()<59){
        reportError(line+"","Line too short!",values);
        break;
      }
      Pfive(values);
      break;
    default:
      break;
  }
}

//Parses E1 Category Entries
void Eone(String values){
  String ssn = values.substring(2,11);
  Person p;
  if(people.containsKey(ssn)){
    p = people.get(ssn);
  }else{
    p = new Person(ssn);
  }
  p.first = trim(values.substring(20,30));
  p.middle = values.substring(30,31);
  p.last = trim(values.substring(31,61));
  p.dob = datef(values.substring(61,69));
  people.put(p.ssn,p);
}

//Parses E2 Category Entries
void Etwo(String values){
  String ssn = values.substring(2,11);
  Person p;
  if(people.containsKey(ssn)){
    p = people.get(ssn);
  }else{
    p = new Person(ssn);
  }
  p.hiredate = datef(values.substring(11,19));
  p.startdate = datef(values.substring(11,19));
  p.term_date = datef(values.substring(80,88));
  people.put(p.ssn,p);
}

//Parses E3 Category Entries
void Ethree(String values){
  String ssn = values.substring(2,11);
  Person p;
  if(people.containsKey(ssn)){
    p = people.get(ssn);
  }else{
    p = new Person(ssn);
  }
    p.addrOne = trim(values.substring(11,41));
    p.addrTwo = trim(values.substring(41,71));
    p.city = trim(values.substring(71,91));
    p.state = values.substring(91,93);
    p.zip = trim(values.substring(93,102));
    people.put(p.ssn,p);
}

//Parses L1 Category Entries
void Lone(String values){
  String fein = values.substring(170,179);
  if(fein.contains("-")){
    fein = values.substring(170,172)+values.substring(173,180);
  }
  Location l = new Location(fein);
  l.entity_name = split(values.substring(27,78),"  ")[0]; 
  loci.put(l.fein,l);
}

//Parses P4 Category Entries
void Pfour(String values){
  String ssn = values.substring(52,61);
  Person p;
  if(people.containsKey(ssn)){
    p = people.get(ssn);
  }else{
    p = new Person(ssn);
  }
  p.branch = trim(values.substring(2,52));
  p.hrs = values.substring(79,85).replaceFirst("^0+(?!$)", "");
  p.yone_wages = values.substring(108,120).replaceFirst("^0+(?!$)", "");
  p.ytwo_wages = values.substring(121,133).replaceFirst("^0+(?!$)", "");
  p.fein = values.substring(133,142);
  String t = values.substring(151,156).replaceFirst("^0+(?!$)", "");
  if(t.length()>3){
    p.start_wage = t.substring(0,2)+"."+t.substring(2,4);
  }
  people.put(p.ssn,p);
}

//Parses P5 Category Entries
void Pfive(String values){
  String ssn = values.substring(50,59);
  Person p;
  if(people.containsKey(ssn)){
    p = people.get(ssn);
  }else{
    p = new Person(ssn);
  }
  p.loc_id = values.substring(2,25);
  people.put(p.ssn,p);
  
}