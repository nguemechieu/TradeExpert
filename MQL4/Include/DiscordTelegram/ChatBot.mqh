//+------------------------------------------------------------------+
//|                                                      ChatBot.mqh |
//|                         Copyright 2021, Noel Martial Nguemechieu |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Noel Martial Nguemechieu"
#property link      "https://www.mql5.com"
#property strict




#define  TWITTER_BASE_URL "https://www.twitter.com/"
#define  FACEBOOK_BASE_URL "https://www.facebook.coom/"
#define coinbaseApi "api.coinbase.com"
#define apiBinanceUs "https://api.binance.us/api/v3/trades?symbol=LTCBTC"
#define  apibinance "https://api.binance.com/"
#define EMOJI_TOP    "\xF51D"
#define EMOJI_BACK   "\xF519"
#define  NL "\n"
#define  apiDiscord "https://discord.com/api/v8"
#define  CLIENT_ID "332269999912132097"
#define CLIENT_SECRET "937it3ow87i4ery69876wqire"

#include <DiscordTelegram/TRADEEXPERT_INPUTS_PARAMETRES.mqh>
//+------------------------------------------------------------------+
//|   Defines                                                        |
//+------------------------------------------------------------------+




#define KEYB_MAIN    (m_lang==LANGUAGE_EN)?"[[\"/account\"],[\"/quote\"],[\"/chart\"],[\"/ordertrade\"],[\"/ordertotal\"],[\"/ticket\"],[\"/historyTotal\"],[\"/tradereport\"],[\"/analysis\"],[\"/trade\"],[\"/news\"]]":"[[\"Информация\"],[\"Котировки\"],[\"Графики\"]]"
#define KEYS_TRADE    (m_lang==LANGUAGE_EN)?"[[\"/BUY\"],[\"/SELL\"],[\"/BUYLIMIT\"],[\"/SELLIMIT\"],[\"/BUYSTOP\"],[\"/SELLSTOP\"]":"[[\"Информация\"],[\"Котировки\"],[\"Графики\"]]"

#define KEYB_SYMBOLS "[[\""+EMOJI_TOP+"\",\"/GBPUSD\",\"/EURUSD\"],[\"/AUDUSD\",\"/USDJPY\",\"/EURJPY\"],[\"/USDCAD\",\"/USDCHF\",\"/EURCHF\"]]"

#define KEYB_PERIODS "[[\""+EMOJI_TOP+"\",\"M1\",\"M5\",\"M15\"],[\""+EMOJI_BACK+"\",\"M30\",\"H1\",\"H4\"],[\" \",\"D1\",\"W1\",\"MN1\"]]"




       




//
//#define KEYB_MAIN    (m_lang==LANGUAGE_EN)?"[[\"/account\"],[\"/quote\"],[\"/chart\"],[\"/ordertrade\"],[\"/ordertotal\"],[\"/ticket\"],[\"/historyTotal\"],[\"/tradereport\"],[\"/analysis\"],[\"/trade\"],[\"/news\"]]":"[[\"Информация\"],[\"Котировки\"],[\"Графики\"]]"
//#define KEYS_TRADE    (m_lang==LANGUAGE_EN)?"[[\"/BUY\"],[\"/SELL\"],[\"/BUYLIMIT\"],[\"/SELLIMIT\"],[\"/BUYSTOP\"],[\"/SELLSTOP\"]":"[[\"Информация\"],[\"Котировки\"],[\"Графики\"]]"
//
//#define KEYB_SYMBOLS "[[\""+EMOJI_TOP+"\",\"/GBPUSD\",\"/EURUSD\"],[\"/AUDUSD\",\"/USDJPY\",\"/EURJPY\"],[\"/USDCAD\",\"/USDCHF\",\"/EURCHF\"]]"
//
//#define KEYB_PERIODS "[[\""+EMOJI_TOP+"\",\"M1\",\"M5\",\"M15\"],[\""+EMOJI_BACK+"\",\"M30\",\"H1\",\"H4\"],[\" \",\"D1\",\"W1\",\"MN1\"]]"
//
 ;
 extern  string  menu1="========= TradeExpert Bot Configuration  ============";



#define SCREENSHOT_FILENAME "_screenshot.gif"


input bool UseBot=true; // Use Bot  ? (TRUE/FALSE)
extern string     InpTocken   = "2032573404:AAEfu_tvVukCibiYf8uUdi6NcDpSmbuj3Tg";//API TOCKEN
extern string     InpChannel = "tradeexpert_infos";//CHANNEL NAME
extern long  InpChannelChatID=-1001659738763;
extern long InpChatID2=-1001648392740;//Chat ID
extern long InpChatID= 805814430;//private chat ID
input bool InpToChannel=true;
input bool InpTochat=true;

input string UserName="noel";//EA UserName
input string  InpUserNameFilter="noel, Olusegun";//EA UserName Filter

input bool SendScreenshot=true;//Send Screenshot ?(Yes/No)
input string google_url="https://nfs.faireconomy.media/ff_calendar_thisweek.json?version=393359e9932452a2579e1e46e6e3319a";//news url
input const string InpFileName="report.csv";    // File Name
input string InpDirectoryName="MQL4";   // Directory name
input int    InpEncodingType=FILE_ANSI; // ANSI=32 or UNICODE=64




input string Template="TradeExpert";//Default Template (for signal screenshot)
input ENUM_TIMEFRAMES InpTimFrame=PERIOD_CURRENT;
input bool UseMaxspread=true;

#include <DiscordTelegram/Enums.mqh>

#include <DiscordTelegram/Telegram.mqh>


#include<DiscordTelegram/TRADE_DATA.mqh>
//start settings all include file orders matters
#include <Object.mqh>


#include <DiscordTelegram/Comment.mqh>

#include <DiscordTelegram/createObjects.mqh>

//+------------------------------------------------------------------+
//|   Include                                                        |
//+------------------------------------------------------------------+






#include <DiscordTelegram/result.mqh>






     
input EXECUTION_MODE ImmediateExecution =MARKET_ORDER; 

