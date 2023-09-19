//+------------------------------------------------------------------+
//|                                TRADEEXPERT_INPUTS_PARAMETRES.mqh |
//|                         Copyright 2022, nguemechieu noel martial |
//|                       https://github.com/nguemechieu/TradeExpert |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, nguemechieu noel martial"
#property link      "https://github.com/nguemechieu/TradeExpert"
#property strict
#include <DiscordTelegram/Comment.mqh>

#include <DiscordTelegram/TradeExpert_Variables.mqh>


#include <DiscordTelegram/Enums.mqh>
 


#include <DiscordTelegram/TradeExpert_Library.mqh>
#include<DiscordTelegram/TRADE_DATA.mqh>




#include <DiscordTelegram/createObjects.mqh>
#include <Coinbase.mqh>


#include <DiscordTelegram/result.mqh>
#include <DiscordTelegram/News.mqh>


#include <DiscordTelegram/TradeSignal.mqh>

#include <DiscordTelegram/BinanceUs.mqh>
   #include <DiscordTelegram\Telegram.mqh>
   #include <DiscordTelegram/Trade.mqh>
CArrayString UsedSymbols[100];
  ENUM_TIMEFRAMES indicatorTimeFrame[];
  ENUM_RUN_MODE  run_mode;
datetime       time_check;
int            web_error;
int            init_error;

enum ExchangeName {
BINANCE_US,BINANCE_COM,COINBASECOM,PRO_COINBASE,KRANKEN

}
;

//+------------------------------------------------------------------+


ENUM_LANGUAGES ENGLISH=LANGUAGE_EN;


//+----------


// ENUM TYPES DEFINE
  enum ENUM_TRADE_REPORT {

DAILY_REPORT=0,//DAILY REPORT
WEEKLY_REPORT=1,//WEEKLY REPORT
MONTHLY_REPORT=2,//MONTHLY REPORT
YEARLY_REPORT=3//ANNUAL REPORT
};



 enum ENUM_CROSSING_MODE
  {
   T3CrossingSnake,
   SnakeCrossingT3
  };



enum ENUM_CLOSE_BUTTON_TYPES
  {
   CloseBuy          = 0,
   CloseSell         = 1,
   CloseProfit       = 2,
   CloseLoss         = 3,
   ClosePendingLimit = 4,
   ClosePendingStop  = 5,
   CloseAll          = 6
  };



enum ENUM_TYPE_OF_ENTRY
  {
   With_Trend,//Change With_Trend
   When_Trend_Change//Change when Trend Changed
  };


enum ENUM_TRADE_CLOSE_MODE
  {
   CloseOnReversedSignal,//Close On Reversed Signal,

   CloseUsingTP_SL//Close Using TakeProfit or StopLoss

  };


struct STRUCT_SIGNAL
  {
   datetime          date; //--- datetime of signal generation
   int               type;    //--- -1 or OP_XXX types after indicator typeofentry validation
   bool              active; //--- true while no trade triggered from this signal
   int               count;   //--- total valid signals encountered : when indicator type of entry is When_Trend_Changed
   // signals are taken into account when count >=2
   int               current_type; //--- current signal
   int               previous_type; //--- previous valid signal
  };
   


  
struct STRUCT_SYMBOL_SIGNAL
  {
   string            symbol; //--- symbol which generated the signal
   int               type;      //--- -1 or OP_XXX types
   double            stop;   //--- stop distance
   double            tp;     //--- tp distance
   double            volume; //--- initial volume
   int               not;       //--- number of trades
   bool              done;     //--- used signal
  };


enum Platform {TELEGRAM,FACEBOOK,DISCORD,TWITTER};
 
 string m_symbol;
string myMessage;


enum MARKET_TYPES
  {

   FOREX, STOCK, ETF, CRYPTO_CURRENCY

  };

enum TRADE_STYLES { LONG,//Long Only
                    SHORT,// Short Only

                    BOTH// Long And Short

                  };

enum TRADEMODE {AutoTrade,// Trade Automatic
                Manual, // Trade Manual

                Signal_Only,// Signal Only No Trading

                None // Neutral

               };

enum  ORDERS_TYPE { MARKET_ORDERS,// MARKET ORDER
                    LIMIT_ORDERS,//LIMIT ORDER

