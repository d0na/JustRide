using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.UserProfile;
using Toybox.Activity as Act;

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

    enum
    {
        STOPPED,
        PAUSED,
        RUNNING
    }

    const BACKGROUND_COLOR = Gfx.COLOR_TRANSPARENT;
    const LINE_COLOR = Gfx.COLOR_BLUE;

    const LINE_A = 20;
    const LINE_B = 90;
    const LINE_C = 172;
    const LINE_D = 244;

    hidden var fields;
    hidden var ARROW_FONT;
    hidden var HEART_ICON;
    hidden var lapInfo;
    hidden var hrInfo;
    hidden var fmt;

    function initialize() {
        fields = new Fields();
        lapInfo = new LapInfo();
        hrInfo = new HRInfo();
        fmt = new Formatter();
    }

    function compute(info) {
        fields.compute(info);
        lapInfo.compute(info);
        hrInfo.compute(info.currentHeartRate);

        return 1;
    }

    function onLayout(dc) {
        ARROW_FONT = WatchUi.loadResource(Rez.Fonts.ArrowFont);
        HEART_ICON = WatchUi.loadResource(Rez.Fonts.Heart);
    }

    function onShow() {
    }

    function onHide() {
    }

    function onTimerLap(){
        lapInfo.newLap();
    }

    //! The timer was started, so set the state to running.
    function onTimerStart()
    {
        lapInfo.setTimerState(RUNNING);
    }

    //! The timer was stopped, so set the state to stopped.
    function onTimerStop()
    {
        lapInfo.setTimerState(STOPPED);
    }

    //! The timer was started, so set the state to running.
    function onTimerPause()
    {
        lapInfo.setTimerState(PAUSED);
    }

    //! The timer was stopped, so set the state to stopped.
    function onTimerResume()
    {
        lapInfo.setTimerState(RUNNING);
    }

    //! The timer was reeset, so reset all our tracking variables
    function onTimerReset()
    {
        lapInfo.reset();
    }


    function onUpdate(dc) {

        dc.setColor(Gfx.COLOR_BLACK, BACKGROUND_COLOR);
        dc.clear();

        drawBottomLeftBoxs(dc);
        //Upper Bar
        drawBattery(dc);
        drawTime(dc,10,2);
        drawElapsedTime(dc,dc.getWidth()/2,11);
        //Body
        drawLayout(dc);
        //Footer

        return true;
    }

    function drawLayout(dc) {

        dc.setColor(LINE_COLOR, BACKGROUND_COLOR);

        // horizontal lines
        dc.drawLine(0, LINE_A, dc.getWidth(), LINE_A);
        dc.drawLine(0, LINE_B, dc.getWidth(), LINE_B);
        dc.drawLine(0, LINE_C, dc.getWidth(), LINE_C);
        dc.drawLine(0, LINE_D, dc.getWidth(), LINE_D);
        // vertical lines
        dc.drawLine(dc.getWidth()/2, LINE_A, dc.getWidth()/2, 28);
        dc.drawLine(dc.getWidth()/2, 65, dc.getWidth()/2, LINE_B);
        dc.drawLine(dc.getWidth()/2, LINE_C, dc.getWidth()/2, LINE_D);
    }

    function drawBottomLeftBoxs(dc){
        drawTopLeftBox(dc);
        drawTopRightBox(dc);
        drawMainBox(dc);
        drawBottomLeftBox(dc);
        drawBottomRightBox(dc);
        drawFootertBox(dc);
    }

    /* BOX B */
    function drawTopLeftBox(dc){

        var topLeftLabel =  "Distance (km)";
        var middleField = fmt.distance(lapInfo.elapsedDistance());
        var midRightLabel =  "Lap";

        var botField = fmt.timeOptHour(lapInfo.lapElapsedTime());
        var botLabel = "Avg";


        //top Left
        textAL(dc, 5, LINE_A+2, Gfx.FONT_XTINY,  topLeftLabel);
        //middle
        textC(dc, dc.getWidth()/4, LINE_A+35, Gfx.FONT_NUMBER_MILD, middleField);
        textAL(dc, (dc.getWidth()/2)-6,28 , Gfx.FONT_XTINY,  midRightLabel);
        getLapString(dc,(dc.getWidth()/2),52);
        textC(dc,  dc.getWidth()/4, LINE_A+60 , Gfx.FONT_SMALL, botField );
    }

    /* BOX C */
    function drawTopRightBox(dc){
        //top Left
        textAR(dc, dc.getWidth()-2, LINE_A+2, Gfx.FONT_XTINY,  "Climb (m)");
        textC(dc, (3*dc.getWidth()/4)-3, LINE_A+35, Gfx.FONT_NUMBER_MILD,  fmt.elevation(lapInfo.lapElevation()));
        textAR(dc, dc.getWidth()-5,47 , Gfx.FONT_XTINY,  "Asc");
        textC(dc,  (3*dc.getWidth()/4), LINE_A+60 , Gfx.FONT_SMALL, fmt.vam(lapInfo.lapVam()));
        textAR(dc, dc.getWidth()-5,LINE_A+56 , Gfx.FONT_XTINY,  "Vam");
    }

    function drawMainBox(dc){
        /* BOX D */


        //LEFT
        textAL(dc, 8,LINE_B+23, Gfx.FONT_XTINY,  "Avg");
        textLC(dc, 6, LINE_B+45, Gfx.FONT_SMALL,  fmt.speed(lapInfo.lapAvgSpeed()));

        //CENTRAL
        textCC(dc, dc.getWidth()/2,LINE_B+3, Gfx.FONT_XTINY,  "Speed (km/h)");
        textC(dc, dc.getWidth()/2, LINE_B+45, Gfx.FONT_NUMBER_THAI_HOT, fmt.speed(fields.speed));
        textC(dc, dc.getWidth()/2, LINE_B+74, Gfx.FONT_MEDIUM, fmt.vam(fields.climbRate30sec));
        drawVamIcon(dc,dc.getWidth()/2+22,LINE_B+61);

        //RIGHT
//        showGradeIcon(dc,fields.climbLsGrade5Sec);
        textAL(dc, dc.getWidth()-10,LINE_B+34, Gfx.FONT_XTINY,  "%");
        drawGrade(dc,dc.getWidth()-13, LINE_B+28,fields.climbLsGrade5Sec);

        textRC(dc, dc.getWidth()-3, LINE_B+70, Gfx.FONT_MEDIUM,  fmt.elevation(fields.altitude));

//        textAR(dc, (dc.getWidth()/2)+10, LINE_B+64, Gfx.FONT_SMALL,   fields.avgSpeed);
//        textAL(dc, 30, LINE_B+64, Gfx.FONT_SMALL,   fields.avgSpeed);
//        textAL(dc, (dc.getWidth()/2)+25, LINE_B+69, Gfx.FONT_XTINY,  "m/h");
//        textAR(dc, (dc.getWidth()/2)+23, LINE_B+62, ARROW_FONT,  "K");
    }

    function drawBottomLeftBox(dc){
        /* BOX E */
        //top Left
//            textAL(dc, 5, LINE_C+2, Gfx.FONT_XTINY,  "HR");
//            textAL(dc,3, LINE_C-8, HEART,  "|");
        showBlinkingHeart(dc,fields.heartRate);
        //middle
        textC(dc, dc.getWidth()/4, LINE_C+40, Gfx.FONT_NUMBER_MILD, fmt.simple(fields.heartRate));
        textAR(dc, (dc.getWidth()/2)-30,LINE_C+59 , Gfx.FONT_XTINY,  "Max");
        doHrBackground(dc,fields.heartRate);
        showHeartRateZone(dc,fields.heartRate);

        textAR(dc, (dc.getWidth()/2)-3,LINE_C+54 , Gfx.FONT_SMALL, fmt.simple(fields.maxHeartRate));
    }

    function drawBottomRightBox(dc){
        /* BOX F */
        //top Left
        textAR(dc, dc.getWidth()-2, LINE_C+2, Gfx.FONT_XTINY,  "RPM");
        doCadenceBackground(dc,fields.rpm);
        textC(dc, 3*dc.getWidth()/4, LINE_C+40, Gfx.FONT_NUMBER_MILD, fmt.simple(fields.rpm));
        textAR(dc, dc.getWidth()-30,LINE_C+59 , Gfx.FONT_XTINY,  "Avg");
        textAR(dc, dc.getWidth()-5, LINE_C+54 , Gfx.FONT_SMALL, fmt.simple(lapInfo.lapAvgCadence())) ;
    }

    function drawFootertBox(dc){
            dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
            textAR(dc, 43, LINE_D+4, Gfx.FONT_SMALL,  fmt.distance(fields.elapsedDistance));// fields.elapsedDistance
            dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);  //reset colors
            textAL(dc, 46, LINE_D+7,  Gfx.FONT_XTINY,   "Dst");
            dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);  //reset colors

            textAR(dc, dc.getWidth()/2+7, LINE_D+4, Gfx.FONT_SMALL,   fmt.speed(fields.avgSpeed)); // fields.avgSpeed
            dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);  //reset colors
            textAL(dc, (dc.getWidth()/2)+11, LINE_D+7,  Gfx.FONT_XTINY,   "Avg");
            dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);  //reset colors

            textAR(dc, (3*dc.getWidth()/4)+28, LINE_D+4, Gfx.FONT_SMALL,   fmt.elevation(fields.totalAscent));//fields.totalAscent
            dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);  //reset colors
            textAL(dc, dc.getWidth()-18, LINE_D+7,  Gfx.FONT_XTINY,   "Asc");
            dc.setColor(Gfx.COLOR_LT_GRAY, BACKGROUND_COLOR);  //reset colors

    }

    function showBlinkingHeart(dc,hr){
        var time = System.getClockTime();
        var s = time.sec;
        dc.setColor(Gfx.COLOR_LT_GRAY, BACKGROUND_COLOR);
        if ((hr != null) && (hr > 0) && s != null){
            if (isOdd(s)){
                dc.setColor(Gfx.COLOR_BLACK, BACKGROUND_COLOR);
            }
        }
        textAL(dc,3, LINE_C-8, HEART_ICON,  "|");
        dc.setColor(Gfx.COLOR_BLACK, BACKGROUND_COLOR);
    }

    function showGradeIcon(dc,grade){
        if (grade >= 0.0){
            dc.setColor(Gfx.COLOR_RED, BACKGROUND_COLOR);
            textAR(dc, dc.getWidth()-1,LINE_B+12, ARROW_FONT,  "O");
        } else {
            dc.setColor(Gfx.COLOR_GREEN, BACKGROUND_COLOR);
            textAR(dc, dc.getWidth()-1,LINE_B+12, ARROW_FONT,  "P");
        }
        dc.setColor(Gfx.COLOR_BLACK, BACKGROUND_COLOR);
        textAR(dc, dc.getWidth()-16,LINE_B+14, Gfx.FONT_XTINY,  "%");
    }

    function isOdd(x){
        return x & 1;
    }

    function getHeartValueRange(hr,offset){
        var hrRange= hrInfo.zones[5].toFloat()-hrInfo.zones[0].toFloat();
        var hrNormalized = 0;
        var barWidth = 78;

        if ( hr != null){
           if( hr >=  hrInfo.zones[0]){
                hrNormalized = hr - hrInfo.zones[0]; //lower limit
           } else if ( hr >= hrInfo.zones[5]  ){
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
            color = Gfx.COLOR_DK_GREEN;
        } else if (cadence >= 90) {
            color = Gfx.COLOR_GREEN;
        } else if (cadence >= 80) {
            color = Gfx.COLOR_BLUE;
        } else if (cadence >= 71) {
            color = Gfx.COLOR_YELLOW;
        } else if (cadence >= 65) {
            color = Gfx.COLOR_RED;
        } else if (cadence >= 60) {
            color = Gfx.COLOR_DK_RED;
        } else {
            color = Gfx.COLOR_PURPLE;
        }
        dc.setColor(color, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(dc.getWidth()/2, LINE_C, getCadenceValueRange(cadence), 15);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
    }

    function doHrBackground(dc, hr) {
        if (hr == null) {
            return;
        }

        var range = getHeartValueRange(hr,3);
        dc.setColor(hrInfo.color, Gfx.COLOR_TRANSPARENT);
        dc.fillRectangle(17, LINE_C,  range, 15);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
//        textAR(dc, dc.getWidth()/2-4, LINE_C+2, Gfx.FONT_XTINY,  "z"+zone);

    }

    function showHeartRateZone(dc,hr){
        var rightOffset = 2;
        var zone =7;  //default out of zones range

        if (hrInfo.zone != null){
            zone = hrInfo.zone;
        }

        for (var i = 0; i < hrInfo.zones.size(); i++) {
            if (i > 0 && i < 6){ //skip zone 0 (not really important to show)
                if (zone == i){  //selected zone - hilight
                    dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
                } else { //show other zones - gray
                   dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
                }

            textAR(dc, getHeartValueRange(hrInfo.zones[i-1],25), LINE_C+2, Gfx.FONT_XTINY,  i);
            }
            dc.setColor(Gfx.COLOR_BLACK, BACKGROUND_COLOR);  //reset colors
        }
    }

    function drawBattery(dc) {

         var X = 180;
         var Y = 5;

         var pct = Sys.getSystemStats().battery;
         dc.drawRectangle(X, Y, 18, 11);
         dc.fillRectangle(X, Y, 2, 5);

         var color = Gfx.COLOR_GREEN;
         if (pct < 25) {
             color = Gfx.COLOR_RED;
         } else if (pct < 40) {
             color = Gfx.COLOR_YELLOW;
         }
         dc.setColor(color, Gfx.COLOR_TRANSPARENT);

         var width = (pct * 16.0 / 100 + 0.5).toLong();
         if (width > 0) {
//             Sys.println("" + pct + "=" + width);
             if (width > 16) {
                 width = 16;
             }
             dc.fillRectangle(X+1, Y+1, width, 9);
         }
     }

    function drawTime(dc,x,y) {
        var time = fmt.clock(fields.time);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        textAL(dc,x,y,Gfx.FONT_SMALL,time);
    }

    function drawElapsedTime(dc,x,y) {
        var time = fmt.time(fields.elapsedTime);
        //          var formatedTime = time.hour+":"+time.min;
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
        textC(dc,x,y,Gfx.FONT_SMALL,time);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
    }


    function textAL(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Gfx.TEXT_JUSTIFY_LEFT);
        }
    }

    function textC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Gfx.TEXT_JUSTIFY_CENTER|Gfx.TEXT_JUSTIFY_VCENTER);
        }
    }

    function textCC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Gfx.TEXT_JUSTIFY_CENTER);
        }
    }

    function textAR(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Gfx.TEXT_JUSTIFY_RIGHT);
        }
    }

    function textRC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Gfx.TEXT_JUSTIFY_RIGHT|Gfx.TEXT_JUSTIFY_VCENTER);
        }
    }

    function textLC(dc, x, y, font, s) {
        if (s != null) {
            dc.drawText(x, y, font, s, Gfx.TEXT_JUSTIFY_LEFT|Gfx.TEXT_JUSTIFY_VCENTER);
        }
    }

    function getLapString(dc,x,y){
        var dataColor = lapInfo.getStateTimerColor();
        dc.setColor(dataColor, BACKGROUND_COLOR);
        var lapString = lapInfo.getLapString();
        //! Draw the lap number
        dc.drawText(x,y, Gfx.FONT_SMALL, lapString, (Gfx.TEXT_JUSTIFY_CENTER | Gfx.TEXT_JUSTIFY_VCENTER));
        dc.setColor(Gfx.COLOR_BLACK, BACKGROUND_COLOR);
    }

    function drawVamIcon(dc,x,y){
        textAL(dc, x, y, Gfx.FONT_XTINY,  "m");
        textAL(dc, x, y+9,  Gfx.FONT_XTINY,  "h");
        textAR(dc, x+19, y, ARROW_FONT,  "K");
    }


    function drawGrade(dc,x,y,grade){
        var fontSize;

        if (grade < -9){
           fontSize =  Gfx.FONT_LARGE;
        } else {
            fontSize =  Gfx.FONT_NUMBER_MILD;
        }

        textAR(dc,  x,y, fontSize,  fmt.grade(grade));

    }
}