final int enemyAmount = 8 ;

Enemy[] enemyArray = new Enemy[enemyAmount] ;
Bullet[] bullet = new Bullet[6];
// enemy states
final int E_LINE = 0    ;
final int E_SLASH = 1   ; 
final int E_DIAMOND = 2 ;
final int E_BOSS = 3    ;

// enemy state
int enemyState ;
int state;
final int start=0, play=1, lose=2;

// FlameManager 
FlameManager flameManager ; 
final int yourFrameRate = 30 ;
Fighter fighter ; 
Treasure treasure;
HPBar hpbar;

// shared images ; 
PImage enemyImg, bg1, bg2;
PImage end1, end2, start1, start2;
float bgR;
float hp = 40;
void setup (){
  size(640, 480);
  enemyImg = loadImage("img/enemy.png");
  bg1 = loadImage( "img/bg1.png" ); 
  bg2 = loadImage( "img/bg2.png" ); 
  start1= loadImage("img/start1.png");
  start2= loadImage("img/start2.png");
  end1= loadImage("img/end1.png");
  end2= loadImage("img/end2.png");
  enemyState = E_LINE ;
  arrangeLineEnemy() ;
  fighter      = new Fighter ();
  flameManager = new FlameManager( yourFrameRate / 5 ) ;
  treasure =new Treasure();
  hpbar = new HPBar();
  bullet[0]= new Bullet(width+1000, height);
  bullet[0].state=true;
  for (int j=1; j<6; j++){
    bullet[j]=new Bullet(width+65*j, height);
  }
  // this means update 5 images in 1 second.
}

void draw (){
  switch(state){
  case start:
    image(start2, 0, 0);
    if (mouseX>200 &&mouseX<470&& mouseY>367&& mouseY<425){
      if (mousePressed){
        state = play;
      } else {
        image(start1, 0, 0);
      }
    }
    break;
  case play:
    image(bg1, bgR, 0);
    image(bg2, bgR-640, 0);
    image(bg1, bgR-1280, 0);
    bgR = bgR + 1;
    bgR = bgR % 1280;
    //===============
    //  ENEMY COLLISION TEST 
    //===============

    for (int i = 0; i < enemyAmount; i++){
      enemyArray[i].move() ;
      if (enemyArray[i].isHit(fighter.x, fighter.y, fighter.img.width, fighter.img.height )){
        flameManager.add(enemyArray[i].x, enemyArray[i].y );
        enemyArray[i].x = width ;
        
          enemyArray[i].hp();  
        
      }
      enemyArray[i].display();
      for (int j=1; j<6; j++){
        if (enemyArray[i].isHit(bullet[j].x, bullet[j].y, bullet[j].img.width, bullet[j].img.height )&&bullet[j].state==true){
          enemyArray[i].life--;
          bullet[j].state=false;
          bullet[j].x=width+65*i;
          if (enemyArray[i].dead()){
            flameManager.add(enemyArray[i].x, enemyArray[i].y );
            enemyArray[i].x = width ;
          }
        }
      }
    }
    for (int j=1; j<6; j++){
      if (bullet[j].state){
        bullet[j].move();
        bullet[j].display();
      }if (bullet[j].x<(0-bullet[j].img.width)){
        bullet[j].state = false;
        bullet[j].x = width+65*j;
      }
    }
    flameManager.display();
    fighter.move();
    fighter.display();  
    treasure.display();
    if (treasure.isHit(fighter.x, fighter.y, fighter.img.width, fighter.img.height )) {
      hp = treasure.size == 1 ? hp+20 : hp+40;
      treasure = new Treasure();
    }if(hp <= 0){
      state = lose;
    }if(hp >= 200){
      hp = 200;
    }
    hpbar.display(hp);
    if (enemyFinished()) {

      // switch to new enemyState 
      enemyState = (enemyState + 1) % 4 ;

      // arrange enemies to new shape. 
      switch (enemyState){
      case E_LINE :   
        arrangeLineEnemy() ;   
        break ;
      case E_SLASH :  
        arrangeSlashEnemy() ;  
        break ;
      case E_DIAMOND : 
        arrangeDiamondEnemy() ; 
        break ;
     
      }
    }
    break;
  case lose:
    image(end2, 0, 0);
    if (mouseX>200 &&mouseX<470&& mouseY>308&& mouseY<350){
      if (mousePressed){
        state= play;
        hp = 40;
        enemyState = E_LINE ;
        arrangeLineEnemy() ;
        fighter      = new Fighter ();
        flameManager = new FlameManager( yourFrameRate / 5 ) ;
        treasure =new Treasure();
        hpbar = new HPBar();
        bullet[0]= new Bullet(width+1000, height);
        bullet[0].state=true;
        for (int j=1; j<6; j++)
        {
          bullet[j] = new Bullet(width+65*j, height);
        }
      }else{
        image(end1, 0, 0);
      }
    }
  }
}
void keyPressed()
{
  fighter.keyPressed(keyCode) ;
  if (fighter.space){
    for (int i=1; i<6; i++){
      if (bullet[i].state==false&&(abs(fighter.x-bullet[i-1].x)>60)&&bullet[i-1].state==true){
        int shootN=0;
        for (int j=1; j<6; j++){
          if (j!=i&&(abs(fighter.x-bullet[j].x)>60)){
            shootN++;
            if (shootN==4){
              bullet[i]=new Bullet(fighter.x-30, fighter.y+10);
              bullet[i].state=true;
              break;
            }
          }
        }
      }
    }
  }
  // +_+ : don't fordet to shoot bullet.
}
void keyReleased(){
  fighter.keyReleased(keyCode) ;
}








