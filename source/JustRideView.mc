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
        drawBoxB(dc);
        drawBoxC(dc);
        drawBottomLeftBox(dc);
        drawBottomRightBox(dc);
        drawFootertBox(dc);
    }

    /* BOX A */
    function drawBoxA_Left(dc){

        var lapElapsedDistance = lapInfo.elapsedDistance();

        //LAP Distance
        textAR(dc, (dc.getWidth()/2)-3, LINE_0+15, Gfx.FONT_XTINY,  "K");
        textAR(dc, (dc.getWidth()/2)-2, LINE_0+23, Gfx.FONT_XTINY,  "m");
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
        textAR(dc, (dc.getWidth()/2)-3, LINE_0+45, Gfx.FONT_XTINY,  "E");
        textAR(dc, (dc.getWidth()/2)-3, LINE_0+53, Gfx.FONT_XTINY,  "T");
        textC(dc, dc.getWidth()/4, LINE_0+52, Gfx.FONT_MEDIUM, fmt.timeOptHour(lapInfo.lapElapsedTime()) );
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
        textC(dc,  (3*dc.getWidth()/4), LINE_0+52 , Gfx.FONT_MEDIUM, fmt.vam(lapInfo.lapVam()));

        //To insert LAP %
//        textAL(dc,  (dc.getWidth()/2)+2, LINE_0+39 , Gfx.FONT_MEDIUM, 12);
//        textAL(dc,  (dc.getWidth()/2)+20, LINE_0+47 , Gfx.FONT_XTINY, "%");
    }


    /* BOX B */
    function drawBoxB(dc){

        var refLine = LINE_B;

        var pedalPowerPercent = Ant.PedalPowerBalance.pedalPowerPercent;
        var rightPedalIndicator = Ant.PedalPowerBalance.rightPedalIndicator;

        //LAP AVG Speed
        textLC(dc, 6, refLine+35, Gfx.FONT_SMALL,  "____");
        textLC(dc, 6, refLine+50, Gfx.FONT_SMALL,  fmt.speed(lapInfo.lapAvgSpeed()));
        textAL(dc, 40,refLine+45, Gfx.FONT_XTINY,  "Km/h");

//        textLC(dc, 10, refLine+10, Gfx.FONT_SMALL,  fmt.number(lapInfo.lapAvgPower()));
//        textLC(dc, 10, refLine+10, Gfx.FONT_SMALL,  fmt.speed(lapInfo.lapAvgSpeed()));


        //left bottom
        //textAL(dc, 6,refLine+70, Gfx.FONT_XTINY, fields.frontDerailleurSize);
//        textAL(dc, 25,refLine+65, Gfx.FONT_XTINY, "PZone");
//        textAL(dc, 6,refLine+65, Gfx.FONT_SMALL, fmt.vam(fields.climbRate30sec));
//        drawVamIcon(dc,52,refLine+61);
        textAL(dc, 6, refLine+2, Gfx.FONT_XTINY,  "Gear");
        textAL(dc, 6,refLine+13, Gfx.FONT_MEDIUM, fields.rearDerailleurSize);

//        textLC(dc, 6, refLine+45, Gfx.FONT_SMALL,  fmt.speed(lapInfo.lapAvgSpeed()));

        //CENTRAL
//        textCC(dc, dc.getWidth()/2,refLine+3, Gfx.FONT_XTINY,  "Spd km/h");
//        textC(dc, dc.getWidth()/2, refLine+34, Gfx.FONT_NUMBER_MILD,  fmt.speed(fields.speed));
        textAL(dc, (dc.getWidth()/2)+35,refLine+13, Gfx.FONT_XTINY,  "Km");
        textAL(dc, (dc.getWidth()/2)+35,refLine+23, Gfx.FONT_XTINY,  "h");
        textC(dc, dc.getWidth()/2, refLine+24, Gfx.FONT_NUMBER_MEDIUM,  fmt.speed(fields.speed));

//        textC(dc, dc.getWidth()/2, refLine+45, Gfx.FONT_NUMBER_MEDIUM, fmt.speed(fields.speed));
//        textC(dc, dc.getWidth()/2, refLine+74, Gfx.FONT_MEDIUM, fmt.vam(fields.climbRate30sec));
//        drawVamIcon(dc,dc.getWidth()/2+28,refLine+61);

        //RIGHT
//        dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
//        showGradeIcon(dc,fields.climbLsGrade5Sec);
//        textAL(dc, dc.getWidth()-10,refLine+6, Gfx.FONT_XTINY,  "%");
//        textAL(dc, dc.getWidth()-10,refLine+16, Gfx.FONT_XTINY,  "5s");
//        drawGrade(dc,dc.getWidth()-13, refLine,fields.climbLsGrade10Sec);
//        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);

//        textRC(dc, dc.getWidth()-18, refLine+10, Gfx.FONT_SMALL,  fields.rearDerailleurSize);
        textCC(dc, dc.getWidth()/2, refLine+44, Gfx.FONT_MEDIUM,  fmt.vam(fields.climbRate30sec));
        drawVamIcon(dc,(dc.getWidth()/2)+20,refLine+44);
//        textRC(dc, dc.getWidth()-3, refLine+5, Gfx.FONT_XTINY,  "GxE");
//        textRC(dc, dc.getWidth()-3, refLine+13, Gfx.FONT_XTINY,  "AR");



        textAL(dc, dc.getWidth()-10,refLine+16, Gfx.FONT_XTINY,  "%");
        textAL(dc, dc.getWidth()-10,refLine+26, Gfx.FONT_XTINY,  "5s");

        drawGrade(dc,dc.getWidth()-13, refLine+10,fields.climbLsGrade5Sec);

        textRC(dc, dc.getWidth()-14, refLine+54, Gfx.FONT_SMALL,  fmt.elevation(fields.altitude));
        textAL(dc, dc.getWidth()-10, refLine+45, Gfx.FONT_XTINY,  "m");
        textAL(dc, dc.getWidth()-10 , refLine+40, Gfx.FONT_XTINY,  "^");

//        textAR(dc, (dc.getWidth()/2)+10, refLine+64, Gfx.FONT_SMALL,   fields.avgSpeed);
//        textAL(dc, 30, refLine+64, Gfx.FONT_SMALL,   fields.avgSpeed);
//        textAL(dc, (dc.getWidth()/2)+25, refLine+69, Gfx.FONT_XTINY,  "m/h");
//        textAR(dc, (dc.getWidth()/2)+23, refLine+62, ARROW_FONT,  "K");
    }


    function drawBoxC(dc){

            var refLine = LINE_A;

            drawPowerChart(dc);

            textC(dc, dc.getWidth()/2, refLine+46, Gfx.FONT_NUMBER_HOT, fmt.number(fields.power3Sec));
            textCC(dc, dc.getWidth()/2+40,refLine+37, Gfx.FONT_XTINY,  "W");
            textCC(dc, dc.getWidth()/2+40,refLine+47, Gfx.FONT_XTINY,  "3s");

            textLC(dc, 6, refLine+35, Gfx.FONT_SMALL,  "____");
            textLC(dc, 6, refLine+50, Gfx.FONT_SMALL,  fmt.number(lapInfo.lapAvgPower()));
            textAL(dc, 35,refLine+47, Gfx.FONT_XTINY,  "W");

            var powerZone =  getPowerZone(fields.power3Sec,274);

            textLC(dc, dc.getWidth()-25, refLine+50, Gfx.FONT_SMALL,  fmt.number2d(powerZone));
            textAL(dc, dc.getWidth()-32,refLine+47, Gfx.FONT_XTINY,  "Z");

            if(powerZone != null && powerZone > 0){
                var zoneArrow = ((powerZone-1)/7)*dc.getWidth();
                drawVamIcon(dc,zoneArrow+9,refLine+6);
            }
    }

    function drawBottomLeftBox(dc){
        /* BOX E */
        //top Left
//            textAL(dc, 5, LINE_C+2, Gfx.FONT_XTINY,  "HR");
//            textAL(dc,3, LINE_C-8, HEART,  "|");
        showBlinkingHeart(dc,fields.heartRate);
        //middle
        textC(dc, dc.getWidth()/4, LINE_C+40, Gfx.FONT_NUMBER_MILD, fmt.simple(fields.heartRate));
        textAR(dc, (dc.getWidth()/2)-30,LINE_C+57 , Gfx.FONT_XTINY,  "Max");
        doHrBackground(dc,fields.heartRate);
        showHeartRateZone(dc,fields.heartRate);

        textAR(dc, (dc.getWidth()/2)-3,LINE_C+52 , Gfx.FONT_SMALL, fmt.simple(fields.maxHeartRate));
    }

    function drawBottomRightBox(dc){
        /* BOX F */
        //top Left
        textAR(dc, dc.getWidth()-2, LINE_C+2, Gfx.FONT_XTINY,  "RPM");
        doCadenceBackground(dc,fields.rpm);
        textC(dc, 3*dc.getWidth()/4, LINE_C+40, Gfx.FONT_NUMBER_MILD, fmt.simple(fields.rpm));
        textAR(dc, dc.getWidth()-30,LINE_C+57 , Gfx.FONT_XTINY,  "Avg");
        textAR(dc, dc.getWidth()-5, LINE_C+52 , Gfx.FONT_SMALL, fmt.simple(lapInfo.lapAvgCadence())) ;
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

    function getPowerZone(power,ftp){

        if (power == null) {
            return ;
        }

        //Zone 7 > 150%
        if(power > ftp*1.5){
            var range = (ftp*2) - (ftp*1.5);
            var powern = power -range;
            return 7+(powern/(ftp*1.5));
                    //Zone 6 > 120%
        } else if (power > (ftp*1.2)){

            var range = (ftp*1.5) - (ftp*1.2);
            var powern = power -range;
            return 6+(powern/(ftp*1.2));             //Zone 5 > 105%

        } else if (power > (ftp*1.05)){

           var range = (ftp*1.2) - (ftp*1.05);
            var powern = power -range;
            return 5+(powern/(ftp*1.05));

        //Zone 4 > 90%

        } else if (power > (ftp*0.9)){

           var range = (ftp*1.05) - (ftp*0.9);
            var powern = power -(ftp*0.9);
            return 4+(powern/range);

        //Zone 3 > 75%
        } else if (power > (ftp*0.75)){

            var range = (ftp*0.9) - (ftp*0.75);
            var powern = power -(ftp*0.75);
            return 3+(powern/range);

        //Zone 2 > 55%
        } else if (power > (ftp*0.55)){

            var range = (ftp*0.75) - (ftp*0.55);
            var powern = power - (ftp*0.55);

            return 2+(powern/range);

        //Zone 1 > 0%
        } else if (power > 0){
            return 1+(power.toFloat()/(ftp*0.55));
        }
    }


    const BLOCK = 29;

    function drawPowerChart(dc){
        //width = 215 => 215/7 = 30
        drawRectangle(dc,Gfx.COLOR_LT_GRAY,0,BLOCK);
        drawRectangle(dc,Gfx.COLOR_BLUE,1*BLOCK,BLOCK);
        drawRectangle(dc,Gfx.COLOR_GREEN,2*BLOCK,BLOCK);
        drawRectangle(dc,Gfx.COLOR_YELLOW,3*BLOCK,BLOCK);
        drawRectangle(dc,Gfx.COLOR_ORANGE,4*BLOCK,BLOCK);
        drawRectangle(dc,Gfx.COLOR_RED,5*BLOCK,BLOCK);
        drawRectangle(dc,Gfx.COLOR_PURPLE,6*BLOCK,BLOCK);
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
    }

    function drawRectangle(dc,color,startPoint,lenght){
            dc.setColor(color, Gfx.COLOR_TRANSPARENT);
            dc.fillRectangle(startPoint, LINE_A, lenght, 15);
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
//        textAL(dc, x, y, Gfx.FONT_XTINY,  "m");
//        textAL(dc, x, y+9,  Gfx.FONT_XTINY,  "h");

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

