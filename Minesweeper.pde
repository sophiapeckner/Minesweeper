import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private final static int NUM_ROWS = 5;
private final static int NUM_COLS = 5;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int r = 0; r < NUM_ROWS; r++) {
      for (int c = 0; c < NUM_COLS; c++) {
        buttons[r][c] = new MSButton(r, c);  
      }
    }
    
    for (int i = 0; i < (NUM_ROWS/2); i++) {
      setMines();
    }
}
public void setMines()
{
    //your code
    int row = (int) (Math.random() * NUM_ROWS);
    int col = (int) (Math.random() * NUM_COLS);
    
    if (!mines.contains(buttons[row][col])) {
      mines.add(buttons[row][col]);
      println(row, col);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    for (int i = 0; i < mines.size(); i++) {
      if (!mines.get(i).flagged)
        return false;
    }
    return true;
}
public void displayLosingMessage()
{
    for (int i = 0; i < mines.size(); i++) {
      if (!mines.get(i).flagged)
        mines.get(i).clicked = true;
    }
    //your code here
    String[][] m = { {"Y", "O", "U"}, {"L", "O", "S", "E"} };
    for (int i = 0; i < m.length; i++) {
      for (int j = 0; j < m[i].length; j++) {
        buttons[i][j].clicked = false;
        buttons[i][j].flagged = false;
        buttons[i][j].myLabel = m[i][j];
      }
    }
}
public void displayWinningMessage()
{
    //your code here
  String[][] m = { {"Y", "O", "U"}, {"W", "I", "N"} };
  for (int i = 0; i < m.length; i++) {
    for (int j = 0; j < m[i].length; j++) {
      buttons[i][j].clicked = false;
      buttons[i][j].flagged = false;
      buttons[i][j].myLabel = m[i][j];
    }
  }
}
public boolean isValid(int r, int c)
{
    //your code here
    if ( (r < NUM_ROWS && r >= 0) && (c < NUM_COLS && c >= 0)) {
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    //your code here
  
    for (int r = row-1; r < row+2; r++) {
      for (int c = col-1; c < col+2; c++) {
        if (isValid(r, c) && mines.contains(buttons[r][c])) {
          numMines++;
        }
      }
    }
    if (mines.contains(buttons[row][col]))
      numMines--;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        //your code here
        if (mouseButton == RIGHT) {
          flagged = !flagged;
          if (flagged == false)
            clicked = false; // this way it doesn't turn grey
        }
        else if (mines.contains(this)) {
          displayLosingMessage();
        }
        else if (countMines(myRow, myCol) > 0) {
          myLabel = String.valueOf( countMines(myRow, myCol) );
        }
        else { 
          for (int r = myRow-1; r < myRow+2; r++) {
            for (int c = myCol-1; c < myCol+2; c++) {
              if(isValid(r, c) && !buttons[r][c].clicked)
                buttons[r][c].mousePressed();
            }
          }
        }
        
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}