                    STOP_ORDERS//STOP ORDER

                  };


enum Answer {No,//NO,
             Yes//YES
            };




string eacomment;
int TSa=0;


enum MONTH_WEEK{january,february,march ,april,may,juin,july,august,september,october,november,december
};
//--- ind8: HMA nrp alerts + arrows
enum enPrices
  {
   pr_close,      // Close
   pr_open,       // Open
   pr_high,       // High
   pr_low,        // Low
   pr_median,     // Median
   pr_typical,    // Typical
   pr_weighted,   // Weighted
   pr_average,    // Average (high+low+open+close)/4
   pr_medianb,    // Average median body (open+close)/2
   pr_tbiased,    // Trend biased price
   pr_tbiased2,   // Trend biased (extreme) price
   pr_haclose,    // Heiken ashi close
   pr_haopen,     // Heiken ashi open
   pr_hahigh,     // Heiken ashi high
   pr_halow,      // Heiken ashi low
   pr_hamedian,   // Heiken ashi median
   pr_hatypical,  // Heiken ashi typical
   pr_haweighted, // Heiken ashi weighted
   pr_haaverage,  // Heiken ashi average
   pr_hamedianb,  // Heiken ashi median body
   pr_hatbiased,  // Heiken ashi trend biased price
   pr_hatbiased2  // Heiken ashi trend biased (extreme) price
  };
//--- ind8: HMA nrp alerts + arrows
enum enMaTypes
  {
   ma_sma,    // Simple moving average
   ma_ema,    // Exponential moving average
   ma_smma,   // Smoothed MA
   ma_lwma,   // Linear weighted MA
   ma_tema    // Triple exponential moving average - TEMA
  };
//--- ind8: HMA nrp alerts + arrows
enum enDisplay
  {
   en_lin,  // Display line
   en_lid,  // Display lines with dots
   en_dot   // Display dots
  };
//------------------------------------

enum ENUM_INDICATOR_SIGNAL
  {
   SellSignal =-1,
   NoSignal   = 0,
   BuySignal  = 1
  };

int TO=0,TB=0,TS=0;
enum profittype
  {
   InCurrencyProfit = 0,                                    // In Currency
   InPercentProfit = 1                                      // In Percent
  };

enum losstype
  {
   InCurrencyLoss = 0,                                      // In Currency
   InPercentLoss = 1                                        // In Percent
  };


enum indi
  {
   Off=0,          // OFF
   hma_trend=1,//Hma-trend
   beast=2,        // Beast

   uni_cross=3,          // Uni Cross
   zig_Zag_Pointer=4,    // Zig Zag Pointer
   Triggerline=5    // Trigger
  };




enum caraclose
  {
   opposite = 0,   // Indicator Reversal Signal
   sltp = 1,       // Take Profit and Stop Loss
   bar = 2,       // Close With N Bar
   date = 3       // Close With Date
  };
enum DYS_WEEK
  {
   Sunday=0,//sunday
   Monday=1,//monday
   Tuesday=2,//tuesday
   Wednesday=3,//wednesday
   Thursday=4,//thursday
   Friday=5,//friday
   Saturday=6//saturday
  };

enum md
  {
   nm=0, //NORMAL
   rf=1, //REVERSE
  };


enum ENUM_UNIT
  {
   InPips,                 // SL in pips
   InDollars               // SL in dollars
  };

enum TIME_LOCK
  {
   closeall,//CLOSE_ALL_TRADES
   closeprofit,//CLOSE_ALL_PROFIT_TRADES
   breakevenprofit//MOVE_PROFIT_TRADES_TO_BREAKEVEN
  };







#define MA1          (1)
#define MA2          (2)
#define AMA1         (3)
#define AMA2         (4)

enum  TRADE_PAIRS { ALL_PAIRS,  SINGLE_PAIR,CUSTOM_PAIRS};


enum MONEYMANAGEMENT { FIXED_SIZE =0, //Fix trade  Size
                       Risk_Percent_Per_Trade =1,// Risk Percent %
                       POSITION_SIZE=2, //Position Size
                       MARTINGALE_OR_ANTI_MATINGALE=3,//Martingale or Antimartingale
                       MARTINEGALE_STEPPING=4, // Martingale Stepping
                       LOT_OPTIMIZE=5,//Lot Optimize
                     Market_Volume_Risk =6//Market_Volume_Risk
                     };
