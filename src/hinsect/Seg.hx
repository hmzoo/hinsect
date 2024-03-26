package hinsect;


class Seg {
    public var index:Int;
    public var next:Seg;
    public var length:Float;
    public var angle:Float;

    public var aa:Float;
    public var sx:Float;
    public var sy:Float;
    public var ex:Float;
    public var ey:Float;



    public function new(a,l){
        length=l;
        angle=a;
        place (0,0,-Pit.PI);
    }

    public function addSeg(a,l){
        if(next == null) {
            next = new Seg(a,l);
            next.place(ex,ey,aa);
        }else{
            next.addSeg(a,l);
        }       
           
    }

    public function place(x,y,a){
        aa=angle+Pit.rev(a);
        sx=x;
        sy=y;
        ex=sx+Pit.adx(aa,length);
        ey=sy+Pit.ady(aa,length);
        if(next !=null){
         next.place(ex,ey,aa);
        }
    }

}