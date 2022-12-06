final int TILE_WIDTH = 16;
final int TILE_HEIGHT = 16;

PImage tile5;
PGraphics original;

boolean fileLoaded = false;

void setup() {
  size(200, 200);
  loop();
  
  original = createGraphics(5*TILE_WIDTH, TILE_HEIGHT);
  
  selectInput("Select a tileset to use:", "fileSelected");
}

void draw() {
  if (fileLoaded) {
    noLoop();
    image(tile5, 0, 0);
  }
}

void fileSelected(File selection) {
  if (selection == null) {
    println("File selection cancelled :(");
    exit();
  } else {
    String path = selection.getAbsolutePath();
    println(path);
    
    String extension = getExtension(path);
    
    String[] validExtensions = new String[] {"gif", "jpg", "jpeg", "tga", "png"};
    
    boolean valid = false;
    
    for (int i = 0; i < validExtensions.length; i++) {
      if (validExtensions[i].equals(extension)) {
        valid = true;
      }
    }
    
    if (valid) {
      tile5 = loadImage(selection.getAbsolutePath());
      fileLoaded = true;
    } else {
      javax.swing.JOptionPane.showMessageDialog(null, "Sorry! You may only load images of type \"png\", \"jpg/jpeg\", \"tga\", and \"gif\".");
      selectInput("Select a tileset to use:", "fileSelected");
    }
  }
}
