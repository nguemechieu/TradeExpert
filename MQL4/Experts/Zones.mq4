//+------------------------------------------------------------------+
//|                                              Strategy: ZONES_EA.mq4 |
//|                                       Created By NOEL M NGUEMECHIEU |
//|                                        |
//+------------------------------------------------------------------+
#property copyright "NOEL M NGUEMECHIEU "
#property link      "https://www.tradeexpert.org"
#property version   "1.02"
#property description "AI POWERED MT4  TRADER"
#include <stdlib.mqh>
#include <stderror.mqh>

#include <DiscordTelegram\MQLMySQL.mqh>
#include <DiscordTelegram\Authenticator.mqh>

string INI;
//+------------------------------------------------------------------+
#define EXPERT_NAME     "ZONES"
#define EXPERT_VERSION  "1.0.2"

#define CAPTION_COLOR   clrWhite
#define LOSS_COLOR      clrOrangeRed

#property tester_file "trade.csv"    // file with the data to be read by an Expert Advisor TradeExpert_file "trade.csv"    // file with the data to be read by an Expert Advisor
#property icon "\\Images\\zones_ea.ico"
#property tester_library "Libraries"
#property stacksize 100000
#property description "This is a very interactive smartBot. It uses multiples indicators base on  define strategy to get trade signals a"
#property description "nd open orders. It also integrate news filter to allow you to trade base on news events. In addition the ea generate s"
#property description "ignals with screenshot on telegram or others withoud using dll import.This  give ea ability to trade on your vps witho"
#property description "ut restrictions."
#property description "This Bot will can trade generate ,manage and generate trading signals on telegram channel"

#include <DiscordTelegram\Comment.mqh>
#include <DiscordTelegram\Telegram.mqh>
#include <DiscordTelegram\CMybot.mqh>
#include <DiscordTelegram\News.mqh>
#resource "\\Indicators\\ZigZag.ex4"




#define INAME     "FFC"
#define TITLE     0
#define COUNTRY   1
#define DATE      2
#define TIME      3
#define IMPACT    4
#define FORECAST  5
#define PREVIOUS  6

enum ENUM_UNIT
  {
   InPips,                 // SL in pips
   InDollars               // SL in dollars
  };


datetime       time_check;
int            web_error;
/** Now, MarketData and MarketRates flags can change in real time, according with
 *  registered symbols and instruments.
 */




string currency;
int GridError;

//+------------------------------------------------------------------+
//|                    MSQL DATABASE PARAMS                                              |
//+------------------------------------------------------------------+



enum DYS_WEEK
  {
   Sunday = 0,
   Monday = 1,
   Tuesday = 2,
   Wednesday,
   Thursday = 4,
   Friday = 5,
   Saturday
  };

enum TIME_LOCK
  {
   closeall,//CLOSE_ALL_TRADES
   closeprofit,//CLOSE_ALL_PROFIT_TRADES
   breakevenprofit//MOVE_PROFIT_TRADES_TO_BREAKEVEN
  };
enum EA_TRADE_MODE
  {
   SELLING_MODE//  SELLING MODE
   ,
   BUYING_MODE, //BUYING MODE,
   STATIC_MODE // STATIC MODE
  }  ;

enum EXECUTION_STYLE
  {
   NONE,
   INSTANT,
//EA Will Execute the price
//instantly at the User
   ADVANCED
//EA Will Execute the trade
//once confirmed through RRR
//or BOS Based on Candle
//closures and retest entries.
  };
enum ZONES_LEVEL //ZONES LEVELS
  {
   LEVEL_1,
   LEVEL_2,
   LEVEL_3
  };

enum ZONES_TYPES
  {

   TEMP_ZONE = 0 //Temp zone
   ,
   MAIN_ZONE = 1 //Main zone

  };



//EA MONITORS TRADE
//ACCORDING TO THE
//TYPE OF ZONE

enum EXECUTION_PLACEMENT
  {

//EA Will Execute the price
   Middle_of_Zone,
   Furthest_away_from_Price_At_the_Zone
   , Closest_to_Price_At_the_Zone
  };
enum TradeSession
  {

   INTRA_DAY = 0, //INTRA DAY
   DAY_TRADING = 1, // DAY TRADING
   SWING_TRADING = 2, //SWING TRADING
   SCALP_TRADING = 3 //SCALPING
  };
enum NO_OF_RE_ENTRIES
  {
   ZERO = 0, ONE = 1, TWO = 2, THREE = 3
  };
enum STRENGTH_TYPES
  {
   STRENGTH_1 = 0, //1 Fractual + 1 Zig Zag,
   STRENGTH_2 = 1, //1 Fractual + 2 or more Zig Zag,
   STRENGTH_3 = 2, //2 Or more Fractual + 2 or more zig zag
   NO_STRENGTH = 3 //NO STRENGTH

  };
enum RISKS_IN_PERCENTAGE
  {
   risk1 = 2 //2 % of account balance
   , risk2 = 25 //25 % of account balance
   , risk3 = 50 //5 % of account balance
   , risk4 = 75 //75 % of account balance
   , risk5 = 100 //100% of account balance
  };
EA_TRADE_MODE ea_trade_mode;//EA TRADE MODE
double Lots;
struct ZONES
  {
   double            start_price;//starting price
   int               slippages;     // value of the permissible slippage-size 1 byte
   char              reserved1;    // skip 1 byte
   short             reserved2;    // skip 2 bytes
   int               reserved4;    // another 4 bytes are skipped. ensure alignment of the boundary 8 bytes
   double            takeprofit;         // values of the price of profit fixing
   double            stoploss;//stop loss
   double            end_price;//ending price
   double            price;//price
   datetime          time;//time
   double            support;//support
   double            resistance;//resistance
   double            HH;//high high
   double            HL;//high low
   double            LH;//low high
   double            LL;//low low
   string            BOS;//Break of structure
   string            RRR;// Retest
   int               Thickness_Size;

   string            symbol;
   string            trend;
   color             zone_color;
   EA_TRADE_MODE     trade_mode;

   TradeSession      session_trade;
   string            types;
   EXECUTION_STYLE   execution_style;

   string            trade_signal;
   ZONES_LEVEL       level;

   double            fractal;
   double            zigzag;
   double            risk_percentage;
   NO_OF_RE_ENTRIES  no_of_re_entries;
   STRENGTH_TYPES    strengh;
  }
;
enum Answer
  {
   yes, no
  };
//------------------------------------------------------------------------------------------------------------
//--------------------------------------------- INTERNAL VARIABLE --------------------------------------------
//--- Vars and arrays
string xmlFileName;
string sData;
string Event[200][7];
string eTitle[10], eCountry[10], eImpact[10], eForecast[10], ePrevious[10];
int eMinutes[10];
datetime eTime[10];
int x0, xx1, xx2, xxf, xp;
int Factor;
//--- Alert
bool FirstAlert;
bool SecondAlert;
datetime AlertTime;
//--- Buffers
double MinuteBuffer[];
double ImpactBuffer[];
//--- time
datetime xmlModifed;
int TimeOfDay;
datetime Midnight;
bool IsEvent;





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CMyBot bot;//Telegram bot (ORDER OF FILE ORGANIZATION MATHER)
input string _dff;//========= USER AUTHENTIFICATION  ==============
input ENUM_LICENSE_TYPE licenseType = LICENSE_DEMO; //LICENSE TYPE
input string licensekey = "12345bhnkasdsf"; //LICENSE KEY
input string username = "noel";//USERNAME
input string account_number = "5476826";//ACCOUNT NUMBER
input string password = "5trcbmh";//PASSWORD
input string server = "OANDA-live"; //SERVER

extern string  dff5;   // "=== Time Management ==="
input  Answer   SET_TRADING_DAYS     = no; // SET TRADING DAYS (yes|no)
input  DYS_WEEK EA_START_DAY        = Sunday; // STARTING DAY
input string EA_START_TIME          = "22:00";//STARTING TIME
input DYS_WEEK EA_STOP_DAY          = Friday;//ENDING DAY
input string EA_STOP_TIME          = "22:00";//ENDING TIME
input TIME_LOCK EA_TIME_LOCK_ACTION = closeall;//LAST TRADE ACTION
input const string _dff1 ;// "============== TELEGRAM BOT ================";


input ENUM_UPDATE_MODE  InpUpdateMode = UPDATE_FAST; //Update Mode
input string            InpToken = "2032573404:AAEfu_tvVukCibiYf8uUdi6NcDpSmbuj3Tg"; //TELEGRAM TOKEN
input string            InpUserNameFilter = ""; //Whitelist Usernames
input string            InpTemplates =   "ADX,RSI,Momentum"; //INDICATOR FOR SCREENSHOT IMAGE


input string channel = "tradeexpert_infos"; // TELEGRAM CHANNEL
input long chatID = -1001648392740; // GROUP or BOT CHAT ID
long ChatID = chatID;

input string symbolss="AUDUSD,USDJPY,USDCAD";//TRADING PAIRS LIST




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
input Answer telegram = yes;//USE TELEGRAM ?(YES|NO)
bool trade0 = false;
bool now = false;


input string dff2 ;//"============== CHART COLORS SETTINGS ================";
input color BearCandle = clrWhite;// Bear candle color
input color BullCandle = clrGreen;// Bull candle color
input color BackGround = clrBlack;
input color ForeGround = clrAquamarine;
input color Bear_Outline = clrRed;// Bear outline color
input color Bull_Outline = clrGreen;// Bull outline color


input string dff3;//"============== NEWS SETTING ================";

input bool DrawLines = true; //Draw News Lines
input int MinAfter = 60; //Minutes after News
input int   MinBefore = 60;
bool Next = false;
input int BeforeNewsStop = 60;
input int AfterNewsStop = 60;
datetime LastUpd = 0;


input string newsfile = "news.xml";
int NomNews;
string str1;
string google_urlx;

input color highc          = clrRed;     // Colour important news
input color mediumc        = clrBlue;    // Colour medium news
input color lowc           = clrLime;    // The color of weak news
input int   Style          = 3;          // Line style
input int   Upd            = 86400;      // Period news updates in seconds
//+------------------------------------------------------------------+
//|                         NEWS                                         |
//+------------------------------------------------------------------+
bool AvoidNews = false;


//-------------------------------------------- EXTERNAL VARIABLE ---------------------------------------------
//------------------------------------------------------------------------------------------------------------
extern bool    ReportActive      = true;                // Report for active chart only (override other inputs)
extern bool    IncludeHigh       = true;                 // Include high
extern bool    IncludeMedium     = true;                 // Include medium
extern bool    IncludeLow        = true;                 // Include low
extern bool    IncludeSpeaks     = true;                 // Include speaks
extern bool    IncludeHolidays   = false;                // Include holidays
extern string  FindKeyword       = "";                   // Find keyword
extern string  IgnoreKeyword     = "";                   // Ignore keyword
extern bool    AllowUpdates      = true;                 // Allow updates
extern int     UpdateHour        = 4;                    // Update every (in hours)
input string   lb_0              = "";                   // ------------------------------------------------------------
input string   lb_1              = "";                   // ------> PANEL SETTINGS
extern bool    ShowPanel         = true;                 // Show panel
extern bool    AllowSubwindow    = false;                // Show Panel in sub window
extern ENUM_BASE_CORNER Corner   = CORNER_LEFT_LOWER;                    // Panel side
extern string  PanelTitle = "@Forex Calendar"; // Panel title
extern color   TitleColor        = C'46,188,46';         // Title color
extern bool    ShowPanelBG       = true;                 // Show panel backgroud
extern color   Pbgc              = C'25,25,25';          // Panel backgroud color
extern color   LowImpactColor    = C'91,192,222';        // Low impact color
extern color   MediumImpactColor = C'255,185,83';        // Medium impact color
extern color   HighImpactColor   = C'217,83,79';         // High impact color
extern color   HolidayColor      = clrOrchid;            // Holidays color
extern color   RemarksColor      = clrGray;              // Remarks color
extern color   PreviousColor     = C'170,170,170';       // Forecast color
extern color   PositiveColor     = C'46,188,46';         // Positive forecast color
extern color   NegativeColor     = clrTomato;            // Negative forecast color
extern bool    ShowVerticalNews  = true;                 // Show vertical lines
extern int     ChartTimeOffset   = -5;                    // Chart time offset (in hours)
extern int     EventDisplay      = 10;                   // Hide event after (in minutes)
input string   lb_2              = "";                   // ------------------------------------------------------------

input string   lb_4              = "";                   // ------------------------------------------------------------
input string   lb_5              = "";                   // ------> INFO SETTINGS
extern bool    ShowInfo          = true;                 // Show Symbol info ( Strength / Bar Time / Spread )
extern color   InfoColor         = C'255,185,83';        // Info color
extern int     InfoFontSize      = 8;                    // Info font size
input string   lb_6              = "";                   // ------------------------------------------------------------
input string   lb_7              = "";                   // ------> NOTIFICATION
input string   lb_8              = "";                   // *Note: Set (-1) to disable the Alert
extern int     Alert1Minutes     = 30;                   // Minutes before first Alert
extern int     Alert2Minutes     = -1;                   // Minutes before second Alert
extern bool    PopupAlerts       = false;                // Popup Alerts
extern bool    SoundAlerts       = true;                 // Sound Alerts
extern string  AlertSoundFile    = "news.wav";           // Sound file name
extern bool    EmailAlerts       = false;                // Send email
extern bool    NotificationAlerts = true;               // Send push notification

input string ;//###############################################

input string dfgg;//"========== TRADES SETTINGS ======================"
input bool garantiesProfit = true; //Use warranty Profit?(false/true)
int LotDigits; //initialized in OnInit


input int MaxSlippage = 3; //slippage, adjusted in OnInit
double MaxTP = 200;
double MinTP = 100;
double stop_loss = 200;

bool crossed[4]; //initialized to true, used in function Cross
input int MaxOpenTrades = 1000;//MAX OPEN ORDERS
input int MaxLongTrades = 500;//MAX LONG ORDERS
input  int MaxShortTrades = 500;//MAX SHORT ORDERS
input int MaxPendingOrders = 500;//MAX PENDING ORDERS
input int MaxLongPendingOrders = 500;//MAX LONG PENDING ORDERS
input int MaxShortPendingOrders = 500;//MAX SHORT PENDING ORDERS
input bool Hedging = true;
int slippage = MaxSlippage; //Slippage (diff between bit and ask)
input int OrderRetry = 5; //# of retries if sending order returns error
input int OrderWait = 5; //# of seconds to wait if sending order returns error
double myPoint; //initialized in OnInit
input string;  //"================ ZONES STRATEGY  SETTING ====================";
input ENUM_TIMEFRAMES  timeframe1 = PERIOD_M5; // First Timeframe
input ENUM_TIMEFRAMES  timeframe2 = PERIOD_H1; //Second TimeFrame

input int MagicNumber = 1241;//MAGIC NUMBER
input bool tradeNews = true;//Trade news?(true/false)
bool Signal = tradeNews;




input string dffg2 ;//"============== ZONES SETTINGS ================";


input string dff4 ;//"========= TEMP ZONE SETTINGS ============";
input int tempzone_Thickness_Size = 30 ; //Zone Thickness Size in(Pts)
input STRENGTH_TYPES tempzone_strength = STRENGTH_2;
input  TradeSession tempzone_session_Trade = INTRA_DAY; // SESSION
input EXECUTION_PLACEMENT tempzone_execution_placement = Middle_of_Zone; //EXECUTION PLACEMENT
input  NO_OF_RE_ENTRIES tempzone_no_of_re_entries = 1; //#NO OF RE-ENTRIES
input RISKS_IN_PERCENTAGE tempzone_risk_percentage = risk2; //RISKS IN % or $
input EXECUTION_STYLE tempzone_execution_style = INSTANT; //EXECUTION STYLE


input string dff6 ;// "========= MAIN ZONE SETTINGS ============"
input int mainzone_Thickness_Size = 15 ; //Zone Thickness Size in(Pts)
input STRENGTH_TYPES mainzone_strength = STRENGTH_2;
input TradeSession mainzone_session_Trade = INTRA_DAY; // SESSION
input EXECUTION_PLACEMENT mainzone_execution_placement = Furthest_away_from_Price_At_the_Zone; //EXECUTION PLACEMENT
input  NO_OF_RE_ENTRIES mainzone_no_of_re_entries = 1; //#NO OF RE-ENTRIES
input RISKS_IN_PERCENTAGE mainzone_risk_percentage = risk2; //RISKS IN % or $
input int BreakEven_Points = 6;//BREAK EVEN POINTS
input EXECUTION_STYLE mainzone_execution_style = INSTANT; //EXECUTION STYLE



string  EQHH = "EQUAL HIGHER HIGH";
string  EQLL = "EQUAL LOWER LOW";
string  BOS = "BREAK OF STRUCUTRE";
bool RESPECT = true;
string  RRR = (RESPECT) ? "REJECT" : "RETEST";


input string t0 = "--- General Parameters for zmq ---";
// if the timer is too small, we might have problems accessing the files from python (mql will write to file every update time).
int MILLISECOND_TIMER = 25;
int numLastMessages = 50;
input string t1 = "If true, it will open charts for bar data symbols, ";
input string t2 = "which reduces the delay on a new bar.";
input bool openChartsForBarData = true;
input bool openChartsForHistoricData = true;
input string t3 = "--- Trading Parameters ---";
int MaximumOrders = MaxOpenTrades;
double MaximumLotSize = 1000000000;
int SlippagePoints = slippage;
int lotSizeDigits = (int)MarketInfo(Symbol(), MODE_LOTSIZE);
int maxOpenOrders = MaxOpenTrades;



input string  ddff3 ;//========= MONEY MANAGEMENT  SYSTEM ============
enum MONEY_MANAGEMENT
  {

   POSITION_SIZE, //POSITION SIZE
   RISK_PERCENT_PER_TRADE,//RISK % PER TRADE,
   MARTINGALE //Martingale / Anti-Martingale

  };

input MONEY_MANAGEMENT moneyManagement = MARTINGALE; //MONEY MANAGEMENT



input string ssd;//POSITION SIZE
input double MM_PositionSizing = 0.01;
input string sdd2;//RISK % PER TRADE
input double Risk = 2;



input string sd;//Martingale/anti martingale
input double MM_Martingale_Start = 0.01;
input double MM_Martingale_ProfitFactor = 1;
input double MM_Martingale_LossFactor = 2;
input bool MM_Martingale_RestartProfit = false;
input bool MM_Martingale_RestartLoss = false;
input int MM_Martingale_RestartLosses = 3;
input int MM_Martingale_RestartProfits = 5;
int maxCommandFiles = 50;
const int maxNumberOfCharts = 2;

long lastMessageMillis = 0;
long lastUpdateMillis = GetTickCount(), lastUpdateOrdersMillis = GetTickCount();

string startIdentifier = "<:";
string endIdentifier = ":>";
string delimiter = "|";
string folderName = "DWX";
string filePathOrders = folderName + "/DWX_Orders.txt";
string filePathMessages = folderName + "/DWX_Messages.txt";
string filePathMarketData = folderName + "/DWX_Market_Data.txt";
string filePathBarData = folderName + "/DWX_Bar_Data.txt";
string filePathHistoricData = folderName + "/DWX_Historic_Data.txt";
string filePathHistoricTrades = folderName + "/DWX_Historic_Trades.txt";
string filePathCommandsPrefix = folderName + "/DWX_Commands_";

string lastOrderText = "", lastMarketDataText = "", lastMessageText = "";
double takeprofit = 100;
double stoploss = 100;
struct MESSAGE
  {
   long              millis;
   string            message;
  };

MESSAGE lastMessages[];

string MarketDataSymbols[];

int commandIDindex = 0;
int commandIDs[];

/**
 * Class definition for an specific instrument: the tuple (symbol,timeframe)
 */
class Instrument
  {
public:

   //--------------------------------------------------------------
   /** Instrument constructor */
                     Instrument() { _symbol = ""; _name = ""; _timeframe = PERIOD_CURRENT; _lastPubTime = 0;}

   //--------------------------------------------------------------
   /** Getters */
   string            symbol()    { return _symbol; }
   ENUM_TIMEFRAMES   timeframe() { return _timeframe; }
   string            name()      { return _name; }
   datetime          getLastPublishTimestamp() { return _lastPubTime; }
   /** Setters */
   void              setLastPublishTimestamp(datetime tmstmp) { _lastPubTime = tmstmp; }

   //--------------------------------------------------------------
   /** Setup instrument with symbol and timeframe descriptions
   *  @param argSymbol Symbol
   *  @param argTimeframe Timeframe
   */
   void              setup(string argSymbol, string argTimeframe)
     {
      _symbol = argSymbol;
      _timeframe = StringToTimeFrame(argTimeframe);
      _name  = _symbol + "_" + argTimeframe;
      _lastPubTime = 0;
      SymbolSelect(_symbol, true);
      if(openChartsForBarData)
        {
         OpenChartIfNotOpen(_symbol, _timeframe);
         Sleep(200);  // sleep to allow time to open the chart and update the data.
        }
     }

   //--------------------------------------------------------------
   /** Get last N MqlRates from this instrument (symbol-timeframe)
   *  @param rates Receives last 'count' rates
   *  @param count Number of requested rates
   *  @return Number of returned rates
   */
   int               GetRates(MqlRates& rates[], int count)
     {
      // ensures that symbol is setup
      if(StringLen(_symbol) > 0)
         return CopyRates(_symbol, _timeframe, 1, count, rates);
      return 0;
     }

protected:
   string            _name;                //!< Instrument descriptive name
   string            _symbol;              //!< Symbol
   ENUM_TIMEFRAMES   _timeframe;  //!< Timeframe
   datetime          _lastPubTime;     //!< Timestamp of the last published OHLC rate. Default = 0 (1 Jan 1970)
  };

// Array of instruments whose rates will be published if Publish_MarketRates = True. It is initialized at OnInit() and
// can be updated through TRACK_RATES request from client peers.
Instrument BarDataInstruments[];

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnnInit()  //ZMQ INIT
  {
   if(!EventSetMillisecondTimer(MILLISECOND_TIMER))
     {
      Print("EventSetMillisecondTimer() returned an error: ", ErrorDescription(GetLastError()));
      return INIT_FAILED;
     }
   LabelCreate(ChartID(), "name", 0, 0, 0, 0, "ZONES", "Arial", 10, clrYellow, 0, 0);
   ObjectSet("name", OBJPROP_YDISTANCE, 10);
   ObjectSetText("name", "ZONES", 10, NULL, clrYellowGreen);
   LabelCreate(ChartID(), "date", 0, 0, 0, 0, "", "Arial", 9, clrYellow, 0, 0);
   ObjectSet("date", OBJPROP_YDISTANCE, 30);
   ObjectSetText("date", "From :" + EA_START_TIME + " / " + (string)EA_START_DAY +   " To :" + (string)EA_STOP_TIME + " / " + (string)EA_STOP_DAY + " CURRENT:" + (string)TimeLocal(), 10, NULL, clrYellowGreen);
   LabelCreate(ChartID(), "session", 0, 0, 0, 0, "session", "Arial", 10, clrYellow, 0, 0);
   ObjectSet("session", OBJPROP_YDISTANCE, 50);
   ObjectSetText("session ", " SESSION :" +  EnumToString(mainzone_session_Trade), 9, NULL, clrYellowGreen);
   ResetFolder();
   ResetCommandIDs();
   ArrayResize(lastMessages, numLastMessages);
   return INIT_SUCCEEDED;
  }
