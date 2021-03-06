//+------------------------------------------------------------------+
//|                                      Auto Fibo Retracement-V2.mq4|
//|   This tool draws a fibonacci retracement with 0 to 100%         |
//|   automatically on a chart, in the direction of the trend.       |
//|   It can also show the unretraced zone                           |
//|   More free tools @ tradertools-fx.com                           |
//|                                                       Paul Nordin|
//|                                    http://www.tradertools-fx.com |
//+------------------------------------------------------------------+
#property copyright "© 2010 TRADERTOOLS-FX.COM"
#property link      "http://www.tradertools-fx.com"

#property indicator_chart_window
#property indicator_buffers    0

enum mode_of_alert
 {
    E_MAIL,MOBILE,E_MAIL_AND_MOBILE
 };
extern mode_of_alert ALERT_MODE=E_MAIL;
//User Parameters
extern color fiboColor =clrBlue;
extern double fiboWidth = 1;
extern ENUM_LINE_STYLE fiboStyle = STYLE_DOT;
extern color unretracedZoneColor = Green;
extern bool showUnretracedZone = true;

double FIBO_LEVEL_0=0.0;

input double FIBO_LEVEL_1=0.236;
input bool ALERT_ACTIVE_FIBO_LEVEL_1=true;

input double FIBO_LEVEL_2=0.382;
input bool ALERT_ACTIVE_FIBO_LEVEL_2=true;

input double FIBO_LEVEL_3=0.50;
input bool ALERT_ACTIVE_FIBO_LEVEL_3=true;         

input double FIBO_LEVEL_4=0.618;
input bool ALERT_ACTIVE_FIBO_LEVEL_4=true; 

input double FIBO_LEVEL_5=0.786;
input bool ALERT_ACTIVE_FIBO_LEVEL_5=true;

input double FIBO_LEVEL_6=1.0;
input bool ALERT_ACTIVE_FIBO_LEVEL_6=true;

input double FIBO_LEVEL_7=1.214;
input bool ALERT_ACTIVE_FIBO_LEVEL_7=true;

input double FIBO_LEVEL_8=1.618;
input bool ALERT_ACTIVE_FIBO_LEVEL_8=true;

input double FIBO_LEVEL_9=2.618;
input bool ALERT_ACTIVE_FIBO_LEVEL_9=true;

input double FIBO_LEVEL_10=4.236;
input bool ALERT_ACTIVE_FIBO_LEVEL_10=true;

bool alarm_fibo_level_1=false;
bool alarm_fibo_level_2=false;
bool alarm_fibo_level_3=false;
bool alarm_fibo_level_4=false;
bool alarm_fibo_level_5=false;
bool alarm_fibo_level_6=false;
bool alarm_fibo_level_7=false;
bool alarm_fibo_level_8=false;
bool alarm_fibo_level_9=false;
bool alarm_fibo_level_10=false;

int fibo_levels=11;
double current_high;
double current_low;
double price_delta;

string headerString = "AutoFibo_";

bool previous_trend;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
void OnInit() {
   IndicatorBuffers(0);    
}

int deinit() {
   deleteObjects();
   Comment( "" ); 
   return(0);
}

int start() {
   Comment( "TRADERTOOLS-FX.COM" );
   deleteObjects();
   createFibo();
   return(0);
}

void deleteObjects() {
   for ( int i = ObjectsTotal() - 1;  i >= 0;  i-- ) {
      string name = ObjectName( i );
      if ( StringSubstr( name, 0, StringLen( headerString ) ) == headerString )
         ObjectDelete( name );
   }
}

