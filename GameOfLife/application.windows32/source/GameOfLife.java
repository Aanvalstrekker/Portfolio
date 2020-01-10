import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class GameOfLife extends PApplet {

int backgColor = color(0, 60, 0);
int simulationColor = color(180, 80, 80);
int gridColor = color(0,0,0);
int deadColor = color(110, 110, 110);
int aliveColor = color(75, 0, 75);

int currentBackgroundColor;

boolean simRunning = false;

int simulationSpeed = 10;

int gridOffsetX, gridOffsetY;
int gridStroke = 2;
int gridSize;
int squareSize = 20;

int[][] buffR, buffW;

int editValue = -1;

int randomChance = 30;

public void setup(){
    
    gridSize = width / squareSize - 2;
    clearBuffers();
    gridOffsetX = squareSize;
    gridOffsetY = (height - width) + squareSize;
    currentBackgroundColor = backgColor;
}

public void draw(){
    drawBackground();
    drawSquares();
    drawGrid();
    if (!simRunning) editor();
    else if (simRunning) simulation();
}

public void enableSimulation(boolean state){
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

public void keyPressed(){
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

public void drawBackground(){
  fill(currentBackgroundColor);
  rect(0,0, width, height);
}

public void clearBuffers(){
    buffR = new int[gridSize][gridSize];
    buffW = new int[gridSize][gridSize];
}

public void drawGrid(){
  strokeWeight(gridStroke);
  for(int i = 0; i < gridSize + 1; i++){
    line(gridOffsetX + squareSize * i, gridOffsetY, gridOffsetX + squareSize * i, gridOffsetY + gridSize * squareSize); 
    line(gridOffsetX, gridOffsetY + squareSize * i, gridOffsetX + gridSize * squareSize, gridOffsetY +  squareSize * i); 
  }
}
public void drawSquares(){
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

public void editor(){
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


public void simulation(){
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

public int getSurroundingSquares(int x, int y) {
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

public void randomizer(){
  for(int y = 0; y < gridSize; y++)
  {
    for(int x = 0; x < gridSize; x++)
    {
      if (random(0, 100) < randomChance) buffR[x][y] = 1;
      else buffR[x][y] = 0;
    }
  }
}
  public void settings() {  size(1000, 1000); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "GameOfLife" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
