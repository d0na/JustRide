using Toybox.Activity as Act;

class LapInfo {

    hidden var lapCounter = 0;
    hidden var split = false;
    hidden var timerState = STOPPED;
    hidden var lapCertainty = "";

    hidden var lastElapsedDistance = 0;
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

    }

    function lapAvgSpeed(){

    }

    function lapElevation(){

    }

    function lapVam(){

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