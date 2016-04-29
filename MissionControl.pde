import processing.serial.*;


Serial serial;
String inputBuffer = "";
String outputBuffer = "";


float scaleFactor;
Vehicle vehicle;
PVector screenOffset;
boolean scrollOn;

ArrayList<Obstacle> obstacles;


void setup() {
  background(#333333);

  serial = new Serial(this, "/dev/tty.ElementSerial-ElementSe", 57600);
  serial.bufferUntil('\n');
  

  //fullScreen();
  size(800, 600);
  frameRate(30);
  pixelDensity(displayDensity());

  scaleFactor = 2.0;
  vehicle = new Vehicle(new PVector(width/4, height/4));
  screenOffset = new PVector(0, 0);
  obstacles = new ArrayList<Obstacle>();
}

void draw() {
  background(#333333);
  fill(255,255,255);
  textSize(24); 
  text(" >> " + inputBuffer, 10, 30);
  text(" << " + outputBuffer, 10, height - 20);

  noStroke();
  pushMatrix();

  if (scrollOn) {
    screenOffset.x = mouseX - width/2;
    screenOffset.y = mouseY - height/2;
  }
  translate(screenOffset.x, screenOffset.y);
  scale(scaleFactor);


  vehicle.render();

  for (int i = 0; i < obstacles.size(); i++) {
    obstacles.get(i).render();
  }

  popMatrix();
}

void keyTyped() {
  if (key == ENTER) {
    // enter pressed, execute command in buffer
    serial.write(inputBuffer + '\n');
    println(" >> " + inputBuffer);
    
    if (inputBuffer.indexOf("scan") >= 0) {
      vehicle.scanning = true;
    }

    // clear buffer
    inputBuffer = "";
  }
  else if (key == BACKSPACE) {
    if (inputBuffer.length() > 0) {
    inputBuffer = inputBuffer.substring(0, inputBuffer.length()-1);
    }
  }
  else if (key >= 32 && key <= 126)
  {
    inputBuffer += key;
  } 
}

void serialEvent(Serial p) { 
  String message = p.readString().trim();
  println(" << " + message);
  outputBuffer = message;

  String split[] = message.split(":");
  String type = split[0];
  String value = split[1];


  switch (type) {
  case "moved":
    vehicle.moveBy(Integer.parseInt(value)/10);
    break;

  case "rotated":
    vehicle.rotateBy(radians(Integer.parseInt(value)));
    break;

  case "scan":
    for (int i = 0; i < obstacles.size(); i++) {
      if (obstacles.get(i).age < 4) {
              obstacles.get(i).age++;
      }
    }
    vehicle.scanning = false;
    break;

  case "object":
    String objectParams[] = value.split(",");
    float radius = (Integer.parseInt(objectParams[1]) + Integer.parseInt(objectParams[3]))/2.0 + 12;
    float angle = radians((Integer.parseInt(objectParams[2]) + Integer.parseInt(objectParams[0]))/2.0);
    int diameter = Integer.parseInt(objectParams[4]);
    float x = radius * cos(-angle - HALF_PI + vehicle.getHeading());
    float y = radius * sin(-angle - HALF_PI + vehicle.getHeading());
    PVector pos = new PVector(x, y);
    pos = pos.add(vehicle.getPosition());
    obstacles.add(new Obstacle(pos, diameter, 0));
    break;
    
  case "emergency":
    int where = Integer.parseInt(value);
    int what = 0;
    angle = 0;
    switch(where) {
      case 1:
        // bumper left
        outputBuffer = "BUMPER LEFT";
        angle = 45;
        what = 1;
        break;
      case 2:
        // bumper right
        outputBuffer = "BUMPER RIGHT";
        angle = -45;
        what = 1;
        break;
      case 3:
        // line left
        outputBuffer = "LINE LEFT";
        angle = 60;
        what = 2;
        break;
      case 4:
        // line front-left
        outputBuffer = "LINE FRONT-LEFT";
        angle = 10;
        what = 2;
        break;
      case 5:
        // line front-right
        outputBuffer = "LINE FRONT-RIGHT";
        angle = -10;
        what = 2;
        break;
      case 6:
        // line right
        outputBuffer = "LINE RIGHT";
        angle = -60;
        what = 2;
        break;
      case 7:
        // cliff left
        outputBuffer = "CLIFF LEFT";
        angle = 60;
        what = 3;
        break;
      case 8:
        // cliff front-left
        outputBuffer = "CLIFF FRONT-LEFT";
        angle = 10;
        what = 3;
        break;
      case 9:
        // cliff front-right
        outputBuffer = "CLIFF FRONT-RIGHT";
        angle = -10;
        what = 3;
        break;
      case 10:
        // cliff right
        outputBuffer = "CLIFF RIGHT";
        angle = -60;
        what = 3;
        break;
        
      default:
        angle = 0;
        break;
    }
        
    angle = radians(-angle) - HALF_PI + vehicle.getHeading();
    pos = (new PVector(17*cos(angle), 17*sin(angle))).add(vehicle.getPosition());
    
    obstacles.add(new Obstacle(pos, 0, what));
  }
}

void mouseClicked() {
  scrollOn = !scrollOn;
}

void mouseWheel(MouseEvent event) {
  scaleFactor += event.getCount()/10.0;
}