using Toybox.System as Sys;


//https://github.com/dmuino/HMFields

class Fields {

    hidden var lastElapsedDistance = 0 ;
    hidden var curDistance = 0;
    hidden var curElevation = 0;
    hidden var climbInfo;

    // public fields - usable after the user calls compute
    var heartRate;
    var maxHeartRate;
    var elapsedDistance;
    var elapsedTime;
    var totalAscent;
    var altitude;
    var speed;
    var avgSpeed;
    var climbRate10sec;
    var climbRate30sec;
    var climbLsGrade;
    var climbLsGrade5Sec;
    var climbPercGrade;
    var rpm;
    var barometricAltitude;

    var time;
    var pressure;
    var seaPressure;
    var barometricRawAltitude;
    var rawAmbientPressure;


    /* CONSTRUCTOR */
    function initialize() {
        climbInfo = new ClimbInfo();
    }

    /* COMPUTE */
    function compute(info) {

        climbInfo.compute(info.altitude,info.elapsedDistance,info.elapsedTime);


        var elapsed = info.elapsedTime;
        var elapsedSecs = null;

        if (elapsed != null) {
            elapsed /= 1000;
            if (elapsed >= 3600) {
                elapsedSecs = (elapsed.toLong() % 60).format("%02d");
            }
        }

        //Elevation and pressure
        seaPressure = info.meanSeaLevelPressure;
        rawAmbientPressure = info.rawAmbientPressure;
        pressure = info.ambientPressure;
        totalAscent = fmtAltitude(info.totalAscent);
        altitude = fmtAltitude(info.altitude);
        barometricAltitude = getBarometricAltitude(info.ambientPressure);
        barometricRawAltitude = getBarometricAltitude(info.rawAmbientPressure);

        //Time
        time = fmtTime(Sys.getClockTime());
        elapsedTime = fmtSecs(info.timerTime);

        //Speed
        speed = fmtSpeed(info.currentSpeed);
        avgSpeed = fmtSpeed(info.averageSpeed);


        rpm = info.currentCadence;
        heartRate =  info.currentHeartRate;
        maxHeartRate = toStr(info.maxHeartRate);

        elapsedDistance  = fmtDistance(info.elapsedDistance);

        //Climb info
        climbLsGrade = climbInfo.lsGrade;
        climbLsGrade5Sec = climbInfo.lsGrade5Sec;
        climbPercGrade = climbInfo.percGrade;
        climbRate10sec = fmtVam(climbInfo.vam10sec);
        climbRate30sec = fmtVam(climbInfo.vam30sec);
    }

    /*******************

        Fields Computational functions

    *********************/

    const sea_press = 1013.25;
	function getBarometricAltitude(pressure){
        // Formula - Simpified Barometric Altitude
	    //  h = 44330 * (1-(pow((pressure/sea_pressure),(1/5.255)))
	    var pow = 0.0d;
	    if( pressure != null && pressure > 0){
            var hPaPressure = (pressure/100);
            pow = Math.pow(hPaPressure/sea_press,(1/5.255));
            return 44330 * (1-pow);
        } else {
            return 0.0;
        }
	}


    /*******************

        Printer helper

    *********************/

    function toStr(o) {
        if (o != null) {
            return "" + o;
        } else {
            return "--";
        }
    }

    function fmtSecs(time) {
        if (time == null) {
            return "--:--";
        }

        time = time /1000;
        var hour = (time / 3600).toLong();
        var minute = (time / 60).toLong() - (hour * 60);
        var second = time - (minute * 60) - (hour * 3600);

        var fmt = Lang.format("$1$:$2$:$3$", [hour.format("%d"), minute.format("%02d"), second.format("%02d")]);

        return fmt;
    }
    
    function fmtTime(clock) {
        var h = clock.hour;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (h > 12) {
                h -= 12;
            } else if (h == 0) {
                h += 12;
            }
        }
        return "" + h + ":" + clock.min.format("%02d");
    }
    
    function fmtSpeed(speed){
        if (speed == null || speed == 0) {
                return "0.0";
        }

        var settings = Sys.getDeviceSettings();
        var unit = 2.2; // miles
        if (settings.paceUnits == Sys.UNIT_METRIC) {
            unit = 3.6; // km
        }
        return (unit * speed).format("%.1f");
    }
    
    function fmtDistance(dst){
        var dist;
        if (dst == null) {
            return "__._";
        }

        if (Sys.getDeviceSettings().distanceUnits == Sys.UNIT_METRIC) {
            dist = dst / 1000.0;
        } else {
            dist = dst / 1609.0;
        }
        return dist.format("%.1f");
    }

    function fmtAltitude(alt){
        if (alt == null) {
            return "___";
        }
        return (alt).format("%01d");
    }

    function print0D(val){
        if (val == null || val == 0.0) {
            return "0";
        }
        return (val).format("%01d");
    }

    function fmtVam(val){
        if (val > 300 ){
            return val;
        } else {
            return 0;
        }
    }
}