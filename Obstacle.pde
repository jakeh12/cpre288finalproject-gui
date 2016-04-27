class Obstacle {
  PVector position;
  int size;
  int type;
  
  Obstacle(PVector p, int s, int t) {
    this.position = p;
    this.size = s;
    this.type = t;
  }
  
  void render() {
    pushMatrix();
    
    switch(this.type) {
      
    }
    noStroke();
    if (this.size >= 0 && this.size < 8) {
      fill(red);
    }
    else if (this.size >= 6 && this.size < 14) {
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