enum TRADE_STRATEGY{separate ,joint,MA,RSI,CCI,Fractal,Accumulation,SupplyDemand,none};



string msgs;

STRUCT_SYMBOL_SIGNAL ManualSignals[];


//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+



//+------------------------------------------------------------------------------+
//|                        DEFINE  EA parameters                                                      |
//+------------------------------------------------------------------------------+

#define  SEPARATOR "---------------------------"


input const string  menu0="========= User  Configuration  ============";

input ENUM_LANGUAGES InpLanguage=LANGUAGE_EN;
ENUM_LANGUAGES m_lang=InpLanguage;

//====================  USER PARAMETERS ======================

input ENUM_LICENSE_TYPE LicenseMode=LICENSE_DEMO;//EA License Mode
input string License="none";// EA License




string EA_Name="TFM EA v4.00";

extern string     conctact          = "===== For enquiries Contact +13023176610 on WhatApps or telegram====="; //====Contact NGUEMECHIEU@LIVE.COM=====
extern int        MT4account        = 1234567;     // MT4 Number/ Pascode


input const string  menu2="========= Trading Time Configuration  ============";

input Answer UseTime=No;
int offset=(int)(TimeCurrent()-TimeLocal());//Auto GMT Shift
extern int NextOpenTradeAfterBars = 12; //Next open trade after time
extern int TOD_From_Hour = 09; //Time of the day (from hour)
extern int TOD_From_Min = 45; //Time of the day (from min)
extern int TOD_To_Hour = 16; //Time of the day (to hour)
extern int TOD_To_Min = 15; //Time of the day (to min)
extern bool TradeMonday = true;
extern bool TradeTuesday = true;
extern bool TradeWednesday = true;
extern bool TradeThursday = true;
extern bool TradeFriday = true;
extern bool TradeSaturday = true;
extern bool TradeSunday = true;
extern int MaxTradeDurationBars = 12; //Maximum trade duration
input const string  menu3="========= Trade symbols&& size Configuration  ============";
//input ENUM_SYMBOLS_MODE InpModeUsedSymbols   =  SYMBOLS_MODE_CURRENT;   // Mode of used symbols list
input const  string            InpUsedSymbols       ="AUDCAD,AUDCHF,AUDHKD,AUDJPY,AUDNZD,AUDSGD,AUDUSD,CADCHF,CADHKD,CADJPY,CADSGD,EURCHF,EURCZK,EURDKK,EURGBP,EURHKD,EURHUF,EURJPY,EURNOK,EURNZD,EURPLN,EURSEK,EURSGD,EURTRY,EURUSD,EURZAR,GBPAUD,GBPCAD,GBPCHF,GBPHKD,GBPJPY,GBPNZD,GBPPLN,GBPSGD,GBPUSD,GBPZAR,HKDJPY,NZDCAD,NZDCHF,NZDHKD,NZDJPY,NZDSGD,NZDUSD,SGDCHF,SGDJPY,TRYJPY,USDCAD,USDCHF,USDCNH,USDCZK,USDDKK,USDHKD,USDHUF,USDJPY,USDMXN,USDNOK,USDPLN,USDSEK,USDSGD,USDTHB,USDTRY,USDZAR,ZARJPY";  // Trading pairs (comma - separator)
input string InpCryptoSymbol="BTCUSD,ETHUSD,XLMUSD,RLCUSD,XRPUSD,LRCUSD,LTCUSD";
input string newsUrl="https://nfs.faireconomy.media/ff_calendar_thisweek.json?version=42067daf92ce0d4cd7ccc0c9e3015d30";//News url (json)
input Answer UseAllsymbol=Yes;//Use All symbols  ?(true/false)
input string sdf="=== Schedule Trade Symbols ===";
input Answer InpSelectPairs_By_Basket_Schedule =No;//Select Pairs By Schedule Time
input  string  symbolList1="USDCAD,EURUSD,AUDUSD";//BASKET LIST 1;
input datetime start1=D'2021.01.19 04:00';
input datetime stop1=D'2025.01.19 06:00';
input const string symbolList2="EURGBP,AUDCAD";//BASKET LIST 2;
input datetime start2=D'2022.01.19 09:00';
input datetime stop2=D'2025.01.20 11:00';
input  string symbolList3="USDJPY,AUDJPY";//BASKET LIST 3;
input  datetime start3=D'2022.01.18 14:00';
input datetime stop3=D'2025.01.18 15:00';

