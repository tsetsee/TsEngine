part of TsEngine;

abstract class Engine {
    CanvasElement canvas;
    CanvasRenderingContext2D context;
    Map<String,Sprite> sprites;
    Map<String,Sound> sounds;
    bool isRunning = false;
    
    Engine(this.canvas) {
        if(this.canvas == null)
        {
            throw new StateError("Canvas not found!"); 
        }
        this.context = this.canvas.context2D;
        sprites = new Map();
        sounds = new Map();
    }
    
    bool init();
    
    void start() {
        init();
        this.isRunning = true;
        window.requestAnimationFrame(run);
    }
    void stop() {
        this.isRunning = false;
    }
    void resume(){
        this.isRunning = true;
    }
    void clear(){
        this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
    }
    void animate() {
        
        this.sprites.forEach((sprite_name,sprite) => sprite.animate());

    }
    void draw() {
        
        this.sprites.forEach((sprite_name,sprite) => sprite.draw(0));

    }
    
    void move() {
        
        this.sprites.forEach((sprite_name,sprite) => sprite.move());

    }

    void run_start(){}
    void run_end(){}
    void customDraw(){}
    void run(num _) {
        run_start();
        if(isRunning)
        {
            clear();
            animate();
            move();
            collision();
            draw();
            customDraw();
        }
        run_end();
        window.requestAnimationFrame(run);
    }
    
    Sprite getSprite(String sprite_name) {
        return this.sprites[sprite_name];
    }

    void setSprite(String sprite_name, Sprite sprite) {
        sprite.name = sprite_name;
        sprite.engine = this;
        if(sprite_name == null)
        {    
            var uuid = new Uuid();
            sprite.name = uuid.v1();
            this.sprites[sprite.name] = sprite;
            
        }
        else if(this.sprites.containsKey(sprite_name))
            this.sprites[sprite_name] = sprite;
        else
            this.sprites.putIfAbsent(sprite_name, ()=>sprite);
    }
    
    Sound getSound(String sound_name) {
        return this.sounds[sound_name];
    }

    void setSound(String sprite_name, Sound sound) {
        if(this.sounds.containsKey(sprite_name))
            this.sounds[sprite_name] = sound;
        else
            this.sounds.putIfAbsent(sprite_name, ()=>sound);
    }

    void collision(){
        this.sprites.forEach((sprite_name1, sprite1){
            if(sprite1.allowCollision)
            {
                this.sprites.forEach((sprite_name2, sprite2){
                    if(sprite_name1 != sprite_name2) {
                        
                        bool isCollide = false;
                        for(Rectangle box1 in sprite1.collisionBoxes)
                        {
                            for(Rectangle box2 in sprite2.collisionBoxes)
                            {
                                if(!(sprite1.y + box1.top + box1.height < sprite2.y + box2.top
                                  || sprite1.y + box1.top > sprite2.y + box2.top + box2.height
                                  || sprite1.x + box1.left + box1.width < sprite2.x + box2.left
                                  || sprite1.x + box1.left > sprite2.x + box2.left  + box2.width))
                                {
                                    isCollide = true;
                                    break;
                                }
                            }
                            if(isCollide)
                            {
                                sprite1.collision(sprite2);
                                break;
                            }
                        }
                    }
                }); 
            }
        });
    }
}

