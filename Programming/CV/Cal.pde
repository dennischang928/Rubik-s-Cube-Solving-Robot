boolean Draw_rect = false;

void calbration() {

  fill(0);
  textSize(50); 
  textAlign(CENTER, CENTER);
  ellipseMode(CENTER);
  text("Detect Calibration", width/2, 60);
  //translate(((width-640)/2), ((height-480)/2));
  println(mouseX);
  if (Released == true) {
    Draw_rect = false;
    Detectx[cal_counter] = mstartx-(width-640)/2;
    Detecty[cal_counter] = mstarty-(height-480)/2;
    Detectcornx[cal_counter] = mouseX-(width-640)/2;
    Detectcorny[cal_counter] = mouseY-(height-480)/2;
    cal_counter+=1;
  }

  if (mousePressed) {
    Draw_rect=true;
    fill(0);
    noStroke();
    rectMode(CORNER);
    rect(mstartx, mstarty, mouseX-mstartx, mouseY-mstarty);
  }
  for (int i = 0; i<cal_counter; i++) {
    rect(Detectx[i]+(width-640)/2, Detecty[i]+(height-480)/2, Detectcornx[i]-Detectx[i], Detectcorny[i]-Detecty[i]);
  }

  if (cal_counter==9) {
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
  }
}