//+------------------------------------------------------------------+
//|   Defines                                                        |
//+------------------------------------------------------------------+
#define SEARCH_URL      "https://search.mql5.com"
//---
#define BUTTON_TOP      "\xF51D"
#define BUTTON_LEFT     "\x25C0"
#define BUTTON_RIGHT    "\x25B6"
//---
#define RADIO_SELECT    "\xF518"
#define RADIO_EMPTY     "\x26AA"
//---
#define CHECK_SELECT    "\xF533"
#define CHECK_EMPTY     "\x25FB"
//---
#define MENU_LANGUAGES  "Languages"
#define MENU_MODULES    "Modules"
//---
#define LANG_EN 0
#define LANG_RU 1
#define LANG_ZH 2
#define LANG_ES 3
#define LANG_DE 4
#define LANG_JA 5
//---
#define MODULE_PROFILES   0x001
#define MODULE_FORUM      0x002
#define MODULE_ARTICLES   0x004
#define MODULE_CODEBASE   0x008
#define MODULE_JOBS       0x010
#define MODULE_DOCS       0x020
#define MODULE_MARKET     0x040
#define MODULE_SIGNALS    0x080
#define MODULE_BLOGS      0x100
//+------------------------------------------------------------------+
//|   CResultMessage                                                 |
//+------------------------------------------------------------------+
class CResultMessage: public CObject
{
public:
   datetime          date;
   string            module;
   string            id;
   string            info_url;
   string            info_title;
   string            text;
};
//+------------------------------------------------------------------+
//|   TLanguage                                                      |
//+------------------------------------------------------------------+
struct TLanguage
{
   string            name;
   string            flag;
   string            prefix;
};
//---
TLanguage languages[6]=
{
   {"English","\xF1EC\xF1E7","en"},
   {"???????","\xF1F7\xF1FA","ru"},
   {"??",    "\xF1E8\xF1F3","zh"},
   {"Español","\xF1EA\xF1F8","es"},
   {"Deutsch","\xF1E9\xF1EA","de"},
   {"???",   "\xF1EF\xF1F5","ja"}
};
const string MODULES_WEB[9]= {"profiles","forum","articles","codebase","jobs","docs","market","signals","blogs"};
const string MODULES_EN[9]= {"Profiles","Forum","Articles","Codebase","Freelance","Documentation","Market","Signals","Blogs"};
const string MODULES_RU[9]= {"???????","?????","??????","Codebase","???????","????????????","??????","???????","?????"};
const string MODULES_ZH[9]= {"????","??","??","???","?????","???","??","??","??"};
const string MODULES_ES[9]= {"Perfil","Foro","Artículos","Codebase","Freelance","Documentación","Market","Señales","Blogs"};
const string MODULES_DE[9]= {"Profile","Forum","Artikel","Codebase","Freelance","Dokumentation","Market","Signale","Blogs"};
const string MODULES_JA[9]= {"??????","?????","??","??????","??????","??????????","?????","????","???"};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

    


//+------------------------------------------------------------------+
//|   CCustomBot                                                     |
//+------------------------------------------------------------------+


