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

    public var amin:Float;
    public var amax:Float;
	public var flex:Float;

	public var shor:Float;

	public var abs_angle:Float;
	public var sx:Float;
	public var sy:Float;
	public var ex:Float;
	public var ey:Float;

	public var la:Float;
	public var lx:Float;
	public var ly:Float;
	public var ma:Float;
	public var mx:Float;
	public var my:Float;

	public function new(l:Float, a:Float, w:Float, x:Float = 0, y:Float = 0, ia:Float = 0) {
		index = 0;
		next = null;
		length = l;
		angle = a;
		width = w;

        amin = Math.PI/12;
        amax = Math.PI-Math.PI/12;

		if (a < 0) {
			shor = -1;
		} else {
			shor = 1;
		}

		flex = 10;

		abs_angle = ia + a;
		sx = x;
		sy = y;
		ex = sx + length * Math.cos(abs_angle);
		ey = sy + length * Math.sin(abs_angle);
	}

	public function setma(x, y, n = 0) {
		mx = x;
		my = y;
		calc();
        var lb = getlast();
        var d = Math.sqrt((mx-lb.ex)*(mx-lb.ex)+(my-lb.ey)*(my-lb.ey));
        if((n<10) && (d>50)){
             setma(x, y, n+1);
             }
	}

	public function plug(l, a, w) {
		var b = getlast();
		b.next = new Bone(l, a, w, b.ex, b.ey, b.abs_angle);
		b.next.index = b.index + 1;
	}

	public function getlast() {
		if (next == null) {
			return this;
		} else {
			return next.getlast();
		}
	}

	public function calc() {
		var lb = getlast();
		la = Math.atan2(lb.ey - sy, lb.ex - sx);
		ma = Math.atan2(my - sy, mx - sx);
		var da = (ma - la) / flex;

		if ((angle + da) * shor < amin ){
            trace("MIN",da,-(angle-amin)*shor);
           da=-(angle-amin)*shor;

		}
        if ((angle + da) * shor > amax ){
            trace("MAX",da,(amax-angle)*shor);
            da=(amax-angle)*shor;
        }

        angle = angle + da;
        abs_angle = abs_angle + da;

		ex = sx + length * Math.cos(abs_angle);
		ey = sy + length * Math.sin(abs_angle);

		if (next != null) {
			next.abs_angle = next.angle + this.abs_angle;
			next.sx = this.ex;
			next.sy = this.ey;
			next.ex = next.sx + next.length * Math.cos(next.abs_angle);
			next.ey = next.sy + next.length * Math.sin(next.abs_angle);
			next.mx = mx;
			next.my = my;

			next.calc();
		}
	}
}

class Leg extends h2d.Object {
	var g:h2d.Graphics;
	var itv:h2d.Interactive;

	var mx:Float;
	var my:Float;

	var bone:Bone;

	public var points:Array<h2d.col.Point>;

	public function new(obj:h2d.Object) {
		super(obj);

		bone = new Bone(80, -Math.PI / 2, 25);
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
	}

	public function redraw() {
		// trace(dx);
		g.clear();

		g.lineStyle(2, color_bone);
		var b = bone;
		g.moveTo(b.sx, b.sy);
		while (b != null) {
			g.lineTo(b.ex, b.ey);
			b = b.next;
		}

		g.beginFill(color_body);
		g.drawCircle(mx, my, 3, 24);
		g.endFill();
	}

	public function update(r) {
		mx = 220 - Math.sin(r) * 20;
		my = Math.cos(r) * 150 - 30;
		bone.setma(mx, my);
		redraw();
	}
}
