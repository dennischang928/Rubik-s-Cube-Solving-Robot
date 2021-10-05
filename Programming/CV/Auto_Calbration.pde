PImage INPUT;
Detect_Area Area [] = new Detect_Area[9];

void auto_Calbration(PImage input) {
  noStroke();
  opencv = new OpenCV(this, input);
  opencv.inRange(0, 50);
  INPUT = opencv.getSnapshot();
  imageMode(CORNERS);
  image(input, 0, 0);
  INPUT.loadPixels();

  PixelArea show[][] = FindAverage_PixelArea(INPUT.pixels);

  PixelArea Up_Left = Find_Left_Top(FindAverage_PixelArea(INPUT.pixels));
  PixelArea Down_Left = Find_Right_Top(FindAverage_PixelArea(INPUT.pixels));

  Area = Find_Detect_Area(Up_Left, Down_Left);
  fill(#21c24c);
  float distance = dist(Up_Left.x, Up_Left.y, Down_Left.x, Down_Left.y)+20;
  float Angle = (asin((Up_Left.x - Down_Left.x)/(distance)));
  pushMatrix();
  translate(Up_Left.x, Up_Left.y);
  rotate(Angle);
  translate(-Up_Left.x, -Up_Left.y);

  for (int i = 0; i<9; i++) {
    Rect(Area[i].Sx, Area[i].Sy, Area[i].Ex, Area[i].Ey);
  }
  fill(#FF0000);
  rect(Up_Left.x, Up_Left.y, AreaWidth, AreaLen);
  fill(#21c24c);
  rect(Down_Left.x, Down_Left.y, AreaWidth, AreaLen);
  popMatrix();
  if (keyPressed) {
    for (int i = 0; i < 9; i++) {
      Detectx[i] = int(Area[i].Sx);
      Detecty[i] = int(Area[i].Sy);
      Detectcornx[i] = int(Area[i].Ex);
      Detectcorny[i] = int(Area[i].Ey);
    }    
    saveStrings("calbrationx.txt", str(Detectx));
    saveStrings("calbrationy.txt", str(Detecty));
    saveStrings("calbrationConx.txt", str(Detectcornx));
    saveStrings("calbrationCony.txt", str(Detectcorny));
    cal_counter=0;
    cal = false;
    String[] x = loadStrings("calbrationx.txt");
    String[] y = loadStrings("calbrationy.txt");
    String[] Conx = loadStrings("calbrationConx.txt");
    String[] Cony = loadStrings("calbrationCony.txt");
    Detectx = int(x);
    Detecty = int(y);
    Detectcornx = int(Conx);
    Detectcorny = int(Cony);
    Auto_cal = false;
  }
}

void Rect(float sx, float sy, float ex, float ey) {
  // rectMode(CORNER);
  rect(sx, sy, ex-sx, ey-sy);
}
