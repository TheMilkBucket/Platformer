//

class Enemy extends FBox {
  FBox[] sensors;
  FBox s;
  int frame, dir;
  float x_, y_, pixel_;
  ArrayList<FContact> contacts;
  boolean alive, dead, action;
  
  Enemy(float w, float h) {
    super(w, h);
    
    alive = true;
    dead = false;
    frame = 0;
    
    setDensity(0.2);
    setFriction(0);
    setRestitution(0);
    
    setGrabbable(false);
    setRotatable(false);
  }
  
  void update(Player player, FWorld world) {return;}
}

class Goomba extends Enemy {
  
  Goomba(float pixel, float x, float y) {
    super(1.2*pixel, 1.2*pixel);
    setPosition(x, y - 10);
    setVelocity(150, 0);
    
    setName("goomba");
    
    pixel_ = pixel;
    x_ = x;
    y_ = y;
    
    sensors = new FBox[3];
    sensors[0] = new_sensor(x, y - getHeight()/2, "top");
    sensors[1] = new_sensor(x - getWidth()/2, y, "left");
    sensors[2] = new_sensor(x + getWidth()/2, y, "right");
    
    dir = 1;
    
    attachImage(sprites.get(1)[frame]);
  }
  
  FBox new_sensor(float x, float y, String name) {
    if (name == "top") {
      s = new FBox(pixel_, 2);
    } else {
      s = new FBox(2, pixel_ - 4);
    }
    
    s.setPosition(x, y);
    s.setSensor(true);
    //s.setFillColor(color(0));
    s.setNoFill();
    s.setNoStroke();
    s.setName("gsensor");
    
    return s;
  }
  
  void update(Player player, FWorld world) {
    if (!alive) {
      setVelocity(0, 0);
      setSensor(true);
      frame = (frame + ((frameCount % 6 == 0)? 1: 0));
      attachImage((dir == 1)? reverseImage(sprites.get(1)[frame]): sprites.get(1)[frame]);
      if (frame == 8) {
        dead = true;
      }
      return;
    }
    
    frame = (frame + ((frameCount % 6 == 0)? 1: 0)) % 4; 
    attachImage((dir == 1)? reverseImage(sprites.get(1)[frame]): sprites.get(1)[frame]);
    
    setVelocity(dir*100, getVelocityY());
    
    contacts = sensors[2].getContacts();
    for (FContact contact: contacts) {
      if (contact.contains("sensor") && player.alive) {
        player.alive = false;
      }
      if (contact.contains("ground")) {
        dir = -dir;
        setPosition(getX() + dir * 10, getY());
        break;
      }
      
    }
    
    contacts = sensors[1].getContacts();
    for (FContact contact: contacts) {
      if (contact.contains("sensor") && player.alive) {
        player.alive = false;
      }
      if (contact.contains("ground")) {
        dir = -dir;
        setPosition(getX() + dir * 10, getY());
        break;
      } 
      
    }
    
    contacts = sensors[0].getContacts();
    for (FContact contact: contacts) {
      if (contact.contains("sensor") && player.alive) {
        alive = false;
        frame = 5;
      }
    }
    
    sensors[0].setPosition(getX(), getY() - getHeight()/2);
    sensors[1].setPosition(getX() - getWidth()/2, getY());
    sensors[2].setPosition(getX() + getWidth()/2, getY());
  }
}


class Thwomp extends Enemy {
  boolean blink;
  
  Thwomp (float pixel, float x, float y) {
    super(1.85*pixel, 1.85*pixel);
    setPosition(x + pixel/2, y + pixel/2);
    
    setStatic(true);
    
    setName("thwomp");  
    
    pixel_ = pixel;
    
    x_ = x + pixel/2;
    y_ = y + pixel/2;

    new_sensor(x, y + getHeight()/2);
    
    action = false;

    blink = false;
    
    attachImage(sprites.get(2)[frame]);
  }
  
  void new_sensor(float x, float y) {  
    s = new FBox((2 * pixel_) - 4, 2);
    s.setPosition(x, y);
    s.setSensor(true);
    //s.setFillColor(color(0));
    s.setNoFill();
    s.setNoStroke();
    s.setName("tsensor");
  }
  
  void update(Player player, FWorld world) {
    s.setPosition(x_, getY() + getHeight()/2);
    contacts = s.getContacts();
    
    if (action) {
      frame = min(8 + (frame + ((frameCount % 6 == 0)? 1: 0)), 12); 
      setPosition(x_, getY());
      for (FContact contact: contacts) {
        if (contact.contains("ground")) {
          action = false;
          alive = false;
          frame = 0;
        } 
        if (contact.contains("sensor")) {
          player.alive = false;
          frame = 0;
        }
      }
    } else if (!alive) {
      setStatic(true);
      frame = min(14 + (frame + ((frameCount % 20 == 0)? 1: 0)), 19); 
    } else {
      if (blink) {
        frame = (frame + ((frameCount % 6 == 0)? 1: 0));
        if (frame >= 7) blink = false;
      } else {
        frame = 0;
        if ((int)random(200) == 56) blink = true;
      }
      
      if (player.getX() >= getX() - getWidth() && player.getX() <= getX() + getWidth() && player.getY() >= getY()) {
        action = true;
        setStatic(false);
        frame = 0;
      }
    }
    
    attachImage(sprites.get(2)[frame]);
  }
}