extern bool                   ShowDashboard = true;
input ENUM_MODE               SelectedMode = COMPACT; /*Dashboard (Size)*/


extern int        minbalance        =10;           //Min Equity Balance IN USD
double inpReqEquity                       = minbalance;                   // Min. Required Equity
input MONEYMANAGEMENT InpMoneyManagement=Risk_Percent_Per_Trade;


input string M1="==== Fix Size ========";
input double Fixed_size=0.01; //Fix Lot
input string  M2="======= Lot Optimize =========";
input double InpLot=0.01;//Lot
extern double     SubLots           = 0.02;        //Sub Lots
input double MaximumRisk             = 0.08;           // MaximumRisk
input double DecreaseFactor          = 3;              // DecreaseFactor
extern double     Lots              = 0.05;        //First Lots
extern double     Risk              = 10;           // Risk Percent

input string M3="===== Risk % Per Trade ========";
 double   Risk_Percentage=Risk; // Risk %
input string M4="==== POSITION SIZE ==========";
input double  Position_size=3000; //Position Size EXAMPLE LOT :5000
input string M5="===MARTINGALE /ANTIMARTINGALE===============";
extern double MM_Martingale_Start = 0.1;
extern double MM_Martingale_ProfitFactor = 1;
extern double MM_Martingale_LossFactor = 2;
extern bool MM_Martingale_RestartProfit = true;
extern bool MM_Martingale_RestartLoss = false;
extern int MM_Martingale_RestartLosses = 2;
extern int MM_Martingale_RestartProfits = 3;

input const string  menu4="========= Advance News trade Setting ============";

//--- input parameters 
input Answer sendnews=Yes;
input Answer sendorder =Yes;
input Answer sendclose=Yes;//Send order close msgs
input Answer InpTradeNews=Yes;// Allow Trade news
input bool sendcontroltrade=true;//Send Trade Advises messages
input bool showoverbought =true;//Send ov bought or ov sell


int Now=0;
datetime LastUpd=0;
string str1;
extern const string commen           ="==================="; // =========IN THE NEWS FILTER==========
extern bool    AvoidNews            = true;                // News Filter
extern bool    CloseBeforNews       = true;                // Close and Stop Order Before News


extern  int    AfterNewsStop        =59;                    // Stop Trading Before News Release (in Minutes)
extern  int    BeforeNewsStop       =59;                    // Start Trading After News Release (in Minutes)
extern bool    NewsLight            = true;                // Low Impact
extern bool    NewsMedium           = true;                // Middle News
extern bool    NewsHard             = true;                 // High Impact News
input  bool    NewsTunggal          =true; // Enable Keyword News
extern string  judulnews            ="FOMC"; // Keyword News
input int   Style          = 2;          // Line style
input int   Upd            = 86400;      // Period news updates in seconds
bool NewsFilter = FALSE;
bool  Vtunggal       = false;
bool  Vhigh          = false;
bool  Vmedium        = false;
bool  Vlow           = false;


extern string  NewsSymb             ="USD,EUR,GBP,CHF,CAD,AUD,NZD,JPY"; //Currency to display the news  
extern bool    CurrencyOnly         = false;                 // Only the current currencies
extern bool    DrawLines            = true;                 // Draw lines on the chart
extern bool    Next                 = false;                // Draw only the future of news line
input  bool    Signal               = false;                // Signals on the upcoming news
extern string noterf          = "-----< Other >-----";//=========================================

input  string  menu5="========= Trade Setting ============";

