class Piece {
  color col;
  Square[] squares;
  int value;
  boolean falling = true;
  int pos = 0;
  int prev_pos = pos;
  Piece() {
    value = floor(random(7));
    switch (value) {
    case 0: // square
      col = color(255, 255, 0);
      squares = new Square[4];
      squares[0] = new Square(4, 0, col);
      squares[1] = new Square(5, 0, col);
      squares[2] = new Square(4, 1, col);
      squares[3] = new Square(5, 1, col);
      break;
    case 1: // L shape
      col = color(255, 150, 40);
      squares = new Square[4];
      squares[0] = new Square(4, 0, col);
      squares[1] = new Square(5, 0, col);
      squares[2] = new Square(6, 0, col);
      squares[3] = new Square(4, 1, col);
      break;
    case 2: // reverse L shape
      col = color(0, 0, 200);
      squares = new Square[4];
      squares[0] = new Square(4, 0, col);
      squares[1] = new Square(5, 0, col);
      squares[2] = new Square(6, 0, col);
      squares[3] = new Square(6, 1, col);
      break;
    case 3: // T shape
      col = color(100, 0, 120);
      squares = new Square[4];
      squares[0] = new Square(4, 0, col);
      squares[1] = new Square(5, 0, col);
      squares[2] = new Square(6, 0, col);
      squares[3] = new Square(5, 1, col);
      break;
    case 4: // Bar
      col = color(0, 255, 255);
      squares = new Square[4];
      squares[0] = new Square(4, 0, col);
      squares[1] = new Square(4, 1, col);
      squares[2] = new Square(4, 2, col);
      squares[3] = new Square(4, 3, col);
      break;
    case 5: // Z shape
      col = color(255, 0, 0);
      squares = new Square[4];
      squares[0] = new Square(4, 0, col);
      squares[1] = new Square(5, 0, col);
      squares[2] = new Square(6, 1, col);
      squares[3] = new Square(5, 1, col);
      break;
    case 6: // reverse Z shape
      col = color(0, 255, 0);
      squares = new Square[4];
      squares[0] = new Square(4, 1, col);
      squares[1] = new Square(5, 0, col);
      squares[2] = new Square(6, 0, col);
      squares[3] = new Square(5, 1, col);
      break;
    }
  }

  void update() {
    for (Square s : squares) {
      s.try_update();
      falling = falling && s.falling;
    }
    if (falling) {
      for (int j = grid_height - 1; j > -1; j--) {
        for (int i = 0; i < grid_width; i++) {
          if (grid[i][j] != null) {
            grid[i][j].update();
          }
        }
      }
    } else {
      for (int i = 0; i < squares.length; i++) {
        squares[i].falling = false;
      }
    }
  }

  void go_right() {
    for (int j = grid_height - 1; j > -1; j--) {
      for (int i = grid_width - 1; i > -1; i--) {
        if (grid[i][j] != null) {
          if (grid[i][j].falling && i == grid_width - 1) {
            return;
          }
          if (grid[i][j].falling && grid[i+1][j] != null) {
            if (!grid[i+1][j].falling) {
              return;
            }
          }
        }
      }
    }
    for (int j = grid_height - 1; j > -1; j--) {
      for (int i = grid_width - 2; i > -1; i--) {
        if (grid[i][j] != null) {
          if (grid[i][j].falling && grid[i+1][j] == null) {
            grid[i+1][j] = grid[i][j];
            grid[i][j] = null;
            grid[i+1][j].pos.x += 1;
          }
        }
      }
    }
  }

  void go_left() {
    for (int j = grid_height - 1; j > -1; j--) {
      for (int i = 0; i < grid_width; i++) {
        if (grid[i][j] != null) {
          if (grid[i][j].falling && i == 0) {
            return;
          }
          if (grid[i][j].falling && grid[i-1][j] != null) {
            if (!grid[i-1][j].falling) {
              return;
            }
          }
        }
      }
    }
    for (int j = grid_height - 1; j > -1; j--) {
      for (int i = 1; i < grid_width; i++) {
        if (grid[i][j] != null) {
          if (grid[i][j].falling && grid[i-1][j] == null) {
            grid[i-1][j] = grid[i][j];
            grid[i][j] = null;
            grid[i-1][j].pos.x -= 1;
          }
        }
      }
    }
  }
  void rotate_left() {
    pos--;
    if (pos == -1) {
      pos = 3;
    }
    update_pos();
  }

  void rotate_right() {
    pos = (pos+1)%4;
    update_pos();
  }

