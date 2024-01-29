class Entity extends FBox{
  float v, x_, y_;
  boolean despawn;
  ArrayList<FContact> contacts;
  int state;
  
  Entity(float w, float d) {
    super(w, d);
    
    despawn = false;
  }
  
  void update() {};
  void update(Player player) {};
  void update(FWorld world) {};
}

class Arrow extends Entity{
  
  Arrow(float x, float y, int d) {
    super(20, 2);
    
    setPosition(x + d*20, y - 25);
    setDensity(0.02);
    setFriction(0);
    setRestitution(0);
    
    v = d*5;
    y_ = y - 25;

    setGrabbable(false);
    setRotatable(false);
    
    setName("arrow");
    
    if (d == 1) attachImage(arrow);
    else attachImage(reverseImage(arrow));
  }
  
  void update() {
    contacts = getContacts();

    setPosition(getX() + v, y_);
    
    if (contacts.size() > 0) despawn = true;
    else if (getX() <= -100 || getX() >= 1500) despawn = true;
  }
}

class Fireball extends Entity{
  int frame;
  
  Fireball(float x, float y) {
    super(30, 30);
    
    setPosition(x, y);
    setFriction(0);
    setRestitution(0);
    setSensor(true);
    
    setGrabbable(false);
    setRotatable(false); 
    
    setName("fireball");
    
    frame = 0;
    attachImage(animated_tileset.get(10)[frame]);
  }
  
  void update(Player player) {
    attachImage(animated_tileset.get(10)[frame]); 
    frame += (frameCount%5 == 0? 1: 0);
    frame = frame%2;
    setVelocity(0, 0);
    setPosition(getX(), getY() + 1);  
    contacts = getContacts();
    for (FContact contact: contacts) {
      if (contact.contains("ground")) despawn = true;
      if (contact.contains("geyser")) despawn = true;
    }
  }
}

class Meteor extends Entity{
  int life;
  boolean live;
  
  Meteor(float x, float y) {
    super(30, 30);
    
    setPosition(x, y);
    setDensity(1);
    setFriction(0);
    setRestitution(0);
    
    setGrabbable(false);
    
    setName("meteor");
    attachImage(meteor);
    
    life = 1000;
    live = true;
  }
  
  void update(Player player) {
    life--;
    if (life <= 0) despawn = true;
    
    contacts = getContacts();
    for (FContact contact: contacts) {
      if (contact.contains("ground")) live = false;
      if ((contact.contains("player") || contact.contains("sensor")) && live) player.alive = false;
    }
  }
}

class Geyser extends Entity {
  int frame;
  FBox geyser;
  
  Geyser(float x, float y, FWorld world) {
    super(20, 20);
    
    setSensor(true);
    setStatic(true);
    setPosition(x, y);
    setGrabbable(false);
    setNoFill();
    setNoStroke();
    setName("source"); 
    
    x_ = x;
    y_ = y;
    
    geyser = new_geyser(20, 80);
    world.add(geyser);
    
    state = 1;
  }
  
  FBox new_geyser(float w, float h) {
    FBox g = new FBox(w, h);
    g.setPosition(x_, y_ - h/2 + 10); // 110
    g.setStatic(true);
    g.setSensor(true);
    g.setGrabbable(false);
    g.setName("geyser");
    frame = 0;
    return g;
  }
  
  void update(FWorld world) {
    if (state == 0) {
      contacts = getContacts();
      for (FContact contact: contacts) {
        if (contact.contains("meteor")) return;
      }
      state = 1;
      geyser = new_geyser(20, 80);
      world.add(geyser);
    } 
    else if (state == 1) {
      frame += (frameCount%10 == 0? 1: 0);
      frame = frame % 4;
      geyser.attachImage(animated_tileset.get(9)[frame]);
      
      contacts = getContacts();
      for (FContact contact: contacts) {
        if (contact.contains("meteor")) {
          state = 0;
          geyser.removeFromWorld();  
          world.remove(geyser);
          return;
        }
      }
      
      if (!geysers) {
        geyser.removeFromWorld();
        world.remove(geyser);
        geyser = new_geyser(40, 220);
        world.add(geyser);
        state = 2;
      }
    } 
    else if (state == 2) { 
      frame += (frameCount%10 == 0? 1: 0);
      frame = frame % 6;
      geyser.attachImage(animated_tileset.get(8)[frame]);
      if (geysers) {
        state = 1;
        geyser.removeFromWorld();
        world.remove(geyser);
        geyser = new_geyser(20, 80);
        world.add(geyser);
      }
    }
  }
}
