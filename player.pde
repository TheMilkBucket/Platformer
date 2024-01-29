class Player extends FBox {
  boolean[] varr_;
  ArrayList<FContact> contacts, scontacts;
  //int cd, max_cd;
  FBox[] sensors;
  FBox s;
  String fluid, block;
  boolean text, submerged, direction, jumpboost, alive;
  float pixel_, x_, y_;
  int frame, breath, crispy;
  
  Player(float pixel, float x, float y) {
    super(1*pixel, 1.75*pixel);
    setPosition(x, y);
    
    setDensity(0.2);
    setFriction(1);
    setRestitution(0.2);
    
    setGrabbable(false);
    setRotatable(false);
    
    setName("player");
    
    pixel_ = pixel;
    
    x_ = x;
    y_ = y;
    
    breath = 600;
    crispy = 0;
    
    varr_ = new boolean[] {false, false, false};
    
    sensors = new FBox[6];
    sensors[0] = new_sensor(x, y - getHeight()/2, "top");
    sensors[1] = new_sensor(x + getWidth()/2, y - getHeight()/4, "ltop");
    sensors[2] = new_sensor(x, y + getHeight()/2, "bot");
    sensors[3] = new_sensor(x - getWidth()/2, y - getHeight()/4, "ltop");
    sensors[4] = new_sensor(x + getWidth()/2, y + getHeight()/4, "rbot");
    sensors[5] = new_sensor(x - getWidth()/2, y + getHeight()/4, "lbot");
    
    fluid = "air";
    submerged = false;
    jumpboost = false;
    
    frame = 0;
    attachImage(sprites.get(0)[frame]);
    direction = true;
    
    alive = true;
  }
  
  FBox new_sensor(float x, float y, String name) {
    if (name == "top" || name == "bot") {
      s = new FBox(pixel_ - 4, 2);
    } else if (name.charAt(1) == 't') {
      s = new FBox(2, getHeight() - pixel_ - 2);
    } else if (name.charAt(1) == 'b') {
      s = new FBox(2, pixel_ - 4);
    }
    
    s.setPosition(x, y);
    s.setSensor(true);
    //s.setFillColor(color(0));
    s.setNoFill();
    s.setNoStroke();
    setName("sensor");
    
    return s;
  }
  
  void update() { 
    update_sensors();
    
    if (!alive) {
      if (frame < 14) frame = 14;
      setVelocity(0, 0);
      setSensor(true);
      
      attachImage(sprites.get(0)[frame]);
      frame = (frame + ((frameCount % 10 == 0)? 1: 0)); 
      if (frame >= 17) {
        alive = true;
        setPosition(x_, y_);
        setSensor(false);
      }
      return;
    }  
    
    if (varr_[1]) {
      setVelocity(200, getVelocityY());
      frame = ((frame + ((frameCount % 2 == 0)? 1: 0)) % 8); 
      direction = true;
      attachImage(sprites.get(0)[frame + 3]);
    }
    if (varr_[2]) {
      setVelocity(-200, getVelocityY());
      frame = ((frame + ((frameCount % 2 == 0)? 1: 0)) % 8);
      direction = false;
      attachImage(reverseImage(sprites.get(0)[frame + 3]));
    }
    
    if (!varr_[1] && !varr_[2]) {
      frame = (frame + ((frameCount % 10 == 0)? 1: 0)) % 4;
      attachImage(direction? sprites.get(0)[frame]: reverseImage(sprites.get(0)[frame]));
      if (block != "ice") setVelocity(max(getVelocityX()/2, 0), getVelocityY());
    }
    
    if (varr_[0]) { 
      if (fluid == "water") {
        if (sensor_touching(4, "water") || sensor_touching(5, "water")) setVelocity(getVelocityX(), -150);
      } else if (fluid == "lava") {
        if (sensor_touching(2, "lava")) setVelocity(getVelocityX(), -200);
      } else if (fluid == "air") {
        if (block == "ground" || block == "ice") setVelocity(getVelocityX(), (jumpboost)? -1000: -250);
      } 
    }
    
    detect_terrain();
    
    
  }
  
  void update_sensors() {
    sensors[0].setPosition(getX(), getY() - getHeight()/2);
    sensors[1].setPosition(getX() + getWidth()/2, getY() - getHeight()/4);
    sensors[2].setPosition(getX(), getY() + getHeight()/2);
    sensors[3].setPosition(getX() - getWidth()/2, getY() - getHeight()/4);
    sensors[4].setPosition(getX() + getWidth()/2, getY() + getHeight()/4);
    sensors[5].setPosition(getX() - getWidth()/2, getY() + getHeight()/4);
  }
  
  boolean sensor_touching(int i, String block) {
    scontacts = sensors[i].getContacts();
    for (FContact scontact: scontacts) {
      if (scontact.contains(block)) return true;
    }
    return false;
  }
  
  void detect_terrain() {
    block = "";
    fluid = "air";
    submerged = false;
    
    if (sensor_touching(2, "ground") || sensor_touching(2, "firebox") || sensor_touching(2, "thwomp") || sensor_touching(2, "meteor")) block = "ground";
    else if (sensor_touching(2, "ice")) block = "ice";
    
    if (sensor_touching(0, "water")) {
      submerged = true;
      if (!water_rune) breath--;
      if (breath <= 0) {
        alive = false;
        frame = 14;
        return;
      }
    }
    
    jumpboost = false;
    text = false;
    contacts = getContacts();
    for (FContact contact: contacts) {
      if (contact.contains("spikes")) {
        alive = false; 
        frame = 14;
        return;
      } else if (contact.contains("arrow")) {
        alive = false;
        frame = 14;
        return;
      } else if (contact.contains("fire")) {
        alive = false;
        frame = 14;
        return;
      } else if (contact.contains("fireball")) {
        alive = false;
        frame = 14;
        return;
      }
      
      if (contact.contains("jumpboost")) jumpboost = true;
      if (contact.contains("sign")) text = true;
      else if (contact.contains("door")) { 
        if (!has_key) text = true;
        else {
          has_key = false;
          cutscene = true;
        }
      }
      
      if (contact.contains("water")) fluid = "water";
      else if (contact.contains("lava")) {
        fluid = "lava";
        if (!lava_rune) crispy++;
        if (crispy >= 100) {
          alive = false;
          frame = 14;
          return;
        }
      }
      
      if (contact.getBody1().getName() == "falling_bridge") {
        contact.getBody1().setStatic(false);
        contact.getBody1().setSensor(true);
      } else if (contact.getBody2().getName() == "falling_bridge") {
        contact.getBody2().setStatic(false);
        contact.getBody2().setSensor(true);
      } else if (contact.getBody1().getName() == "breakable" && rock_rune) {
        contact.getBody1().setSensor(true);
        contact.getBody1().attachImage(tiles[0]);  
      } else if (contact.getBody2().getName() == "breakable" && rock_rune) {
        contact.getBody2().setSensor(true);
        contact.getBody2().attachImage(tiles[0]);  
      }
      
      if (contact.getBody1().getName() == "bluerune") {
        contact.getBody1().attachImage(runes[0]);
        water_rune = true;
      } else if (contact.getBody2().getName() == "bluerune") {
        contact.getBody2().attachImage(runes[0]);
        water_rune = true;
      } else if (contact.getBody1().getName() == "lavarune") {
        contact.getBody1().attachImage(runes[0]);
        lava_rune = true;
      } else if (contact.getBody2().getName() == "lavarune") {
        contact.getBody2().attachImage(runes[0]);
        lava_rune = true;
      } else if (contact.getBody1().getName() == "rockrune") {
        contact.getBody1().attachImage(runes[0]);
        rock_rune = true;
      } else if (contact.getBody2().getName() == "rockrune") {
        contact.getBody2().attachImage(runes[0]);
        rock_rune = true;
      } else if (contact.getBody1().getName() == "key") {
        contact.getBody1().attachImage(tiles[0]);
        has_key = true;
      } else if (contact.getBody2().getName() == "key") {
        contact.getBody2().attachImage(tiles[0]);
        has_key = true;
      } 
    }

    if (fluid == "water") setVelocity(getVelocityX()/2, getVelocityY()/1.5);
    else if (fluid == "lava") setVelocity(getVelocityX()/3, getVelocityY()/1.75);
    
    if (fluid != "water") breath = min(breath + 5, 300);
    if (fluid != "lava") crispy = max(crispy - 1, 0);
  }

  void display(int stage) {
    if (cutscene) {
      setVelocity(0, 0);
      setPosition(440, 250);
    }
    
    if (fluid == "water" && submerged ) {
      fill(#00b7ef, (water_rune? 10: 100));
      noStroke();
      rect(0, 0, width, height);
      
      fill(0);
      rect(198, 498, 204, 14, 5);
      fill(0, 128, 255);
      rect(200, 500, map(breath, 0, 300, 0, 200), 10, 5);
    } else if (fluid == "lava") {
      fill(#ff7e00, (lava_rune? 10: 100));
      noStroke();
      rect(0, 0, width, height);
    } 
    
    if (text) {
      fill(150);
      stroke(0);
      strokeWeight(5);
      rect(150, 425, 300, 125, 5);
      
      fill(0);
      textSize(16);
      textAlign(BASELINE);
      text(dialogue[stage], 155, 440);
    }
    
    if (has_key) image(key_, 10, 10, 20, 20);
    
    if (cutscene) {
      setVelocity(0, 0);
    }
  }
}
