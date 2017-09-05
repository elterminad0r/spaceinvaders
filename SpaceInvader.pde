class SpaceInvader {
  Hitbox h;
  float x, y;
  boolean needed = true;

  SpaceInvader(float x, float y) {
    this.x = x;
    this.y = y;
    this.h = new Hitbox(x, y, inv_size, inv_size);
  }

  void destroy() {
    needed = false;
    deads.add(new DeadInvader(this.x, this.y));
  }

  void doframe() {
    float chx, chy;

    switch(inv_phase) {
      case 0:
        chx = inv_size;
        chy = 0;
        break;
      case 1:
      case 3:
        chx = 0;
        chy = inv_size;
        break;
      case 2:
        chx = -inv_size;
        chy = 0;
        break;
      default:
        chx = 0;
        chy = 0;
        break;
    }

    this.x += chx;
    this.y += chy;

    this.h.shift(chx, chy);
  }

  void drawinvader() {
    stroke(0);
    fill(255);
    rect(this.x, this.y, inv_size, inv_size);
    fill(0);
    ellipse(this.x + inv_size / 3.0, this.y + inv_size * 0.25,
            inv_size / 20.0, inv_size / 20.0);
    ellipse(this.x + inv_size * 2.0 / 3.0, this.y + inv_size * 0.25,
            inv_size / 20.0, inv_size / 20.0);
  }

}