ENUM_TIMEFRAMES _periods[] = {PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1};




  



 //+------------------------------------------------------------------+
   //|   CMyBot                                                         |
   //+------------------------------------------------------------------+
   class CBot: public CCustomBot
   {
   private:
      ENUM_LANGUAGES    m_lang;
      string            m_symbol;
      ENUM_TIMEFRAMES   m_period;
      string            m_template;
      CArrayString      m_templates;
   
   public:
      //+------------------------------------------------------------------+
      void              Language(const ENUM_LANGUAGES _lang)
      {
         m_lang=_lang;
      }
   
      //+------------------------------------------------------------------+
         void myAlert(string sym,string type, string message)
     {
      if(type == "print")
         Print(message);
      else if(type == "error")
        {
         Print(type+" | @  "+sym+","+IntegerToString(Period())+" | "+message);
         SendMessage(InpChatID,type+" | @  "+sym+","+IntegerToString(Period())+" | "+message);
        }
      else if(type == "order")
        {
        }
      else if(type == "modify")
        {
        }
     }

   int myOrderSend(string sym,int type, double price, double volume, string ordername ) //send order, return ticket ("price" is irrelevant for market orders)
     {
     
    
      if(!IsTradeAllowed()) return(-1);
      int ticket = -1;
    retries = 0;
      int err = 0;
      int long_trades = TradesCount(OP_BUY,sym);
      int short_trades = TradesCount(OP_SELL,sym);
      int long_pending = TradesCount(OP_BUYLIMIT,sym) + TradesCount(OP_BUYSTOP,sym);
      int short_pending = TradesCount(OP_SELLLIMIT,sym) + TradesCount(OP_SELLSTOP,sym);
      string ordername_ = ordername;
      if(ordername != "")
         ordername_ = "("+ordername+")";
      //test Hedging
      if(!Hedging && ((type % 2 == 0 && short_trades + short_pending > 0) || (type % 2 == 1 && long_trades + long_pending > 0)))
        {
         myAlert(sym,"print", "Order"+ordername_+" not sent, hedging not allowed");
         
         SendMessage(InpChannel,"Order"+ordername_+ "not sent, hedging not allowed");
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
         myAlert(sym,"print", "Order"+ordername_+" not sent, maximum reached");
        SendMessage(InpChatID, "Order"+ordername_+" not sent, maximum reached");
         return(-1);
        }
       double SL=0,TP=0;
      //prepare to send order
      while(IsTradeContextBusy()) Sleep(100);
      

      
      RefreshRates();
      if(type == OP_BUY || type==OP_BUYLIMIT || type==OP_BUYSTOP)
       {  price = MarketInfo(sym,MODE_ASK);
        SL= price -stoploss*MarketInfo(sym,MODE_POINT);
            
         TP= price +takeprofit*MarketInfo(sym,MODE_POINT);
         
        } 
      else if(type == OP_SELL || type==OP_SELLLIMIT || type==OP_SELLSTOP)
         {price =  price = MarketInfo(sym,MODE_BID);
         
         SL= price +stoploss*MarketInfo(sym,MODE_POINT);
            
         TP= price -takeprofit*MarketInfo(sym,MODE_POINT);
         
         
         }
      else if(price < 0) //invalid price for pending order
        {
        // myAlert(sym,"order", "Order"+ordername_+" not sent, invalid price for pending order");
         SendMessage(InpChannel,"Order"+ordername_+" not sent, invalid price for pending order");
   	  return(-1);
        }
      int clr = (type % 2 == 1) ? clrWhite : clrGold;
      while(ticket < 0 && retries < OrderRetry+1)
        {
        LotDigits=(int)MarketInfo(sym,MODE_LOTSIZE);
        
         ticket = OrderSend(sym, type,
          NormalizeDouble(volume, LotDigits),
          NormalizeDouble(price,  (int)MarketInfo(sym,MODE_DIGITS))
           ,
           
          0, 
          SL, TP,
           ordername, 
           2234,
            0, clr);
         if(ticket < 0)
           {
            err = GetLastError();
            myAlert(sym,"print", "OrderSend"+ordername_+" error #"+IntegerToString(err)+" "+ErrorDescription(err));
                Sleep(OrderWait*1000);
           }
           
       
       if(ticket < 0)
        {
           myAlert(sym,"error", "OrderSend"+ordername_+" failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err));
           SendMessage(InpChannel, "OrderSend"+ordername_+" failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err));
   
         return(-1);
        }
      string typestr[6] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop"};
    
          myAlert(sym,"order", "Order sent"+ordername_+": "+typestr[type]+" "+sym+" Magic #"+IntegerToString(MagicNumber));
         SendMessage(InpChatID,"Order sent"+ordername_+": "+typestr[type]+sym+" "+ (string)MagicNumber+" "+IntegerToString(MagicNumber));

         retries++;
        }
        return ticket;
     
   }
      int               Templates(const string _list)
      {
         m_templates.Clear();
         //--- parsing
         string text=StringTrim(_list);
         if(text=="")
            return(0);
   
         //---
         while(StringReplace(text,"  "," ")>0);
         StringReplace(text,";"," ");
         StringReplace(text,","," ");
   
         //---
         string array[];
         int amount=StringSplit(text,' ',array);
         amount=fmin(amount,5);
   
         for(int i=0; i<amount; i++)
         {
            array[i]=StringTrim(array[i]);
            if(array[i]!="")
               m_templates.Add(array[i]);
         }
   
         return(amount);
      }
   
      //+------------------------------------------------------------------+
      int               SendScreenShot(const long _chat_id,
                                       const string _symbol,
                                       const ENUM_TIMEFRAMES _period,
                                       const string _template=NULL)
      {
         int result=0;
   
         long chart_id=ChartOpen(_symbol,_period);
         if(chart_id==0)
            return(ERR_CHART_NOT_FOUND);
   
         ChartSetInteger(ChartID(),CHART_BRING_TO_TOP,true);
   
         //--- updates chart
         int wait=30;
         while(--wait>0)
         {
            if(SeriesInfoInteger(_symbol,_period,SERIES_SYNCHRONIZED))
               break;
            Sleep(30);
         }
   
         if(_template!=NULL)
            if(!ChartApplyTemplate(chart_id,_template))
               PrintError(_LastError,InpLanguage);
   
         ChartRedraw(chart_id);
         Sleep(500);
   
         ChartSetInteger(chart_id,CHART_SHOW_GRID,false);
   
         ChartSetInteger(chart_id,CHART_SHOW_PERIOD_SEP,false);
   
         string filename=StringFormat("%s%d.gif",_symbol,_period);
   
         if(FileIsExist(filename))
            FileDelete(filename);
         ChartRedraw(chart_id);
   
         Sleep(100);
   
         if(ChartScreenShot(chart_id,filename,800,600,ALIGN_RIGHT))
         {
            
            Sleep(100);
            
            //--- Need for MT4 on weekends !!!
            ChartRedraw(chart_id);
            
            SendChatAction(_chat_id,ACTION_UPLOAD_PHOTO);
   
            //--- waitng 30 sec for save screenshot
            wait=60;
            while(!FileIsExist(filename) && --wait>0)
               Sleep(500);
   
            //---
            if(FileIsExist(filename))
            {
               string screen_id;
               result=SendPhoto(screen_id,_chat_id,filename,_symbol+"_"+StringSubstr(EnumToString(_period),7));
            }
            else
            {
               string mask=m_lang==LANGUAGE_EN?"Screenshot file '%s' not created.":"Файл скриншота '%s' не создан.";
               PrintFormat(mask,filename);
            }
         }
   
         ChartClose(chart_id);
         return(result);
      }
   
      //+------------------------------------------------------------------+
      void              ProcessMessages(void)
      {
             
   int ticket=0;
   string symbol="";

          for(int i=0; i<m_chats.Total(); i++)
      
         {
            CCustomChat *chat=m_chats.GetNodeAtIndex(i);
            if(!chat.m_new_one.done)
            {
               chat.m_new_one.done=true;
               string text=chat.m_new_one.message_text;
   
               //--- start
               if(StringFind(text,"start")>=0 || StringFind(text,"help")>=0)
               {
                  chat.m_state=0;
                  string msg="The bot works with your trading account:\n";
                  msg+="/info - get account information\n";
                  msg+="/quotes - get quotes\n";
                  msg+="/charts - get chart images\n";
                  msg+="/trade- start live  trade"; 
                  msg+="/ordertotal -get orderstotal";
                   msg+="/orderhistory -get ordershistory";
                 
                  msg+="/account -- get account infos ";
                  msg+="/analysis  -- get market analysis";
   
                  if(m_lang==LANGUAGE_RU)
                  {
                     msg="Бот работает с вашим торговым счетом:\n";
                     msg+="/info - запросить информацию по счету\n";
                     msg+="/quotes - запросить котировки\n";
                     msg+="/charts - запросить график\n";
                     msg+="/trade"; 
                    
                     msg+="/analysis";
                     msg+="/report"
                  ;}
   
                  SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_MAIN,false,false));
                  continue;
               }
   
               //---
               if(text==EMOJI_TOP)
               {
                  chat.m_state=0;
                  string msg=(m_lang==LANGUAGE_EN)?"Choose a menu item":"Выберите пункт меню";
                  SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_MAIN,false,false));
                  continue;
               }
   
               //---
               if(text==EMOJI_BACK)
               {
                  if(chat.m_state==31)
                  {
                     chat.m_state=3;
                     string msg=(m_lang==LANGUAGE_EN)?"Enter a symbol name like 'EURUSD'":"Введите название инструмента, например 'EURUSD'";
                     SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
                  }
                  else if(chat.m_state==32)
                  {
                     chat.m_state=31;
                     string msg=(m_lang==LANGUAGE_EN)?"Select a timeframe like 'H1'":"Введите период графика, например 'H1'";
                     SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_PERIODS,false,false));
                  }
                  else
                  {
                     chat.m_state=0;
                     string msg=(m_lang==LANGUAGE_EN)?"Choose a menu item":"Выберите пункт меню";
                     SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_MAIN,false,false));
                  }
                  continue;
               }
   
               //---
               if(text=="/info" || text=="Account Info" || text=="Информация")
               {
                  chat.m_state=1;
                   SendMessage(chat.m_id,BotAccount(),ReplyKeyboardMarkup(KEYB_MAIN,false,false));
                  continue;
               }
               //---
               if(text=="ordertrade"||text=="/ordertrade"){
               
                BotOrdersTrade(false);
               
             
               }
               
                //---
               if(text=="/history"){
               
                BotOrdersTrade(false);
               
             
               }
   
               //---
               if(text=="/quotes" || text=="Quotes" || text=="Котировки")
               {
                  chat.m_state=2;
                  string msg=(m_lang==LANGUAGE_EN)?"Enter a symbol name like 'EURUSD'":"Введите название инструмента, например 'EURUSD'";
                  SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
                  continue;
               }
   
               //---
               if(text=="/charts" || text=="Charts" || text=="chart"|| text=="Графики")
               {
                  chat.m_state=3;
                  string msg=(m_lang==LANGUAGE_EN)?"Enter a symbol name like 'EURUSD'":"Введите название инструмента, например 'EURUSD'";
                  SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
                  continue;
               }
               //Trade 
               
               
               
               if(text== "/trade" || text=="trade"){
               
               string msg="=======TRADE MODE====== \nSelect symbol!";
                SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
               chat.m_state =4;
              
              }
              
              if(text=="/analysis"|| text=="analysis"){
              
                  chat.m_state=1;
                string msg="=========== Market Analysis ==========";
                
                for(i=0;i<SymbolsTotal(false);i++){
                string sym="",sy[6];
                sy[0]=SymbolName(i,false);
                sym=sy[0];
                for(i=0;i<iBars(sym,0);i++){
                
        
                
               msg=  sym+" \n"+StringFormat("open %s\n,close %s\n, high %s\n, low %s\n===========",
               
               (string)iOpen(sym,PERIOD_CURRENT,i),(string)iClose(sym,PERIOD_CURRENT,i)
               ,(string)iHigh(sym,PERIOD_CURRENT,1),
               (string)iLow(sym,PERIOD_CURRENT,0)
               );
               }
               ;
               i++;
                        printf("symbol "+sym+ " "+msg);
                        ;break;
                         SendMessage(chat.m_id,msg);
        
                } 
                
                
             
           
              }
              
               if(text=="/ordertotal"|| text=="ordertotal"){
              
                string msg="=========== Ordertotal ==========\n====Total "+(string)OrdersTotal();
                        
               SendMessage(chat.m_id,BotOrdersTotal());
                    printf(msg);
              continue;
              }
              
               if(text=="/orderhistory"|| text=="orderhistory"){
              
                string msg="=========== Order ====History Total======\n====Total "+(string)OrdersHistoryTotal();
                  SendMessage(chat.m_id,BotOrdersHistoryTotal());
            
                  printf(msg);
                  continue;
              
              }
              
              
              
              
              
              
              
              
              
              
             if(text=="/report" || text=="report"){
             double profit=0 ,losses=0;
             string msg="";
               
               int gh=0;
                 msg="=== ===== Trade Report ==== ==";
         
               
               msg=BotOrdersTrade(true);
               
                  chat.m_state=1;
                     
                             
               SendMessage(chat.m_id,msg);
               continue;
               
 
              }
     


    
        //CREATE ORDERS
        
       ObjectCreate(ChartID(),"symb", OBJ_LABEL,0,Time[0],MarketInfo(      Symbol(),MODE_ASK));
              
        //SEARCHING  SYMBOL TO CREATE ORDER
        for(int j=SymbolsTotal(false)-1;j>0;j--){
                 StringToUpper(text);
        if(StringFind(text,SymbolName(j,false),0)>=0){
              string symb=  SymbolName(j,false);
              
             ObjectSetInteger(ChartID(),"symb",OBJPROP_YDISTANCE,100);
             
             ObjectSetInteger(ChartID(),"symb",OBJPROP_XDISTANCE,Time[0]);
                  
             ObjectSetText("symb","Telegram Symbol: "+        symb,12,NULL,clrYellow);
              
             if(ImmediateExecution==MARKET_ORDER){      
         
               if(StringFind(text,"SELL",0)>=0){
                    
               ticket =myOrderSend(symb,OP_SELL,MarketInfo(symb,MODE_BID),Lots,"MARKET SELL ORDER");
                if(ticket<0)SendMessage(chat.m_id," ERROR "+ GetErrorDescription(GetLastError(),0));
                return;
              
                 }else
                       if(StringFind(text,"BUY",0)>=0){
                    
               ticket =myOrderSend(symb,OP_BUY,MarketInfo(symb,MODE_ASK),Lots,"MARKET BUY ORDER");
                if(ticket<0)SendMessage(chat.m_id," ERROR "+ GetErrorDescription(GetLastError(),0));
                return;
             
                 }
               
          
          }else
                  
          if(ImmediateExecution== LIMIT_ORDER){     
           
    
                   if(StringFind(text,"BUY",0)>=0 ){                        
                  ticket =myOrderSend(symb,OP_BUYLIMIT,MarketInfo(symb,MODE_ASK),Lots,"BUY LIMIT ORDER");
                if(ticket<0)SendMessage(chat.m_id," ERROR "+ GetErrorDescription(GetLastError(),0));
                return;
              }
              else 
     
              if( StringFind(text,"SELL",0)>=0 ){
                    
                ticket =myOrderSend(symb,OP_SELLLIMIT,MarketInfo(symb,MODE_BID),Lots,"SELL Limit ORDER");
                
                 if(ticket<0)SendMessage(chat.m_id," ERROR "+ GetErrorDescription(GetLastError(),0));
                 return  ;
              
              }  
               
           }else
           
             if (ImmediateExecution==STOPLOSS_ORDERS){
           
   
              if(StringFind(text,"BUY",0)>=0 ){                              
               ticket =myOrderSend(symb,OP_BUYSTOP,MarketInfo(symb,MODE_ASK),Lots,"BUY STOPLOSS ORDER");
                if(ticket<0){SendMessage(chat.m_id," ERROR "+ GetErrorDescription(GetLastError(),0));
              return;
              }
              }
              else 
                    if(StringFind(text,"SELL",0)>=0){
                 ticket =myOrderSend(symb,OP_SELLSTOP,MarketInfo(symb,MODE_BID),Lots,"SELL STOPLOSS ORDER");
                if(ticket<0)SendMessage(chat.m_id," ERROR "+ ErrorDescription(GetLastError()));
                  }
            
              
            
            }
             
         
          }
                  j++;
                  break;
                 }
    
               //--- Quotes
               if(chat.m_state==2)
               {
                  string mask=(m_lang==LANGUAGE_EN)?"  Invalid symbol name '%s'":"Инструмент '%s' не найден";
                  string msg=StringFormat(mask,text);
                  StringToUpper(text);
                  symbol=text;
                  if(SymbolSelect(symbol,true))
                  {
                     double open[1]= {0};
   
                     m_symbol=symbol;
                     //--- upload history
                     for(int k=0; k<3; k++)
                     {
   #ifdef __MQL4__
                        double array[][6];
                        ArrayCopyRates(array,symbol,PERIOD_D1);
   #endif
   
                        Sleep(2000);
                        CopyOpen(symbol,PERIOD_D1,0,1,open);
                        if(open[0]>0.0)
                           break;
                     }
   
                     int digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
                     double bid=SymbolInfoDouble(symbol,SYMBOL_BID);
   
                     CopyOpen(symbol,PERIOD_D1,0,1,open);
                     if(open[0]>0.0)
                     {
                        double percent=100*(bid-open[0])/open[0];
                        //--- sign
                        string sign=ShortToString(0x25B2);
                        if(percent<0.0)
                           sign=ShortToString(0x25BC);
   
                        msg=StringFormat("%s: %s %s (%s%%)",symbol,DoubleToString(bid,digits),sign,DoubleToString(percent,2));
                     }
                     else
                     {
                        msg=(m_lang==LANGUAGE_EN)?"No history for ":"Нет истории для "+symbol;
                     }
                  }
   
                  SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
                  continue;
               }
     ArrayResize(Symbols,SymbolsTotal(false),0);
               //--- Charts
               if(chat.m_state==3)
               {
   
                  StringToUpper(text);
                  symbol=text;
                  if(SymbolSelect(symbol,true))
                  {
                     m_symbol=symbol;
   
                     chat.m_state=31;
                     string msg=(m_lang==LANGUAGE_EN)?"Select a timeframe like 'H1'":"Введите период графика, например 'H1'";
                     SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_PERIODS,false,false));
                  }
                  else
                  {
                     string mask=(m_lang==LANGUAGE_EN)?"Invalid symbol name '%s'":"Инструмент '%s' не найден";
                     string msg=StringFormat(mask,text);
                     SendMessage(chat.m_id,msg,ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false));
                  }
                  continue;
               }
   
   
   
    if(i<SymbolsTotal(false)){
               
               
               
                for (int j =0;j<SymbolsTotal(false);j++){
                  if(StringFind(text,SymbolName(j,false),0)>=0){
                  
                Symbols[0]=SymbolName(j,false);
                          Comment(Symbols[0]);
                break; 
                }
          
                }
             
             }
   
   
             Lots= MM_Size(Symbols[0]);
   
                printf("sym[0] :"+Symbols[0]);
                if(StringFind(text,"BUY",0)>=0 )
                  {
                
               myOrderSend(Symbols[0],OP_BUY,MarketInfo(Symbols[0],MODE_ASK),Lots,"MARKET BUY  ORDER");
               
              
              }else
              
               if(StringFind(text,"SELL",0)>=0 ){
                    
               myOrderSend(Symbols[0],OP_SELL,MarketInfo(Symbols[0],MODE_BID),Lots,"MARKET SELL ORDER");
               
              
                 }
                 
                  // CREATE LIMIT ORDERS 
                    
              if(StringFind(text,"BUYLIMIT",0)>=0 ){                        
                  ticket =myOrderSend(Symbols[0],OP_BUYLIMIT,MarketInfo(Symbols[0],MODE_ASK),Lots,"BUY LIMIT ORDER");
              
              }
              else 
     
              if( StringFind(text,"SELLLIMIT",0)>=0 ){
                    
                ticket =myOrderSend(Symbols[0],OP_SELLLIMIT,MarketInfo(Symbols[0],MODE_BID),Lots,"SELL Limit ORDER");
                ;
              
              }  
      
             // CREATE STOPLOSS ORDER 
              if(StringFind(text,"BUYSTOP",0)>=0 ){                              
               ticket =myOrderSend(Symbols[0],OP_BUYSTOP,MarketInfo(Symbols[0],MODE_ASK),Lots,"BUY STOPLOSS ORDER");
                if(ticket<0)SendMessage(chat.m_id," ERROR "+ GetErrorDescription(GetLastError(),0));
              }else
              
               if(StringFind(text,"SELLSTOP",0)>=0 ){
                 ticket =myOrderSend(Symbols[0],OP_SELLSTOP,MarketInfo(Symbols[0],MODE_BID),Lots,"SELL STOPLOSS ORDER");
                      }
   
   
           
        if(chat.m_state ==4){
                
             if(i<SymbolsTotal(false)){
          
                for (int j =0;j<SymbolsTotal(false);j++){
                  if(StringFind(text,SymbolName(j,false),0)>=0){
                  
                Symbols[0]=SymbolName(j,false);
                      SendMessage(chat.m_id,"Click buttons to trade",ReplyKeyboardMarkup(KEYB_SYMBOLS,false,false),false,false);
                    chat.m_state=5;
                    Comment(Symbols[0]);
                break;  }
          
                }
             
             }
         }
          
          
             
          while(chat.m_state==5){
          
   
                printf("sym[0] :"+Symbols[0]);
                if(StringFind(text,"BUY",0)>=0 )
                  {
                
               myOrderSend(Symbols[0],OP_BUY,MarketInfo(Symbols[0],MODE_ASK),Lots,"MARKET BUY  ORDER");
               
              
              }else
              
               if(StringFind(text,"SELL",0)>=0 ){
                    
               myOrderSend(Symbols[0],OP_SELL,MarketInfo(Symbols[0],MODE_BID),Lots,"MARKET SELL ORDER");
               
              
                 }
                 
                  // CREATE LIMIT ORDERS 
                    
              if(StringFind(text,"BUYLIMIT",0)>=0 || StringFind(text,"BUY_LIMIT",0)>=0 ){                        
                  ticket =myOrderSend(Symbols[0],OP_BUYLIMIT,MarketInfo(Symbols[0],MODE_ASK),Lots,"BUY LIMIT ORDER");
              
              }
              else 
     
              if( StringFind(text,"SELLLIMIT",0)>=0||StringFind(text,"SELL_LIMIT",0)>=0 ){
                    
                ticket =myOrderSend(Symbols[0],OP_SELLLIMIT,MarketInfo(Symbols[0],MODE_BID),Lots,"SELL Limit ORDER");
                ;
              
              }  
      
             // CREATE STOPLOSS ORDER 
              if(StringFind(text,"BUYSTOP",0)>=0|| StringFind(text,"BUY_STOP",0)>=0 ){                              
               ticket =myOrderSend(Symbols[0],OP_BUYSTOP,MarketInfo(Symbols[0],MODE_ASK),Lots,"BUY STOPLOSS ORDER");
                if(ticket<0)SendMessage(chat.m_id," ERROR "+ GetErrorDescription(GetLastError(),0));
              }else
              
               if(StringFind(text,"SELLSTOP",0)>=0||StringFind(text,"SELL_STOP",0)>=0 ){
                 ticket =myOrderSend(Symbols[0],OP_SELLSTOP,MarketInfo(Symbols[0],MODE_BID),Lots,"SELL STOPLOSS ORDER");
                      }
              break;            
        }
             //Charts->Periods
               if(chat.m_state==31)
               {
                  bool found=false;
                  int total=ArraySize(_periods);
                  for(int k=0; k<total; k++)
                  {
                     string str_tf=StringSubstr(EnumToString(_periods[k]),7);
                     if(StringCompare(str_tf,text,false)==0)
                     {
                        m_period=_periods[k];
                        found=true;
                        break;
                     }
                  }
   
                  if(found)
                  {
                     //--- template
                     chat.m_state=32;
                     string str="[[\""+EMOJI_BACK+"\",\""+EMOJI_TOP+"\"]";
                     str+=",[\"None\"]";
                     for(int k=0; k<m_templates.Total(); k++)
                        str+=",[\""+m_templates.At(k)+"\"]";
                     str+="]";
   
                     SendMessage(chat.m_id,(m_lang==LANGUAGE_EN)?"Select a template":"Выберите шаблон",ReplyKeyboardMarkup(str,false,false));
                  }
                  else
                  {
                     SendMessage(chat.m_id,(m_lang==LANGUAGE_EN)?"Invalid timeframe":"Неправильно задан период графика",ReplyKeyboardMarkup(KEYB_PERIODS,false,false));
                  }
                  continue;
               }
               //---
               if(chat.m_state==32)
               {
                  m_template=text;
                  if(m_template=="None")
                     m_template=NULL;
                  int result=SendScreenShot(chat.m_id,m_symbol,m_period,m_template);
                  if(result!=0)
                     Print(GetErrorDescription(result,InpLanguage));
               }
            }
         }
      }
};      //|-----------------------------------------------------------------------------------------|
//|                                O R D E R S   S T A T U S                                |
//|-----------------------------------------------------------------------------------------|

 string BotOrdersTotal(bool noPending=true)
{string message;
   int count=0;
   int total=OrdersTotal();
//--- Assert optimize function by checking total > 0
   if( total<=0 ) return( strBotInt("Total", count) );   
//--- Assert optimize function by checking noPending = false
   if( noPending==false ) return( strBotInt("Total", total) );
   
//--- Assert determine count of all trades that are opened
   for(int i=0;i<total;i++) {
      int go=OrderSelect( i, SELECT_BY_POS, MODE_TRADES );
   //--- Assert OrderType is either BUY or SELL
      if( OrderType() <= 1 ) count ++;
   }
   return( strBotInt( "Total", count ) );
}

