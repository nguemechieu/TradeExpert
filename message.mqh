//+------------------------------------------------------------------+
//|                                                      message.mqh |
//|                          Copyright 2021,Noel Martial Nguemechieu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,Noel Martial Nguemechieu"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <DiscordTelegram/from.mqh>
#include <DiscordTelegram/sender_chat.mqh>
#include <DiscordTelegram/entities.mqh>
#include <DiscordTelegram/Chat.mqh>
#include <DiscordTelegram/from_chat forward_from_chat.mqh>

class Cmessage :public CCustomMessage
  {

public:
Cfrom from;
Centities entities;
bool ok;
Csender_chat sender_chat;
Cchat chat;
string author_signature;
datetime date;


Cforward_from_chat forward_from_chat;
long forward_from_message_id;
string forward_signature;
bool is_automatic_forward;
datetime forward_date;
string text;






  };
  
