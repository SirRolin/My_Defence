import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import javax.swing.filechooser.FileSystemView;
import java.io.FileWriter;

static class FileIO{
  private static String documentFolder;
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
    } catch (IOException e) {
    }
    return data;
  }
  public static ArrayList<String> readFileData(String path, boolean skipHeader, boolean skipEmpty, String[] defaultFileString) {
    ArrayList<String> output = readFileData(path, skipHeader, skipEmpty);
    if(output.size()==0){
      File file = new File(path);
      File folder = file.getParentFile();
      folder.mkdirs();
      try {
        FileWriter fw = new FileWriter(file);
        for(String line: defaultFileString){
          fw.write(line + System.lineSeparator());
        }
        fw.close();
      } catch (IOException e) {
        System.out.println("FileIO.readFileData - " + path + " is not accessible");
        return output;
      }
    }
    output = readFileData(path, skipHeader, skipEmpty);
    return output;
  }
  public static String getDocument(){
    if(documentFolder == null) {
      documentFolder = FileSystemView.getFileSystemView().getDefaultDirectory().getPath();
    }
    return documentFolder;
  }
}