string BotOrdersTrade(bool noPending=true)
{string message;
   int ticket = -1;
   int count=0;
   const string strPartial="from #";
   int total=OrdersTotal();
//--- Assert optimize function by checking total > 0
   if( total<=0 ) return( message );   

//--- Assert determine count of all trades that are opened
   for(int i=total-1;i>--total;i--) {
      ticket=OrderSelect( i, SELECT_BY_POS, MODE_HISTORY );

   //--- Assert OrderType is either BUY or SELL if noPending=true
      if( noPending==true && OrderType() > 1 ) continue ;
      else count++;

      message += StringConcatenate(message, strBotInt( "Ticket",OrderTicket() ));
      message += StringConcatenate(message, strBotStr( "Symbol",OrderSymbol() ));
      message += StringConcatenate(message, strBotInt( "Type",OrderType() ));
      message += StringConcatenate(message, strBotDbl( "Lots",OrderLots(),2 ));
      message += StringConcatenate(message, strBotDbl( "OpenPrice",OrderOpenPrice(),5 ));
      message += StringConcatenate(message, strBotDbl( "CurPrice",OrderClosePrice(),5 ));
      message+= StringConcatenate(message, strBotDbl( "StopLoss",OrderStopLoss(),5 ));
      message += StringConcatenate(message, strBotDbl( "TakeProfit",OrderTakeProfit(),5 ));
      message+= StringConcatenate(message, strBotTme( "OpenTime",OrderOpenTime() ));
      message += StringConcatenate(message, strBotTme( "CloseTime",OrderCloseTime() ));
      
      BotHistoryTicket(i,true);
      
      
   //--- Assert Partial Trade has comment="from #<historyTicket>"
      if( StringFind( OrderComment(), strPartial )>=0 )
         message = StringConcatenate(message, strBotStr( "PrevTicket", StringSubstr(OrderComment(),StringLen(strPartial)) ));
      else
         message= StringConcatenate(message, strBotStr( "PrevTicket", "0" ));
   }
//--- Assert msg isnt empty
   if( message=="" ) return( message );   
   
//--- Assert append count of trades
   message = StringConcatenate(strBotInt( "Count",count ), message);
   return( message);
}

