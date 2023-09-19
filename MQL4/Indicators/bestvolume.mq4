//+------------------------------------------------------------------+
//|                                        Indicator: bestvolume.mq4 |
//|                                       Created with EABuilder.com |
//|                                        https://www.eabuilder.com |
//+------------------------------------------------------------------+
#property copyright "Created with EABuilder.com"
#property link      "https://www.eabuilder.com"
#property version   "1.00"
#property description ""

#include <stdlib.mqh>
#include <stderror.mqh>

//--- indicator settings
#property indicator_chart_window
#property indicator_buffers 2

#property indicator_type1 DRAW_ARROW
#property indicator_width1 1
#property indicator_color1 0x33FF00
#property indicator_label1 "Buy"

#property indicator_type2 DRAW_ARROW
#property indicator_width2 1
#property indicator_color2 0x8C00FF
#property indicator_label2 "Sell"

//--- indicator buffers
double Buffer1[];
double Buffer2[];

int TOD_From_Hour = 09; //time of the day (from hour)
int TOD_From_Min = 45; //time of the day (from min)
int TOD_To_Hour = 16; //time of the day (to hour)
int TOD_To_Min = 15; //time of the day (to min)
datetime time_alert; //used when sending alert
bool Send_Email = true;
double myPoint; //initialized in OnInit

bool inTimeInterval(datetime t, int From_Hour, int From_Min, int To_Hour, int To_Min)
  {
   string TOD = TimeToString(t, TIME_MINUTES);
   string TOD_From = StringFormat("%02d", From_Hour)+":"+StringFormat("%02d", From_Min);
   string TOD_To = StringFormat("%02d", To_Hour)+":"+StringFormat("%02d", To_Min);
   return((StringCompare(TOD, TOD_From) >= 0 && StringCompare(TOD, TOD_To) <= 0)
     || (StringCompare(TOD_From, TOD_To) > 0
       && ((StringCompare(TOD, TOD_From) >= 0 && StringCompare(TOD, "23:59") <= 0)
         || (StringCompare(TOD, "00:00") >= 0 && StringCompare(TOD, TOD_To) <= 0))));
  }

