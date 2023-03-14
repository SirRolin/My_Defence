import java.util.HashSet;
float camX = 0;
float camY = 0;
int zoom = 20; // ends up deviding with 20
int maxZoom = 60;
ArrayList<MapTile> tiles = new ArrayList();
ArrayList<ExpandTile> expandTiles = new ArrayList();
ArrayList<SpawnPoint> spawnPoints = new ArrayList();
ArrayList<Enemy> enemies = new ArrayList();
HashSet<Integer> pressedKeys = new HashSet<Integer>();
boolean hasEnemies = false;
byte debuggingLevel = 7; // between 0-7
byte speed = 1;
boolean paused = false;
int level = 0;
long enemyPoints = 0;
int towerHealth = 100;
int enemyID = 0;
int updateRate = 60;

//// used for Source: https://forum.processing.org/two/discussion/18478/deltatime.html
long timeOfFrame;


final int A     = 65;
final int S     = 83;
final int D     = 68;
final int W     = 87;
//final int MINUS = 107;
//final int PLUS  = 109;


void setup() {
  fullScreen();
  frameRate(updateRate);
  rectMode(CENTER);
  MapTile towerTile = new MapTile(new Coord(0, 0), (byte) -1);
  towerTile.progress = 1;
  tiles.add(towerTile);
  
}

void draw() {
  //// Delta Time for time control no matter framerate.
  //// Source: https://forum.processing.org/two/discussion/18478/deltatime.html
  double delta = (-timeOfFrame + (timeOfFrame = frameRateLastNanos))/1e6d;

  //// Limiting Delta Time so it doesn't cause unwanted sideeffects at very low framerates.
  if(delta > 50) delta = 50;

//// Updates
  for(int updateInFrame = 0; !paused && updateInFrame < speed; ++updateInFrame){
    //// Spawn of Enemies
    if(hasEnemies){
      boolean AnySpawnPointsOpen = false;
      for(SpawnPoint point: spawnPoints){
        point.Update(delta);
        if(point.open){
          AnySpawnPointsOpen = true;
        }
      }
      ////Spawn Enemies
      while(enemyPoints > 0 && AnySpawnPointsOpen){
        for(SpawnPoint point: spawnPoints){
          if(point.open){
            Enemy tmpEnemy = new Enemy(point.coord, point.nextTile);
            point.open = false;
            enemyPoints -= tmpEnemy.pointsWorth;
            point.spawnCD = tmpEnemy.spawnCD / (1.0 + point.getSpawnCDR()/10.0) * spawnPoints.size();
            enemies.add(tmpEnemy);
            break;
          }
        }
        AnySpawnPointsOpen = false;
        for(SpawnPoint point: spawnPoints){
          if(point.open){
            AnySpawnPointsOpen = true;
          }
        }
        if(!AnySpawnPointsOpen) break;
      }
    }
  
    ////Update Enemies
    for(int i = enemies.size() - 1; i >= 0; --i){
      enemies.get(i).Update();
    }
  }
  
  //// Display
  background(255);
  fill(0);
  //// Debugging How Many Keys
  int ite = 0;
  for (int debugKey : pressedKeys) {
    text(debugKey, width-20, 20 + 20 * ite);
    ++ite;
  }
  //// Level
  text("Level: " +str(level), width/2, 20);
  
  //// Health
  text("Health: " + str(towerHealth) + "/100", 20, height - 20);
  
  //// Round active?
  text("enemies: " + str(enemies.size()), width/2, 50);
  
//// Debugging info Left
  String infoLeft = "";
  //// timeOfFrame?
  if (debuggingLevel % 4 >= 2) {
    infoLeft += "time: " + timeOfFrame + " - Delta: " + delta + ".\n";
  }
  
  //// spawn CDS
  if (debuggingLevel % 8 >= 4) {
    infoLeft += "spawnPoint CDs: " + "\n";
    for(SpawnPoint sp: spawnPoints){
      infoLeft += sp.spawnCD + "\n";
    }
  }
  if (infoLeft.length() > 0) {
    text(infoLeft, 20, 40);
  }
  
  //// draw everything
  for (MapTile tile : tiles) {
    tile.Display();
  }
  if (!hasEnemies) {
    for (ExpandTile tile : expandTiles) {
      tile.Display();
    }
  } else {
    for (Enemy enemy: enemies){
      enemy.Display();
    }
  }
  if (debuggingLevel % 2 == 1) {
    for (SpawnPoint point : spawnPoints) {
      point.Display();
    }
  }
  //// Cam Movement
  if (pressedKeys.contains(A)) {
    camX += 1.0 /zoom;
  } else if (pressedKeys.contains(D)) {
    camX -= 1.0 /zoom;
  }
  if (pressedKeys.contains(W)) {
    camY += 1.0 /zoom;
  } else if (pressedKeys.contains(S)) {
    camY -= 1.0 /zoom;
  }
  //// Cam Zoom with keyboard
  if (pressedKeys.contains((int) 'E')) {
    zoom=Math.min(maxZoom, zoom + 1);
  } else if (pressedKeys.contains((int) 'Q')) {
    zoom=Math.max(1, zoom - 1);
  }
  
  fill(0);
  text("x: " + camX + ". y: " + camY + ". z:" + str(zoom/20.0), 20, 20); // display zoom
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if (e>0) {
    zoom=Math.max(1, zoom - 1);
  } else if (e<0) {
    zoom=Math.min(maxZoom, zoom + 1);
  }
}

void keyPressed() {
  //// Only First Press
  if (!pressedKeys.contains(keyCode)) {
    FirstKeyPressed(keyCode);
  }

  //// Consistent pressed
  pressedKeys.add(keyCode);
}

void FirstKeyPressed(int keycode) {
  if (keycode == (int) '\t' ) {
    speed = (byte) (speed % 3 + 1);
  }
  if (keycode == (int) ' ' ) {
    paused = !paused;
  }
}

void keyReleased() {
  pressedKeys.remove(keyCode);
}

void mousePressed() {
  if (!hasEnemies) {
    for (ExpandTile tile : expandTiles) {
      if (tile.Interact(mouseX, mouseY)) {
        //// here we start next round
        break;
      }
    }
  }
}