string BotOrdersTicket(int tickets, bool noPending=true)
{string gh;

for(int a=OrdersHistoryTotal()-1;a>0;a++){

if(OrderSelect(a,SELECT_BY_POS,MODE_HISTORY)){
 gh+=(string)"Ticket: "+(string)OrderTicket()+"  "+ "DATE"+(string) TimeCurrent();
}


};


   return( gh );
}

string BotHistoryTicket(int tickets, bool noPending=true)
{
  string message;
   const string strPartial="from #";
   int total=OrdersHistoryTotal();
//--- Assert optimize function by checking total > 0
   if( total<=0 ) return( message );   

//--- Assert determine history by ticket
   if( OrderSelect( tickets, SELECT_BY_TICKET, MODE_HISTORY )==false ) return( message );
  
//--- Assert OrderType is either BUY or SELL if noPending=true
   if( noPending==true && OrderType() >=0 ) return( message);
      
//--- Assert OrderTicket is found

   message+= (string)StringConcatenate(message, strBotStr( "Date",(string)TimeCurrent() ));
   message +=  (string)StringConcatenate(message, strBotInt( "Ticket",OrderTicket() ));
   message +=  (string)StringConcatenate(message, strBotStr( "Symbol",OrderSymbol() ));
   message+=  (string)StringConcatenate(message, strBotInt( "Type",OrderType() ));
   message+=  (string)StringConcatenate(message, strBotDbl( "Lots",OrderLots(),2 ));
   message+=  (string)StringConcatenate(message, strBotDbl( "OpenPrice",OrderOpenPrice(),5 ));
   message+=  (string)StringConcatenate(message, strBotDbl( "ClosePrice",OrderClosePrice(),5 ));
   message+=  (string)StringConcatenate(message, strBotDbl( "StopLoss",OrderStopLoss(),5 ));
   message+= (string) StringConcatenate(message, strBotDbl( "TakeProfit",OrderTakeProfit(),5 ));
   message+=  (string)StringConcatenate(message, strBotTme( "OpenTime",OrderOpenTime() ));
   message += (string) StringConcatenate(message, strBotTme( "CloseTime",OrderCloseTime() ));
   
//--- Assert Partial Trade has comment="from #<historyTicket>"
   if( StringFind( OrderComment(), strPartial )>=0 )
      message += StringConcatenate(message, strBotStr( "PrevTicket", StringSubstr(OrderComment(),StringLen(strPartial)) ));
   else
      message+= StringConcatenate(message, strBotStr( "PrevTicket", "0" ));
      
   return( message);
}

