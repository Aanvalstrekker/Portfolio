color backgColor = color(0, 60, 0);
color simulationColor = color(180, 80, 80);
color gridColor = color(0,0,0);
color deadColor = color(110, 110, 110);
color aliveColor = color(75, 0, 75);

color currentBackgroundColor;

boolean simRunning = false;

int simulationSpeed = 10;

int gridOffsetX, gridOffsetY;
int gridStroke = 2;
int gridSize;
int squareSize = 20;

int[][] buffR, buffW;

int editValue = -1;

int randomChance = 30;

void setup(){
    size(1000, 1000);
    gridSize = width / squareSize - 2;
    clearBuffers();
    gridOffsetX = squareSize;
    gridOffsetY = (height - width) + squareSize;
    currentBackgroundColor = backgColor;
}

void draw(){
    drawBackground();
    drawSquares();
    drawGrid();
    if (!simRunning) editor();
    else if (simRunning) simulation();
}

void enableSimulation(boolean state){
  if (!state){
      currentBackgroundColor = backgColor;
      simRunning = false;
      frameRate(144);
  }
  else if (state){
      currentBackgroundColor = simulationColor;
      simRunning = true;
      frameRate(simulationSpeed);
  }
}

void keyPressed(){
  if (key == ' '){
    if (simRunning){
      enableSimulation(false);
    }
    else if (!simRunning){
      enableSimulation(true);
    }
  }
  if (key == 'r' || key == 'R'){
    if (simRunning) enableSimulation(false);
    clearBuffers();
  }
  if (key == 'q' || key == 'Q'){
    if (simRunning) enableSimulation(false);
    clearBuffers();
    randomizer();
  }
}

void drawBackground(){
  fill(currentBackgroundColor);
  rect(0,0, width, height);
}

void clearBuffers(){
    buffR = new int[gridSize][gridSize];
    buffW = new int[gridSize][gridSize];
}

void drawGrid(){
  strokeWeight(gridStroke);
  for(int i = 0; i < gridSize + 1; i++){
    line(gridOffsetX + squareSize * i, gridOffsetY, gridOffsetX + squareSize * i, gridOffsetY + gridSize * squareSize); 
    line(gridOffsetX, gridOffsetY + squareSize * i, gridOffsetX + gridSize * squareSize, gridOffsetY +  squareSize * i); 
  }
}
void drawSquares(){
    for(int y = 0; y < gridSize; y++)
    {
        for(int x = 0; x < gridSize; x++)
        {
            fill(aliveColor);
            if(buffR[x][y] == 0) fill(deadColor);
            rect(x * squareSize + gridOffsetX, y * squareSize + gridOffsetY, squareSize, squareSize);
        }
    }
}

void editor(){
  if(mousePressed)
    {
        int squareX = floor((mouseX - gridOffsetX) / squareSize);
        int squareY = floor((mouseY - gridOffsetY) / squareSize);

        if(squareX >= 0 && squareX < gridSize && squareY >= 0 && squareY < gridSize)
        {
            int value = buffR[squareX][squareY];
            if(editValue == -1)
            {
                editValue = 0;
                if(value == 0) editValue = 1;           
            }
            buffR[squareX][squareY] = editValue;
        }
    }
    else editValue = -1;
}


void simulation(){
  for(int y = 0; y < gridSize; y++)
  {
    for(int x = 0; x < gridSize; x++)
    {
      buffW[x][y] = 0;
      int surroundingSquares = getSurroundingSquares(x,y);  
      if(buffR[x][y] == 0 && surroundingSquares == 3) buffW[x][y] = 1;
      else if(buffR[x][y] >= 1 && surroundingSquares > 1 && surroundingSquares < 4) buffW[x][y] = buffR[x][y] + 1;
    }
  }
  buffR = buffW;
  buffW = new int[gridSize][gridSize];
}

int getSurroundingSquares(int x, int y) {
  int surroundingSquares = 0;
  for(int _y = -1; _y < 2; _y++)
  {
    for(int _x = -1; _x < 2; _x++)
    {
      if(x + _x >= 0 && y + _y >= 0 && x + _x < gridSize && y + _y < gridSize)
      {
        if(x + _x == x && y + _y == y) continue;
        if(buffR[x + _x][y + _y] >= 1) surroundingSquares++;
      }
    }
  }
  return surroundingSquares;
}

void randomizer(){
  for(int y = 0; y < gridSize; y++)
  {
    for(int x = 0; x < gridSize; x++)
    {
      if (random(0, 100) < randomChance) buffR[x][y] = 1;
      else buffR[x][y] = 0;
    }
  }
}