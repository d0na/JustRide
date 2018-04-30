using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System as Sys;
using Toybox.UserProfile;

     /*
                -------------------------------     0
           A   | Aleft                  Aright |  20
               |           Amiddle             |
               A ------------- VA -------------
               | Btl       Btr |           Ctr |
               |     Bmid      |      Cmid     |  70
               | Bbl           |           Cbr |
               B ------------------------------
               |                               |
               |             Dmiddle           |  80
               |                               |
               C ------------- VC -------------
               |               |               |
               |      E        |      F        |  70
               |               |               |
               D ------------------------------
               |              G                |   20
                -------------------------------  264

            215x263
         */


class JustRideView extends WatchUi.DataField {

    const BACKGROUND_COLOR = Graphics.COLOR_WHITE;
    const LINE_COLOR = Graphics.Graphics.COLOR_BLUE;

    const LINE_A = 20;
    const LINE_B = 90;
    const LINE_C = 170;
    const LINE_D = 244;

    hidden var fields;
    hidden var heartRateZones = [];

    function initialize() {
        fields = new Fields();
        heartRateZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);
        System.println("The user was born in " + heartRateZones);
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function drawLayout(dc) {

//            System.println( LINE_A+ "\n" );

        dc.setColor(LINE_COLOR, BACKGROUND_COLOR);

        // horizontal lines
        dc.drawLine(0, LINE_A, dc.getWidth(), LINE_A);
        dc.drawLine(0, LINE_B, dc.getWidth(), LINE_B);
        dc.drawLine(0, LINE_C, dc.getWidth(), LINE_C);
        dc.drawLine(0, LINE_D, dc.getWidth(), LINE_D);
        // vertical lines
        dc.drawLine(dc.getWidth()/2, LINE_A, dc.getWidth()/2, LINE_B);
        dc.drawLine(dc.getWidth()/2, LINE_C, dc.getWidth()/2, LINE_D);
    }