//===============
//  FUNCTIONS :
//===============
//  use them directly.

boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh){
  // Collision x-axis?
  boolean collisionX = (ax + aw >= bx) && (bx + bw >= ax);
  // Collision y-axis?
  boolean collisionY = (ay + ah >= by) && (by + bh >= ay);

  return collisionX && collisionY;
}


boolean enemyFinished() { 

  // if all enemy is out of screen    -> return true
  // if any enemy is inside of screen -> return false 

  for (int i = 0; i < 8; i++) {
    if (enemyArray[i].x < width){
      return false ;
    }
  }
  return true ;
}


void arrangeLineEnemy (){
  float  y = random (0, 480 - 5 * enemyImg.height);
  for (int i = 0; i < 8; i++){
    if (i < 5){
      enemyArray[i] = new Enemy( -50 - i * (enemyImg.width + 10), y ) ;
    }else{
      enemyArray[i] = new Enemy( width, y ) ;
    }
  }
}

void arrangeSlashEnemy (){
  float y = random (0, 480 - 5 * enemyImg.width);
  for (int i = 0;i < 8; i++){
    if (i < 5 ){
      enemyArray[i] = new Enemy(-50 - i*51, y + i*enemyImg.height);
    }else{
      enemyArray[i] = new Enemy(width, y);
    }
  }
}
void arrangeDiamondEnemy (){
  float cx = -250 ;
  float cy = random(0 + 2 * enemyImg.height, 480 - 3 * enemyImg.height ) ;  
  int numPerSide = 3 ;

  int index = 0;
  for (int i = 0; i < numPerSide - 1; i++){
    int rx = numPerSide - 1 - i ;
    int ry = i ;

    enemyArray[index++] = new Enemy( cx + rx * enemyImg.width, cy + ry * enemyImg.height );
    enemyArray[index++] = new Enemy( cx - rx * enemyImg.width, cy - ry * enemyImg.height );
    enemyArray[index++] = new Enemy( cx + ry * enemyImg.width, cy - rx * enemyImg.height );
    enemyArray[index++] = new Enemy( cx - ry * enemyImg.width, cy + rx * enemyImg.height );
  }
}


