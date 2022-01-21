//+------------------------------------------------------------------+
//|                                                         Chat.mqh |
//|                          Copyright 2021,Noel Martial Nguemechieu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,Noel Martial Nguemechieu"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
   #include <DiscordTelegram/customMessage.mqh>
class Cchat 
  {
public:

string last_name;
string type;
  long              m_id;
   CCustomMessage    m_last;
   CCustomMessage    m_new_one;
   int               m_state;
   datetime          m_time;
string first_name;
                     Cchat();
                    ~Cchat();
                    
                    
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Cchat::Cchat(){   m_id=0;m_time=NULL;
m_state=0;
    
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Cchat::~Cchat()
  {
  }
//+------------------------------------------------------------------+
