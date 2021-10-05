import processing.video.*; //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
import processing.serial.*;
import http.requests.*;
import controlP5.*;
import gab.opencv.*;
import processing.sound.*;


OpenCV opencv;

ControlP5 GUI; 

Serial Solver;   

Capture cam; 

int[]FaceColor = new int[9];//FaceColor RAM
char Cube_Color[][][] = new char[6][3][3];//whole Cube color
color[]face_color = {#9B2D2D, #A0F0A0, #00A0F0, #F0F050, #F0A000, #ffffff}; 
// red green blue yellow orange white(this value compare with camera)
color[]src = {#A50613,#AEDDB7,#266FBA, #F9EB9E, #E78221, #ffffff}; 
color[]Corsrc = {#A50613,#AEDDB7,#266FBA ,#F9EB9E, #E78221, #ffffff}; 

boolean debug = true; //Use to adjust the Corsrc and src
boolean PDraw_rect = false;

//Calbration part(value)
int mstartx, mstarty; 
int[]Detectx = new int[9];
int[]Detecty = new int[9];
int[]Detectcornx = new int[9];
int[]Detectcorny = new int[9];
int cal_counter = 0;
boolean cal = false;
boolean Auto_cal = false;
boolean Tragged = false;
boolean Released = false;
boolean Pressed = false;
//Calbration part(value) END

SoundFile Finish_Sound;

color[] OriginalColorptNineRes = new color[9];//average color value of a area
color[] OriginalColorpt = new color[9];

//Cube drawing
int box_size = 80;
rubikCube rubik = new rubikCube();
//Cube drawing END

boolean Solving = false;
boolean Scanning = false;  

color PIXELS[][] = new color[640][480]; // From pixel[] to PIXELS[][]


void setup() {
  //Serial port
  // printArray(Serial.list());
  Solver = new Serial(this, Serial.list()[4], 115200);
  //Serial portEND

  //Camera
  String[] cameras = Capture.list();
  printArray(cameras);
  cam = new Capture(this, cameras[3]);
  cam.resize(640, 480);
  cam.start();
  //Camera END

  //calbration part
  String[] x = loadStrings("calbrationx.txt");
  String[] y = loadStrings("calbrationy.txt");
  String[] Conx = loadStrings("calbrationConx.txt");
  String[] Cony = loadStrings("calbrationCony.txt");
  Detectx = int(x);
  Detecty = int(y);
  Detectcorny = int(Cony);
  Detectcornx = int(Conx);



  //create a new button with name 'buttonA'
  textSize(90); 
  //PFont  font = new PFont();
  //font = createFont("andalemo.ttf", 60);
  textSize(32);
  //PFont text = new Font("andalemo.ttf", 32);
  //textFont(text);
  PFont font1 = createFont("beef'd.ttf", 14);
  PFont font2 = createFont("beef'd.ttf", 11);

  //GUI
  GUI = new ControlP5(this);
  GUI.addButton("Solve")
    .setPosition(700, 600)
    .setSize(180, 50)
    .setFont(font1)
    .activateBy(ControlP5.RELEASE)
    ;
  //Celebrate Song
  Finish_Sound = new SoundFile(this, "never-gonna-give-you-up-video.mp3");


  size(980, 740);
  colorMode(RGB, 255);
}


PImage CAM;
int ha = 0;
void draw() {

  //setup(START)
  imageMode(CENTER);
  background(255);

  //setup(END)



  //calibration
  if (cal ==  true) {
    background(255);
    cam.read();
    image(cam, width / 2, height / 2, 640, 480);
    if (PDraw_rect != Draw_rect) {
      if (Draw_rect == true) {
        PDraw_rect = Draw_rect;
      } 
      mstartx = mouseX;
      mstarty = mouseY;
    }
    calbration();
  } else if (Scanning == true) {
    println("Scanning...");
    //for (int i = 0; i< 3; i++) {
    if (Scan() == true) { // When not error occurs
      Scanning = false;
      Solving = true;
    } else {
      Scanning = false;
      Solver.write("T B");
      Solver.write('\n');
      Solver.clear();
      delay(100);
      println("Error Occurs, Press S to try again");
    }
  } else if (Solving == true) {
    println("Solving...");
    rubikCube ProVer = new rubikCube();
    rubikCube PyVer = new rubikCube();

    ProVer = Rotate_Cube_To_Pro();
    PyVer = Rotate_Cube_To_Py();
    Put(ProVer.To_String(), PyVer.To_String());
    //waiting for solve
    int ID = GetSolvedIndex();
    while (ID == -1) {
      ID = GetSolvedIndex();
      delay(300);
    }
    GetRequest get = new GetRequest("http://localhost:3000/data");
    get.send();

    if (ID == 1) {
      String[] XYZROT =  split(ProstateComment, ' ');
      for (int i = 0; i < XYZROT.length; i++) {
        Solver.write("F " + XYZROT[i]);
        println("F " + XYZROT[i]);
        Solver.clear();   
        Solver.write('\n');
        while (Solver.readString() ==  null) {
          delay(300);
        }
        Solver.clear();        
        delay(300);
      }
      rubik = ProVer;
    } else {
      String[] XYZROT =  split(PystateComment, ' ');

      for (int i = 0; i < XYZROT.length; i++) {
        Solver.write("F " + XYZROT[i]);
        println("F " + XYZROT[i]);
        Solver.write('\n');
        while (Solver.readString() ==  null) {
          delay(200);
        }
        Solver.clear();        
        delay(200);
      }
      rubik = PyVer;
    }
    Solver.clear();
    JSONObject response = parseJSONObject(get.getContent());
    String Solution = (response.getString("Cube_Solution"));
    delay(200);

    int start = 0;
    int end = 10;
    for (int  i = 0; i < ceil(float(Solution.length()) / 100); i++) {
      if (i == (ceil(float(Solution.length()) / 100) - 1)) {
        Solver.write("G " + (Solution.substring(start, Solution.length())));
        Solver.write('\n');
      } else {
        Solver.write("G " + (Solution.substring(start, end)));
        Solver.write('\n');
      }
      start += 10;
      end += 10;
      while (Solver.readString() ==  null) {
        delay(200);
      }
      Solver.clear();
    }



    Solving = false;
    println("----------------Solved-------------------");
    println("----------------Solved-------------------");
    println("----------------Solved-------------------");
    println("----------------Solved-------------------");
    rubik = new rubikCube();
    Finish_Sound.play();
  } else if (Auto_cal == true) {
    cam.read();
    auto_Calbration(cam);
  } else {
    FaceDetect();
    rubik.drawCube();

    if (debug == true) {
      for (int i = 0; i < 9; i++) {
        print(hex(FaceAverage(Detectx[i], Detecty[i], Detectcornx[i], Detectcorny[i]), 6));
        print(",");
      }
      println("");
    } else {
      for (int i = 0; i < 9; i++) {
        textSize(20);
        textAlign(CENTER);
      }
    }
  }
  Released = false;
  Tragged = false;
}


void mouseDragged() {
  Tragged = true;
}

void mouseReleased() {
  Released = true;
}

float deltaEE(color compared, color source) {
  float RC = 2;
  float GC = 4;
  float BC = 3;

  float comR = red(compared);
  float comG = green(compared);
  float comB = blue(compared);
  float sourceR = red(source);
  float sourceG = green(source);
  float sourceB = blue(source);

  float r = (comR + sourceR) / 2;
  float diffR = sq(comR - sourceR);
  float diffG = sq(comG - sourceG);
  float diffB = sq(comB - sourceB);

  return sqrt(2 * diffR + 4 * diffG + 3 * diffB);
}

int DetectColor(color[] comparedNineDigit, color[]src) {
  int number_of_Colors[] = {0, 0, 0, 0, 0, 0};
  int[] Colors_Detect = new int[comparedNineDigit.length];
  for (int i = 0; i < comparedNineDigit.length; i++) {
    Colors_Detect[i] = minColor(comparedNineDigit[i]);
  }
  for (int i = 0; i < Colors_Detect.length; i++) {
    number_of_Colors[Colors_Detect[i]]++;
    //println(Colors_Detect[i]);
  }
  int maxCount = number_of_Colors[0];
  int maxindex = 0;
  //printArray(number_of_Colors);
  for (int i = 1; i < 6; i++) {
    if (maxCount <=  number_of_Colors[i]) {
      maxCount = number_of_Colors[i];
      maxindex = i;
    }
  }
  return(maxindex);
}
int minColor(color compare) {
  int index = 0;
  float min = deltaE(compare, src[0]);
  //println(deltaE(compare, src[5]));
  //if (deltaE(compare, src[5])>60) {
  for (int i = 1; i < 6; i++) {
    if (min > (deltaE(compare, src[i]))) {
      min = (deltaE(compare, src[i]));
      index = i;
    }
  }
  return(index);
}

char[][] TWOD_ARRAY_ROTATE(boolean ways, char input[][]) { // ways: true clockwise, false anticlockwise
  char output[][] = new char[3][3];
  if (ways == true) {
  } else {
    for (int y = 0; y < 3; y++) {
      for (int x = 0; x < 3; x++) {
        output[x][y] = input[2 - y][x];
      }
    }
  }
  return output;
}

char index(int index) {
  char output = ' ';
  if (index == 0) {
    output = 'R';
  }
  if (index == 1) {
    output = 'G';
  }
  if (index == 2) {
    output = 'B';
  }
  if (index == 3) {
    output = 'Y';
  }
  if (index == 4) {
    output = 'O';
  }
  if (index == 5) {
    output = 'W';
  }
  return(output);
}

void FaceDetect() {
  cam.read();
  PIXELS = pixel();
  for (int i = 0; i < 9; i++) {
    FaceColor[8 - i] = DetectColor(findaverage(Detectx[i], Detecty[i], Detectcornx[i], Detectcorny[i]), src);
  }
}  

color[] findaverage(int sx, int sy, int ex, int ey) {
  PIXELS = pixel();
  float outputHue = 0;
  float outputSat = 0;
  float outputbright = 0; 
  color output[] = new color[abs(sx - ex) * abs(sy - ey)];
  float pxnum = 0;
  int  i = 0;
  for (int x = sx; x < ex; x++) {
    for (int y = sy; y < ey; y++) {
      color input = 0;
      outputHue = red(PIXELS[x][y]);
      outputSat = green(PIXELS[x][y]);
      outputbright = blue(PIXELS[x][y]);
      input = color(outputHue, outputSat, outputbright);
      output[i] = input;
      i++;
    }
  }
  return(output);
}


color FaceAverage(int sx, int sy, int ex, int ey) {
  cam.read();
  PIXELS = pixel();
  float outputHue = 0;
  float outputSat = 0;
  float outputbright = 0; 
  float pxnum = 0;
  int  i = 0;
  for (int x = sx; x < ex; x++) {
    for (int y = sy; y < ey; y++) {
      outputHue += red(PIXELS[x][y]);
      outputSat += green(PIXELS[x][y]);
      outputbright += blue(PIXELS[x][y]);
      pxnum++;
    }
  }
  color output = color(outputHue / pxnum, outputSat / pxnum, outputbright / pxnum);
  return(output);
}


void keyPressed() {
  if (key == 'C' || key == 'c') {
    cal = true;
  }
  if (key == 'S' || key == 's') {
    //Scan_Cube();
    Scanning = true;
  }
  
  if (key == 'E' || key == 'e') {
    Solver.write("E X");
    Solver.write('\n');
    while (Solver.readString() ==  null) {
      delay(200);
    }
    Solver.clear();
    Solver.write("E Y");
    Solver.write('\n');
    while (Solver.readString() ==  null) {
      delay(200);
    }
    Solver.clear();
  }
  if (key == 'D' || key == 'd') {
    Solver.write("D X");
    Solver.write('\n');
    while (Solver.readString() ==  null) {
      delay(200);
    }
    Solver.clear();
    Solver.write("D Y");
    Solver.write('\n');
    while (Solver.readString() ==  null) {
      delay(200);
    }
    Solver.clear();
  }
  if (key == 'K' || key == 'k') {
    Solving = true;
  }
  if (key == 'X' || key == 'x') {
    Solver.write("D X");
    Solver.write('\n');
    FaceDetect();
    for (int i = 0; i < 9; i++) {
      print(hex(OriginalColorptNineRes[i], 6));
      print(",");
    }
    println("");
    delay(4000);
  }
  if (key == 'Y' || key == 'y') {
    Solver.write("D Y");
    Solver.write('\n');
    FaceDetect();
    for (int i = 0; i < 9; i++) {
      print(hex(OriginalColorptNineRes[i], 6));
      print(",");
    }
    println("");
    delay(4000);
  }
  if (key == 'A' || key == 'a') {
    Auto_cal = true;
    delay(200);
  }
}


char[][] Scan_Face() {
  Solver.write("D X");
  Solver.write('\n');
  while (Solver.readString() ==  null) {
    delay(100);
  };
  Solver.clear();
  FaceDetect();
  cam.save("DX");
  int[][] Face_ColourTwoD = OneD_TO_TwoD(FaceColor);
  char output[][] = new char[3][3];
  for (int x = 0; x < 3; x++) {
    for (int y = 0; y < 3; y++) {
      output[x][y] = ' ';
    }
  }
  for (int y = 0; y < 3; y++) {
    output[0][y] = index(Face_ColourTwoD[0][y]);
    output[2][y] = index(Face_ColourTwoD[2][y]);
  }
  for (int y = 0; y < 3; y++) {
    for (int x = 0; x < 3; x++) {
      print(output[x][y] + ", ");
    }
    println("");
  }
  println("-------------------");
  Solver.write("E X");
  Solver.write('\n');
  while (Solver.readString() ==  null) {   
    delay(100);
  };
  Solver.clear();
  Solver.write("D Y");
  Solver.write('\n');
  while (Solver.readString() ==  null) {
    delay(100);
  };

  Solver.clear();
  FaceDetect();

  for (int y = 0; y < 3; y++) { 
    output[1][y] = index(Face_ColourTwoD[1][y]);
  }
  for (int y = 0; y < 3; y++) {
    for (int x = 0; x < 3; x++) {
      print(output[x][y] + ", ");
    }
    println("");
  }
  println("-------------------");
  Solver.write("E Y");
  Solver.write('\n');
  while (Solver.readString() ==  null) {
    delay(100);
  };
  Solver.clear();
  return(output);
}

int[][] OneD_TO_TwoD(int input[]) {
  int output[][] = new int[3][3];
  for (int x = 0; x < 3; x++) {
    for (int y = 0; y < 3; y++) {
      output[x][y] = input[x + y * 3];
    }
  }
  return(output);
}

color[][] pixel() {
  PImage src = cam;
  color output[][] = new color[640][480];
  src.loadPixels();
  for (int x = 0; x < 640; x++) {
    for (int y = 0; y < 480; y++) {
      int location = x + y * 640;
      output[x][y] = src.pixels[location];
    }
  }
  return(output);
}
