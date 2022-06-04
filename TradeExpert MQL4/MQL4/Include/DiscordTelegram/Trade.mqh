//+------------------------------------------------------------------+
//|                                                        Trade.mqh |
//|                         Copyright 2022, nguemechieu noel martial |
//|                       https://github.com/nguemechieu/TradeExpert |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, nguemechieu noel martial"
#property link      "https://github.com/nguemechieu/TradeExpert"
#property version   "1.00"
#property strict
#include <DiscordTelegram/Order.mqh>
class CTrade : public COrder
  {
private:

public:
                     CTrade();
                    ~CTrade();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrade::CTrade()
  {
  }
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CTrade::~CTrade()
  {
  }
//+------------------------------------------------------------------+
