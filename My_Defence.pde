import java.util.HashSet;

//// debug
byte debuggingLevel = 0; // enum 0 - 15
//// 1 = spawn points drawn & keypresses shown
//// 2 = Time and Delta
//// 4 = Spawn Cooldowns
//// 8 = Interchangable - right now: get progress value of hovered tile.

//// declare global variable
float camX;
float camY;
int zoom; // ends up deviding with 20
int maxZoom;
int towerHealth;
int enemyID;
long enemyPoints;
ArrayList<MapTile> tiles;
ArrayList<ExpandTile> expandTiles;
ArrayList<SpawnPoint> spawnPoints;
ArrayList<Enemy> enemies;
ArrayList<Tower> towers;
ArrayList<Projectile> projectiles;
boolean hasEnemies;
boolean paused;

//// declare and initiale global variables that doesn't get reset with a new game
byte speed = 1;
int level = 0;
final int updateRate = 60;
final int tileSize = 100;
TowerType cursorTower;
TowerHandler towerHandler = new TowerHandler(); //// cause processing does not allow me to make it static
HashSet<Integer> pressedKeys = new HashSet<Integer>();

//// used for Source: https://forum.processing.org/two/discussion/18478/deltatime.html
long timeOfFrame;


void setup() {
  fullScreen();
  frameRate(updateRate);
  rectMode(CENTER);
  towerHandler.initiateTowers();
  resetGame();
}

void draw() {
  //// Delta Time for time control no matter framerate.
  //// Source: https://forum.processing.org/two/discussion/18478/deltatime.html
  double delta = (-timeOfFrame + (timeOfFrame = frameRateLastNanos))/1e6d;
  //// End of Source (I renamed prev to timeOfFrame, cause it made more sense)

  //// Limiting Delta Time so it doesn't cause unwanted sideeffects at very low framerates.
  if(delta > 50) delta = 50;

//// Updates
  for(int updateInFrame = 0; !paused && updateInFrame < speed; ++updateInFrame){
    //// Spawn of Enemies
    if(hasEnemies){
      //// update all spawns
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
            //// initiate a new enemy
            Enemy tmpEnemy = new Enemy(point.coord, point.nextTile);
            //// close the spawner
            point.open = false;
            //// pay for the cost of spawning
            enemyPoints -= tmpEnemy.pointsWorth;
            //// set the spawning CD to enemies base CD devided by
            point.spawnCD = tmpEnemy.spawnCD / 
                //// the sum of 1 and the spawners CD reduction (a 10th the distance to the tower) times 
                (1.0 + point.getSpawnCDR()/10.0) * 
                //// the amount of spawners (so more spawns doesn't mean denser enemy hordes) times
                spawnPoints.size() * 
                //// 2 divided by the level (to increase spawn rate, otherwise levels just become longer and not harder)
                (2 / (float) level);
            
            //// Finally we add the enemy to the list of enemies.
            enemies.add(tmpEnemy);
            break;
          }
        }
        //// check if we can spawn more this frame
        AnySpawnPointsOpen = false;
        for(SpawnPoint point: spawnPoints){
          if(point.open){
            AnySpawnPointsOpen = true;
          }
        }
        if(!AnySpawnPointsOpen) break;
      }
  
      ////Update Enemies
      for(int i = enemies.size() - 1; i >= 0; --i){
        enemies.get(i).Update(delta);
      }
    
      //// Update Towers
      for(int i = towers.size() - 1; i >= 0; --i){
        towers.get(i).Update(delta);
      }
    }
    
    //// Update Projectiles
    for(int i = projectiles.size() - 1; i >= 0; --i){
      projectiles.get(i).Update(delta);
    }
  }
  
  //// if we lose, we reset the game. no warning, sorry.
  if(towerHealth <= 0) {
    resetGame();
  }
  
  //// Cam Movement
  if (pressedKeys.contains((int) 'A')) {
    camX += 1.0 / zoom;
  } else if (pressedKeys.contains((int) 'D')) {
    camX -= 1.0 / zoom;
  }
  if (pressedKeys.contains((int) 'W')) {
    camY += 1.0 / zoom;
  } else if (pressedKeys.contains((int) 'S')) {
    camY -= 1.0 / zoom;
  }
  
  //// Cam Zoom with keyboard
  if (pressedKeys.contains((int) 'E')) {
    zoom=Math.min(maxZoom, zoom + 1);
  } else if (pressedKeys.contains((int) 'Q')) {
    zoom=Math.max(1, zoom - 1);
  }
  
  //// Display
  background(255); //// clear display
  fill(0);
  
  //// draw everything
  for (MapTile tile : tiles) {
    tile.Display();
  }
  //// if no enemies draw expansion tiles
  if (!hasEnemies) {
    for (ExpandTile tile : expandTiles) {
      tile.Display();
    }
  //// otherwise draw enemies
  } else {
    for (Enemy enemy: enemies){
      enemy.Display();
    }
  }
  //// draw the towers
  for (Tower t: towers){
    t.Display();
  }
  //// draw the projectiles
  for (Projectile p: projectiles){
    p.Display();
  }
  
  
  
  
  
  //// UI
  fill(0);
  textSize(20);
  
  //// Level
  text("Level: " +str(level), width/2, 20);
  
  //// Enemies on map
  text("Enemies: " + str(enemies.size()) + " - " + str((int) enemyPoints) + " enemy points remaining.", width/2, 40);
  
  //// Health
  text("Health: " + str(towerHealth) + "/100", 20, height - 20);
  
  //// Top left camera info.
  text("x: " + camX + ". y: " + camY + ". z:" + str(zoom/20.0), 20, 20); // display zoom
  
  
  //// level 1 debugging
  if (debuggingLevel % 2 == 1) {
  //// Debugging How Many Keys
    String debugasdKeys = "";
    for (int debugKey : pressedKeys) {
      debugasdKeys += str(debugKey) + "\n";
    }
    text(debugasdKeys, width-20, 20);
  
  //// Debug show spawn points
    for (SpawnPoint point : spawnPoints) {
      point.Display();
    }
  }
  
  //// Debugging info Top Left
  String infoLeft = "";
  fill(0);
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
  
  //// get progress value of hovered tile.
  if (debuggingLevel % 16 >= 8) {
    Coord mouseCoord = new Coord(mouseX, mouseY).screenToWorld();
    for(MapTile tile: tiles){
      if((abs(mouseCoord.x - tile.coord.x) < 0.5) && (abs(mouseCoord.y - tile.coord.y) < 0.5)) {
        infoLeft += "Tile progress: " + tile.progress + "\n";
        break;
      }
    }
  }
  
  //// Debugging output 
  if (infoLeft.length() > 0) {
    text(infoLeft, 20, 40);
  }
  
  
  
  ////Cursor
  if(cursorTower != null){
    cursorTower.DisplayRange(mouseX, mouseY);
    cursorTower.Display(mouseX, mouseY);
  }
}

