part of TsEngine;

class Sound {
    String _src;
    AudioContext _audioContext;
    GainNode _gainNode;
    AudioBuffer _buffer;
    bool _isReady = false;
    
    Sound(this._src){
        _audioContext = new AudioContext();
        _gainNode = _audioContext.createGainNode();
        
        HttpRequest xhr = new HttpRequest();
        
        xhr.open("GET", _src, async: true);
        xhr.responseType = "arraybuffer";
        xhr.onLoad.listen((e) {
            _audioContext.decodeAudioData(xhr.response)
            .then((buffer) {
                this._isReady = true;
                _buffer = buffer;
            })
            .catchError((e){
                print(e);
            });
           
        });
        
        xhr.send();
    }
    
    bool get isReady => _isReady;
    String get src => _src;
    
    void play() {
        if(_isReady)
        {
            AudioBufferSourceNode source = _audioContext.createBufferSource();
            source.connectNode(_gainNode, 0, 0);
            _gainNode.connectNode(_audioContext.destination, 0, 0);
            source.buffer = _buffer;
            source.noteOn(0);
        }
    }
}