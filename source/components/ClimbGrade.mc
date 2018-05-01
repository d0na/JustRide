class ClimbGrade
{
    hidden var samples;
    hidden var sample_idx;

    hidden var sum_neg;
    hidden var sum_pos;

    function initialize(count) {
        samples = new [ count ];
        sample_idx = 0;
        for (var i = 0; i < samples.size(); ++i) {
            samples[i] = 0.0;
        }

        sum_pos = 0.0;
        sum_neg = 0.0;
    }

    function add_sample(sample) {

        // store the sample
        samples[sample_idx] = sample;

        // calculate the positive/negative sums
        sum_pos = 0.0;
        sum_neg = 0.0;
        for (var i = 0; i < samples.size(); ++i) {
            if (samples[i] < 0) {
                sum_neg += samples[i];
            }
            else {
                sum_pos += samples[i];
            }
        }

        // advance to the next storage location
        sample_idx = (sample_idx + 1) % samples.size();
    }

    function ascent() {
        return sum_pos;
    }

    function descent() {
        return sum_neg;
    }
}