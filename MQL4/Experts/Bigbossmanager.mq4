//+------------------------------------------------------------------+
//|                                               Strategy: BOSS.mq4 |
//|                                       Created with EABuilder.com |
//|                                        https://www.eabuilder.com |
//+------------------------------------------------------------------+
#property copyright "Created with EABuilder.com"
#property link      "https://www.eabuilder.com"
#property version   "1.00"
#property description ""

#include <stdlib.mqh>
#include <stderror.mqh>

extern int SR_Interval = 12;
int LotDigits; //initialized in OnInit
extern int MagicNumber = 821358;
int NextOpenTradeAfterBars = 12; //next open trade after time
int NextOpenTradeAfterTOD_Hour = 00; //next open trade after time of the day
int NextOpenTradeAfterTOD_Min = 50; //next open trade after time of the day
datetime NextTradeTime = 0;
extern int MaxTradeDurationHours = 1; //maximum trade duration
extern int PendingOrderExpirationBars = 6; //pending order expiration
extern double DeleteOrderAtDistance = 12; //delete order when too far from current price
extern int MinTradeDurationBars = 12; //minimum trade duration
extern double MM_PositionSizing = 10000;
extern double MaxSpread = 3;
extern int MaxSlippage = 3; //slippage, adjusted in OnInit
extern double MaxSL = 150;
extern double MinSL = 100;
extern double MaxTP = 200;
extern double MinTP = 25;
extern double CloseAtPL = 75;
extern double PriceTooClose = 5;
bool crossed[2]; //initialized to true, used in function Cross
extern bool Audible_Alerts = true;
extern int MaxOpenTrades = 3;
extern int MaxLongTrades = 3;
extern int MaxShortTrades = 3;
extern int MaxPendingOrders = 1;
extern int MaxLongPendingOrders = 3;
extern int MaxShortPendingOrders = 3;
extern bool Hedging = true;
int OrderRetry = 2; //# of retries if sending order returns error
int OrderWait = 60; //# of seconds to wait if sending order returns error
double myPoint; //initialized in OnInit

void CloseByDuration(int sec) //close trades opened longer than sec seconds
  {
   if(!IsTradeAllowed()) return;
   bool success = false;
   int err = 0;
   int total = OrdersTotal();
   int orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy()) Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderType() > 1 || OrderOpenTime() + sec > TimeCurrent()) continue;
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = (int)OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(!OrderSelect(orderList[i][1], SELECT_BY_TICKET, MODE_TRADES)) continue;
      while(IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      double price = Bid;
      if(OrderType() == OP_SELL)
         price = Ask;
      success = OrderClose(OrderTicket(), NormalizeDouble(OrderLots(), LotDigits), NormalizeDouble(price, Digits()), MaxSlippage, clrWhite);
      if(!success)
        {
         err = GetLastError();
         myAlert("error", "OrderClose failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
        }
     }
   if(success) myAlert("order", "Orders closed by duration: "+Symbol()+" Magic #"+IntegerToString(MagicNumber));
  }

void DeleteByDuration(int sec) //delete pending order after time since placing the order
  {
   if(!IsTradeAllowed()) return;
   bool success = false;
   int err = 0;
   int total = OrdersTotal();
   int orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy()) Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderType() <= 1 || OrderOpenTime() + sec > TimeCurrent()) continue;
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = (int)OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(!OrderSelect(orderList[i][1], SELECT_BY_TICKET, MODE_TRADES)) continue;
      while(IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      success = OrderDelete(OrderTicket());
      if(!success)
        {
         err = GetLastError();
         myAlert("error", "OrderDelete failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
        }
     }
   if(success) myAlert("order", "Orders deleted by duration: "+Symbol()+" Magic #"+IntegerToString(MagicNumber));
  }

void DeleteByDistance(double distance) //delete pending order if price went too far from it
  {
   if(!IsTradeAllowed()) return;
   bool success = false;
   int err = 0;
   int total = OrdersTotal();
   int orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy()) Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderType() <= 1) continue;
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = (int)OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(!OrderSelect(orderList[i][1], SELECT_BY_TICKET, MODE_TRADES)) continue;
      while(IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      double price = (OrderType() % 2 == 1) ? Ask : Bid;
      if(MathAbs(OrderOpenPrice() - price) <= distance) continue;
      success = OrderDelete(OrderTicket());
      if(!success)
        {
         err = GetLastError();
         myAlert("error", "OrderDelete failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
        }
     }
   if(success) myAlert("order", "Orders deleted by distance: "+Symbol()+" Magic #"+IntegerToString(MagicNumber));
  }