string BotOrdersHistoryTotal(bool noPending=true)
{
   return( strBotInt( "Total", OrdersHistoryTotal() ) );
}


string tradeReport(bool noPending=true){
string  report="None";

  for(int jk= OrdersHistoryTotal()-1; jk>0; jk --){
if(OrderSelect(jk,SELECT_BY_POS,MODE_HISTORY )==false){
if(OrderProfit()>0){
report+="Total Profit : "+ (string)OrderProfit()+ "  "+(string)TimeCurrent() ;


}
if(OrderProfit()<0){
report+="Total Losses: "+ (string)OrderProfit()+"  "+(string)TimeCurrent();


};

};

}

return report;
}

//|-----------------------------------------------------------------------------------------|
//|                               A C C O U N T   S T A T U S                               |
//|-----------------------------------------------------------------------------------------|
string BotAccount(void) 
{


   string message;
   message= StringConcatenate(message, strBotInt( "Number",AccountNumber() ));
   message = StringConcatenate(message, strBotStr( "Currency",AccountCurrency() ));
   message = StringConcatenate(message, strBotDbl( "Balance",AccountBalance(),2 ));
   message = StringConcatenate(message, strBotDbl( "Equity",AccountEquity(),2 ));
   message = StringConcatenate(message, strBotDbl( "Margin",AccountMargin(),2 ));
   message = StringConcatenate(message, strBotDbl( "FreeMargin",AccountFreeMargin(),2 ));
   message= StringConcatenate(message, strBotDbl( "Profit",AccountProfit(),2 ));
      return( message );
}


