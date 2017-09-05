class DeadInvader {
  float x, y; 
  float ex_s = 0;
  boolean needed = true;

  DeadInvader(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void doframe() {
    ex_s += 5;
    if (ex_s > inv_size * 3) {
      needed = false;
    }
  }

  void drawinvader() {
    stroke(255, 0, 0, 255 - ex_s * 255.0 / (inv_size * 3));
    fill(255, 0, 0, 255 - ex_s * 255.0 / (inv_size * 3));

    ellipse(this.x + inv_size / 2.0, this.y + inv_size / 2.0, ex_s, ex_s);
  }
}