input MARKET_TYPES InpMarket_Type= FOREX;//MARKET TYPE;
input ExchangeName exchange;
input string api_key="2032573404:AAEfu_tvVukCibiYf8uUdi6NcDpSmbuj3Tg";
input string secret_key;
input string pUsername="nguemechieu@live.com";
input string pPasword="Bigboss307#";
extern TRADEMODE  inpTradeMode           = AutoTrade;        // Trade Mode
extern ORDERS_TYPE Order_Type= MARKET_ORDERS;
input TRADE_STYLES inpTradeStyle=BOTH;
input double inpMaxSpread=10;//MAX SPREAD

//--- input variables
input int          InpMagic             =  123;  // Magic number
input double            InpLots              =  0.01;  // Lots
input uint              InpStopLoss          =  50;   // StopLoss in points
input uint              InpTakeProfit        =  50;   // TakeProfit in points
input uint              InpDistance          =  50;   // Pending orders distance (points)
input uint              InpDistanceSL        =  50;   // StopLimit orders distance (points)
input uint              InpSlippage          =  0;    // Slippage in points
input double            InpWithdrawal        =  10;   // Withdrawal funds (in tester)
input uint              InpButtShiftX        =  40;   // Buttons X shift 
input uint              InpButtShiftY        =  10;   // Buttons Y shift 
input uint              InpTrailingStop      =  50;   // Trailing Stop (points)
input uint              InpTrailingStep      =  20;   // Trailing Step (points)
input uint              InpTrailingStart     =  0;    // Trailing Start (points)
input uint              InpStopLossModify    =  20;   // StopLoss for modification (points)
input uint              InpTakeProfitModify  =  60;   // TakeProfit for modification (points)

input bool UsePartialClose                      = true;                  // Use Partial Close
input ENUM_UNIT PartialCloseUnit                = InPips;             // Partial Close Unit
input double PartialCloseTrigger                = 40;                    // Partial Close after
input double PartialClosePercent                = 0.5;                   // Percentage of lot size to close
input int MaxNoPartialClose                     = 1;                     // Max No of Partial Close
input string ___TRADE_MONITORING_TRAILING___    = "";                    // - Trailing Stop Parameters
input bool UseTrailingStop                      = true;                  // Use Trailing Stop
input ENUM_UNIT TrailingUnit                    = InPips;             // Trailing Unit
input double TrailingStart                      = 35;                   // Trailing Activated After
input double TrailingStep                       = 10;                   // Trailing Step
input double TrailingStop                       = 2;                    // Trailing Stop
input string ___TRADE_MONITORING_BE_________    = "";                    // - Break Even Parameters
input bool UseBreakEven                         = true;                  // Use Break Even
input ENUM_UNIT BreakEvenUnit                   = InPips;             // Break Even Unit
input double BreakEvenTrigger                   = 30;                   // Break Even Trigger
input double BreakEvenProfit                    = 1;                   // Break Even Profit
input int MaxNoBreakEven                        = 1;                     // Max No of Break Even
extern Answer     DeletePendingOrder       = Yes;          //Delete Pending Order
extern int        orderexp          = 43;           //Pending order Experation (inBars)
extern caraclose  closetype         = opposite;        //Choose Closing Type

extern bool        OpenNewBarIndicator           = true;        //Open New Bar Indicator

