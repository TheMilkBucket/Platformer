void keyPressed() {
  if (key == 'w' || key == 'W') sys.player.varr_[0] = true;
  if (key == 'd' || key == 'D') sys.player.varr_[1] = true;
  if (key == 'a' || key == 'A') sys.player.varr_[2] = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') sys.player.varr_[0] = false;
  if (key == 'd' || key == 'D') sys.player.varr_[1] = false;
  if (key == 'a' || key == 'A') sys.player.varr_[2] = false;

}
