package;
import hinsect.*;

final SCREEN_WIDTH = 500;
final SCREEN_HEIGHT = 500;



class  MainApp  extends hxd.App {

 
    var frame:hinsect.Frame;
    var leg:hinsect.Leg;
    var seg_a:hinsect.Segment;
    var r:Float;

    override  function  init() {
        r=0;
        var a = -20*Pit.PI/3;
        var z= Pit.deg(a);
        trace(z);

  //       frame= new Frame(s2d);

  //       //leg= new Leg(frame);

  // seg_a=  new Segment(80, 30,20);
  // seg_a.x=SCREEN_WIDTH/2;
  // seg_a.y=SCREEN_HEIGHT/2;
  // seg_a.set_angle_start (Math.PI/3+Math.PI/2);

  // seg_a.place(50,80,0);
  // s2d.addChild(seg_a);

  // seg_a.redraw();

    }

    override function update(dt:Float) {
      r=r+Math.PI*dt/2;
      if(r>2*Math.PI){r=r-2*Math.PI;}
    //  segment.abs_a=r;
    //   
      

       //seg_a.redraw();
   
    }

    override function onResize() {
 
      
        
    }


    public static var inst : MainApp;

    static  function  main() {
        inst=new  MainApp();
    }
  }