class Tile extends FBox {
  int frame, max_frame, tile_number, data;
  boolean t, tr, r, br, b, bl, l, tl, loop;
  PImage deactive;
  
  Tile(float pixel, float m, float n, PImage map) {
    super(pixel + 0.5, pixel + 0.5);
    setPosition(pixel * m, pixel * n);
    setStatic(true);
    setFillColor(map.get((int)m, (int)n));
    setNoStroke();
    setGrabbable(false);
    setFriction(0);
    
    frame = 0;
    loop = true;
    
    if (map.get((int)m, (int)n) == #000000) {
      setName("ground");
      attachImage(load_grass((int)m, (int)n, map));
      
    } else if (map.get((int)m, (int)n) == #00b7ef) {
      setName("water");
      
      if (map.get((int)m - 1, (int)n) != #00b7ef && map.get((int)m + 1, (int)n) != #00b7ef) {
        if (map.get((int)m - 1, (int)n + 1) == #00b7ef || map.get((int)m + 1, (int)n + 1) == #00b7ef) attachImage(tiles[75]);
        else attachImage(tiles[66]);
      } else if (map.get((int)m, (int)n - 1) == #00b7ef) {
        if (map.get((int)m - 1, (int)n - 1) != #00b7ef && map.get((int)m + 1, (int)n - 1) != #00b7ef) attachImage(tiles[81]);
        else attachImage(tiles[90]);
      }
      else attachImage(tiles[83]);
      setSensor(true);
      
    } else if (map.get((int)m, (int)n) == #FF0000) {
      setName("jumpboost");
      setSensor(true);
      max_frame = 4;
      tile_number = 0;
      animated_tiles.add(this);
      
    } else if (map.get((int)m, (int)n) == #99d9ea) {
      setName("ice");
      //setFriction(0);
      
      if (map.get((int)m, (int)n - 1) != #FFFFFF) attachImage(tiles[3]);
      else attachImage(tiles[78]);
      
    } else if (map.get((int)m, (int)n) == #ff7e00) {
      setName("lava");
      setSensor(true);
      
      if (map.get((int)m, (int)n - 1) == #ff7e00) attachImage(tiles[68]);
      else attachImage(tiles[84]);
      
    } else if (map.get((int)m, (int)n) == #ffc20e) {
      setName("falling_bridge");
      
      attachImage(tiles[14]);
    } else if (map.get((int)m, (int)n) == #b4b4b4 || map.get((int)m, (int)n) == #00FF00 || map.get((int)m, (int)n) == #FFFF00) {
      setName("inner");
      setSensor(true);
      setNoFill();
      
    } else if (map.get((int)m, (int)n) == #709ad1) {
      setName("spikes");
      max_frame = 9;
      tile_number = 2;
      animated_tiles.add(this);
      
      setSensor(true);
    } else if (red(map.get((int)m, (int)n)) == 255 && blue(map.get((int)m, (int)n)) == 255) {
      max_frame = 8;
      tile_number = 1;
      animated_tiles.add(this);
      
      data = int(green(map.get((int)m, (int)n)));
      setName("portal");
      
      setSensor(true);
    } else if (map.get((int)m, (int)n) == #2f3699) {
      setName("bluerune");
      setSensor(true);
      
      if (water_rune) attachImage(runes[0]);
      else attachImage(runes[1]);
    } else if (map.get((int)m, (int)n) == #ff9900) {
      setName("lavarune");
      setSensor(true);

      if (lava_rune) attachImage(runes[0]);
      else attachImage(runes[2]);
    } else if (map.get((int)m, (int)n) == #d99059) {
      setName("sign");
      setSensor(true);
      attachImage(sign);
    } else if (map.get((int)m, (int)n) == #ed1c24) {
      setName("firebox");
      max_frame = 4;
      tile_number = 3;
      animated_tiles.add(this);
      
      deactive = animated_tileset.get(3)[4];
    } else if (map.get((int)m, (int)n) == #ffa3b1) {
      setName("fire");
      max_frame = 4;
      tile_number = 4;
      animated_tiles.add(this);
      
      setSensor(true);
      deactive = tiles[0];
    } else if (map.get((int)m, (int)n) == #6f3198) {
      setPosition(pixel * m, pixel * n - 10);
      setName("purplefire");
      
      if (!fire_trap) {
        attachImage(tiles[0]);
        return;
      }
      
      max_frame = 8;
      tile_number = 5;
      animated_tiles.add(this);
      
      setSensor(true);
    } else if (map.get((int)m, (int)n) == #ff9500) {
      setName("breakable");
      
      attachImage(tiles[23]);
    } else if (map.get((int)m, (int)n) == #090909) {
      setName("door");
      max_frame = 1;
      tile_number = 7;
      animated_tiles.add(this);
      loop = false;
      
      setSensor(true);
    } else if (map.get((int)m, (int)n) == #914711) {
      setName("rockrune");
      setSensor(true);
      
      if (rock_rune) attachImage(runes[0]);
      else attachImage(runes[3]);
    } else if (map.get((int)m, (int)n) == #ffbb00) {
      setPosition(pixel * m, pixel * n - 10);
      setName("key");
      setSensor(true);
      if (has_key) attachImage(tiles[0]);
      else attachImage(key_);
    }
  }
  
  PImage load_grass(int x, int y, PImage map) {
    t = !contains(transparent, map.get(x, y - 1));
    tr = !contains(transparent, map.get(x + 1, y - 1));
    r = !contains(transparent, map.get(x + 1, y));
    br = !contains(transparent, map.get(x + 1, y + 1));
    b = !contains(transparent, map.get(x, y + 1));
    bl = !contains(transparent, map.get(x - 1, y + 1));
    l = !contains(transparent, map.get(x - 1, y));
    tl = !contains(transparent, map.get(x - 1, y - 1));
    
    if (map.get(0, 0) == #00FF00) {
      if (!t && r && l) {
        return tiles[9]; // top
      } if (!t && r && !l) {
        return tiles[8]; // top left 
      } if (!t && !r && l) {
        return reverseImage(tiles[8]); // top right 
      } if (t && l && !tl) {
        return tiles[10]; // top left corner
      } if (t && r && !tr) {
        return reverseImage(tiles[10]); // top right corner
      } if (t && b && r && !l) {
        return tiles[16]; // left 
      } if (t && b && !r && l) {
        return reverseImage(tiles[16]); // right 
      } if (!b && r && l) {
        return reverseImage(tiles[25]); // bottom
      } if (!b && r && !l) {
        return tiles[24]; // bottom left
      } if (!b && !r && l) {
        return reverseImage(tiles[24]); // bottom right
      }
    }
    
    if (map.get(0, 0) == #FFFF00) {
      if (!t && r && l) {
        return tiles[36]; // top
      } if (!t && r && !l) {
        return tiles[35]; // top left 
      } if (!t && !r && l) {
        return reverseImage(tiles[35]); // top right 
      } if (t && l && !tl) {
        return tiles[37]; // top left corner
      } if (t && r && !tr) {
        return reverseImage(tiles[37]); // top right corner
      } if (t && b && r && !l) {
        return tiles[43]; // left 
      } if (t && b && !r && l) {
        return reverseImage(tiles[43]); // right
      } if (!b && r && l) {
        return reverseImage(tiles[52]); // bottom
      } if (!b && r && !l) {
        return tiles[51]; // bottom left
      } if (!b && !r && l) {
        return reverseImage(tiles[51]); // bottom right
      }
    }
    
    return tiles[3];
  }
  
  void update() {
    frame += (frameCount%10 == 0? 1: 0);
    if (!loop) frame = min(frame, max_frame);
    else frame = frame % max_frame;
    attachImage(animated_tileset.get(tile_number)[frame]);
  }
}
