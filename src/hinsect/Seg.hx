package hinsect;


class Seg {
    public var length:Float;
    public var angle:Float;

    public var aa:Float
    public var sx:Float
    public var sy:Float
    public var ex:Float
    public var ey:Float

    public function new(l){
        length=l;
        angle=Pit.PI;
        place (0,0,0)
    }

    public function place(x,y,aa){
        sx=x;
        sy=y;
        ex=adx(angle+aa,l);
        ey=ady(angle+aa,l);
    }

}