//+------------------------------------------------------------------+
//|                                                  TradeSignal.mqh |
//|                         Copyright 2022, nguemechieu noel martial |
//|                       https://github.com/nguemechieu/TradeExpert |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, nguemechieu noel martial"
#property link      "https://github.com/nguemechieu/TradeExpert"
#property version   "1.00"
#property strict
#include <Object.mqh>
#include <DiscordTelegram/TradeExpert_Variables.mqh>
class CTradeSignal : public CObject
  {
private:
 string indicatorName;ENUMS_TIMEFRAMES timeframe; string commentx;int shift;int shiftx; string symbol;
public:
                     CTradeSignal( string indicatorName,ENUMS_TIMEFRAMES timeframe,  string commentx, int shift,int shiftx, string symbol){
                     
                     this.indicatorName=indicatorName;
                     this.timeframe=timeframe;
                     this.commentx=commentx;
                     this.shiftx=shiftx;
                     this.symbol=symbol;
                     this.shift=shift;
                     
                     };
                     
                   
              
                    CTradeSignal(){};
                    
                    
    
     
     string getIndicatorName() {
        return indicatorName;
    }

    void setIndicatorName(string indicatorName) {
        this.indicatorName = indicatorName;
    }

   ENUMS_TIMEFRAMES getTimeframe() {
        return timeframe;
    }

   void setTimeframe(ENUMS_TIMEFRAMES timeframe) {
        this.timeframe = timeframe;
    }

    string getCommentx() {
        return commentx;
    }

  void setCommentx(string commentx) {
        this.commentx = commentx;
    }

  int getShift() {
        return shift;
    }

    void setShift(int shift) {
        this.shift = shift;
    }

     int getShiftx() {
        return shiftx;
    }

   void setShiftx(int shiftx) {
        this.shiftx = shiftx;
    }

    string getSymbol() {
        return symbol;
    }

   void setSymbol(string symbol) {
        this.symbol = symbol;
    }
                    
                    
       
  int TradeSignal( string indicatorName,ENUMS_TIMEFRAMES timeframe,  string commentx, int shift,int shiftx, string symbol){
 
 
 

  bool alignx=InpAlign;
  ;int signalx=0;
  
   int buyx=(int)iCustom(symbol,timeframe,indicatorName,0,shift);
  
  int sellx=(int)iCustom(symbol,timeframe,indicatorName,1,shiftx);
  
   if(alignx)
     {
      if(buyx== 1 && sellx==-1)
        {
         signalx= 1;commentx="BUY SIGNAL";
        }
        else
      if(buyx == -1 && sellx==1)
        {
       signalx= -1;commentx="SELL SIGNAL";
        }

        

     }
   else
     {
  
     
      if(buyx == 1)
        {
         signalx= 1;commentx="BUY SIGNAL";
        }
      if(sellx == -1)
        {
        signalx= -1;
        
        commentx="SELL SIGNAL";}
        }
   
return signalx;
}
               
                    
                    
                    
                    
                    
  };
  


//+------------------------------------------------------------------+
