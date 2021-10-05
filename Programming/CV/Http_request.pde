
void Put(String Prover, String Pyver) { // Putting two Cube State in "http://localhost:3000/data"
  PutRequest put = new PutRequest("http://localhost:3000/data");
  put.addHeader("Content-Type", "application/json");
  put.addData("{\"Cube_State_Processing\":\"" + Prover+ "\"," + "\"Cube_State_Python\":\"" + Pyver+ "\"," + "\"Cube_Solution\":" + "\""+" "+"\","+ "\"SolverID\":" + "\""+0+"\"}");
  put.send();
}

String PystateComment = "";
String ProstateComment = "";
String directionComment[] = {"X", "X'", "Y", "Y'", "Z", "Z'"};


void randomize (String[] arrMy) {
  for (int k=0; k < arrMy.length; k++) {
    int x = (int)random(0, arrMy.length);
    arrMy = swapValues(arrMy, k, x);
  }
}

String[] swapValues (String[] myArray, int a, int b) {
  String temp=myArray[a];
  myArray[a]=myArray[b];
  myArray[b]=temp;
  return myArray;
}



rubikCube Rotate_Cube_To_Pro() { //
  rubikCube output = new rubikCube();
  char Orientation[] = {'W', 'O', 'G', 'R', 'B', 'Y'};
  for (int i = 1; i<52; i++) {
    if (To_Cube_Oriented(rubik, i, Orientation, true) == true) {
      break;
    }
  }
  println("processing: "+ProstateComment);
  output = rubik.twistPuzzle(ProstateComment);
  println(output.To_String());
  return(output);
}
rubikCube Rotate_Cube_To_Py() { //
  rubikCube output = new rubikCube();
  char Orientation[] = {'Y', 'B', 'R', 'G', 'O', 'W'};
  for (int i = 1; i<52; i++) {
    if (To_Cube_Oriented(rubik, i, Orientation, false) == true) {
      break;
    }
  }
  println("python: "+PystateComment);
  output = rubik.twistPuzzle(PystateComment);
  println(output.To_String());
  return(output);
}


boolean To_Cube_Oriented(rubikCube _r, int _limit, char Cube_State[], boolean PROorPy) {

  if (PROorPy == true) {
    if (_r.isGroup0(_r, Cube_State)) {
      ProstateComment = _r.parentComment;
      return true;
    }
  } else {
    if (_r.isGroup0(_r, Cube_State)) {
      PystateComment = _r.parentComment;
      return true;
    }
  }
  if (_limit <= 0) return false;
  for (int i=0; i < directionComment.length; i++) {
    rubikCube temp = _r.twistPuzzle(directionComment[i]);
    temp.parentComment += directionComment[i]+' ';
    if (To_Cube_Oriented(temp, _limit - 1, Cube_State, PROorPy)) {
      return true;
    }
  }
  return false;
}





int GetSolvedIndex() {
  GetRequest get = new GetRequest("http://localhost:3000/data");
  get.send();
  JSONObject response = parseJSONObject(get.getContent());
  String SolverID = (response.getString("SolverID"));
  if (SolverID.equals("1")||SolverID.equals("3")) {
    return int(SolverID);
  }
  return -1;
}