void myAlert(string type, string message)
  {
   if(type == "print")
      Print(message);
   else if(type == "error")
     {
      Print(type+" | bestvolume @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
     }
   else if(type == "order")
     {
     }
   else if(type == "modify")
     {
     }
   else if(type == "indicator")
     {
      Print(type+" | bestvolume @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
      if(Send_Email) SendMail("bestvolume", type+" | bestvolume @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
     }
  }

double TrendlinePriceUpper(int shift) //returns current price on the highest horizontal line or trendline found in the chart
  {
   int obj_total = ObjectsTotal();
   double maxprice = -1;
   for(int i = obj_total - 1; i >= 0; i--)
     {
      string name = ObjectName(i);
      double price;
      if(ObjectType(name) == OBJ_HLINE && StringFind(name, "#", 0) < 0
      && (price = ObjectGet(name, OBJPROP_PRICE1)) > maxprice
      && price > 0)
         maxprice = price;
      else if(ObjectType(name) == OBJ_TREND && StringFind(name, "#", 0) < 0
      && (price = ObjectGetValueByShift(name, shift)) > maxprice
      && price > 0)
         maxprice = price;
     }
   return(maxprice); //not found => -1
  }

double TrendlinePriceLower(int shift) //returns current price on the lowest horizontal line or trendline found in the chart
  {
   int obj_total = ObjectsTotal();
   double minprice = MathPow(10, 308);
   for(int i = obj_total - 1; i >= 0; i--)
     {
      string name = ObjectName(i);
      double price;
      if(ObjectType(name) == OBJ_HLINE && StringFind(name, "#", 0) < 0
      && (price = ObjectGet(name, OBJPROP_PRICE1)) < minprice
      && price > 0)
         minprice = price;
      else if(ObjectType(name) == OBJ_TREND && StringFind(name, "#", 0) < 0
      && (price = ObjectGetValueByShift(name, shift)) < minprice
      && price > 0)
         minprice = price;
     }
   if (minprice > MathPow(10, 307))
      minprice = -1; //not found => -1
   return(minprice);
  }

void DrawLine(string objname, double price, int count, int start_index) //creates or modifies existing object if necessary
  {
   if((price < 0) && ObjectFind(objname) >= 0)
     {
      ObjectDelete(objname);
     }
   else if(ObjectFind(objname) >= 0 && ObjectType(objname) == OBJ_TREND)
     {
      ObjectSet(objname, OBJPROP_TIME1, Time[start_index]);
      ObjectSet(objname, OBJPROP_PRICE1, price);
      ObjectSet(objname, OBJPROP_TIME2, Time[start_index+count-1]);
      ObjectSet(objname, OBJPROP_PRICE2, price);
     }
   else
     {
      ObjectCreate(objname, OBJ_TREND, 0, Time[start_index], price, Time[start_index+count-1], price);
      ObjectSet(objname, OBJPROP_RAY, false);
      ObjectSet(objname, OBJPROP_COLOR, C'0x00,0x00,0xFF');
      ObjectSet(objname, OBJPROP_STYLE, STYLE_SOLID);
      ObjectSet(objname, OBJPROP_WIDTH, 2);
     }
  }

double Support(int time_interval, bool fixed_tod, int hh, int mm, bool draw, int shift)
  {
   int start_index = shift;
   int count = time_interval / 60 / Period();
   if(fixed_tod)
     {
      datetime start_time;
      if(shift == 0)
	     start_time = TimeCurrent();
      else
         start_time = Time[shift-1];
      datetime dt = StringToTime(StringConcatenate(TimeToString(start_time, TIME_DATE)," ",hh,":",mm)); //closest time hh:mm
      if (dt > start_time)
         dt -= 86400; //go 24 hours back
      int dt_index = iBarShift(NULL, 0, dt, true);
      datetime dt2 = dt;
      while(dt_index < 0 && dt > Time[Bars-1-count]) //bar not found => look a few days back
        {
         dt -= 86400; //go 24 hours back
         dt_index = iBarShift(NULL, 0, dt, true);
        }
      if (dt_index < 0) //still not found => find nearest bar
         dt_index = iBarShift(NULL, 0, dt2, false);
      start_index = dt_index + 1; //bar after S/R opens at dt
     }
   double ret = Low[iLowest(NULL, 0, MODE_LOW, count, start_index)];
   if (draw) DrawLine("Support", ret, count, start_index);
   return(ret);
  }

double Resistance(int time_interval, bool fixed_tod, int hh, int mm, bool draw, int shift)
  {
   int start_index = shift;
   int count = time_interval / 60 / Period();
   if(fixed_tod)
     {
      datetime start_time;
      if(shift == 0)
	     start_time = TimeCurrent();
      else
         start_time = Time[shift-1];
      datetime dt = StringToTime(StringConcatenate(TimeToString(start_time, TIME_DATE)," ",hh,":",mm)); //closest time hh:mm
      if (dt > start_time)
         dt -= 86400; //go 24 hours back
      int dt_index = iBarShift(NULL, 0, dt, true);
      datetime dt2 = dt;
      while(dt_index < 0 && dt > Time[Bars-1-count]) //bar not found => look a few days back
        {
         dt -= 86400; //go 24 hours back
         dt_index = iBarShift(NULL, 0, dt, true);
        }
      if (dt_index < 0) //still not found => find nearest bar
         dt_index = iBarShift(NULL, 0, dt2, false);
      start_index = dt_index + 1; //bar after S/R opens at dt
     }
   double ret = High[iHighest(NULL, 0, MODE_HIGH, count, start_index)];
   if (draw) DrawLine("Resistance", ret, count, start_index);
   return(ret);
  }

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {   
   IndicatorBuffers(2);
   SetIndexBuffer(0, Buffer1);
   SetIndexEmptyValue(0, EMPTY_VALUE);
   SetIndexArrow(0, 67);
   SetIndexBuffer(1, Buffer2);
   SetIndexEmptyValue(1, EMPTY_VALUE);
   SetIndexArrow(1, 68);
   //initialize myPoint
   myPoint = Point();
   if(Digits() == 5 || Digits() == 3)
     {
      myPoint *= 10;
     }
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime& time[],
                const double& open[],
                const double& high[],
                const double& low[],
                const double& close[],
                const long& tick_volume[],
                const long& volume[],
                const int& spread[])
  {
   int limit = rates_total - prev_calculated;
   //--- counting from 0 to rates_total
   ArraySetAsSeries(Buffer1, true);
   ArraySetAsSeries(Buffer2, true);
   //--- initial zero
   if(prev_calculated < 1)
     {
      ArrayInitialize(Buffer1, EMPTY_VALUE);
      ArrayInitialize(Buffer2, EMPTY_VALUE);
     }
   else
      limit++;
   
   if(TrendlinePriceUpper(0) < 0 && TrendlinePriceLower(0) < 0) return(rates_total);
   //--- main loop
   for(int i = limit-1; i >= 0; i--)
     {
      if (i >= MathMin(500-1, rates_total-1-20)) continue; //omit some old rates to prevent "Array out of range" or slow calculation   
      
      //Indicator Buffer 1
      RefreshRates();
      if(Bid > Support(12 * PeriodSeconds(), false, 00, 00, true, i)
      && Bid < Support(12 * PeriodSeconds(), false, 00, 00, true, i+1) //Price crosses above Support
      && iMACD(NULL, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, i) > iMACD(NULL, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_SIGNAL, i) //MACD > MACD
      && Bid > TrendlinePriceUpper(i) //Price > Upper Trendline
      && iFractals(NULL, PERIOD_CURRENT, MODE_UPPER, i) > iFractals(NULL, PERIOD_CURRENT, MODE_LOWER, i) //Fractals > Fractals
      )
        {
         if(!inTimeInterval(Time[i], TOD_From_Hour, TOD_From_Min, TOD_To_Hour, TOD_To_Min)) continue; //draw indicator only at specific times of the day
         Buffer1[i] = Low[4+i]; //Set indicator value at Candlestick Low
         if(i == 0 && Time[0] != time_alert) { myAlert("indicator", "Buy"); time_alert = Time[0]; } //Instant alert, only once per bar
        }
      else
        {
         Buffer1[i] = EMPTY_VALUE;
        }
      //Indicator Buffer 2
      RefreshRates();
      if(Bid < Resistance(12 * PeriodSeconds(), false, 00, 00, true, i)
      && Bid > Resistance(12 * PeriodSeconds(), false, 00, 00, true, i+1) //Price crosses below Resistance
      && iMACD(NULL, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_MAIN, i) < iMACD(NULL, PERIOD_CURRENT, 12, 26, 9, PRICE_CLOSE, MODE_SIGNAL, i) //MACD < MACD
      && Bid < TrendlinePriceLower(i) //Price < Lower Trendline
      && iFractals(NULL, PERIOD_CURRENT, MODE_UPPER, i) < iFractals(NULL, PERIOD_CURRENT, MODE_LOWER, i) //Fractals < Fractals
      )
        {
         if(!inTimeInterval(Time[i], TOD_From_Hour, TOD_From_Min, TOD_To_Hour, TOD_To_Min)) continue; //draw indicator only at specific times of the day
         Buffer2[i] = High[4+i]; //Set indicator value at Candlestick High
         if(i == 0 && Time[0] != time_alert) { myAlert("indicator", "Sell"); time_alert = Time[0]; } //Instant alert, only once per bar
        }
      else
        {
         Buffer2[i] = EMPTY_VALUE;
        }
     }
   return(rates_total);
  }
//+------------------------------------------------------------------+