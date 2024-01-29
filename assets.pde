PImage[] tiles, runes; 
color[] transparent = {#FFFFFF, #ffc20e, #6400ff, #546d8e, #FF0000, #22b14c, #0000FF, #9c5a3c, #990030, #2f3699, #d99059, #6f3198, #ff9900, #914711, #ffbb00, #4d6df3, #ff9500, #709ad1};
ArrayList<PImage[]> animated_tileset, sprites;
PImage arrow, sign, key_, meteor;
ArrayList<Tile> animated_tiles;
ArrayList<Enemy> enemies;
ArrayList<Entity> environment;
float[] playerx = {225, 125, 1150, 100, 1160, 150, 150, 150, 100, 670},
        playery = {470, 500, 70, 50,  430,  80, 100, 150, 400, 440};
boolean water_rune, lava_rune, rock_rune, fire_trap, has_key, cutscene, geysers;
String[] dialogue = {"", " I'm a sign. Some of us will say \n something useful.",
                         " This is a Rune! Touching it \n will give special properties. \n This one seems to be related \n to water.",
                         " Sometimes I'm a distraction.",
                         " Magical power emulates from \n the flame. It seems to hold \n power over other fire.",
                         " The key glows with power. I'm \n not saying its important, but \n it looks very important.",
                         " Oh no! A cave in! Maybe this \n rune can do something to help.",
                         " You need a key for this door.",
                         " You see a big, scary looking \n dragon. Its scales protect it \n from harm. The cold water geysers \n might be able to damage it. If only \n we could turn up the pressure.",
                         " Another Rune! It glows with \n the power of magma. It could be\n related to lava"};
PFont font;

void setup() {
  water_rune = false;
  lava_rune = false;
  rock_rune = false;
  has_key = false;
  cutscene = false;
  
  fire_trap = true;
  geysers = true;
  
  size(600, 600);
  Fisica.init(this);
  
  font = createFont("5x5.ttf", 32);
  textFont(font);
  
  tiles = new PImage[93];
  for(int i = 0; i < 93; ++i) {
    tiles[i] = loadImage("tileset/tile0" + (i < 10? "0" + i: i) + ".png");
    tiles[i].resize(20, 20);
  }
  
  runes = new PImage[4];
  for(int i = 0; i < 4; ++i) {
    runes[i] = loadImage("assets/runes/" + i + ".png");
    runes[i].resize(20, 30);
  }
  
  sprites = new ArrayList<PImage[]>();
  
  add_sprite("player", 24, 50, 50);
  add_sprite("goomba", 9, 30, 30);
  add_sprite("thwomp", 20, 45, 45);
  add_sprite("archer", 20, 50, 50);
  add_sprite("dragon", 16, 70, 70);
  
  animated_tileset = new ArrayList<PImage[]>();
  animated_tiles = new ArrayList<Tile>();
  
  add_tileset("jump_boost", 4, 20, 20);
  add_tileset("portal", 8, 70, 70);
  add_tileset("spikes", 9, 20, 40);
  add_tileset("firebox", 5, 20, 20);
  add_tileset("fire", 4, 20, 20);
  add_tileset("purplefire", 8, 20, 40);
  add_tileset("purplefire_end", 5, 20, 40);
  add_tileset("door", 16, 40, 60);
  add_tileset("geyser", 6, 40, 220);
  add_tileset("geyser_small", 4, 20, 80);
  add_tileset("fireball", 2, 30, 30);
  
  enemies = new ArrayList<Enemy>();
  
  arrow = loadImage("assets/arrow_C.png");
  arrow.resize(20, 5);
  
  sign = loadImage("assets/sign.png");
  sign.resize(20, 20);
  
  key_ = loadImage("assets/key.png");
  key_.resize(20, 20);
  
  meteor = loadImage("assets/meteor.png");
  meteor.resize(40, 40);


  sys = new System(); 
}

PImage reverseImage(PImage image) {
  PImage reverse;
  reverse = createImage(image.width, image.height, ARGB);

  for (int i=0; i < image.width; ++i) {
    for (int j=0; j < image.height; ++j) {
      int xPixel, yPixel;
      xPixel = image.width - 1 - i;
      yPixel = j;
      reverse.pixels[yPixel*image.width+xPixel]=image.pixels[j*image.width+i] ;
    }
  }
  return reverse;
}

void add_tileset(String name, int max_frame, int width_, int height_) {
  animated_tileset.add(new PImage[max_frame]);
  int l = animated_tileset.size() - 1;
  
  for(int i = 0; i < max_frame; ++i) {
    animated_tileset.get(l)[i] = loadImage("assets/" + name + "/tile0" + (i < 10? "0" + i: i) + ".png");
    animated_tileset.get(l)[i].resize(width_, height_);
  }
}

void add_sprite(String name, int max_frame, int width_, int height_) {
  sprites.add(new PImage[max_frame]);
  int l = sprites.size() - 1;
  
  for(int i = 0; i < max_frame; ++i) {
    sprites.get(l)[i] = loadImage("sprites/" + name + "/tile0" + (i < 10? "0" + i: i) + ".png");
    sprites.get(l)[i].resize(width_, height_);
  }
}

boolean contains(color[] colors, color c) {
  for (color colour: colors) {
    if (colour == c) return true;
  }
  return false;
}
