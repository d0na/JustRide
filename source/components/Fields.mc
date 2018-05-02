using Toybox.System as Sys;


//https://github.com/dmuino/HMFields

class Fields {

    hidden var lastElapsedDistance = 0 ;
    hidden var newLap = false;
    hidden var curDistance = 0;
    hidden var curElevation = 0;
    hidden var lsGradeHelper;
    hidden var climbRateHelper;
    hidden var climbAvgRateHelper;


//    hidden var rate20s;
//    hidden var rate30s;
//    hidden var rate40s;
//
//    hidden var m_prev;

    // public fields - usable after the user calls compute
    var elapsedLapDistance = 0;
    var elapsedDistance;
    var elapsedTime;

    var lapDistance;
    var rpm;
    var maxRpm;
    var avgSpeed;
    var vam;
    var totalAscent;
    var heartRate;
    var maxHeartRate;
    var climbGrade;
    var climbRate;
    var climbAvgGrade;
    var speed;
    var time;
    var altitude;
    var lap = 0;



    function initialize() {
//        rate20s = new ClimbRate(20);
//        rate30s = new ClimbRate(30);
//        rate40s = new ClimbRate(40);

        lsGradeHelper = new LSGrade();
        climbRateHelper = new ClimbRateField();
        climbAvgRateHelper = new ClimbAvgGrade();
    }

    function compute(info) {

        var elapsed = info.elapsedTime;
        var elapsedSecs = null;

        if (elapsed != null) {
            elapsed /= 1000;
            if (elapsed >= 3600) {
                elapsedSecs = (elapsed.toLong() % 60).format("%02d");
            }
        }

        System.println("Altitude: "+info.altitude);
        System.println("Distance: "+info.elapsedDistance);
        System.println("Speed: "+info.currentSpeed);

        time = fmtTime(Sys.getClockTime());

        elapsedTime = fmtSecs(info.timerTime);
        speed = getSpeed(info.currentSpeed);
        avgSpeed = getSpeed(info.averageSpeed);
        totalAscent = printAltitude(info.totalAscent);
        rpm = info.currentCadence;
        heartRate = info.currentHeartRate;
//        heartRate = 170;
        maxHeartRate = toStr(info.maxHeartRate);
        elapsedDistance  = printDst(info.elapsedDistance);
        elapsedLapDistance = printDst(calcLapDistance(info.elapsedDistance));

        altitude = print0D(info.altitude);
//        climbGrade = grade(info);
        climbGrade = lsGradeHelper.gradient(info);
//        vam = VamRate(info).format("%0d");


//        vam = rate(info).format("%0d");

        vam = print0D(climbRateHelper.rate(info));
        climbRate = vam;
        climbAvgGrade = climbAvgRateHelper.avgGrade(info);
    }


    function setNewLap(bol){
        if (bol){
            lap +=1;
            newLap = true;
        }
    }

    function calcLapDistance (dst){
        if (dst == null || lastElapsedDistance== null){
            return null;
        }
        return dst - lastElapsedDistance;
    }




    function printDst(dst){
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

    function printAltitude(alt){
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

    function getSpeed(speed){
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


    function toStr(o) {
            if (o != null) {
                return "" + o;
            } else {
                return "--";
            }
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

        function VamRate(info){
                if (info.altitude == null) {
                    return "--";
                }

                if (m_prev == null) {
                    m_prev = info.altitude;
                }

                // calculate the delta since the previous call
                var delta = info.altitude - m_prev;
                m_prev = info.altitude;

                // this is the expensive part, adding the sample and creating
                // the sums of all of the values
                rate20s.add_sample(delta);
                rate30s.add_sample(delta);
                rate40s.add_sample(delta);

                var ascent20s = rate20s.ascent() * 180;
                var ascent30s = rate30s.ascent() * 120;
                var ascent40s = rate40s.ascent() * 90;

                // average of the delta values
                return (ascent20s + ascent30s + ascent40s) / 3.0;
        }

}