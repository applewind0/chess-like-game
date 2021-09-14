Piece[] piece;
PFont myFont;
String[] p_name = {"王", "金"};
int king_start[][] = { {8, 2} , {8, 17} };
int gold_start[][] = { {7, 2} , {7, 17} ,  {9, 2} , {9, 17} };
int piece_start[][][] = { king_start, gold_start };
// 王: 8,2 ; 8,17
// 金: 7/9,2 ; 7/9,17
// 木: 5,16 11,17 ; 
// 土: 5,17 11,16 ; 
// 水 2/12,17
// 火: 4/
int a = 8;
int b = 17;
boolean p = false;
void setup(){
  size( 550, 650 );
  // add piece loop
  piece = new Piece[6];
  int index = 0;
  for( int i = 0; i < piece_start.length; i++ ){
    for( int j = 0; j <  piece_start[i].length; j++){
      piece[index] = set_piece( p_name[i], piece_start[i][j][0], piece_start[i][j][1] );
      index++;
    }
  }
  
  myFont = createFont("標楷體",100);
  textFont(myFont);
  //noLoop();
}

Piece set_piece( String name, int x, int y ){
  Piece p = new Piece( x, y, name  );
  p.place( int(x*2/3 + 1/2), int(y*2/3 + 1/2) );
  return p;
}

void move_control_draw( Piece p ){
  p.control( mouseX, mouseY, mousePressed );
  p.draw();
}

void draw(){
  background( 255 );
  
  board();

  for( int i = 0; i < piece.length; i++ ){
    move_control_draw( piece[i] ); 
  }
  
  
}

void board(){
  int size = 50;
  stroke( 0 );
  for( int y = 1 ; y <= 11 ; y++ ){
    for( int x = 1 ; x <= 9 ; x++){
      fill( 255 );
      if( y==6 )
        fill( 200, 200, 240 );
      rect( x * size, y * size, size, size );
    }
  }
}

public class Piece{
  int bx, by, step;
  float x, y, px, py, // [x, y](currect), [px, py](previous)  
        size, block;  // piece size, block size
  String name;
  boolean follow, drag;
  Piece(int _x, int _y, String _name){
    name = _name;
    block = 50;
    size = block/3*2;
    x = _x * size + block/2;
    y = _y * size + block/2;
    px = -1;
    py = -1;
    bx = int( x / block );
    by = int( y / block );
    follow = false;
    drag   = false;
    step = 0;
  }
  
  public void draw(){
    fill( 255 );
    stroke( follow ? color( 255, 0, 0 ) : color( 0 ) );
    circle( x, y, size );
    fill( 0 );
    textSize( 16 );
    text( name, x - textWidth(name)/2, y + textWidth(name)/4 );
  }
  
  public void place( float tx, float ty ){
    p = false;
    int rx = int( tx / block ),
        ry = int( ty / block );
    if( rx > 0 && rx <= 9 && ry > 0 && ry <= 11 ){
      x = (rx + 1) * block - block/2;
      y = (ry + 1) * block - block/2;
    }
  }  
  public void place( int rx, int ry ){
    p = false;
    if( rx > 0 && rx <= 9 && ry > 0 && ry <= 11 ){
      x = (rx + 1) * block - block/2;
      y = (ry + 1) * block - block/2;
    }
  }
  
  public void control( float tx, float ty, boolean _drag ){
    if( !follow && _drag && sqrt((x-tx)*(x-tx) + (y-ty)*(y-ty)) <= size/2 ){
      px = x;
      py = y;
      follow = true;
    }else if( !_drag && follow ){
      follow = false;
      if ( !moving_rule( int(tx), int(ty) ) || int( ty / block ) == 6 ){
        place( px, py );
      }else{
        place( tx, ty );
      }
    }
    
    if( follow ){
      x = tx;
      y = ty;
    }
  }
  
  public boolean moving_rule( int tx, int ty ){
    boolean result = false;
    int bx  = int(px/block) , // input base position 
        by  = int(py/block) ,
        tbx = int(tx/block) ,
        tby = int(ty/block) ; // block based
    switch( name ){
      case "王":
        //print("Pos: ");
        //println(abs(tbx-bx), abs(tby-by), abs(tbx-bx) <= 1 && abs(tbx-bx) <=1, tbx, tby, bx, by);
        if( abs(tbx-bx) <= 1 && ( abs(tby-by) <= 1 || (tby==5 && by==7) || (tby==7 && by==5) ) )
          result = true;
      case "金":
        //print("Pos: ");
        //println(abs(tbx-bx), abs(tby-by), abs(tbx-bx) <= 1 && abs(tbx-bx) <=1, tbx, tby, bx, by);
        if( step == 0 ){
           if( ( abs(tbx-bx) <= 3 && tby-by==0 ) || ( abs(tby-by) <= 3 && tbx-bx==0 ) ) 
             result = true;
        }
        else{
          if( ( abs(tbx-bx) <= 2 && tby-by==0 ) || ( abs(tby-by) <= 2 && tbx-bx==0 ) ||  ( tbx-bx==0 && ( (tby==5 && by==7) || (tby==7 && by==5) )) )
            result = true;
        }
        
      break;
    }
    if( result == true )
      step ++;
    return result;
  }
};