double MM_Size() //position sizing
  {
   double MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   double MinLot = MarketInfo(Symbol(), MODE_MINLOT);
   double lots = AccountBalance() / MM_PositionSizing;
   if(lots > MaxLot) lots = MaxLot;
   if(lots < MinLot) lots = MinLot;
   return(lots);
  }

void CloseTradesAtPL(double PL) //close all trades if total P/L >= profit (positive) or total P/L <= loss (negative)
  {
   double totalPL = TotalOpenProfit(0);
   if((PL > 0 && totalPL >= PL) || (PL < 0 && totalPL <= PL))
     {
      myOrderClose(OP_BUY, 100, "");
      myOrderClose(OP_SELL, 100, "");
     }
  }

bool Cross(int i, bool condition) //returns true if "condition" is true and was false in the previous call
  {
   bool ret = condition && !crossed[i];
   crossed[i] = condition;
   return(ret);
  }

void myAlert(string type, string message)
  {
   if(type == "print")
      Print(message);
   else if(type == "error")
     {
     }
   else if(type == "order")
     {
      Print(type+" | BOSS @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
      if(Audible_Alerts) Alert(type+" | BOSS @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
     }
   else if(type == "modify")
     {
     }
  }

int TradesCount(int type) //returns # of open trades for order type, current symbol and magic number
  {
   int result = 0;
   int total = OrdersTotal();
   for(int i = 0; i < total; i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false) continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderType() != type) continue;
      result++;
     }
   return(result);
  }

bool SelectLastHistoryTrade()
  {
   int lastOrder = -1;
   int total = OrdersHistoryTotal();
   for(int i = total-1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) continue;
      if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
        {
         lastOrder = i;
         break;
        }
     } 
   return(lastOrder >= 0);
  }

double TotalOpenProfit(int direction)
  {
   double result = 0;
   int total = OrdersTotal();
   for(int i = 0; i < total; i++)   
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if((direction < 0 && OrderType() == OP_BUY) || (direction > 0 && OrderType() == OP_SELL)) continue;
      result += OrderProfit();
     }
   return(result);
  }

double ProfitToday()
  {
   double ret = 0;
   for(int i = OrdersHistoryTotal()-1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY)) continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderType() > 1) continue;
      if(TimeDayOfYear(OrderCloseTime()) != DayOfYear() || TimeYear(OrderCloseTime()) != Year()) continue;
      ret += OrderProfit();
     }
   return(ret);
  }

datetime LastCloseTime()
  {
   if(SelectLastHistoryTrade())
     {
      return(OrderCloseTime());
     }
   return(0);
  }

