//float deltaE(color compared, color source) {
//  float RC = 2;
//  float GC = 4;
//  float BC = 3;
//  colorMode(HSB, 360, 100, 100);
//  float comR = hue(compared);
//  float comG = saturation(compared);
//  float comB = brightness(compared);
//  float sourceR = hue(source);
//  float sourceG = saturation(source);
//  float sourceB = brightness(source);

//  colorMode(RGB, 255);
//  float diffR = 1x*abs(comR - sourceR);
//  float diffG = 0*abs(comG - sourceG);
//  float diffB = abs(comB - sourceB);
//  //+ abs(comB - sourceB)*BC
//  //println();
//  //if (source == #B5B3B3) {
//  //  if (abs(red(compared) - green(compared))<15 && abs(red(compared) - blue(compared))<15 && abs(green(compared) - blue(compared))<15) {
//  //    return(0);
//  //  } else {
//  //    return(999999);
//  //  }
//  //}
//  return diffR+diffG;
//  //if (source != src[5]) {
//  //return sqrt(RC*diffR+GC*diffG+BC*diffB);
//  //} else {
//  //  if (sqrt(diffR)<30&&sqrt(diffG)<30&&sqrt(diffB)<30) {
//  //    return 0;
//  //  } else {
//  //    return 99999;
//  //  }
//  //}
//}