  void update_pos() {
    int x, y;
    switch (value) {
    case 1://---------------------------------------------------------------------------------
      x = floor(squares[1].pos.x);
      y = floor(squares[1].pos.y);
      switch (pos) {
      case 0:
        if (x == 0 || x == grid_width - 1 || y == grid_height - 1) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y+1] != null) {
          if (!grid[x-1][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x+1][y] = squares[0];
        squares[0].pos = new PVector(x+1, y);
        grid[x-1][y] = squares[2];
        squares[2].pos = new PVector(x-1, y);
        grid[x-1][y+1] = squares[3];
        squares[3].pos = new PVector(x-1, y+1);
        break;
      case 1:
        if (x == 0 || y == 0 || y == grid_height - 1) {
          return;
        }
        if (grid[x-1][y-1] != null) {
          if (!grid[x-1][y-1].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x][y+1] = squares[0];
        squares[0].pos = new PVector(x, y+1);
        grid[x][y-1] = squares[2];
        squares[2].pos = new PVector(x, y-1);
        grid[x-1][y-1] = squares[3];
        squares[3].pos = new PVector(x-1, y-1);
        break;
      case 2:
        if (x == 0 || x == grid_width - 1 || y == 0) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x+1][y-1] != null) {
          if (!grid[x+1][y-1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x-1][y] = squares[0];
        squares[0].pos = new PVector(x-1, y);
        grid[x+1][y] = squares[2];
        squares[2].pos = new PVector(x+1, y);
        grid[x+1][y-1] = squares[3];
        squares[3].pos = new PVector(x+1, y-1);
        break;
      case 3:
        if (x == grid_width - 1 || y == 0 || y == grid_height - 1) {
          return;
        }
        if (grid[x+1][y+1] != null) {
          if (!grid[x+1][y+1].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x][y-1] = squares[0];
        squares[0].pos = new PVector(x, y-1);
        grid[x][y+1] = squares[2];
        squares[2].pos = new PVector(x, y+1);
        grid[x+1][y+1] = squares[3];
        squares[3].pos = new PVector(x+1, y+1);
        break;
      }
      break;
    case 2://----------------------------------------------------------------------------------------------
      x = floor(squares[1].pos.x);
      y = floor(squares[1].pos.y);
      switch (pos) {
      case 0:
        if (x == 0 || x == grid_width - 1 || y == grid_height - 1) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x+1][y+1] != null) {
          if (!grid[x+1][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x+1][y] = squares[0];
        squares[0].pos = new PVector(x+1, y);
        grid[x-1][y] = squares[2];
        squares[2].pos = new PVector(x-1, y);
        grid[x+1][y+1] = squares[3];
        squares[3].pos = new PVector(x+1, y+1);
        break;
      case 1:
        if (x == 0 || y == 0 || y == grid_height - 1) {
          return;
        }
        if (grid[x-1][y+1] != null) {
          if (!grid[x-1][y+1].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x][y+1] = squares[0];
        squares[0].pos = new PVector(x, y+1);
        grid[x][y-1] = squares[2];
        squares[2].pos = new PVector(x, y-1);
        grid[x-1][y+1] = squares[3];
        squares[3].pos = new PVector(x-1, y+1);
        break;
      case 2:
        if (x == 0 || x == grid_width - 1 || y == 0) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y-1] != null) {
          if (!grid[x-1][y-1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x-1][y] = squares[0];
        squares[0].pos = new PVector(x-1, y);
        grid[x+1][y] = squares[2];
        squares[2].pos = new PVector(x+1, y);
        grid[x-1][y-1] = squares[3];
        squares[3].pos = new PVector(x-1, y-1);
        break;
      case 3:
        if (x == grid_width - 1 || y == 0 || y == grid_height - 1) {
          return;
        }
        if (grid[x+1][y-1] != null) {
          if (!grid[x+1][y-1].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x][y-1] = squares[0];
        squares[0].pos = new PVector(x, y-1);
        grid[x][y+1] = squares[2];
        squares[2].pos = new PVector(x, y+1);
        grid[x+1][y-1] = squares[3];
        squares[3].pos = new PVector(x+1, y-1);
        break;
      }
      break;
    case 3://------------------------------------------------------------------------------------------
      x = floor(squares[1].pos.x);
      y = floor(squares[1].pos.y);
      switch (pos) {
      case 0:
        if (x == 0 || x == grid_width - 1 || y == grid_height - 1) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x+1][y] = squares[0];
        squares[0].pos = new PVector(x+1, y);
        grid[x-1][y] = squares[2];
        squares[2].pos = new PVector(x-1, y);
        grid[x][y+1] = squares[3];
        squares[3].pos = new PVector(x, y+1);
        break;
      case 1:
        if (x == 0 || y == 0 || y == grid_height + 1) {
          return;
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x][y+1] = squares[0];
        squares[0].pos = new PVector(x, y+1);
        grid[x][y-1] = squares[2];
        squares[2].pos = new PVector(x, y-1);
        grid[x-1][y] = squares[3];
        squares[3].pos = new PVector(x-1, y);
        break;
      case 2:
        if (x == 0 || x == grid_width - 1 || y == 0) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x-1][y] = squares[0];
        squares[0].pos = new PVector(x-1, y);
        grid[x+1][y] = squares[2];
        squares[2].pos = new PVector(x+1, y);
        grid[x][y-1] = squares[3];
        squares[3].pos = new PVector(x, y-1);
        break;
      case 3:
        if (x == grid_width - 1 || y == 0 || y == grid_height + 1) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x][y-1] = squares[0];
        squares[0].pos = new PVector(x, y-1);
        grid[x][y+1] = squares[2];
        squares[2].pos = new PVector(x, y+1);
        grid[x+1][y] = squares[3];
        squares[3].pos = new PVector(x+1, y);
        break;
      }
      break;
    case 4://------------------------------------------------------------------------------------------
    
      break;
    case 5://-----------------------------------------------------------------------------------------
      x = floor(squares[1].pos.x);
      y = floor(squares[1].pos.y);
      switch (pos) {
      case 0:
        if (x == 0 || x == grid_width - 1 || y == grid_height - 1) {
          return;
        }
        if (grid[x+1][y+1] != null) {
          if (!grid[x+1][y+1].falling) {
            return;
          }
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x+1][y+1] = squares[0];
        squares[0].pos = new PVector(x+1, y+1);
        grid[x-1][y] = squares[2];
        squares[2].pos = new PVector(x-1, y);
        grid[x][y+1] = squares[3];
        squares[3].pos = new PVector(x, y+1);
        break;
      case 1:
        if (x == 0 || y == 0 || y == grid_height + 1) {
          return;
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        if (grid[x-1][y+1] != null) {
          if (!grid[x-1][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x-1][y+1] = squares[0];
        squares[0].pos = new PVector(x-1, y+1);
        grid[x][y-1] = squares[2];
        squares[2].pos = new PVector(x, y-1);
        grid[x-1][y] = squares[3];
        squares[3].pos = new PVector(x-1, y);
        break;
      case 2:
        if (x == 0 || x == grid_width - 1 || y == 0) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y-1] != null) {
          if (!grid[x-1][y-1].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x-1][y-1] = squares[0];
        squares[0].pos = new PVector(x-1, y-1);
        grid[x+1][y] = squares[2];
        squares[2].pos = new PVector(x+1, y);
        grid[x][y-1] = squares[3];
        squares[3].pos = new PVector(x, y-1);
        break;
      case 3:
        if (x == grid_width - 1 || y == 0 || y == grid_height + 1) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x+1][y-1] != null) {
          if (!grid[x+1][y-1].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x+1][y-1] = squares[0];
        squares[0].pos = new PVector(x+1, y-1);
        grid[x][y+1] = squares[2];
        squares[2].pos = new PVector(x, y+1);
        grid[x+1][y] = squares[3];
        squares[3].pos = new PVector(x+1, y);
        break;
      }
    case 6://---------------------------------------------------------------------------------------------
      x = floor(squares[1].pos.x);
      y = floor(squares[1].pos.y);
      switch (pos) {
      case 0:
        if (x == 0 || x == grid_width - 1 || y == grid_height - 1) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y+1] != null) {
          if (!grid[x-1][y+1].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x+1][y] = squares[0];
        squares[0].pos = new PVector(x+1, y);
        grid[x-1][y+1] = squares[2];
        squares[2].pos = new PVector(x-1, y+1);
        grid[x][y+1] = squares[3];
        squares[3].pos = new PVector(x, y+1);
        break;
      case 1:
        if (x == 0 || y == 0 || y == grid_height + 1) {
          return;
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x-1][y-1] != null) {
          if (!grid[x-1][y-1].falling) {
            return;
          }
        }
        if (grid[x][y+1] != null) {
          if (!grid[x][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x][y+1] = squares[0];
        squares[0].pos = new PVector(x, y+1);
        grid[x-1][y-1] = squares[2];
        squares[2].pos = new PVector(x-1, y-1);
        grid[x-1][y] = squares[3];
        squares[3].pos = new PVector(x-1, y);
        break;
      case 2:
        if (x == 0 || x == grid_width - 1 || y == 0) {
          return;
        }
        if (grid[x+1][y-1] != null) {
          if (!grid[x+1][y-1].falling) {
            return;
          }
        }
        if (grid[x-1][y] != null) {
          if (!grid[x-1][y].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x-1][y] = squares[0];
        squares[0].pos = new PVector(x-1, y);
        grid[x+1][y-1] = squares[2];
        squares[2].pos = new PVector(x+1, y-1);
        grid[x][y-1] = squares[3];
        squares[3].pos = new PVector(x, y-1);
        break;
      case 3:
        if (x == grid_width - 1 || y == 0 || y == grid_height + 1) {
          return;
        }
        if (grid[x+1][y] != null) {
          if (!grid[x+1][y].falling) {
            return;
          }
        }
        if (grid[x][y-1] != null) {
          if (!grid[x][y-1].falling) {
            return;
          }
        }
        if (grid[x+1][y+1] != null) {
          if (!grid[x+1][y+1].falling) {
            return;
          }
        }
        grid[floor(squares[0].pos.x)][floor(squares[0].pos.y)] = null;
        grid[floor(squares[2].pos.x)][floor(squares[2].pos.y)] = null;
        grid[floor(squares[3].pos.x)][floor(squares[3].pos.y)] = null;
        grid[x][y-1] = squares[0];
        squares[0].pos = new PVector(x, y-1);
        grid[x+1][y+1] = squares[2];
        squares[2].pos = new PVector(x+1, y+1);
        grid[x+1][y] = squares[3];
        squares[3].pos = new PVector(x+1, y);
        break;
      }
    }
  }
}
