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
    hidden var ARROW_FONT;
    hidden var HEART;

    function initialize() {
        fields = new Fields();
        heartRateZones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);
        System.println("The user HR zone " + heartRateZones);
    }

    function onLayout(dc) {
        ARROW_FONT = WatchUi.loadResource(Rez.Fonts.ArrowFont);
        HEART = WatchUi.loadResource(Rez.Fonts.Heart);
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
            textAlignLeft(dc, 5, LINE_A+2, Graphics.FONT_XTINY,  "Distance (m)");
            //middle
            textCentered(dc, dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD, fields.elapsedLapDistance);
    //        textCentered(dc, dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  "30.3");
            textAlignLeft(dc, (dc.getWidth()/2)-17,47 , Graphics.FONT_XTINY,  "Lap");
            textCentered(dc,  dc.getWidth()/4, LINE_A+60 , Graphics.FONT_SMALL,  fields.elapsedDistance);
            textAlignLeft(dc, (dc.getWidth()/2)-17,LINE_A+56 , Graphics.FONT_XTINY,  "Tot");


            /* BOX B */
            //top Left
            textAlignRight(dc, dc.getWidth()-2, LINE_A+2, Graphics.FONT_XTINY,  "Climb (m)");
    //        textAlignLeft(dc, 10+dc.getWidth()/2, LINE_A+25, Graphics.FONT_SMALL,  "12");
            textCentered(dc, 3*dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  fields.totalAscent);
    //        textCentered(dc, 3*dc.getWidth()/4, LINE_A+35, Graphics.FONT_NUMBER_MILD,  "12.1");
            textAlignLeft(dc, dc.getWidth()-17,47 , Graphics.FONT_XTINY,  "Asc");
            textCentered(dc,  3*dc.getWidth()/4, LINE_A+60 , Graphics.FONT_SMALL, fields.altitude);
            textAlignLeft(dc, dc.getWidth()-17,LINE_A+56 , Graphics.FONT_XTINY,  "Alt");


            /* BOX D */
            textAlignLeft(dc, 8,LINE_B+23, Graphics.FONT_XTINY,  "Avg");
            textCnC(dc, dc.getWidth()/2,LINE_B+3, Graphics.FONT_XTINY,  "Speed (km/h)");
            showGradeIcon(dc,fields.climbGrade);
            textLC(dc, 6, LINE_B+45, Graphics.FONT_SMALL,  fields.avgSpeed);
            textCentered(dc, dc.getWidth()/2, LINE_B+45, Graphics.FONT_NUMBER_THAI_HOT, fields.speed);
    //        textRC(dc, dc.getWidth()-3, LINE_B+45, Graphics.FONT_SMALL,  "1000");
            textRC(dc, dc.getWidth()-3, LINE_B+45, Graphics.FONT_NUMBER_MILD,  fields.climbGrade.format("%01d"));
//            textRC(dc, dc.getWidth()-3, LINE_B+45, Graphics.FONT_NUMBER_MILD,  "18");


            textAlignRight(dc, (dc.getWidth()/2)+10, LINE_B+64, Graphics.FONT_SMALL,  fields.vam);
            textAlignLeft(dc, (dc.getWidth()/2)+25, LINE_B+69, Graphics.FONT_XTINY,  "m/s");
            textAlignRight(dc, (dc.getWidth()/2)+23, LINE_B+62, ARROW_FONT,  "K");


            /* BOX E */
            //top Left
//            textAlignLeft(dc, 5, LINE_C+2, Graphics.FONT_XTINY,  "HR");
//            textAlignLeft(dc,3, LINE_C-8, HEART,  "|");
            showBlinkingHeart(dc,fields.heartRate);
            //middle
            textCentered(dc, dc.getWidth()/4, LINE_C+40, Graphics.FONT_NUMBER_MILD, fields.heartRate?fields.heartRate:"--") ;

            textAlignRight(dc, (dc.getWidth()/2)-30,LINE_C+59 , Graphics.FONT_XTINY,  "Max");
    //        dc.drawLine((dc.getWidth()/2)-22, LINE_C+53, (dc.getWidth()/2)-6, LINE_C+53);
            doHrBackground(dc,fields.heartRate);
            showHeartRateZone(dc,fields.heartRate);

            textAlignRight(dc, (dc.getWidth()/2)-3,LINE_C+54 , Graphics.FONT_SMALL, fields.maxHeartRate?fields.maxHeartRate:"--") ;

            /* BOX F */
            //top Left
            textAlignRight(dc, dc.getWidth()-2, LINE_C+2, Graphics.FONT_XTINY,  "RPM");
    //        textAlignRight(dc, dc.getWidth()-10, LINE_+25, Graphics.FONT_SMALL,  "1200");
            doCadenceBackground(dc,fields.rpm);
            textCentered(dc, 3*dc.getWidth()/4, LINE_C+40, Graphics.FONT_NUMBER_MILD, fields.rpm?fields.rpm:"--" );
    }


    function showBlinkingHeart(dc,hr){
        var time = System.getClockTime();
        var s = time.sec;
        if ((hr != null) && (hr > 0) && s != null){
            if (isOdd(s)){
                dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
            } else {
                dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_WHITE);
            }
        }
        textAlignLeft(dc,3, LINE_C-8, HEART,  "|");
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

    }



    function showGradeIcon(dc,grade){
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_WHITE);
        if (grade >= 0){
            textAlignRight(dc, dc.getWidth()-1,LINE_B+12, ARROW_FONT,  "O");
        } else {
            textAlignRight(dc, dc.getWidth()-1,LINE_B+12, ARROW_FONT,  "P");
        }
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        textAlignRight(dc, dc.getWidth()-16,LINE_B+14, Graphics.FONT_XTINY,  "%");
    }

    function isOdd(x){
        return x & 1;
    }

    function getHeartValueRange(hr,offset){
        var hrRange= heartRateZones[5].toFloat()-heartRateZones[0].toFloat();
        var hrNormalized = 0;
        var barWidth = 78;

        if ( hr != null){
           if( hr >=  heartRateZones[0]){
                hrNormalized = hr - heartRateZones[0]; //lower limit
           } else if ( hr >= heartRateZones[5]  ){
                hrNormalized = barWidth; //upper limit
           }
        }

        return ((hrNormalized/hrRange)*barWidth)+offset;
    }

    function getCadenceValueRange(rpm){
        return (rpm/120.0)*80;
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
        dc.fillRectangle(dc.getWidth()/2, LINE_C, getCadenceValueRange(cadence), 15);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    }

    function doHrBackground(dc, hr) {
        if (hr == null) {
            return;
        }

        var color;
        var zone;
        var range = getHeartValueRange(hr,3);
        System.println("range:"+range);
        if (hr >= heartRateZones[5]) {
            zone = 6;
            color = Graphics.COLOR_PURPLE;
        } else if (hr >= heartRateZones[4]) {
            zone = 5;
            color = Graphics.COLOR_RED;
        } else if (hr >= heartRateZones[3]) {
            zone = 4;
            color = Graphics.COLOR_ORANGE;
        } else if (hr >= heartRateZones[2]) {
            zone = 3;
            color = Graphics.COLOR_YELLOW;
        } else if (hr >= heartRateZones[1]) {
            zone = 2;
            color = Graphics.COLOR_GREEN;
        } else if (hr >= heartRateZones[0]) {
            zone = 1;
            color = Graphics.COLOR_BLUE;
        } else {
            zone = 0;
            color = Graphics.COLOR_LT_GRAY;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(17, LINE_C,  range, 15);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
//        textAlignRight(dc, dc.getWidth()/2-4, LINE_C+2, Graphics.FONT_XTINY,  "z"+zone);

    }

    function showHeartRateZone(dc,hr){
        var rightOffset = 2;
        var zone =7;  //default out of zones range

        if (hr != null){
            if (hr >= heartRateZones[5]) {
                zone = 6;  //should be impossibile to reach
            } else if (hr >= heartRateZones[4]) {
                zone = 5;  //upper zone
            } else if (hr >= heartRateZones[3]) {
                zone = 4;
            } else if (hr >= heartRateZones[2]) {
                zone = 3;
            } else if (hr >= heartRateZones[1]) {
                zone = 2;
            } else if (hr >= heartRateZones[0]) {
                zone = 1;
            } else {
                zone = 0;
            }
        }

        for (var i = 0; i < heartRateZones.size(); i++) {
            if (i > 0 && i < 6){ //skip zone 0 (not really important to show)
                if (zone == i){  //selected zone - hilight
                    dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
                } else { //show other zones - gray
                   dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
                }

            textAlignRight(dc, getHeartValueRange(heartRateZones[i-1],25), LINE_C+2, Graphics.FONT_XTINY,  i);
            }
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);  //reset colors
        }
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
          textAlignLeft(dc,5,5,Graphics.FONT_XTINY,time);
      }

     function drawElapsedTime(dc) {
          var time = fields.elapsedTime;
//          var formatedTime = time.hour+":"+time.min;
          dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
          textCentered(dc,dc.getWidth()/2,11,Graphics.FONT_SMALL,time);
      }

    function compute(info) {
        fields.compute(info);
        return 1;
    }

    function textAlignLeft(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    function textCentered(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER|Graphics.TEXT_JUSTIFY_VCENTER);
        }
    }

    function textCnC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    function textAlignRight(dc, x, y, font, s) {
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