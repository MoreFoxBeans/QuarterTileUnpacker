int TILE_WIDTH = 16;
int TILE_HEIGHT = 16;

//https://opengameart.org/content/seamless-tileset-template-ii
int[] template = {
  0,   4,   92, 112, 28,  124, 116, 64,
  20,  84,  87, 221, 127, 255, 245, 80,
  29,  117, 85, 95,  247, 215, 209, 1,
  23,  213, 81, 31,  253, 125, 113, 16,
  21,  69,  93, 119, 223, 255, 241, 17,
  5,   68,  71, 193, 7,   199, 197, 65,
};

int[] trMap = {0, 2, -1, -1, 3, 4, -1, 1};
int[] brMap = {0, 3, -1, -1, 2, 4, -1, 1};
int[] blMap = {0, 2, -1, -1, 3, 4, -1, 1};
int[] tlMap = {0, 3, -1, -1, 2, 4, -1, 1};

PImage tile5;
PGraphics original;
PGraphics converted;

boolean fileLoaded = false;
String outPath = "";

boolean getBit(int n, int k) { return ((n >> k) & 1) == 1; }

int getCorner(int n, int c) {
  int o = ((n | n << 8) >> (c * 2)) & 7;
  
  return o;
}

void setup() {
  size(128, 96, P2D);
  loop();
  
  selectInput("Select a tileset to use:", "fileSelected");
}

void drawTile(int x, int y, int bitmask) {
  int tr = trMap[getCorner(bitmask, 0)] * TILE_WIDTH;
  int br = brMap[getCorner(bitmask, 1)] * TILE_WIDTH;
  int bl = blMap[getCorner(bitmask, 2)] * TILE_WIDTH;
  int tl = tlMap[getCorner(bitmask, 3)] * TILE_WIDTH;
  
  converted.copy(tile5, tr + 8, 0, TILE_WIDTH / 2, TILE_HEIGHT / 2, x * TILE_WIDTH + 8, y * TILE_HEIGHT, TILE_WIDTH / 2, TILE_HEIGHT / 2);
  converted.copy(tile5, br + 8, 8, TILE_WIDTH / 2, TILE_HEIGHT / 2, x * TILE_WIDTH + 8, y * TILE_HEIGHT + 8, TILE_WIDTH / 2, TILE_HEIGHT / 2);
  converted.copy(tile5, bl, 8, TILE_WIDTH / 2, TILE_HEIGHT / 2, x * TILE_WIDTH, y * TILE_HEIGHT + 8, TILE_WIDTH / 2, TILE_HEIGHT / 2);
  converted.copy(tile5, tl, 0, TILE_WIDTH / 2, TILE_HEIGHT / 2, x * TILE_WIDTH, y * TILE_HEIGHT, TILE_WIDTH / 2, TILE_HEIGHT / 2);
}

void draw() {
  background(0);
  
  if (fileLoaded) {
    fileLoaded = false;
    
    converted.beginDraw();
    
    for (int y = 0; y < 6; y++) {
      for (int x = 0; x < 8; x++) {
        drawTile(x, y, template[y * 8 + x]);
      }
    }
    
    converted.endDraw();
    
    image(converted, 0, 0);

    selectOutput("Choose an image to write to:", "outSelected");
  }
  
  if (!outPath.equals("")) {
    converted.save(outPath);
    
    outPath = "";
    exit();
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
      tile5 = loadImage(path);
      fileLoaded = true;
      
      TILE_WIDTH = (int)round(tile5.width / 5);
      TILE_HEIGHT = (int)round(tile5.height);
      
      original = createGraphics(5*TILE_WIDTH, TILE_HEIGHT, P2D);
      converted = createGraphics(8*TILE_WIDTH, 6*TILE_HEIGHT, P2D);
    } else {
      javax.swing.JOptionPane.showMessageDialog(null, "Sorry! You may only load images of type \"png\", \"jpg/jpeg\", \"tga\", and \"gif\".");
      selectInput("Select a tileset to use:", "fileSelected");
    }
  }
}

void outSelected(File selection) {
  if (selection == null) {
    println("File selection cancelled :(");
    exit();
  } else {
    outPath = selection.getAbsolutePath();
    println(outPath);
  }
}
