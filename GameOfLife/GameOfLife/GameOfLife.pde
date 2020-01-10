color backg = color(100, 100, 100);
color dead = color(150, 150, 150);
color alive = color(40, 40, 40);

boolean simRunning = false;

int gridOffset = 25;
int gridStroke = 2;
int gridSize;
int squareSize = 15;

int[][] buffR, buffW;

void setup(){
    size(1000, 1000);
    gridSize = width / squareSize;
    clearBuffers();
}

void draw(){
    noStroke();
    background(backg);
    drawGrid();
}

void clearBuffers(){
    buffR = new int[gridSize][gridSize];
    buffW = new int[gridSize][gridSize];
}

void drawGrid(){
  strokeWeight(gridStroke);
  for(int i = 0; i < gridSize + 1; i++){
    line(gridOffset + squareSize * i, 0, gridOffset + squareSize * i, gridSize * squareSize); 
    line(0, gridOffset + squareSize * i, gridSize * squareSize, gridOffset + squareSize * i); 
  }
}