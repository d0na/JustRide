using Toybox.Activity as Act;

class LapInfo {

    hidden var lapCounter = 0;
    hidden var split = false;
    hidden var timerState = STOPPED;
    hidden var lapCertainty = "";

    hidden var lastElapsedDistance = 0;
    hidden var lastElapsedTime = 0;
    hidden var lastAltitude = 0;
    hidden var info;
    hidden var metric = 0;

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
    }


    function newLap(){
        lapCounter++;
        me.lastElapsedDistance = info.elapsedDistance;
        me.lastAltitude = info.altitude;
        me.lastElapsedTime = info.elapsedTime;
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
        return fmtDistance(info.elapsedDistance - me.lastElapsedDistance);
    }

    function lapElapsedTime(){
        if (info.elapsedTime == null || me.lastElapsedTime == null){
            return null;
        }

        return (info.elapsedTime - me.lastElapsedTime);
    }

    function lapElevation(){

        if (info.altitude == null || me.lastAltitude == null){
            return null;
        }
        return info.altitude-me.lastAltitude;
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

        var dist = elapsedDistance();


        var timeInHour = 0.0;
        timeInHour = lapElapsedTime();
        var res = 0;

        if (dist == null || timeInHour == null){
            return null;
        }

        timeInHour = timeInHour.toFloat()  / 3600000;

        if (timeInHour > 0){
            res= (dist/timeInHour);
        }

        return res;
    }

    function fmtDistance(dst){
        var dist;
        if (metric) {
                dist = dst / 1000.0;
            } else {
                dist = dst / 1609.0;
        }
        return dist;
    }

}