class Vehicle {
  PVector position;
  float heading;
  boolean scanning;

  Vehicle(PVector p) {
    this.position = p;
    this.heading = 0;
  }

  void render() {
    pushMatrix();

    // rotate around shape
    translate(this.position.x, this.position.y);
    rotate(this.heading);
    translate(-this.position.x, -this.position.y);

    // draw robot

    translate(this.position.x, this.position.y);



    if (scanning) {
      // draw radar range
      fill(0, 126, 255, 30);
      for (int i = 1; i < 5; i++) {
        arc(0, -12, i*40, i*40, PI, TWO_PI, CHORD);
      }
    }

    //stroke(yellow);
    fill(yellow);
    ellipse(0, 0, 35, 35);

    fill(#000000);
    pushMatrix();
    ellipse(0, -12, 8, 8);
    popMatrix();

    popMatrix();
  }

  void rotateBy(float by_angle) {
    this.heading += -by_angle;
  }

  void moveBy(int by) {
    this.position.y += -cos(this.heading)*by;
    this.position.x += sin(this.heading)*by;
  }

  PVector getPosition() {
    return this.position; 
  }
  
  float getHeading() {
    return this.heading;
  }
  
  String toString() {
    return "[" + position + "]";
  }
}