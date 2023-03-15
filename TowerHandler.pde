import java.util.ArrayList;

import java.util.Scanner;
import java.io.File;
import java.io.FileWriter;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.lang.Exception;

//// a class to load towers from a file
class TowerHandler {
  //// stored towers
  private ArrayList<TowerType> towers;

  //// initialise
  public void initiateTowers() {
    //// get data via the FileIO class I made
    ArrayList<String> data = FileIO.readFileData("C:\\Users\\nicol\\Documents\\GitHub\\My_Defence/Data/Towers.txt", false, true);
    //// initialise towers
    towers = new ArrayList<>();
    int lineNumber = 0;
    //// for each line deserialise the line and populate a tower
    for (String s : data) {
      ++lineNumber;
      String[] splitLine = s.split(",");
      //// TO DO: make into a function to make this less of a pain.
      //// initialise cost
      int cost;
      try {
        cost = Integer.parseInt(splitLine[0].trim());
      }
      catch (Exception e) {
        //// if something went from, skip this tower
        println("Error in loading tower at line: " + lineNumber)
        continue;
      }
      int baseDamage;
      try {
        baseDamage = Integer.parseInt(splitLine[1].trim());
      }
      catch (Exception e) {
        //// if something went from, skip this tower
        println("Error in loading tower at line: " + lineNumber)
        continue;
      }
      float fireRate;
      try {
        fireRate = Float.parseFloat(splitLine[2].trim());
      }
      catch (Exception e) {
        //// if something went from, skip this tower
        println("Error in loading tower at line: " + lineNumber)
        continue;
      }
      int projectile;
      try {
        projectile = Integer.parseInt(splitLine[3].trim());
      }
      catch (Exception e) {
        //// if something went from, skip this tower
        println("Error in loading tower at line: " + lineNumber)
        continue;
      }
      int tColor;
      try {
        tColor = Integer.parseInt(splitLine[4].trim());
      }
      catch (Exception e) {
        //// if something went from, skip this tower
        println("Error in loading tower at line: " + lineNumber)
        continue;
      }
      int aColor;
      try {
        aColor = Integer.parseInt(splitLine[5].trim());
      }
      catch (Exception e) {
        //// if something went from, skip this tower
        println("Error in loading tower at line: " + lineNumber)
        continue;
      }
      float size;
      try {
        size = Float.parseFloat(splitLine[6].trim());
      }
      catch (Exception e) {
        //// if something went from, skip this tower
        println("Error in loading tower at line: " + lineNumber)
        continue;
      }
      float range;
      try {
        range = Float.parseFloat(splitLine[7].trim());
      }
      catch (Exception e) {
        //// if something went from, skip this tower
        println("Error in loading tower at line: " + lineNumber)
        continue;
      }
      
      //// initialise the tower
      TowerType tempTowerType = new TowerType(cost, baseDamage, fireRate, projectile, tColor, aColor, size, range);
      
      //// add it to the list of available towers
      towers.add(tempTowerType);
    }
  }
  //// get a tower from the list
  public TowerType getTower(int index) {
    //// if it's out of the index get null and log error
    if (index > towers.size()) {
      println("tried getting non existing tower type from too high index");
      return null;
    } else {
      return towers.get(index);
    }
  }
}
