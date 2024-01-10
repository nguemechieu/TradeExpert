//+------------------------------------------------------------------+
//|                                                  encryptuser.mq5 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"

#include <DiscordTelegram/User.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
      user_lic ul;
      ul.uid = 123;
      ul.expired = D'2025.06.01 12:30:27';
      ul.AddLogin(AccountInfoInteger(ACCOUNT_LOGIN));   
      ul.AddLogin(3072021);
      ul.ea_count = 2;
      
      ea_user e1, e2;
      e1.SetEAname("TradeExpert");
      e2.SetEAname("NY cool bot v.6.0");
      e2.expired = D'2025.05.28 12:30:27';
      
      CLic cl;
      cl.SetUser(ul);
      cl.AddEA(e1);
      cl.AddEA(e2);
      
      string k = "qwertyuiopasdfgh";
      ENUM_CRYPT_METHOD m = CRYPT_AES128;
      
      Print("Create license",CreateLic(m, k, cl, "license_tradeexpert.txt"));

  }
//+------------------------------------------------------------------+