int myOrderSend(int type, double price, double volume, string ordername) //send order, return ticket ("price" is irrelevant for market orders)
  {
   if(!IsTradeAllowed()) return(-1);
   int ticket = -1;
   int retries = 0;
   int err = 0;
   int long_trades = TradesCount(OP_BUY);
   int short_trades = TradesCount(OP_SELL);
   int long_pending = TradesCount(OP_BUYLIMIT) + TradesCount(OP_BUYSTOP);
   int short_pending = TradesCount(OP_SELLLIMIT) + TradesCount(OP_SELLSTOP);
   string ordername_ = ordername;
   if(ordername != "")
      ordername_ = "("+ordername+")";
   //test Hedging
   if(!Hedging && ((type % 2 == 0 && short_trades + short_pending > 0) || (type % 2 == 1 && long_trades + long_pending > 0)))
     {
      myAlert("print", "Order"+ordername_+" not sent, hedging not allowed");
      return(-1);
     }
   //test maximum trades
   if((type % 2 == 0 && long_trades >= MaxLongTrades)
   || (type % 2 == 1 && short_trades >= MaxShortTrades)
   || (long_trades + short_trades >= MaxOpenTrades)
   || (type > 1 && type % 2 == 0 && long_pending >= MaxLongPendingOrders)
   || (type > 1 && type % 2 == 1 && short_pending >= MaxShortPendingOrders)
   || (type > 1 && long_pending + short_pending >= MaxPendingOrders)
   )
     {
      myAlert("print", "Order"+ordername_+" not sent, maximum reached");
      return(-1);
     }
   //prepare to send order
   while(IsTradeContextBusy()) Sleep(100);
   RefreshRates();
   if(type == OP_BUY)
      price = Ask;
   else if(type == OP_SELL)
      price = Bid;
   else if(price < 0) //invalid price for pending order
     {
      myAlert("order", "Order"+ordername_+" not sent, invalid price for pending order");
	  return(-1);
     }
   int clr = (type % 2 == 1) ? clrRed : clrBlue;
   if(MaxSpread > 0 && Ask - Bid > MaxSpread * myPoint)
     {
      myAlert("order", "Order"+ordername_+" not sent, maximum spread "+DoubleToStr(MaxSpread * myPoint, Digits())+" exceeded");
      return(-1);
     }
   //adjust price for pending order if it is too close to the market price
   double MinDistance = PriceTooClose * myPoint;
   if(type == OP_BUYLIMIT && Ask - price < MinDistance)
      price = Ask - MinDistance;
   else if(type == OP_BUYSTOP && price - Ask < MinDistance)
      price = Ask + MinDistance;
   else if(type == OP_SELLLIMIT && price - Bid < MinDistance)
      price = Bid + MinDistance;
   else if(type == OP_SELLSTOP && Bid - price < MinDistance)
      price = Bid - MinDistance;
   while(ticket < 0 && retries < OrderRetry+1)
     {
      ticket = OrderSend(Symbol(), type, NormalizeDouble(volume, LotDigits), NormalizeDouble(price, Digits()), MaxSlippage, 0, 0, ordername, MagicNumber, 0, clr);
      if(ticket < 0)
        {
         err = GetLastError();
         myAlert("print", "OrderSend"+ordername_+" error #"+IntegerToString(err)+" "+ErrorDescription(err));
         Sleep(OrderWait*1000);
        }
      retries++;
     }
   if(ticket < 0)
     {
      myAlert("error", "OrderSend"+ordername_+" failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err));
      return(-1);
     }
   string typestr[6] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop"};
   myAlert("order", "Order sent"+ordername_+": "+typestr[type]+" "+Symbol()+" Magic #"+IntegerToString(MagicNumber));
   return(ticket);
  }

int myOrderModify(int ticket, double SL, double TP) //modify SL and TP (absolute price), zero targets do not modify
  {
   if(!IsTradeAllowed()) return(-1);
   bool success = false;
   int retries = 0;
   int err = 0;
   SL = NormalizeDouble(SL, Digits());
   TP = NormalizeDouble(TP, Digits());
   if(SL < 0) SL = 0;
   if(TP < 0) TP = 0;
   //prepare to select order
   while(IsTradeContextBusy()) Sleep(100);
   if(!OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES))
     {
      err = GetLastError();
      myAlert("error", "OrderSelect failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
      return(-1);
     }
   //prepare to modify order
   while(IsTradeContextBusy()) Sleep(100);
   RefreshRates();
   //adjust targets for market order if too close to the market price
   double MinDistance = PriceTooClose * myPoint;
   if(OrderType() == OP_BUY)
     {
      if(NormalizeDouble(SL, Digits()) != 0 && Ask - SL < MinDistance)
         SL = Ask - MinDistance;
      if(NormalizeDouble(TP, Digits()) != 0 && TP - Ask < MinDistance)
         TP = Ask + MinDistance;
     }
   else if(OrderType() == OP_SELL)
     {
      if(NormalizeDouble(SL, Digits()) != 0 && SL - Bid < MinDistance)
         SL = Bid + MinDistance;
      if(NormalizeDouble(TP, Digits()) != 0 && Bid - TP < MinDistance)
         TP = Bid - MinDistance;
     }
   if(CompareDoubles(SL, 0)) SL = OrderStopLoss(); //not to modify
   if(CompareDoubles(TP, 0)) TP = OrderTakeProfit(); //not to modify
   if(CompareDoubles(SL, OrderStopLoss()) && CompareDoubles(TP, OrderTakeProfit())) return(0); //nothing to do
   while(!success && retries < OrderRetry+1)
     {
      success = OrderModify(ticket, NormalizeDouble(OrderOpenPrice(), Digits()), NormalizeDouble(SL, Digits()), NormalizeDouble(TP, Digits()), OrderExpiration(), CLR_NONE);
      if(!success)
        {
         err = GetLastError();
         myAlert("print", "OrderModify error #"+IntegerToString(err)+" "+ErrorDescription(err));
         Sleep(OrderWait*1000);
        }
      retries++;
     }
   if(!success)
     {
      myAlert("error", "OrderModify failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err));
      return(-1);
     }
   string alertstr = "Order modified: ticket="+IntegerToString(ticket);
   if(!CompareDoubles(SL, 0)) alertstr = alertstr+" SL="+DoubleToString(SL);
   if(!CompareDoubles(TP, 0)) alertstr = alertstr+" TP="+DoubleToString(TP);
   myAlert("modify", alertstr);
   return(0);
  }

int myOrderModifyRel(int ticket, double SL, double TP) //modify SL and TP (relative to open price), zero targets do not modify
  {
   if(!IsTradeAllowed()) return(-1);
   bool success = false;
   int retries = 0;
   int err = 0;
   SL = NormalizeDouble(SL, Digits());
   TP = NormalizeDouble(TP, Digits());
   if(SL < 0) SL = 0;
   if(TP < 0) TP = 0;
   //prepare to select order
   while(IsTradeContextBusy()) Sleep(100);
   if(!OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES))
     {
      err = GetLastError();
      myAlert("error", "OrderSelect failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
      return(-1);
     }
   //prepare to modify order
   while(IsTradeContextBusy()) Sleep(100);
   RefreshRates();
   //convert relative to absolute
   if(OrderType() % 2 == 0) //buy
     {
      if(NormalizeDouble(SL, Digits()) != 0)
         SL = OrderOpenPrice() - SL;
      if(NormalizeDouble(TP, Digits()) != 0)
         TP = OrderOpenPrice() + TP;
     }
   else //sell
     {
      if(NormalizeDouble(SL, Digits()) != 0)
         SL = OrderOpenPrice() + SL;
      if(NormalizeDouble(TP, Digits()) != 0)
         TP = OrderOpenPrice() - TP;
     }
   //adjust targets for market order if too close to the market price
   double MinDistance = PriceTooClose * myPoint;
   if(OrderType() == OP_BUY)
     {
      if(NormalizeDouble(SL, Digits()) != 0 && Ask - SL < MinDistance)
         SL = Ask - MinDistance;
      if(NormalizeDouble(TP, Digits()) != 0 && TP - Ask < MinDistance)
         TP = Ask + MinDistance;
     }
   else if(OrderType() == OP_SELL)
     {
      if(NormalizeDouble(SL, Digits()) != 0 && SL - Bid < MinDistance)
         SL = Bid + MinDistance;
      if(NormalizeDouble(TP, Digits()) != 0 && Bid - TP < MinDistance)
         TP = Bid - MinDistance;
     }
   if(CompareDoubles(SL, 0)) SL = OrderStopLoss(); //not to modify
   if(CompareDoubles(TP, 0)) TP = OrderTakeProfit(); //not to modify
   if(CompareDoubles(SL, OrderStopLoss()) && CompareDoubles(TP, OrderTakeProfit())) return(0); //nothing to do
   while(!success && retries < OrderRetry+1)
     {
      success = OrderModify(ticket, NormalizeDouble(OrderOpenPrice(), Digits()), NormalizeDouble(SL, Digits()), NormalizeDouble(TP, Digits()), OrderExpiration(), CLR_NONE);
      if(!success)
        {
         err = GetLastError();
         myAlert("print", "OrderModify error #"+IntegerToString(err)+" "+ErrorDescription(err));
         Sleep(OrderWait*1000);
        }
      retries++;
     }
   if(!success)
     {
      myAlert("error", "OrderModify failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err));
      return(-1);
     }
   string alertstr = "Order modified: ticket="+IntegerToString(ticket);
   if(!CompareDoubles(SL, 0)) alertstr = alertstr+" SL="+DoubleToString(SL);
   if(!CompareDoubles(TP, 0)) alertstr = alertstr+" TP="+DoubleToString(TP);
   myAlert("modify", alertstr);
   return(0);
  }

void myOrderClose(int type, double volumepercent, string ordername) //close open orders for current symbol, magic number and "type" (OP_BUY or OP_SELL)
  {
   if(!IsTradeAllowed()) return;
   if (type > 1)
     {
      myAlert("error", "Invalid type in myOrderClose");
      return;
     }
   bool success = false;
   int retries = 0;
   int err = 0;
   string ordername_ = ordername;
   if(ordername != "")
      ordername_ = "("+ordername+")";
   int total = OrdersTotal();
   int orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy()) Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderType() != type) continue;
      if(OrderOpenTime() + MinTradeDurationBars * PeriodSeconds() > TimeCurrent()) continue; //minimum trade duration, do not close
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = (int)OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(!OrderSelect(orderList[i][1], SELECT_BY_TICKET, MODE_TRADES)) continue;
      while(IsTradeContextBusy()) Sleep(100);
      RefreshRates();
      double price = (type == OP_SELL) ? Ask : Bid;
      double volume = NormalizeDouble(OrderLots()*volumepercent * 1.0 / 100, LotDigits);
      if (NormalizeDouble(volume, LotDigits) == 0) continue;

      success = false; retries = 0;
      while(!success && retries < OrderRetry+1)
        {
         success = OrderClose(OrderTicket(), volume, NormalizeDouble(price, Digits()), MaxSlippage, clrWhite);
         if(!success)
           {
            err = GetLastError();
            myAlert("print", "OrderClose"+ordername_+" failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
            Sleep(OrderWait*1000);
           }
         retries++;
        }
      if(!success)
        {
         myAlert("error", "OrderClose"+ordername_+" failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err));
         return;
       }
     }
   string typestr[6] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop"};
   if(success) myAlert("order", "Orders closed"+ordername_+": "+typestr[type]+" "+Symbol()+" Magic #"+IntegerToString(MagicNumber));
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

void TrailingStopTrail(int type, double TS, double step, bool aboveBE, double aboveBEval) //set Stop Loss to "TS" if price is going your way with "step"
  {
   int total = OrdersTotal();
   TS = NormalizeDouble(TS, Digits());
   step = NormalizeDouble(step, Digits());
   for(int i = total-1; i >= 0; i--)
     {
      while(IsTradeContextBusy()) Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderType() != type) continue;
	  RefreshRates();
      if(type == OP_BUY && (!aboveBE || Bid > OrderOpenPrice() + TS + aboveBEval) && (NormalizeDouble(OrderStopLoss(), Digits()) <= 0 || Bid > OrderStopLoss() + TS + step))
         myOrderModify(OrderTicket(), Bid - TS, 0);
      else if(type == OP_SELL && (!aboveBE || Ask < OrderOpenPrice() - TS - aboveBEval) && (NormalizeDouble(OrderStopLoss(), Digits()) <= 0 || Ask < OrderStopLoss() - TS - step))
         myOrderModify(OrderTicket(), Ask + TS, 0);
     }
  }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {   
   //initialize myPoint
   myPoint = Point();
   if(Digits() == 5 || Digits() == 3)
     {
      myPoint *= 10;
      MaxSlippage *= 10;
     }
   //initialize LotDigits
   double LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   if(NormalizeDouble(LotStep, 3) == round(LotStep))
      LotDigits = 0;
   else if(NormalizeDouble(10*LotStep, 3) == round(10*LotStep))
      LotDigits = 1;
   else if(NormalizeDouble(100*LotStep, 3) == round(100*LotStep))
      LotDigits = 2;
   else LotDigits = 3;
   NextTradeTime = 0;
   MaxSL = MaxSL * myPoint;
   MinSL = MinSL * myPoint;
   MaxTP = MaxTP * myPoint;
   MinTP = MinTP * myPoint;
   int i;
   //initialize crossed
   for (i = 0; i < ArraySize(crossed); i++)
      crossed[i] = true;
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   int ticket = -1;
   double price;   
   double SL;
   double TP;
   int mb_ret; //MessageBox
   
   CloseByDuration(MaxTradeDurationHours * 3600);
   DeleteByDuration(PendingOrderExpirationBars * PeriodSeconds());
   DeleteByDistance(DeleteOrderAtDistance * myPoint);
   CloseTradesAtPL(CloseAtPL);
   TrailingStopTrail(OP_BUY, 75 * myPoint, 5 * myPoint, false, 0); //Trailing Stop = trail
   TrailingStopTrail(OP_SELL, 75 * myPoint, 5 * myPoint, false, 0); //Trailing Stop = trail
   
   //Close Long Positions, instant signal is tested first
   RefreshRates();
   if(Cross(1, Bid < Support(12 * PeriodSeconds(), false, 00, 00, true, 0)) //Price crosses below Support
   )
     {   
      if(IsTradeAllowed())
         myOrderClose(OP_BUY, 100, "");
      else //not autotrading => only send alert
         myAlert("order", "");
     }
   
   //Close Short Positions, instant signal is tested first
   RefreshRates();
   if(Cross(0, Bid > Resistance(12 * PeriodSeconds(), false, 00, 00, true, 0)) //Price crosses above Resistance
   )
     {   
      if(IsTradeAllowed())
         myOrderClose(OP_SELL, 100, "");
      else //not autotrading => only send alert
         myAlert("order", "");
     }
   
   //Open Buy Order
   if(ProfitToday() > AccountEquity() //Profit/Loss Today > Account Equity
   )
     {
      RefreshRates();
      price = Ask;
      SL = 200 * myPoint; //Stop Loss = value in points (relative to price)
      if(SL > MaxSL) SL = MaxSL;
      if(SL < MinSL) SL = MinSL;
      TP = 100 * myPoint; //Take Profit = value in points (relative to price)
      if(TP > MaxTP) TP = MaxTP;
      if(TP < MinTP) TP = MinTP;
      if(TradesCount(OP_BUY) + TradesCount(OP_SELL) > 0 || TimeCurrent() - LastCloseTime() < NextOpenTradeAfterBars * PeriodSeconds()) return; //next open trade after time after previous trade's close
      if(TimeCurrent() <= NextTradeTime) return; //next open trade after time of the day   
      if(IsTradeAllowed())
        {
         mb_ret = MessageBox("Open Buy Order "+DoubleToString(MM_Size())+" lots? [BOSS @ "+Symbol()+","+IntegerToString(Period())+"]", "Manual Order Confirmation", MB_YESNO);
         if(mb_ret == IDYES)
            ticket = myOrderSend(OP_BUY, price, MM_Size(), "");
         if(ticket <= 0) return;
        }
      else //not autotrading => only send alert
         myAlert("order", "");
      NextTradeTime = StringToTime(IntegerToString(NextOpenTradeAfterTOD_Hour)+":"+IntegerToString(NextOpenTradeAfterTOD_Min));
      while(NextTradeTime <= TimeCurrent()) NextTradeTime += 86400;
      myOrderModifyRel(ticket, SL, 0);
      myOrderModifyRel(ticket, 0, TP);
     }
   
   //Open Sell Order
   if(ProfitToday() < AccountEquity() //Profit/Loss Today < Account Equity
   )
     {
      RefreshRates();
      price = Bid;
      SL = 200 * myPoint; //Stop Loss = value in points (relative to price)
      if(SL > MaxSL) SL = MaxSL;
      if(SL < MinSL) SL = MinSL;
      TP = 100 * myPoint; //Take Profit = value in points (relative to price)
      if(TP > MaxTP) TP = MaxTP;
      if(TP < MinTP) TP = MinTP;
      if(TradesCount(OP_BUY) + TradesCount(OP_SELL) > 0 || TimeCurrent() - LastCloseTime() < NextOpenTradeAfterBars * PeriodSeconds()) return; //next open trade after time after previous trade's close
      if(TimeCurrent() <= NextTradeTime) return; //next open trade after time of the day   
      if(IsTradeAllowed())
        {
         mb_ret = MessageBox("Open Sell Order "+DoubleToString(MM_Size())+" lots? [BOSS @ "+Symbol()+","+IntegerToString(Period())+"]", "Manual Order Confirmation", MB_YESNO);
         if(mb_ret == IDYES)
            ticket = myOrderSend(OP_SELL, price, MM_Size(), "");
         if(ticket <= 0) return;
        }
      else //not autotrading => only send alert
         myAlert("order", "");
      NextTradeTime = StringToTime(IntegerToString(NextOpenTradeAfterTOD_Hour)+":"+IntegerToString(NextOpenTradeAfterTOD_Min));
      while(NextTradeTime <= TimeCurrent()) NextTradeTime += 86400;
      myOrderModifyRel(ticket, SL, 0);
      myOrderModifyRel(ticket, 0, TP);
     }
  }
//+------------------------------------------------------------------+