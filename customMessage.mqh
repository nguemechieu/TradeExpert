//+------------------------------------------------------------------+
//|                                                customMessage.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict
  
#include <object.mqh>
class CCustomMessage : public CObject
{
public:
   bool              done;
   long              update_id;
   long message_id;
   //---
   long              from_id;
   string            from_first_name;
   string            from_last_name;
   string            from_username;
   //---
   long              chat_id;
   string            chat_first_name;
   string            chat_last_name;
   string            chat_username;
   string            chat_type;
   //---
   datetime          message_date;
   string            message_text;

                     CCustomMessage()
   {
      done=false;
      update_id=0;
     
      from_id=0;
      from_first_name=NULL;
      from_last_name=NULL;
      from_username=NULL;
      chat_id=0;
      chat_first_name=NULL;
      chat_last_name=NULL;
      chat_username=NULL;
      chat_type=NULL;
      message_date=0;
      message_text=NULL;
      from_id=0;
      from_first_name=NULL;
      from_last_name=NULL;
      from_username=NULL;
      chat_id=0;
      chat_first_name=NULL;
      chat_last_name=NULL;
      chat_username=NULL;
      chat_type=NULL;
      message_date=0;
      message_text=NULL;
   }

};
