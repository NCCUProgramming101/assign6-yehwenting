class HPBar {
  int x , y ;
  PImage img ;
  
  HPBar (){
    x = 10;
    y = 10;
    img = loadImage("img/hp.png"); 
  }
  
  void display(float hp){
    
    noStroke();
    fill(255, 0, 0);
    rect(19, 10, hp, 30);
    image(img,x,y);
   
  }
}
