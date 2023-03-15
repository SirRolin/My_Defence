import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;

static class FileIO{
  public static ArrayList<String> readFileData(String path, boolean skipHeader, boolean skipEmpty) {
    ArrayList<String> data = new ArrayList<String>();
    File file = new File(path);
    try {
        Scanner sc = new Scanner(file);
        if(skipHeader) sc.nextLine();
        while (sc.hasNextLine()) {
          String line = sc.nextLine();
          if (skipEmpty && line == "") continue;
          data.add(line);
        }
        sc.close();
    } catch (FileNotFoundException e) {
        System.out.println("FileIO.readFileData - " + path + " not found");
    } catch (IOException e) {
        System.out.println("FileIO.readFileData - " + path + " is not accessible");
    }
    return data;
  }
}
