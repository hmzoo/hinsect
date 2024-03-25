package hinsect;


class Seg {
    public var index:Int;
    public var next:Seg;
    public var length:Float;
    public var angle:Float;

    public var aa:Float
    public var sx:Float
    public var sy:Float
    public var ex:Float
    public var ey:Float

    public function addSeg(a,l){

    }

    public function new(a,l){
        length=l;
        angle=a;
        place (0,0,0);
    }

    public function addSeg(a,l){
        var s= new Seg(a,l)
        s.place(ex,ey,aa)
        
    }

    public function place(x,y,aa){
        var a=angle+Pit.rev(aa);
        sx=x;
        sy=y;
        ex=sx+adx(a,l);
        ey=sy+ady(a,l);
        next.place(ex,ey,a);
    }

}