    function onUpdate(dc) {

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        /* BOX A */
        //top Left
        textL(dc, 2, LINE_A+2, Graphics.FONT_XTINY,  "Distance");
        //middle
        textC(dc, dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  "---");
//        textC(dc, dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  "30.3");
        textL(dc, (dc.getWidth()/2)-17,47 , Graphics.FONT_XTINY,  "Lap");
        textC(dc,  dc.getWidth()/4, LINE_A+60 , Graphics.FONT_SMALL,  toStr(fields.elapsedDistance));
        textL(dc, (dc.getWidth()/2)-17,LINE_A+56 , Graphics.FONT_XTINY,  "Tot");


        /* BOX B */
        //top Left
        textR(dc, dc.getWidth()-2, LINE_A+2, Graphics.FONT_XTINY,  "Elevation");
//        textR(dc, dc.getWidth()-10, LINE_A+25, Graphics.FONT_SMALL,  "1200");
//        textL(dc, 10+dc.getWidth()/2, LINE_A+25, Graphics.FONT_SMALL,  "12");
        textC(dc, 3*dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  "---");
//        textC(dc, 3*dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  "12.1");
        textL(dc, dc.getWidth()-17,47 , Graphics.FONT_XTINY,  "%");
        textC(dc,  3*dc.getWidth()/4, LINE_A+60 , Graphics.FONT_SMALL,  toStr(fields.totalAscent));
        textL(dc, dc.getWidth()-17,LINE_A+56 , Graphics.FONT_XTINY,  "Tot");


        /* BOX D */
        textL(dc, 4,LINE_B+23, Graphics.FONT_XTINY,  "Avg");
        textCnC(dc, dc.getWidth()/2,LINE_B+3, Graphics.FONT_XTINY,  "Speed");
        textR(dc, dc.getWidth()-5,LINE_B+23, Graphics.FONT_XTINY,  "Vam");
        textLC(dc, 3, LINE_B+45, Graphics.FONT_SMALL,  toStr(fields.avgSpeed));
        textC(dc, dc.getWidth()/2, LINE_B+45, Graphics.FONT_NUMBER_THAI_HOT,  toStr(fields.speed));
//        textRC(dc, dc.getWidth()-3, LINE_B+45, Graphics.FONT_SMALL,  "1000");
        textRC(dc, dc.getWidth()-3, LINE_B+45, Graphics.FONT_SMALL,  "---");


        /* BOX E */
        //top Left
        textL(dc, 2, LINE_C+2, Graphics.FONT_XTINY,  "HR");
        //middle
        textC(dc, dc.getWidth()/4, LINE_C+40, Graphics.FONT_NUMBER_MILD, toStr(fields.heartRate) );
        textR(dc, (dc.getWidth()/2)-30,LINE_C+59 , Graphics.FONT_XTINY,  "Max");
//        dc.drawLine((dc.getWidth()/2)-22, LINE_C+53, (dc.getWidth()/2)-6, LINE_C+53);
        doHrBackground(dc,fields.heartRate);
        textR(dc, (dc.getWidth()/2)-3,LINE_C+54 , Graphics.FONT_SMALL,  toStr(fields.maxHeartRate) );

        /* BOX F */
        //top Left
        textR(dc, dc.getWidth()-2, LINE_C+2, Graphics.FONT_XTINY,  "RPM");
//        textR(dc, dc.getWidth()-10, LINE_+25, Graphics.FONT_SMALL,  "1200");
        doCadenceBackground(dc,fields.rpm);
        textC(dc, 3*dc.getWidth()/4, LINE_C+40, Graphics.FONT_NUMBER_MILD, toStr(fields.rpm) );

//        textL(dc, 36, 45, Graphics.FONT_NUMBER_MEDIUM,  fields.half);
//        if (fields.halfSecs != null) {
//            var length = dc.getTextWidthInPixels(fields.half, Graphics.FONT_NUMBER_MEDIUM);
//            textL(dc, 36 + length + 1, 55, Graphics.FONT_NUMBER_MILD, fields.halfSecs);
//        }
//        textL(dc, 55, 18, Graphics.      , "HALF");
//
//        textL(dc, 112, 45, Graphics.FONT_NUMBER_MEDIUM,  fields.timer);
//        if (fields.timerSecs != null) {
//            var length = dc.getTextWidthInPixels(fields.timer, Graphics.FONT_NUMBER_MEDIUM);
//            textL(dc, 112 + length + 1, 55, Graphics.FONT_NUMBER_MILD, fields.timerSecs);
//        }
//
//        textL(dc, 120, 18, Graphics.FONT_XTINY,  "TIMER");
//
//        doCadenceBackground(dc, fields.cadenceN);
//        textC(dc, 30, 107, Graphics.FONT_NUMBER_MEDIUM, fields.cadence);
//        textC(dc, 30, 79, Graphics.FONT_XTINY,  "CAD");
//
//        textC(dc, 110, 107, Graphics.FONT_NUMBER_MEDIUM, fields.pace10s);
//        textL(dc, 78, 79, Graphics.FONT_XTINY,  "PACE 10s");
//
//        doHrBackground(dc, fields.hrN);
//        textC(dc, 180, 107, Graphics.FONT_NUMBER_MEDIUM, fields.hr);
//        textC(dc, 180, 79, Graphics.FONT_XTINY,  "HR");
//
//
//        textC(dc, 66, 154, Graphics.FONT_NUMBER_MEDIUM, fields.dist);
//        textL(dc, 54, 186, Graphics.FONT_XTINY, "DIST");
//
//        textC(dc, 150, 154, Graphics.FONT_NUMBER_MEDIUM, fields.paceAvg);
//        textL(dc, 124, 186, Graphics.FONT_XTINY, "A PACE");
//
//        textL(dc, 75, 206, Graphics.FONT_TINY, fields.time);

        //Upper Bar
        drawBattery(dc);
        drawTime(dc);
        drawElapsedTime(dc);
        //Body
        drawLayout(dc);
        //Footer
        return true;
    }

