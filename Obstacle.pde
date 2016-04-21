class Obstacle {
  PVector position;
  int size;
  
  Obstacle(PVector p, int s) {
    this.position = p;
    this.size = s;
  }
  
  void render() {
    pushMatrix();
    
    noStroke();
    if (this.size >= 0 && this.size < 6) {
      fill(red);
    }
    else if (this.size >= 6 && this.size < 12) {
      fill(green);
    }
    else if (this.size >= 12 && this.size < 18) {
      fill(blue);
    }
    else {
      fill(purple);
    }

    ellipse(this.position.x, this.position.y, this.size, this.size);
    
    popMatrix();
  }
 
  
  String toString() {
    return "[" + position + ", " + size + "]";
  }
  
  
  
}