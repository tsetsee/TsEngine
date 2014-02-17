import 'dart:html';

class Sprite {
  CanvasElement canvas;
  CanvasRenderingContext2D context;
  ImageElement img;
  int frame;
  int sframe;
  int eframe;
  int maxframe;
  
  int offsetX;
  int offsetY;
  int x;
  int y;
  int width;
  int height;
  int maxwidth;
  int maxheight;
  int fps;
  var lastMove;
  
  Sprite(this.canvas, String filename, 
          {this.width, this.height, this.x, this.y, this.offsetX, this.offsetY, this.sframe, this.eframe, this.fps}) 
  {
    
    this.x           =   (this.x == null) ? 0 : this.x;
    this.y           =   (this.y == null) ? 0 : this.y;
    this.offsetX     =   (this.offsetX == null) ? 0 : this.offsetX;
    this.offsetY     =   (this.offsetY == null) ? 0 : this.offsetY;
    this.sframe      =   (this.sframe == null) ? 0 : this.sframe;
    this.frame       =   this.sframe;
    this.fps         =   (this.fps == null) ? 20 : this.fps;
    this.context     =   this.canvas.getContext("2d"); 
    this.img         =   new ImageElement(src:filename);
    this.lastMove    =   new DateTime.now().millisecondsSinceEpoch;
    
    this.img.onLoad.listen((Event e){
          this.width        =   (this.width == null) ? this.img.width : this.width;
          this.height       =   (this.height == null) ? this.img.height : this.height;
          this.maxwidth     =   this.img.width;
          this.maxheight    =   this.img.height;
          this.eframe       =   (this.eframe == null) ? (this.img.height ~/ this.height) * (this.img.width ~/ this.width) - 1 : this.eframe;
          this.maxframe     =   this.eframe + 1;
          
          window.requestAnimationFrame(draw);
    });
    
  }
  void draw(num _) {
      if(this.img.width == 0)
          return;
      var sourceX = (this.frame * this.width + this.offsetX) % this.maxwidth;
      var sourceY = (this.frame * this.width + this.offsetX) ~/ this.maxwidth * this.height + this.offsetY;
      var sourceRect = new Rectangle(sourceX, sourceY, this.width, this.height);
    
      var destRect = new Rectangle(this.x, this.y, this.width, this.height);
      this.context.drawImageToRect(this.img, destRect, sourceRect: sourceRect);
  }
  
  void animate() {
    if(this.img.width == 0)
        return;
    if(new DateTime.now().millisecondsSinceEpoch - this.lastMove > 1000.0/this.fps)
    {
      this.lastMove = new DateTime.now().millisecondsSinceEpoch;
      this.frame = (this.frame + 1) % this.maxframe + this.sframe;
    }
  }
}