#include <Arduino.h>
#include <Servo.h>
#include "BasicStepperDriver.h".
#include "MultiDriver.h"
#include "SyncDriver.h"
#define MICROSTEPS 16
#define MOTOR_STEPS 200
BasicStepperDriver stepper1(MOTOR_STEPS, 2, 3);
BasicStepperDriver stepper2(MOTOR_STEPS, 4, 5);
BasicStepperDriver stepper3(MOTOR_STEPS, 6, 7);
BasicStepperDriver stepper4(MOTOR_STEPS, 8, 9);

SyncDriver stepper1_3(stepper1, stepper3);
SyncDriver stepper2_4(stepper2, stepper4);

//----------------------------------Classes----------------------------------

char input = ' ';
String Sinput = "";
int encoder_value[4];
boolean finishhome = false;
boolean DEBUG = false;
char index[6] = {'L', 'B', 'R', 'F', 'U', 'D'};
struct Send
{
  int en_cen_value[4] = {
      289,
      374,
      351,
      422,
  };
};

Send setting;
int servoPin[4] = {10, 11, 12, 13};
byte encoderPin[4] = {A5, A4, A0, A1};
int NEIGHBOR[4][2] = {{1, 3}, {2, 0}, {3, 1}, {0, 2}};

Servo servo[4];

void setup()
{
  Serial.begin(115200);
  for (int x = 0; x < 2; x++)
  {
    for (int i = 0; i < 4; i++)
    {
      pinMode(encoderPin[i], INPUT);
      servo[i].attach(servoPin[i]);
      servo[i].write(88);
    }
  }

  stepper1.begin(100, MICROSTEPS);
  stepper2.begin(100, MICROSTEPS);
  stepper3.begin(100, MICROSTEPS);
  stepper4.begin(100, MICROSTEPS);
  stepper1_3.setMicrostep(16);
  stepper2_4.setMicrostep(16);
}

class Steppers
{
public:
  int Center[4] = {0, 0, 0, 0};
  int posit[4] = {0, 0, 0, 0};
  int pos[4] = {0, 0, 0, 0};

  void Set_CTR(int index, int CTR)
  {
    Center[index] = CTR;
  }
  void reset_pos()
  {
    for (int i = 0; i < 4; i++)
    {
      if (posit[i] >= 3200)
      {
        posit[i] = 0;
      }
      if (posit[i] < 0)
      {
        posit[i] = 3199;
      }
    }
  }
  bool Move(int index, int rotate)
  {

    if (index == 0 || index == 2)
    {
      switch (rotate)
      {
      case 0:

        if (index == 0)
        {
          stepper1_3.move(1, 0);
        }
        else
        {
          stepper1_3.move(0, 1);
        }

        posit[index]++;
        pos[index]++;
        reset_pos();
        if (pos[index] >= 800)
        {
          pos[index] = 0;
          return (true);
          Serial.println("dsfafdfas");
        };
        return (false);

        break;

      case 1:
        if (index == 0)
        {
          stepper1_3.move(-1, 0);
        }
        else
        {
          stepper1_3.move(0, -1);
        }

        posit[index]--;
        pos[index]--;
        reset_pos();
        if (pos[index] <= -800)
        {
          pos[index] = 0;
          return (true);
          Serial.println("0102929929");
        };
        return (false);

        break;
      case 2:
        if (index == 0)
        {
          stepper1_3.move(1, 0);
        }
        else
        {
          stepper1_3.move(0, 1);
        }

        posit[index]++;
        pos[index]++;
        reset_pos();
        if (pos[index] >= 1600)
        {
          pos[index] = 0;
          return (true);
        };
        return (false);
        break;
      }
    }
    else if (index == 1 || index == 3)
    {

      switch (rotate)
      {
      case 0:

        if (index == 1)
        {
          stepper2_4.move(1, 0);
        }
        else
        {
          stepper2_4.move(0, 1);
        }

        posit[index]++;
        pos[index]++;
        reset_pos();
        if (pos[index] >= 800)
        {
          pos[index] = 0;
          return (true);
          Serial.println("dsfafdfas");
        };
        return (false);

        break;

      case 1:
        if (index == 1)
        {
          stepper2_4.move(-1, 0);
        }
        else
        {
          stepper2_4.move(0, -1);
        }

        posit[index]--;
        pos[index]--;
        reset_pos();
        if (pos[index] <= -800)
        {
          pos[index] = 0;
          return (true);
        };
        return (false);

        break;
      case 2:

        if (index == 1)
        {
          stepper2_4.move(1, 0);
        }
        else
        {
          stepper2_4.move(0, 1);
        }

        posit[index]++;
        pos[index]++;
        reset_pos();
        if (pos[index] >= 1600)
        {
          pos[index] = 0;
          return (true);
        };
        return (false);

        break;
      }
      return (false);
    }
  }