input bool DebugTrailingStop         = true;           // Trailing Stop Infos in Journal
input bool DebugBreakEven            = true;           // Break Even Infos in Journal
input bool DebugUnit                 = true;           // SL TP Trail BE Units Infos in Journal (in tester)
input bool DebugPartialClose         = true;           // Partial close Infos in Journal
input Answer UseFibo_TP=Yes;//Use Fibo take profit?(Yes/No)
//extern bool     snr           = TRUE;           //Use Support & Resistance
extern bool    showfibo       = true;           // Show Fibo Line
extern bool Show_Support_Resistance=true;//Show Support & Resistance lines
extern  ENUM_TIMEFRAMES snrperiod     = PERIOD_M30;         //Support & Resistance Time Frame
extern Answer      sendTradesignal       = Yes; //Send Strategy Trade Signal
input int MagicNumber=3123456;//Magic Number
extern int MaxSlippage = 0; //Slippages
input ENUM_UNIT TakeProfitUnit       = InDollars;      // Take Profit Unit
extern double MaxTP = 40;//Take Profit Value
double inpTP= MaxTP;
input ENUM_UNIT StopLossUnit         = InDollars;      // Stop Loss Unit
input double MaxSL = 40;// Stop Loss Value
double inpSL                   = MaxSL;
double MinTP=MaxTP/2;
double MinSL=MaxTP/2;
extern bool closeTradesAtPL=false;//Use Close trade
extern double CloseAtPL = 50; //Close trade if total profit & loss exceed
extern double PriceTooClose =5; // Price to close
extern int  orderdistance     = 30;          //Order Distance
input ENUM_UNIT OrderDistanceUnit               = InPips; // Order Distance Unit
double inpStopDis = orderdistance; // Order Distance
input bool DeletePendingOrders = true;                  // Delete Pending Orders
input bool UseTrailingOrders=true;
input int inpPendingBar = 5;                     // Delete Pending After (bars)
extern int MaxOpenTrades = 12;//Maximum Open Trades
extern int MaxLongTrades = 5;//Max LongTrades
extern int MaxShortTrades = 5;// Max ShortTrades
extern int MaxPendingOrders = 5;//Max PendingOrders
extern int MaxLongPendingOrders = 5;//Max LongPendingOrders
double Trail_Above =TrailingStart;//Trailing above
double Trail_Step = TrailingStep;// Trailing steps
extern int MaxShortPendingOrders = 5;//Max ShortPendingOrders
extern int PendingOrderExpirationBars = 12; //pending order expiration
extern double DeleteOrderAtDistance = 100; //delete order when too far from current price
extern bool Hedging = true;//Allow  Hedging ?(true/false)
input int NextOpenTradeAfterMinutes=30;//Next Open Trade After ? Minutes
input int MaxTradeDurationHours =60;//Max Trade Duration in Hours
input int  PendingOrderExpirationMinutes=124;// Pending Order ExpirationMinutes
extern int OrderRetry = 5; //# Of retries if sending order returns error
extern int OrderWait = 5; //# Of seconds to wait if sending order returns error

input TIME_LOCK EA_TIME_LOCK_ACTION = closeprofit;// Time Lock Action
extern bool Send_Email = true; //Send email ?(true/false)
extern bool Audible_Alerts = true;
extern bool Push_Notifications = true;          
double xlimit=0,xstop=0,slimit=0,slstop=0,tplimit=0,tpstop=0;

int LotDigits; //initialized in OnInit
extern bool       BarBaru           = true;        //Open New Bar Indicator
extern   ORDERS_TYPE    Order_Types         = MARKET_ORDERS;      //Order Execution Mode 
extern bool    PendingOrderDeletes       = true;          //Delete Pending Order 
extern double     ProfitValue       = 30.0;         //Maximum Profit in %
input bool sendsupportandResisitance=true;
input string  ts1="=====  CHART  SETTINGS ===="; //===================


input string   lb_0              = "";                   // ------------------------------------------------------------
input string   lb_1              = "";                   // ------> PANEL SETTINGS
extern bool    ShowPanel         = true;                 // Show panel
input bool            AllowSubwindow    = false;                // Show Panel in sub window
extern ENUM_BASE_CORNER Corner   = 2;                    // Panel 
extern color   TitleColor        = C'46,188,46';         // Title color
extern bool    ShowPanelBG       = true;                 // Show panel backgroud
extern color   Pbgc              = C'25,25,25';          // Panel backgroud color
extern int     EventDisplay      = 10;                   // Hide event after (in minutes)
input string   lb_2              = "";                   // ------------------------------------------------------------
input string   lb_3              = "";                   // ------> SYMBOL SETTINGS

input bool     snr           = TRUE;           //Use Support & Resistance

