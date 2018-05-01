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
    const LINE_C = 172;
    const LINE_D = 244;

    hidden var fields;
    hidden var heartRateZones = [];
    hidden var newLap = false;

    function initialize() {
        fields = new Fields();
        heartRateZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);
        System.println("The user HR zone " + heartRateZones);
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function onTimerLap(){
        System.println("Lap");
        newLap  = true;
    }


    function drawLayout(dc) {

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

        if (newLap){
            fields.setNewLap(newLap);
            newLap = false;
        }

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        drawBoxes(dc);
        //Upper Bar
        drawBattery(dc);
        drawTime(dc);
        drawElapsedTime(dc);
        //Body
        drawLayout(dc);
        //Footer
        return true;
    }

    function drawBoxes(dc){
    /* BOX A */
            //top Left
            textL(dc, 2, LINE_A+2, Graphics.FONT_XTINY,  "Distance (m)");
            //middle
            textC(dc, dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD, fields.elapsedLapDistance);
    //        textC(dc, dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  "30.3");
            textL(dc, (dc.getWidth()/2)-17,47 , Graphics.FONT_XTINY,  "Lap");
            textC(dc,  dc.getWidth()/4, LINE_A+60 , Graphics.FONT_SMALL,  fields.elapsedDistance);
            textL(dc, (dc.getWidth()/2)-17,LINE_A+56 , Graphics.FONT_XTINY,  "Tot");


            /* BOX B */
            //top Left
            textR(dc, dc.getWidth()-2, LINE_A+2, Graphics.FONT_XTINY,  "Climb (m)");
    //        textL(dc, 10+dc.getWidth()/2, LINE_A+25, Graphics.FONT_SMALL,  "12");
            textC(dc, 3*dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  fields.totalAscent);
    //        textC(dc, 3*dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  "12.1");
            textL(dc, dc.getWidth()-17,47 , Graphics.FONT_XTINY,  "Asc");
            textC(dc,  3*dc.getWidth()/4, LINE_A+60 , Graphics.FONT_SMALL, fields.altitude);
            textL(dc, dc.getWidth()-17,LINE_A+56 , Graphics.FONT_XTINY,  "Alt");


            /* BOX D */
            textL(dc, 8,LINE_B+23, Graphics.FONT_XTINY,  "Avg");
            textCnC(dc, dc.getWidth()/2,LINE_B+3, Graphics.FONT_XTINY,  "Speed (km/h)");
            textR(dc, dc.getWidth()-16,LINE_B+18, Graphics.FONT_XTINY,  "%");
            textLC(dc, 6, LINE_B+45, Graphics.FONT_SMALL,  fields.avgSpeed);
            textC(dc, dc.getWidth()/2, LINE_B+45, Graphics.FONT_NUMBER_THAI_HOT, fields.speed);
    //        textRC(dc, dc.getWidth()-3, LINE_B+45, Graphics.FONT_SMALL,  "1000");
            textRC(dc, dc.getWidth()-3, LINE_B+45, Graphics.FONT_NUMBER_MILD,  fields.climbGrade.format("%01d"));
//            textRC(dc, dc.getWidth()-3, LINE_B+45, Graphics.FONT_NUMBER_MILD,  "18");

            textCnC(dc, dc.getWidth()/2, LINE_B+64, Graphics.FONT_SMALL,  "^ "+ fields.vam);
            textL(dc, (dc.getWidth()/2)+25, LINE_B+69, Graphics.FONT_XTINY,  "VAM");


            /* BOX E */
            //top Left
            textL(dc, 2, LINE_C+2, Graphics.FONT_XTINY,  "HR");
            //middle
            textC(dc, dc.getWidth()/4, LINE_C+40, Graphics.FONT_NUMBER_MILD, fields.heartRate?fields.heartRate:"--") ;
            textR(dc, (dc.getWidth()/2)-30,LINE_C+59 , Graphics.FONT_XTINY,  "Max");
    //        dc.drawLine((dc.getWidth()/2)-22, LINE_C+53, (dc.getWidth()/2)-6, LINE_C+53);
            doHrBackground(dc,fields.heartRate);
            textR(dc, (dc.getWidth()/2)-3,LINE_C+54 , Graphics.FONT_SMALL, fields.maxHeartRate?fields.maxHeartRate:"--") ;

            /* BOX F */
            //top Left
            textR(dc, dc.getWidth()-2, LINE_C+2, Graphics.FONT_XTINY,  "RPM");
    //        textR(dc, dc.getWidth()-10, LINE_+25, Graphics.FONT_SMALL,  "1200");
            doCadenceBackground(dc,fields.rpm);
            textC(dc, 3*dc.getWidth()/4, LINE_C+40, Graphics.FONT_NUMBER_MILD, fields.rpm?fields.rpm:"--" );
    }


    function doHrBackground(dc, hr) {
        if (hr == null) {
            return;
        }


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
        dc.fillRectangle(18, LINE_C,  (hr*74/173), 15);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        textR(dc, dc.getWidth()/2-4, LINE_C+2, Graphics.FONT_XTINY,  "z"+zone);

    }

    function doCadenceBackground(dc, cadence) {
        if (cadence == null) {
            return;
        }

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
}