  bool Rot(int index, int angle)
  {

    if (index == 0 || index == 2)
    {
      int Way;
      if ((angle - posit[index]) > (posit[index] - angle))
      {
        Way = 1;
      }
      else
      {
        Way = -1;
      }
      if (index == 0)
      {
        stepper1_3.move(Way, 0);
      }
      else
      {
        stepper1_3.move(0, Way);
      }

      posit[index] = posit[index] + Way;

      if (posit[index] == angle)
      {
        reset_pos();
        return (true);
      };
      reset_pos();
      return (false);
    }
    else if (index == 1 || index == 3)
    {
      int Way = 0;
      if ((angle - posit[index]) > (posit[index] - angle))
      {
        Way = 1;
      }
      else
      {
        Way = -1;
      }
      if (index == 1)
      {
        stepper2_4.move(Way, 0);
      }
      else
      {
        stepper2_4.move(0, Way);
      }

      posit[index] = posit[index] + Way;
      if (posit[index] == angle)
      {
        reset_pos();
        return (true);
      };
      reset_pos();
      return (false);
    }
  }
};

Steppers steppers;

void loop()
{
  if (Serial.available() > 0)
  {
    Sinput = Serial.readStringUntil('/n');
    input = Sinput.charAt(0);
  }

  if (input == 'C' || input == 'c')
  {
    calbration(encoder_value);
    input = NULL;
  }
  else if (input == 'H' || input == 'h')
  {
    boolean homing[4];
    for (int i = 0; i < 4; i++)
    {
      homing[i] = center(i);
    }

    int x = 0;
    for (int i = 0; i < 4; i++)
    {
      if (homing[i] = true)
      {
        x++;
      }
    }
    if (x == 4)
    {
      for (int i = 0; i < 4; i++)
      {
        servo[i].write(10);
      }
      delay(7000);
      for (int i = 0; i < 4; i++)
      {
        servo[i].write(88);
      }
      input = ' ';
    }
  }
  else if (input == 'G')
  {

    String Rot_Notation = "";
    Rot_Notation = (Sinput.substring(2));
    int NumberOfNotations = Find_Num_Items(Rot_Notation, ' ');
    String Notation[NumberOfNotations];
    for (int i = 0; i < NumberOfNotations; i++)
    {
      Notation[i] = (getValue(Rot_Notation, ' ', i));
      char Face = Notation[i].charAt(0);
      int Way = 0;
      if (Notation[i].charAt(1) == '\u0027')
      {
        Way = 0;
      }
      else if (Notation[i].charAt(1) == '2')
      {
        Way = 2;
      }
      else
      {
        Way = 1;
      }
      rotation(Face, Way);
      delay(500);
    }
    input = ' ';
    delay(200);
    Serial.write("Fin");
  }
  else if (input == 'T')
  {
    char Face = ' ';
    Face = (Sinput.charAt(2));
    Turn_FaceUp(Face);
    input = ' ';
    Serial.write("Fin");
  }
  else if (input == 'D')
  {
    char Clip = ' ';
    Clip = (Sinput.charAt(2));
    Clip_Open(Clip);
    delay(300 );
    Serial.write("Fin");
    input = ' ';
  }
  else if (input == 'E')
  {
    char Clip = ' ';
    Clip = (Sinput.charAt(2));
    Clip_Close(Clip);
    delay(100);
    Serial.write("Fin");
    input = ' ';
  }
  else if (input == 'R')
  {
    resetIndex();
    input = ' ';
  }
  else if (input == 'F')
  {
    if (Sinput.length() == 4)
    {
      ROT_XYZ(String(Sinput.charAt(2)));
    }
    else
    {
      ROT_XYZ(String(Sinput.charAt(2)) + "'");
    }
    delay(350);
    Serial.write("fin");
    input = ' ';
  }
  if (DEBUG == true)
  {
    for (int i = 0; i < 4; i++)
    {
      encoder_value[i] = analogRead(encoderPin[i]);
      Serial.print(encoder_value[i]);
      Serial.print(",");
    }
    Serial.println("");

    Serial.println("");
  }
}

