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

	public var skel:Array<h2d.col.Point>;
	public var body:Array<h2d.col.Point>;

	public function new(l:Float, a:Float, w:Float, x:Float = 0, y:Float = 0, ia:Float = 0) {
		index = 0;
		next = null;
		length = l;
		angle = a;
		width = w;

		amin = Math.PI / 12;
		amax = Math.PI - Math.PI / 12;

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

		skel = [];
		body = [];
		buildskel();
		buildbody();
	}

	public function setma(x, y, n = 0) {
		mx = x;
		my = y;
		calc();
		var lb = getlast();
		var d = Math.sqrt((mx - lb.ex) * (mx - lb.ex) + (my - lb.ey) * (my - lb.ey));
		if ((n < 10) && (d > 50)) {
			setma(x, y, n + 1);
		}
		buildskel();
		buildbody();
	}

	public function plug(l, a, w) {
		var b = getlast();
		b.next = new Bone(l, a, w, b.ex, b.ey, b.abs_angle);
		b.next.index = b.index + 1;
		buildskel();
		buildbody();
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
		var da = (ma - la) / (2+index);

		if (shor == 1) {
			if (angle + da < amin) {
				da = amin - angle;
			}
			if (angle + da > amax) {
				da = amax - angle;
			}
		} else {
			if (angle + da > -amin) {
				da = -amin - angle;
			}
			if (angle + da < -amax) {
				da = -amax - angle;
			}
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

	public function buildskel() {
		skel = [];
		skel.push(new h2d.col.Point(sx, sy));
		var b = this;
		while (b != null) {
			skel.push(new h2d.col.Point(b.ex, b.ey));
			b = b.next;
		}
	}

	public function buildbody() {
		body = [];
		var a = abs_angle;
		var b = this;
		while (b != null) {
            var sa =a+(Math.PI- b.angle)/2+b.angle;
			body.push(new h2d.col.Point(b.sx + b.width * Math.cos(sa), b.sy +b.width * Math.sin(sa)));
			a = b.abs_angle;
			b = b.next;
		}

        var b = getlast();
        body.push(new h2d.col.Point(b.ex,b.ey));

        var tmpbody:Array<h2d.col.Point>  = [];
		var a = abs_angle;
		var b = this;
		while (b != null) {
            var sa =Math.PI+a+(Math.PI- b.angle)/2+b.angle;
			tmpbody.push(new h2d.col.Point(b.sx + b.width * Math.cos(sa), b.sy +b.width * Math.sin(sa)));
			a = b.abs_angle;
			b = b.next;
		}
        
        tmpbody.reverse();


        body=body.concat(tmpbody);
        body.push(body[0]);
		
	}
}

class Leg extends h2d.Object {
	var g:h2d.Graphics;
	var itv:h2d.Interactive;

	var mx:Float;
	var my:Float;

    var cx:Float;
    var cy:Float;
    var rx:Float;
    var ry:Float;
    var dr:Float;

	var bone:Bone;

	public var points:Array<h2d.col.Point>;

	public function new(obj:h2d.Object) {
		super(obj);

        cx=200;
        rx=20;
        cy=-50;
        ry=40;
        dr=0;

		bone = new Bone(80, -Math.PI / 2, 25);
		bone.plug(60, Math.PI / 2 + Math.PI / 6, 20);
		bone.plug(40, -Math.PI / 12, 15);
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
			
		};
	}

	public function redraw() {
		// trace(dx);
		g.clear();



        g.beginFill(color_body);
		g.lineStyle(2, color_body);
		g.moveTo(bone.body[0].x, bone.body[0].y);
		for (i in 1...bone.body.length) {
			g.lineTo(bone.body[i].x, bone.body[i].y);
		}
        g.endFill();

        
        g.lineStyle(2, color_bone);
		g.moveTo(bone.skel[0].x, bone.skel[0].y);
		for (i in 1...bone.skel.length) {
			g.lineTo(bone.skel[i].x, bone.skel[i].y);
		}

		g.beginFill(color_body);
		g.drawCircle(mx, my, 3, 24);
		g.endFill();
	}

	public function update(r) {
        if(bone !=null){
		mx = cx + Math.sin(r+dr) * rx;
		my = cy + Math.cos(r+dr) * ry ;
		bone.setma(mx, my);
		redraw();
        }
	}
}
