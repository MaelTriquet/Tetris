class Square {
  PVector pos;
  float size = height / grid_height;
  boolean falling = true;
  color col;
  Square(int x, int y, color col_) {
    pos = new PVector(x, y);
    col = col_;
    grid[x][y] = this;
  }

  void show() {
    fill(col);
    rect(pos.x * size, pos.y * size, size, size);
  }

  void update() {
    if (pos.y + 2 > grid_height){
      falling = false;
      return;
    } else if (grid[floor(pos.x)][floor(pos.y+1)] != null) {
      if (!grid[floor(pos.x)][floor(pos.y+1)].falling) {
        falling = false;
        return;
      }
    }
    if (falling) {
      grid[floor(pos.x)][floor(pos.y)] = null;
      grid[floor(pos.x)][floor(pos.y+1)] = this;
      pos.y += 1;
    }
  }
  
  void try_update() {
    if (pos.y + 2 > grid_height){
      falling = false;
      return;
    } else if (grid[floor(pos.x)][floor(pos.y+1)] != null) {
      if (!grid[floor(pos.x)][floor(pos.y+1)].falling) {
        falling = false;
        return;
      }
    }
  }
}
