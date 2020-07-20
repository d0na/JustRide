using Toybox.Activity as Act;
using Toybox.WatchUi as Ui;

class PowerInfo extends Ui.SimpleDataField{
     hidden var _M_samples;
     hidden var _M_index;
     hidden var _M_count;

    function initialize(seconds) {
        SimpleDataField.initialize();
        _M_samples = new [seconds];
        _M_index = 0;
        _M_count = 0;
    }

    function compute(info) {
        if (info.currentPower == null) {
            return null;
        }

        _M_samples[_M_index] = info.currentPower;
        _M_index = (_M_index + 1) % _M_samples.size();

        if (_M_samples.size() != _M_count) {
            _M_count += 1;
        }

        var sum = 0.0;
        for (var i = 0; i < _M_count; ++i) {
            sum += _M_samples;
        }

        return (sum / _M_count).toNumber();
    }
}