void createFibo() {
   int bar = WindowFirstVisibleBar();
   
   int shiftLowest  = iLowest( NULL, 0, MODE_LOW, bar - 1, 1 );
   int shiftHighest = iHighest( NULL, 0, MODE_HIGH, bar - 1, 1 );
   
   current_low=iLow(Symbol(),PERIOD_CURRENT,shiftLowest);
   current_high=iHigh(Symbol(),PERIOD_CURRENT,shiftHighest);
   price_delta=current_high-current_low;
   
   bool   isDownTrend = shiftHighest > shiftLowest;
   string fiboObjectId1 = headerString + "1";
   string fiboObjectHigh = headerString + "High";
   string fiboObjectLow = headerString + "Low";
   string unretracedZoneObject = headerString + "UnretracedZone";
   int shiftMostRetraced;
 
   if ( isDownTrend == true )
    {   
           
      ObjectCreate( fiboObjectId1, OBJ_FIBO,0, Time[shiftHighest], High[shiftHighest], Time[shiftLowest], Low[shiftLowest] );    
      ObjectSet( fiboObjectId1, OBJPROP_LEVELWIDTH, fiboWidth );
      ObjectSet( fiboObjectId1, OBJPROP_LEVELSTYLE, fiboStyle );
      
      if ( showUnretracedZone == true ) 
       {
         if ( shiftLowest > 0 )
          {
            shiftMostRetraced = iHighest( NULL, 0, MODE_HIGH, shiftLowest - 1, 0 );
            ObjectCreate( unretracedZoneObject, OBJ_RECTANGLE, 0, Time[shiftMostRetraced], High[shiftHighest], Time[0], High[shiftMostRetraced] );      
            ObjectSet( unretracedZoneObject, OBJPROP_COLOR, unretracedZoneColor );     
          } 
       }        
    }
   
   else {
            
     ObjectCreate( fiboObjectId1, OBJ_FIBO, 0, Time[shiftLowest], Low[shiftLowest], Time[shiftHighest], High[shiftHighest] );   
     ObjectSet( fiboObjectId1, OBJPROP_LEVELWIDTH, fiboWidth );
     ObjectSet( fiboObjectId1, OBJPROP_LEVELSTYLE, fiboStyle );
        if( showUnretracedZone == true ) {
           if ( shiftHighest > 0 ) {
               shiftMostRetraced = iLowest( NULL, 0, MODE_LOW, shiftHighest - 1, 0 );
               ObjectCreate( unretracedZoneObject, OBJ_RECTANGLE, 0, Time[shiftMostRetraced], Low[shiftLowest], Time[0], Low[shiftMostRetraced] );      
               ObjectSet( unretracedZoneObject, OBJPROP_COLOR, unretracedZoneColor );
           }
        }
        
                               
    }
//__________________________________________________________________________________________________________________________________________________ 
//    
   ObjectSet( fiboObjectId1, OBJPROP_LEVELCOLOR, fiboColor );
   ObjectSet( fiboObjectId1, OBJPROP_LEVELSTYLE, fiboStyle );
   ObjectSet( fiboObjectId1, OBJPROP_LEVELWIDTH, fiboWidth );
   ObjectSet( fiboObjectId1, OBJPROP_FIBOLEVELS, 11 );
 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 0, FIBO_LEVEL_0);
   ObjectSetFiboDescription( fiboObjectId1, 0, DoubleToString(FIBO_LEVEL_0*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 1, FIBO_LEVEL_1);
   ObjectSetFiboDescription( fiboObjectId1, 1, DoubleToString(FIBO_LEVEL_1*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 2, FIBO_LEVEL_2);
   ObjectSetFiboDescription( fiboObjectId1, 2, DoubleToString(FIBO_LEVEL_2*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 3, FIBO_LEVEL_3);
   ObjectSetFiboDescription( fiboObjectId1, 3, DoubleToString(FIBO_LEVEL_3*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 4, FIBO_LEVEL_4);
   ObjectSetFiboDescription( fiboObjectId1, 4, DoubleToString(FIBO_LEVEL_4*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 5, FIBO_LEVEL_5);
   ObjectSetFiboDescription( fiboObjectId1, 5, DoubleToString(FIBO_LEVEL_5*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 6, FIBO_LEVEL_6);
   ObjectSetFiboDescription( fiboObjectId1, 6, DoubleToString(FIBO_LEVEL_6*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 7, FIBO_LEVEL_7);
   ObjectSetFiboDescription( fiboObjectId1, 7, DoubleToString(FIBO_LEVEL_7*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 8, FIBO_LEVEL_8);
   ObjectSetFiboDescription( fiboObjectId1, 8, DoubleToString(FIBO_LEVEL_8*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 9, FIBO_LEVEL_9);
   ObjectSetFiboDescription( fiboObjectId1, 9, DoubleToString(FIBO_LEVEL_9*100,1)+"  - %$" ); 
   ObjectSet( fiboObjectId1, OBJPROP_FIRSTLEVEL + 10,FIBO_LEVEL_10);
   ObjectSetFiboDescription( fiboObjectId1, 10, DoubleToString(FIBO_LEVEL_10*100,1)+"  - %$" ); 
     
   if(previous_trend!=isDownTrend)
     RESET_ALARMS();
   
   previous_trend=isDownTrend; 
//__________________________________________________________________________________________________________________________________________________ 
// 
// FIBO MESSAGES ON LEVEL CROSSING UP
//__________________________________________________________________________________________________________________________________________________ 
//       
      if(Bid<=current_high-FIBO_LEVEL_1*price_delta&&alarm_fibo_level_1==false&&ALERT_ACTIVE_FIBO_LEVEL_1==true&&isDownTrend==false)
       {
          alarm_fibo_level_1=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid<=current_high-FIBO_LEVEL_2*price_delta&&alarm_fibo_level_2==false&&ALERT_ACTIVE_FIBO_LEVEL_2==true&&isDownTrend==false)
       {
          alarm_fibo_level_2=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)    
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid<=current_high-FIBO_LEVEL_3*price_delta&&alarm_fibo_level_3==false&&ALERT_ACTIVE_FIBO_LEVEL_3==true&&isDownTrend==false)
       {
          alarm_fibo_level_3=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid<=current_high-FIBO_LEVEL_4*price_delta&&alarm_fibo_level_4==false&&ALERT_ACTIVE_FIBO_LEVEL_4==true&&isDownTrend==false)
       {
          alarm_fibo_level_4=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//       
      if(Bid<=current_high-FIBO_LEVEL_5*price_delta&&alarm_fibo_level_5==false&&ALERT_ACTIVE_FIBO_LEVEL_5==true&&isDownTrend==false)
       {
          alarm_fibo_level_5=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid<=current_high-FIBO_LEVEL_6*price_delta&&alarm_fibo_level_6==false&&ALERT_ACTIVE_FIBO_LEVEL_6==true&&isDownTrend==false)
       {
          alarm_fibo_level_6=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid<=current_high-FIBO_LEVEL_7*price_delta&&alarm_fibo_level_7==false&&ALERT_ACTIVE_FIBO_LEVEL_7==true&&isDownTrend==false)
       {
          alarm_fibo_level_7=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid<=current_high-FIBO_LEVEL_8*price_delta&&alarm_fibo_level_8==false&&ALERT_ACTIVE_FIBO_LEVEL_8==true&&isDownTrend==false)
       {
          alarm_fibo_level_8=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid<=current_high-FIBO_LEVEL_9*price_delta&&alarm_fibo_level_9==false&&ALERT_ACTIVE_FIBO_LEVEL_9==true&&isDownTrend==false)
       {
          alarm_fibo_level_9=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid<=current_high-FIBO_LEVEL_10*price_delta&&alarm_fibo_level_10==false&&ALERT_ACTIVE_FIBO_LEVEL_10==true&&isDownTrend==false)
       {
          alarm_fibo_level_10=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
// 
// FIBO MESSAGES ON LEVEL CROSSING DOWN
//__________________________________________________________________________________________________________________________________________________ 
//       
      if(Bid>=current_low+FIBO_LEVEL_1*price_delta&&alarm_fibo_level_1==false&&ALERT_ACTIVE_FIBO_LEVEL_1==true&&isDownTrend==true)
       {
          alarm_fibo_level_1=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)                                                                         
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid>=current_low+FIBO_LEVEL_2*price_delta&&alarm_fibo_level_2==false&&ALERT_ACTIVE_FIBO_LEVEL_2==true&&isDownTrend==true)
       {
          alarm_fibo_level_2=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid>=current_low+FIBO_LEVEL_3*price_delta&&alarm_fibo_level_3==false&&ALERT_ACTIVE_FIBO_LEVEL_3==true&&isDownTrend==true)
       {
          alarm_fibo_level_3=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid>=current_low+FIBO_LEVEL_4*price_delta&&alarm_fibo_level_4==false&&ALERT_ACTIVE_FIBO_LEVEL_4==true&&isDownTrend==true)
       {
          alarm_fibo_level_4=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//       
      if(Bid>=current_low+FIBO_LEVEL_5*price_delta&&alarm_fibo_level_5==false&&ALERT_ACTIVE_FIBO_LEVEL_5==true&&isDownTrend==true)
       {
          alarm_fibo_level_5=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid>=current_low+FIBO_LEVEL_6*price_delta&&alarm_fibo_level_6==false&&ALERT_ACTIVE_FIBO_LEVEL_6==true&&isDownTrend==true)
       {
          alarm_fibo_level_6=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid>=current_low+FIBO_LEVEL_7*price_delta&&alarm_fibo_level_7==false&&ALERT_ACTIVE_FIBO_LEVEL_7==true&&isDownTrend==true)
       {
          alarm_fibo_level_7=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid>=current_low+FIBO_LEVEL_8*price_delta&&alarm_fibo_level_8==false&&ALERT_ACTIVE_FIBO_LEVEL_8==true&&isDownTrend==true)
       {
          alarm_fibo_level_8=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid>=current_low+FIBO_LEVEL_9*price_delta&&alarm_fibo_level_9==false&&ALERT_ACTIVE_FIBO_LEVEL_9==true&&isDownTrend==true)
       {
          alarm_fibo_level_9=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }
//__________________________________________________________________________________________________________________________________________________ 
//
      if(Bid>=current_low+FIBO_LEVEL_10*price_delta&&alarm_fibo_level_10==false&&ALERT_ACTIVE_FIBO_LEVEL_10==true&&isDownTrend==true)
       {
          alarm_fibo_level_10=true;
          
          if(ALERT_MODE==E_MAIL_AND_MOBILE)
           {
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
              
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
           }
           
          if(ALERT_MODE==E_MAIL)
              SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
          if(ALERT_MODE==MOBILE)   
              SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
       }       
//__________________________________________________________________________________________________________________________________________________ 
//
}

void RESET_ALARMS()
 {
   alarm_fibo_level_1=false;
   alarm_fibo_level_2=false;
   alarm_fibo_level_3=false;
   alarm_fibo_level_4=false;
   alarm_fibo_level_5=false;
   alarm_fibo_level_6=false;
   alarm_fibo_level_7=false;
   alarm_fibo_level_8=false;
   alarm_fibo_level_9=false;
   alarm_fibo_level_10=false;
 }