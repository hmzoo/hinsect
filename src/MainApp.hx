package;
import hinsect.*;

final SCREEN_WIDTH = 500;
final SCREEN_HEIGHT = 500;



class  MainApp  extends hxd.App {

 
    var frame:hinsect.Frame;
    var leg:hinsect.Leg;
    var segment:hinsect.Segment;
    var r:Float;

    override  function  init() {
        r=0;

        frame= new Frame(s2d);

        //leg= new Leg(frame);

  segment=  new Segment(80, 30,20,Math.PI/12,Math.PI-Math.PI/12,10);
  segment.angle = Math.PI/3+Math.PI/2;
  segment.x=SCREEN_WIDTH/2;
  segment.y=SCREEN_HEIGHT/2;
  s2d.addChild(segment);

  segment.redraw();

    }

    override function update(dt:Float) {
      var d=Math.PI*dt/2;
      r=r+d;
      segment.oangle=r;
    //   
       if(r>2*Math.PI){r=r-2*Math.PI;}

       segment.redraw();
   
    }

    override function onResize() {
 
      
        
    }


    public static var inst : MainApp;

    static  function  main() {
        inst=new  MainApp();
    }
  }