class System{
  FWorld world;
  Tile t;
  
  PImage map;
  float pixel;
  Player player;
  int stage, state, next_state, text_size, f;
  long frame;
  ArrayList<FContact> contacts;
  boolean win, was_pressed, help, credits;
  
  System() {
    stage = 0;
    state = 1;
    pixel = 20;
    win = false;
    load_map();

    was_pressed = false;
    help = false;
    credits = false;

    world.add(player);
    for (FBox sensor: player.sensors) world.add(sensor);
  }
  
  void run() {
    if (state == -1) {
      transition();
    } else if (state == 0) {
      update();
      display();
    } else if (state == 1) {
      prologue();
    } else if (state == 2) {
      epilogue();
    }
  }
  
  void prologue() {
    background(tiles[0].get(0, 0));
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(100);
    text("DECIDE", 300, 150);
    textSize(20);
    text("A Puzzle Platformer", 300, 200);
    
    image(sprites.get(0)[f], 275, 300);
    f = (f + ((frameCount % 10 == 0)? 1: 0)) % 4;
    
    textSize(20 + abs(5 * cos(TWO_PI * frameCount / 200)));
    text("Press Any Key to Begin", 300, 400);
    
    textSize(20);
    text("Help", 200, 500);
    text("Credits", 380, 500);
    
    if (mouseY >= 490 && mouseY <= 510) {
      if (mouseX >= 160 && mouseX <= 230) {
        noFill();
        stroke(255);
        strokeWeight(5);
        rect(170, 493, 60, 20);
        if (mousePressed && !was_pressed) {
          help = true;
        } 
      } else if (mouseX >= 330 && mouseX <= 430) {
        noFill();
        stroke(255);
        strokeWeight(5);
        rect(330, 493, 100, 20);
        if (mousePressed && !was_pressed) {
          credits = true;
        } 
      }
    }
    
    if (!mousePressed && was_pressed) was_pressed = false;
    
    if (help) {
      fill(tiles[0].get(0, 0));
      stroke(255);
      strokeWeight(5);
      rect(50, 50, 500, 500);
      
      if (mouseX >= 55 && mouseX <= 75 && mouseY >= 55 && mouseY <= 75) {
        fill(200);
        if (mousePressed && !was_pressed) {
          help = false;
        } 
      } else fill(255);
      textSize(30);
      text("x", 65, 57);
      
      fill(255);
      textSize(20);
      text("no lmao", 300, 300);
      
    } else if (credits) {
      fill(tiles[0].get(0, 0));
      stroke(255);
      strokeWeight(5);
      rect(50, 50, 500, 500);
      
      if (mouseX >= 55 && mouseX <= 75 && mouseY >= 55 && mouseY <= 75) {
        fill(200);
        if (mousePressed && !was_pressed) {
          credits = false;
        } 
      } else fill(255);
      textSize(30);
      text("x", 65, 57);
      
      fill(255);
      textSize(20);
      text("Assets:\nCavernas - Adam Saltsman\nDino Characters - ScissorMarks\nFree Trap Platformer - BDragon1727\nWaddling Dragon Sprite - liz cheong\nCrusher - unTied Games\nSkeleton Warrior + Archer - unTied Games\nDragon Asset Pack - DeepDive Game Studio\nFire Animation - brullov", 300, 300);
      
    } else if (keyPressed) {
      frame = frameCount;
      state = -1;
      next_state = 0;
    }
  }
  
  void epilogue() {
    background(tiles[0].get(0, 0));
    
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(100);
    text("Victory", 300, 150);
    textSize(20);
    text("Well Done", 300, 200);
    
    image(sprites.get(0)[f], 275, 300);
    f = (f + ((frameCount % 10 == 0)? 1: 0)) % 4;
  }
  
  void transition() {
    if (frameCount - frame > 120) state = next_state;
    else {
      noStroke();
      fill(0, 10);
      rect(0, 0, 1000, 800);
      
      if (next_state == 0) {
        image(sprites.get(0)[f], 275, 300);
        f = (f + ((frameCount % 10 == 0)? 1: 0)) % 4;
        
        textAlign(CENTER, CENTER);
        textSize(20);
        fill(255);
        strokeWeight(2);
        rect(270, 270, 15, 15);
        rect(290, 250, 15, 15);
        rect(310, 270, 15, 15);
        
        fill(0);
        text("A", 277.5, 275);
        text("W", 297.5, 255);
        text("D", 317.5, 275);
        fill(255);
        text("<", 262.5, 275);
        text("^", 297.5, 250);
        text(">", 332.5, 275);
      }
    }
  }
  
