class COLOR {
  char rubik_color;
  int rubik_ID;

  COLOR clone() {
    COLOR temp = new COLOR();
    temp.rubik_color = rubik_color;
    temp.rubik_ID = rubik_ID;
    return temp;
  }
}

class rubikCubeFace {


  COLOR rubik_color[][] = new COLOR[3][3];

  int neighbor[] = new int[4];
  // The  array hold the 4 neighbor UP, RIGHT, DOWN, RIGHT
  int neighborDirection[] = new int[4];



  rubikCubeFace() {
  }

  rubikCubeFace(char _color) {
    fillAllColor(_color);
  }

  rubikCubeFace  clone() {
    rubikCubeFace temp = new rubikCubeFace();
    for (int i=0; i < 3; i++) for (int j=0; j < 3; j++)temp.rubik_color[i][j] = rubik_color[i][j];
    for (int i=0; i < 4; i++) temp.neighbor = neighbor;
    for (int i=0; i < 4; i++) temp.neighborDirection = neighborDirection;
    return temp;
  }


  void fillAllColor(char _color) {
    for (int i = 0; i < rubik_color.length; i++)
      for (int j=0; j < rubik_color[0].length; j++) {
        rubik_color[i][j] = new COLOR();
        rubik_color[i][j].rubik_color = _color;
      }
  }

  void printFaceColor() {
    for (int i = 0; i < rubik_color.length; i++) {
      print("    ");
      for (int j=0; j < rubik_color[0].length; j++)
        print(rubik_color[i][j].rubik_color);
      println();
    }
  }

  void printFaceID() {
    for (int i = 0; i < rubik_color.length; i++) {
      print("    ");
      for (int j=0; j < rubik_color[0].length; j++)
        print(rubik_color[i][j].rubik_ID, ' ');
      println();
    }
  }

  void printRowColor(int rowNumber) {
    for (int j=0; j < rubik_color[0].length; j++)
      print(rubik_color[rowNumber][j].rubik_color);
    print(' ');
  }

  COLOR getCubeElement(int rowNumber, int columnNumber) {
    return rubik_color[rowNumber][columnNumber];
  }

  COLOR[] getCubeRow(int rowNumber) {
    COLOR[] temp = new COLOR[3];
    for (int i = 0; i < rubik_color.length; i++)
      temp[i] = rubik_color[rowNumber][i];
    return temp;
  }

  COLOR[] getCubeColumn(int columnNumber) {
    COLOR[] temp = new COLOR[3];
    for (int i = 0; i < rubik_color.length; i++)
      temp[i] = rubik_color[i][columnNumber];
    return temp;
  }

  void setCubeElement(int rowNumber, int columnNumber, COLOR _color) {
    rubik_color[rowNumber][columnNumber] = _color;
  }

  void setCubeColor(int rowNumber, int columnNumber, char _color) {
    rubik_color[rowNumber][columnNumber].rubik_color = _color;
  }

  void setCubeRow(int rowNumber, COLOR[] _color) {
    for (int i = 0; i <= 2; i++)
      rubik_color[rowNumber][i] = _color[i];
  }

  void setCubeColumn(int columnNumber, COLOR[] _color) {
    for (int i = 0; i <= 2; i++)
      rubik_color[i][columnNumber] = _color[i];
  }

  color fillColor(char _color) {
    color returnColor = 0;
    //red green blue yellow orange white
    switch (_color) {
    case 'W':
      returnColor = face_color[5];
      break;
    case 'O':
      returnColor = face_color[4];
      break;
    case 'G':
      returnColor = face_color[1];
      break;
    case 'R':
      returnColor = face_color[0];
      break;
    case 'B':
      returnColor = face_color[2];
      break;
    case 'Y':
      returnColor = face_color[3];
      break;
    }
    return returnColor;
  }

  void drawFace() {
    stroke(0);
    strokeWeight(1);
    for (int x=0; x<=2; x++) {
      for (int y=0; y<=2; y++) {
        fill(fillColor(rubik_color[y][x].rubik_color));
        rect(x*box_size, y*box_size, box_size, box_size);
        //fill(0);
        //text(rubik_color[y][x].rubik_ID, x*box_size+10, y*box_size+10);
      }
    }
    strokeWeight(5);
    noFill();
    rect(0, 0, 3*box_size, 3*box_size);
  }

  void rotateCW() {
    COLOR[][] temp =new COLOR[3][3];
    for (int i = 0; i < 3; i++)
      for (int j = 0; j < 3; j++)
        temp[i][j] = getCubeRow(i)[j];

    setCubeColumn(2, temp[0]);
    setCubeColumn(1, temp[1]);
    setCubeColumn(0, temp[2]);
  }

  void rotateACW() {
    COLOR[][] temp =new COLOR[3][3];
    for (int i = 0; i < 3; i++)
      for (int j = 0; j < 3; j++)
        temp[i][j] = getCubeColumn(i)[j];

    setCubeRow(2, temp[0]);
    setCubeRow(1, temp[1]);
    setCubeRow(0, temp[2]);
  }
  String To_String() {
    String output = "";
    for (int x = 0; x<3; x++) {
      for (int  y = 0; y<3; y++) {
        output += rubik_color[x][y].rubik_color;
      }
    }
    return output;
  }
}