void Clip_Open(char X_OR_Y)
{
  if (X_OR_Y == 'X')
  {
    servoMove(2, false);
    servoMove(0, false);
  }
  else if (X_OR_Y == 'Y')
  {
    servoMove(1, false);
    servoMove(3, false);
  }
}
void Clip_Close(char X_OR_Y)
{
  if (X_OR_Y == 'X')
  {
    servoMove(2, true);
    servoMove(0, true);
  }
  else if (X_OR_Y == 'Y')
  {
    servoMove(1, true);
    servoMove(3, true);
  }
}
void rotation(char face, int ways)
{
  for (int i = 0; i < 6; i++)
  {
    if (index[i] == face)
    {
      if (i == 4 || i == 5)
      {
        if (i == 4)
        {
          for (int x = 0; x < 2; x++)
          {
            if (steppers.posit[NEIGHBOR[0][x]] == 0 || steppers.posit[NEIGHBOR[0][x]] == 1600)
            {
            }
            else
            {
              returnCTR(NEIGHBOR[0][x]);
            }
          }

          for (int x = 0; x < 2; x++)
          {
            if (steppers.posit[NEIGHBOR[1][x]] == 800 || steppers.posit[NEIGHBOR[1][x]] == 2400)
            {
            }
            else
            {
              To_angle(NEIGHBOR[1][x], 800);
            }
          }

          delay(300);
          servoMove(1, false);
          servoMove(3, false);
          delay(200);
          boolean finish = false;
          while (finish == false)
          {
            boolean fin_1 = false;
            boolean fin_2 = false;
            fin_1 = (steppers.Move(0, 0));
            fin_2 = (steppers.Move(2, 1));
            finish = fin_1 && fin_2;
          }

          servoMove(1, true);
          servoMove(3, true);
          delay(300);
          boolean fin_1 = false;
          while (fin_1 == false)
          {
            fin_1 = (steppers.Move(1, ways));
          }
          char index_cp[6];
          for (int i = 0; i < 6; i++)
          {
            index_cp[i] = index[i];
          }
          index[1] = index_cp[4];
          index[4] = index_cp[3];
          index[3] = index_cp[5];
          index[5] = index_cp[1];
        }
        else
        {
          for (int x = 0; x < 2; x++)
          {
            if (steppers.posit[NEIGHBOR[0][x]] == 0 || steppers.posit[NEIGHBOR[0][x]] == 1600)
            {
            }
            else
            {
              returnCTR(NEIGHBOR[0][x]);
            }
          }
          for (int x = 0; x < 2; x++)
          {
            if (steppers.posit[NEIGHBOR[1][x]] == 800 || steppers.posit[NEIGHBOR[1][x]] == 2400)
            {
            }
            else
            {
              To_angle(NEIGHBOR[1][x], 800);
            }
          }

          delay(300);
          servoMove(1, false);
          servoMove(3, false);
          delay(300);
          boolean finish = false;
          while (finish == false)
          {
            boolean fin_1 = false;
            boolean fin_2 = false;
            fin_1 = (steppers.Move(0, 1));
            fin_2 = (steppers.Move(2, 0));
            finish = fin_1 && fin_2;
          }

          servoMove(1, true);
          servoMove(3, true);
          delay(300);
          boolean fin_1 = false;
          while (fin_1 == false)
          {
            fin_1 = (steppers.Move(1, ways));
          }
          char index_cp[6];
          for (int i = 0; i < 6; i++)
          {
            index_cp[i] = index[i];
          }
          index[1] = index_cp[5];
          index[3] = index_cp[4];
          index[4] = index_cp[1];
          index[5] = index_cp[3];
        }
      }
      else
      {
        for (int x = 0; x < 2; x++)
        {
          if (steppers.posit[NEIGHBOR[i][x]] == 0 || steppers.posit[NEIGHBOR[i][x]] == 1600)
          {
          }
          else
          {
            returnCTR(NEIGHBOR[i][x]);
          }
        }
        boolean fin = false;
        delay(300);
        while (fin == false)
        {
          fin = steppers.Move(i, ways);
        }
      }
    }
  }
  delay(300);
}

