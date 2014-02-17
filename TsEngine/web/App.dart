import "dart:html";
import "Engine.dart";

void main() {
    CanvasElement canvas = 
            document.querySelector("#myCanvas");
    new Engine(canvas);  
}