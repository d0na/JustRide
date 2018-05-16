/*
https://github.com/nickmacias/Garmin-LSGrade/blob/master/LSGradeView.mc
 */
class ClimbInfo{

    const SAMPLES_SIZE = 10; //10 samples equals a 10 seconds interval time
    hidden var saveAlt=new[SAMPLES_SIZE]; // record 10 prior altitude readings here
    hidden var saveDist=new[SAMPLES_SIZE]; // and 10 distance readings
    hidden var saveTime=new[SAMPLES_SIZE]; // and 10 time readings
    hidden var saveCR=new[10]; // record 10 prior climbing rates
    hidden var nextLoc=0; // where we'll write the *next* pieces of data
    hidden var prevLoc=0; // where we'll write the *next* pieces of data

    hidden var prevRet=0.0; // previous return value (in case we can't re-compute this time)
    hidden var prevDist=0.0; // previous distance. "interesting" data means distance has changed

    hidden var ready=false; // set when we've got full arrays

    var grade =0.0;
    var vam =0.0;


    function initialize() {
        ready=false;
        nextLoc=0;
        // initialize saveCR array
        var i;
        for (i=0;i<10;i++){
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

    function pushValues(altitude,elapsedDistance,elapsedTime){
        // we've moved!
        saveAlt[nextLoc]=altitude;
        saveDist[nextLoc]=elapsedDistance;
        saveTime[nextLoc]=elapsedTime;
        prevLoc = nextLoc;

        var time = saveTime[prevLoc]-saveTime[nextLoc];
        var alt = saveAlt[prevLoc]-saveAlt[nextLoc];


        ++nextLoc;
        if (nextLoc==SAMPLES_SIZE){
          nextLoc=0; // circular queue
          ready=true; // arrays are fully populated
        }
    }

    function calcLSFit(){
        // okay, calculate the least squares fit
        // first calculate xMean and yMean

        var xSum=0.0,ySum=0.0,xMean,yMean;
        var i;

        for (i=0;i<SAMPLES_SIZE;i++){
          xSum+=saveDist[i];
          ySum+=saveAlt[i];
        }

        xMean=xSum/SAMPLES_SIZE;
        yMean=ySum/SAMPLES_SIZE;

        // slope=sum[(xi-xMean)(yi-yMean)] / sum[(xi-xMean)^2]
        var top=0.0,bot=0.0;

        for (i=0;i<SAMPLES_SIZE;i++){
          top+=(saveDist[i]-xMean)*(saveAlt[i]-yMean);
          bot+=(saveDist[i]-xMean)*(saveDist[i]-xMean);
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


    function climbRate(){


//        System.println("indx:"+prevLoc);
//        System.println("mod:"+nextLoc);
        var time = saveTime[prevLoc]-saveTime[nextLoc];
        var alt = saveAlt[prevLoc]-saveAlt[nextLoc];
        var dist = saveDist[prevLoc]-saveDist[nextLoc];


        System.println("ALT:"+alt);
        System.println("pre:"+saveAlt[prevLoc]);
        System.println("curr:"+saveAlt[nextLoc]);
//        System.println("Time(ms):"+time);
//        System.println("Time(h):"+time/1000);
//        System.println("Dist:"+dist);

//        var result = alt/(time/1000) * 3600;
        saveCR[prevLoc]= alt/(time/1000) * 3600;

        // now average our saved CRs
        var CRSum=0.0;
        var CRNum=0;
        var CRAvg;
        var i;

        for (i=0;i<10;i++){
          if (saveCR[i] != 100000.0){
            ++CRNum;
            CRSum+=saveCR[i];
          }
        } // ready to calculate average
        CRAvg=CRSum/CRNum; // should be legal
//        prevRet=CRAvg;

        return CRAvg;

    }

    // compute LS gradient
    function compute(altitude,elapsedDistance,elapsedTime) {

        if (!isDataAvailable(altitude,elapsedDistance) || isNotMoving(elapsedDistance)){ // data not available (weird)
          return(prevRet);
        }

        pushValues(altitude,elapsedDistance,elapsedTime);

        if (!ready){
          return(prevRet); // LS data not ready...wait for more data
        }

        grade = calcLSFit();
        vam  = climbRate();
        System.println("Vam:"+vam);
     }
}