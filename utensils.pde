

Byte pickRandomFromArray(byte[] arr) {
  int rndnum = (int) random(0, arr.length);
  return arr[rndnum];
}
Byte pickRandomFromArrayList(ArrayList<Byte> arr) {
  int rndnum = (int) random(0, arr.size());
  return arr.get(rndnum);
}

boolean isAllState(boolean[] input, boolean state){
  boolean output = true;
  for(boolean b: input){
    if(b != state) output = false;
  }
  return output;
}

int countStates(boolean[] input, boolean state){
  int output = 0;
  for(boolean b: input){
    if(b == state) ++output;
  }
  return output;
}
