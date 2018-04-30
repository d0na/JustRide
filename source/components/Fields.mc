using Toybox.System as Sys;


class Fields {
    // last 60 seconds - 'current speed' samples
    hidden var lastSecs = new [60];
    hidden var curPos;

    // public fields - usable after the user calls compute
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
    var grade;
    var speed;
    var time;

    function initialize() {
        for (var i = 0; i < lastSecs.size(); ++i) {
            lastSecs[i] = 0.0;
        }

        curPos = 0;
    }

    function compute(info) {
        if (info.currentSpeed != null && info.currentSpeed > 0) {
            var idx = curPos % lastSecs.size();
            curPos++;
            lastSecs[idx] = info.currentSpeed;
        }

//        var avg10s = getNAvg(lastSecs, curPos, 10);
//        //distance, time, avgSpeed, avg10s

        var elapsed = info.elapsedTime;
        var elapsedSecs = null;

        if (elapsed != null) {
            elapsed /= 1000;

            if (elapsed >= 3600) {
                elapsedSecs = (elapsed.toLong() % 60).format("%02d");
            }
        }

//        dist = toDist(info.elapsedDistance);
//        hr = toStr(info.currentHeartRate);
//        hrN = info.currentHeartRate;
//
//        timerSecs = elapsedSecs;
//        cadence = toStr(info.currentCadence);
//        cadenceN = info.currentCadence;
//        pace10s =  fmtSecs(toPace(avg10s));
//        paceAvg = fmtSecs(toPace(info.averageSpeed));
//        half = fmtSecs(expectedHalf);
           time = fmtTime(Sys.getClockTime());
//        halfSecs = halfSecs;

          elapsedTime = fmtSecs(info.elapsedTime);
          speed = getSpeed(info.currentSpeed);
          avgSpeed = getSpeed(info.averageSpeed);
          totalAscent = toAlt(info.totalAscent);
          rpm = info.currentCadence;
          heartRate = info.currentHeartRate;
          maxHeartRate = info.maxHeartRate;
          elapsedDistance  = toDst(info.elapsedDistance);
    }


    function toDst(dst){
        if (dst == null) {
            return null;
        }

        return (dst /1000).format("%.1f");
    }

    function toAlt(alt){
        if (alt == null) {
            return null;
        }

        return (alt).format("%.1f");
    }

    function getSpeed(speed){
        if (speed == null || speed == 0) {
                return null;
        }

//        var settings = Sys.getDeviceSettings();
//        var unit = 1609; // miles
//        if (settings.paceUnits == Sys.UNIT_METRIC) {
//            unit = 1000; // km
//        }
        return (speed  * 3.6).format("%.1f");
    }

    function toStr(o) {
            if (o != null) {
                return "" + o;
            } else {
                return "---";
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

    function fmtSecs(secs) {
        if (secs == null) {
            return "--:--";
        }

        var s = secs.toLong();
        var hours = s / 3600;
        s -= hours * 3600;
        var minutes = s / 60;
        s -= minutes * 60;
        var fmt;
         fmt = "" + hours + ":" + minutes.format("%02d")+":" + s.format("%02d");

        return fmt;
    }
}