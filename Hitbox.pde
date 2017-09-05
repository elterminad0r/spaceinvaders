class Hitbox {
  float x, y, w, h;

  Hitbox(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void shift(float chx, float chy) {
    this.x += chx;
    this.y += chy;
  }

  boolean collides(float x, float y) {
    return x > this.x & x < this.x + w & y > this.y & y < this.y + h;
  }
}