//|-----------------------------------------------------------------------------------------|
//|                           I N T E R N A L   F U N C T I O N S                           |
//|-----------------------------------------------------------------------------------------|
string strBotInt(string key, int val)
{
   return( StringConcatenate(NL,key,"=",val) );
}
string strBotDbl(string key, double val, int dgt=5)
{
   return( StringConcatenate(NL,key,"=",NormalizeDouble(val,dgt)) );
}
string strBotTme(string key, datetime val)
{
   return( StringConcatenate(NL,key,"=",TimeToString(val)) );
}
string strBotStr(string key, string val)
{
   return( StringConcatenate(NL,key,"=",val) );
}
string strBotBln(string key, bool val)
{
   string valType;
   if( val )   valType="true";
   else        valType="false";
   return StringConcatenate(NL,key,"=",valType) ;
} 




 
   
   

 //+------------------------------------------------------------------+
 //|                       TradeSignal2                                           |
 //+------------------------------------------------------------------+

 string signalList[10];
ENUM_ORDER_TYPE TradeSignal2(string symbol) //Get    trades signals
  {

  ushort ad=',';
  int signalFinalList[];
     const  int totalSignal =StringSplit(InpSignalList,ad,signalList);
   double buy=0,sell=0;   
      
ArrayResize(signalFinalList,totalSignal,0);      
      for(int po=0; po < totalSignal; po ++){
     
      signalFinalList[po]=signalFilter((int)iCustom(symbol,InpTimFrame,signalList[po],0,1),(int)iCustom(symbol,InpTimFrame,signalList[po],1,1));
      
     
          }
          
          
          string tradeTex="";  string message;

   
//string tradeTex;
//   
//   
//   //--- correct way of working in the "file sandbox" 
   ResetLastError(); 
 
//   
 for(int h=0;h<totalSignal;h++){
 
 if(signalFinalList[h]==1)//StringFind(tradeTex,"Buy "+symbol,0)>0)){
 {
 message=tradeTex+" Buy "+symbol;
  
  smartBot.SendScreenShot(InpChatID,symbol,InpTimFrame,Template);
  
  int  filehandle=FileOpen("TradeSignal.csv",FILE_READ||FILE_WRITE||FILE_CSV||FILE_ANSI,';');
   if(filehandle!=INVALID_HANDLE) 
     { 
     
      FileWrite(filehandle,"TIME","SYMBOL", "TIMEFRAME","SIGNAL"); 
      FileWrite(filehandle,TimeCurrent(),symbol, EnumToString(ENUM_TIMEFRAMES(_Period)),OP_BUY); 
      tradeTex=FileReadString(filehandle,0);
      FileClose(filehandle);
 
 }else { printf("Can't open file TradeSignal.csv");
 }

 return OP_BUY;
 }else  if(signalFinalList[h]<=-1
 ){
  
  smartBot.SendScreenShot(InpChatID,symbol,InpTimFrame,Template);
  
 message=tradeTex+" Sell"+symbol;
   int  filehandle=FileOpen("TradeSignal.csv",FILE_READ||FILE_WRITE||FILE_CSV||FILE_ANSI,';');
   if(filehandle!=INVALID_HANDLE) 
     { 
     
      FileWrite(filehandle,"TIME","SYMBOL", "TIMEFRAME","SIGNAL"); 
      FileWrite(filehandle,TimeCurrent(),Symbol(), EnumToString(ENUM_TIMEFRAMES(_Period)),OP_SELL); 
      tradeTex=FileReadString(filehandle,0);
      FileClose(filehandle);
 
 }else { printf("Can't open file TradeSignal.csv");
 }

 return OP_SELL;
 }else  if(signalFinalList[h]<-20 && signalFinalList[h]>=-50){
   
  smartBot.SendScreenShot(InpChatID,symbol,InpTimFrame,Template);

 
 return OP_SELLLIMIT;
 }
 else if(signalFinalList[h]>20 && signalFinalList[h]<=50){
 
 message="SellLimit "+symbol;
  
  smartBot.SendScreenShot(InpChatID,symbol,InpTimFrame,Template);

 return OP_BUYLIMIT;
 }else if(signalFinalList[h]>50 && signalFinalList[h]<=100){
 
 
 
 message=tradeTex+" Buy "+symbol;
 
 message= tradeTex+" Buy "+symbol;
  smartBot.SendScreenShot(InpChatID,symbol,InpTimFrame,Template);

 return OP_BUYSTOP;
 
 }else if(signalFinalList[h]<-50
  && signalFinalList[h]>=-100){
 
 message=tradeTex+" Sell "+symbol;

  smartBot.SendScreenShot(InpChatID,symbol,InpTimFrame,Template);

 return OP_SELLSTOP;
 
 }

}

 return 0;
 }
 //+------------------------------------------------------------------+
//|                    Order_type                                               |
//+------------------------------------------------------------------+
string order_type()
  {

   if(OrderType() == OP_BUY)
      return "BUY";
   if(OrderType() == OP_SELL)
      return "SELL";
   if(OrderType() == OP_BUYLIMIT)
      return "BUYLIMIT";
   if(OrderType() == OP_SELLLIMIT)
      return "SELLLIMIT";
   if(OrderType() == OP_BUYSTOP)
      return "BUYSTOP";
   if(OrderType() == OP_SELLSTOP)
      return "SELLSTOP";

   return "";
  }
 
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double order_pips()
  {
   if(OrderType() == OP_BUY)
     {
      return (OrderClosePrice()-OrderOpenPrice())/(MathMax(MarketInfo(OrderSymbol(),MODE_POINT),0.00000001));
     }
   else
     {
      return (OrderOpenPrice()-OrderClosePrice())/(MathMax(MarketInfo(OrderSymbol(),MODE_POINT),0.00000001));
     }
  }
