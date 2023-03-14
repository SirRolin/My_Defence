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
byte debuggingLevel = 3;
byte speed = 1;
int level = 0;
long enemyPoints = 0;
int towerHealth = 100;
int enemyID = 0;


final int A     = 65;
final int S     = 83;
final int D     = 68;
final int W     = 87;
//final int MINUS = 107;
//final int PLUS  = 109;


void setup() {
  fullScreen();
  frameRate(10);
  rectMode(CENTER);
  tiles.add(new MapTile(new Coord(0, 0), (byte) -1));
}

void draw() {
  //// setting frames moment in time
  long timeOfFrame = millis() / 500;
  
  //// Updates
    //// Spawn of Enemies
  if(hasEnemies){
    boolean AnySpawnPointsOpen = false;
    for(SpawnPoint point: spawnPoints){
      if((point.lastSpawned + point.spawnCD) < timeOfFrame){
        AnySpawnPointsOpen = true;
        point.open = true;
      }
    }
    ////Spawn Enemies
    while(enemyPoints > 0 && AnySpawnPointsOpen){
      println("am I stuck?");
      for(SpawnPoint point: spawnPoints){
        if(point.open){
          Enemy tmpEnemy = new Enemy(point.coord, point.nextTile);
          point.open = false;
          enemyPoints -= tmpEnemy.pointsWorth;
          //point.lastSpawned += point.spawnCD;
          //tmpEnemy.nextTile = point.nextTile;
          enemies.add(tmpEnemy);
          break;
        }
      }
      AnySpawnPointsOpen = false;
      for(SpawnPoint point: spawnPoints){
        if((point.lastSpawned + point.spawnCD) < timeOfFrame){
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
  
  //// timeOfFrame?
  if (debuggingLevel % 4 - (debuggingLevel % 2) == 2) {
    text("time of frame: " + str(timeOfFrame), 20, 40);
    text("spawnPoint 1 last spawn time: " + str(spawnPoints.get(0).lastSpawned), 20, 60);
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
    speed = (byte) ((speed +  1) % 4);
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