void resetGame(){
  camX = 0;
  camY = 0;
  zoom = 20; // ends up deviding with 20
  maxZoom = 60; // ends up deviding with 20
  tiles = new ArrayList();
  expandTiles = new ArrayList();
  spawnPoints = new ArrayList();
  enemies = new ArrayList();
  towers = new ArrayList();
  projectiles = new ArrayList();
  hasEnemies = false;
  level = 0;
  enemyPoints = 0;
  towerHealth = 100;
  enemyID = 0;
  cursorTower = null;
  MapTile towerTile = new MapTile(new Coord(0, 0), (byte) -1);
  towerTile.progress = 1;
  tiles.add(towerTile);
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
  if (keycode == (int) 'G'){
    cursorTower = towerHandler.getTower(0);
  }
}

void keyReleased() {
  pressedKeys.remove(keyCode);
}

void mousePressed() {
  Coord mouseCoord = new Coord(mouseX, mouseY);
  Coord mouseWorldCoord = mouseCoord.screenToWorld(); 
  if (!hasEnemies && cursorTower == null) {
    for (ExpandTile tile : expandTiles) {
      if (tile.Interact(mouseX, mouseY)) {
        //// here we start next round
        break;
      }
    }
  }
  if(cursorTower != null){
    for(MapTile tile: tiles){
      if((abs(tile.coord.x - mouseWorldCoord.x) < 0.5) && (abs(tile.coord.y - mouseWorldCoord.y) < 0.5)){
        towers.add(new Tower(cursorTower, mouseWorldCoord));
        cursorTower = null;
        break;
      }
    }
  }
}
