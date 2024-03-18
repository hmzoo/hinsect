package;

import hinsect.*;

class  MainApp  extends hxd.App {

 
    var frame:hinsect.Frame;
    var leg:hinsect.Leg;
    var r:Float;

    override  function  init() {
        r=0;

        frame= new Frame(s2d);

        leg= new Leg(frame);

        //l.print();

        

    }

    override function update(dt:Float) {
      var d=Math.PI*dt/10;
      r=r+d;
      if(r>2*Math.PI){r=r-2*Math.PI;}

      leg.update(r);
   
    }

    override function onResize() {
 
      
        
    }


    public static var inst : MainApp;

    static  function  main() {
        inst=new  MainApp();
    }
  }