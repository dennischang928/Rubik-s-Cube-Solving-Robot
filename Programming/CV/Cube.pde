class rubikCube {

  //rubikCubeFace upFace, leftFace, frontFace, rightFace, backFace, downFace;
  rubikCubeFace face[] = new rubikCubeFace[6];
  int cubeID;
  String parentComment;


  rubikCube() {
    face[0] = new rubikCubeFace('W');//UP
    face[1] = new rubikCubeFace('O');//LEFT
    face[2] = new rubikCubeFace('G');//FRONG
    face[3] = new rubikCubeFace('R');//RIGHT
    face[4] = new rubikCubeFace('B');//BACK
    face[5] = new rubikCubeFace('Y');//DOWN

    face[0].neighbor = new int[]{4, 3, 2, 1};//UP
    face[1].neighbor = new int[]{0, 2, 5, 4};//LEFT
    face[2].neighbor = new int[]{0, 3, 5, 1};//FRONG
    face[3].neighbor = new int[]{0, 4, 5, 2};//RIGHT
    face[4].neighbor = new int[]{0, 1, 5, 3};//BACK
    face[5].neighbor = new int[]{2, 3, 4, 1};//DOWN

    // numbers mean rotate CW number
    face[0].neighborDirection = new int[]{2, 3, 0, 1};//UP
    face[1].neighborDirection = new int[]{3, 0, 1, 0};//LEFT
    face[2].neighborDirection = new int[]{0, 0, 0, 0};//FRONG
    face[3].neighborDirection = new int[]{1, 0, 3, 0};//RIGHT
    face[4].neighborDirection = new int[]{2, 0, 2, 0};//BACK
    face[5].neighborDirection = new int[]{0, 1, 2, 3};//DOWN

    for (int k=0; k <=5; k++)
      for (int i=0; i <=2; i++)
        for (int j=0; j <=2; j++)
          face[k].rubik_color[i][j].rubik_ID = 9*k+3*i+j;

    cubeID = calcID();
    parentComment = "";
  }



  rubikCube  clone() {
    rubikCube temp = new rubikCube();
    for (int i=0; i < 6; i++) temp.face[i] = face[i].clone();
    temp.cubeID = cubeID;
    temp.parentComment = parentComment;
    return temp;
  }


  // I set the groble axis of the world is that x axis points from front to back
  // y axis points from right to left, z axis points from down to up

  rubikCube rotateCubeX(int degree) {
    return rotateCubeX(this, degree);
  }

  rubikCube rotateCubeX(rubikCube _r, int degree) {
    if (degree == 1) {
      _r.face[2].rotateCW();
      _r.face[4].rotateACW();

      rubikCubeFace tempFace[] = new rubikCubeFace[4];
      // clone the neighbor face base on the neighbor face id array

      tempFace[0] =  _r.face[0].clone();
      tempFace[1] =  _r.face[3].clone();
      tempFace[2] =  _r.face[5].clone();
      tempFace[3] =  _r.face[1].clone();


      tempFace[0].rotateCW();
      tempFace[1].rotateCW();
      tempFace[2].rotateCW();
      tempFace[3].rotateCW();

      _r.face[5] = tempFace[1].clone();
      _r.face[1] = tempFace[2].clone();
      _r.face[0] = tempFace[3].clone();
      _r.face[3] = tempFace[0].clone();

      _r.cubeID = _r.calcID();
    } else if (degree == -1) {
      _r = rotateCubeX(_r, 1);
      _r = rotateCubeX(_r, 1);
      _r = rotateCubeX(_r, 1);
    } else if (degree == 2) {
      _r = rotateCubeX(_r, 1);
      _r = rotateCubeX(_r, 1);
    }
    return _r;
  }

  rubikCube rotateCubeY(int degree) {
    return rotateCubeY(this, degree);
  }

  rubikCube rotateCubeY(rubikCube _r, int degree) {
    if (degree == 1) {
      _r.face[3].rotateCW();
      _r.face[1].rotateACW();


      rubikCubeFace temp = _r.face[0].clone();
      _r.face[0] = _r.face[2].clone();
      _r.face[2] = _r.face[5].clone();
      _r.face[5] = _r.face[4].clone();
      _r.face[4] = temp.clone();

      // rotate one more time base on real rotation

      _r.face[4].rotateCW();
      _r.face[4].rotateCW();
      _r.face[5].rotateCW();
      _r.face[5].rotateCW();


      _r.cubeID = _r.calcID();
    } else if (degree == -1) {
      _r = rotateCubeY(_r, 1);
      _r = rotateCubeY(_r, 1);
      _r = rotateCubeY(_r, 1);
    } else if (degree == 2) {
      _r = rotateCubeY(_r, 1);
      _r = rotateCubeY(_r, 1);
    }
    return _r;
  }

  rubikCube rotateCubeZ(int degree) {
    return rotateCubeZ(this, degree);
  }

  rubikCube rotateCubeZ(rubikCube _r, int degree) {
    if (degree == 1) {
      _r.face[5].rotateCW();
      _r.face[0].rotateACW();

      rubikCubeFace temp =  _r.face[4].clone();
      _r.face[4] = _r.face[3].clone();
      _r.face[3] = _r.face[2].clone();
      _r.face[2] = _r.face[1].clone();
      _r.face[1] = temp;

      _r.cubeID = _r.calcID();
    } else if (degree == -1) {
      _r = rotateCubeZ(_r, 1);
      _r = rotateCubeZ(_r, 1);
      _r = rotateCubeZ(_r, 1);
    } else if (degree == 2) {
      _r = rotateCubeZ(_r, 1);
      _r = rotateCubeZ(_r, 1);
    }
    return _r;
  }


  rubikCube twistPuzzle( String comment) {

    rubikCube r =this.clone();
    char faceComment=0, lastFaceComment=0;
    char directionComment=0, lastDirectionComment= 0;


    if (comment != null && comment.length() > 0) {
      String[] _comment =  split(comment, ' ');

      for (int i=0; i < _comment.length; i++) {

        if (_comment[i].length() == 0)  continue;
        else if (_comment[i].length() == 1) {
          faceComment = _comment[i].charAt(0);
          directionComment = 0;
        } else if (_comment[i].length() == 2) {
          faceComment = _comment[i].charAt(0);
          directionComment = _comment[i].charAt(1);
        }

        //if ((lastFaceComment == faceComment) && ((lastDirectionComment == 0 && directionComment == 39)
        //    || (lastDirectionComment == 39 && directionComment == 0))) {
        //    //print("skip me:");
        //    //println(str(lastFaceComment)+str(lastDirectionComment)+' '+str(faceComment)+str(directionComment));
        //    return null;
        //} else {

        if (faceComment == 'F' || faceComment == 'B' || faceComment == 'L' || faceComment == 'R' || faceComment == 'U' || faceComment == 'D') {
          if (directionComment == 0)  r = twistCW(r, faceComment);
          else if (directionComment == 39)  r = twistACW(r, faceComment);
          else if (directionComment == '2') r = twistCW(twistCW(r, faceComment), faceComment);
        } else if (faceComment == 'X' || faceComment == 'Y' || faceComment == 'Z') {
          if (directionComment == 0) r = rotateCube(r, faceComment, 1);
          else if (directionComment == 39) r = rotateCube(r, faceComment, -1);
        }
        r.cubeID = r.calcID();

        lastFaceComment = faceComment;
        lastDirectionComment = directionComment;
      }
    }

    return r;
  }


  rubikCube rotateCube(rubikCube _r, char _comment, int dir) {
    if (_comment == 'X')  return _r.clone().rotateCubeX(dir);
    if (_comment == 'Y')  return _r.clone().rotateCubeY(dir);
    if (_comment == 'Z')  return _r.clone().rotateCubeZ(dir);
    return null;
  }

  rubikCube twistCW(rubikCube _r, char _faceComment) {
    int k = selectFace(_faceComment);

    _r.face[k].rotateCW();

    rubikCubeFace tempFace[] = new rubikCubeFace[4];

    // clone the neighbor face base on the neighbor face id array
    for (int i = 0; i < 4; i++)
      tempFace[i] =  _r.face[ _r.face[k].neighbor[i] ].clone();

    // rotate the neighbor face base on the above direction array
    for (int i = 0; i < 4; i++)
      for (int j=0; j <_r.face[k].neighborDirection[i]; j++)
        tempFace[i].rotateCW();

    COLOR[] lefttemp = new COLOR[3];
    COLOR[] uptemp = new COLOR[3];
    COLOR[] righttemp = new COLOR[3];
    COLOR[] downtemp = new COLOR[3];

    arrayCopy(tempFace[0].getCubeRow(2), uptemp);
    arrayCopy(tempFace[1].getCubeColumn(0), righttemp);
    arrayCopy(tempFace[2].getCubeRow(0), downtemp );
    arrayCopy(tempFace[3].getCubeColumn(2), lefttemp);

    tempFace[0].setCubeRow(2, Reverse(lefttemp));
    tempFace[1].setCubeColumn(0, uptemp);
    tempFace[2].setCubeRow(0, Reverse(righttemp));
    tempFace[3].setCubeColumn(2, downtemp);

    // rotate back to the original direction
    for (int i = 0; i < 4; i++)
      for (int j=0; j <_r.face[k].neighborDirection[i]; j++)
        tempFace[i].rotateACW();

    for (int i = 0; i < 4; i++)
      _r.face[_r.face[k].neighbor[i]] = tempFace[i].clone();

    return _r;
  }

  rubikCube twistACW(rubikCube _r, char _faceComment) {
    int k = selectFace(_faceComment);

    _r.face[k].rotateACW();

    rubikCubeFace tempFace[] = new rubikCubeFace[4];

    // clone the neighbor face base on the neighbor face id array
    for (int i = 0; i < 4; i++)
      tempFace[i] =  _r.face[ _r.face[k].neighbor[i] ].clone();

    // rotate the neighbor face base on the above direction array
    for (int i = 0; i < 4; i++)
      for (int j=0; j <_r.face[k].neighborDirection[i]; j++)
        tempFace[i].rotateCW();

    COLOR[] lefttemp = new COLOR[3];
    COLOR[] uptemp = new COLOR[3];
    COLOR[] righttemp = new COLOR[3];
    COLOR[] downtemp = new COLOR[3];

    arrayCopy(tempFace[0].getCubeRow(2), uptemp);
    arrayCopy(tempFace[1].getCubeColumn(0), righttemp);
    arrayCopy(tempFace[2].getCubeRow(0), downtemp);
    arrayCopy(tempFace[3].getCubeColumn(2), lefttemp);

    tempFace[0].setCubeRow(2, righttemp);
    tempFace[1].setCubeColumn(0, Reverse(downtemp));
    tempFace[2].setCubeRow(0, lefttemp);
    tempFace[3].setCubeColumn(2, Reverse(uptemp));

    // rotate back to the original direction
    for (int i = 0; i < 4; i++)
      for (int j=0; j <_r.face[k].neighborDirection[i]; j++)
        tempFace[i].rotateACW();

    for (int i = 0; i < 4; i++)
      _r.face[_r.face[k].neighbor[i]] = tempFace[i].clone();

    return _r;
  }

  void printColor() {

    face[0].printFaceColor();
    for (int i = 0; i < 3; i++) {
      for (int j = 1; j <= 4; j++)
        face[j].printRowColor(i);
      println();
    }
    face[5].printFaceColor();
  }

  void drawCube() {

    pushMatrix();
    translate(10, 10);

    pushMatrix();
    translate(box_size*3, 0);
    face[0].drawFace();
    popMatrix();

    pushMatrix();
    translate(0, box_size*3);
    face[1].drawFace();
    translate(box_size*3, 0);
    face[2].drawFace();
    translate(box_size*3, 0);
    face[3].drawFace();
    translate(box_size*3, 0);
    face[4].drawFace();
    popMatrix();

    pushMatrix();
    translate(box_size*3, box_size*6);
    face[5].drawFace();
    popMatrix();

    popMatrix();
  }

  int selectFace(char _face) {
    int ans = 0;
    switch(_face) {
    case 'U':
      ans = 0;
      break;
    case 'L':
      ans = 1;
      break;
    case 'F':
      ans = 2;
      break;
    case 'R':
      ans = 3;
      break;
    case 'B':
      ans = 4;
      break;
    case 'D':
      ans = 5;
      break;
    }
    return ans;
  }

  COLOR[] Reverse(COLOR[] l) {
    COLOR[] temp = new COLOR[l.length];
    for (int i = 0; i < l.length; i++)
      temp[l.length-1-i] = l[i];
    return temp;
  }

  int calcID() {
    char[] msg = new char[54];
    for (int k=0; k <=5; k++)
      for (int i=0; i <=2; i++)
        for (int j=0; j <=2; j++)
          msg[9*k+3*i+j] = face[k].rubik_color[i][j].rubik_color;

    return crc32(msg);
  }

  int colorID(char _color) {
    int returnColorID = 0;
    switch (_color) {
    case 'W':
      returnColorID = 0;
      break;
    case 'O':
      returnColorID = 1;
      break;
    case 'G':
      returnColorID = 2;
      break;
    case 'R':
      returnColorID = 3;
      break;
    case 'B':
      returnColorID = 4;
      break;
    case 'Y':
      returnColorID = 5;
      break;
    }
    return returnColorID;
  }

  boolean matchID(rubikCube _r) {
    return (_r.cubeID== cubeID);
  }

  int crc32(char[] message) {


    int crc =  0xFFFFFFFF;    // initial contents of LFBSR
    int poly = 0xEDB88320;   // reverse polynomial

    for (char b : message) {
      int temp = (crc ^ (byte)b) & 0xff;

      // read 8 bits one at a time
      for (int i = 0; i < 8; i++) {
        if ((temp & 1) == 1) temp = (temp >>> 1) ^ poly;
        else                 temp = (temp >>> 1);
      }
      crc = (crc >>> 8) ^ temp;
    }

    // flip bits
    crc = crc ^ 0xffffffff;

    return crc;
  }


  boolean isGroup0(rubikCube _r, char Cube_State[]) {
    boolean ans = true;

    for (int i = 0; i<6; i++) {
      ans &= _r.face[i].rubik_color[1][1].rubik_color == Cube_State[i];
    }

    return ans;
  }

  boolean isGroup1() {
    return isGroup1(this);
  }

  boolean isGroup1(rubikCube _r) {
    boolean ans = true;

    //FU, FL, FR, FD
    char frontEdge[] = {_r.face[2].rubik_color[0][1].rubik_color, _r.face[2].rubik_color[1][0].rubik_color, 
      _r.face[2].rubik_color[1][2].rubik_color, _r.face[2].rubik_color[2][1].rubik_color};
    char frontEdgeAdjacent[] = {_r.face[0].rubik_color[2][1].rubik_color, _r.face[1].rubik_color[1][2].rubik_color, 
      _r.face[3].rubik_color[1][0].rubik_color, _r.face[5].rubik_color[0][1].rubik_color};

    //BU, BR, BL, BD
    char backEdge[] =   {_r.face[4].rubik_color[0][1].rubik_color, _r.face[4].rubik_color[1][0].rubik_color, 
      _r.face[4].rubik_color[1][2].rubik_color, _r.face[4].rubik_color[2][1].rubik_color};
    char backEdgeAdjacent[] = {_r.face[0].rubik_color[0][1].rubik_color, _r.face[3].rubik_color[1][2].rubik_color, 
      _r.face[1].rubik_color[1][0].rubik_color, _r.face[5].rubik_color[2][1].rubik_color};

    char upEdge[] = {_r.face[0].rubik_color[1][0].rubik_color, _r.face[0].rubik_color[1][2].rubik_color};
    char upEdgeAdjacent[] = {_r.face[1].rubik_color[0][1].rubik_color, _r.face[3].rubik_color[0][1].rubik_color};

    char downEdge[] = {_r.face[5].rubik_color[1][0].rubik_color, _r.face[5].rubik_color[1][2].rubik_color};
    char downEdgeAdjacent[] = {_r.face[1].rubik_color[2][1].rubik_color, _r.face[3].rubik_color[2][1].rubik_color};

    boolean temp = true;
    for (int i = 0; i <= 3; i++) {
      // Look at the F/B faces. If you see: L/R colour (orange/red) it's bad.
      temp &= frontEdge[i] != 'O' && frontEdge[i] != 'R';
      temp &= backEdge[i] != 'O' && backEdge[i] != 'R';

      //Look at the F/B faces. IF U/D colour (white/yellow) means you need to look round the side of the edge.
      //If the side is F/B (green/blue) it is bad.
      if (frontEdge[i] == 'W' || frontEdge[i] == 'Y') temp &= frontEdgeAdjacent[i] != 'G' && frontEdgeAdjacent[i] != 'B';
      if (backEdge[i] == 'W' || backEdge[i] == 'Y') temp &= backEdgeAdjacent[i] != 'G' && backEdgeAdjacent[i] != 'B';
    }
    for (int i = 0; i <= 1; i++) {
      //Then look at the U/D faces of the E-slice (middle layer). The same rules apply. If you see:
      // L/R colour (orange/red) it's bad.
      temp &= upEdge[i] != 'O' && upEdge[i] != 'R';
      temp &= downEdge[i] != 'O' && downEdge[i] != 'R';
      // U/D colour (white/yellow) means you need to look round the side of the edge.
      // If the side is F/B (green/blue) it is bad.
      if (upEdge[i] == 'W' || upEdge[i] == 'Y') temp &= upEdgeAdjacent[i] != 'G' && upEdgeAdjacent[i] != 'B';
      if (downEdge[i] == 'W' || downEdge[i] == 'Y') temp &= downEdgeAdjacent[i] != 'G' && downEdgeAdjacent[i] != 'B';
    }

    ans = temp;
    return ans;
  }

  boolean isGroup2_1() {
    return isGroup2_1(this);
  }

  boolean isGroup2_1(rubikCube _r) {
    // four of the edges are moved to the correct slice: The front-up, front-down, back-up, and back-down edges are placed in the M slice
    boolean ans = true;

    char group2EdgeCase[][] = {{'G', 'W'}, {'W', 'G'}, {'G', 'Y'}, {'Y', 'G'}, {'Y', 'B'}, {'B', 'Y'}, {'B', 'W'}, {'W', 'B'}};

    //FU, FD
    char frontEdge[] = {_r.face[2].rubik_color[0][1].rubik_color, _r.face[2].rubik_color[2][1].rubik_color};
    char frontEdgeAdjacent[] = {_r.face[0].rubik_color[2][1].rubik_color, _r.face[5].rubik_color[0][1].rubik_color};

    //BU, BD
    char backEdge[] =   {_r.face[4].rubik_color[0][1].rubik_color, _r.face[4].rubik_color[2][1].rubik_color};
    char backEdgeAdjacent[] = {_r.face[0].rubik_color[0][1].rubik_color, _r.face[5].rubik_color[2][1].rubik_color};

    boolean temp = false;

    for (int i = 0; i <= 7; i++) temp |= frontEdge[0] == group2EdgeCase[i][0] && frontEdgeAdjacent[0] == group2EdgeCase[i][1]; 
    ans &= temp;
    temp = false;
    for (int i = 0; i <= 7; i++) temp |= frontEdge[1] == group2EdgeCase[i][0] && frontEdgeAdjacent[1] == group2EdgeCase[i][1]; 
    ans &= temp;
    temp = false;
    for (int i = 0; i <= 7; i++) temp |= backEdge[0] == group2EdgeCase[i][0] && backEdgeAdjacent[0] == group2EdgeCase[i][1]; 
    ans &= temp;
    temp = false;
    for (int i = 0; i <= 7; i++) temp |= backEdge[1] == group2EdgeCase[i][0] && backEdgeAdjacent[1] == group2EdgeCase[i][1];
    ans &= temp;

    return ans;
  }

  boolean isGroup2_2() {
    return isGroup2_2(this);
  }

  boolean isGroup2_2(rubikCube _r) {
    boolean ans = true, temp;

    char upCorner[] =   {_r.face[0].rubik_color[0][0].rubik_color, _r.face[0].rubik_color[0][2].rubik_color, 
      _r.face[0].rubik_color[2][0].rubik_color, _r.face[0].rubik_color[2][2].rubik_color};
    char downCorner[] =   {_r.face[5].rubik_color[0][0].rubik_color, _r.face[5].rubik_color[0][2].rubik_color, 
      _r.face[5].rubik_color[2][0].rubik_color, _r.face[5].rubik_color[2][2].rubik_color};

    temp = isGroup2_1();

    for (int i=0; i <=3; i++) {
      temp &= upCorner[i] == 'W' || upCorner[i] == 'Y';
      temp &= downCorner[i] == 'W' || downCorner[i] == 'Y';
    }


    ans = temp;
    return ans;
  }

  boolean isGroup3() {
    return isGroup3(this);
  }

  boolean isGroup3(rubikCube _r) {
    boolean ans = true;

    char myColor[] = {'W', 'O', 'G', 'R', 'B', 'Y'};
    char oppositeColor[] = {'Y', 'R', 'B', 'O', 'G', 'W'};

    for (int k = 0; k <= 5; k++)
      for (int i = 0; i <= 2; i++)
        for (int j = 0; j <= 2; j++) {
          if (i == j && i == 1) continue; 
          ans &= _r.face[k].rubik_color[i][j].rubik_color == myColor[k] || _r.face[k].rubik_color[i][j].rubik_color == oppositeColor[k];
        }

    return ans;
  }

  boolean isSolved() {
    return isSolved(this);
  }

  boolean isSolved(rubikCube _r) {
    boolean ans = true;

    char myColor[] = {'W', 'O', 'G', 'R', 'B', 'Y'};
    for (int k = 0; k <= 5; k++)
      for (int i = 0; i <= 2; i++)
        for (int j = 0; j <= 2; j++) {
          if (i == j && i == 1) continue; 
          ans &= _r.face[k].rubik_color[i][j].rubik_color == myColor[k];
        }

    return ans;
  }
  char[] Check() {
    // red green blue yellow orange white
    char output[] = new char[6];
    int Color_Count[] = new int[6];

    for (int F = 0; F<6; F++) {
      for (int x = 0; x<3; x++) {
        for (int y = 0; y<3; y++) {
          Color_Count[Char2index(face[F].rubik_color[x][y].rubik_color)]++;
        }
      }
    }
    int index = 0;
    for (int F = 0; F<6; F++) {
      if (Color_Count[F]<9) {
        output[index]=index(F);
        index++;
      }
    }
    if (index == 0) { // nothing wrong
      output[0]='N';
    }
    return output;
  }
  String To_String () {
    String output = "";
    for (int F = 0; F<6; F++) {
      output += face[F].To_String();
    }
    return output;
  }


  int Char2index(char input) {
    int output= 0;
    if (input == 'R') {
      output = 0;
    }
    if (input == 'G') {
      output = 1;
    }
    if (input == 'B') {
      output = 2;
    }
    if (input == 'Y') {
      output = 3;
    }
    if (input == 'O') {
      output = 4;
    }
    if (input == 'W') {
      output = 5;
    }
    return(output);
  }
}
