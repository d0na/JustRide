//
// Copyright 2016 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

using Toybox.WatchUi as Ui;

class JustRideConfirmationDialogDelegate extends Ui.ConfirmationDelegate {
    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(value) {
        if (value == 0) {
            resultString = cancelString;
        }
        else {
            resultString = confirmString;
        }
    }
}


class BaseInputDelegate extends Ui.BehaviorDelegate {
    var dialog;

    function initialize() {
        BehaviorDelegate.initialize();
    }

    // Handle menu input
    function onMenu() {
        return pushDialog();
    }

    // Handle select button
    function onSelect() {
        return pushDialog();
    }

    function pushDialog() {
        dialog = new Ui.Confirmation(dialogHeaderString);
        Ui.pushView(dialog, new JustRideConfirmationDialogDelegate(), Ui.SLIDE_IMMEDIATE);
        return true;
    }

    function onNextPage() {
    }
}
