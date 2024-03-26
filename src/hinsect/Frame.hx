package hinsect;

final color_axes = 0x8A97E0;
final color_ang = 0x87CEEB;
final color_body= 0x483D8B;

final SCREEN_WIDTH=500;
final SCREEN_HEIGHT=500;

class Frame extends h2d.Object {

    public var g:h2d.Graphics;
	var itv:h2d.Interactive;

    var legs:Array<Leg>;

    public function new(scene:h2d.Scene) {
		super(scene);
        legs=[];
        g = new h2d.Graphics(this);
		g.x = SCREEN_WIDTH/2;
		g.y = SCREEN_HEIGHT/2;
		g.scaleY = -1;

        this.redraw();
    }

    public function redraw() {

        //trace(dx);
		g.clear();

		g.beginFill(0xFFFFFF);
		g.drawRect(-SCREEN_WIDTH/2, -SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT);
        
		g.endFill();

		g.lineStyle(2, color_axes);
		g.moveTo(0, -SCREEN_HEIGHT/2);
		g.lineTo(0, SCREEN_HEIGHT/2);
		g.moveTo(-SCREEN_WIDTH/2, 0);
		g.lineTo(SCREEN_WIDTH/2, 0);

      

		
	}



}