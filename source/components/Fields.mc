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
    var frontDerailleurSize;
    var rearDerailleurSize;
    var currentPower;
    var power3Sec;

    var time;
    var pressure;
    var seaPressure;
    var barometricRawAltitude;
    var rawAmbientPressure;

    hidden var pwr3s=new[3]; // record 10 prior climbing rates
    hidden var ready3sec=false; // set when we've got full arrays
    hidden var nextLoc3s=0; // where we'll write the *next* pieces of data



    /* CONSTRUCTOR */
    function initialize() {
        climbInfo = new ClimbInfo();
        ready3sec=false;
        nextLoc3s=0;
        var i;
        for (i=0;i<3;i++){
            pwr3s[i]=0; // 10000 means uninitialized
        }
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

        //Gear
        frontDerailleurSize = info.frontDerailleurSize;
        rearDerailleurSize = info.rearDerailleurSize;
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

	function get3sPower(){
	    var pwrSum = 0;
	    var i;
	    for (i=0;i<3;i++){
              pwrSum+=pwr3s[i];
        }
        return pwrSum/3;
	}



	 function incLoc3s(){
            ++nextLoc3s;
            nextLoc3s = mod(nextLoc3s,3);
            if (nextLoc3s == 0){
                ready3sec=true; // arrays are fully populated
            }
        }

     function mod(x,y){
           return x%y;
     }

     function pushPwr(pwr){
//     	    Sys.println("pwr:"+pwr);
     	    if (pwr != null){
     	        pwr3s[nextLoc3s] = currentPower;
     	    }
     	    incLoc3s();
     	}
}