class Archer extends Enemy {
  ArrayList<Arrow> arrows;
  
  Archer (float pixel, float x, float y, int d) {
    super(pixel, 1.75*pixel);
    setPosition(x, y - getHeight()/2);
    
    setStatic(true);
    
    setName("archer");
    
    pixel_ = pixel;
    
    x_ = x + pixel/2;
    y_ = y + pixel/2;
    
    dir = d;
   
    attachImage(sprites.get(3)[frame]);
    arrows = new ArrayList<Arrow>();
    
    setSensor(true);
  }
  
  void update(Player player, FWorld world) {
    if (frameCount % 300 == 0) action = true; 
    
    if (action) {
      frame = (frame + ((frameCount % 6 == 0)? 1: 0));
      if (frame >= 20) {
        action = false;
        frame = 0;
      }
    }
    
    if (dir == 1) attachImage(sprites.get(3)[frame]);
    else attachImage(reverseImage(sprites.get(3)[frame]));
    
    if (frame == 9 && frameCount % 6 == 1) {
      arrows.add(new Arrow (x_, y_, dir));
      world.add(arrows.get(arrows.size() - 1));
    }
    
    for (int i = 0; i < arrows.size(); ++i) {
      arrows.get(i).update();  
      if (arrows.get(i).despawn) {
        world.remove(arrows.get(i));
        arrows.remove(i);
        i--;
      }
    }
  }
}



class Dragon extends Enemy {
  ArrayList<Entity> attacks;
  int fire_dur, fire_cd, meteor_cd, health;
  boolean breath, meteor, damaged;
  ArrayList<FContact> contacts;
  
  Dragon (float pixel, float x, float y) {
    super(70, 70);
    setPosition(x + pixel, y + pixel);
    
    //setStatic(true);
    
    setName("dragon");  
    
    pixel_ = pixel;
    
    x_ = x;
    y_ = y;
    
    attachImage(sprites.get(4)[frame]);
    
    attacks = new ArrayList<Entity>();
    
    fire_cd = 0;
    fire_dur = 300;
    breath = false;
    meteor = false;
    damaged = false;
    health = 3*2;
  }

  void update(Player player, FWorld world) {
    for (int i = 0; i < attacks.size(); ++i) {
      attacks.get(i).update(player);  
      if (attacks.get(i).despawn) {
        world.remove(attacks.get(i));
        attacks.remove(i);
        i--;
      }
    }  
    
    if (damaged) {
      setPosition(x_, y_);
      setVelocity(0, 0);
      frame = (frame + ((frameCount % 8 == 0)? 1: 0));
      if (frame >= 16) {
        if (health <= 0) {
          dead = true;
        }
        damaged = false;
      }
      else attachImage(sprites.get(4)[frame]);
      return;
    }
    
    frame = (frame + ((frameCount % 8 == 0)? 1: 0))%8;
    
    attachImage(sprites.get(4)[frame]);
    
    if (player.getX() < getX() - 20) {
      setVelocity(-100, 0);
    } else if (player.getX() > getX() + 20) {
      setVelocity(100, 0);
    } else if (meteor) {
      attacks.add(new Meteor(getX(), getY()));
      world.add(attacks.get(attacks.size() - 1));
      meteor = false;
    } else if (fire_cd <= 0){
      breath = true;
    }
    
    if (breath && fire_dur > 0) {
      if (frameCount % 10 == 0) {
        attacks.add(new Fireball(getX(), getY()));
        world.add(attacks.get(attacks.size() - 1));
      }
      fire_dur--;
      fire_cd = 300;
    } else if (fire_dur <= 0) {
      breath = false;
      fire_dur = 300;
      if ((player.getX() < getX() - 100 || player.getX() > getX() + 100)) meteor = true;
    }
    
    if (!breath) fire_cd--;
    meteor_cd--;
    
    setPosition(getX(), y_);
    
    contacts = getContacts();
    for (FContact contact: contacts) {
      if (contact.contains("geyser")) {
        damaged = true;
        health--;
        println(health);
        fire_cd = 60;
        fire_dur = 300;
        breath = false;
        meteor = false;
        frame = 8;
        for (int i = 0; i < attacks.size(); ++i) {attacks.get(i).despawn = true;}  
      }
    }
  }
}
