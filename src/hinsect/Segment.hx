package hinsect;

final color_segment = 0x62E962;
final color_border = 0xEE2A9C;
final color_draft = 0x044249;

class Segment  extends h2d.Object {

    var length:Float;
    var width_start:Float;
    var width_end:Float;

   public  var abs_r:Float;
   public  var abs_a:Float;
   public  var abs_x:Float;
   public  var abs_y:Float;
   public  var abs_ex:Float;
   public  var abs_ey:Float;

   var angle_start:Float;
   var angle_end:Float;

    var angle_max:Float;
    var angle_min:Float;
    var angle_flex:Float;

	var g:h2d.Graphics;


    public function new(l:Float, ws:Float,we:Float) {
        super();
        length = l;
        width_start= ws;
        width_end=we;



        angle_min=0;
        angle_max=Math.PI*2;

        angle_start=(angle_max+angle_min)/2;
        angle_end=Math.PI+Math.PI/3;
        angle_flex=5;

        abs_a=angle_start;
        abs_r=0;
        abs_x=0;
        abs_y=0;

        


        g = new h2d.Graphics(this);
        g.scaleY= -1;
        redraw();
    }

    public function set_limit(amin,amax){
        angle_min=amin;
        angle_max=amax;
        check_angle_limits();
    }
    function check_angle_limits(){
        if(angle_start>angle_max){angle_start=angle_max;}
        if(angle_start <angle_min){angle_start=angle_min;}
        redraw();
    }
    public function set_flex(f){
        angle_flex=f;
    }
    public function place(ax,ay,aa){
        abs_x=ax;
        abs_y=ay;
        abs_a=aa;
        redraw();
    }
    public function set_angle_start(a){
        angle_start=a;
        check_angle_limits();
    }
    public function set_angle_end(a){
        angle_end=a;
        redraw();
    }

    public function calc_abs(){
        abs_a=angle_start+abs_r;
        abs_ex=abs_x+length*Math.cos(abs_a);
        abs_ey=abs_y+length*Math.sin(abs_a);

    }


    public function redraw(){
        calc_abs();
    
        var sl=width_start/2;
        var el=width_end/2;
        var sba= (angle_start)/2+abs_r;
        var rnangle=Math.PI+angle_start+angle_end;
        var eba= (Math.PI+angle_start+rnangle)/2+abs_r;

        g.clear();

        g.beginFill(color_segment);
		g.lineStyle(2, color_border);
        g.moveTo(abs_x+sl*Math.cos(sba),abs_y+sl*Math.sin(sba));
        g.lineTo(abs_x+sl*Math.cos(sba+Math.PI),abs_y+sl*Math.sin(sba+Math.PI));
        g.lineTo(abs_ex+el*Math.cos(eba+Math.PI),abs_ey+el*Math.sin(eba+Math.PI));
        g.lineTo(abs_ex+el*Math.cos(eba),abs_ey+el*Math.sin(eba));
        g.lineTo(abs_x+sl*Math.cos(sba),abs_y+sl*Math.sin(sba));
        g.endFill();

        g.lineStyle(2, color_draft);
        g.moveTo(abs_x,abs_y);
        g.lineTo(abs_x+30*Math.cos(abs_r),abs_y+30*Math.sin(abs_r));

         g.moveTo(abs_x,abs_y);
         g.lineTo(abs_x+15*Math.cos(angle_min+abs_r),abs_y+15*Math.sin(angle_min+abs_r));
         g.moveTo(abs_x,abs_y);
         g.lineTo(abs_x+15*Math.cos(angle_max+abs_r),abs_y+15*Math.sin(angle_max+abs_r));

        g.moveTo(abs_x,abs_y);
        g.lineTo(abs_ex,abs_ey);
        g.lineTo(abs_ex+30*Math.cos(rnangle+abs_r),abs_ey+30*Math.sin(rnangle+abs_r));
    }



}