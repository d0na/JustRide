/*
https://github.com/nickmacias/Garmin-LSGrade/blob/master/LSGradeView.mc
 */
class ClimbInfo{

    var SAMPLES_10_SEC = 10; //10 samples equals a 10 seconds interval time
    var SAMPLES_5_SEC = 5; //10 samples equals a 10 seconds interval time
    var SAMPLES_30_SEC = 30; //10 samples equals a 10 seconds interval time

    hidden var saveAlt10sec=new[SAMPLES_10_SEC]; // record 10 prior altitude readings here
    hidden var saveAlt5sec=new[SAMPLES_5_SEC]; // record 10 prior altitude readings here
    hidden var saveAlt30sec=new[SAMPLES_30_SEC]; // record 30 prior altitude readings here

    hidden var saveDist10sec=new[SAMPLES_10_SEC]; // and 10 distance readings
    hidden var saveDist5sec=new[SAMPLES_5_SEC]; // and 10 distance readings
    hidden var saveDist30sec=new[SAMPLES_30_SEC]; // and 10 distance readings

    hidden var saveCR=new[SAMPLES_10_SEC]; // record 10 prior climbing rates
    
    hidden var nextLoc10s=0; // where we'll write the *next* pieces of data
    hidden var prevLoc10s=0; // where we'll write the *next* pieces of data
    hidden var nextLoc5s=0; // where we'll write the *next* pieces of data

    hidden var nextLoc30s=0; // where we'll write the *next* pieces of data
    hidden var prevLoc30s=0; // where we'll write the *next* pieces of data
    hidden var prevLoc5s=0; // where we'll write the *next* pieces of data

    hidden var prevRet=0.0; // previous return value (in case we can't re-compute this time)
    hidden var prevDist=0.0; // previous distance. "interesting" data means distance has changed

    hidden var ready10sec=false; // set when we've got full arrays
    hidden var ready5sec=false; // set when we've got full arrays
    hidden var ready30sec=false; // set when we've got full arrays

    //public fields
    var lsGrade10Sec =0.0;
    var lsGrade5Sec =0.0;
    var percGrade =0.0;
    var vam10sec =0.0;
    var vam5sec =0.0;
    var vam30sec =0.0;

    function initialize() {
        ready10sec=false;
        ready30sec=false;
        nextLoc10s=0;
        nextLoc5s=0;
        nextLoc30s=0;
        // initialize saveCR array
        var i;
        for (i=0;i<SAMPLES_10_SEC;i++){
            saveCR[i]=10000.0; // 10000 means uninitialized
        }
    }


    function isDataAvailable(altitude,elapsedDistance){
        if ((altitude==null)||(elapsedDistance==null)){ // data not available (weird)
              return false;
        } else {
              return true;
        }
    }

    function isNotMoving(elapsedDistance){
            if (elapsedDistance==prevDist){ // data not available (weird)
                  return true;
            } else {
                  return false;
            }
    }

    function pushValues(altitude,elapsedDistance){

        if (altitude != null && elapsedDistance != null){
            // we've moved!
            saveAlt10sec[nextLoc10s]=altitude;
            saveDist10sec[nextLoc10s]=elapsedDistance;


            saveAlt5sec[nextLoc5s]=altitude;
            saveDist5sec[nextLoc5s]=elapsedDistance;

            saveAlt30sec[nextLoc30s]=altitude;
            saveDist30sec[nextLoc30s]=elapsedDistance;

            //Formula
            //vam10sec =  ascent * 3600  / time, time is 1 sec
            // populating Climb Rate array per sec
            saveCR[nextLoc10s] = (altitude-saveAlt10sec[prevLoc10s]) * 3600;

            prevLoc10s = nextLoc10s;
            prevLoc5s = nextLoc5s;
            prevLoc30s = nextLoc30s;
//            System.println("prevLoc" + prevLoc10s);
            incLoc10s();
            incLoc5s();
            incLoc30s();
//            System.println("nextLoc " + nextLoc10s);
        }
    }

