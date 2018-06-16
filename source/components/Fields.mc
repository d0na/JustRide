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
    var climbLsGrade10Sec;
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
        totalAscent = info.totalAscent;
        altitude = info.altitude;
        barometricAltitude = getBarometricAltitude(info.ambientPressure);
        barometricRawAltitude = getBarometricAltitude(info.rawAmbientPressure);

        //Time
        time =  Sys.getClockTime();
        elapsedTime = info.timerTime;

        //Speed
        speed = info.currentSpeed;
        avgSpeed = info.averageSpeed;


        rpm = info.currentCadence;
        heartRate =  info.currentHeartRate;
        maxHeartRate = info.maxHeartRate;

        elapsedDistance  = info.elapsedDistance;

        //Climb info
        climbLsGrade10Sec = climbInfo.lsGrade10Sec;
        climbLsGrade5Sec = climbInfo.lsGrade5Sec;
        climbPercGrade = climbInfo.percGrade;
        climbRate10sec = climbInfo.vam10sec;
        climbRate30sec = climbInfo.vam30sec;
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
}