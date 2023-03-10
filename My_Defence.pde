import java.util.HashSet;

float camX = 0;
float camY = 0;
int zoom = 20; // ends up deviding with 20
int maxZoom = 60;
ArrayList<MapTile> tiles = new ArrayList();
ArrayList<ExpandTile> expandTiles = new ArrayList();
ArrayList<Enemy> enemies = new ArrayList();
HashSet<Integer> pressedKeys = new HashSet<Integer>();
boolean hasEnemies = false;


final int A     = 65;
final int S     = 83;
final int D     = 68;
final int W     = 87;
//final int MINUS = 107;
//final int PLUS  = 109;


void setup(){
  fullScreen();
  frameRate(60);
  rectMode(CENTER);
  tiles.add(new MapTile(new Coord(0,0), (byte) -1));
}

void draw() {
  //// Updates
  
  
  
  
  
  //// Display
  background(255);
  fill(0);
  //// Debugging How Many Keys
  int ite = 0;
  for(int debugKey : pressedKeys){
    text(debugKey, width-20, 20 + 20 * ite);
    ++ite;
  }
  for(MapTile tile: tiles){
    tile.Display();
  }
  if(!hasEnemies){
    for(ExpandTile tile: expandTiles){
      tile.Display();
    }
  }
  //// Cam Movement
  if(pressedKeys.contains(A)){
    camX += 1.0 /zoom;
  } else if(pressedKeys.contains(D)){
    camX -= 1.0 /zoom;
  }
  if(pressedKeys.contains(W)){
    camY += 1.0 /zoom;
  } else if(pressedKeys.contains(S)){
    camY -= 1.0 /zoom;
  }
  //// Cam Zoom with keyboard
  if(pressedKeys.contains((int) 'E')){
    zoom=Math.min(maxZoom, zoom + 1);
  } else if(pressedKeys.contains((int) 'Q')){
    zoom=Math.max(1, zoom - 1);
  }
  
  text("x: " + camX + ". y: " + camY + ". z:" + str(zoom/20.0), 20, 20); // display zoom
} 

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e>0){
    zoom=Math.max(1, zoom - 1);
  } else if (e<0) {
    zoom=Math.min(maxZoom, zoom + 1);
  }
}

void keyPressed(){
    pressedKeys.add(keyCode);
}

void keyReleased(){
  pressedKeys.remove(keyCode);
}

void mousePressed(){
  if(!hasEnemies){
    for(ExpandTile tile: expandTiles){
      if(tile.Interact(mouseX, mouseY)){
        //// here we start next round
        break;
      }
    }
  }
}
