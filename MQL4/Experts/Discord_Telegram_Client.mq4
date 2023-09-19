//+------------------------------------------------------------------+
//|                            Strategy: Discord_Telegram_Client2.mq4 |
//|                                       Created with EABuilder.com |
//|                                        https://www.eabuilder.com |
//+------------------------------------------------------------------+
#property copyright "Created with EABuilder.com"
#property link      "https://www.eabuilder.com"
#property version   "1.00"
#property description "This Bot will can trade generate ,manage and generate trading signals on telegram ,twitter and discord channel"
#property tester_indicator "THE_ATM_INDICATOR_FX_master"

#include <stdlib.mqh>
#include <stderror.mqh>

int LotDigits; //initialized in OnInit
int MagicNumber = 640310;
int NextOpenTradeAfterBars = 0; //next open trade after time
int NextOpenTradeAfterTOD_Hour = 00; //next open trade after time of the day
int NextOpenTradeAfterTOD_Min = 30; //next open trade after time of the day
datetime NextTradeTime = 0;
int TOD_From_Hour = 09; //time of the day (from hour)
int TOD_From_Min = 45; //time of the day (from min)
int TOD_To_Hour = 16; //time of the day (to hour)
int TOD_To_Min = 15; //time of the day (to min)
int PendingOrderExpirationBars = 12; //pending order expiration
double TradeSize = 0.1;
int MaxSlippage = 0; //adjusted in OnInit
bool TradeMonday = true;
bool TradeTuesday = true;
bool TradeWednesday = true;
bool TradeThursday = true;
bool TradeFriday = true;
bool TradeSaturday = true;
bool TradeSunday = true;
double MaxSL = 300;
double MinSL = 200;
double MaxTP = 300;
double MinTP = 200;
bool Send_Email = true;
bool Audible_Alerts = true;
bool Push_Notifications = true;
int MaxOpenTrades = 34;
int MaxLongTrades = 1000;
int MaxShortTrades = 1000;
int MaxPendingOrders = 1000;
int MaxLongPendingOrders = 1000;
int MaxShortPendingOrders = 1000;
bool Hedging = true;
int OrderRetry = 5; //# of retries if sending order returns error
int OrderWait = 5; //# of seconds to wait if sending order returns error
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

bool TradeDayOfWeek()
  {
   int day = DayOfWeek();
   return((TradeMonday && day == 1)
   || (TradeTuesday && day == 2)
   || (TradeWednesday && day == 3)
   || (TradeThursday && day == 4)
   || (TradeFriday && day == 5)
   || (TradeSaturday && day == 6)
   || (TradeSunday && day == 0));
  }

void myAlert(string type, string message)
  {
   if(type == "print")
      Print(message);
   else if(type == "error")
     {
      Print(type+" | Discord_Telegram_Client @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
     }
   else if(type == "order")
     {
      Print(type+" | Discord_Telegram_Client @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
      if(Audible_Alerts) Alert(type+" | Discord_Telegram_Client @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
      if(Send_Email) SendMail("Discord_Telegram_Client", type+" | Discord_Telegram_Client @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
      if(Push_Notifications) SendNotification(type+" | Discord_Telegram_Client @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
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
   
   DeleteByDuration(PendingOrderExpirationBars * PeriodSeconds());
   
   //Open Buy Order
   if(iCustom(NULL, PERIOD_CURRENT, "THE_ATM_INDICATOR_FX_master", 3, 34, 0, true, true, 4, 0) > iCustom(NULL, PERIOD_CURRENT, "THE_ATM_INDICATOR_FX_master", 3, 34, 0, true, true, 3, 0) //THE_ATM_INDICATOR_FX_master > THE_ATM_INDICATOR_FX_master
   )
     {
      RefreshRates();
      price = Ask;
      SL = 200 * myPoint; //Stop Loss = value in points (relative to price)
      if(SL > MaxSL) SL = MaxSL;
      if(SL < MinSL) SL = MinSL;
      TP = 200 * myPoint; //Take Profit = value in points (relative to price)
      if(TP > MaxTP) TP = MaxTP;
      if(TP < MinTP) TP = MinTP;
      if(TradesCount(OP_BUY) + TradesCount(OP_SELL) > 0 || TimeCurrent() - LastCloseTime() < NextOpenTradeAfterBars * PeriodSeconds()) return; //next open trade after time after previous trade's close
      if(TimeCurrent() <= NextTradeTime) return; //next open trade after time of the day
      if(!inTimeInterval(TimeCurrent(), TOD_From_Hour, TOD_From_Min, TOD_To_Hour, TOD_To_Min)) return; //open trades only at specific times of the day
      if(!TradeDayOfWeek()) return; //open trades only on specific days of the week   
      if(IsTradeAllowed())
        {
         ticket = myOrderSend(OP_BUY, price, TradeSize, "");
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
   if(iCustom(NULL, PERIOD_CURRENT, "THE_ATM_INDICATOR_FX_master", 3, 34, 0, true, true, 4, 0) < iCustom(NULL, PERIOD_CURRENT, "THE_ATM_INDICATOR_FX_master", 3, 34, 0, true, true, 3, 0) //THE_ATM_INDICATOR_FX_master < THE_ATM_INDICATOR_FX_master
   )
     {
      RefreshRates();
      price = Bid;
      SL = 200 * myPoint; //Stop Loss = value in points (relative to price)
      if(SL > MaxSL) SL = MaxSL;
      if(SL < MinSL) SL = MinSL;
      TP = 200 * myPoint; //Take Profit = value in points (relative to price)
      if(TP > MaxTP) TP = MaxTP;
      if(TP < MinTP) TP = MinTP;
      if(TradesCount(OP_BUY) + TradesCount(OP_SELL) > 0 || TimeCurrent() - LastCloseTime() < NextOpenTradeAfterBars * PeriodSeconds()) return; //next open trade after time after previous trade's close
      if(TimeCurrent() <= NextTradeTime) return; //next open trade after time of the day
      if(!inTimeInterval(TimeCurrent(), TOD_From_Hour, TOD_From_Min, TOD_To_Hour, TOD_To_Min)) return; //open trades only at specific times of the day
      if(!TradeDayOfWeek()) return; //open trades only on specific days of the week   
      if(IsTradeAllowed())
        {
         ticket = myOrderSend(OP_SELL, price, TradeSize, "");
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