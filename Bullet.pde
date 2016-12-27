class Bullet {
  int x, y;
  PImage img;
  int speed;
  boolean state;

  Bullet (int x, int y) {
    speed = 3;
    img = loadImage("img/shoot.png");
    this.x=x;
    this.y=y;
    state = false;
  }
  void display(){
    image(img, x, y);
  }
  void move(){
    x = x - speed;
  }
}
