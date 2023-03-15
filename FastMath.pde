import java.lang.Math;

//// my library to save sqrt results and approximate those close to the precise once.
public static class FastMath {
  private static int precisionsIn0to1 = 100; //// store every value from 0 to 1 in intervals of 1 / precisionsIn0to1 = 0.01.
  private static Double[] mySqrts = new Double[precisionsIn0to1 + 2]; //// cache

  //// a hopefully faster sqrt method that caches the most common (0 to 1) values.
  public static double mySqrt(float input) {
    //// I am not going into unreal numbers with this. the normal sqrt doesn't even do that.
    //// (I could, but it isn't useful unless I am doing quantum physics... which shouldn't be hasted)
    if (input<0) {
      println("input too low: " + input + "Returning 0;");
      return 0;
    }

    //// if input is higher than 1 it means that the quick was would be really inprecise, so we default to the slow one.
    if (input > 1) {
      return Math.sqrt((double) input);
    }

    //// getting the index of the cached values
    int floorInput = (int) (input*precisionsIn0to1);
    //// flooring the input to the lower value of precision.
    float flooredToInterval = floorInput / ((float) precisionsIn0to1);

    //// if the value is one that should be cached and is cached output the cache
    if (flooredToInterval == input && mySqrts[floorInput] != null) {
      return mySqrts[floorInput];

      //// otherwise check if the 2 closest caches is initialised, if they are output a linear value between them depending on destince between them.
    } else if (input > 0 && mySqrts[floorInput] != null && mySqrts[floorInput+1] != null) {
      return mySqrts[floorInput] * ((input % (1.0 / (float) precisionsIn0to1)) * precisionsIn0to1) +
        mySqrts[floorInput+1] * (((1.0/(float) precisionsIn0to1) - (input % (1.0 / (float) precisionsIn0to1))) * precisionsIn0to1);

      //// Otherwise cache the once that's not cached and start over (as they are both now cached, it wouldn't get back here).
    } else {
      if (mySqrts[floorInput] == null) {
        mySqrts[floorInput] = Math.sqrt((double) input - (input % (1.0 / (float) precisionsIn0to1)));
      }
      if (mySqrts[floorInput+1] == null) {
        mySqrts[floorInput+1] = Math.sqrt((double) input - (input % (1.0 / (float)precisionsIn0to1)) + (1.0 / (float) precisionsIn0to1));
      }
      return mySqrt(input);
    }
  }

  //// normalise 2 floats so they total 1.
  public static float[] normalise(float xDiff, float yDiff) {
    //// Saving if they are negative or not
    boolean negX = xDiff<0?true:false;
    boolean negY = yDiff<0?true:false;
    
    //// getting the sum of the absolute values.
    float xy = abs(xDiff)+abs(yDiff);
    
    //// making the sum of the 2 values = 1
    xDiff = abs(xDiff / xy);
    yDiff = abs(yDiff / xy);
    
    //// if neither off them are 0 do the square root to normalise
    if (!(xDiff == 0 || yDiff == 0)) {
      float tempXDiff = (float) FastMath.mySqrt(1 - (yDiff));
      yDiff = (float) FastMath.mySqrt(1 - (xDiff));
      xDiff = tempXDiff;
    }
    
    //// reapplying negatives
    xDiff *= (negX?-1:1);
    yDiff *= (negY?-1:1);
    
    //// putting the output into an array (cause java doesn't do multiple return values unfortunately).
    float[] output = {xDiff, yDiff};
    return output;
  }
}
