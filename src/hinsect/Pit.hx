package hinsect;


class Pit {

    public static final PI = Math.PI;

    public static function deg(a:Float):Float{
        a=r(a);
        return a*(180/PI);
    }

    public static function rad(d:Float):Float{
        return r(d*(PI/180));
    }


    public static function r(a:Float):Float{
        if(a>2*PI){a=a-2*PI; return r(a);}
        if(a<0){a=a+2*PI; return r(a);}
        return a;
    }

    public static function rev(a:Float):Float{
        return r(a+PI);
    }

    public static function bis(a:Float):Float{
        return r(a/2);
    }

    public static function ort(a:Float):Float{
        return r(a+PI/2);
    }

    public function toa(x:Float,y:float):Float{
        return r(Math.atan2(y, x));
    }

    public function dis(x,y){
        return r(Math.sqrt(x*x,y*y));
    }

    public function adx(a,l):Float{
        return l*Math.cos(a)
    }
    public function ady(a,l):Float{
        return l*Math.sin(a)
    }

}