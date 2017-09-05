/*
----> 0
    | 1
    v
<--- 2
|
v 3
*/

PFont f;

float inv_size;
int inv_phase;
int inv_speed;
int frametally;
boolean stijnMode;
boolean gameOver;

boolean[] keys;

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

ArrayList<SpaceInvader> invaders;
SpaceInvader control_right;
SpaceInvader control_left;

ArrayList<DeadInvader> deads;

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

ArrayList<Bullet> bullets;

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

Defence defence;

void spawnInvaders() {
  float xw = 2.1;
  float yw = 2.1;

  for (float i = width / 2.0 - inv_size * 3.1; 
       i < width / 2.0 + inv_size * xw; i += inv_size) {
    for (float j = 0; j < inv_size * yw; j += inv_size) {
      invaders.add(new SpaceInvader(i, j));
    }
  }

  control_right = new SpaceInvader(width / 2.0 + inv_size * xw, inv_size * yw);
  control_left = new SpaceInvader(width / 2.0 - inv_size * xw, inv_size * yw);
}

void setup() {
  size(1500, 800);

  //frameRate(15);

  inv_phase = 0;
  inv_size = 100;
  inv_speed = 20;
  
  stijnMode = false;
  
  gameOver = false;
  
  f = createFont("Arial", 16, true);

  frametally = 0;

  keys = new boolean[]{false, false, false};

  defence = new Defence(width / 2.0);

  bullets = new ArrayList<Bullet>();

  deads = new ArrayList<DeadInvader>();

  invaders = new ArrayList<SpaceInvader>();

  spawnInvaders();

  //invaders.add(new SpaceInvader(0, 0));
}

void keyPressed() {
  switch (keyCode) {
    case LEFT:
      keys[0] = true;
      break;
    case ' ':
      keys[1] = true;
      break;
    case RIGHT:
      keys[2] = true;
      break;
    case 'R':
      setup();
      break;
    case 'S':
      stijnMode = !stijnMode;
      break;
  }
}

void keyReleased() {
  switch (keyCode) {
    case LEFT:
      keys[0] = false;
      break;
    case ' ':
      keys[1] = false;
      break;
    case RIGHT:
      keys[2] = false;
      break;
  }
}

void draw() {
  if (!gameOver) {

    background(0);
    
    fill(255);
    textFont(f, 16);
    text("round " + String.valueOf(20 - inv_speed), 50, 50);

    //println(invaders.size(), deads.size(), bullets.size());

    if (frametally % inv_speed == 0) {
      if (inv_phase == 0) {
        if (control_right.x + inv_size > width) {
          inv_phase++;
        }
      } else if (inv_phase == 1 | inv_phase == 3) {
        inv_phase++;
        inv_phase %= 4;
      } else if (inv_phase == 2) {
        if (control_left.x - inv_size < 0) {
          inv_phase++;
        }
      }

      control_left.doframe();
      control_right.doframe();
      
      float lowest = 0;
      
      for (SpaceInvader si: invaders) {
        if (si.y > lowest) {
          lowest = si.y;
        }
      }

      if (lowest + inv_size > height) {
        gameOver = true;
      }

      for (SpaceInvader si: invaders) {
        si.doframe();
      }
    }

    defence.doframe();
    defence.drawdefence();

    for (int i = bullets.size() - 1; i >= 0; i--) {
      Bullet b = bullets.get(i);
      if (!b.needed) {
        bullets.remove(i);
      } else {
        b.doframe();
        b.drawbullet();
      }
    }

    for (int i = invaders.size() - 1; i >= 0; i--) {
      SpaceInvader si = invaders.get(i);
      if (!si.needed) {
        invaders.remove(i);
      } else {
        si.drawinvader();
      }
    }

    for (int i = deads.size() - 1; i >= 0; i--) {
      DeadInvader si = deads.get(i);
      if (!si.needed) {
        deads.remove(i);
      } else {
        si.doframe();
        si.drawinvader();
      }
    }

    if (invaders.size() == 0) {
      spawnInvaders();
      if (inv_speed > 1) {
        inv_speed--;
        inv_phase = 0;
      }
    }

    frametally++;

  } else {
    background(255, 0, 0);
  }

}