class PixelArea {
  int x, y;
  color value;
  PixelArea(int x, int y, color value) {
    this.x  = x;
    this.y  = y;
    this.value  = value;
  }
}

int AreaWidth = 20;
int AreaLen = 20;

PixelArea[][] FindAverage_PixelArea(color input[]) {
  color Pixels[][] = Pixels_OneD2TwoD(input);
  //println(Pixels[0].length);
  PixelArea Area[][] = new PixelArea[Pixels.length/AreaWidth][Pixels[0].length/AreaLen];
  for (int x = 0; x<Pixels.length/AreaWidth; x++) {
    for (int y = 0; y<Pixels[x].length/AreaLen; y++) {
      Area[x][y] = new PixelArea(x*AreaWidth, y*AreaLen, Average(Pixels, x, y));
    }
  }
  return Area;
}

PixelArea Find_Left_Top(PixelArea input[][]) {
  PixelArea Filtered[] = Filter(input);
  PixelArea Output = new PixelArea(0, 0, 0);
  int index = 0;
  for (int i = 1; i<Filtered.length; i++) {
    if (dist(Filtered[index].x, Filtered[index].y, 0, 0)+Gray(Filtered[index].value) >dist( Filtered[i].x, Filtered[i].y, 0, 0)+Gray(Filtered[index].value)) {
      index = i;
    }
  }
  return Filtered[index];
}

PixelArea Find_Right_Top(PixelArea input[][]) {
  PixelArea Filtered[] = Filter(input);
  PixelArea Output = new PixelArea(0, 0, 0);
  int index = 0;
  for (int i = 1; i<Filtered.length; i++) {
    if (dist(Filtered[index].x, Filtered[index].y, 0, 480) + Gray(Filtered[index].value) >dist( Filtered[i].x, Filtered[i].y, 0, 480)+Gray(Filtered[index].value)) {
      index = i;
    }
  }
  return Filtered[index];
}

float Gray(color input) {
//  
  // return 0;
  // println((255-((red(input)+green(input)+blue(input))/3)));
  return ((((red(input)+green(input)+blue(input))/3))*10000);
}

PixelArea[] Filter(PixelArea input[][]) {
  int i = 0;
  PixelArea output_copy[] = new PixelArea[99999999];
  for (int x = 0; x<input.length; x++) {
    for (int y = 0; y<input[x].length; y++) {
      if (((red(input[x][y].value)+green(input[x][y].value)+blue(input[x][y].value))/3)>120) {
        output_copy[i] = input[x][y];
        i++;
      }
    }
  }
  if (i == 0) {
    i = 1;
  } 
  PixelArea output[] = new PixelArea[i];
  output[0] = new  PixelArea(0, 0, 0);
  for (int c = 0; c<i; c++) {
    output[c] = output_copy[c];
  }
  return output;
}


int Average(color Pixels[][], int scaledX, int scaledY) {
  float R = 0;  
  float G = 0;
  float B = 0;
  int i = 0;
  for (int x = scaledX*AreaWidth; x<(scaledX+1)*AreaWidth; x++) {
    for (int y = scaledY*AreaLen; y<(scaledY+1)*AreaLen; y++) {
      i++;
      R = R + red(Pixels[x][y]);
      G = G + green(Pixels[x][y]);
      B = B + blue(Pixels[x][y]);
    }
  }
  return color(R/i, G/i, B/i);
}

color[][] Pixels_OneD2TwoD(color input[]) {
  color output[][] = new color[640][480];
  for (int x = 0; x<640; x++) {
    for (int y = 0; y<480; y++) {
      int location = x + y*640;
      output[x][y] =input[location];
    }
  }
  return(output);
}
