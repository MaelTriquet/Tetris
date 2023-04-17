int grid_height = 15;
int grid_width = 10;
Square[][] grid = new Square[grid_width][grid_height];
boolean create_new_piece = true;
Piece piece;
int speed = 50;
int score = 0;
void setup() {
  size(500, 750);
}

void draw() {
  speed = floor(map(frameCount, 0, 10000, 50, 30));
  background(0);
  if (create_new_piece) {
    piece = new Piece();
    create_new_piece = false;
  }
  for (int j = grid_height - 1; j > -1; j--) {
    for (int i = 0; i < grid_width; i++) {
      if (grid[i][j] != null) {
        grid[i][j].show();
      }
    }
  }
  if (frameCount%speed == 0) {
    piece.update();
  }
  check_new_piece();
    fill(255);
  textSize(30);
  text(score, 10, 40);
  check_tetris();
}

void check_new_piece() {
  create_new_piece = true;
  for (int j = grid_height - 1; j > -1; j--) {
    for (int i = 0; i < grid_width; i++) {
      if (grid[i][j] != null) {
        if (grid[i][j].falling) {
          create_new_piece = false;
          return;
        }
      }
    }
  }
}

void check_tetris() {
  for (int j = grid_height - 1; j > -1; j--) {
    boolean tetris = true;
    for (int i = 0; i < grid_width; i++) {
      if (grid[i][j] == null) {
        tetris = false;
        break;
      }
    }
    if (tetris) {
      clear_tetris(j);
      score += 10;
      j++;
    }
  }
}

void clear_tetris(int k) {
  for (int j = k; j > 0; j--) {
    for (int i = 0; i < grid_width; i++) {
      if (grid[i][j] != null) {
        grid[i][j].pos.y++;
      }
      grid[i][j] = grid[i][j-1];
    }
  }
  for (int i = 0; i < grid_width; i++) {
    grid[i][0] = null;
  }
}

void keyPressed() {
  switch (keyCode) {
  case SHIFT :
    while (piece.falling) {
      piece.update();
    }
    break;
  case RIGHT :
    piece.go_right();
    break;
  case LEFT :
    piece.go_left();
    break;
  case UP :
    piece.rotate_left();
    break;
  case DOWN :
    piece.rotate_right();
    break;
  }
}