    function doHrBackground(dc, hr) {
        if (hr == null) {
            return;
        }
        hr = 90;
        var color;
        var zone;
        if (hr >= heartRateZones[5]) {
            zone = 6;
            color = Graphics.COLOR_PURPLE;
        } else if (hr > heartRateZones[4]) {
            zone = 5;
            color = Graphics.COLOR_DK_RED;
        } else if (hr > heartRateZones[3]) {
            zone = 4;
            color = Graphics.COLOR_RED;
        } else if (hr > heartRateZones[2]) {
            zone = 3;
            color = Graphics.COLOR_ORANGE;
        } else if (hr > heartRateZones[1]) {
            zone = 2;
            color = Graphics.COLOR_YELLOW;
        } else if (hr > heartRateZones[0]) {
            zone = 1;
            color = Graphics.COLOR_GREEN;
        } else {
            zone = 0;
            color = Graphics.COLOR_LT_GRAY;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(25, LINE_C,  (hr*70/173), 15);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        textR(dc, dc.getWidth()/2-4, LINE_C+2, Graphics.FONT_XTINY,  "Z"+zone);

    }

    function doCadenceBackground(dc, cadence) {
        if (cadence == null) {
            return;
        }

        cadence = 50;

        var color;
        if (cadence >= 100) {
            color = Graphics.COLOR_DK_GREEN;
        } else if (cadence >= 90) {
            color = Graphics.COLOR_GREEN;
        } else if (cadence >= 80) {
            color = Graphics.COLOR_BLUE;
        } else if (cadence >= 71) {
            color = Graphics.COLOR_YELLOW;
        } else if (cadence >= 65) {
            color = Graphics.COLOR_RED;
        } else if (cadence >= 60) {
            color = Graphics.COLOR_DK_RED;
        } else {
            color = Graphics.COLOR_PURPLE;
        }
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(dc.getWidth()/2, LINE_C, cadence*54/80, 15);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    }

    function drawBattery(dc) {

         var X = 180;
         var Y = 5;

         var pct = Sys.getSystemStats().battery;
         dc.drawRectangle(X, Y, 18, 11);
         dc.fillRectangle(X, Y, 2, 5);

         var color = Graphics.COLOR_GREEN;
         if (pct < 25) {
             color = Graphics.COLOR_RED;
         } else if (pct < 40) {
             color = Graphics.COLOR_YELLOW;
         }
         dc.setColor(color, Graphics.COLOR_TRANSPARENT);

         var width = (pct * 16.0 / 100 + 0.5).toLong();
         if (width > 0) {
//             Sys.println("" + pct + "=" + width);
             if (width > 16) {
                 width = 16;
             }
             dc.fillRectangle(X+1, Y+1, width, 9);
         }
     }

     function drawTime(dc) {
          var time = fields.time;
          dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
          textL(dc,5,5,Graphics.FONT_XTINY,time);
      }

     function drawElapsedTime(dc) {
          var time = fields.elapsedTime;
//          var formatedTime = time.hour+":"+time.min;
          dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
          textC(dc,dc.getWidth()/2,11,Graphics.FONT_SMALL,time);
      }

    function compute(info) {
        fields.compute(info);
        return 1;
    }

    function textL(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    function textC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    function textCnC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    function textR(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT);
        }
    }

    function textRC(dc, x, y, font, s) {
            if (s != null) {
                dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_RIGHT|Graphics.TEXT_JUSTIFY_VCENTER);
            }
    }

    function textLC(dc, x, y, font, s) {
            if (s != null) {
                dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT|Graphics.TEXT_JUSTIFY_VCENTER);
            }
    }

    function toStr(o) {
            if (o != null) {
                return "" + o;
            } else {
                return "---";
            }
    }
}