//+-----------------------------------------
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   EventKillTimer();
   ResetFolder();
   OnnDeinit(reason);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double positionSize(string  sym) //position sizing
  {
   double MaxLot = MarketInfo(sym, MODE_MAXLOT);
   double MinLot = MarketInfo(sym, MODE_MINLOT);
   double lots = AccountBalance() / MM_PositionSizing;
   if(lots > MaxLot)
      lots = MaxLot;
   if(lots < MinLot)
      lots = MinLot;
   return(lots);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskPercent(string sym, double SL) //Risk % per trade, SL = relative Stop Loss to calculate risk
  {
   if(SL == 0)
      SL = 1;
   double MaxLot = MarketInfo(sym, MODE_MAXLOT);
   double MinLot = MarketInfo(sym, MODE_MINLOT);
   double tickvalue = MarketInfo(sym, MODE_TICKVALUE);
   double ticksize = MarketInfo(sym, MODE_TICKSIZE);
   double lots = ((Risk * AccountBalance()) / 100 + AccountBalance()) / 1000000;
   if(lots <= 0)
      lots = 0.01;
   if(lots > MaxLot)
      lots = MaxLot;
   if(lots < MinLot)
      lots = MinLot;
   return(lots);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool SelectLastHistoryTrade(string sym)
  {
   int lastOrder = -1;
   int total = OrdersHistoryTotal();
   for(int i = total - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
         continue;
      if(OrderSymbol() == sym && OrderMagicNumber() == MagicNumber)
        {
         lastOrder = i;
         break;
        }
     }
   return(lastOrder >= 0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double BOProfit(int ticket) //Binary Options profit
  {
   int total = OrdersHistoryTotal();
   for(int i = total - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
         continue;
      if(StringSubstr(OrderComment(), 0, 2) == "BO" && StringFind(OrderComment(), "#" + IntegerToString(ticket) + " ") >= 0)
         return OrderProfit();
     }
   return 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool ConsecutivePL(string sym, bool profits, int n)
  {
   int count = 0;
   int total = OrdersHistoryTotal();
   for(int i = total - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
         continue;
      if(OrderSymbol() == sym && OrderMagicNumber() == MagicNumber)
        {
         double orderprofit = OrderProfit();
         double boprofit = BOProfit(OrderTicket());
         if((!profits && orderprofit + boprofit >= 0) || (profits && orderprofit + boprofit <= 0))
            break;
         count++;
        }
     }
   return(count >= n);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Martingale(string sym) //martingale / anti-martingale
  {
   double lots = MM_Martingale_Start;
   double MaxLot = MarketInfo(sym, MODE_MAXLOT);
   double MinLot = MarketInfo(sym, MODE_MINLOT);
   if(SelectLastHistoryTrade(sym))
     {
      double orderprofit = OrderProfit();
      double orderlots = OrderLots();
      double boprofit = BOProfit(OrderTicket());
      if(orderprofit + boprofit > 0 && !MM_Martingale_RestartProfit)
         lots = orderlots * MM_Martingale_ProfitFactor;
      else
         if(orderprofit + boprofit < 0 && !MM_Martingale_RestartLoss)
            lots = orderlots * MM_Martingale_LossFactor;
         else
            if(orderprofit + boprofit == 0)
               lots = orderlots;
     }
   if(ConsecutivePL(sym, false, MM_Martingale_RestartLosses))
      lots = MM_Martingale_Start;
   if(ConsecutivePL(sym, true, MM_Martingale_RestartProfits))
      lots = MM_Martingale_Start;
   if(lots > MaxLot)
      lots = MaxLot;
   if(lots < MinLot)
      lots = MinLot;
   return(lots);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double  getLotSize(string sym, MONEY_MANAGEMENT moneyManagement0, double sl)
  {
   double lot = 0.01;
   switch(moneyManagement0)
     {
      case POSITION_SIZE:
         lot = positionSize(sym);
         break;
      case RISK_PERCENT_PER_TRADE:
         lot = RiskPercent(sym, sl);
         break;
      case MARTINGALE :
         lot = Martingale(sym);
         break;
      default :
         lot = RiskPercent(sym, sl);
         break;
     }
   return lot;
  }
//+------------------------------------------------------------------+
//| Expert timer function                                            |
//+------------------------------------------------------------------+
void OnTimer()
  {
// update prices regularly in case there was no tick within X milliseconds (for non-chart symbols).
   if(GetTickCount() >= lastUpdateMillis + MILLISECOND_TIMER)
     {
      OnnTimer();//Calling server timer
      OnTimer3();
     }
  }

//+------------------------------------------------------------------+
//| Expert tick function                                            |
//+------------------------------------------------------------------+
void OnTick()
  {
   /*
      Use this OnTick() function to send market data to subscribed client.
   */
   lastUpdateMillis = GetTickCount();
   NewsInfos();
   CheckCommands();
   CheckOpenOrders();
   CheckMarketData();
   CheckBarData();
   OnnTick();
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckCommands()
  {
   for(int i = 0; i < maxCommandFiles; i++)
     {
      string filePath = filePathCommandsPrefix + IntegerToString(i) + ".txt";
      if(!FileIsExist(filePath))
         return;
      int handle = FileOpen(filePath, FILE_READ | FILE_TXT); // FILE_COMMON |
      Print(filePath, " | handle: ", handle);
      if(handle == -1)
         return;
      if(handle == 0)
         return;
      string text = "";
      while(!FileIsEnding(handle))
         text += FileReadString(handle);
      FileClose(handle);
      for(int j = 0; j < 10; j++)
         if(FileDelete(filePath))
            break;
      // make sure that the file content is complete.
      int length = StringLen(text);
      if(StringSubstr(text, 0, 2) != startIdentifier)
        {
         SendError("WRONG_FORMAT_START_IDENTIFIER", "Start identifier not found for command: " + text);
         return;
        }
      if(StringSubstr(text, length - 2, 2) != endIdentifier)
        {
         SendError("WRONG_FORMAT_END_IDENTIFIER", "End identifier not found for command: " + text);
         return;
        }
      text = StringSubstr(text, 2, length - 4);
      ushort uSep = StringGetCharacter(delimiter, 0);
      string data[];
      int splits = StringSplit(text, uSep, data);
      if(splits != 3)
        {
         SendError("WRONG_FORMAT_COMMAND", "Wrong format for command: " + text);
         return;
        }
      int commandID = (int)data[0];
      string command = data[1];
      string content = data[2];
      //Print(StringFormat("commandID: %d, command: %s, content: %s ", commandID, command, content));
      // dont check commandID for the reset command because else it could get blocked if only the python/java/dotnet side restarts, but not the mql side.
      if(command != "RESET_COMMAND_IDS" && CommandIDfound(commandID))
        {
         Print(StringFormat("Not executing command because ID already exists. commandID: %d, command: %s, content: %s ", commandID, command, content));
         return;
        }
      commandIDs[commandIDindex] = commandID;
      commandIDindex = (commandIDindex + 1) % ArraySize(commandIDs);
      if(command == "OPEN_ORDER")
        {
         OpenOrder(content);
        }
      else
         if(command == "CLOSE_ORDER")
           {
            CloseOrder(content);
           }
         else
            if(command == "CLOSE_ALL_ORDERS")
              {
               CloseAllOrders();
              }
            else
               if(command == "CLOSE_ORDERS_BY_SYMBOL")
                 {
                  CloseOrdersBySymbol(content);
                 }
               else
                  if(command == "CLOSE_ORDERS_BY_MAGIC")
                    {
                     CloseOrdersByMagic(content);
                    }
                  else
                     if(command == "MODIFY_ORDER")
                       {
                        //ModifyOrder()
                       }
                     else
                        if(command == "SUBSCRIBE_SYMBOLS")
                          {
                           SubscribeSymbols(content);
                          }
                        else
                           if(command == "SUBSCRIBE_SYMBOLS_BAR_DATA")
                             {
                              SubscribeSymbolsBarData(content);
                             }
                           else
                              if(command == "GET_HISTORIC_TRADES")
                                {
                                 GetHistoricTrades(content);
                                }
                              else
                                 if(command == "GET_HISTORIC_DATA")
                                   {
                                    GetHistoricData(content);
                                   }
                                 else
                                    if(command == "RESET_COMMAND_IDS")
                                      {
                                       Print("Resetting stored command IDs.");
                                       ResetCommandIDs();
                                      }
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrder(string orderStr)
  {
   string sep = ",";
   ushort uSep = StringGetCharacter(sep, 0);
   string data[];
   int splits = StringSplit(orderStr, uSep, data);
   if(ArraySize(data) != 9)
     {
      SendError("OPEN_ORDER_WRONG_FORMAT", "Wrong format for OPEN_ORDER command: " + orderStr);
      return;
     }
   int numOrders = NumOrders();
   if(numOrders == MaximumOrders && OrdersTotal() == MaximumOrders)
     {
      SendError("OPEN_ORDER_MAXIMUM_NUMBER", StringFormat("Number of orders (%d) larger than or equal to MaximumOrders (%d).", numOrders, MaximumOrders));
      return;
     }
   string symbol = data[0];
   int digits = (int)MarketInfo(symbol, MODE_DIGITS);
   int orderType = StringToOrderType(data[1]);
   double lots = NormalizeDouble(StringToDouble(data[2]), lotSizeDigits);
   double price = NormalizeDouble(StringToDouble(data[3]), digits);
   double stopLoss = NormalizeDouble(StringToDouble(data[4]), digits);
   double takeProfit = NormalizeDouble(StringToDouble(data[5]), digits);
   int magic = (int)StringToInteger(data[6]);
   string comment = data[7];
   datetime expiration = (datetime)StringToInteger(data[8]);
   if(price == 0 && ((orderType == OP_BUY) || (orderType == OP_BUYSTOP)  || (orderType == OP_BUYLIMIT)))
      price = MarketInfo(symbol, MODE_ASK);
   if(price == 0 && ((orderType == OP_SELL) || (orderType == OP_SELLLIMIT) || (orderType == OP_SELLSTOP)))
      price = MarketInfo(symbol, MODE_BID);
   if(orderType == -1)
     {
      SendError("OPEN_ORDER_TYPE", StringFormat("Order type could not be parsed: %f (%f)", orderType, data[1]));
      return;
     }
   if(lots < MarketInfo(symbol, MODE_MINLOT) || lots > MarketInfo(symbol, MODE_MAXLOT))
     {
      SendError("OPEN_ORDER_LOTSIZE_OUT_OF_RANGE", StringFormat("Lot size out of range (min: %f, max: %f): %f", MarketInfo(symbol, MODE_MINLOT), MarketInfo(symbol, MODE_MAXLOT), lots));
      return;
     }
   if(lots > MaximumLotSize)
     {
      SendError("OPEN_ORDER_LOTSIZE_TOO_LARGE", StringFormat("Lot size (%.2f) larger than MaximumLotSize (%.2f).", lots, MaximumLotSize));
      return;
     }
   if(price == 0)
     {
      SendError("OPEN_ORDER_PRICE_ZERO", "Price is zero: " + orderStr);
      return;
     }
   int ticket = OrderSend(symbol, orderType, lots, price, SlippagePoints,
                          stopLoss, takeProfit, comment, magic, expiration);
   if(ticket >= 0)
     {
      SendInfo("Successfully sent order " + IntegerToString(ticket) + ": " + symbol + ", " + OrderTypeToString(orderType) + ", " + DoubleToString(lots, lotSizeDigits) + ", " + DoubleToString(price, digits));
     }
   else
     {
      SendError("OPEN_ORDER", "Could not open order: " + ErrorDescription(GetLastError()));
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int modifyOrder(string sym, double bid, double ask)
  {
   for(int index = OrdersTotal(); index > 0; index--)
     {
      if(OrderSelect(index, SELECT_BY_TICKET, MODE_TRADES) && (OrderType() == 0 || OrderType() == 2 || OrderType() == 4) && OrderSymbol() == sym)
         index = OrderModify(index, ask, NormalizeDouble(ask - (stoploss * (MarketInfo(sym, MODE_POINT))), ((int)MarketInfo(sym, MODE_DIGITS))),
                             NormalizeDouble(ask + (takeprofit * (MarketInfo(sym, MODE_POINT))), ((int)MarketInfo(sym, MODE_DIGITS))), 0, clrLemonChiffon);
      else
         if(OrderSelect(index, SELECT_BY_TICKET, MODE_TRADES) && (OrderType() == 1 || OrderType() == 3 || OrderType() == 5) && OrderSymbol() == sym)
            index =  OrderModify(index, bid, NormalizeDouble(bid + (stoploss * (MarketInfo(sym, MODE_POINT))), ((int)MarketInfo(sym, MODE_DIGITS))),
                                 NormalizeDouble(bid - (takeprofit * (MarketInfo(sym, MODE_POINT))), ((int)MarketInfo(sym, MODE_DIGITS))), 0, clrLightCyan);
     }
   return 0;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseOrder(string orderStr)
  {
   string sep = ",";
   ushort uSep = StringGetCharacter(sep, 0);
   string data[];
   int splits = StringSplit(orderStr, uSep, data);
   if(ArraySize(data) != 2)
     {
      SendError("CLOSE_ORDER_WRONG_FORMAT", "Wrong format for CLOSE_ORDER command: " + orderStr);
      return;
     }
   int ticket = (int)StringToInteger(data[0]);
   double lots = NormalizeDouble(StringToDouble(data[1]), lotSizeDigits);
   if(!OrderSelect(ticket, SELECT_BY_TICKET))
     {
      SendError("CLOSE_ORDER_SELECT_TICKET", "Could not select order with ticket: " + IntegerToString(ticket));
      return;
     }
   bool res = false;
   if(OrderType() == OP_BUY || OrderType() == OP_SELL)
     {
      if(lots == 0)
         lots = OrderLots();
      res = OrderClose(ticket, lots, OrderClosePrice(), SlippagePoints);
     }
   else
     {
      res = OrderDelete(ticket);
     }
   if(res)
     {
      SendInfo("Successfully closed order: " + IntegerToString(ticket) + ", " + OrderSymbol() + ", " + DoubleToString(lots, lotSizeDigits));
     }
   else
     {
      SendError("CLOSE_ORDER_TICKET", "Could not close position " + IntegerToString(ticket) + ": " + ErrorDescription(GetLastError()));
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllOrders()
  {
   int closed = 0, errors = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS))
         continue;
      if(OrderType() == OP_BUY || OrderType() == OP_SELL)
        {
         bool res = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), SlippagePoints);
         if(res)
            closed++;
         else
            errors++;
        }
      else
         if(OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP)
           {
            bool res = OrderDelete(OrderTicket());
            if(res)
               closed++;
            else
               errors++;
           }
     }
   if(closed == 0 && errors == 0)
      SendInfo("No orders to close.");
   if(errors > 0)
      SendError("CLOSE_ORDER_ALL", "Error during closing of " + IntegerToString(errors) + " orders.");
   else
      SendInfo("Successfully closed " + IntegerToString(closed) + " orders.");
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseOrdersBySymbol(string symbol)
  {
   int closed = 0, errors = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS) || OrderSymbol() != symbol)
         continue;
      if(OrderType() == OP_BUY || OrderType() == OP_SELL)
        {
         bool res = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), SlippagePoints);
         if(res)
            closed++;
         else
            errors++;
        }
      else
         if(OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP)
           {
            bool res = OrderDelete(OrderTicket());
            if(res)
               closed++;
            else
               errors++;
           }
     }
   if(closed == 0 && errors == 0)
      SendInfo("No orders to close with symbol " + symbol + ".");
   else
      if(errors > 0)
         SendError("CLOSE_ORDER_SYMBOL", "Error during closing of " + IntegerToString(errors) + " orders with symbol " + symbol + ".");
      else
         SendInfo("Successfully closed " + IntegerToString(closed) + " orders with symbol " + symbol + ".");
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseOrdersByMagic(string magicStr)
  {
   int magic = (int)StringToInteger(magicStr);
   int closed = 0, errors = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS) || OrderMagicNumber() != magic)
         continue;
      if(OrderType() == OP_BUY || OrderType() == OP_SELL)
        {
         bool res = OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), SlippagePoints);
         if(res)
            closed++;
         else
            errors++;
        }
      else
         if(OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT
            || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP)
           {
            bool res = OrderDelete(OrderTicket());
            if(res)
               closed++;
            else
               errors++;
           }
     }
   if(closed == 0 && errors == 0)
      SendInfo("No orders to close with magic " + IntegerToString(magic) + ".");
   else
      if(errors > 0)
         SendError("CLOSE_ORDER_MAGIC", "Error during closing of " + IntegerToString(errors) + " orders with magic " + IntegerToString(magic) + ".");
      else
         SendInfo("Successfully closed " + IntegerToString(closed) + " orders with magic " + IntegerToString(magic) + ".");
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int NumOrders()
  {
   int n = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS))
         continue;
      if(OrderType() == OP_BUY || OrderType() == OP_SELL
         || OrderType() == OP_BUYLIMIT || OrderType() == OP_SELLLIMIT
         || OrderType() == OP_BUYSTOP || OrderType() == OP_SELLSTOP)
        {
         n++;
        }
     }
   return n;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SubscribeSymbols(string symbolsStr)
  {
   string sep = ",";
   ushort uSep = StringGetCharacter(sep, 0);
   string data[];
   int splits = StringSplit(symbolsStr, uSep, data);
   string successSymbols = "", errorSymbols = "";
   if(ArraySize(data) == 0)
     {
      ArrayResize(MarketDataSymbols, 0);
      SendInfo("Unsubscribed from all tick data because of empty symbol list.");
      return;
     }
   for(int i = 0; i < ArraySize(data); i++)
     {
      if(SymbolSelect(data[i], true))
        {
         ArrayResize(MarketDataSymbols, i + 1);
         MarketDataSymbols[i] = data[i];
         successSymbols += data[i] + ", ";
        }
      else
        {
         errorSymbols += data[i] + ", ";
        }
     }
   if(StringLen(errorSymbols) > 0)
     {
      SendError("SUBSCRIBE_SYMBOL", "Could not subscribe to symbols: " + StringSubstr(errorSymbols, 0, StringLen(errorSymbols) - 2));
     }
   if(StringLen(successSymbols) > 0)
     {
      SendInfo("Successfully subscribed to: " + StringSubstr(successSymbols, 0, StringLen(successSymbols) - 2));
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SubscribeSymbolsBarData(string dataStr)
  {
   string sep = ",";
   ushort uSep = StringGetCharacter(sep, 0);
   string data[];
   int splits = StringSplit(dataStr, uSep, data);
   if(ArraySize(data) == 0)
     {
      ArrayResize(BarDataInstruments, 0);
      SendInfo("Unsubscribed from all bar data because of empty symbol list.");
      return;
     }
   if(ArraySize(data) < 2 || ArraySize(data) % 2 != 0)
     {
      SendError("BAR_DATA_WRONG_FORMAT", "Wrong format to subscribe to bar data: " + dataStr);
      return;
     }
// Format: SYMBOL_1,TIMEFRAME_1,SYMBOL_2,TIMEFRAME_2,...,SYMBOL_N,TIMEFRAME_N
   string errorSymbols = "";
   int numInstruments = ArraySize(data) / 2;
   for(int s = 0; s < numInstruments; s++)
     {
      if(SymbolSelect(data[2 * s], true))
        {
         ArrayResize(BarDataInstruments, s + 1);
         BarDataInstruments[s].setup(data[2 * s], data[(2 * s) + 1]);
        }
      else
        {
         errorSymbols += "'" + data[2 * s] + "', ";
        }
     }
   if(StringLen(errorSymbols) > 0)
      errorSymbols = "[" + StringSubstr(errorSymbols, 0, StringLen(errorSymbols) - 2) + "]";
   if(StringLen(errorSymbols) == 0)
     {
      SendInfo("Successfully subscribed to bar data: " + dataStr);
      CheckBarData();
     }
   else
     {
      SendError("SUBSCRIBE_BAR_DATA", "Could not subscribe to bar data for: " + errorSymbols);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetHistoricData(string dataStr)
  {
   string sep = ",";
   ushort uSep = StringGetCharacter(sep, 0);
   string data[];
   int splits = StringSplit(dataStr, uSep, data);
   if(ArraySize(data) != 4)
     {
      SendError("HISTORIC_DATA_WRONG_FORMAT", "Wrong format for GET_HISTORIC_DATA command: " + dataStr);
      return;
     }
   string symbol = data[0];
   ENUM_TIMEFRAMES timeFrame = StringToTimeFrame(data[1]);
   datetime dateStart = (datetime)StringToInteger(data[2]);
   datetime dateEnd = (datetime)StringToInteger(data[3]);
   if(StringLen(symbol) == 0)
     {
      SendError("HISTORIC_DATA_SYMBOL", "Could not read symbol: " + dataStr);
      return;
     }
   if(!SymbolSelect(symbol, true))
     {
      SendError("HISTORIC_DATA_SELECT_SYMBOL", "Could not select symbol " + symbol + " in market watch. Error: " + ErrorDescription(GetLastError()));
     }
   if(openChartsForHistoricData)
     {
      // if just opnened sleep to give MT4 some time to fetch the data.
      if(OpenChartIfNotOpen(symbol, timeFrame))
         Sleep(200);
     }
   MqlRates rates_array[];
// Get prices
   int rates_count = 0;
// Handling ERR_HISTORY_WILL_UPDATED (4066) and ERR_NO_HISTORY_DATA (4073) errors.
// For non-chart symbols and time frames MT4 often needs a few requests until the data is available.
// But even after 10 requests it can happen that it is not available. So it is best to have the charts open.
   for(int i = 0; i < 10; i++)
     {
      // if (numBars > 0)
      //   rates_count = CopyRates(symbol, timeFrame, startPos, numBars, rates_array);
      rates_count = CopyRates(symbol, timeFrame, dateStart, dateEnd, rates_array);
      int errorCode = GetLastError();
      // Print("errorCode: ", errorCode);
      if(rates_count > 0 || (errorCode != 4066 && errorCode != 4073))
         break;
      Sleep(200);
     }
   if(rates_count <= 0)
     {
      SendError("HISTORIC_DATA", "Could not get historic data for " + symbol + "_" + data[1] + ": " + ErrorDescription(GetLastError()));
      return;
     }
   bool first = true;
   string text = "{\"" + symbol + "_" + TimeFrameToString(timeFrame) + "\": {";
   for(int i = 0; i < rates_count; i++)
     {
      if(first)
        {
         double daysDifference = ((double)MathAbs(rates_array[i].time - dateStart)) / (24 * 60 * 60);
         if((timeFrame == PERIOD_MN1 && daysDifference > 33) || (timeFrame == PERIOD_W1 && daysDifference > 10) || (timeFrame < PERIOD_W1 && daysDifference > 3))
           {
            SendInfo(StringFormat("The difference between requested start date and returned start date is relatively large (%.1f days). Maybe the data is not available on MetaTrader.", daysDifference));
           }
         Print(dateStart, " | ", rates_array[i].time, " | ", daysDifference);
        }
      else
        {
         text += ", ";
        }
      // maybe use integer instead of time string? IntegerToString(rates_array[i].time)
      text += StringFormat("\"%s\": {\"open\": %.5f, \"high\": %.5f, \"low\": %.5f, \"close\": %.5f, \"tick_volume\": %.5f}",
                           TimeToString(rates_array[i].time),
                           rates_array[i].open,
                           rates_array[i].high,
                           rates_array[i].low,
                           rates_array[i].close,
                           rates_array[i].tick_volume);
      first = false;
     }
   text += "}}";
   for(int i = 0; i < 5; i++)
     {
      if(WriteToFile(filePathHistoricData, text))
         break;
      Sleep(100);
     }
   SendInfo(StringFormat("Successfully read historic data for %s_%s.", symbol, data[1]));
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetHistoricTrades(string dataStr)
  {
   int lookbackDays = (int)StringToInteger(dataStr);
   if(lookbackDays <= 0)
     {
      SendError("HISTORIC_TRADES", "Lookback days smaller or equal to zero: " + dataStr);
      return;
     }
   bool first = true;
   string text = "{";
   for(int i = OrdersHistoryTotal() - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
         continue;
      if(OrderOpenTime() < TimeCurrent() - lookbackDays * (24 * 60 * 60))
         continue;
      if(!first)
         text += ", ";
      else
         first = false;
      text += StringFormat("\"%d\": {\"magic\": %d, \"symbol\": \"%s\", \"lots\": %.2f, \"type\": \"%s\", \"open_time\": \"%s\", \"close_time\": \"%s\", \"open_price\": %.5f, \"close_price\": %.5f, \"SL\": %.5f, \"TP\": %.5f, \"pnl\": %.2f, \"commission\": %.2f, \"swap\": %.2f, \"comment\": \"%s\"}",
                           OrderTicket(),
                           OrderMagicNumber(),
                           OrderSymbol(),
                           OrderLots(),
                           OrderTypeToString(OrderType()),
                           TimeToString(OrderOpenTime(), TIME_DATE | TIME_SECONDS),
                           TimeToString(OrderCloseTime(), TIME_DATE | TIME_SECONDS),
                           OrderOpenPrice(),
                           OrderClosePrice(),
                           OrderStopLoss(),
                           OrderTakeProfit(),
                           OrderProfit(),
                           OrderCommission(),
                           OrderSwap(),
                           OrderComment());
     }
   text += "}";
   for(int i = 0; i < 5; i++)
     {
      if(WriteToFile(filePathHistoricTrades, text))
         break;
      Sleep(100);
     }
   SendInfo("Successfully read historic trades.");
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckMarketData()
  {
   bool first = true;
   string text = "{";
   for(int i = 0; i < ArraySize(MarketDataSymbols); i++)
     {
      MqlTick lastTick;
      if(SymbolInfoTick(MarketDataSymbols[i], lastTick))
        {
         if(!first)
            text += ", ";
         text += StringFormat("\"%s\": {\"bid\": %.5f, \"ask\": %.5f, \"tick_value\": %.5f}",
                              MarketDataSymbols[i],
                              lastTick.bid,
                              lastTick.ask,
                              MarketInfo(MarketDataSymbols[i], MODE_TICKVALUE));
         first = false;
        }
      else
        {
         SendError("GET_BID_ASK", "Could not get bid/ask for " + MarketDataSymbols[i] + ". Last error: " + ErrorDescription(GetLastError()));
        }
     }
   text += "}";
// only write to file if there was a change.
   if(text == lastMarketDataText)
      return;
   if(WriteToFile(filePathMarketData, text))
     {
      lastMarketDataText = text;
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckBarData()
  {
// Python clients can also subscribe to a rates feed for each tracked instrument
   bool newData = false;
   string text = "{";
   for(int s = 0; s < ArraySize(BarDataInstruments); s++)
     {
      MqlRates curr_rate[];
      int count = BarDataInstruments[s].GetRates(curr_rate, 1);
      // if last rate is returned and its timestamp is greater than the last published...
      if(count > 0 && curr_rate[0].time > BarDataInstruments[s].getLastPublishTimestamp())
        {
         string rates = StringFormat("\"%s\": {\"time\": \"%s\", \"open\": %f, \"high\": %f, \"low\": %f, \"close\": %f, \"tick_volume\":%d}, ",
                                     BarDataInstruments[s].name(),
                                     TimeToString(curr_rate[0].time),
                                     curr_rate[0].open,
                                     curr_rate[0].high,
                                     curr_rate[0].low,
                                     curr_rate[0].close,
                                     curr_rate[0].tick_volume);
         text += rates;
         newData = true;
         // updates the timestamp
         BarDataInstruments[s].setLastPublishTimestamp(curr_rate[0].time);
        }
     }
   if(!newData)
      return;
   text = StringSubstr(text, 0, StringLen(text) - 2) + "}";
   for(int i = 0; i < 5; i++)
     {
      if(WriteToFile(filePathBarData, text))
         break;
      Sleep(100);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_TIMEFRAMES StringToTimeFrame(string tf)
  {
// Standard timeframes
   if(tf == "M1")
      return PERIOD_M1;
   if(tf == "M5")
      return PERIOD_M5;
   if(tf == "M15")
      return PERIOD_M15;
   if(tf == "M30")
      return PERIOD_M30;
   if(tf == "H1")
      return PERIOD_H1;
   if(tf == "H4")
      return PERIOD_H4;
   if(tf == "D1")
      return PERIOD_D1;
   if(tf == "W1")
      return PERIOD_W1;
   if(tf == "MN1")
      return PERIOD_MN1;
   return -1;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string TimeFrameToString(ENUM_TIMEFRAMES tf)
  {
// Standard timeframes
   switch(tf)
     {
      case PERIOD_M1:
         return "M1";
      case PERIOD_M5:
         return "M5";
      case PERIOD_M15:
         return "M15";
      case PERIOD_M30:
         return "M30";
      case PERIOD_H1:
         return "H1";
      case PERIOD_H4:
         return "H4";
      case PERIOD_D1:
         return "D1";
      case PERIOD_W1:
         return "W1";
      case PERIOD_MN1:
         return "MN1";
      default:
         return "UNKNOWN";
     }
  }


// counts the number of orders with a given magic number. currently not used.
int NumOpenOrdersWithMagic(int _magic)
  {
   int n = 0;
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(OrderSelect(i, SELECT_BY_POS) == true && OrderMagicNumber() == _magic)
        {
         n++;
        }
     }
   return n;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckOpenOrders()
  {
   bool first = true;
   string text = StringFormat("{\"account_info\": {\"name\": \"%s\", \"number\": %d, \"currency\": \"%s\", \"leverage\": %d, \"free_margin\": %f, \"balance\": %f, \"equity\": %f}, \"orders\": {",
                              AccountName(), AccountNumber(), AccountCurrency(), AccountLeverage(), AccountFreeMargin(), AccountBalance(), AccountEquity());
   for(int i = OrdersTotal() - 1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS))
         continue;
      if(!first)
         text += ", ";
      text += StringFormat("\"%d\": {\"magic\": %d, \"symbol\": \"%s\", \"lots\": %.2f, \"type\": \"%s\", \"open_price\": %.5f, \"open_time\": \"%s\", \"SL\": %.5f, \"TP\": %.5f, \"pnl\": %.2f, \"commission\": %.2f, \"swap\": %.2f, \"comment\": \"%s\"}",
                           OrderTicket(),
                           OrderMagicNumber(),
                           OrderSymbol(),
                           OrderLots(),
                           OrderTypeToString(OrderType()),
                           OrderOpenPrice(),
                           TimeToString(OrderOpenTime(), TIME_DATE | TIME_SECONDS),
                           OrderStopLoss(),
                           OrderTakeProfit(),
                           OrderProfit(),
                           OrderCommission(),
                           OrderSwap(),
                           OrderComment());
      first = false;
     }
   text += "}}";
// if there are open positions, it will almost always be different because of open profit/loss.
// update at least once per second in case there was a problem during writing.
   if(text == lastOrderText && GetTickCount() < lastUpdateOrdersMillis + 1000)
      return;
   if(WriteToFile(filePathOrders, text))
     {
      lastUpdateOrdersMillis = GetTickCount();
      lastOrderText = text;
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool WriteToFile(string filePath, string text)
  {
   int handle = FileOpen(filePath, FILE_WRITE | FILE_TXT); // FILE_COMMON |
   if(handle == -1)
      return false;
// even an empty string writes two bytes (line break).
   uint numBytesWritten = FileWrite(handle, text);
   FileClose(handle);
   return numBytesWritten > 0;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SendError(string errorType, string errorDescription)
  {
   Print("ERROR: " + errorType + " | " + errorDescription);
   string message = StringFormat("{\"type\": \"ERROR\", \"time\": \"%s %s\", \"error_type\": \"%s\", \"description\": \"%s\"}",
                                 TimeToString(TimeGMT(), TIME_DATE), TimeToString(TimeGMT(), TIME_SECONDS), errorType, errorDescription);
   SendMessage(message);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SendInfo(string message)
  {
   Print("INFO: " + message);
   message = StringFormat("{\"type\": \"INFO\", \"time\": \"%s %s\", \"message\": \"%s\"}",
                          TimeToString(TimeGMT(), TIME_DATE), TimeToString(TimeGMT(), TIME_SECONDS), message);
   SendMessage(message);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SendMessage(string message)
  {
   for(int i = ArraySize(lastMessages) - 1; i >= 1; i--)
     {
      lastMessages[i] = lastMessages[i - 1];
     }
   lastMessages[0].millis = GetTickCount();
// to make sure that every message has a unique number.
   if(lastMessages[0].millis <= lastMessageMillis)
      lastMessages[0].millis = lastMessageMillis + 1;
   lastMessageMillis = lastMessages[0].millis;
   lastMessages[0].message = message;
   bool first = true;
   string text = "{";
   for(int i = ArraySize(lastMessages) - 1; i >= 0; i--)
     {
      if(StringLen(lastMessages[i].message) == 0)
         continue;
      if(!first)
         text += ", ";
      text += "\"" + IntegerToString(lastMessages[i].millis) + "\": " + lastMessages[i].message;
      first = false;
     }
   text += "}";
   if(text == lastMessageText)
      return;
   if(WriteToFile(filePathMessages, text))
      lastMessageText = text;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool OpenChartIfNotOpen(string symbol, ENUM_TIMEFRAMES timeFrame)
  {
// long currentChartID = ChartID();
   long chartID = ChartFirst();
   for(int i = 0; i < maxNumberOfCharts; i++)
     {
      if(StringLen(ChartSymbol(chartID)) > 0)
        {
         if(ChartSymbol(chartID) == symbol && ChartPeriod(chartID) == timeFrame)
           {
            Print(StringFormat("Chart already open (%s, %s).", symbol, TimeFrameToString(timeFrame)));
            return false;
           }
        }
      chartID = ChartNext(chartID);
      if(chartID == -1)
         break;
     }
// open chart if not yet opened.
   long id = ChartOpen(symbol, timeFrame);
   ChartColorSet(id);
   if(id > 0)
     {
      Print(StringFormat("Chart opened (%s, %s).", symbol, TimeFrameToString(timeFrame)));
      return true;
     }
   else
     {
      SendError("OPEN_CHART", StringFormat("Could not open chart (%s, %s).", symbol, TimeFrameToString(timeFrame)));
      return false;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ResetCommandIDs()
  {
   ArrayResize(commandIDs, 1000);  // save the last 1000 command IDs.
   ArrayFill(commandIDs, 0, ArraySize(commandIDs), -1);  // fill with -1 so that 0 will not be blocked.
   commandIDindex = 0;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CommandIDfound(int id)
  {
   for(int i = 0; i < ArraySize(commandIDs); i++)
      if(id == commandIDs[i])
         return true;
   return false;
  }

// use string so that we can have the same in MT5.
string OrderTypeToString(int orderType)
  {
   if(orderType == OP_BUY)
      return "buy";
   if(orderType == OP_SELL)
      return "sell";
   if(orderType == OP_BUYLIMIT)
      return "buylimit";
   if(orderType == OP_SELLLIMIT)
      return "selllimit";
   if(orderType == OP_BUYSTOP)
      return "buystop";
   if(orderType == OP_SELLSTOP)
      return "sellstop";
   return "unknown";
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int StringToOrderType(string orderTypeStr)
  {
   if(orderTypeStr == "buy")
      return OP_BUY;
   if(orderTypeStr == "sell")
      return OP_SELL;
   if(orderTypeStr == "buylimit")
      return OP_BUYLIMIT;
   if(orderTypeStr == "selllimit")
      return OP_SELLLIMIT;
   if(orderTypeStr == "buystop")
      return OP_BUYSTOP;
   if(orderTypeStr == "sellstop")
      return OP_SELLSTOP;
   return -1;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ResetFolder()
  {
//FolderDelete(folderName);  // does not always work.
   FolderCreate(folderName);
   FileDelete(filePathMarketData);
   FileDelete(filePathBarData);
   FileDelete(filePathHistoricData);
   FileDelete(filePathOrders);
   FileDelete(filePathMessages);
   for(int i = 0; i < maxCommandFiles; i++)
     {
      FileDelete(filePathCommandsPrefix + IntegerToString(i) + ".txt");
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ErrorDescription(int errorCode)
  {
   string errorString;
   switch(errorCode)
     {
      //---- codes returned from trade server
      case 0:
      case 1:
         errorString = "no error";
         break;
      case 2:
         errorString = "common error";
         break;
      case 3:
         errorString = "invalid trade parameters";
         break;
      case 4:
         errorString = "trade server is busy";
         break;
      case 5:
         errorString = "old version of the client terminal";
         break;
      case 6:
         errorString = "no connection with trade server";
         break;
      case 7:
         errorString = "not enough rights";
         break;
      case 8:
         errorString = "too frequent requests";
         break;
      case 9:
         errorString = "malfunctional trade operation (never returned error)";
         break;
      case 64:
         errorString = "account disabled";
         break;
      case 65:
         errorString = "invalid account";
         break;
      case 128:
         errorString = "trade timeout";
         break;
      case 129:
         errorString = "invalid price";
         break;
      case 130:
         errorString = "invalid stops";
         break;
      case 131:
         errorString = "invalid trade volume";
         break;
      case 132:
         errorString = "market is closed";
         break;
      case 133:
         errorString = "trade is disabled";
         break;
      case 134:
         errorString = "not enough money";
         break;
      case 135:
         errorString = "price changed";
         break;
      case 136:
         errorString = "off quotes";
         break;
      case 137:
         errorString = "broker is busy (never returned error)";
         break;
      case 138:
         errorString = "requote";
         break;
      case 139:
         errorString = "order is locked";
         break;
      case 140:
         errorString = "long positions only allowed";
         break;
      case 141:
         errorString = "too many requests";
         break;
      case 145:
         errorString = "modification denied because order too close to market";
         break;
      case 146:
         errorString = "trade context is busy";
         break;
      case 147:
         errorString = "expirations are denied by broker";
         break;
      case 148:
         errorString = "amount of open and pending orders has reached the limit";
         break;
      case 149:
         errorString = "hedging is prohibited";
         break;
      case 150:
         errorString = "prohibited by FIFO rules";
         break;
      //---- mql4 errors
      case 4000:
         errorString = "no error (never generated code)";
         break;
      case 4001:
         errorString = "wrong function pointer";
         break;
      case 4002:
         errorString = "array index is out of range";
         break;
      case 4003:
         errorString = "no memory for function call stack";
         break;
      case 4004:
         errorString = "recursive stack overflow";
         break;
      case 4005:
         errorString = "not enough stack for parameter";
         break;
      case 4006:
         errorString = "no memory for parameter string";
         break;
      case 4007:
         errorString = "no memory for temp string";
         break;
      case 4008:
         errorString = "not initialized string";
         break;
      case 4009:
         errorString = "not initialized string in array";
         break;
      case 4010:
         errorString = "no memory for array\' string";
         break;
      case 4011:
         errorString = "too long string";
         break;
      case 4012:
         errorString = "remainder from zero divide";
         break;
      case 4013:
         errorString = "zero divide";
         break;
      case 4014:
         errorString = "unknown command";
         break;
      case 4015:
         errorString = "wrong jump (never generated error)";
         break;
      case 4016:
         errorString = "not initialized array";
         break;
      case 4017:
         errorString = "dll calls are not allowed";
         break;
      case 4018:
         errorString = "cannot load library";
         break;
      case 4019:
         errorString = "cannot call function";
         break;
      case 4020:
         errorString = "expert function calls are not allowed";
         break;
      case 4021:
         errorString = "not enough memory for temp string returned from function";
         break;
      case 4022:
         errorString = "system is busy (never generated error)";
         break;
      case 4050:
         errorString = "invalid function parameters count";
         break;
      case 4051:
         errorString = "invalid function parameter value";
         break;
      case 4052:
         errorString = "string function internal error";
         break;
      case 4053:
         errorString = "some array error";
         break;
      case 4054:
         errorString = "incorrect series array using";
         break;
      case 4055:
         errorString = "custom indicator error";
         break;
      case 4056:
         errorString = "arrays are incompatible";
         break;
      case 4057:
         errorString = "global variables processing error";
         break;
      case 4058:
         errorString = "global variable not found";
         break;
      case 4059:
         errorString = "function is not allowed in testing mode";
         break;
      case 4060:
         errorString = "function is not confirmed";
         break;
      case 4061:
         errorString = "send mail error";
         break;
      case 4062:
         errorString = "string parameter expected";
         break;
      case 4063:
         errorString = "integer parameter expected";
         break;
      case 4064:
         errorString = "double parameter expected";
         break;
      case 4065:
         errorString = "array as parameter expected";
         break;
      case 4066:
         errorString = "requested history data in update state";
         break;
      case 4099:
         errorString = "end of file";
         break;
      case 4100:
         errorString = "some file error";
         break;
      case 4101:
         errorString = "wrong file name";
         break;
      case 4102:
         errorString = "too many opened files";
         break;
      case 4103:
         errorString = "cannot open file";
         break;
      case 4104:
         errorString = "incompatible access to a file";
         break;
      case 4105:
         errorString = "no order selected";
         break;
      case 4106:
         errorString = "unknown symbol";
         break;
      case 4107:
         errorString = "invalid price parameter for trade function";
         break;
      case 4108:
         errorString = "invalid ticket";
         break;
      case 4109:
         errorString = "trade is not allowed in the expert properties";
         break;
      case 4110:
         errorString = "longs are not allowed in the expert properties";
         break;
      case 4111:
         errorString = "shorts are not allowed in the expert properties";
         break;
      case 4200:
         errorString = "object is already exist";
         break;
      case 4201:
         errorString = "unknown object property";
         break;
      case 4202:
         errorString = "object is not exist";
         break;
      case 4203:
         errorString = "unknown object type";
         break;
      case 4204:
         errorString = "no object name";
         break;
      case 4205:
         errorString = "object coordinates error";
         break;
      case 4206:
         errorString = "no specified subwindow";
         break;
      default:
         errorString = "ErrorCode: " + IntegerToString(errorCode);
     }
   return(errorString);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void printArray(string &arr[])
  {
   if(ArraySize(arr) == 0)
      Print("{}");
   string printStr = "{";
   int i;
   for(i = 0; i < ArraySize(arr); i++)
     {
      if(i == ArraySize(arr) - 1)
         printStr += arr[i];
      else
         printStr += arr[i] + ", ";
     }
   Print(printStr + "}");
  }

//+------------------------------------------------------------------+
//Find if the Market was Up or Down buy=1 or sell=0
//+------------------------------------------------------------------+
int Market(int i)
  {
   int market = 0;
   if(Close[i] > Open[i]) //know what is the market buy or sell
     {
      market = 1; //buy
     }
   else
      if(Close[i] < Open[i])
        {
         market = -1; //sell
        }
   return market;
  }
//+------------------------------------------------------------------+
long VOLUME(int i)
  {
   return Volume[i];
  }
//+------------------------------------------------------------------+
double LOW(int i)
  {
   return Low[i];
  }

//+------------------------------------------------------------------+
//|              GET STRENGTH                                                    |
//+------------------------------------------------------------------+
STRENGTH_TYPES GetStrength(ZONES & zones0)
  {
   STRENGTH_TYPES streng = STRENGTH_3 ;
   int count1 = 0, count2 = 0;
   int i = iBars(zones0.symbol,PERIOD_CURRENT);
   double fr = FRACTALS(1);
   double zig = ZIGZAG(1);
   if(fr >= 1)
     {
      count1++;
     }
   if(fr <= -1)
     {
      count2++;
     }
   if(zig == 1)
     {
      count1++;
     }
   if(zig <= -1)
     {
      count2++;
     }
   if(count1 > count2)
     {
      if(count1 == 1)
         return STRENGTH_1;
      if(count1 == 2)
         return STRENGTH_2;
      if(count1 >= 3)
         return STRENGTH_3;
     }
   if(count1 < count2)
     {
      if(count1 == 1)
         return STRENGTH_1;
      if(count1 == 2)
         return STRENGTH_2;
      if(count1 >= 3)
         return STRENGTH_3;
     }
   return streng;
  }




//+------------------------------------------------------------------+
//|                         FINDING ZONES ON                                       |
//+------------------------------------------------------------------+
bool isCorrectMarketStructure = false;
ZONES TEMP_ZONES, MAIN_ZONE;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GET_ZONES(ZONES & zones)
  {
   double HH[];
   double HL[];
   double LH[];
   double LL[];
//CREATE SESSION
   if(!CreateSession(zones.session_trade))
     {
      LabelCreate(ChartID(), "Info", 0, 123, 10, 0, "NO VALID TRADING SESSION", NULL, 12);
      ObjectSetText("Info", "NO VALID TRADING SESSION", clrWheat);
      return;
     }
   string info = "";
   bool isBuying = false;
   bool isSelling = false;
   string signal = "NONE";
   string sym =   zones.symbol;
   zones.slippages = slippage;
   int ind = 0;
   int bars = ind = Bars;
   ArrayResize(HH, bars, 0);
   ArrayResize(HL, bars, 0);
   ArrayResize(LL, bars, 0);
   ArrayResize(LH, bars, 0);
//Level 1: Identify Market Strucutre & Key points for S&DCalled "Zones"
   int l = 0;
   double LastHigh = 0, LastLow = 0;
   int in = 0;
//DEFINITION TABEL:
//HH = HIGHER HIGH
//LH = LOWER HIGH
//LL = LOWER LOW
//HL = HIGHER LOW
//EQHH = EQUAL HIGHER HIGH
//EQLL = EQUAL LOWER LOW
//BOS = BREAK OF STRUCUTRE RRR = RESPECT, REJECT, RETEST
//Level 3: Identify Buying and Selling Opportinity
   ea_trade_mode = (EA_TRADE_MODE)IS_IT_BUYING_OR_SELLING(zones);
   LabelCreate(ChartID(), "ea_trade_mode", 0, 0, 110);
   ObjectSetText("ea_trade_mode", EnumToString(ea_trade_mode), 12, "Arial", clrGold);
   LabelCreate(ChartID(), "strength", 0, 0, 80);
   ObjectSetText("strength", EnumToString(GetStrength(zones)), 12, "Arial", clrOldLace);
// Invalidation or Validation
   bool Invalidation = false;
   if(!ObjectFind(ChartID(), zones.types))
     {
      info = "NO  " + zones.types + ". ";
     }
   else
     {
      info = "PLACING  " + zones.types + ". ";
      if(zones.types == "tempzones" && isCorrectMarketStructure) //CREATE MAINZONES
        {
         // LOOKING FOR MAINZONES
         CreateZones(Symbol(), "tempzones");
        }
      if(zones.types == "mainzones" && isCorrectMarketStructure) //CREATE MAINZONES
        {
         // LOOKING FOR MAINZONES
         CreateZones(Symbol(), "mainzones");
        }
      CreateZones(Symbol(), "mainzones");
     }
   LabelCreate(ChartID(), "zoneinfo", 0, 0, 150, 0, info, NULL, 10, clrAliceBlue);
   if(ea_trade_mode == BUYING_MODE)
     {
      signal = "BUY";
     }
   else
      if(ea_trade_mode == SELLING_MODE)
        {
         signal = "SELL";
        }
  }

//+------------------------------------------------------------------+
//|                         CreateZones                                         |
//+------------------------------------------------------------------+
ZONES mainzones;
ZONES tempzones;

string ea_state;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawZone(int index, string type, int size, color clr)
  {
   int in = index;
   string zone_type = type;
   if(type == "tempzones")
     {
      ObjectCreate(ChartID(), zone_type, OBJ_HLINE, 0, Time[0], Ask);
      ObjectSet(zone_type, OBJPROP_COLOR, clr);
      ObjectSet(zone_type, OBJPROP_WIDTH, tempzone_Thickness_Size);
      ObjectSet(zone_type, OBJPROP_SELECTABLE, true);
      ObjectSet(zone_type, OBJPROP_TIME2, Time[in]);
      ObjectSet(zone_type, OBJPROP_TIME1, Time[0]);
      ObjectSet(zone_type, OBJPROP_BACK, true);
      ObjectSetString(ChartID(), type, OBJPROP_TEXT, type + " " + EnumToString(tempzones.strengh));
     }
   if(type == "mainzones")
     {
      ObjectCreate(ChartID(), zone_type, OBJ_HLINE, 0, Time[0], Ask);
      ObjectSet(zone_type, OBJPROP_COLOR, clr);
      ObjectSet(zone_type, OBJPROP_WIDTH, mainzone_Thickness_Size);
      ObjectSet(zone_type, OBJPROP_SELECTABLE, true);
      ObjectSetString(ChartID(), type, OBJPROP_TEXT, type + " " + EnumToString(mainzones.strengh));
      ObjectSet(zone_type, OBJPROP_BACK, true);
      ObjectSet(zone_type, OBJPROP_TIME2, Time[in]);
     }
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateZones(string sym, string zone_type)
  {
   double HH[];
   double HL[];
   double LH[];
   double LL[];
   sym =   Symbol();
   int ind = 0;
   int bars = ind = Bars;
   ArrayResize(HH, bars, 0);
   ArrayResize(HL, bars, 0);
   ArrayResize(LL, bars, 0);
   ArrayResize(LH, bars, 0);
   double LastHigh = 0, LastLow = 0;
   int in = 0;
   int index;
   for(index = 0; index < Bars; index++)
     {
      //Bars represent the total number of candle drown on a chart.It 's values can change base on user settings
      if(High[index] > LastHigh)
         LastHigh = High[index] ;
      if(Low[index]  < LastLow)
         LastLow  = Low[index];
      tempzones.start_price = LastLow;
      tempzones.end_price = LastHigh;
      mainzones.start_price = LastLow;
      mainzones.end_price = LastHigh;
      //----
     }
   drawZone(0,
            (zone_type == "tempzones") ? "mainzones" : "tempzones",
            (zone_type == "tempzones") ? mainzone_Thickness_Size : tempzone_Thickness_Size
            ,
            (zone_type == "tempzones") ? clrGray : clrBlue
           );
  }




//----










//SEARCHING FOR  BUYING_OR_SELLING OPPORTUNITIES
//+------------------------------------------------------------------+
//|                 IS_IT_BUYING_OR_SELLING                                    |
//+------------------------------------------------------------------+
string IS_IT_BUYING_OR_SELLING(ZONES &zones)
  {
//  IDENTIFYING MARKET STRUCUTRE.
//THIS DETERMINES IF EA IS IN BUY OR SELL MODE
//IF HH OR LH OR EQHH = BREAK UP + CLOSE = BUYING MODE
//IF HH OR LH OR EQHH = RRR + NO CLOSED BREAK = SELLING MODE
//IF LL OR HL OR EQLL = BREAK DOWN + CLOSE = SELLING MODE
//
//
//
   string ms = "WAITING...";
   int index = Bars - 1;
   double LastHigh = 0, LastLow = 0;
   while(index > 0)
     {
      if(High[index] > LastHigh)
         LastHigh = High[index] ;
      if(Low[index]  < LastLow)
         LastLow  = Low[index];
      string sym = zones.symbol;
      zones.end_price =  LastHigh;
      zones.start_price = LastLow;
      double price = MarketInfo(sym, MODE_ASK);
      long time = iTime(sym, PERIOD_H1, 1);
      int counted_bars = 0;
      if(price >= zones.end_price)//
        {
         //PRICE IS ABOVE ZONE
         //[BUYING MODE|
         //Ea Is looking for Buys as
         //long as 5M and or 1H
         //Candle Closure Body
         if(Close[index] == zones.start_price && Close[index] < zones.end_price
            && Close[ index ] == zones.start_price && Close[index ] < zones.end_price
            && zones.fractal >= 1 && zones.zigzag <= -1
           )//respecting Zone?
            return ms = "BUYING";
        }
      else
         if(price < zones.start_price)
           {
            //
            //PRICE IS BELOW ZONE
            //[SELLING MODE|
            //Ea Is looking for Sells as
            //long as 5M and or 1H
            //Candle Closure Body is
            //respecting Zone
            if(Close[index] > zones.start_price && Close[index] <= zones.end_price   &&
               Close[index ] > zones.start_price && Close[index] <= zones.end_price
               && zones.fractal <= -1 && zones.zigzag >= 1
              )//respecting Zone?
               return ms = "SELLING";
           }
      index--;
     }
   return ms;
  }






datetime ea_start_time = 0;
datetime ea_end_time ;

//+------------------------------------------------------------------+
//|                   CreateSession                                               |
//+------------------------------------------------------------------+
bool CreateSession(TradeSession session)//validate session time for operations
  {
   string msg = "EMPTY";
   int stopwatch = 0;
   datetime sta = TimeLocal();
   datetime end = StringToTime((string)Year() + "." + (string) Month() + "." + (string) Day() + "  " + (string)(Hour()) + " : " + (string)(Minute() + 1));
   int op = FileOpen("DWX/session.csv", FILE_WRITE | FILE_READ | FILE_SHARE_READ | FILE_CSV, ',');
   if(op > 0)
     {
      FileWrite(op, "DATE ", "SESSION", "STARTING TIME", "ENDING TIME");
      FileWrite(op, TimeLocal(), session, sta, end);
      FileSeek(op, 0, SEEK_END);
      FileClose(op);
     }
   else
      printf("CAN'T OPEN SESSION FILE");
   LabelCreate(ChartID(), "session", 0, 0, 166, 0, "N/A", NULL, 12, clrAliceBlue);
   int count = 0;
   switch(session) //Scalp 1 = 1 Min - 60 Min Scalp 2 = 1 Min 90 Min Intraday = 1 Min - 5 Hours Day Trade = 24 Hours Swing trade = Multiple days up to 2 Week
     {
      case INTRA_DAY:
         if(count <= 1)
           {
            end = TimeLocal() + 90;
            FileWrite(op, "DATE ", "SESSION", "STARTING TIME", "ENDING TIME");
            FileSeek(op, 0, SEEK_END);
            FileWrite(op, TimeLocal(), session, sta, end);
           }
         else
           {
            count++;
           }
         if(TimeLocal() < end)
           {
            msg = EnumToString(session) + "  EXP : " + (string)end;
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
            return true;
           }
         else
           {
            msg = EnumToString(session) + " IS OVER ! " + (string)end + " NOT TRADING";
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
            timelockaction();
           }
         break;
      case SCALP_TRADING:
         if(count <= 1)
           {
            end = StringToTime((string)Year() + "." + (string)Month() + "." + (string) Day() + "  " + (string)((Minute() < 30) ? (string)(Hour() - 1) : (string)(Hour() + 1)) + " : " + (string)(Minute() + 30));
            FileWrite(op, "DATE ", "SESSION", "STARTING TIME", "ENDING TIME");
            FileSeek(op, 0, SEEK_END);
            FileWrite(op, TimeLocal(), session, sta, end);
            FileClose(op);
           }
         else
            count ++;
         if(TimeLocal() < end)
           {
            msg = "SCALP 1  "  + EnumToString(session) + "  EXP : " + (string)end;
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
            return true;
           }
         else
           {
            msg = "SCALP 1  SESSION OVER " + " NOT TRADING";
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
           }
         //scalp 2
         if(count == 1)
           {
            end = StringToTime((string)Year() + "." + (string) Month() + "." + (string) Day() + "  " + (string)((Minute() < 30) ? (string)(Hour() + 2) : (string)(Hour() + 1) + " : " + (string)(Minute() + 30)));
            FileWrite(op, "DATE ", "SESSION", "STARTING TIME", "ENDING TIME");
            FileWrite(op, TimeLocal(), session, sta, end);
            FileSeek(op, 0, SEEK_END);
           }
         else
            count ++;
         if((TimeLocal() >= StringToTime((string)Year() + "." + (string) Month() + "." + (string)Day() + "  " + (string)(Hour() + 1) + " : " + (string)Minute()))
            && TimeLocal() < end
           )
           {
            msg = "SCALP 2 "
                  ;
            msg += EnumToString(session) + "  EXP : " + (string)end;
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
            return true;
           }
         else
           {
            msg = "SCALP 2 OVER ";
            msg += EnumToString(session) + "  EXP : " + (string)end;
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
            timelockaction();
           }
         break;
      case DAY_TRADING:
         if(count <= 1)
           {
            end = StringToTime((string)Year() + "." + (string)Month() + "." + (string)(Day() + 1) + "     " + (string)Hour() + " : " + (string)(Minute()));
            FileWrite(op, TimeLocal(), EnumToString(session), sta, end);
            FileClose(op);
           }
         else
            count++;
         if(TimeLocal() < end)
           {
            msg = EnumToString(session) + "  EXP : " + (string)end ;
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
            return true;
           }
         else
           {
            msg = (string)session + "  OVER! " + " NOT TRADING";
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
            timelockaction();
           }
         break;
      case SWING_TRADING :
         end = StringToTime((string)Year() + "." + (string) Month() + "." + (string)(Day() + 1) + "     " + (string)Hour() + " : " + (string)(Minute()));
         if(count == 1)
           {
            end = StringToTime((string)Year() + "." + (string)Month() + "." + (string)((Day() < Day() - 7) ? (Day() - 7) : (Day() + 7)) + "     " + (string)Hour() + " : " + (string)(Minute()));
            FileWrite(op, "DATE ", "SESSION", "STARTING TIME", "ENDING TIME");
            FileWrite(op, TimeLocal(), session, sta, end);
            FileSeek(op, 0, SEEK_END);
           }
         else
            count ++;
         FileClose(op);
         if(TimeLocal() < end)
           {
            msg = EnumToString(session) + "  EXP :" + (string)(datetime) end;
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
            return true;
           }
         else
           {
            msg = EnumToString(session) + "  OVER " + " NOT TRADING";
            LabelCreate(ChartID(), "session", 0, 0, 166, 0, msg, NULL, 12, clrAliceBlue);
           }
      default :
         break;
     }
//---
   return false;
  }


//+------------------------------------------------------------------+
//Find if the Market was Up or Down buy=1 or sell=0
//+------------------------------------------------------------------+
int MARKET(int i, string sym)
  {
   string market = "CONSOLIDATION";
   if(Close[(int)iClose(sym, PERIOD_CURRENT, 0)] > Open[(int)iOpen(sym, PERIOD_CURRENT, i)]) //know what is the market buy or sell
     {
      //market = "BUY"; //buy
      return 1;
     }
   else
      if(Close[(int)iClose(sym, PERIOD_CURRENT, 0)] < Close[(int)iOpen(sym, PERIOD_CURRENT, i)])
        {
         //market = "SELL"; //sell
         return -1;
        }
      else
         return 0;
  }


//FRACTALS
//+------------------------------------------------------------------+
double FRACTALS(int i) //NEW
  {
//
//FRACTUAL INDICATOR
//[MAIN ZONE DETECTION]
//THESE ARE THE ZONES THAT CONFIRM THE MAIN
//HIGHS AND THE MAIN LOWS IN THE MARKET.
//ONCE FOUND IT CAN BE USED TO DETECT THE
//START OF A NEW TREND OR CONTINUATION OF A
//TREND BASED ON HOW PRICE ACTION
//RESPONDS TO THIS ZONE. ONCE DETECTED EA
//WILL DETERMINE TO BUY OR SELL.
   double buy = iFractals(Symbol(), PERIOD_M5, MODE_UPPER, 0);
   double sell = iFractals(Symbol(), PERIOD_H1, MODE_UPPER, i);
   Comment("FRACTAL  SELL  " + (string)sell + " BUY " + (string) buy);
   if(buy != sell)
     {
      if(buy >= 1)
        {
         return buy;
        }
      else
         if(sell <= -1)
           {
            return sell;
           }
     }
   return 0;
  }



//+------------------------------------------------------------------+
input string sdf;//ZIG ZAG     PARAMETERS
//+------------------------------------------------------------------+
input int InpDepth = 12;   // Depth
input int InpDeviation = 5; // Deviation
input int InpBackstep = 3; // Backstep


//+------------------------------------------------------------------+
//|                 ZIGZAG                                                 |
//+------------------------------------------------------------------+
double ZIGZAG(int i) //NEW
  {
//  Idientifies Key points in Market
//Strucutre best in a trending market
//and detecting the start of a reversal in
//the market.
//Once found there will be a "TEMP"
//ZONE ADDED. Market Structure also refered as = Higher Highs, Lower highs, Lower
//Lows, Higher Lows
   double buy = iCustom(Symbol(), PERIOD_M5, "ZigZag", 12, 5, 3, 0, i);
   double sell = iCustom(Symbol(), PERIOD_H1, "ZigZag.ex4", 12, 5, 3, 1, i); //i represent a in direction  shift
   Comment("\n\n\nzigzag buy " + (string)buy + "   sell " + (string)sell);
   if(buy != sell)
     {
      if(buy == 1)
        {
         return buy;
        }
      else
         if(sell == -1)
           {
            return sell;
           }
     }
   return 0;
  }

int   _opened_last_time = 0;
int _closed_last_time = 0;

//-------- SEND REPORT TO TELEGRAM ------------
void SEND_REPORT_TO_TELEGRAM()
  {
//tggggg
   if(true)
     {
      int total = OrdersTotal();
      datetime max_time = 0;
      for(int pos = 0; pos < total; pos++) // Current orders -----------------------
        {
         if(!OrderSelect(pos, SELECT_BY_POS, MODE_TRADES))
            continue;
         if(OrderOpenTime() <= _opened_last_time)
            continue;
         string message = StringFormat(
                             "\n----ZONES  OPEN ORDER----\r\n%s %s lots \r\n%s @ %s \r\nSL - %s\r\nTP - %s\r\n----------------------\r\n\n",
                             order_type(),
                             DoubleToStr(OrderLots(), 2),
                             OrderSymbol(),
                             DoubleToStr(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)),
                             DoubleToStr(OrderStopLoss(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)),
                             DoubleToStr(OrderTakeProfit(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS))
                          );
         if(StringLen(message) > 0)
           {
            bot.SendMessage(chatID, message) ;
            //error handling
           }
         max_time = MathMax(max_time, OrderOpenTime());
        }
      _opened_last_time = (int) MathMax(max_time, _opened_last_time);
     }
   if(true)
     {
      datetime max_time = 0;
      double day_profit = 0;
      bool is_closed = false;
      int total = OrdersHistoryTotal();
      for(int pos = 0; pos < total; pos++) // History orders-----------------------
        {
         if(TimeDay(TimeLocal()) == TimeDay(OrderCloseTime()) && OrderCloseTime() > iTime(OrderSymbol(), PERIOD_CURRENT, 1))
           {
            day_profit += order_pips();
           }
         if(!OrderSelect(pos, SELECT_BY_TICKET, MODE_HISTORY))
            continue;
         if(OrderCloseTime() <= _closed_last_time)
            continue;
         printf(TimeToStr(OrderCloseTime()));
         is_closed = true;
         string   message = StringFormat("\n----ZONES EA CLOSE PROFIT----\r\n%s %s lots\r\n%s @ %s\r\nSL - %s \r\nTP - %s \r\nProfit: %s PIPS \r\n--------------------------------\r\n\n",
                                         order_type(),
                                         DoubleToStr(OrderLots(), 2),
                                         OrderSymbol(),
                                         DoubleToStr(OrderOpenPrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)),
                                         DoubleToStr(OrderClosePrice(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)),
                                         DoubleToStr(OrderTakeProfit(), (int)MarketInfo(OrderSymbol(), MODE_DIGITS)),
                                         DoubleToStr(order_pips() / 10, 1)
                                        );
         if(StringLen(message) > 0)
           {
            if(is_closed)
               message += StringFormat("Total Profit today: %s PIPS", DoubleToStr(day_profit / 10, 1));
            printf(message);
            bot.SendMessage(chatID, message);
           }
         max_time = MathMax(max_time, OrderCloseTime());
        }
      _closed_last_time = (int)MathMax(max_time, _closed_last_time);
     }
  }



//+------------------------------------------------------------------+
//|                       ORDER PIPS                                           |
//+------------------------------------------------------------------+
double order_pips()
  {
   if(OrderType() == OP_BUY)
     {
      return (OrderClosePrice() - OrderOpenPrice()) / (MathMax(MarketInfo(OrderSymbol(), MODE_POINT), 0.00000001));
     }
   else
     {
      return (OrderOpenPrice() - OrderClosePrice()) / (MathMax(MarketInfo(OrderSymbol(), MODE_POINT), 0.00000001));
     }
  }
//+------------------------------------------------------------------+
//|                     ORDER TYPE                                             |
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
//|                      MM_Size                                            |
//+------------------------------------------------------------------+
double MM_Size(ZONES &zone) //Risk % per trade, SL = relative Stop Loss to calculate risk
  {
   string sym = zone.symbol;
   double MaxLot = MarketInfo(sym, MODE_MAXLOT);
   double MinLot = MarketInfo(sym, MODE_MINLOT);
   double tickvalue = MarketInfo(sym, MODE_TICKVALUE);
   double ticksize = MarketInfo(sym, MODE_TICKSIZE);
   double lots = zone.risk_percentage * 1.0 / 100 * AccountBalance();
   if(lots > MaxLot)
      lots = MaxLot;
   if(lots < MinLot)
      lots = MinLot;
//---
   return(lots);
  }



//+------------------------------------------------------------------+
//|                     CHART COLOR SET                                             |
//+------------------------------------------------------------------+
bool ChartColorSet(long id)//set chart colors
  {
   ChartSetInteger(id, CHART_COLOR_ASK, BearCandle);
   ChartSetInteger(id, CHART_COLOR_BID, clrOrange);
   ChartSetInteger(id, CHART_COLOR_VOLUME, clrAqua);
   int keyboard = 12;
   ChartSetInteger(id, CHART_KEYBOARD_CONTROL, keyboard);
   ChartSetInteger(id, CHART_COLOR_CHART_DOWN, 231);
   ChartSetInteger(id, CHART_COLOR_CANDLE_BEAR, BearCandle);
   ChartSetInteger(id, CHART_COLOR_CANDLE_BULL, BullCandle);
   ChartSetInteger(id, CHART_COLOR_CHART_DOWN, Bear_Outline);
   ChartSetInteger(id, CHART_COLOR_CHART_UP, Bull_Outline);
   ChartSetInteger(id, CHART_SHOW_GRID, 0);
   ChartSetInteger(id, CHART_SHOW_PERIOD_SEP, false);
   ChartSetInteger(id, CHART_MODE, 1);
   ChartSetInteger(id, CHART_SHIFT, 1);
   ChartSetInteger(id, CHART_SHOW_ASK_LINE, 1);
   ChartSetInteger(id, CHART_COLOR_BACKGROUND, BackGround);
   ChartSetInteger(id, CHART_COLOR_FOREGROUND, ForeGround);
   return(true);
  }



void CloseTradesAtPL(string sym, double PL) //close all trades if total P/L >= profit (positive) or total P/L <= loss (negative)
  {
   double totalPL = TotalOpenProfit(0, sym);
   if((PL > 0 && totalPL >= PL) || (PL < 0 && totalPL <= PL))
     {
      myOrderClose(sym, OP_BUY, 100, "");
      myOrderClose(sym, OP_SELL, 100, "");
     }
  }

//+------------------------------------------------------------------+
//|                CROSS                                                   |
//+------------------------------------------------------------------+
bool Cross(int i, bool condition) //returns true if "condition" is true and was false in the previous call
  {
   bool ret = condition && !crossed[i];
   crossed[i] = condition;
   return(ret);
  }

//+------------------------------------------------------------------+
//|            MY ALERT                                                      |
//+------------------------------------------------------------------+
void myAlert(string type, string xmessage)
  {
   if(type == "print")
      Print(xmessage);
   else
      if(type == "error")
        {
         Print(type + " | ZONES_EA @ " + Symbol() + "," + IntegerToString(Period()) + " | " + xmessage);
        }
      else
         if(type == "order")
           {
           }
         else
            if(type == "modify")
              {
              }
  }

//+------------------------------------------------------------------+
//|             TRADES COUNT                                                     |
//+------------------------------------------------------------------+
int TradesCount(int type) //returns # of open trades for order type, current symbol and magic number
  {
   int result = 0;
   int total = OrdersTotal();
   for(int i = 0; i < total; i++)
     {
      if(OrderSelect(i, SELECT_BY_TICKET, MODE_TRADES) == false)
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != Symbol() || OrderType() != type)
         continue;
      result++;
     }
   return(result);
  }

//+------------------------------------------------------------------+
//|                     TotalOpenProfit                                             |
//+------------------------------------------------------------------+
double TotalOpenProfit(int direction, string sym)
  {
   double result = 0;
   int total = OrdersTotal();
   for(int i = 0; i < total; i++)
     {
      if(!OrderSelect(i, SELECT_BY_TICKET, MODE_TRADES))
         continue;
      if(OrderSymbol() != sym || OrderMagicNumber() != MagicNumber)
         continue;
      if((direction < 0 && OrderType() == OP_BUY) || (direction > 0 && OrderType() == OP_SELL))
         continue;
      result += OrderProfit();
     }
   return(result);
  }

//+------------------------------------------------------------------+
//|                        myOrderSend                                          |
//+------------------------------------------------------------------+
int myOrderSend(string sym, int type, double price, double volume, string ordername, double SL, double TP) //send order, return ticket ("price" is irrelevant for market orders)
  {
   if(!IsTradeAllowed())
      return(-1);
   int ticket = -1;
   int retries = 0;
   int err = 0;
   int long_trades = TradesCount(OP_BUY);
   int short_trades = TradesCount(OP_SELL);
   int long_pending = TradesCount(OP_BUYLIMIT) + TradesCount(OP_BUYSTOP);
   int short_pending = TradesCount(OP_SELLLIMIT) + TradesCount(OP_SELLSTOP);
   string ordername_ = ordername;
   if(ordername != "")
      ordername_ = "(" + ordername + ")";
//test Hedging
   if(!Hedging && ((type % 2 == 0 && short_trades + short_pending > 0) || (type % 2 == 1 && long_trades + long_pending > 0)))
     {
      myAlert("print", "Order" + ordername_ + " not sent, hedging not allowed");
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
      myAlert("print", "Order" + ordername_ + " not sent, maximum reached");
      return(-1);
     }
//prepare to send order
   while(IsTradeContextBusy())
      Sleep(100);
   RefreshRates();
   if(type == OP_BUY || type == OP_BUYSTOP || type == OP_BUYLIMIT)
     {
      price = NormalizeDouble(MarketInfo(sym, MODE_ASK), (int)MarketInfo(sym, MODE_DIGITS));
     }
   else
      if(type == OP_SELL  || type == OP_SELLLIMIT || type == OP_SELLSTOP)
        {
         price = NormalizeDouble(MarketInfo(sym, MODE_BID), (int)MarketInfo(sym, MODE_DIGITS));
        }
      else
         if(price < 0) //invalid price for pending order
           {
            myAlert("order", "Order" + ordername_ + " not sent, invalid price for pending order");
            return(-1);
           }
   int clr = (type % 2 == 1) ? clrRed : clrBlue;
   while(ticket < 0 && retries < OrderRetry + 1)
     {
      double lot = volume;
      if(OrdersTotal() == 1 && OrderOpenPrice() < MarketInfo(sym, MODE_ASK))
        {
         lot *= volume * 2 ;
        }
      if(OrdersTotal() > 1 && OrderOpenPrice() > MarketInfo(sym, MODE_ASK))
        {
         lot = volume * 2 ;
        }
      else
         if(OrdersTotal() == 2 && OrderOpenPrice() < MarketInfo(sym, MODE_ASK))
           {
            lot = volume * 3 ;
           }
         else
            if(OrdersTotal() > 2 && OrderOpenPrice() < MarketInfo(sym, MODE_ASK))
              {
               lot =  OrderLots() * 3;
              }
            else
               lot = volume;
      printf("LOT " + (string)lot);
      if(lot <= 0)
         return 0;
      ticket = OrderSend(Symbol(), type, NormalizeDouble(lot, (int)MarketInfo(Symbol(), MODE_LOTSIZE)),
                         price,
                         slippage,
                         NormalizeDouble(SL, (int)(MarketInfo(Symbol(), MODE_DIGITS))),
                         NormalizeDouble(TP, (int)(MarketInfo(Symbol(), MODE_DIGITS))),
                         ordername,
                         MagicNumber, 0, clr);
      if(ticket < 0)
        {
         err = GetLastError();
         myAlert("print", "OrderSend" + ordername_ + " error #" + IntegerToString(err) + " " + ErrorDescription(err));
         Sleep(OrderWait * 1000);
        }
      retries++;
     }
   if(ticket < 0)
     {
      myAlert("error", "OrderSend" + ordername_ + " failed " + IntegerToString(OrderRetry + 1) + " times; error #" + IntegerToString(err) + " " + ErrorDescription(err));
      printf("OrderSend" + ordername_ + " failed " + IntegerToString(OrderRetry + 1) + " times; error #" + IntegerToString(err) + " " + ErrorDescription(err));
      return(-1);
     }
   string typestr[6] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop"};
   myAlert("order", "OrderSend " + ordername_ + ": " + typestr[type] + "   " + sym
          );
   printf("OrderSend " + ordername_ + ": " + typestr[type] + "   " + sym);
   return(ticket);
  }

//+------------------------------------------------------------------+
//|               ModifyOrders                                                   |
//+------------------------------------------------------------------+
int myOrderModify(string sym, int ticket, double SL, double TP) //modify SL and TP (absolute price), zero targets do not modify
  {
   if(!IsTradeAllowed())
      return(-1);
   bool success = false;
   int retries = 0;
   int err = 0;
   SL = 0;
   if(TP < 0)
      TP = 0;
//prepare to select order
   while(IsTradeContextBusy())
      Sleep(100);
   if(!OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES))
     {
      err = GetLastError();
      myAlert("error", "OrderSelect failed; error #" + IntegerToString(err) + " " + ErrorDescription(err));
      return(-1);
     }
//prepare to modify order
   while(IsTradeContextBusy())
      Sleep(100);
   RefreshRates();
   double price = MarketInfo(sym, MODE_ASK);
   if(CompareDoubles(SL, 0))
      SL = OrderStopLoss(); //not to modify
   if(CompareDoubles(TP, 0))
      TP = OrderTakeProfit(); //not to modify
   if(CompareDoubles(SL, OrderStopLoss()) && CompareDoubles(TP, OrderTakeProfit()))
      return(0); //nothing to do
   while(!success && retries < OrderRetry + 1)
     {
      success = OrderModify(ticket, price,
                            NormalizeDouble(SL,
                                            (int)MarketInfo(sym, MODE_DIGITS)),
                            NormalizeDouble(TP, (int)MarketInfo(sym, MODE_DIGITS)),
                            OrderExpiration(),
                            CLR_NONE);
      if(!success)
        {
         err = GetLastError();
         myAlert("print", "OrderModify error #" + IntegerToString(err) + " " + ErrorDescription(err));
         Sleep(OrderWait * 1000);
        }
      retries++;
     }
   if(!success)
     {
      myAlert("error", "OrderModify failed " + IntegerToString(OrderRetry + 1) + " times; error #" + IntegerToString(err) + " " + ErrorDescription(err));
      return(-1);
     }
   string alertstr = "Order modified: ticket=" + IntegerToString(ticket);
   if(!CompareDoubles(SL, 0))
      alertstr = alertstr + " SL=" + DoubleToString(SL);
   if(!CompareDoubles(TP, 0))
      alertstr = alertstr + " TP=" + DoubleToString(TP);
   myAlert("modify", alertstr);
   return(0);
  }
//+------------------------------------------------------------------+
//|                        MY ORDER CLOSE                                          |
//+------------------------------------------------------------------+
void myOrderClose(string sym, int type, double volumepercent, string ordername) //close open orders for current symbol, magic number and "type" (OP_BUY or OP_SELL)
  {
   if(!IsTradeAllowed())
      return;
   if(type > 1)
     {
      myAlert("error", "Invalid type in myOrderClose");
      return;
     }
   bool success = false;
   int retries = 0;
   int err = 0;
   string ordername_ = ordername;
   if(ordername != "")
      ordername_ = "(" + ordername + ")";
   int total = OrdersTotal();
   ulong orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy())
         Sleep(100);
      if(OrderSelect(i, SELECT_BY_POS) == false)
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != sym || OrderType() != type)
         continue;
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(OrderSelect((int)orderList[i][1], SELECT_BY_POS) == FALSE)
         continue;
      while(IsTradeContextBusy())
         Sleep(100);
      RefreshRates();
      double price = (type == OP_SELL) ? MarketInfo(sym, MODE_ASK) : MarketInfo(sym, MODE_BID);
      double volume = NormalizeDouble(OrderLots() * volumepercent * 1.0 / 100, LotDigits);
      if(NormalizeDouble(volume, LotDigits) == 0)
         continue;
      success = false;
      retries = 0;
      while(!success && retries < OrderRetry + 1)
        {
         success = OrderClose(OrderTicket(), volume, NormalizeDouble(price, (int)MarketInfo(sym, MODE_DIGITS)), MaxSlippage, clrWhite);
         if(!success)
           {
            err = GetLastError();
            myAlert("print", "OrderClose" + ordername_ + " failed; error #" + IntegerToString(err) + " " + ErrorDescription(err));
            Sleep(OrderWait * 1000);
           }
         retries++;
        }
      if(!success)
        {
         myAlert("error", "OrderClose" + ordername_ + " failed " + IntegerToString(OrderRetry + 1) + " times; error #" + IntegerToString(err) + " " + ErrorDescription(err));
         return;
        }
     }
   string typestr[6] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop"};
   if(success)
      myAlert("order", "Orders closed" + ordername_ + ": " + typestr[type] + " " + sym + " Magic #" + IntegerToString(MagicNumber));
  }


//+------------------------------------------------------------------+
//|                     DrawLine horizontal                                             |
//+------------------------------------------------------------------+
void DrawLine(string sym, string objname, double price, int count, int start_index, color clr) //creates or modifies existing object if necessary
  {
   if((price < 0) && ObjectFind(objname) >= 0)
     {
      ObjectDelete(objname);
     }
   else
      if(ObjectFind(objname) >= 0 && ObjectType(objname) == OBJ_TREND)
        {
         ObjectSet(objname, OBJPROP_TIME1, Time[0]);
         ObjectSet(objname, OBJPROP_PRICE1, price);
         ObjectSet(objname, OBJPROP_TIME2, Time[count]);
         ObjectSet(objname, OBJPROP_PRICE2, price);
        }
      else
        {
         ObjectCreate(objname, OBJ_TREND, 0, Time[0], Ask);
         ObjectSet(objname, OBJPROP_RAY, false);
         ObjectSet(objname, OBJPROP_COLOR, clr);
         ObjectSet(objname, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet(objname, OBJPROP_WIDTH, 5);
        }
  }


//+------------------------------------------------------------------+
//|                            Support                                      |
//+------------------------------------------------------------------+
double Support(string sym, int time_interval, bool fixed_tod, int hh, int mm, bool draw, int shift)
  {
   int start_index = shift;
   int count = time_interval / 60 / Period();
   if(fixed_tod)
     {
      datetime start_time;
      if(shift == 0)
         start_time = 0;
      else
         start_time = Time[shift - 1];
      datetime dt = StringToTime(StringConcatenate(TimeToString(start_time, TIME_DATE), " ", hh, ":", mm)); //closest time hh:mm
      if(dt > start_time)
         dt -= 86400; //go 24 hours back
      int dt_index = iBarShift(NULL, 0, dt, true);
      datetime dt2 = dt;
      while(dt_index < 0 && dt > Time[Bars - 1 - count]) //bar not found => look a few days back
        {
         dt -= 86400; //go 24 hours back
         dt_index = iBarShift(NULL, 0, dt, true);
        }
      if(dt_index < 0)  //still not found => find nearest bar
         dt_index = iBarShift(NULL, 0, dt2, false);
      start_index = dt_index + 1; //bar after S/R opens at dt
     }
   double ret = Low[iLowest(NULL, PERIOD_CURRENT, MODE_LOW, count, 0)];
   if(draw)
      DrawLine(NULL, "Support", ret, count, 0, clrGreen);
   return(ret);
  }

//+------------------------------------------------------------------+
//|                       Resistance                                           |
//+------------------------------------------------------------------+
double Resistance(string sym, int time_interval, bool fixed_tod, int hh, int mm, bool draw, int shift)
  {
   int start_index = shift;
   int count = time_interval / 60 / Period();
   if(fixed_tod)
     {
      datetime start_time;
      if(shift == 0)
         start_time = TimeLocal();
      else
         start_time = Time[shift - 1];
      datetime dt = StringToTime(StringConcatenate(TimeToString(start_time, TIME_DATE), " ", hh, ":", mm)); //closest time hh:mm
      if(dt > start_time)
         dt -= 86400; //go 24 hours back
      int dt_index = iBarShift(NULL, 0, dt, true);
      datetime dt2 = dt;
      while(dt_index < 0 && dt > Time[Bars - 1 - count]) //bar not found => look a few days back
        {
         dt -= 86400; //go 24 hours back
         dt_index = iBarShift(NULL, 0, dt, true);
        }
      if(dt_index < 0)  //still not found => find nearest bar
         dt_index = iBarShift(NULL, 0, dt2, false);
      start_index = dt_index + 1; //bar after S/R opens at dt
     }
   double ret = High[iHighest(NULL, 0, MODE_HIGH, count, 1)];
   if(draw)
      DrawLine(NULL, "Resistance", ret, count, 0, clrRed);
   return(ret);
  }


//+------------------------------------------------------------------+
//|                         TRAILING                                         |
//+------------------------------------------------------------------+
void TrailingStopBE(string sym, int type, double profit, double add) //set Stop Loss to open price if in profit
  {
   int total = OrdersTotal();
   profit = NormalizeDouble(profit, (int)MarketInfo(sym, MODE_DIGITS));
   for(int i = total - 1; i >= 0; i--)
     {
      while(IsTradeContextBusy())
         Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS))
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != sym || OrderType() != type)
         continue;
      RefreshRates();
      if((type == OP_BUY && MarketInfo(sym, MODE_ASK) > OrderOpenPrice() + profit && (NormalizeDouble(OrderStopLoss(), (int)MarketInfo(sym, MODE_DIGITS)) <= 0 || OrderOpenPrice() > OrderStopLoss()))
         || (type == OP_SELL && MarketInfo(sym, MODE_ASK) < OrderOpenPrice() - profit && (NormalizeDouble(OrderStopLoss(), (int)MarketInfo(sym, MODE_DIGITS)) <= 0 || OrderOpenPrice() < OrderStopLoss())))
         myOrderModify(sym, i, OrderOpenPrice() + add, 0);
     }
  }
int Trend = 0;



int anchorx = 0;

int init_error = 0;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string getTrend()
  {
   string ATrend = "CONSOLIDATION";
   int k = Bars - 1;
   LabelCreate(ChartID(), "trend", 0, 0, 0, 0, "trend", "Bold", 12, clrYellow);
   ObjectSet("trend", OBJPROP_TEXT, 0);
   while(k > 0)
     {
      if(MARKET(k, _Symbol) == -1)
         ATrend = "DOWN"  ;
      else
         if(MARKET(k, _Symbol) == 1)
            ATrend = "UP" ;
         else
            ATrend = "CONSOLIDATION  ON " + _Symbol;
      k--;
     }
   ObjectSet("trend", OBJPROP_YDISTANCE, 190);
   ObjectSetText("trend", ATrend, 12, NULL, clrAliceBlue);
   return ATrend;
  }

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Authentication(username, password, (string)account_number, licenseType, licensekey, AccountServer());
//+------------------------------------------------------------------+
//|            SET CHART COLOR                                                      |
//+------------------------------------------------------------------+
   ChartColorSet(ChartID());
//---
   string session = "";
   int op = FileOpen("DWX/session.csv", FILE_WRITE | FILE_READ | FILE_SHARE_READ | FILE_CSV, ',');
   if(op > 0)
     {
      string sta = (string)EA_START_DAY + "|" + EA_START_TIME;
      string end = (string)EA_STOP_DAY + "|" + EA_STOP_TIME;
      FileWrite(op, "DATE ", "SESSION", "STARTING TIME", "ENDING TIME");
      FileWrite(op, TimeLocal(), session, sta, end);
      FileSeek(op, 0, SEEK_END);
      FileClose(op);
     }
   else
      printf("CAN'T OPEN SESSION FILE");
   op = FileOpen("DWX/setting.csv", FILE_WRITE | FILE_READ | FILE_SHARE_READ | FILE_CSV, ',');
   if(op > 0)
     {
      string sta = (string)EA_START_DAY + "|" + EA_START_TIME;
      string end = (string)EA_STOP_DAY + "|" + EA_STOP_TIME;
      FileWrite(op, "stoploss ", "takeprofit", "moneymanagement", "Risk",   "MM_Martingale_Start",
                "MM_Martingale_ProfitFactor", "MM_Martingale_LossFactor",
                "MM_Martingale_RestartProfit",
                "MM_Martingale_RestartLoss",
                "MM_Martingale_RestartLosses",
                "MM_Martingale_RestartProfits", "Position_size","order_type");
      FileWrite(op, stoploss, takeprofit, EnumToString(moneyManagement), Risk, MM_Martingale_Start,
                MM_Martingale_ProfitFactor, MM_Martingale_LossFactor,
                MM_Martingale_RestartProfit,
                MM_Martingale_RestartLoss,
                MM_Martingale_RestartLosses,
                MM_Martingale_RestartProfits, MM_PositionSizing,ORDER_TYPE);
      FileSeek(op, 0, SEEK_END);
      FileClose(op);
     }
   else
      printf("CAN'T OPEN SESSION FILE");
//+------------------------------------------------------------------+
//|                TIME MANAGEMENT                                                 |
//+------------------------------------------------------------------+
   if(TradeDays() == false  &&   SET_TRADING_DAYS == yes)
     {
      timelockaction();
      Comment("Trading Session  End ! Please wait for new  session.");
      MessageBox("Trading end!\nPlease wait for next session! ", "TIME MANAGEMENT", 1);
      return 0;
     }
//---NEWS indicator buffers mapping
   SetIndexBuffer(0, MinuteBuffer);
   SetIndexBuffer(1, ImpactBuffer);
   SetIndexStyle(0, DRAW_NONE);
   SetIndexStyle(1, DRAW_NONE);
//--- 0 value will not be displayed
   SetIndexEmptyValue(0, 0.0);
   SetIndexEmptyValue(1, 0.0);
//--- 4/5 digit brokers
   if(Digits % 2 == 1)
      Factor = 10;
   else
      Factor = 1;
//--- get today time
   TimeOfDay = (int)TimeLocal() % 86400;
   Midnight = TimeLocal() - TimeOfDay;
//--- set xml file name ffcal_week_this (fixed name)
   xmlFileName = newsfile;
//--- checks the existence of the file.
   if(!FileIsExist(xmlFileName))
     {
      xmlDownload();
      xmlRead();
     }
//--- else just read it
   else
      xmlRead();
//--- get last modification time
   xmlModifed = (datetime)FileGetInteger(xmlFileName, FILE_MODIFY_DATE, false);
//--- check for updates
   if(AllowUpdates)
     {
      if(xmlModifed < TimeLocal() - (UpdateHour * 3600))
        {
         Print(INAME + ": xml file is out of date");
         xmlUpdate();
        }
      //--- set timer to update old xml file every x hours
      else
         EventSetTimer(UpdateHour * 3600);
     }
//--- set panel corner
   switch(Corner)
     {
      case CORNER_LEFT_UPPER:
         x0 = 5;
         xx1 = 165;
         xx2 = 15;
         xxf = 340;
         xp = 390;
         anchorx = 0;
         break;
      case CORNER_RIGHT_UPPER:
         x0 = 455;
         xx1 = 265;
         xx2 = 440;
         xxf = 110;
         xp = 60;
         anchorx = 0;
         break;
      case CORNER_RIGHT_LOWER:
         x0 = 455;
         xx1 = 265;
         xx2 = 440;
         xxf = 110;
         xp = 60;
         anchorx = 2;
         break;
      case CORNER_LEFT_LOWER:
         x0 = 5;
         xx1 = 165;
         xx2 = 15;
         xxf = 340;
         xp = 390;
         anchorx = 2;
         break;
     }
//initialize myPoint
   myPoint = Point();
   if(Digits() == 5 || Digits() == 3)
     {
      myPoint *= 10;
      slippage *= 10;
     }
//initialize LotDigits
   double LotStep = MarketInfo(Symbol(), MODE_LOTSTEP);
   if(NormalizeDouble(LotStep, 3) == round(LotStep))
      LotDigits = 0;
   else
      if(NormalizeDouble(10 * LotStep, 3) == round(10 * LotStep))
         LotDigits = 1;
      else
         if(NormalizeDouble(100 * LotStep, 3) == round(100 * LotStep))
            LotDigits = 2;
         else
            LotDigits = 3;
   double MaxTPx = MaxTP * myPoint;
   double MinTPx = MinTP * myPoint;
// for single account licence you can remove the slash followed by a star
   string broker = AccountInfoString(ACCOUNT_COMPANY);
   long account = AccountInfoInteger(ACCOUNT_LOGIN);
   string ser = (string)AccountInfoInteger(ACCOUNT_TRADE_EXPERT);
   CComment comment;
   int timer_ms = -1;
   if(telegram == yes)
     {
      //--- set language
      bot.Language(InpLanguage);
      //--- set token
      init_error = bot.Token(InpToken);
      //--- set filter
      bot.UserNameFilter(InpUserNameFilter);
      //--- set templates
      bot.Templates(InpTemplates);
      datetime time = __DATETIME__  ;
      //--- set timer
      switch(InpUpdateMode)
        {
         case UPDATE_FAST:
            timer_ms = 1000;
            break;
         case UPDATE_NORMAL:
            timer_ms = 2000;
            break;
         case UPDATE_SLOW:
            timer_ms = 3000;
            break;
         default:
            timer_ms = 1000;
            break;
        }
     }  ;
   EventSetTimer(timer_ms);
   OnnInit();
   OnTimer();//timer
   return(INIT_SUCCEEDED);
  }




//+------------------------------------------------------------------+
//|DisplayNews                            |
//+------------------------------------------------------------------+
int NewsInfos()
  {
   string sym = Symbol();
   const int rates_total = 0;
   int prev_calculated = 7;
   datetime time[];
   double open[];
   double high[];
   double low[];
   double close[];
   long tick_volume[];
   long volume[];
   int spread[];
//--
//--- BY AUTHORS WITH SOME MODIFICATIONS
//--- define the XML Tags, Vars
   string sTags[7] = {"<title>", "<country>", "<date><![CDATA[", "<time><![CDATA[", "<impact><![CDATA[", "<forecast><![CDATA[", "<previous><![CDATA["};
   string eTags[7] = {"</title>", "</country>", "]]></date>", "]]></time>", "]]></impact>", "]]></forecast>", "]]></previous>"};
   int index = 0;
   int next = -1;
   int BoEvent = 0, begin = 0, end = 0;
   string myEvent = "";
//--- Minutes calculation
   datetime EventTime = 7;
   int EventMinute = 7;
//--- split the currencies into the two parts
   string MainSymbol = StringSubstr(sym, 0, 3);
   string SecondSymbol = StringSubstr(sym, 3, 3);
//--- loop to get the data from xml tags
   while(true)
     {
      BoEvent = StringFind(sData, "<event>", BoEvent);
      if(BoEvent == -1)
         break;
      BoEvent += 7;
      next = StringFind(sData, "</event>", BoEvent);
      if(next == -1)
         break;
      myEvent = StringSubstr(sData, BoEvent, next - BoEvent);
      BoEvent = next;
      begin = 0;
      for(int i = 0; i < 7; i++)
        {
         Event[index][i] = "";
         next = StringFind(myEvent, sTags[i], begin);
         //--- Within this event, if tag not found, then it must be missing; skip it
         if(next == -1)
            continue;
         else
           {
            //--- We must have found the sTag okay...
            //--- Advance past the start tag
            begin = next + StringLen(sTags[i]);
            end = StringFind(myEvent, eTags[i], begin);
            //---Find start of end tag and Get data between start and end tag
            if(end > begin && end != -1)
               Event[index][i] = StringSubstr(myEvent, begin, end - begin);
           }
        }
      //--- filters that define whether we want to skip this particular currencies or events
      if(ReportActive && MainSymbol != Event[index][COUNTRY] && SecondSymbol != Event[index][COUNTRY])
         continue;
      if(!IsCurrency(Event[index][COUNTRY]))
         continue;
      if(!IncludeHigh && Event[index][IMPACT] == "High")
         continue;
      if(!IncludeMedium && Event[index][IMPACT] == "Medium")
         continue;
      if(!IncludeLow && Event[index][IMPACT] == "Low")
         continue;
      if(!IncludeSpeaks && StringFind(Event[index][TITLE], "Speaks") != -1)
         continue;
      if(!IncludeHolidays && Event[index][IMPACT] == "Holiday")
         continue;
      if(Event[index][TIME] == "All Day" ||
         Event[index][TIME] == "Tentative" ||
         Event[index][TIME] == "")
         continue;
      if(FindKeyword != "")
        {
         if(StringFind(Event[index][TITLE], FindKeyword) == -1)
            continue;
        }
      if(IgnoreKeyword != "")
        {
         if(StringFind(Event[index][TITLE], IgnoreKeyword) != -1)
            continue;
        }
      //--- sometimes they forget to remove the tags :)
      if(StringFind(Event[index][TITLE], "<![CDATA[") != -1)
         StringReplace(Event[index][TITLE], "<![CDATA[", "");
      if(StringFind(Event[index][TITLE], "]]>") != -1)
         StringReplace(Event[index][TITLE], "]]>", "");
      if(StringFind(Event[index][TITLE], "]]>") != -1)
         StringReplace(Event[index][TITLE], "]]>", "");
      //---
      if(StringFind(Event[index][FORECAST], "&lt;") != -1)
         StringReplace(Event[index][FORECAST], "&lt;", "");
      if(StringFind(Event[index][PREVIOUS], "&lt;") != -1)
         StringReplace(Event[index][PREVIOUS], "&lt;", "");
      //--- set some values (dashes) if empty
      if(Event[index][FORECAST] == "")
         Event[index][FORECAST] = "---";
      if(Event[index][PREVIOUS] == "")
         Event[index][PREVIOUS] = "---";
      //--- Convert Event time to MT4 time
      EventTime = datetime(MakeDateTime(Event[index][DATE], Event[index][TIME]));
      //--- calculate how many minutes before the event (may be negative)
      EventMinute = int(EventTime - TimeGMT()) / 60;
      //--- only Alert once
      if(EventMinute == 0 && AlertTime != EventTime)
        {
         FirstAlert = false;
         SecondAlert = false;
         AlertTime = EventTime;
        }
      //--- Remove the event after x minutes
      if(EventMinute + EventDisplay < 0)
         continue;
      //--- Set buffers
      ArrayResize(MinuteBuffer, index + 23, 0);
      ArrayResize(ImpactBuffer, index + 23, 0);
      MinuteBuffer[index] = EventMinute;
      ImpactBuffer[index] = ImpactToNumber(Event[index][IMPACT]);
      index++
      ;
     }
//--- loop to set arrays/buffers that uses to draw objects and alert
   for(int i = 0; i < index; i++)
     {
      for(int n = i; n < 10; n++)
        {
         eTitle[n]    = Event[i][TITLE];
         eCountry[n]  = Event[i][COUNTRY];
         eImpact[n]   = Event[i][IMPACT];
         eForecast[n] = Event[i][FORECAST];
         ePrevious[n] = Event[i][PREVIOUS];
         eTime[n]     = datetime(MakeDateTime(Event[i][DATE], Event[i][TIME])) - TimeGMTOffset();
         eMinutes[n]  = (int)MinuteBuffer[i];
         //--- Check if there are any events
         if(ObjectFind(eTitle[n]) != 0)
            IsEvent = true;
        }
     }
//--- check then call draw / alert function
   if(IsEvent)
      DrawEvents();
   else
      Draw("no more events", "NO MORE EVENTS", 14, "Arial Black", RemarksColor, 2, 10, 30, "Get some rest!");
//--- call info function
   if(ShowInfo)
      SymbolInfo(sym);
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer3()
  {
//---
   xmlUpdate();
//---
  }
//+------------------------------------------------------------------+
//| Deinitialization                                                 |
//+------------------------------------------------------------------+
void OnnDeinit(const int reason)
  {
   Print(__FUNCTION__, " " + (string)reason);
//---
   for(int i = ObjectsTotal(); i >= 0; i--)
     {
      string name = ObjectName(i);
      if(StringFind(name, INAME) == 0)
         ObjectDelete(name);
     }
//OnnDeinit(reason);
//--- Kill update timer only if removed
   if(reason == 1)
     {
      EventKillTimer();
     }
//---
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string sUrl = "https://nfs.faireconomy.media/ff_calendar_thisweek.xml?version=bf0e35a327e8c9cd0b0ffdbae2dae029"; // ForexFactory NEWS URL (XML)
//+------------------------------------------------------------------+
//|                 URLDownloadToFileW                               |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int URLDownloadToFileW(string file, string url, string FilePath, int in, bool ns)
  {
   char results[];
   string result_headers = "";
   char data[];
//timeout 5000 for slow connnections
   int res = WebRequest("GET", url, NULL, NULL, 5000, data, 0, results, result_headers);
   string info = CharArrayToString(results, WHOLE_ARRAY);
   printf(info);
   if(res > 0)
     {
      if(res == 200)
        {
        }
      else
        {
         printf("HTTP ERROR " + GetErrorDescription(GetLastError(), 0));
        }
     }
   else
     {
      printf("HTTP ERROR " + GetErrorDescription(GetLastError(), 0));
     }
//--- correct way of working in the "file sandbox"
   ResetLastError();
   int filehandle = FileOpen(newsfile, FILE_WRITE | FILE_BIN);
   if(filehandle != INVALID_HANDLE)
     {
      FileWriteArray(filehandle, results, 0, WHOLE_ARRAY);
      FileClose(filehandle);
      Print("FileOpen OK");
     }
   else
      Print("Operation FileOpen failed, error ", GetLastError());
   return res;
  }

//+-------------------------------------------------------------------------------------------+
//| Download XML file from forexfactory                                                       |
//| for windows 7 and later file path would be:                                               |
//| C:\Users\xxx\AppData\Roaming\MetaQuotes\Terminal\xxxxxxxxxxxxxxx\MQL4\Files\xmlFileName   |
//+-------------------------------------------------------------------------------------------+
void xmlDownload()
  {
//---
   ResetLastError();
   string FilePath = StringConcatenate(TerminalInfoString(TERMINAL_DATA_PATH), "\\MQL4\\files\\", newsfile);
   int FileGet = URLDownloadToFileW(newsfile, sUrl, FilePath, 0, NULL);
   if(FileGet > 0)
      PrintFormat(INAME + ": %s file downloaded successfully!", newsfile);
//--- check for errors
   else
      PrintFormat(INAME + ": failed to download %s file, Error code = %d", newsfile, GetLastError());
//---
  }
//+------------------------------------------------------------------+
//| Read the XML file                                                |
//+------------------------------------------------------------------+
void xmlRead()
  {
//---
   ResetLastError();
   int FileHandle = FileOpen(newsfile, FILE_BIN | FILE_READ);
   if(FileHandle != INVALID_HANDLE)
     {
      //--- receive the file size
      ulong size = FileSize(FileHandle);
      //--- read data from the file
      while(!FileIsEnding(FileHandle))
         sData = FileReadString(FileHandle, (int)size);
      printf("read news :" + sData);
      //--- close
      FileClose(FileHandle);
     }
//--- check for errors
   else
      PrintFormat(INAME + ": failed to open %s file, Error code = %d", newsfile, GetErrorDescription(GetLastError(), 0));
//---
  }
//+------------------------------------------------------------------+
//| Check for update XML                                             |
//+------------------------------------------------------------------+
void xmlUpdate()
  {
//--- do not download on saturday
   if(TimeDayOfWeek(Midnight) == 6)
      return;
   else
     {
      Print(INAME + ": check for updates...");
      Print(INAME + ": delete old file");
      FileDelete(newsfile);
      xmlDownload();
      xmlRead();
      xmlModifed = (datetime)FileGetInteger(newsfile, FILE_MODIFY_DATE, false);
      PrintFormat(INAME + ": updated successfully! last modified: %s", (string)xmlModifed);
     }
//---
  }
//+------------------------------------------------------------------+
//| Draw panel and events on the chart                               |
//+------------------------------------------------------------------+
void DrawEvents()
  {
   string FontName = "Arial";
   int    FontSize = 8;
   string eToolTip = "";
//--- draw backbround / date / special note
   if(ShowPanel && ShowPanelBG)
     {
      eToolTip = "Hover on the Event!";
      Draw("BG", "gggg", 85, "Webdings", Pbgc, Corner, x0, 3, eToolTip);
      Draw("Date", DayToStr(Midnight) + ", " + MonthToStr() + " " + (string)TimeDay(Midnight), FontSize + 1, "Arial Black", TitleColor, Corner, xx2, 95, "Today");
      Draw("Title", PanelTitle, FontSize, FontName, TitleColor, Corner, xx1, 195, "Panel Title");
      Draw("Spreator", "------", 13, "Arial", RemarksColor, Corner, xx2, 183, eToolTip);
     }
//--- draw objects / alert functions
   for(int i = 0; i < 5; i++)
     {
      eToolTip = eTitle[i] + "\nCurrency: " + eCountry[i] + "\nTime left: " + (string)eMinutes[i] + " Minutes" + "\nImpact: " + eImpact[i];
      printf("Out0 :" + eToolTip);
      //--- impact color
      color EventColor = ImpactToColor(eImpact[i]);
      //--- previous/forecast color
      color ForecastColor = PreviousColor;
      if(ePrevious[i] > eForecast[i])
         ForecastColor = NegativeColor;
      else
         if(ePrevious[i] < eForecast[i])
            ForecastColor = PositiveColor;
      //--- past event color
      if(eMinutes[i] < 0)
         EventColor = ForecastColor = PreviousColor = RemarksColor;
      //--- panel
      if(ShowPanel)
        {
         //--- date/time / title / currency
         Draw("Event " + (string)i,
              DayToStr(eTime[i]) + "  |  " +
              TimeToStr(eTime[i], TIME_MINUTES) + "  |  " +
              eCountry[i] + "  |  " +
              eTitle[i], FontSize, FontName, EventColor, Corner, xx2, 70 - i * 15, eToolTip);
         //--- forecast
         Draw("Event Forecast " + (string)i, "[ " + eForecast[i] + " ]", FontSize, FontName, ForecastColor, Corner, xxf, 70 - i * 15,
              "Forecast: " + eForecast[i]);
         //--- previous
         Draw("Event Previous " + (string)i, "[ " + ePrevious[i] + " ]", FontSize, FontName, PreviousColor, Corner, xp, 70 - i * 15,
              "Previous: " + ePrevious[i]);
         //     bot.SendMessage(channel, DayToStr(eTime[i])+"  |  "+    TimeToStr(eTime[i],TIME_MINUTES)+"  |  "+eCountry[i]+"|"+ eTitle[i]);
         //--- forecast
        }
      //--- vertical news
      if(ShowVerticalNews)
         DrawLine("Event Line " + (string)i, eTime[i] + (ChartTimeOffset * 3600), EventColor, eToolTip);
      //--- Set alert message
      string AlertMessage = (string)eMinutes[i] + " Minutes until [" + eTitle[i] + "] Event on " + eCountry[i] +
                            "\nImpact: " + eImpact[i] +
                            "\nForecast: " + eForecast[i] +
                            "\nPrevious: " + ePrevious[i];
      //--- first alert
      if(Alert1Minutes != -1 && eMinutes[i] == Alert1Minutes && !FirstAlert)
        {
         setAlerts("First Alert! " + AlertMessage);
         FirstAlert = true;
         bot.SendMessage(channel, AlertMessage);
        }
      //--- second alert
      if(Alert2Minutes != -1 && eMinutes[i] == Alert2Minutes && !SecondAlert)
        {
         setAlerts("Second Alert! " + AlertMessage);
         bot.SendMessage(channel, AlertMessage);
         SecondAlert = true;
        }
      //--- break if no more data
      if(eTitle[i] == eTitle[i + 1])
        {
         Draw(INAME + " no more events", "NO MORE EVENTS! GET SOME REST. ", 8, "Arial", RemarksColor, Corner, xx2, 50 - i * 15, "Get some rest!");
         break;
        }
     }
//---
  }
//+-----------------------------------------------------------------------------------------------+
//| Subroutine: to ID currency even if broker has added a prefix to the symbol, and is used to    |
//| determine the news to show, based on the users external inputs - by authors (Modified)        |
//+-----------------------------------------------------------------------------------------------+
bool IsCurrency(string symbol)
  {
//---
   for(int jk = 0; jk < SymbolsTotal(false); jk++)
      if(symbol == StringSubstr(SymbolName(jk, false), 0, 3))
         return(true);
   return(false);
//---
  }
//+------------------------------------------------------------------+
//| Converts ff time & date into yyyy.mm.dd hh:mm - by deVries       |
//+------------------------------------------------------------------+
string MakeDateTime(string strDate, string strTime)
  {
//---
   int n1stDash = StringFind(strDate, "-");
   int n2ndDash = StringFind(strDate, "-", n1stDash + 1);
   string strMonth = StringSubstr(strDate, 0, 2);
   string strDay = StringSubstr(strDate, 3, 2);
   string strYear = StringSubstr(strDate, 6, 4);
   int nTimeColonPos = StringFind(strTime, ":");
   string strHour = StringSubstr(strTime, 0, nTimeColonPos);
   string strMinute = StringSubstr(strTime, nTimeColonPos + 1, 2);
   string strAM_PM = StringSubstr(strTime, StringLen(strTime) - 2);
   int nHour24 = StrToInteger(strHour);
   if((strAM_PM == "pm" || strAM_PM == "PM") && nHour24 != 12)
      nHour24 += 12;
   if((strAM_PM == "am" || strAM_PM == "AM") && nHour24 == 12)
      nHour24 = 0;
   string strHourPad = "";
   if(nHour24 < 10)
      strHourPad = "0";
   return(StringConcatenate(strYear, ".", strMonth, ".", strDay, " ", strHourPad, nHour24, ":", strMinute));
//---
  }
//+------------------------------------------------------------------+
//| set impact Color - by authors                                    |
//+------------------------------------------------------------------+
color ImpactToColor(string impact)
  {
//---
   if(impact == "High")
      return (HighImpactColor);
   else
      if(impact == "Medium")
         return (MediumImpactColor);
      else
         if(impact == "Low")
            return (LowImpactColor);
         else
            if(impact == "Holiday")
               return (HolidayColor);
            else
               return (RemarksColor);
//---
  }
//+------------------------------------------------------------------+
//| Impact to number - by authors                                    |
//+------------------------------------------------------------------+
int ImpactToNumber(string impact)
  {
//---
   if(impact == "High")
      return(3);
   else
      if(impact == "Medium")
         return(2);
      else
         if(impact == "Low")
            return(1);
         else
            return(0);
//---
  }
//+------------------------------------------------------------------+
//| Convert day of the week to text                                  |
//+------------------------------------------------------------------+
string DayToStr(datetime time)
  {
   int ThisDay = TimeDayOfWeek(time);
   string day = "";
   switch(ThisDay)
     {
      case 0:
         day = "Sun";
         break;
      case 1:
         day = "Mon";
         break;
      case 2:
         day = "Tue";
         break;
      case 3:
         day = "Wed";
         break;
      case 4:
         day = "Thu";
         break;
      case 5:
         day = "Fri";
         break;
      case 6:
         day = "Sat";
         break;
     }
   return(day);
  }
//+------------------------------------------------------------------+
//| Convert months to text                                           |
//+------------------------------------------------------------------+
string MonthToStr()
  {
   int ThisMonth = Month();
   string month = "";
   switch(ThisMonth)
     {
      case 1:
         month = "Jan";
         break;
      case 2:
         month = "Feb";
         break;
      case 3:
         month = "Mar";
         break;
      case 4:
         month = "Apr";
         break;
      case 5:
         month = "May";
         break;
      case 6:
         month = "Jun";
         break;
      case 7:
         month = "Jul";
         break;
      case 8:
         month = "Aug";
         break;
      case 9:
         month = "Sep";
         break;
      case 10:
         month = "Oct";
         break;
      case 11:
         month = "Nov";
         break;
      case 12:
         month = "Dec";
         break;
     }
   return(month);
  }
//+------------------------------------------------------------------+
//| Candle Time Left / Spread                                        |
//+------------------------------------------------------------------+
void SymbolInfo(string sym)
  {
//---
   string TimeLeft = TimeToStr(Time[0] + Period() * 60 - (int)TimeLocal(), TIME_MINUTES | TIME_SECONDS);
   string Spread = DoubleToStr(MarketInfo(sym, MODE_SPREAD) / Factor, 1);
   double DayClose = iClose(sym, PERIOD_D1, 1);
   if(DayClose != 0)
     {
      double Strength = ((MarketInfo(sym, MODE_BID) - DayClose) / DayClose) * 100;
      string Label = "Power: " + DoubleToStr(Strength, 2) + " %" + " Spread: " + Spread + " Current Bar close In :-" + TimeLeft;
      ENUM_BASE_CORNER corner = 1;
      if(Corner == 1)
         corner = 3;
      string arrow = "q";
      if(Strength > 0)
         arrow = "p";
      string tooltip = StringFormat("Power:%d,Spread :%d,Time :%s ,%",
                                    Strength, Spread, (string)Time[0]);
      Draw(INAME + ": info", Label, InfoFontSize, "Calibri", InfoColor, corner, 400, 20, tooltip);
      Draw(INAME + ": info arrow", arrow, InfoFontSize + 2, "Wingdings 3", InfoColor, corner, 280, 28, tooltip);
     }
//---
  }
//+------------------------------------------------------------------+
//| draw event text                                                  |
//+------------------------------------------------------------------+
void Draw(string name, string label, int size, string font, color clr, ENUM_BASE_CORNER c, int x, int y, string tooltip)
  {
//---
   name = INAME + ": " + name;
   int windows = 0;
   if(AllowSubwindow && WindowsTotal() > 1)
      windows = 1;
   ObjectDelete(name);
   ObjectCreate(name, OBJ_LABEL, windows, 0, 0);
   ObjectSetText(name, label, size, font, clr);
   ObjectSet(name, OBJPROP_CORNER, c);
   ObjectSet(name, OBJPROP_XDISTANCE, x);
   ObjectSet(name, OBJPROP_YDISTANCE, y);
//--- justify text
   ObjectSet(name, OBJPROP_ANCHOR, anchorx);
   ObjectSetString(0, name, OBJPROP_TOOLTIP, tooltip);
   ObjectSet(name, OBJPROP_SELECTABLE, 0);
//---
  }
//+------------------------------------------------------------------+
//| draw vertical lines                                              |
//+------------------------------------------------------------------+
void DrawLine(string name, datetime time, color clr, string tooltip)
  {
//---
   name = INAME + ": " + name;
   ObjectDelete(name);
   ObjectCreate(name, OBJ_VLINE, 0, time, 0);
   ObjectSet(name, OBJPROP_COLOR, clr);
   ObjectSet(name, OBJPROP_STYLE, 2);
   ObjectSet(name, OBJPROP_WIDTH, 5);
   ObjectSetString(0, name, OBJPROP_TOOLTIP, tooltip);
//---
  }



//+------------------------------------------------------------------+
//| draw zones                                           |
//+------------------------------------------------------------------+
void DrawZones(ZONES &zones, string tooltip)
  {
//---
   string name = (string) zones.types;
   ObjectDelete(name);
   ObjectCreate(ChartID(), name, OBJ_HLINE, 0, zones.time, zones.price);
   ObjectSet(name, OBJPROP_COLOR, zones.zone_color);
   ObjectSet(name, OBJPROP_STYLE, 0);
   ObjectSetInteger(ChartID(), name, OBJPROP_CREATETIME, TimeLocal());
   ObjectSetInteger(ChartID(), name, OBJPROP_SELECTABLE, true);
   ObjectSetInteger(ChartID(), name, OBJPROP_TIMEFRAMES, zones.time);
   ObjectSet(name, OBJPROP_XDISTANCE, 0);
   ObjectSet(name, OBJPROP_YDISTANCE, zones.price);
   ObjectSet(name, OBJPROP_WIDTH, zones.Thickness_Size);
   ObjectSetString(ChartID(), name, OBJPROP_TOOLTIP, tooltip);
//---
  }








//+------------------------------------------------------------------+
//| Notifications                                                    |
//+------------------------------------------------------------------+
void setAlerts(string message)
  {
//---
   if(PopupAlerts)
      Alert(message);
   if(SoundAlerts)
      PlaySound(AlertSoundFile);
   if(NotificationAlerts)
      SendNotification(message);
   if(EmailAlerts)
      SendMail(INAME, message);
//---
  }








//+------------------------------------------------------------------+
//|                  TRADE REPORT                                                |
//+------------------------------------------------------------------+
void TradeReport()
  {
   string msgs = StringFormat(
                    "Date :%s , AccountNumber %d , AccountName %s , Balance %d, Profit %d , Open Order %n", TimeToString(TimeCurrent()), AccountNumber(), AccountName(),
                    AccountBalance()
                    , AccountProfit(), OrdersTotal()
                 );
   Print("Symbol=", Symbol());
   Print("Low day price=", MarketInfo(Symbol(), MODE_LOW));
   Print("High day price=", MarketInfo(Symbol(), MODE_HIGH));
   Print("The last incoming tick time=", (MarketInfo(Symbol(), MODE_TIME)));
   Print("Last incoming bid price=", MarketInfo(Symbol(), MODE_BID));
   Print("Last incoming ask price=", MarketInfo(Symbol(), MODE_ASK));
   Print("Point size in the quote currency=", MarketInfo(Symbol(), MODE_POINT));
   Print("Digits after decimal point=", MarketInfo(Symbol(), MODE_DIGITS));
   Print("Spread value in points=", MarketInfo(Symbol(), MODE_SPREAD));
   Print("Stop level in points=", MarketInfo(Symbol(), MODE_STOPLEVEL));
   Print("Lot size in the base currency=", MarketInfo(Symbol(), MODE_LOTSIZE));
   Print("Tick value in the deposit currency=", MarketInfo(Symbol(), MODE_TICKVALUE));
   Print("Tick size in points=", MarketInfo(Symbol(), MODE_TICKSIZE));
   Print("Swap of the buy order=", MarketInfo(Symbol(), MODE_SWAPLONG));
   Print("Swap of the sell order=", MarketInfo(Symbol(), MODE_SWAPSHORT));
   Print("Market starting date (for futures)=", MarketInfo(Symbol(), MODE_STARTING));
   Print("Market expiration date (for futures)=", MarketInfo(Symbol(), MODE_EXPIRATION));
   Print("Trade is allowed for the symbol=", MarketInfo(Symbol(), MODE_TRADEALLOWED));
   Print("Minimum permitted amount of a lot=", MarketInfo(Symbol(), MODE_MINLOT));
   Print("Step for changing lots=", MarketInfo(Symbol(), MODE_LOTSTEP));
   Print("Maximum permitted amount of a lot=", MarketInfo(Symbol(), MODE_MAXLOT));
   Print("Swap calculation method=", MarketInfo(Symbol(), MODE_SWAPTYPE));
   Print("Profit calculation mode=", MarketInfo(Symbol(), MODE_PROFITCALCMODE));
   Print("Margin calculation mode=", MarketInfo(Symbol(), MODE_MARGINCALCMODE));
   Print("Initial margin requirements for 1 lot=", MarketInfo(Symbol(), MODE_MARGININIT));
   Print("Margin to maintain open orders calculated for 1 lot=", MarketInfo(Symbol(), MODE_MARGINMAINTENANCE));
   Print("Hedged margin calculated for 1 lot=", MarketInfo(Symbol(), MODE_MARGINHEDGED));
   Print("Free margin required to open 1 lot for buying=", MarketInfo(Symbol(), MODE_MARGINREQUIRED));
   Print("Order freeze level in points=", MarketInfo(Symbol(), MODE_FREEZELEVEL));
  }

ENUM_RUN_MODE  run_mode;


//+------------------------------------------------------------------+
//|         ON TIMER                                                         |
//+------------------------------------------------------------------+
void OnnTimer()
  {
   if(telegram == yes)
     {
      CComment comment;
      //--- show init error
      if(init_error != 0)
        {
         //--- show error on display
         CustomInfo info;
         GetCustomInfo(info, init_error, InpLanguage);
         //---
         comment.SetText(0, info.text1, LOSS_COLOR);
         bot.SendMessage(chatID, info.text1 + info.text2);
         if(info.text2 != "")
            comment.SetText(1, info.text2, LOSS_COLOR);
         comment.Show();
         //return;
        }
      //--- show web error
      if(run_mode == RUN_LIVE)
        {
         bot.ProcessMessages();
         //--- check bot registration
         if(time_check < TimeLocal() - PeriodSeconds(PERIOD_H1))
           {
            time_check = TimeLocal();
            if(TerminalInfoInteger(TERMINAL_CONNECTED))
              {
               //---
               web_error = bot.GetMe();
               if(web_error != 0)
                 {
                  //---
                  if(web_error == ERR_NOT_ACTIVE)
                    {
                     time_check = TimeLocal() - PeriodSeconds(PERIOD_H1) + 300;
                    }
                  //---
                  else
                    {
                     time_check = TimeLocal() - PeriodSeconds(PERIOD_H1) + 5;
                    }
                 }
              }
            else
              {
               web_error = ERR_NOT_CONNECTED;
               time_check = 0;
              }
           }
         //--- show error
         if(web_error != 0)
           {
            comment.Clear();
            comment.SetText(0, StringFormat("%s v.%s", EXPERT_NAME, EXPERT_VERSION), CAPTION_COLOR);
            if(
#ifdef __MQL4__ web_error==ERR_FUNCTION_NOT_CONFIRMED #endif
#ifdef __MQL5__ web_error==ERR_FUNCTION_NOT_ALLOWED #endif
            )
              {
               time_check = 0;
               CustomInfo info = {0};
               GetCustomInfo(info, web_error, InpLanguage);
               comment.SetText(1, info.text1, LOSS_COLOR);
               comment.SetText(2, info.text2, LOSS_COLOR);
              }
            else
               comment.SetText(2, GetErrorDescription(web_error, InpLanguage), LOSS_COLOR);
            comment.Show();
           }
        }
      //---
      bot.GetUpdates();
      //---
     }
   bot.ProcessMessages();
   OnTick();//DO NOT MOVE THIS FUNCTION ORDER MATTER

  }




//+------------------------------------------------------------------+
//|   GetCustomInfo                                                  |
//+------------------------------------------------------------------+
void GetCustomInfo(CustomInfo &info,
                   const int _error_code,
                   const ENUM_LANGUAGES _lang)
  {
   switch(_error_code)
     {
#ifdef __MQL5__
      case ERR_FUNCTION_NOT_ALLOWED:
         info.text1 = (_lang == LANGUAGE_EN) ? "The URL does not allowed for WebRequest" : "Этого URL нет в списке для WebRequest.";
         info.text2 = TELEGRAM_BASE_URL;
         break;
#endif
#ifdef __MQL4__
      case ERR_FUNCTION_NOT_CONFIRMED:
         info.text1 = (_lang == LANGUAGE_EN) ? "The URL does not allowed for WebRequest" : "Этого URL нет в списке для WebRequest.";
         info.text2 = TELEGRAM_BASE_URL;
         break;
#endif
      case ERR_TOKEN_ISEMPTY:
         info.text1 = (_lang == LANGUAGE_EN) ? "The 'Token' parameter is empty." : "Параметр 'Token' пуст.";
         info.text2 = (_lang == LANGUAGE_EN) ? "Please fill this parameter." : "Пожалуйста задайте значение для этого параметра.";
         break;
     }
  }


//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID = 0,             // chart's ID
                 const string            name = "Label",           // label name
                 const int               sub_window = 0,           // subwindow index
                 const int               x = 0,                    // X coordinate
                 const int               y = 0,                    // Y coordinate
                 const ENUM_BASE_CORNER  corner = CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string            text = "Label",           // text
                 const string            font = "Arial",           // font
                 const int               font_size = 10,           // font size
                 const color             clr = C'183,28,28', // color
                 const double            angle = 0.0,              // text slope
                 const ENUM_ANCHOR_POINT xanchor = ANCHOR_LEFT_UPPER, // anchor type
                 const bool              back = false,             // in the background
                 const bool              selection = false,        // highlight to move
                 const bool              hidden = true,            // hidden in the object list
                 const long              z_order = 0)              // priority for mouse click
  {
//--- reset the error value
   ObjectDelete(chart_ID, name);
   ResetLastError();
//--- create a text label
   if(!ObjectCreate(chart_ID, name, OBJ_LABEL, sub_window, Time[0], Ask))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ", GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x);
   ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID, name, OBJPROP_CORNER, corner);
//--- set the text
   ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
//--- set text font
   ObjectSetString(chart_ID, name, OBJPROP_FONT, font);
//--- set font size
   ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID, name, OBJPROP_ANGLE, angle);
//--- set anchor type
   ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, xanchor);
//--- set color
   ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
   ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the text label                                              |
//+------------------------------------------------------------------+
bool LabelMove(const long   chart_ID = 0, // chart's ID
               const string name = "Label", // label name
               const int    x = 0,        // X coordinate
               const int    y = 0)        // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the text label
   if(!ObjectSetInteger(chart_ID, name, OBJPROP_XDISTANCE, x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the label! Error code = ", GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID, name, OBJPROP_YDISTANCE, y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the label! Error code = ", GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//|            TRADE HISTORY                                                      |
//+------------------------------------------------------------------+
void tradeHistory(string sym)
  {
//CWndContainer container;
//CComboBox cb;
//CLabel lab;
//CDialog dialog;
//dialog.Create(ChartID(), "dialog", 1, 1, 45, 32, 8);
//dialog.Bottom(345);
//dialog.BringToTop();
//lab.Create(ChartID(), "info", 0, 0, 0, 123, 45);
//container.Create(ChartID(), "container", 0, 12, 23, 123, 150);
//CListView listView;
//listView.AddItem(
//   sym
//);
//CPanel panel;
//panel.Color(clrBlue);
//panel.Create(ChartID(), "PANEL", 0, 0, 0, 0, 0);
//panel.Visible(true);
//panel.Activate();
//listView.BringToTop();
//panel.MouseX(0);
//panel.MouseY(0);
//--- open the file for writing the indicator values (if the file is absent, it will be created automatically)
   ResetLastError();
   int file_handle = FileOpen("DWX/DWX_Historic_Trades.csv", FILE_READ | FILE_WRITE | FILE_CSV);
   if(file_handle != INVALID_HANDLE)
     {
      PrintFormat("%s file is available for writing", "DWX/DWX_Historic_Trades.csv");
      PrintFormat("File path: %s\\Files\\", TerminalInfoString(TERMINAL_DATA_PATH));
      //--- first, write the number of signals
      int op3 = (int) FileSeek(file_handle, 0, SEEK_END);
      int write = (int)FileWrite(file_handle, TimeLocal(), sym, OrderLots(), OrderOpenPrice(), OrderClosePrice(), OrderProfit(), AccountBalance(), Bid, Ask, Volume[0]) ;
      //--- write the time and values of signals to the file
      if(write <= 0)
         printf("Error writing file DWX\\DWX_Historic_Trades.csv");
      FileClose(file_handle);
      PrintFormat("Data is written, %s file is closed", "DWX\\DWX_Historic_Trades.csv");
     }
   else
     {
      PrintFormat("Failed to open %s file, Error code = %d", "DWX\\DWX_Historic_Trades.csv", GetErrorDescription(GetLastError(), 0));
     }
   ObjectsDeleteAll(0, "HistoryToObjects_");
   double totalProfit = 0;
   int total_order = OrdersHistoryTotal();
   for(int x = total_order; x >= 0; x--)
     {
      if(OrderSelect(x, SELECT_BY_TICKET) == false)
        {
         continue;
        }
      if(MagicNumber != 0 && OrderMagicNumber() != MagicNumber)
        {
         continue;
        }
      if(OrderSymbol() != sym)
        {
         continue;
        }
      string orderType = OrderType() == OP_BUY ? "Buy" : OrderType() == OP_SELL ? "Sell" : "";
      int lapse = (int) MathFloor((OrderCloseTime() - OrderOpenTime()) / 60) / 4;
      totalProfit += OrderProfit();
      if(OrderType() != OP_BUY && OrderType() != OP_SELL)
        {
         continue;
        }
      string _name = "HistoryToObjects_" + IntegerToString(OrderTicket());
      if(ObjectCreate(0, _name, OBJ_TREND, 0, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderClosePrice()))
        {
         ObjectSet(_name, OBJPROP_RAY, 0);
         ObjectSet(_name, OBJPROP_COLOR, OrderType() == OP_BUY ? clrWhite : clrPurple);
         ObjectSet(_name, OBJPROP_SELECTABLE, false);
        }
      if(ObjectCreate(0, _name + "_E", OBJ_TREND, 0, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderOpenPrice()))
        {
         ObjectSet(_name + "_E", OBJPROP_RAY, 0);
         ObjectSet(_name + "_E", OBJPROP_COLOR, clrBlack);
         ObjectSet(_name + "_E", OBJPROP_SELECTABLE, false);
        }
      if(ObjectCreate(0, _name + "_TP", OBJ_TREND, 0, OrderOpenTime(), OrderTakeProfit(), OrderCloseTime(), OrderTakeProfit()))
        {
         ObjectSet(_name + "_TP", OBJPROP_RAY, 0);
         ObjectSet(_name + "_TP", OBJPROP_COLOR, clrGreen);
         ObjectSet(_name + "_TP", OBJPROP_SELECTABLE, true);
        }
      if(ObjectCreate(0, _name + "_SL", OBJ_TREND, 0, OrderOpenTime(), OrderStopLoss(), OrderCloseTime(), OrderStopLoss()))
        {
         ObjectSet(_name + "_SL", OBJPROP_RAY, 0);
         ObjectSet(_name + "_SL", OBJPROP_COLOR, clrRed);
         ObjectSet(_name + "_SL", OBJPROP_SELECTABLE, true);
        }
      int _start = iBarShift(NULL, 0, OrderOpenTime());
      if(ObjectCreate(0, _name + "_ASTART", OBJ_ARROW, 0, Time[_start], OrderType() == OP_BUY ? Low[_start] : High[_start]))
        {
         ObjectSet(_name + "_ASTART", OBJPROP_ARROWCODE, OrderType() == OP_BUY ? 233 : 234);
         ObjectSet(_name + "_ASTART", OBJPROP_ANCHOR, OrderType() == OP_BUY ? ANCHOR_TOP : ANCHOR_BOTTOM);
         ObjectSet(_name + "_ASTART", OBJPROP_COLOR, OrderType() == OP_BUY ? clrWhite : clrRed);
         ObjectSet(_name + "_ASTART", OBJPROP_SELECTABLE, false);
        }
      if(ObjectCreate(0, _name + "_ASTOP", OBJ_ARROW, 0, OrderCloseTime(), OrderClosePrice()))
        {
         ObjectSet(_name + "_ASTOP", OBJPROP_ARROWCODE, OrderProfit() <= 0 ? 251 : 252);
         ObjectSet(_name + "_ASTOP", OBJPROP_ANCHOR, ANCHOR_CENTER);
         ObjectSet(_name + "_ASTOP", OBJPROP_COLOR, OrderType() == OP_SELL ? clrBlue : clrRed);
         ObjectSet(_name + "_ASTOP", OBJPROP_SELECTABLE, false);
        }
      if(ObjectCreate(0, _name + "_TPZONE", OBJ_RECTANGLE, 0, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderTakeProfit()))
        {
         ObjectSet(_name + "_TPZONE", OBJPROP_COLOR, clrPowderBlue);
         ObjectSet(_name + "_TPZONE", OBJPROP_SELECTABLE, false);
         ObjectSet(_name + "_TPZONE", OBJPROP_BACK, true);
        }
      if(ObjectCreate(0, _name + "_SLZONE", OBJ_RECTANGLE, 0, OrderOpenTime(), OrderOpenPrice(), OrderCloseTime(), OrderStopLoss()))
        {
         ObjectSet(_name + "_SLZONE", OBJPROP_COLOR, clrPink);
         ObjectSet(_name + "_SLZONE", OBJPROP_SELECTABLE, false);
         ObjectSet(_name + "_SLZONE", OBJPROP_BACK, true);
        }
     }
  }


CNews mynews[];
string jamberita = "";
bool judulnews = true;





//-------- Debit/Credit total -------------------
bool StopTarget()


  {
   double profitValue = AccountBalance() - AccountEquity();
   if((2 / AccountBalance()) * 100 >= profitValue)
     {
      return (true);
     }
   return (false);
  }
//+------------------------------------------------------------------+
//|                       CloseAll                                           |
//+------------------------------------------------------------------+
void CloseAll()
  {
   int totalOP  = OrdersTotal(), tiket = 0;
   for(int cnt = totalOP - 1 ; cnt >= 0 ; cnt--)
     {
      int Oc = 0, Os = OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType() == OP_BUY && OrderMagicNumber() == MagicNumber)
        {
         Oc = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3, CLR_NONE);
         Sleep(300);
         continue;
        }
      if(OrderType() == OP_SELL && OrderMagicNumber() == MagicNumber)
        {
         Oc = OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3, CLR_NONE);
         Sleep(300);
        }
     }
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnnTick()
  {
   if(garantiesProfit)
     {
      int j = 0;
      for(j = OrdersTotal() - 1; j > 0; j--)
        {
         if(OrderSelect(j, SELECT_BY_POS))
           {
            if(OrderProfit() <= 20)
              {
               if(OrderTicket() == j)
                  j =  OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), slippage, clrWhite);
              }
           }
        }
     }

     int count=0;


   int total =StringSplit(symbolss,',',symbols);
  if(count<=1){count++;
    int or=   FileOpen("DWX/symbols.csv",FILE_READ|FILE_WRITE|FILE_CSV,',');
    if(or>0){

   FileWrite(or,"symbol");

    for(int j=0;j<total;j++){
    FileSeek(or,0,SEEK_END);
    FileWrite(or,symbols[j]);


} FileClose(or );

   }else{

   printf("CAN'T OPEN SYMBOLS.CSV FILE");
   }}

   for(int j=0;j<total;j++){
//---
//---     MARKET INFO
   int digit = (int)MarketInfo(MarketInfo(symbols[j],MODE_BID), MODE_DIGITS);
   double bid = MarketInfo(symbols[j],MODE_BID);
   double ask = MarketInfo(symbols[j],MODE_ASK);

//--------TEMP ZONE
   tempzones.types = "tempzones";
   tempzones.symbol = MarketInfo(symbols[j],MODE_BID);
   tempzones.fractal = FRACTALS(1);
   tempzones.zigzag = ZIGZAG(1);
   tempzones.types = "tempzones";
   tempzones.trade_signal = (string)signal(MarketInfo(symbols[j],MODE_BID));
   tempzones.takeprofit = takeprofit;
   tempzones.stoploss = stoploss;
   tempzones.support = Support(MarketInfo(symbols[j],MODE_BID), 1 * 86400, false, 00, 00, true, 0);
   tempzones.resistance = Resistance(MarketInfo(symbols[j],MODE_BID), 1 * 86400, false, 00, 00, true, 1);
   tempzones.risk_percentage = Risk;
   tempzones.execution_style = tempzone_execution_style;
   tempzones.Thickness_Size = tempzone_Thickness_Size;
   tempzones.session_trade = tempzone_session_Trade;
   tempzones.start_price = MarketInfo(symbols[j],MODE_BID);
   tempzones.strengh = GetStrength(tempzones);
//   MAIN ZONES
   mainzones.types = "mainzones";
   mainzones.symbol = symbols[j];
   mainzones.takeprofit = takeprofit;
   mainzones.stoploss = stoploss;
   mainzones.support = Support(symbols[j], 1 * 86400, false, 00, 00, true, 0);
   mainzones.resistance = Resistance(symbols[j], 1 * 86400, false, 00, 00, true, 1);
   mainzones.risk_percentage = Risk;
   mainzones.types = "mainzones";
   mainzones.execution_style = mainzone_execution_style;
   mainzones.Thickness_Size = mainzone_Thickness_Size;
   mainzones.session_trade = mainzone_session_Trade;
   mainzones.start_price = MarketInfo(symbols[j],MODE_BID);
   mainzones.strengh = GetStrength(mainzones);
   mainzones.fractal = FRACTALS(1);
   mainzones.zigzag = ZIGZAG(1);
   mainzones.trend = getTrend();
//Create Fractals
   if(ObjectFind(ChartID(), "Fractal Up") > 0 && ea_trade_mode == BUYING_MODE)
     {
      isCorrectMarketStructure = true;
     }
   else
      if(ObjectFind(ChartID(), "Fractal Down") > 0 && ea_trade_mode == SELLING_MODE)
        {
         isCorrectMarketStructure = true;
        }
   GET_ZONES(mainzones);
   GET_ZONES(tempzones);

  Trade(tempzones);
  Trade(mainzones);
  if(telegram == yes)
     {
      SEND_REPORT_TO_TELEGRAM();
      tradeHistory(Symbol());
     }




   }

  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int signal(string sym)
  {
   int sig = 0;
   if(ea_trade_mode == SELLING_MODE)
      return -1;
   if(ea_trade_mode == BUYING_MODE)
      return 1;
   return ea_trade_mode = STATIC_MODE;
  }




//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int   Ordersend(string sym, double bid, double ask, int digit, ENUM_ORDER_TYPE cmd)
  {
   double lot;
   int ticket = 0;
   if(IsTradeAllowed())
     {
      double sl;
      double tp;
      if(OrdersTotal() < maxOpenOrders)
         if(cmd == 0 || cmd == 2 || cmd == 4)
           {
            sl =  NormalizeDouble((ask - stoploss * MarketInfo(sym, MODE_POINT)), digit);
            tp = NormalizeDouble((ask + takeprofit * MarketInfo(sym, MODE_POINT)), digit);
            lot = getLotSize(sym, moneyManagement, sl);
            if(((AccountBalance() + AccountEquity()) / 5) > 0)
               ticket =  OrderSend(sym, cmd, lot, ask, slippage, sl, tp, "ZONES EA @SELL", cmd + 2, 0, clrRed);
            if(ticket <= 0)
              {
               printf(ErrorDescription(GetLastError()));
               return 0;
              }
           }
         else
           {
            sl =  NormalizeDouble((bid + stoploss * MarketInfo(sym, MODE_POINT)), digit);
            tp = NormalizeDouble((bid - takeprofit * MarketInfo(sym, MODE_POINT)), digit);
            lot = getLotSize(sym, moneyManagement, sl);
            if(((AccountBalance() + AccountEquity()) / 5) > 0)
               ticket =  OrderSend(sym, cmd, lot, bid, slippage, sl, tp, " ZONES EA @SELL", cmd + 2, 0, clrRed);
            if(ticket <= 0)
              {
               printf(ErrorDescription(GetLastError()));
               return 0;
              }
           }
      else
         Orderclose(sym);
      ObjectCreate(ChartID(), "alpha", OBJ_LABEL, 0, Time[0], Ask);
      ObjectSetInteger(ChartID(), "alpha", OBJPROP_XDISTANCE, 0);
      ObjectSetInteger(ChartID(), "alpha", OBJPROP_YDISTANCE, 10);
      ObjectSetText("alpha", "ZONES EA", 16, NULL, clrYellow);
     }
   return 0;
  }





//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int Orderclose(string sym)
  {
   for(int j = OrdersTotal(); j > 0; j--)
     {
      if(OrderSelect(j, SELECT_BY_TICKET, MODE_TRADES) && (OrderType() == 0 || OrderType() == 2 || OrderType() == 4) && OrderSymbol() == sym)
        {
         if(OrderProfit() < OrderOpenPrice() < MarketInfo(sym, MODE_BID) && OrderProfit() > 10)
            return OrderClose(j, OrderLots(), 0, 0, clrWhite);
        }
      else
         if(OrderSelect(j, SELECT_BY_TICKET, MODE_TRADES) && (OrderType() == 1 || OrderType() == 3 || OrderType() == 5) && (OrderSymbol() == sym))
           {
            if(OrderProfit() > 0 && MarketInfo(sym, MODE_ASK) >= OrderOpenPrice())
               return OrderClose(j, OrderLots(), 0, 0, clrRed);
           }
     }
   return 0;
  }









//+------------------------------------------------------------------+
//|                        Trade                                          |
//+------------------------------------------------------------------+
void Trade(ZONES &zone) //FILTER TRADES
  {
//SEARCHING  AND DRAWING ZONES
   LabelCreate(ChartID(), "trend", 0, 0, 280, 0, "MARKET TREND IS " + mainzones.trend, NULL, 12, clrYellowGreen);
   ObjectSetInteger(ChartID(), "trend",       OBJPROP_SELECTED, true);
   if(zone.types == "mainzones")
     {
      switch(zone.session_trade)
        {
         case INTRA_DAY:
            IntradayTrading(zone);
            break;
         case    DAY_TRADING:
            DayTrading(zone);
            break;
         case SWING_TRADING :
            SwingTrading(zone);
            break;
         case SCALP_TRADING:
            ScalpTrading(zone);
            break;
         default  :
            break;
        }
     }
   else
     {
      switch(zone.session_trade)
        {
         case INTRA_DAY:
            IntradayTrading(zone);
            break;
         case    DAY_TRADING:
            DayTrading(zone);
            break;
         case SWING_TRADING :
            SwingTrading(zone);
            break;
         case SCALP_TRADING:
            ScalpTrading(zone);
            break;
         default  :
            break;
        }
     }
  }

//+------------------------------------------------------------------+
//|                             SwingTrading                                     |
//+------------------------------------------------------------------+
void SwingTrading(ZONES&zone)
  {
   if(zone.types == "mainzones")
     {
      stoploss = 30;
      takeprofit = 1000;
     }
   else
     {
      stoploss = 30;
      takeprofit = 1000;
     }
   string sym = Symbol();
   int ticket = 0;
   double SL, TP;
   int count = 0;
   double priceMemo = 0;
   double profit = OrderProfit();
   TrailingStopBE(zone.symbol, OP_BUY, BreakEven_Points * myPoint, 0); //Trailing Stop = go break even
//Open Buy Order, instant signal is tested first
   if(ea_trade_mode == BUYING_MODE && OrdersTotal() < MaxOpenTrades && OrdersTotal() <= MaxShortTrades && AccountEquity() >= AccountBalance()
//Moving Average crosses above Moving Average
//On Balance Volume > On Balance Volume
//Relative Strength Index > Relative Strength Index
     )
     {
      RefreshRates();
      double price = MarketInfo(sym, MODE_ASK);
      SL = price - stoploss * MarketInfo(sym, MODE_POINT); //Stop Loss = value in points (relative to price)
      TP = price + takeprofit * MarketInfo(sym, MODE_POINT); //Take Profit = value in points (relative to
      Lots =             getLotSize(sym, moneyManagement, SL)    ;
      if(IsTradeAllowed())
        {
         switch(zone.execution_style)
           {
            case INSTANT :
               ticket = myOrderSend(sym, OP_BUY, price, Lots, "ZONES EA -->@BUY " +
                                    (string)MarketInfo(sym, MODE_BID), SL, TP);
               break;
            case ADVANCED:
               ticket = myOrderSend(sym, OP_BUYSTOP, price, Lots, "ZONES EA -->@BUYSTOP" +
                                    (string)MarketInfo(sym, MODE_BID), SL, TP);
               break;
           }
         if(ticket <= 0)
            return;
        }
      else //not autotrading => only send alert
         myAlert("order", "");
      myOrderModify(sym, ticket, SL, TP);
     }
   else
      if(ea_trade_mode == SELLING_MODE && OrdersTotal() < MaxOpenTrades && OrdersTotal() <= MaxShortTrades && AccountEquity() >= AccountBalance())
        {
         RefreshRates();
         double price = MarketInfo(sym, MODE_BID);
         SL =   price + stoploss * MarketInfo(sym, MODE_POINT); //Stop Loss = value in points (relative to price)
         TP = price - takeprofit * MarketInfo(sym, MODE_POINT); //Take Profit = value in points (relative to
         Lots =              getLotSize(sym, moneyManagement, SL)    ;
         printf("SL: " + (string)SL + "TP: " + (string)TP + "   lot :" + (string)Lots);
         if(IsTradeAllowed())
           {
            switch(zone.execution_style)
              {
               case INSTANT :
                  ticket = myOrderSend(sym, OP_SELL, price, Lots, "ZONES EA -->@Sell " +
                                       (string)MarketInfo(sym, MODE_BID), SL, TP);
                  break;
               case ADVANCED:
                  ticket = myOrderSend(sym, OP_SELLSTOP, price, Lots, "ZONES EA -->@SellSTOP" +
                                       (string)MarketInfo(sym, MODE_BID), SL, TP);
                  break;
              }
            if(ticket <= 0)
               return;
           }
         else //not autotrading => only send alert
           {
            myAlert("order", "");
            myOrderModify(sym, ticket, SL, TP);
           }
        }
  }
//+------------------------------------------------------------------+
//|                    ScalpTrading                                              |
//+------------------------------------------------------------------+
void ScalpTrading(ZONES &zone)
  {
   stoploss = 30;
   takeprofit = 300;
   string sym = Symbol();
   int ticket = 0;
   double SL, TP;
   int count = 0;
   double priceMemo = 0;
   double profit = OrderProfit();
   TrailingStopBE(zone.symbol, OP_BUY, BreakEven_Points * myPoint, 0); //Trailing Stop = go break even
//Open Buy Order, instant signal is tested first
   if(
      ea_trade_mode == BUYING_MODE && OrdersTotal() < MaxOpenTrades && OrdersTotal() <= MaxShortTrades && AccountEquity() >= AccountBalance()
   )
     {
      RefreshRates();
      double price = MarketInfo(sym, MODE_ASK);
      SL = price - stoploss * MarketInfo(sym, MODE_POINT); //Stop Loss = value in points (relative to price)
      TP = price + takeprofit * MarketInfo(sym, MODE_POINT); //Take Profit = value in points (relative to
      Lots =              getLotSize(sym, moneyManagement, SL)   ;
      if(IsTradeAllowed())
        {
         switch(zone.execution_style)
           {
            case INSTANT :
               ticket = myOrderSend(sym, OP_BUY, price, Lots, "ZONES EA -->@BUY " +
                                    (string)MarketInfo(sym, MODE_ASK), SL, TP);
               break;
            case ADVANCED:
               ticket = myOrderSend(sym, OP_BUYSTOP, price, Lots, "ZONES EA -->@BUYSTOP" +
                                    (string)MarketInfo(sym, MODE_BID), SL, TP);
               break;
           }
         if(ticket <= 0)
            return;
        }
      else //not autotrading => only send alert
         myAlert("order", "");
      myOrderModify(sym, ticket, SL, TP);
     }
   else
      if(ea_trade_mode == SELLING_MODE && OrdersTotal() < MaxOpenTrades && OrdersTotal() <= MaxShortTrades && AccountEquity() >= AccountBalance())
        {
         //Open Sell Order, instant signal is tested first
         if(
            ea_trade_mode == SELLING_MODE
         )
           {
            RefreshRates();
            double price = MarketInfo(sym, MODE_BID);
            SL = price + stoploss * MarketInfo(sym, MODE_POINT); //Stop Loss = value in points (relative to price)
            TP = price - takeprofit * MarketInfo(sym, MODE_POINT); //Take Profit = value in points (relative to
            Lots =              getLotSize(sym, moneyManagement, SL)    ;
            printf("SL: " + (string)SL + "TP: " + (string)TP + "   lot :" + (string)Lots);
            if(IsTradeAllowed())
              {
               switch(zone.execution_style)
                 {
                  case INSTANT :
                     ticket = myOrderSend(sym, OP_SELL, price, Lots, "ZONES EA -->@Sell " +
                                          (string)MarketInfo(sym, MODE_BID), SL, TP);
                     break;
                  case ADVANCED:
                     ticket = myOrderSend(sym, OP_SELLSTOP, price, Lots, "ZONES EA -->@SellSTOP" +
                                          (string)MarketInfo(sym, MODE_BID), SL, TP);
                     break;
                 }
               if(ticket <= 0)
                  return;
              }
            else //not autotrading => only send alert
              {
               myAlert("order", "");
               myOrderModify(sym, ticket, SL, TP);
              }
           }
        }
  }












//+------------------------------------------------------------------+
//|                           DAY TRADING                                       |
//+------------------------------------------------------------------+
void DayTrading(ZONES &zone) //DAY TRADING
  {
   if(zone.types == "mainzones")
     {
      stoploss = 0;
      takeprofit = 500;
     }
   string sym = Symbol();
   int ticket = 0;
   double SL, TP;
   int count = 0;
   double priceMemo = 0;
   double profit = OrderProfit();
   TrailingStopBE(zone.symbol, OP_BUY, BreakEven_Points * myPoint, 0); //Trailing Stop = go break even
//Open Buy Order, instant signal is tested first
   if(ea_trade_mode == BUYING_MODE && OrdersTotal() < MaxOpenTrades && OrdersTotal() <= MaxShortTrades && AccountEquity() >= AccountBalance())
     {
      RefreshRates();
      double price = MarketInfo(sym, MODE_ASK);
      SL = price - stoploss * MarketInfo(sym, MODE_POINT); //Stop Loss = value in points (relative to price)
      TP = price + takeprofit * MarketInfo(sym, MODE_POINT); //Take Profit = value in points (relative to
      Lots =                getLotSize(sym, moneyManagement, SL)   ;
      if(IsTradeAllowed())
        {
         switch(zone.execution_style)
           {
            case INSTANT :
               ticket = myOrderSend(sym, OP_BUY, price, Lots, "ZONES EA -->@BUY " +
                                    (string)MarketInfo(sym, MODE_ASK), SL, TP);
               break;
            case ADVANCED:
               ticket = myOrderSend(sym, OP_BUYSTOP, price, Lots, "ZONES EA -->@BUYSTOP" +
                                    (string)MarketInfo(sym, MODE_ASK), SL, TP);
               break;
           }
         if(ticket <= 0)
            return;
        }
      else //not autotrading => only send alert
         myAlert("order", "");
      myOrderModify(sym, ticket, SL, TP);
     }
   else
      if(ea_trade_mode == SELLING_MODE && OrdersTotal() < MaxOpenTrades && OrdersTotal() <= MaxShortTrades && AccountEquity() >= AccountBalance())
        {
         RefreshRates();
         double price = Bid;
         SL = price + stoploss * MarketInfo(sym, MODE_POINT); //Stop Loss = value in points (relative to price)
         TP = price - takeprofit * MarketInfo(sym, MODE_POINT); //Take Profit = value in points (relative to
         Lots =               getLotSize(sym, moneyManagement, SL)    ;
         printf("SL: " + (string)SL + "TP: " + (string)TP + "   lot :" + (string)Lots);
         if(IsTradeAllowed())
           {
            switch(zone.execution_style)
              {
               case INSTANT :
                  ticket = myOrderSend(sym, OP_SELL, price, Lots, "ZONES EA -->@Sell " +
                                       (string)MarketInfo(sym, MODE_BID), SL, TP);
                  break;
               case ADVANCED:
                  ticket = myOrderSend(sym, OP_SELLSTOP, price, Lots, "ZONES EA -->@SellSTOP" +
                                       (string)MarketInfo(sym, MODE_BID), SL, TP);
                  break;
              }
            if(ticket <= 0)
               return;
           }
         else //not autotrading => only send alert
           {
            myAlert("order", "");
            myOrderModify(sym, ticket, SL, TP);
           }
        }
  }
//+------------------------------------------------------------------+
//|                     IntradayTrading                                             |
//+------------------------------------------------------------------+
void IntradayTrading(ZONES &zone)
  {
   int ticket = -1;
   double price = 0;
   double TradeSize = 0;
   double SL = 0;
   double TP = 0 ;
//LOCAL TRADES EXECUTION
   if(zone.types == "mainzones")
     {
      stoploss = 200;
      takeprofit = 500;
     }
   string sym = zone.symbol;
   if(ea_trade_mode == BUYING_MODE && OrdersTotal() < MaxOpenTrades && OrdersTotal() <= MaxShortTrades && AccountEquity() >= AccountBalance())
     {
      int count = 0;
      double priceMemo = 0;
      double profit = OrderProfit();
      TrailingStopBE(zone.symbol, OP_BUY, BreakEven_Points * myPoint, 0); //Trailing Stop = go break even
      //Open Buy Order, instant signal is tested first
      RefreshRates();
      price = MarketInfo(sym, MODE_ASK);
      SL = price - stoploss * MarketInfo(sym, MODE_POINT); //Stop Loss = value in points (relative to price)
      TP = price + takeprofit * MarketInfo(sym, MODE_POINT); //Take Profit = value in points (relative to
      Lots =                getLotSize(sym, moneyManagement, SL)    ;
      if(IsTradeAllowed())
        {
         switch(zone.execution_style)
           {
            case INSTANT :
               ticket = myOrderSend(sym, OP_BUY, price, Lots, "ZONES EA -->@Sell " +
                                    (string)MarketInfo(sym, MODE_ASK), SL, TP);
               break;
            case ADVANCED:
               ticket = myOrderSend(sym, OP_BUYSTOP, price, Lots, "ZONES EA -->@BuySTOP" +
                                    (string)MarketInfo(sym, MODE_ASK), SL, TP);
               break;
           }
         if(ticket <= 0)
            return;
         else //not autotrading => only send alert
            myAlert("order", "");
         myOrderModify(sym, ticket, SL, TP);
        }
     }
   else
      if(ea_trade_mode == SELLING_MODE && OrdersTotal() < MaxOpenTrades && OrdersTotal() <= MaxShortTrades && AccountEquity() >= AccountBalance())
        {
         RefreshRates();
         price = MarketInfo(sym, MODE_BID);
         SL = price + stoploss * MarketInfo(sym, MODE_POINT); //Stop Loss = value in points (relative to price)
         TP = price - takeprofit * MarketInfo(sym, MODE_POINT); //Take Profit = value in points (relative to
         Lots =              getLotSize(sym, moneyManagement, SL)   ;
         printf("SL: " + (string)SL + "TP: " + (string)TP + "   lot :" + (string)Lots);
         if(Lots <= 0)
            return;
         if(IsTradeAllowed())
           {
            switch(zone.execution_style)
              {
               case INSTANT :
                  ticket = myOrderSend(sym, OP_SELL, price, Lots, "ZONES EA -->@Sell " +
                                       (string)MarketInfo(sym, MODE_BID), SL, TP);
                  break;
               case ADVANCED:
                  ticket = myOrderSend(sym, OP_SELLSTOP, price, Lots, "ZONES EA -->@SellSTOP" +
                                       (string)MarketInfo(sym, MODE_BID), SL, TP);
                  break;
              }
            if(ticket <= 0)
               return;
           }
         else //not autotrading => only send alert
           {
            myAlert("order", "");
            myOrderModify(sym, ticket, SL, TP);
           }
        }
////Close Long Positions, instant signal is tested first
//   if(Cross(1, Resistance(sym,1 * 60, false, 00, 00, true, 0) < Resistance(sym,1 * 86400, false, 00, 00, true, 0)) //Resistance crosses below Resistance
//     )
//     {
//      if(IsTradeAllowed())
//         myOrderClose(sym, OP_BUY, 100, "");
//      else //not autotrading => only send alert
//         myAlert("order", "");
//     }
////Close Short Positions, instant signal is tested first
//   if(Cross(0, Support(sym,1 * 60, false, 00, 00, true, 0) > Support(sym,1 * 86400, false, 00, 00, true, 0) && AccountInfoDouble(ACCOUNT_MARGIN_FREE) > 0) //Support crosses above Support
//     )
//     {
//      if(IsTradeAllowed())
//         myOrderClose(sym, OP_SELL, 100, "");
//      else //not autotrading => only send alert
//        { myOrderModify(sym, ticket, SL, TP);}
//     }
  }


//+------------------------------------------------------------------+
//|                  TradeDays                                                |
//+------------------------------------------------------------------+
bool TradeDays()
  {
   if(SET_TRADING_DAYS == no)
      return(true);
   bool ret = false;
   int today = DayOfWeek();
   if(EA_START_DAY < EA_STOP_DAY)
     {
      if(today > EA_START_DAY && today < EA_STOP_DAY)
         return(true);
      else
         if(today == EA_START_DAY)
           {
            if(TimeLocal() >= datetime(StringToTime(EA_START_TIME)))
               return(true);
            else
               return(false);
           }
         else
            if(today == EA_STOP_DAY)
              {
               if(TimeLocal() < datetime(StringToTime(EA_STOP_TIME)))
                  return(true);
               else
                  return(false);
              }
     }
   else
      if(EA_STOP_DAY < EA_START_DAY)
        {
         if(today > EA_START_DAY || today < EA_STOP_DAY)
            return(true);
         else
            if(today == EA_START_DAY)
              {
               if(TimeLocal() >= datetime(StringToTime(EA_START_TIME)))
                  return(true);
               else
                  return(false);
              }
            else
               if(today == EA_STOP_DAY)
                 {
                  if(TimeLocal() < datetime(StringToTime(EA_STOP_TIME)))
                     return(true);
                  else
                     return(false);
                 }
        }
      else
         if(EA_STOP_DAY == EA_START_DAY)
           {
            datetime st = (datetime)StringToTime(EA_START_TIME);
            datetime et = (datetime)StringToTime(EA_STOP_TIME);
            if(et > st)
              {
               if(today != EA_STOP_DAY)
                  return(false);
               else
                  if(TimeLocal() >= st && TimeLocal() < et)
                     return(true);
                  else
                     return(false);
              }
            else
              {
               if(today != EA_STOP_DAY)
                  return(true);
               else
                  if(TimeLocal() >= et && TimeLocal() < st)
                     return(false);
                  else
                     return(true);
              }
           }
   return (ret);
  }

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


//
////+------------------------------------------------------------------+
////| Script program start database on mysql                                   |
////+------------------------------------------------------------------+
void Mysql(int i, datetime date, string symbol, int time_frame, double open, double close, double high,
           double  low, double volume)
  {
   string Host = "localhost", Database, User = "root", Password = "Bigboss307#"; // database credentials
   int Port, ClientFlag;
   int DB; // database identifier
   Print(MySqlVersion());
//INI = TerminalPath() + "\\MQL4\\Scripts\\MyConnection.ini";
// reading database credentials from INI file
   Host = "localhost";
   User = "root";
   Password = "Bigboss307#";
   Database = "zones";
   Port     = StrToInteger(ReadIni(INI, "MYSQL", "Port"));
   string socket   = ReadIni(INI, "MYSQL", "Socket");
   ClientFlag = CLIENT_MULTI_STATEMENTS; //StrToInteger(ReadIni(INI, "MYSQL", "ClientFlag"));
   Print("Host: ", Host, ", User: ", User, ", Database: ", Database);
// open database connection
   Print("Connecting...");
   DB = MySqlConnect(Host, User, Password, Database, Port, socket, ClientFlag);
   if(DB == -1)
     {
      MessageBox("Connection failed! Error: " + MySqlErrorDescription, "MYSQL", 1);
     }
   else
     {
      Print("Connected to # " + Database, DB);
     }
   string Query;
   Query = "CREATE DATABASE  IF NOT EXIST " + Database + "  ;";
   MySqlExecute(DB, Query);
   Query = "USE DATABASE " + Database + ";";
   MySqlExecute(DB, Query);

   Query = "CREATE TABLE   IF NOT EXISTS `account` (id int AUTO_INCREMENT PRIMARY KEY,time datetime, account_number int ,username varchar(255), password varchar(255),  server varchar(255) );";
   if(MySqlExecute(DB, Query))
     {
      Print("Succeeded!  account   created.");
     }
   else
     {
      Print("Error of multiple statements: ", MySqlErrorDescription);
     }
   Query = "INSERT INTO `account` (time,account_number,username,password,server) VALUES (\'"
           + (string)TimeLocal() + "\',\'" + account_number + "\',\'" + username + "\',\'" + password + "\',\'" + server
            + "\');";
       if(MySqlExecute(DB, Query))
     {
      Print("Table `account data` saved.");
     }
   else
     {
      Print("Error: ", MySqlErrorDescription);
      Print("Query: ", Query);
     }
   Query = "CREATE TABLE IF NOT EXISTS `bar_data`  ( id int AUTO_INCREMENT PRIMARY KEY," +
           "time datetime,symbol varchar(255), time_frame int,open double,close double ,high double,low double,volume int  " + ");";
   if(MySqlExecute(DB, Query))
     {
      Print("Table `bar_data` created.");
     }
   else
     {
      Print("Error: ", MySqlErrorDescription);
      Print("Query: ", Query);
     }
   datetime time = Time[i - 1];
   date = time;
   Query = "INSERT INTO `bar_data` (time ,symbol,time_frame,open,close,high,low,volume)" +
   "VALUES (\'" + (string)date + "\',\'" + symbol + "\',\'" + time_frame + "\',\'" + open + "\',\'" + close + "\',\'"
    + high + "\',\'" + low + "\',\'" + volume  + "\');";
   if(MySqlExecute(DB, Query))
     {
      Print("bars Data  saved.");
     }
   else
     {
      Print("Error  bar_data of multiple statements: ", MySqlErrorDescription);
     }


     Query = "CREATE TABLE IF NOT EXISTS symbols  ( id int AUTO_INCREMENT PRIMARY KEY,  symbol varchar(255) );";



     if(MySqlExecute(DB, Query))
     {
      Print("symbols   created.");
     }
   else
     {
      Print("Error of multiple statements: ", MySqlErrorDescription);
     }
    int count=0;
    count++;
    if(count==1){
     for(int k=0;k<SymbolsTotal(false);k++){



      Query = "INSERT INTO `symbols` (symbol) VALUES (\'"+SymbolName(k,false)   + "\');";

     if(MySqlExecute(DB, Query))
     {
      Print("Succeeded!  symbols Data  saved.");
     }
   else
     {
      Print("Error of multiple statements: ", MySqlErrorDescription);
     }}
     }










   MySqlDisconnect(DB);
   Print("Disconnected.  done!");
  }
//+------------------------------------------------------------------+
int Authentication(string usernameX, string passwordX, string account_numberX, ENUM_LICENSE_TYPE licenseTypeX,
                   string licensekeyX, string serverX)
  {
   if(!AccountInfoInteger(ACCOUNT_TRADE_ALLOWED))
     {
      MessageBox("Trading is forbidden for this account " + (string)AccountInfoInteger(ACCOUNT_LOGIN)
                 +
                 ".\n Perhaps an investor password has been used to connect to the trading account."
                 +
                 "\n Check the terminal journal for the following entry:" +
                 (string)AccountInfoInteger(ACCOUNT_LOGIN) + "\': Trading has been disabled - investor ", NULL, 1);
      return INIT_FAILED;
     }
   if(auth((string)account_number, password, AccountServer()) && TerminalInfoInteger(TERMINAL_CONNECTED))
     {
      if(!TerminalInfoInteger(TERMINAL_TRADE_ALLOWED))
        {
         MessageBox("PLEASE ALLOW AUTO TRADING ..!", "SETTING", 1);
        }
      else
         //START TRADING
         Comment("=============== ******* WELCOME TO ZONES **********    =========== \n We are now trading...");
     }
   else
     {
      Comment("YOU ARE NOT CONNECTED...!A valid account number or password is required...!");
      return  INIT_FAILED;
     }
   return  INIT_SUCCEEDED;
  }


//-
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MM_Size(double SL) //Risk % per trade, SL = relative Stop Loss to calculate risk
  {
   double MaxLot = MarketInfo(Symbol(), MODE_MAXLOT);
   double MinLot = MarketInfo(Symbol(), MODE_MINLOT);
   double tickvalue = MarketInfo(Symbol(), MODE_TICKVALUE);
   double ticksize = MarketInfo(Symbol(), MODE_TICKSIZE);
   double lots = mainzones.risk_percentage * 1.0 / 100 * AccountBalance() / (SL / ticksize * tickvalue);
   if(lots > MaxLot)
      lots = MaxLot;
   if(lots < MinLot)
      lots = MinLot;
   return(lots);
  }

////////////////////////////////////////////////////////////////////////
void timelockaction(void)
  {
   if(TradeDays())
      return;
   double stoplevel = 0, proffit = 0, newsl = 0, price = 0;
   double ask = 0, bid = 0;
   string sy = NULL;
   int sy_digits = 0;
   double sy_points = 0;
   bool ans = false;
   bool next = false;
   int otype = -1;
   int kk = 0;
   int i = OrdersTotal();
   while(i > 0)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderMagicNumber() != MagicNumber)
         continue;
      next = false;
      ans = false;
      sy = OrderSymbol();
      ask = SymbolInfoDouble(sy, SYMBOL_ASK);
      bid = SymbolInfoDouble(sy, SYMBOL_BID);
      sy_digits = (int)SymbolInfoInteger(sy, SYMBOL_DIGITS);
      sy_points = SymbolInfoDouble(sy, SYMBOL_POINT);
      stoplevel = MarketInfo(sy, MODE_STOPLEVEL) * sy_points;
      otype = OrderType();
      proffit = OrderProfit() + OrderSwap() + OrderCommission();
      newsl = OrderOpenPrice();
      switch(EA_TIME_LOCK_ACTION)
        {
         case closeall:
            if(otype > 1)
              {
               while(kk < 5 && !OrderDelete(OrderTicket()))
                 {
                  kk++;
                 }
              }
            else
              {
               price = (otype == OP_BUY) ? bid : ask;
               while(kk < 5 && !OrderClose(OrderTicket(), OrderLots(), price, 10))
                 {
                  kk++;
                  price = (otype == OP_BUY) ? MarketInfo(sy, MODE_BID) : MarketInfo(sy, MODE_ASK);
                 }
              }
            break;
         case closeprofit:
            if(proffit <= 0)
               break;
            else
              {
               price = (otype == OP_BUY) ? bid : ask;
               while(otype < 2 && kk < 5 && !OrderClose(OrderTicket(), OrderLots(), price, 10))
                 {
                  kk++;
                  price = (otype == OP_BUY) ? MarketInfo(sy, MODE_BID) : MarketInfo(sy, MODE_ASK);
                 }
              }
            break;
         case breakevenprofit:
            if(proffit <= 0)
               break;
            else
              {
               price = (otype == OP_BUY) ? bid : ask;
               while(otype < 2 && kk < 5 && MathAbs(price - newsl) >= stoplevel && !OrderModify(OrderTicket(), newsl, newsl, OrderTakeProfit(), OrderExpiration()))
                 {
                  kk++;
                  price = (otype == OP_BUY) ? MarketInfo(sy, MODE_BID) : MarketInfo(sy, MODE_ASK);
                 }
              }
            break;
        }
      continue;
     }
  }


//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