    function calcLSFit(time){
        // okay, calculate the least squares fit
        // first calculate xMean and yMean

        var xSum=0.0,ySum=0.0,xMean,yMean;
        var i;

        for (i=0;i<time;i++){
          xSum+=saveDist10sec[i];
          ySum+=saveAlt10sec[i];
        }

        xMean=xSum/time;
        yMean=ySum/time;

        // slope=sum[(xi-xMean)(yi-yMean)] / sum[(xi-xMean)^2]
        var top=0.0,bot=0.0;

        if (time == SAMPLES_10_SEC){
            for (i=0;i<SAMPLES_10_SEC;i++){
              top+=(saveDist10sec[i]-xMean)*(saveAlt10sec[i]-yMean);
              bot+=(saveDist10sec[i]-xMean)*(saveDist10sec[i]-xMean);
            }
        } else  if (time == SAMPLES_5_SEC){
            for (i=0;i<SAMPLES_5_SEC;i++){
              top+=(saveDist5sec[i]-xMean)*(saveAlt5sec[i]-yMean);
              bot+=(saveDist5sec[i]-xMean)*(saveDist5sec[i]-xMean);
            }
        }

        if (bot==0){
          return(prevRet);
        }

        var rate = 100.0*top/bot;

//        System.println("RATE:"+rate);

        //if values are too big do not show
        if (rate >= -30.0 && rate <= 30.0){
            return rate;
        } else {
            return 0.0;
        }
    }



//    function calcSlopePercentage(){
//        if (
//            (saveAlt10sec[prevLoc10s] != null) &&
//            (saveAlt10sec[nextLoc10s] != null) &&
//            (saveDist10sec[prevLoc10s] != null) &&
//            (saveDist10sec[nextLoc10s] != null)
//           )
//        {
//            return (saveAlt10sec[prevLoc10s]-saveAlt10sec[nextLoc10s])/(saveDist10sec[prevLoc10s]-saveDist10sec[nextLoc10s])*100;
//        }
//    }

    //Calculate climb rate whitin 10 sec
    function climbRate10sec(){

        // now average our saved CRs
        var CRSum=0.0;
        var CRAvg;
        var i;

        for (i=0;i<SAMPLES_10_SEC;i++){
          if (saveCR[i] != 100000.0){
            CRSum+=saveCR[i];
          }
        } // ready to calculate average of each climb rate in the last 10 sec
        CRAvg=CRSum/SAMPLES_10_SEC; // should be legal

        return CRAvg;
    }

    //Calculate climb rate whitin 10 sec
    function climbRate30sec(){
        var ascent = saveAlt30sec[prevLoc30s]-saveAlt30sec[nextLoc30s];
        var vam = (ascent * 3600)/30;
//        System.println("ascent:"+ascent);
        return vam;
    }

    // compute LS gradient
    function compute(altitude,elapsedDistance,elapsedTime) {

        if (!isDataAvailable(altitude,elapsedDistance) || isNotMoving(elapsedDistance)){ // data not available (weird)
          return(prevRet);
        }

        pushValues(altitude,elapsedDistance);

        if (ready10sec){
          lsGrade10Sec = calcLSFit(SAMPLES_10_SEC);
//          percGrade = calcSlopePercentage();

          vam10sec  = climbRate10sec();
        }

        if (ready5sec){
            lsGrade5Sec = calcLSFit(SAMPLES_5_SEC);
        }

        if (ready30sec){
          vam30sec  = climbRate30sec();
        }
     }

    //Mod function
    function mod(x,y){
        return x%y;
    }

    //Increment index 10sec
    function incLoc10s(){
        ++nextLoc10s;
        nextLoc10s = mod(nextLoc10s,SAMPLES_10_SEC);
        if (nextLoc10s==0){
            ready10sec=true; // arrays are fully populated
        }
    }

    //Increment index 30sec
    function incLoc30s(){
        ++nextLoc30s;
        nextLoc30s = mod(nextLoc30s,SAMPLES_30_SEC);
        if (nextLoc30s == 0){
            ready30sec=true; // arrays are fully populated
        }
    }

    //Increment index 5sec
    function incLoc5s(){
        ++nextLoc5s;
        nextLoc5s = mod(nextLoc5s,SAMPLES_5_SEC);
        if (nextLoc5s == 0){
            ready5sec=true; // arrays are fully populated
        }
    }
}