  void load_map() {
    animated_tiles = new ArrayList<Tile>();
    enemies = new ArrayList<Enemy>();
    environment = new ArrayList<Entity>();
    
    world = new FWorld(-2000, -2000, 2000, 2000); 
    world.setGravity(0, 900);
    map = loadImage("stages/" + (stage == 9? 4: stage) + ".png");
    
    player = new Player(pixel, playerx[stage], playery[stage]);
  
    for (int m = 0; m <= map.width; ++m) {
      for (int n = 0; n <= map.height; ++n) {
        if (map.get(m, n) == #22b14c) {
          enemies.add(new Goomba(pixel, m * pixel, n * pixel));
        } else if (map.get(m, n) == #0000FF) {
          enemies.add(new Thwomp(pixel, m * pixel, n * pixel));
        } else if (map.get(m, n) == #9c5a3c) {
          enemies.add(new Archer(pixel, m * pixel, n * pixel, 1));
        } else if (map.get(m, n) == #990030) {
          enemies.add(new Archer(pixel, m * pixel, n * pixel, -1));
        } else if (map.get(m, n) == #b82126) {
          enemies.add(new Dragon(pixel, m * pixel, n * pixel));
        } else if (map.get(m, n) == #4d6df3) {
          environment.add(new Geyser(m * pixel, n * pixel, world));
        }
       
        else if (map.get(m, n) != color(255)) {
          world.add(new Tile(pixel, m, n, map));
        }
      }
    }
    
    for (Enemy enemy: enemies) {
      world.add(enemy);
      if (enemy.getName() == "goomba") {for (FBox sensor: enemy.sensors) world.add(sensor);}
      else if (enemy.getName() == "thwomp") world.add(enemy.s);
    }
    
    for (Entity entity: environment) {
      world.add(entity);
    }
  }
  
  void update() {
    world.step();
    
    for (Tile tile: animated_tiles) {
      tile.update();
      if (tile.getName() == "portal") {
        contacts = tile.getContacts();
        for (FContact contact: contacts) {
          if (contact.contains("player") || contact.contains("sensor")) {
            playerx[stage] = player.getX() + (player.direction? -1: 1)*25;
            playery[stage] = player.getY() - 20;
            
            stage = tile.data;
            
            load_map();
            
            world.add(player);
            for (FBox sensor: player.sensors) world.add(sensor);
            world.step();
            return;
          }
        }
      } else if (tile.getName() == "door") {
        contacts = tile.getContacts();
        if (tile.frame == 15){ 
          cutscene = false;
          for (FContact contact: contacts) {
            if (contact.contains("player") || contact.contains("sensor")) {
              stage = 8;
              
              load_map();
              
              world.add(player);
              for (FBox sensor: player.sensors) world.add(sensor);
              world.step();
              return;
            }
          }
        } else if (cutscene){
          tile.max_frame = 15;
        }
      } else if (tile.getName() == "purplefire" && fire_trap) {
        contacts = tile.getContacts();
        for (FContact contact: contacts) {
          if (contact.contains("player")|| contact.contains("sensor")) {
            tile.tile_number = 6;
            tile.frame = 0;
            fire_trap = false;
          }
        }
      }
    }
    
    if (!fire_trap) {
      for (int i = 0; i < animated_tiles.size(); ++i) {
        t = animated_tiles.get(i);
        if (t.tile_number == 6 && t.frame == 4) {
          world.remove(t);
          animated_tiles.remove(t);
          i--;
        } else if (t.getName() == "fire") {
          world.remove(t);
          animated_tiles.remove(t);
          i--;
        } else if (t.getName() == "firebox") {
          t.attachImage(t.deactive);
          animated_tiles.remove(t);
          i--;
        }
      }
    }
    
    player.update();
    
    for (int i = 0; i < enemies.size(); ++i) {
      enemies.get(i).update(player, world);
      if (enemies.get(i).dead) {
        if (enemies.get(i).getName() == "dragon") {
          win = true;
          frame = frameCount;
        }
        world.remove(enemies.get(i));
        enemies.remove(i); 
        i--;
      }
    }
    
    for (Entity entity: environment) {entity.update(world);}
    
    if (environment.size() == 2 && (environment.get(0).state == 0 || environment.get(1).state == 0)) geysers = false;
    else geysers = true;
    
    if (win && frameCount - frame >= 120) {
      frame = frameCount;
      state = -1;
      next_state = 2;
    }
  }
  
  void display() {
    background(tiles[0].get(0, 0));
    
    pushMatrix();
    translate(-(player.getX() - width/2), -(player.getY() - height/2));
    
    world.draw();
    popMatrix();
    
    player.display(stage);
  }
}
