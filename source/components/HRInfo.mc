using Toybox.System as Sys;
using Toybox.Graphics as Gfx;
using Toybox.UserProfile as Ui;

class HRInfo {

    hidden var heartRate;

    var zones = [];
    var zone;
    var color;

    function initialize(){
        zones = Ui.getHeartRateZones(UserProfile.HR_ZONE_SPORT_BIKING);
        System.println("The user HR zone " + zones);
    }

    function compute(hr){
        me.heartRate = hr;
        setColorAndZone(hr);
    }

    function setColorAndZone(hr) {
        if (hr == null) {
            return;
        }

//        System.println(hr);

        if (hr >= zones[5]) {
            zone = 6;
            color = Gfx.COLOR_PURPLE;
        } else if (hr >= zones[4]) {
            zone = 5;
            color = Gfx.COLOR_RED;
        } else if (hr >= zones[3]) {
            zone = 4;
            color = Gfx.COLOR_ORANGE;
        } else if (hr >= zones[2]) {
            zone = 3;
            color = Gfx.COLOR_YELLOW;
        } else if (hr >= zones[1]) {
            zone = 2;
            color = Gfx.COLOR_GREEN;
        } else if (hr >= zones[0]) {
            zone = 1;
            color = Gfx.COLOR_BLUE;
        } else {
            zone = 0;
            color = Gfx.COLOR_LT_GRAY;
        }
    }
}