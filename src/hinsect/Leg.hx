package hinsect;

final SCREEN_WIDTH = 500;
final SCREEN_HEIGHT = 500;
final color_body = 0x483D8B;
final color_bone = 0xEE2A9C;

class Bone {
    public var index:Int;
	public var next:Bone;
	public var length:Float;
	public var width:Float;
	public var angle:Float;
	public var flex:Float;

    public var shor:Float;

    public var abs_angle:Float;
	public var sx:Float;
	public var sy:Float;
	public var ex:Float;
	public var ey:Float;

    public var la:Float;
    public var ma:Float;
    public var mx:Float;
    public var my:Float;

	public function new(l:Float, a:Float, w:Float, x:Float=0,y:Float=0,ia:Float=0) {
        index=0;
		next = null;
		length = l;
		angle = a;
		width = w;

        if (a<0 ){shor=-1;}else{shor=1;}
      

		flex = 0;

        abs_angle=ia+a;
		sx = x;
		sy = y;
		ex = sx+length * Math.cos(abs_angle);
		ey = sy+length * Math.sin(abs_angle);

        


	}

    public function setma( x,y){
        mx=x;
        my=y;
        calc();
    }

	public function plug(l, a, w) {
		var b = getlast();
		b.next = new Bone(l, a, w,b.ex,b.ey,b.abs_angle);
        b.next.index=b.index+1;
	}

	public function getlast() {
		if (next == null) {
			return this;
		} else {
			return next.getlast();
		}
	}

    public function calc(){

        var lb=getlast();
        la = Math.atan2(lb.ey-sy, lb.ex-sx);
        ma = Math.atan2(my-sy, mx-sx);

        var da=(ma-la)/5;

        if((angle+da)*shor >=0 && (angle+da)*shor<= Math.PI){
        angle = angle+da;
        abs_angle =abs_angle+da;
        }

        ex = sx+length * Math.cos(abs_angle);
		ey = sy+length * Math.sin(abs_angle);

        if(next!=null){


            next.abs_angle=next.angle+this.abs_angle;
            next.sx=this.ex;
            next.sy=this.ey;
            next.ex = next.sx+next.length * Math.cos(next.abs_angle);
            next.ey = next.sy+next.length * Math.sin(next.abs_angle);
            next.mx = mx;
            next.my= my;

            next.calc();
        }

    }

}

class Leg extends h2d.Object {
	var g:h2d.Graphics;
	var itv:h2d.Interactive;

	var ox:Float;
	var oy:Float;
	var mx:Float;
	var my:Float;

	var bones:Array<Float>;
	var angles:Array<Float>;
	var widths:Array<Float>;

	var flexs:Array<Float>;

    var bone:Bone;

	public var points:Array<h2d.col.Point>;

	public function new(obj:h2d.Object) {
		super(obj);
		bones = [];
		angles = [];
		widths = [];
		flexs = [];
		points = [];

        bone=new Bone(80,-Math.PI / 2,25);
        bone.plug(80, Math.PI / 2 + Math.PI / 6, 20);
        bone.plug(50, -Math.PI / 12, 15);
        bone.plug(30, -Math.PI / 12, 10);
        bone.plug(20, Math.PI / 12, 5);


		g = new h2d.Graphics(this);
		g.x = SCREEN_WIDTH / 2;
		g.y = SCREEN_HEIGHT / 2;
		g.scaleY = -1;

		itv = new h2d.Interactive(SCREEN_WIDTH, SCREEN_HEIGHT, this);
		itv.onRelease = function(e:hxd.Event) {
			mx = e.relX - SCREEN_WIDTH / 2;
			my = -e.relY + SCREEN_HEIGHT / 2;
			trace(e.relX, e.relY, mx, my);
			redraw();
		};

		addBone(80, -Math.PI / 2, 25);
		addBone(80, Math.PI / 2 + Math.PI / 6, 20);
		addBone(50, -Math.PI / 12, 15);
		addBone(30, -Math.PI / 12, 10);
		addBone(20, -Math.PI / 12, 5);
	}

	public function addBone(d, a, w) {
		bones.push(d);
		angles.push(a);
		widths.push(w);
		flexs.push(0);

		var px:Float = 0;
		var py:Float = 0;
		var a:Float = 0;

		for (i in 0...bones.length) {
			a = a + angles[i];
			px = px + bones[i] * Math.cos(a);
			py = py + bones[i] * Math.sin(a);
		}
		points.push(new h2d.col.Point(px, py));
		ox = px;
		oy = py;
		mx = ox;
		my = oy;
		redraw();
	}

	public function calc() {
		var px:Float = 0;
		var py:Float = 0;
		var a:Float = 0;
		for (i in 0...bones.length) {
			a = a + angles[i] + flexs[i];
			px = px + bones[i] * Math.cos(a);
			py = py + bones[i] * Math.sin(a);
			points[i].x = px;
			points[i].y = py;
		}
		ox = px;
		oy = py;
	}

	public function geto(n = 0) {
		var px:Float = 0;
		var py:Float = 0;
		var a:Float = 0;
		var step:Float = 12;
		for (i in 0...flexs.length) {
			if (i > 0) {
				px = points[i - 1].x;
				py = points[i - 1].y;
			}
			var oa = Math.atan2(oy - py, ox - px);
			var ma = Math.atan2(my - py, mx - px);
			if (Math.abs(flexs[i] + (ma - oa) / step) < (Math.PI / 8)) {
				flexs[i] = flexs[i] + (ma - oa) / step;
			}
			calc();
		}
		if (n < 300 && Math.sqrt((mx - ox) * (mx - ox) + (my - oy) * (my - oy)) > 5) {
			n = n + 1;
			geto(n);
		}
	}

	public function redraw() {
		geto();
		// trace(dx);
		g.clear();

		g.lineStyle(2, color_body);
		g.moveTo(0, 0);
		for (i in 0...points.length) {
			g.lineTo(points[i].x, points[i].y);
		}

		for (i in 0...points.length) {
			g.drawCircle(points[i].x, points[i].y, widths[i], 24);
		}

        g.lineStyle(2, color_bone);
        var b=bone;
		g.moveTo(b.sx, b.sy);
        while (b!=null){
            g.lineTo(b.ex, b.ey);
            b=b.next;
        }



		g.beginFill(color_body);
		g.drawCircle(mx, my, 3, 24);
		g.endFill();
	}

	public function update(r) {
		mx = 180 - Math.sin(r) * 20;
		my = Math.cos(r) * 150 - 30;
        bone.setma(mx,my);
		redraw();
	}
}