extern double RiskPercent 	= 2.0;// risk for lot calculation according to the SL (for manual trading info)
extern int Offset				= -6;		// offset for arrows in pips
extern int BarsBack 			= 2000;
extern color InfoColor		= Snow;
extern string AlertSound = "alert.wav";
input bool KeyboardTrading = true; /*Keyboard Trading*/
input string h6      = "============================= Graphics ==========================";
input color COLOR_BORDER = C'255, 151, 25'; /*Panel Border*/
input color COLOR_CBG_LIGHT = C'252, 252, 252'; /*Chart Background (Light)*/
input color COLOR_CBG_DARK = C'28, 27, 26'; /*Chart Background (Dark)*/
//--- Global variables
input int ChartHigth =800;//Set chart hight
input int ChartWidth=1280;//Set Chart widht
input  color BearCandle=clrRed;
input color BullCandle=clrGreen;
input color Bear_Outline=clrWhite;
input color Bull_Outline=clrBlue;
input color BackGround;
input color ForeGround=clrDarkTurquoise;
extern string                                                        dff="TRADE OBJECTS SETTING";
extern color      color1            = clrGreenYellow;             // EA's name color
extern color      color2            = clrDarkOrange;             // EA's balance & info color
extern color      color3            = clrBeige;             // EA's profit color
extern color      color4            = clrMagenta;             // EA's loss color
extern color      color5            = clrBlue;          // Head Label Color
extern color      color6            = clrBlack;             // Main Label Color
extern int        Xordinate         = 20;                   // X
extern int        Yordinate         = 30;                   // Y


extern color _tableHeader=clrWhite;
extern color _Header = clrBlue;
extern color _SellSignal = clrRed;  //Sell Signal Color
extern color _BuySignal = clrBlue;//Buy Signal Color
extern color _Neutral = clrGray; //Neutral Signal Color
extern color _cSymbol = clrPowderBlue;//Symbol Signal Color
extern color _Separator = clrMediumPurple;

///////////////////////////////////////////////////
extern int Corners= 1;
extern int dys = 25;
extern string sss="";////////INDICATORRS PARAMETERS /////////////////////
input  string  menu6="========= Files Configurations ============";
input bool Report=true;
input ENUM_TRADE_REPORT InpTradeReport;
input  string  menu7="========= Indicators Configurations ============";
string prefix2 = "capital_";
input string           InpSignalList ="Triggerlines,TrendExpert,ZigZag";//Indicators List
               // Close Trade Strategy
input ENUM_TRADE_CLOSE_MODE inpTradeCloseMode   = CloseOnReversedSignal; // Trade Close Mode
input bool inpAligned =false; //Align Signal
input string ___GUI_MANAGEMENT___    = SEPARATOR;      //=== GUI Settings ===
input bool ShowTradedSymbols         = true;           // Display Traded Symbols Dashboard
input int PanelFontSize              = 12;             // Panel Font Size
input int TradedSymbolsFontSize      = 10;     
        // Traded Symbols Dashboard Font Size
input bool ShowIndicator1Panel       = true;           // Display information on indicators
input string inpComment              = "";             // COMMENT



enum mode_of_alert
 {
    E_MAIL,MOBILE,E_MAIL_AND_MOBILE
 };
extern mode_of_alert ALERT_MODE=E_MAIL;
//User Parameters
extern color fiboColor =clrBlue;
extern double fiboWidth = 1;
extern ENUM_LINE_STYLE fiboStyle = STYLE_DOT;
extern color unretracedZoneColor = Green;
extern bool showUnretracedZone = true;


 double FIBO_LEVEL_0=0.0;

 double FIBO_LEVEL_1=0.236;
 bool ALERT_ACTIVE_FIBO_LEVEL_1=true;

double FIBO_LEVEL_2=0.382;
 bool ALERT_ACTIVE_FIBO_LEVEL_2=true;
double FIBO_LEVEL_3=0.50;
bool ALERT_ACTIVE_FIBO_LEVEL_3=true;

 double FIBO_LEVEL_4=0.618;
  bool ALERT_ACTIVE_FIBO_LEVEL_4=true;

double FIBO_LEVEL_5=0.786;
bool ALERT_ACTIVE_FIBO_LEVEL_5=true;

 double FIBO_LEVEL_6=1.0;
 bool ALERT_ACTIVE_FIBO_LEVEL_6=true;

 double FIBO_LEVEL_7=1.214;
 bool ALERT_ACTIVE_FIBO_LEVEL_7=true;

 double FIBO_LEVEL_8=1.618;
bool ALERT_ACTIVE_FIBO_LEVEL_8=true;

 double FIBO_LEVEL_9=2.618;
 bool ALERT_ACTIVE_FIBO_LEVEL_9=true;
double FIBO_LEVEL_10=4.236;
 bool ALERT_ACTIVE_FIBO_LEVEL_10=true;
 