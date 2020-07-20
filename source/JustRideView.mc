using Toybox.WatchUi;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.UserProfile;
using Toybox.Activity as Act;
using Toybox.AntPlus as Ant;


     /*
          Line_0-------------------------------   0
               | Aleft         |        Aright |
       BOX A   |               |               |
               |           Amiddle             |
          Line_A ------------- VA -------------   66
               | Btl       Btr             Ctr |
       BOX B   |     Bmid             Cmid     |
               | Bbl                       Cbr |
          Line_B ------------------------------   132
               |                               |
       BOX C   |             Dmiddle           |
               |                               |
          Line_C ------------- VC -------------   198
               |               |               |
       BOX D   |      E        |      F        |
               |               |               |
               |               |               |
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

    const LINE_0 = 0;
    const LINE_A = 66;
    const LINE_B = 132;
    const LINE_C = 198;
    const LINE_D = 264;

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
//        powerInfo = new PowerInfo();
    }

    function compute(info) {
        fields.compute(info);
        lapInfo.compute(info);
//        powerInfo.compute(info);
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

        drawBoxes(dc);
        //Upper Bar
//        drawBattery(dc);
//        drawTime(dc,10,2);
//        drawElapsedTime(dc,dc.getWidth()/2,11);
        //Body
        drawLayout(dc);
        //Footer

        return true;
    }

    function drawLayout(dc) {

        dc.setColor(LINE_COLOR, BACKGROUND_COLOR);

        // horizontal lines
        dc.drawLine(0, LINE_A, dc.getWidth(), LINE_A);
        dc.drawLine(0, LINE_A-1, dc.getWidth(), LINE_A-1);
        dc.drawLine(0, LINE_B, dc.getWidth(), LINE_B);
        dc.drawLine(0, LINE_B-1, dc.getWidth(), LINE_B-1);
        dc.drawLine(0, LINE_C, dc.getWidth(), LINE_C);
        dc.drawLine(0, LINE_D, dc.getWidth(), LINE_D);
        // vertical lines
        dc.drawLine(dc.getWidth()/2, LINE_A, dc.getWidth()/2, 28);
//        dc.drawLine(dc.getWidth()/2, 65, dc.getWidth()/2, LINE_B);
        dc.drawLine(dc.getWidth()/2, LINE_C, dc.getWidth()/2, LINE_D);
    }

    function drawBoxes(dc){
        drawBoxA_Left(dc);
        drawBoxA_Right(dc);
        drawMainBox(dc);
        drawBottomLeftBox(dc);
        drawBottomRightBox(dc);
        drawFootertBox(dc);
    }

    /* BOX A */
    function drawBoxA_Left(dc){

        var lapElapsedDistance = lapInfo.elapsedDistance();

        //LAP Distance
        textAR(dc, (dc.getWidth()/2)-4, LINE_0+15, Gfx.FONT_XTINY,  "Km");
        //Variable size depenging on the lapElapsedDistance
        if(lapElapsedDistance == null || lapElapsedDistance < 1000){
            textC(dc, dc.getWidth()/4, LINE_0+25, Gfx.FONT_NUMBER_MEDIUM, fmt.distance(lapElapsedDistance));
        } else {
            textC(dc, dc.getWidth()/4, LINE_0+25, Gfx.FONT_NUMBER_MILD, fmt.distance(lapElapsedDistance));
        }

        //LAP number
//        textAL(dc, (dc.getWidth()/2)-6,28 , Gfx.FONT_XTINY,  "Lap");
//        getLapString(dc,(dc.getWidth()/2),52);

        //LAP ElapsedTime
        textAR(dc, (dc.getWidth()/2)-6, LINE_0+45, Gfx.FONT_XTINY,  "ET");
        textC(dc, dc.getWidth()/4, LINE_0+50, Gfx.FONT_MEDIUM, fmt.timeOptHour(lapInfo.lapElapsedTime()) );
        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);

        //Info labels (Lap , Data)
