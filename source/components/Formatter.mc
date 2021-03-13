class Formatter {

    function timeOptHour(time) {
//         if (time == null) {
//             return "--:--";
//         }

//         time = time /1000;
//         var hour = (time / 3600).toLong();
//         var minute = (time / 60).toLong() - (hour * 60);
//         var second = time - (minute * 60) - (hour * 3600);

// //        if (hour > 0) {
//             return Lang.format("$1$:$2$:$3$", [hour.format("%d"), minute.format("%02d"), second.format("%02d")]);
// //        } else {
// //            return Lang.format("$1$:$2$", [minute.format("%02d"), second.format("%02d")]);
// //        }




          var lapTime = "--:--";

        if (time != 0) {
            var hour = (time / (1000 * 60 * 60)) % 24;
            var minute = (time / (1000 * 60)) % 60;
            var second = (time / 1000) % 60;
// if (lapTime >= 3600) {
// lapTime = Lang.format("$1$:$2$:$3$", [hour.format("%d"), minute.format("%02d"), second.format("%02d")]);
// } else {
// lapTime = Lang.format("$1$:$2$", [minute.format("%d"), second.format("%02d")]);
            lapTime = Lang.format("$1$:$2$:$3$", [hour.format("%d"), minute.format("%02d"), second.format("%02d")]);
// }
// return lapTime;
        }
        return lapTime;  
    }

    function distance(dst) {
        var dist = 0.0;

        if (dst == null){
            return "--.-";
        }

        if (System.getDeviceSettings().paceUnits==Toybox.System.UNIT_METRIC) {
                dist = dst / 1000.0;
            } else {
                dist = dst / 1609.0;
        }

        return dist.format("%.1f");
    }

    function elevation (val){
        if (val == null){
            return "---";
        }

        return val.format("%0d");
    }


    function speed (speed){
        if (speed == null || speed == 0) {
            return "0.0";
        }

        var unit = 2.2; // miles



        if (System.getDeviceSettings().paceUnits==Toybox.System.UNIT_METRIC) {
//            System.println("yes");
            unit = 3.6; // km
        }
        return (unit * speed).format("%.1f");
    }

    function vam(val){
        if (val == null || val <300){
            return "0";
        }

        if (val > 300 ){
            return val.format("%0d");
        } else {
            return 0;
        }
    }

     function number2d(val){
        if (val == null ){
            return "0";
        }

        return val.format("%.1f");
     }

     function number(val){
        if (val == null ){
            return "0";
        }

        return val;
     }

     function clock(clock) {
        var h = clock.hour;
        if (! System.getDeviceSettings().is24Hour) {
            if (h > 12) {
                h -= 12;
            } else if (h == 0) {
                h += 12;
            }
        }
        return "" + h + ":" + clock.min.format("%02d");
    }

    function simple(o) {
        if (o != null) {
            return "" + o;
        } else {
            return "--";
        }
    }

     function time(time) {
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

    function grade (grade){
        if (grade == null){
            return 0;
        }

        return grade.format("%0d");
    }
}