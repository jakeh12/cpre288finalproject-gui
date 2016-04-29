class Obstacle {
  PVector position;
  int size;
  int type;
  int age;
  
  Obstacle(PVector p, int s, int t) {
    this.position = p;
    this.size = s;
    this.type = t;
    this.age = 0;
  }
  
  void render() {
    switch(this.type) {
      case 0:
        drawPipe();
        break;
      case 1:
        drawCollision();
        break;
      case 2:
        drawLine();
        break;
      case 3:
        drawCliff();
        break;
        
      default:
        break;
    }
    
  }
    
  void drawPipe() {
    pushMatrix();
    noStroke();
    if (this.size >= 0 && this.size < 8) {
      fill(colorWithAlpha(red, (255 - this.age * 51)));
    }
    else if (this.size >= 6 && this.size < 14) {
      fill(colorWithAlpha(green, (255 - this.age * 51)));
    }
    else if (this.size >= 12 && this.size < 18) {
      fill(colorWithAlpha(blue, (255 - this.age * 51)));
    }
    else {
      fill(colorWithAlpha(purple, (255 - this.age * 51)));
    }
    
    ellipse(this.position.x, this.position.y, this.size, this.size);
    popMatrix();
  }
  
  void drawLine() {
    drawX(colorWithAlpha(line_color, (255 - this.age * 51)));
  }
  
  void drawCliff() {
    drawX(colorWithAlpha(cliff_color, (255 - this.age * 51))); 
  }
  
  void drawCollision() {
    drawX(colorWithAlpha(collision_color, (255 - this.age * 51)));
  }
  
  void drawX(color c) {
    pushMatrix();
    stroke(c);
    line(this.position.x-5, this.position.y-5, this.position.x+5, this.position.y+5);
    line(this.position.x-5, this.position.y+5, this.position.x+5, this.position.y-5);
    popMatrix();
  }
  
  color colorWithAlpha(color colour, int alpha) {
    return (colour & 0xffffff) | (alpha << 24);
  }
  
  String toString() {
    return "[" + position + ", " + size + "]";
  }
 
}