boolean Scan() {
  char notation[] = {'U', 'F', 'R', 'B', 'L', 'D'};
  int system[] = {0, 2, 3, 4, 1, 5};
  for (int i = 0; i<6; i++) {
    Solver.clear();
    Solver.write("T " +notation[i]);
    Solver.write('\n');
    while (Solver.readString()==null) {
      delay(100);
    };
    Solver.clear();
    println("Face"+i+" Scanning....");
    if (notation[i] == 'B') {
      char RAM [][]= Scan_Face();
      for (int x = 0; x<3; x++) {
        for (int y = 0; y<3; y++) {
          Cube_Color[system[i]][x][y] = RAM[x][y];
        }
      }
    } else  if (notation[i] == 'D') {
      Cube_Color[system[i]] = TWOD_ARRAY_ROTATE(false, Scan_Face());
    } else {
      Cube_Color[system[i]] = Scan_Face();
    }

    for (int F = 0; F<6; F++) {
      for (int x = 0; x<3; x++) {
        for (int y = 0; y<3; y++) {
          rubik.face[system[i]].setCubeColor(y, x, Cube_Color[system[i]][x][y]);
        }
      }
    }    

    rubik.printColor();
  }
  rubik  = rubik.rotateCube(rubik, 'Y', 1);
  rubik  = rubik.rotateCube(rubik, 'Y', 1);
  rubik  = rubik.rotateCube(rubik, 'Z', -1);
  Solver.write("R");
  Solver.write('\n');
  delay(100);
  if (rubik.Check()[0]=='N') {
    return true;
  } else {
    println("-------------------------------------------------");
    println("!!!!!-----------------ERROR-----------------!!!!!");
    println("-------------------------------------------------");
    for (int i = 0; i<6; i++) {
      print(rubik.Check()[i]);
      print(',');
    }
    println("");
    println("-------------------------------------------------");
    println("!!!!!-----------------ERROR-----------------!!!!!");
    println("-------------------------------------------------");
    return false;
  }
}
