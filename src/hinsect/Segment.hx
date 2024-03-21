package hinsect;

final color_segment = 0x62E962;
final color_border = 0xEE2A9C;
final color_draft = 0x044249;

class Segment  extends h2d.Object {

    var length:Float;

    var width_start:Float;
    var width_end:Float;

   public  var angle:Float;
   public  var nangle:Float;
   public  var oangle:Float;

    var angle_start:Float;
    var angle_end:Float;
    var angle_max:Float;
    var angle_min:Float;
    var angle_sho:Float;
    var angle_flex:Float;

	var g:h2d.Graphics;


    public function new(l:Float, ws:Float,we:Float,amin:Float,amax:Float,aflex:Float) {
        super();
        length = l;
        width_start= ws;
        width_end=we;

        angle_min=amin;
        angle_max=amax;

        angle_flex=aflex;

        angle=(angle_max+angle_min)/2;
        nangle=Math.PI+Math.PI/3;
        oangle=-Math.PI/12;

        g = new h2d.Graphics(this);
        g.scaleY = -1;
        redraw();
    }



    public function redraw(){

        var sx=0;
        var sy=0;
        var sl=width_start/2;

        var ex=length*Math.cos(angle+oangle);
        var ey=length*Math.sin(angle+oangle);
        var el=width_end/2;

        var sba= (angle)/2+oangle;

        var rnangle=Math.PI+angle+nangle;
        var eba= (Math.PI+angle+rnangle)/2+oangle;

        g.clear();

        g.beginFill(color_segment);
		g.lineStyle(2, color_border);
        g.moveTo(sx+sl*Math.cos(sba),sy+sl*Math.sin(sba));
        g.lineTo(sx+sl*Math.cos(sba+Math.PI),sy+sl*Math.sin(sba+Math.PI));
        g.lineTo(ex+el*Math.cos(eba+Math.PI),ey+el*Math.sin(eba+Math.PI));
        g.lineTo(ex+el*Math.cos(eba),ey+el*Math.sin(eba));
        g.lineTo(sx+sl*Math.cos(sba),sy+sl*Math.sin(sba));
        g.endFill();

        g.lineStyle(2, color_draft);
        g.moveTo(0,0);
        g.lineTo(30*Math.cos(oangle),30*Math.sin(oangle));
        g.moveTo(0,0);
        g.lineTo(30*Math.cos(angle_min+oangle),30*Math.sin(angle_min+oangle));
        g.moveTo(0,0);
        g.lineTo(30*Math.cos(angle_max+oangle),30*Math.sin(angle_max+oangle));
        g.moveTo(0,0);
        g.lineTo(ex,ey);
        g.lineTo(ex+30*Math.cos(rnangle+oangle),ey+30*Math.sin(rnangle+oangle));
    }



}