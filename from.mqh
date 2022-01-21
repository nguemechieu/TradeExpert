//+------------------------------------------------------------------+
//|                                                         from.mqh |
//|                          Copyright 2021,Noel Martial Nguemechieu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,Noel Martial Nguemechieu"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
class Cfrom
  {
public:
long id;
bool is_bot;

string first_name;

string last_name;

string username;
string language_code;


       
       
                     Cfrom();
                    ~Cfrom();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Cfrom::Cfrom()
  {
  id=0;
 is_bot=false;

 first_name="ali";

 last_name="bernard";

username="tapi";
language_code="en";

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Cfrom::~Cfrom()
  {
  }
//+------------------------------------------------------------------+