void calbration(int env[4])
{
  for (int i = 0; i < 4; i++)
  {
    setting.en_cen_value[i] = env[i];
  }
}

void returnCTR(int index)
{
  servoMove(index, false);
  delay(100);
  boolean fin_1 = false;
  if (abs(1600 - steppers.posit[index]) < steppers.posit[index])
  {
    while (fin_1 == false)
    {
      fin_1 = (steppers.Rot(index, 1600));
    }
  }
  else
  {
    while (fin_1 == false)
    {
      fin_1 = (steppers.Rot(index, 0));
    }
  }
  servoMove(index, true);
  delay(300);
}

void servoMove(int index, bool EN)
{
  if (EN == true)
  {
    servo[index].write(87);
  }
  else if (EN == false)
  {
    servo[index].write(20);
  }
}

void To_angle(int index, int angle)
{
  servoMove(index, false);
  delay(100);
  boolean fin_1 = false;
  if (angle == 800)
  {
    if (abs(2400 - steppers.posit[index]) < abs(800 - steppers.posit[index]))
    {

      while (fin_1 == false)
      {
        fin_1 = (steppers.Rot(index, 2400));
      }
    }
    else
    {
      while (fin_1 == false)
      {
        fin_1 = (steppers.Rot(index, 800));
      }
    }
  }
  else
  {
    while (fin_1 == false)
    {
      fin_1 = (steppers.Rot(index, angle));
    }
  }
  servoMove(index, true);
  delay(300);
}

void Turn_FaceUp(char Face)
{
  int OPPOSTIE[4][2] = {{0, 2}, {1, 3}, {2, 0}, {3, 1}};
  for (int i = 0; i < 4; i++)
  {
    if (index[i] == Face)
    {
      for (int x = 0; x < 2; x++)
      {
        if (steppers.posit[OPPOSTIE[i][x]] == 0 || steppers.posit[OPPOSTIE[i][x]] == 1600)
        {
        }
        else
        {
          returnCTR(OPPOSTIE[i][x]);
        }
      }
      for (int x = 0; x < 2; x++)
      {
        if (steppers.posit[NEIGHBOR[i][x]] == 800 || steppers.posit[NEIGHBOR[i][x]] == 2400)
        {
        }
        else
        {
          To_angle(NEIGHBOR[i][x], 800);
        }
      }

      delay(300);
      servoMove(OPPOSTIE[i][0], false);
      servoMove(OPPOSTIE[i][1], false);
      delay(100);
      boolean finish = false;
      int LeftM_rotation = 0;
      int RightM_rotation = 0;
      while (finish == false)
      {

        for (int x = 0; x < 2; x++)
        {
          if (NEIGHBOR[NEIGHBOR[i][0]][x] == i)
          {

            LeftM_rotation = (x == 0) ? 1 : 0;
          }
          if (NEIGHBOR[NEIGHBOR[i][1]][x] == i)
          {
            RightM_rotation = (x == 0) ? 1 : 0;
          }
        }
        boolean fin_1 = false;
        boolean fin_2 = false;
        fin_1 = (steppers.Move(NEIGHBOR[i][0], LeftM_rotation));
        fin_2 = (steppers.Move(NEIGHBOR[i][1], RightM_rotation));
        finish = fin_1 && fin_2;
      }
      servoMove(OPPOSTIE[i][0], true);
      servoMove(OPPOSTIE[i][1], true);
      char index_cp[6];
      for (int i = 0; i < 6; i++)
      {
        index_cp[i] = index[i];
      }
      switch (i)
      {
      case 0:
        index[4] = index_cp[0];
        index[0] = index_cp[5];
        index[5] = index_cp[2];
        index[2] = index_cp[4];
        break;
      case 1:
        index[4] = index_cp[1];
        index[1] = index_cp[5];
        index[5] = index_cp[3];
        index[3] = index_cp[4];
        break;
      case 2:
        index[4] = index_cp[2];
        index[2] = index_cp[5];
        index[5] = index_cp[0];
        index[0] = index_cp[4];
        break;
      case 3:
        index[4] = index_cp[3];
        index[3] = index_cp[5];
        index[5] = index_cp[1];
        index[1] = index_cp[4];
        break;
      }
    }
  }
}
int Find_Num_Items(String data, char separator)
{
  int found = 0;
  int maxIndex = data.length() - 1;

  for (int i = 0; i <= maxIndex && found <= index; i++)
  {
    if (data.charAt(i) == separator || i == maxIndex)
    {
      found++;
    }
  }
  return found;
}

