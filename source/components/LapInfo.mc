using Toybox.Activity as Act;
using Toybox.System as Sys;

class LapInfo {

    hidden var lapCounter = 0;
    hidden var split = false;
    hidden var timerState = STOPPED;
    hidden var lapCertainty = "";

    hidden var lastElapsedDistance = 0;
    hidden var lastElapsedTime = 0;
    hidden var lastTotAscent = 0;
    hidden var lapAvgRpm = 0;
    hidden var lapAvgHR = 0;
    hidden var _lapAvgPower = 0;
    hidden var prevAlt = 0;
    hidden var curAlt = 0;
    hidden var info;
    hidden var metric = 0;
    hidden var tick = 0;
    hidden var tickPwr = 0;
    hidden var tickRPM = 0;
    hidden var tickHR = 0;

    enum
    {
        STOPPED,
        PAUSED,
        RUNNING
    }

    function initialize(){
        info = Act.getActivityInfo();
        metric=(Toybox.System.getDeviceSettings().paceUnits==Toybox.System.UNIT_METRIC);
        //! If the activity timer is greater than 0, then we don't know the lap or timer state.
        if( (info.timerTime != null) && (info.timerTime > 0) )
        {
            lapCertainty = "?";
        }
    }

    function compute(info){
        me.info = info;
        me.tick++;
    }


    function newLap(){
        lapCounter++;
        me.lastElapsedDistance = info.elapsedDistance;
        me.lastTotAscent = info.totalAscent;
        me.lastElapsedTime = info.timerTime;
        me.lapAvgRpm = 0;
        me.lapAvgHR = 0;
        me.tick = 0;
        me.tickPwr = 0;
        me.tickRPM = 0;
        me._lapAvgPower = 0;
        me.tickHR = 0;
    }


    function setTimerState(state){
        timerState = state;
    }



    function reset(){
        lapCounter = 0;
        timerState = STOPPED;
        lapCertainty = "";
    }

    function getStateTimerColor(){
        //! Select text color based on timer state.
        if( timerState == null )
        {
            return Graphics.COLOR_BLACK;
        }
        else if( timerState == RUNNING )
        {
            return   Graphics.COLOR_GREEN;
        }
        else if( timerState == PAUSED )
        {
            return Graphics.COLOR_YELLOW;
        }
        else
        {
            return Graphics.COLOR_RED;
        }
    }

    function getLapString(){
        return lapCounter.format("%d") + lapCertainty;
    }


    //Get last lap Elapsed Distance
    function elapsedDistance(){
        if (info.elapsedDistance == null || me.lastElapsedDistance == null){
            return null;
        }
        return info.elapsedDistance - me.lastElapsedDistance;
    }

    function lapElapsedTime(){
        if (info.timerTime == null || me.lastElapsedTime == null){
            return null;
        }

        return (info.timerTime - me.lastElapsedTime);
    }

    function lapElevation(){

        if (info.totalAscent == null || me.lastTotAscent == null){
            return null;
        }
        return info.totalAscent-me.lastTotAscent;
    }

    function lapVam(){

        var gain =  lapElevation();
        var timeInSec = lapElapsedTime();
        var res= 0;

        if (gain == null || timeInSec == null ){
            return null;
        }
        timeInSec = timeInSec.toFloat()/1000; //transform time in sec

        if (timeInSec > 0 ){
            res = gain * 3600/timeInSec;
        }
        return res;
    }

    function lapAvgSpeed(){

        var dist = 0.0;
        var time = 0.0;

        if (elapsedDistance() == null ||  lapElapsedTime() == null){
            return null;
        }

        dist = elapsedDistance();
        time = lapElapsedTime()/1000;

        if (dist == null ||  time == null || time <= 0){
            return null;
        }
        return (dist/time);

    }

    function lapAvgCadence(){

        if (info.currentCadence != null && info.currentCadence > 0){
            tickRPM++;
            lapAvgRpm += info.currentCadence;
            return lapAvgRpm/tickRPM;
        }

        return null;
    }

//    function lapAvgHeartRate(){
//
//        if (info.currentHeartRate != null && info.currentHeartRate > 0){
//            tickHR++;
//            lapAvgHR += info.currentHeartRate;
//            return lapAvgHR/tickHR;
//        }
//
//        return null;
//    }

    function lapAvgPower(){
            if (info.currentPower != null ){
                tickPwr++;
                _lapAvgPower += info.currentPower;

                return _lapAvgPower/tickPwr;
            }

            return null;
        }
}