//+------------------------------------------------------------------+
//|                               tradeResponse                                    |
//+------------------------------------------------------------------+
void tradeResponse(string symbol1)
  {

string symbol=symbol1;
     string message;


      int total=OrdersTotal();
      datetime max_time = 0;

      for(int pos=0; pos<total; pos++) // Current orders -----------------------
        {
         if(OrderSelect(pos,SELECT_BY_POS)==false&& OrderSymbol()!=symbol)
            continue;
         if(OrderOpenTime() <= _opened_last_time)
            continue;
         
         else
         message = StringFormat(
                      "\n----TRADE_EXPERT\n OPEN ORDER----\r\n%s %s lots \r\n%s @ %s \r\nSL - %s\r\nTP - %s\r\n----------------------\r\n\n",
                      order_type(),
                      DoubleToStr(OrderLots(),2),
                      OrderSymbol(),
                      DoubleToStr(OrderOpenPrice(),(int)MarketInfo(symbol,MODE_DIGITS)),
                      DoubleToStr(OrderStopLoss(),(int)MarketInfo(symbol,MODE_DIGITS)),
                      DoubleToStr(OrderTakeProfit(),(int)MarketInfo(symbol,MODE_DIGITS))
                   );


         smartBot.SendMessage(InpChannel,message);


         if(StringLen(message) > 0)
           {
            smartBot.SendMessage(InpChatID2,message);
           }
         max_time = MathMax(max_time,OrderOpenTime());

        }

      _opened_last_time = MathMax(max_time,_opened_last_time);

     
   if(sendclose == Yes)
     {
     
      double day_profit = 0;

      bool is_closed = false;
      total = OrdersHistoryTotal();
      for(int pos=0; pos<total; pos++)  // History orders-----------------------
        {

         if(TimeDay(TimeCurrent()) == TimeDay(OrderCloseTime()) && OrderCloseTime() > iTime(symbol,InpTimFrame,0))
           {
            day_profit += order_pips();
           }

         if(OrderSelect(pos,SELECT_BY_POS,MODE_HISTORY)==false)
            continue;
         if(OrderCloseTime() <= _closed_last_time)
            continue;

         printf(TimeToStr(OrderCloseTime()));
         is_closed = true;
         message = StringFormat("\n"+smartBot.Name() +"CLOSE PROFIT----\r\n%s %s lots\r\n%s @ %s\r\nSL - %s \r\nTP - %s \r\nProfit: %s PIPS \r\n--------------------------------\r\n\n",
                                order_type(),
                                DoubleToStr(OrderLots(),2),
                                OrderSymbol(),
                                DoubleToStr(OrderOpenPrice(),(int)MarketInfo(symbol,MODE_DIGITS)),
                                DoubleToStr(OrderClosePrice(),(int)MarketInfo(symbol,MODE_DIGITS)),
                                DoubleToStr(OrderTakeProfit(),(int)MarketInfo(symbol,MODE_DIGITS)),
                                DoubleToStr(order_pips()/10,1)
                               );

           smartBot.SendMessage(InpChannel,message);


         if(StringLen(message) > 0)
           {
            if(is_closed)
               message = StringFormat("Total Profit for today %s : %s PIPS",symbol,DoubleToStr(day_profit/10,1));
            printf(message);

            smartBot.SendMessage(InpChatID2,message);
            }

         max_time = MathMax(max_time,OrderCloseTime());

        
      _closed_last_time = MathMax(max_time,_closed_last_time);
      

     }
     
     
     
     
     
     
     
     
     
     
     
     }


  }
  
  
  

// -----------------------------------------+
//+------------------------------------------------------------------+
//|                      SignalFilter                                            |
//+------------------------------------------------------------------+

ENUM_ORDER_TYPE signalFilter(int buySignal,int sellSignal){
 
    bool alignx=InpAlign;
  ;ENUM_ORDER_TYPE signalx=0;
  string commentx1,commentx;
   int buyx=buySignal;
  
  int sellx=sellSignal;
  
   if(alignx)
     {
      if(buyx== 1 && sellx==-1)
        {
        return signalx= OP_BUY;commentx="BUY SIGNAL";
        }
        else
      if(buyx == -1 && sellx==1)
        {
      return signalx= OP_SELL;commentx1="SELL SIGNAL";
        }
        else
        
        
         if(buyx>= 50 && sellx!=-50)
        {
        return signalx= OP_BUYLIMIT;
         commentx="BUYLIMIT SIGNAL";
        }
        else
      if(buyx <= -50 && sellx!=50)
        {
      return signalx= OP_SELLLIMIT;commentx1="SELLLIMIT SIGNAL";
        }
        
        else
         if(buyx== 100 && sellx==-100)
        {
      return   signalx= OP_BUYSTOP;commentx="BUYSTOP SIGNAL";
        }
        else
      if(buyx == -100 && sellx==100)
        {
       return signalx= OP_SELLSTOP;commentx1="SELLSTOP SIGNAL";
        }
        
        
  
     }
   else
     {
  
     
      if(buyx == 1)
        {
      return   signalx= OP_BUY;commentx1="BUY SIGNAL";
        }
      if(sellx == -1)
        {
       return signalx= OP_SELL;
        
        commentx="SELL SIGNAL";
        
        }
        else
        
        
        
         if(buyx>= 50 && sellx!=-50)
        {
         return signalx= OP_BUYLIMIT;
         commentx="BUYLIMIT SIGNAL";
        }
        else
      if(buyx <= -50 && sellx!=50)
        {commentx1="SELLLIMIT SIGNAL";
            return  signalx= OP_SELLLIMIT;
        }
        else
         if(buyx>= 100 && sellx!=-100)
        {commentx="BUYSTOP SIGNAL";
         return signalx= OP_BUYSTOP;
        }
        else
      if(buyx <=
       -100 && sellx!=100)
        {
     return  signalx= OP_SELLSTOP;commentx1="SELLSTOP SIGNAL";
        }
        
        }
        
      
return NULL;
}
    
  
  

    void TradeReport(string symbol, bool tradereportdates=false)
  {
   if(tradereportdates)
     {
      double totalprofit[],totalloss[],op_price[],cl_price[];

      long orderID=0;
      double winratio[];


      for(int jkl=OrdersHistoryTotal()-1;jkl>0;jkl--)
        {


         ArrayResize(symbols,OrdersHistoryTotal(),0);
         ArrayResize(totalloss,OrdersHistoryTotal(),0);
         ArrayResize(winratio,OrdersHistoryTotal(),0);

         ArrayResize(totalprofit,OrdersHistoryTotal(),0);
         ArrayResize(op_price,OrdersHistoryTotal(),0);
         ArrayResize(cl_price,OrdersHistoryTotal(),0);

         if(tradereportdates)
           {
            if(OrderSelect(jkl,SELECT_BY_POS,MODE_HISTORY)==true &&symbol==OrderSymbol())
              {

               symbols[jkl]+=OrderSymbol();
               op_price[jkl]+=OrderOpenPrice();
               cl_price[jkl]+=OrderClosePrice();

               if(OrderProfit()<=0)
                 {
                  totalloss[jkl]+=OrderProfit();
                 }


               if(OrderProfit()>0)
                 {
                  totalprofit[jkl]+=OrderProfit();
                 }

               winratio[jkl]+=(totalloss[jkl]/(1+totalprofit[jkl]));



               bool file=FileOpen(InpDirectoryName+"\\"+"TradeReport.csv",FILE_READ|FILE_WRITE|FILE_CSV|InpEncodingType);

               if(!file)
                 {
                  printf((string)ERR_FILE_CANNOT_OPEN+InpFileName);
                 }



               FileSeek(file,offset,SEEK_SET);
               bool write=FileWrite(file,"\n"+(string)TimeCurrent() +"    "+symbols[jkl]+"     "+(string)op_price[jkl]+"     "+(string)cl_price[jkl]+"      "+(string)totalloss[jkl]+"      "+(string)totalprofit[jkl]+"      "+(string)winratio[jkl]+"\n");
                   
              
         ///  smartBot.SendMessageToChannel(InpChannel, StringFormat("Symbol: %s, %2.4f %2.4f %2.4f %2.4f %2.4f ",(string)TimeCurrent(),symbols[jkl],(string)op_price[jkl],(string)cl_price[jkl],(string)totalloss[jkl],(string)totalprofit[jkl],(string)winratio[jkl]));
                   
               if(!write)
                  printf("Unable to write data in "+ "TradeReport.csv");

               FileClose(file);

              }

           }


        }

    }
    
    
    
    
    
   
    
    
    
    
    };
  
                    
       CComment comment;
       
CBot smartBot;
