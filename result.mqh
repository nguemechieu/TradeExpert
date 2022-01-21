//+------------------------------------------------------------------+
//|                                                       result.mqh |
//|                          Copyright 2021,Noel Martial Nguemechieu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,Noel Martial Nguemechieu"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <DiscordTelegram/channel_post.mqh>
class Cresult
  {

public: Cmessage message;
long update_id;




Cchannel_post channel_post;
                     Cresult();
                    ~Cresult();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Cresult::Cresult()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Cresult::~Cresult()
  {
  }
//+------------------------------------------------------------------+
