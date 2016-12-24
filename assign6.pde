class GameState
{
	static final int START = 0;
	static final int PLAYING = 1;
	static final int END = 2;
}
class Direction
{
	static final int LEFT = 0;
	static final int RIGHT = 1;
	static final int UP = 2;
	static final int DOWN = 3;
}
class EnemysShowingType
{
	static final int STRAIGHT = 0;
	static final int SLOPE = 1;
	static final int DIAMOND = 2;
	static final int STRONGLINE = 3;
}
class FlightType
{
	static final int FIGHTER = 0;
	static final int ENEMY = 1;
	static final int ENEMYSTRONG = 2;
}

int state = GameState.START;
int currentType = EnemysShowingType.STRAIGHT;
int enemyCount = 8;
Enemy[] enemys = new Enemy[enemyCount];
Fighter fighter;
//Background bg;
FlameMgr flameMgr;
Treasure treasure;
HPBar hpDisplay;
boolean isMovingUp;
boolean isMovingDown;
boolean isMovingLeft;
boolean isMovingRight;
int bulletCount = 5;
Bullet[] bullets = new Bullet[bulletCount];
int time;
int wait = 4000;

PImage backgroundImg1;
  PImage backgroundImg2;
  PImage start1;
  PImage start2;
  PImage end1;
  PImage end2;
  
  
  int x,y;



void setup () {
	size(640, 480);
	flameMgr = new FlameMgr();
	//bg = new Background();
	treasure = new Treasure();
	hpDisplay = new HPBar();
	fighter = new Fighter(20);

  backgroundImg1 = loadImage("img/bg1.png");
  backgroundImg2 = loadImage("img/bg2.png");
  start1 = loadImage("img/start1.png");
  start2= loadImage("img/start2.png");
  end1 = loadImage("img/end1.png");
  end2 = loadImage("img/end2.png");
}

void draw()
{	
	
	switch(state){
      case GameState.START :
      
      image(start2,0,0,640,480);
      if(mouseX> 210 && mouseX< 440 && mouseY > 370 && mouseY< 410){
        image(start1,0,0,640,480);
        
      }
      
      break;
   case GameState.PLAYING:
		// background
      image(backgroundImg1,x,0,640,480);
      image(backgroundImg2,y,0,640,480);
      x++;
      y++;
      if(y==640){
        y=-640;
      }
      if(x==640){
        x=-640;
      }
		treasure.draw();
		flameMgr.draw();
		fighter.draw();

		//enemys
		if(millis() - time >= wait){
			addEnemy(currentType++);
			currentType = currentType%4;
		}		

		for (int i = 0; i < enemyCount; ++i) {
			if (enemys[i]!= null) {
				enemys[i].move();
				enemys[i].draw();
				if (enemys[i].isCollideWithFighter()) {
					fighter.hpValueChange(-20);
					flameMgr.addFlame(enemys[i].x, enemys[i].y);
					enemys[i]=null;
				}
				for(int j = 0;j<5;j++){
					if (bullets[j] != null && enemys[i] != null) {
						if (enemys[i].isCollideWithBullet(bullets[j])) {
							flameMgr.addFlame(enemys[i].x, enemys[i].y);
							bullets[j] = null;
							enemys[i] = null;
							}
						}
					}
				}
		}

		// 這地方應該加入Fighter 血量顯示UI
		hpDisplay.updateWithFighterHP(fighter.hp);
		
		//bullets
		for(int i = 0;i<bulletCount;i++){
			if(bullets[i] != null){
				bullets[i].move();
				bullets[i].draw();
			}
		}
	   break;

		//bullets crush	

	case GameState.END:
		image(end2,0,0,640,480);
              if(mouseX> 210 && mouseX< 440 && mouseY > 310 && mouseY< 350){
                image(end1,0,0,640,480);
              if (mousePressed == true) { 
                state=GameState.PLAYING;
                //initGame();
            }
          }
          break;
	}
}
boolean isHit(int ax, int ay, int aw, int ah, int bx, int by, int bw, int bh)
{
	// Collision x-axis?
    boolean collisionX = (ax + aw >= bx) && (bx + bw >= ax);
    // Collision y-axis?
    boolean collisionY = (ay + ah >= by) && (by + bh >= ay);
    return collisionX && collisionY;
}

void keyPressed(){
  switch(keyCode){
    case UP : isMovingUp = true ;break ;
    case DOWN : isMovingDown = true ; break ;
    case LEFT : isMovingLeft = true ; break ;
    case RIGHT : isMovingRight = true ; break ;
    default :break ;
  }
}
void keyReleased(){
  switch(keyCode){
	case UP : isMovingUp = false ;break ;
    case DOWN : isMovingDown = false ; break ;
    case LEFT : isMovingLeft = false ; break ;
    case RIGHT : isMovingRight = false ; break ;
    default :break ;
  }
  if (key == ' ') {
  	if (state == GameState.PLAYING) {
		fighter.shoot();
	}
  }
  
}

void mousePressed(){
  if(mouseX> 210 && mouseX< 440 && mouseY > 370 && mouseY< 410){
  state = GameState.PLAYING; 
  }
}
