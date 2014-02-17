import 'dart:html';
import 'Sprite.dart';

class Engine {
    CanvasElement canvas;
    CanvasRenderingContext2D context;
    List<Sprite> sprites;
    bool isRunning = false;
    int fps;
    
    Engine(this.canvas) {
        this.context = this.canvas.context2D;
        sprites = new List();
        
        this.init();
        
        this.start();
    }
    
    bool init() {
        Sprite background = new Sprite(this.canvas, "background.png");
        Sprite subzero = new Sprite(this.canvas, "sprite1.png",y:100, width:78, height:148,fps: 10, offsetY: 278,sframe:0, eframe: 8);
        Sprite subzero1 = new Sprite(canvas, "sprite1.png", width:78, height:148,x: 200, fps: 10);
        this.addSprite(background);
        this.addSprite(subzero);
        this.addSprite(subzero1);

        return true;
    }
    void start() {
        
        this.isRunning = true;
        window.requestAnimationFrame(run);
    }
    void addSprite(Sprite sprite) {
        this.sprites.add(sprite);
    }
    
    void animate() {
        for(var sprite in this.sprites) {
            sprite.animate();
        }
    }
    
    void draw() {
        for(var sprite in this.sprites) {
            sprite.draw(0);
        }
    }
    
    void run(num _) {
        if(isRunning)
        {
            clear();
            animate();
            draw();
            window.requestAnimationFrame(run);
        }
    }
    void stop() {
        this.isRunning = false;
    }
    void clear(){
        this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
    }
}