//        textAL(dc, (dc.getWidth()/2)-6,LINE_0+47 , Gfx.FONT_XTINY,  "LAP");
//        textAL(dc, (dc.getWidth()/2)-10,LINE_0+57 , Gfx.FONT_XTINY,  "DATA");
        dc.setColor(Gfx.COLOR_BLACK, BACKGROUND_COLOR);
    }

    /* BOX C */
    function drawBoxA_Right(dc){
        //ASC
        textAR(dc, dc.getWidth()-4, LINE_0+15, Gfx.FONT_XTINY,  "ASC");
        textC(dc, (3*dc.getWidth()/4)-3, LINE_0+25, Gfx.FONT_NUMBER_MILD,  fmt.elevation(lapInfo.lapElevation()));
        //VAM
        textAR(dc, dc.getWidth()-4,47 , Gfx.FONT_XTINY,  "VAM");
        textC(dc,  (3*dc.getWidth()/4), LINE_0+50 , Gfx.FONT_MEDIUM, fmt.vam(lapInfo.lapVam()));

        //To insert LAP %
//        textAL(dc,  (dc.getWidth()/2)+2, LINE_0+39 , Gfx.FONT_MEDIUM, 12);
//        textAL(dc,  (dc.getWidth()/2)+20, LINE_0+47 , Gfx.FONT_XTINY, "%");
    }


    /* BOX D */
    function drawMainBox(dc){

var pedalPowerPercent = Ant.PedalPowerBalance.pedalPowerPercent;
var rightPedalIndicator = Ant.PedalPowerBalance.rightPedalIndicator;


        //LEFT
        textAL(dc, 40,LINE_B+3, Gfx.FONT_XTINY,  "Avg");
        textLC(dc, 7, LINE_B+13, Gfx.FONT_SMALL,  fmt.speed(lapInfo.lapAvgSpeed()));
//        textLC(dc, 10, LINE_B+10, Gfx.FONT_SMALL,  fmt.number(lapInfo.lapAvgPower()));

        textAL(dc, 40,LINE_B+28, Gfx.FONT_XTINY,  "Avg");
        textAL(dc, 40,LINE_B+38, Gfx.FONT_XTINY,  "Pwr");
//        textAL(dc, 44,LINE_B+28, Gfx.FONT_XTINY,  "%");
//        textAL(dc, 44,LINE_B+37, Gfx.FONT_XTINY,  "Bal");
//        textLC(dc, 6, LINE_B+40, Gfx.FONT_SMALL,  fmt.number(pedalPowerPercent)+"/"+fmt.number(rightPedalIndicator));

        textLC(dc, 6, LINE_B+40, Gfx.FONT_SMALL,  fmt.number(lapInfo.lapAvgPower()));
//        textLC(dc, 10, LINE_B+10, Gfx.FONT_SMALL,  fmt.speed(lapInfo.lapAvgSpeed()));


        //left bottom
        //textAL(dc, 6,LINE_B+70, Gfx.FONT_XTINY, fields.frontDerailleurSize);
//        textAL(dc, 25,LINE_B+65, Gfx.FONT_XTINY, "PZone");
//        textAL(dc, 6,LINE_B+65, Gfx.FONT_SMALL, fmt.vam(fields.climbRate30sec));
//        drawVamIcon(dc,52,LINE_B+61);
        textAL(dc, 40, LINE_B+68, Gfx.FONT_XTINY,  "R.D.");
        textAL(dc, 13,LINE_B+65, Gfx.FONT_SMALL, fields.rearDerailleurSize);

//        textLC(dc, 6, LINE_B+45, Gfx.FONT_SMALL,  fmt.speed(lapInfo.lapAvgSpeed()));

        //CENTRAL
        textCC(dc, dc.getWidth()/2,LINE_B+3, Gfx.FONT_XTINY,  "Spd km/h");
//        textC(dc, dc.getWidth()/2, LINE_B+34, Gfx.FONT_NUMBER_MILD,  fmt.speed(fields.speed));
        textC(dc, dc.getWidth()/2, LINE_B+34, Gfx.FONT_NUMBER_MILD,  fmt.speed(fields.speed));
        textC(dc, dc.getWidth()/2, LINE_B+66, Gfx.FONT_NUMBER_MEDIUM, fmt.number(fields.power3Sec));
        textCC(dc, dc.getWidth()/2+40,LINE_B+57, Gfx.FONT_XTINY,  "W");
        textCC(dc, dc.getWidth()/2+40,LINE_B+67, Gfx.FONT_XTINY,  "3s");
//        textC(dc, dc.getWidth()/2, LINE_B+45, Gfx.FONT_NUMBER_MEDIUM, fmt.speed(fields.speed));
//        textC(dc, dc.getWidth()/2, LINE_B+74, Gfx.FONT_MEDIUM, fmt.vam(fields.climbRate30sec));
//        drawVamIcon(dc,dc.getWidth()/2+28,LINE_B+61);

        //RIGHT
//        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
//        showGradeIcon(dc,fields.climbLsGrade5Sec);
//        textAL(dc, dc.getWidth()-10,LINE_B+6, Gfx.FONT_XTINY,  "%");
//        textAL(dc, dc.getWidth()-10,LINE_B+16, Gfx.FONT_XTINY,  "5s");
//        drawGrade(dc,dc.getWidth()-13, LINE_B,fields.climbLsGrade10Sec);
//        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);

//        textRC(dc, dc.getWidth()-18, LINE_B+10, Gfx.FONT_SMALL,  fields.rearDerailleurSize);
        textRC(dc, dc.getWidth()-22, LINE_B+14, Gfx.FONT_MEDIUM,  fmt.vam(fields.climbRate30sec));
        drawVamIcon(dc,dc.getWidth()-10,LINE_B+3);
//        textRC(dc, dc.getWidth()-3, LINE_B+5, Gfx.FONT_XTINY,  "GE");
//        textRC(dc, dc.getWidth()-3, LINE_B+13, Gfx.FONT_XTINY,  "AR");



        textAL(dc, dc.getWidth()-10,LINE_B+34, Gfx.FONT_XTINY,  "%");
        textAL(dc, dc.getWidth()-10,LINE_B+44, Gfx.FONT_XTINY,  "5s");

        drawGrade(dc,dc.getWidth()-13, LINE_B+28,fields.climbLsGrade5Sec);

        textRC(dc, dc.getWidth()-14, LINE_B+74, Gfx.FONT_SMALL,  fmt.elevation(fields.altitude));
        textAL(dc, dc.getWidth()-10, LINE_B+70, Gfx.FONT_XTINY,  "m");
        textAL(dc, dc.getWidth()-10 , LINE_B+64, Gfx.FONT_XTINY,  "^");

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
        textAR(dc, x-1, y, ARROW_FONT,  "K");
        textAL(dc, x, y, Gfx.FONT_XTINY,  "m");
        textAL(dc, x+2, y+10,  Gfx.FONT_XTINY,  "h");
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

