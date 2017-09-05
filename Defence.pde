class Defence {
  float x;

  Defence(float x) {
    this.x = x;
  }

  void move(float ch) {
    this.x += ch;
  }

  void shoot() {
    bullets.add(new Bullet(this.x, height));
  }

  void drawdefence() {
    stroke(255);
    fill(255);
    triangle(this.x - 10, height, this.x + 10, height, this.x, height - 20);
  }

  void doframe() {
    if (keys[0] & this.x > 0) {
      this.move(-10);
    } else if (keys[2] & this.x < width) {
      this.move(10);
    }

    if ((stijnMode | keys[1]) & frametally % 13 == 0) {
      this.shoot();
    }
  }
}


