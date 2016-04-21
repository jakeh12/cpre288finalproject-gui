import processing.serial.*;

Serial serial;
String inputBuffer = "";

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

    if (inputBuffer.indexOf("scan:0") >= 0) {
      vehicle.scanning = true;
    }

    // clear buffer
    inputBuffer = "";
  } else if (key >= 32 && key <= 126)
  {
    inputBuffer += key;
  }
}

void serialEvent(Serial p) { 
  String message = p.readString().trim();
  println(" << " + message);

  String split[] = message.split(":");
  String type = split[0];
  String value = split[1];

  //println("type: " + type + ", value: " + value);

  switch (type) {
  case "moved":
    vehicle.moveBy(Integer.parseInt(value)/10);
        println("vehicle position: " + vehicle.getPosition());

    break;

  case "rotated":
    vehicle.rotateBy(radians(Integer.parseInt(value)));
    break;

  case "scan":
    vehicle.scanning = false;
    break;

  case "object":
    String objectParams[] = value.split(",");
    printArray(objectParams);
    float radius = (Integer.parseInt(objectParams[1]) + Integer.parseInt(objectParams[3]))/2.0 + 12;
    float angle = -radians((Integer.parseInt(objectParams[2]) - Integer.parseInt(objectParams[0]))/2.0) - HALF_PI + vehicle.getHeading();
    int diameter = Integer.parseInt(objectParams[4]);
    float x = radius * cos(angle);
    float y = radius * sin(angle);
    
    PVector pos = new PVector(x, y);
    pos = pos.add(vehicle.getPosition());
    println("vehicle position: " + vehicle.getPosition());
    
    println("radius: " + radius + ", angle" + angle);
    
    obstacles.add(new Obstacle(pos, diameter));
    break;
  }
}

void mouseClicked() {
  scrollOn = !scrollOn;
}

void mouseWheel(MouseEvent event) {
  scaleFactor += event.getCount()/10.0;
}