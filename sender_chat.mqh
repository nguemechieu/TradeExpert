//+------------------------------------------------------------------+
//|                                                  sender_chat.mqh |
//|                          Copyright 2021,Noel Martial Nguemechieu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,Noel Martial Nguemechieu"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

class Csender_chat  
  
  {
public:

long id;
string title;
string type;
string username;





                     Csender_chat();
                    ~Csender_chat();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Csender_chat::Csender_chat()
  {
  
  id=-1001648392740;
  title="TRADE_EXPERT Chat";
  type="supergroup";
  

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Csender_chat::~Csender_chat()
  {
  }
//+------------------------------------------------------------------+
