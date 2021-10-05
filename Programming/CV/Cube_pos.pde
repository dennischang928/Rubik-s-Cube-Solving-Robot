class Detect_Area {
  float Sx;
  float Sy;
  float Ex;
  float Ey;
  Detect_Area(float Sx, float Sy, float Ex, float Ey) {
    this.Sx = Sx;
    this.Sy = Sy;
    this.Ex = Ex;  
    this.Ey = Ey;
  }
}

Detect_Area[] Find_Detect_Area(PixelArea TL, PixelArea DL) {
  float distance = dist(TL.x, TL.y, DL.x, DL.y)+10;
  // println(distance);)
  float Angle = (asin((TL.x - DL.x)/(distance)));

  PVector Origin = new PVector(TL.x, TL.y);
  PVector Center_Of_Each_Areas[] = new PVector[9];
  Center_Of_Each_Areas[0] = new PVector(Origin.x-(distance*0.5), Origin.y-(distance*0.5));
  Center_Of_Each_Areas[1] = new PVector(Origin.x+(distance*0.5), Origin.y-(distance*0.15));
  Center_Of_Each_Areas[2] = new PVector(Origin.x+(distance*1.5), Origin.y-(distance*0.5));

  Center_Of_Each_Areas[3] = new PVector(Origin.x-(distance*0.5), Origin.y+(distance*0.5));
  Center_Of_Each_Areas[4] = new PVector(Origin.x+(distance*0.5), Origin.y+(distance*0.5));
  Center_Of_Each_Areas[5] = new PVector(Origin.x+(distance*1.5), Origin.y+(distance*0.5));

  Center_Of_Each_Areas[6] = new PVector(Origin.x-(distance*0.5), Origin.y+(distance*1.5));
  Center_Of_Each_Areas[7] = new PVector(Origin.x+(distance*0.5), Origin.y+(distance*1.15));
  Center_Of_Each_Areas[8] = new PVector(Origin.x+(distance*1.5), Origin.y+(distance*1.5));
  Detect_Area Output[] = new Detect_Area[9];

  for (int i = 0; i<9; i++) {
    float W = distance * 0.4;
    float L = distance * 0.4;
    if (i == 1||i == 7) {
      L = distance * 0.15;
    }
    Output[i] = XY2Rect(Center_Of_Each_Areas[i], W, L);
  }

  Detect_Area Translated_Output[] = new Detect_Area[9];
  for (int x = 0; x<9; x++) {
    Output[x].Sx = Output[x].Sx - Origin.x;
    Output[x].Sy = Output[x].Sy - Origin.y;
    Output[x].Ex = Output[x].Ex - Origin.x;
    Output[x].Ey = Output[x].Ey - Origin.y;

    Output[x].Sx = Output[x].Sx*cos(Angle) - Output[x].Sy*sin(Angle);
    Output[x].Sy = Output[x].Sx*sin(Angle) + Output[x].Sy*cos(Angle);
    Output[x].Ex = Output[x].Ex*cos(Angle) - Output[x].Ey*sin(Angle);
    Output[x].Ey = Output[x].Ex*sin(Angle) + Output[x].Ey*cos(Angle);

    Output[x].Sx = Output[x].Sx + Origin.x;
    Output[x].Sy = Output[x].Sy + Origin.y;
    Output[x].Ex = Output[x].Ex + Origin.x;
    Output[x].Ey = Output[x].Ey + Origin.y;  
  }

  return Output;
}

Detect_Area XY2Rect(PVector center_Of_Rect, float Width, float Length) {
  Detect_Area Output = new Detect_Area(center_Of_Rect.x - (Width / 2), center_Of_Rect.y - (Length / 2), center_Of_Rect.x + (Width / 2), center_Of_Rect.y + (Length / 2));
  return Output;
}
