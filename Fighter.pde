class Fighter {
  int x ;
  int y ;
  PImage img ; 
  int speed ;

  private boolean up = false ;
  private boolean down = false ;
  private boolean left = false ;
  private boolean right = false ;
  private boolean space = false ;

  Fighter () {
    img = loadImage("img/fighter.png");
    speed = 8 ;
    x = width - 50 ;
    y = height /2 ;
  }

  void display () {   
    image(img,x,y);
  }

  void move () {
    if (up    && y - speed > 0      ) y -= speed ;
    if (down  && y + speed < height - img.height) y += speed ;
    if (right && x + speed < width - img.width  ) x += speed ;
    if (left  && x - speed > 0 ) x -= speed ;
  }


  void keyPressed (int keyCode) {
    switch (keyCode) {
    case UP    : 
      up = true ;   
      break ;
    case DOWN  : 
      down = true ; 
      break ;
    case LEFT  : 
      left = true ; 
      break ;
    case RIGHT : 
      right = true ;
      break ;
    }
    if(key == ' ') space = true;
  }
  void keyReleased (int keyCode) {
    switch (keyCode) {
    case UP    : 
      up =    false ; 
      break ;
    case DOWN  : 
      down =  false ; 
      break ;
    case LEFT  : 
      left =  false ; 
      break ;
    case RIGHT : 
      right = false ; 
      break ;
    }
    if(key == ' ')space = false;
  }
}
