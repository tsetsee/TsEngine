import 'dart:html';
import "TsEngine/TsEngine.dart";
import 'dart:math' as math;

class Background extends Sprite {
    num xVelocity;
    Background(CanvasElement canvas, String filename, 
        {num this.xVelocity, num width, num height, num x, num y, num offsetX, num offsetY, int sframe, int eframe, int fps,var scaleH, var scaleV}) : 
         super(canvas, filename,width:width, height:height, x:x, y:y, offsetX:offsetX, offsetY:offsetY, sframe:sframe, eframe:eframe, fps:fps, scaleH:scaleH, scaleV:scaleV)
    {
        this.xVelocity = (this.xVelocity == null)? 0.3 : this.xVelocity;
    }
    @override
    void move() {
        if(this.engine.birdVelocity == 0)
            return;
        this.x -= xVelocity;
        if(this.x <= -this.width)
        {
            this.x = this.width * 2 - 1;
        }
    }
    @override
    void collision(Sprite sprite){
        
    }
}

class Ground extends Sprite {
    num xVelocity;
    Ground(CanvasElement canvas, String filename, 
        {num this.xVelocity, num width, num height, num x, num y, num offsetX, num offsetY, int sframe, int eframe, int fps,var scaleH, var scaleV}) : 
         super(canvas, filename,width:width, height:height, x:x, y:y, offsetX:offsetX, offsetY:offsetY, sframe:sframe, eframe:eframe, fps:fps, scaleH:scaleH, scaleV:scaleV)
    {
        this.xVelocity = (this.xVelocity == null)? 0.5 : this.xVelocity;
    }
    @override
    void move() {
        if(this.engine.birdVelocity == 0)
            return;
        this.x -= xVelocity;
        if(this.x <= -this.width)
        {
            this.x = this.width;
        }
    }
    @override
    void collision(Sprite sprite){
        
    }
}

class Pipe extends Sprite {
    num xVelocity;
    num factor;

    Pipe(CanvasElement canvas, String filename, this.factor,
        {num this.xVelocity, num width, num height, num x, num y, num offsetX, num offsetY, int sframe, int eframe, int fps,var scaleH, var scaleV}) : 
         super(canvas, filename,width:width, height:height, x:x, y:y, offsetX:offsetX, offsetY:offsetY, sframe:sframe, eframe:eframe, fps:fps, scaleH:scaleH, scaleV:scaleV)
    {
        this.xVelocity = (this.xVelocity == null)? 0.5 : this.xVelocity;
    }

    @override
    void move() {
        if(this.engine.birdVelocity == 0)
            return;
        this.x -= xVelocity;
       
    }
    @override
    void collision(Sprite sprite){
        
    }
}
class FlappyBird extends Sprite {
    num g = 0.2;
    num deltaY = 0;
    String status;
    FlappyBird(CanvasElement canvas, String filename, 
            {bool allowCollision, num width, num height, num x, num y, num offsetX, num offsetY, int sframe, int eframe, int fps,var scaleH, var scaleV}) : 
            super(canvas, filename,width:width,allowCollision:allowCollision, height:height, x:x, y:y, offsetX:offsetX, offsetY:offsetY, sframe:sframe, eframe:eframe, fps:fps, scaleH:scaleH, scaleV:scaleV)
    {
       status = "down";
       
       window.onClick.listen((MouseEvent e){
           if(status != "up")
           {
               this.deltaY = 0; 
               status="up";
           }
            
       });
    }
    void moveUp(){
        this.frame = 2;
        this.deltaY -= g * 5;
        this.y += this.deltaY;
        if(this.deltaY < -8)
        {
            this.deltaY = 0;
            this.status = "down";
        }
    }
    void moveDown(){
        this.frame = 0;
        this.deltaY += g; 
        this.y += this.deltaY;
    }
    @override
    void move() {
        if(this.engine.birdVelocity == 0)
            return;
        if(status == "up")
        {
            moveUp();
        } 
        else if (status == "down") 
        {
            moveDown();
        } 
        else if (status == "dead")
        {
            this.engine.stop();
        }
    }
    @override
    void collision(Sprite sprite) {
        if(sprite is Ground || sprite is Pipe)
        {
            this.status = "dead";
        }
    }
    @override
    void onLoadSprite(){
        this.collisionBoxes.add(new Rectangle(10,0,this.width - 20, this.height));
    }
}
class App extends Engine{
    num birdVelocity = 0;
    final num xPipes = 150;
    final num yPipes = 100;
    final num pipeH = 320;
    final num groundH = 76;
    num currentD = 0;
    var random;
    
    int points = 0;
    
    @override
    bool init() {
        random = new math.Random(new DateTime.now().millisecondsSinceEpoch);
        this.setSprite("background1", new Background(
                this.canvas,"resource/background.png",
                width: 274, fps: 0));
        this.setSprite("background2", new Background(
                this.canvas,"resource/background.png",
                width: 274, fps: 0, x: 274));
        this.setSprite("background3", new Background(
                this.canvas,"resource/background.png",
                width: 274, fps: 0, x: 548));
        this.setSprite("ground1", new Ground(
                this.canvas,"resource/ground.png",xVelocity: 1,
                y:this.canvas.height - groundH, fps: 0, width: 335));
        this.setSprite("ground2", new Ground(
                this.canvas,"resource/ground.png",xVelocity: 1,
                y:this.canvas.height - groundH, fps: 0, x: 335, width: 335));
        
        this.setSprite("flappybird", new FlappyBird(
                this.canvas,"resource/flappybird.png",
                allowCollision: true,
                width: 34, height: 24, fps: 0, sframe: 1,
                x:this.canvas.width / 3, y: this.canvas.height / 2));

        return true;
    }
    App(String canvasID) : super(document.querySelector(canvasID)) {
        this.start();
        var event;
        event = window.onClick.listen((MouseEvent e){
            birdVelocity = 1;
            event.cancel();
        });
    }
    @override
    void run_start()
    {

        if(isRunning && birdVelocity > 0)
        {
            if(currentD% xPipes == 0)
            {
                var newPipeH = pipeH * (random.nextInt(3) + 1) / 5;
                print(newPipeH);
                this.setSprite(null, new Pipe(
                        this.canvas,"resource/pipes.png", 1, xVelocity: birdVelocity,
                        y: this.canvas.height - newPipeH - groundH, fps: 0, x: this.canvas.width, width: 55, sframe: 3));
                this.setSprite(null, new Pipe(
                        this.canvas,"resource/pipes.png", -1,xVelocity: birdVelocity,
                        y:-pipeH + this.canvas.height - newPipeH - yPipes - groundH, fps: 0, x: this.canvas.width, width: 55, sframe:2));
                
                this.sprites.forEach((sprite_name, sprite){
                   if(sprite is Pipe)
                   {
                       if(sprite.x + sprite.width < 0)
                           sprite = null;
                   }
               });
    
            }
            currentD = (currentD + birdVelocity) ;
            if(this.canvas.width - currentD == this.sprites['flappybird'].x)
              {
                  this.points++;
                  currentD%= xPipes;
              }
        }
    }
    @override
    void customDraw(){
        
        this.context
            ..fillStyle = "white"
            ..font = "bold 30px Arial"
            ..fillText(points.toString(), this.canvas.width / 2, 50);
    }

}

void main() {

    try{
        new App("#myCanvas");
    }catch(exception, stackTrace){
        print(exception);
    }
}