String getValue(String data, char separator, int index)
{
  int found = 0;
  int strIndex[] = {0, -1};
  int maxIndex = data.length() - 1;

  for (int i = 0; i <= maxIndex && found <= index; i++)
  {
    if (data.charAt(i) == separator || i == maxIndex)
    {
      found++;
      strIndex[0] = strIndex[1] + 1;
      strIndex[1] = (i == maxIndex) ? i + 1 : i;
    }
  }

  return found > index ? data.substring(strIndex[0], strIndex[1]) : "";
}

boolean center(int module)
{
  int encoder_angle = 0;
  if (module == 0)
  {
    boolean Homed = false;
    for (int i = 0; i < 4; i++)
    {
      servo[i].write(88);
    }
    servo[module].write(40);
    for (int i = 0; i < 3200; i += 1)
    {
      if (Homed == false)
      {
        stepper1_3.move(i, 0);
      }
      encoder_angle = analogRead(encoderPin[module]);
      if (abs(setting.en_cen_value[module] - encoder_angle) < 10)
      {
        Homed = true;
        return (true);
      }
      else
      {
      }
    }
  }
  if (module == 1)
  {
    boolean Homed = false;
    for (int i = 0; i < 4; i++)
    {
      servo[i].write(88);
    }
    servo[module].write(20);
    for (int i = 0; i < 3200; i += 1)
    {
      if (Homed == false)
      {
        stepper2_4.move(i, 0);
      }
      encoder_angle = analogRead(encoderPin[module]);
      if (abs(setting.en_cen_value[module] - encoder_angle) < 10)
      {
        Homed = true;
        return (true);
      }
      else
      {
      }
    }
  }
  if (module == 2)
  {
    boolean Homed = false;
    for (int i = 0; i < 4; i++)
    {
      servo[i].write(88);
    }
    servo[module].write(20);
    for (int i = 0; i < 3200; i++)
    {
      if (Homed == false)
      {
        stepper1_3.move(0, (i));
      }
      encoder_angle = analogRead(encoderPin[module]);
      (300);
      if (abs(setting.en_cen_value[module] - encoder_angle) < 10)
      {
        Homed = true;
        return (true);
      }
      else
      {
      }
    }
  }
  if (module == 3)
  {
    boolean Homed = false;
    for (int i = 0; i < 4; i++)
    {
      servo[i].write(88);
    }
    servo[module].write(20);
    for (int i = 0; i < 3200; i++)
    {
      if (Homed == false)
      {
        stepper2_4.move(0, (i));
      }
      encoder_angle = analogRead(encoderPin[module]);
      if (abs(setting.en_cen_value[module] - encoder_angle) < 10)
      {
        Homed = true;
        return (true);
      }
      else
      {
      }
    }
  }
}


void resetIndex()
{
  char RefactorIndex[6] = {'L', 'B', 'R', 'F', 'U', 'D'};
  for (int x = 0; x < 6; x++)
  {
    index[x] = RefactorIndex[x];
  } 
}

void ROT_XYZ(String ways)
{
  resetIndex();
  if (ways.length() == 1)
  {
    switch (ways.charAt(0))
    {
    case 'X':
      Turn_FaceUp('L');
      break;
    case 'Y':
      Turn_FaceUp('F');
      break;
    case 'Z':
      Turn_FaceUp('F');
      Turn_FaceUp('L');
      Turn_FaceUp('U');
      break;
    }
  }
  else
  {
    switch (ways.charAt(0))
    {
    case 'X':
      Turn_FaceUp('R');
      break;
    case 'Y':
      Turn_FaceUp('B');
      break;
    case 'Z':
      Turn_FaceUp('F');
      Turn_FaceUp('R');
      Turn_FaceUp('U');
      break;
    }
  }
  resetIndex();
}
