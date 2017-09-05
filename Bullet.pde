class Bullet {
  float x, y;
  boolean needed = true;

  Bullet(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void doframe() {
    this.y -= 5;

    if (this.y < 0) {
      this.needed = false;
    }

    for (SpaceInvader si: invaders) {
      if (si.h.collides(this.x, this.y)) {
        si.destroy();
        this.needed = false;
      }
    }
  }

  void drawbullet() {
    stroke(255);
    fill(255);
    ellipse(this.x, this.y, 5, 5);
  }
}
