class Treasure {
  float x, y;
  float size;
  PImage img;
  
  Treasure (){
    size = random(0,1) < 0.5 ? 1 :1.4;
    img = loadImage("img/treasure.png");
    x = random(width-size*img.width);
    y = random(height-size*img.height);
  }
  
  void display(){
    image(img, x, y, size*img.width, size*img.height);
  }
  void hp(){
    hp = treasure.size == 1 ? hp+19.5 : hp+39;
  }
  boolean isHit (int bx, int by, int bw, int bh )
  {
    boolean collisionX = (this.x + this.img.width*size >= bx) && (bx + bw >= this.x);
    boolean collisionY = (this.y + this.img.height*size >= by) && (by + bh >= this.y);
    return collisionX && collisionY;
  }
  

}
