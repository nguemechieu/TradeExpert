
//+------------------------------------------------------------------+
//|                                                  TradeExpert.mq4 |
//|                        Copyright 2021, Noel Martial Nguemechieu. |
//|                     https://github.com/Bigbossmanger/TradeExpert |                                    |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021,Noel Martial Nguemechieu"
#property strict
#property link "https://github.com/Bigbossmanger/TradeExpert"
#property tester_file "trade.csv"    // file with the data to be read by an Expert Advisor TradeExpert_file "trade.csv"    // file with the data to be read by an Expert Advisor
#property icon "\\Images\\TradeExpert.ico"
#property tester_library "Libraries"
#property stacksize 23
#property  version "4.0" //EA VERSION 

//--- includes

#include <DoEasy\Engine.mqh>
#ifdef __MQL5__
#include <Trade\Trade.mqh>
CTrade         trade;
#endif
#include <Arrays\List.mqh>
#include <Arrays\ArrayString.mqh>
#include <DiscordTelegram/Comment.mqh>
#include <stdlib.mqh>
#include <stderror.mqh>
#define  NL "\n" // warning NL position order matter
#include <DiscordTelegram/Telegram.mqh>//control telegram
#include <DiscordTelegram/MyBot.mqh>//control bot
CEngine        engine;//create engine object
//--- input parameters
#define  EXPERT_NAME "TradeExpert"
#define SEPARATOR "________________"
#define JOB "97031"
#define EPOCH D'2020.01.01 00:00'
#define OBJPFX JOB"_"
#define MAX_CLOSE_BUTTONS 7
#define CLIENT_BG_X (20)
#define CLIENT_BG_Y (20)
#define TOTAL_OpenOrExit 2
#define TOTAL_IndicatorNum 32 // Total number of usable indicators
#define IndicatorName0 "OFF"//Is an empty indicator that return nothing
#define IndicatorName1 "hma-trend-indicator_new _build.ex4"
#define IndicatorName2 "Beast Super Signal.ex4"
#define IndicatorName3 "uni_cross.ex4"
#define IndicatorName4 "ZigZag_Pointer.ex4"
#define IndicatorName5 "Triggerlines.ex4"
#define IndicatorName6 "Auto_Fibonacci_Retracement-V3_ALERT.ex4"
#define IndicatorName7 "Bears.ex4"
#define IndicatorName8 "Heiken Ashi Smoothed.ex4"
#define IndicatorName9 "MACD.ex4"
#define IndicatorName10 "Accumulation.ex4"
#define IndicatorName11 "Custom Moving Averages.ex4"
#define IndicatorName12 "ATR.ex4"
#define IndicatorName13 "BULLVSBEAR.ex4"
#define IndicatorName14 "OsMa.ex4"
#define IndicatorName15 "Parabolic.ex4"
#define IndicatorName16 "PPO.ex4"
#define IndicatorName17 "Stochastic.ex4"
#define IndicatorName18 "StrategyIndi_1_0.ex4"
#define IndicatorName19 "TrendsFollowers.ex4"
#define IndicatorName20 "MTF_RSI.ex4"

#define IndicatorName21 "Alligator.ex4"
#define IndicatorName22 "1mfsto.ex4"
#define IndicatorName23 "Heiken Ashi.ex4"
#define IndicatorName24 "iExposure.ex4"
#define IndicatorName25 "Ichimoku.ex4"
#define IndicatorName26 "CCI.ex4"
#define IndicatorName27 "Stochastic.ex4"
#define IndicatorName28 "StrategyIndi_1_0.ex4"
#define IndicatorName29 "TrendsFollowers.ex4"
#define IndicatorName30 "Fixed_Chart_Scale.ex4"
#define IndicatorName31 "Bands.ex4"
#define IndicatorName32 "ZigZag.ex4"

//--- define the maximum number of used indicators in the EA
#define MAX_USABLE_INDICATORS 4
#define MAX_OPENING_INDICATORS MAX_USABLE_INDICATORS
#define MAX_CLOSING_INDICATORS MAX_USABLE_INDICATORS

#define SIGNAL_SELL (-1)
#define SIGNAL_NONE ( 0)
#define SIGNAL_BUY  ( 1)

#define  LOSS_COLOR clrGold
#define  CAPTION_COLOR  clrAliceBlue


//--- input parameters
#define  EXPERT_NAME "TradeExpert"
#define SEPARATOR "________________"
#define JOB "97031"
#define EPOCH D'2020.01.01 00:00'
#define OBJPFX JOB"_"
#define MAX_CLOSE_BUTTONS 7
#define CLIENT_BG_X (20)
#define CLIENT_BG_Y (20)
#define TOTAL_OpenOrExit 2
#define TOTAL_IndicatorNum 32 // Total number of usable indicators
#define IndicatorName0 "OFF"//Is an empty indicator that return nothing
#define IndicatorName1 "hma-trend-indicator_new _build.ex4"
#define IndicatorName2 "ATR.ex4"
#define IndicatorName3 "uni_cross.ex4"
#define IndicatorName4 "ZigZag_Pointer.ex4"
#define IndicatorName5 "Triggerlines.ex4"
#define IndicatorName6 "Auto_Fibonacci_Retracement-V3_ALERT.ex4"
#define IndicatorName7 "Bears.ex4"
#define IndicatorName8 "Heiken Ashi Smoothed.ex4"
#define IndicatorName9 "MACD.ex4"
#define IndicatorName10 "Accumulation.ex4"
#define IndicatorName11 "Custom Moving Averages.ex4"
#define IndicatorName12 "ATR.ex4"
#define IndicatorName13 "BULLVSBEAR.ex4"
#define IndicatorName14 "OsMa.ex4"
#define IndicatorName15 "Parabolic.ex4"
#define IndicatorName16 "PPO.ex4"
#define IndicatorName17 "Stochastic.ex4"
#define IndicatorName18 "StrategyIndi_1_0.ex4"
#define IndicatorName19 "TrendsFollowers.ex4"
#define IndicatorName20 "MTF_RSI.ex4"

#define IndicatorName21 "Alligator.ex4"
#define IndicatorName22 "1mfsto.ex4"
#define IndicatorName23 "Heiken Ashi.ex4"
#define IndicatorName24 "iExposure.ex4"
#define IndicatorName25 "Ichimoku.ex4"
#define IndicatorName26 "CCI.ex4"
#define IndicatorName27 "Stochastic.ex4"
#define IndicatorName28 "StrategyIndi_1_0.ex4"
#define IndicatorName29 "TrendsFollowers.ex4"
#define IndicatorName30 "Fixed_Chart_Scale.ex4"
#define IndicatorName31 "Bands.ex4"
#define IndicatorName32 "ZigZag.ex4"

//--- define the maximum number of used indicators in the EA
#define MAX_USABLE_INDICATORS 4
#define MAX_OPENING_INDICATORS MAX_USABLE_INDICATORS
#define MAX_CLOSING_INDICATORS MAX_USABLE_INDICATORS

#define SIGNAL_SELL (-1)
#define SIGNAL_NONE ( 0)
#define SIGNAL_BUY  ( 1)

#define  LOSS_COLOR clrGold
#define  CAPTION_COLOR  clrAliceBlue



//ALLOCATE RECSOURCES USING DEFINES INDICATORS FORM DIRECTORY
#resource "\\Indicators\\"+IndicatorName1;
#resource "\\Indicators\\"+IndicatorName2;
#resource "\\Indicators\\"+IndicatorName3;
#resource "\\Indicators\\"+IndicatorName4;
#resource "\\Indicators\\"+IndicatorName5;
#resource "\\Indicators\\"+IndicatorName6;
#resource "\\Indicators\\"+IndicatorName7;
#resource "\\Indicators\\"+IndicatorName8;
#resource "\\Indicators\\"+IndicatorName9;
#resource "\\Indicators\\"+IndicatorName10;

#resource "\\Indicators\\"+IndicatorName11;
#resource "\\Indicators\\"+IndicatorName12;
#resource "\\Indicators\\"+IndicatorName13;
#resource "\\Indicators\\"+IndicatorName14;
#resource "\\Indicators\\"+IndicatorName15;
#resource "\\Indicators\\"+IndicatorName16;
#resource "\\Indicators\\"+IndicatorName17;
#resource "\\Indicators\\"+IndicatorName18;
#resource "\\Indicators\\"+IndicatorName19;
#resource "\\Indicators\\"+IndicatorName20;

#resource "\\Indicators\\"+IndicatorName21;
#resource "\\Indicators\\"+IndicatorName22;
#resource "\\Indicators\\"+IndicatorName23;
#resource "\\Indicators\\"+IndicatorName24;
#resource "\\Indicators\\"+IndicatorName25;
#resource "\\Indicators\\"+IndicatorName26;
#resource "\\Indicators\\"+IndicatorName27;
#resource "\\Indicators\\"+IndicatorName28;
#resource "\\Indicators\\"+IndicatorName29;
#resource "\\Indicators\\"+IndicatorName30;

#resource "\\Indicators\\"+IndicatorName31;
#resource "\\Indicators\\"+IndicatorName32;

#define MAX_INDICATORS (32)



//ALLOCATE RECSOURCES USING DEFINES INDICATORS FORM DIRECTORY
#resource "\\Indicators\\"+IndicatorName1;
#resource "\\Indicators\\"+IndicatorName2;
#resource "\\Indicators\\"+IndicatorName3;
#resource "\\Indicators\\"+IndicatorName4;
#resource "\\Indicators\\"+IndicatorName5;
#resource "\\Indicators\\"+IndicatorName6;
#resource "\\Indicators\\"+IndicatorName7;
#resource "\\Indicators\\"+IndicatorName8;
#resource "\\Indicators\\"+IndicatorName9;
#resource "\\Indicators\\"+IndicatorName10;

#resource "\\Indicators\\"+IndicatorName11;
#resource "\\Indicators\\"+IndicatorName12;
#resource "\\Indicators\\"+IndicatorName13;
#resource "\\Indicators\\"+IndicatorName14;
#resource "\\Indicators\\"+IndicatorName15;
#resource "\\Indicators\\"+IndicatorName16;
#resource "\\Indicators\\"+IndicatorName17;
#resource "\\Indicators\\"+IndicatorName18;
#resource "\\Indicators\\"+IndicatorName19;
#resource "\\Indicators\\"+IndicatorName20;

#resource "\\Indicators\\"+IndicatorName21;
#resource "\\Indicators\\"+IndicatorName22;
#resource "\\Indicators\\"+IndicatorName23;
#resource "\\Indicators\\"+IndicatorName24;
#resource "\\Indicators\\"+IndicatorName25;
#resource "\\Indicators\\"+IndicatorName26;
#resource "\\Indicators\\"+IndicatorName27;
#resource "\\Indicators\\"+IndicatorName28;
#resource "\\Indicators\\"+IndicatorName29;
#resource "\\Indicators\\"+IndicatorName30;

#resource "\\Indicators\\"+IndicatorName31;
#resource "\\Indicators\\"+IndicatorName32;

#define MAX_INDICATORS (32)



//-===================END TELEGRAM =======================================

enum MARKET_TYPES
  {

   FOREX, STOCK, ETF, CRYPTO_CURRENCY

  };
enum PLATFORM
  {
   Telegram, Discord, Twitter, Facebook, Instagram
  };
enum TRADE_STYLES { LONG,//Long Only
                    SHORT,// Short Only

                    BOTH// Long And Short

                  };

enum TRADEMODE {Automatic,// Trade Automatic
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

enum indicators//list all enum indicators
  {
   ind0=0, //OFF
   ind1=1,  //hma-trend-indicator_new _build
   ind2=2,  //Beast Super Signal
   ind3=3,  //Uni cross
   ind4=4,  //Zigzag Pointer
   ind5=5, //Triggerlines
   ind6=6,//Auto_Fibonacci_Retracement-V3_ALERT
   ind7=7,  //4xgoddess_Zones_master
   ind8=8,  //Heiken Ashi Smoothed
   ind9=9,  //MACD
   ind10=10,  //RSI
   ind11=11,
   ind12=12,
   ind13=13,
   ind14=14,
   ind15=15,
   ind16=16,
   ind17=17,
   ind18=18,
   ind19=19,
   ind20=20,

   ind21=21,
   ind22=22,
   ind23=23,
   ind24=24,
   ind25=25,
   ind26=26,
   ind27=27,
   ind28=28,
   ind29=29,
   ind30=30,
   ind31=31,
   ind32=32
  };
  
//-===================END TELEGRAM =======================================

enum MARKET_TYPES
  {

   FOREX, STOCK, ETF, CRYPTO_CURRENCY

  };

enum TRADE_STYLES { LONG,//Long Only
                    SHORT,// Short Only

                    BOTH// Long And Short

                  };

enum TRADEMODE {Automatic,// Trade Automatic
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

enum indicators//list all enum indicators
  {
   ind0=0, //OFF
   ind1=1,  //hma-trend-indicator_new _build
   ind2=2,  //Beast Super Signal
   ind3=3,  //Uni cross
   ind4=4,  //Zigzag Pointer
   ind5=5, //Triggerlines
   ind6=6,//Auto_Fibonacci_Retracement-V3_ALERT
   ind7=7,  //4xgoddess_Zones_master
   ind8=8,  //Heiken Ashi Smoothed
   ind9=9,  //MACD
   ind10=10,  //RSI
   ind11=11,
   ind12=12,
   ind13=13,
   ind14=14,
   ind15=15,
   ind16=16,
   ind17=17,
   ind18=18,
   ind19=19,
   ind20=20,

   ind21=21,
   ind22=22,
   ind23=23,
   ind24=24,
   ind25=25,
   ind26=26,
   ind27=27,
   ind28=28,
   ind29=29,
   ind30=30,
   ind31=31,
   ind32=32
  };

const string indicator_names[] =
  {

   IndicatorName0,
   IndicatorName1,
   IndicatorName2,
   IndicatorName3,
   IndicatorName4,
   IndicatorName5,
   IndicatorName6,
   IndicatorName7,
   IndicatorName8,
   IndicatorName9,
   IndicatorName10


   IndicatorName11,
   IndicatorName12,
   IndicatorName12,
   IndicatorName13,
   IndicatorName14,
   IndicatorName15,
   IndicatorName16,
   IndicatorName17,
   IndicatorName18,
   IndicatorName19,

   IndicatorName20,
   IndicatorName21,
   IndicatorName22,
   IndicatorName23,
   IndicatorName24,
   IndicatorName25
   IndicatorName26,
   IndicatorName27,
   IndicatorName28,
   IndicatorName29,
   IndicatorName30,
   IndicatorName31,
   IndicatorName32
  };
enum mode_of_alert
  {
   E_MAIL,MOBILE,E_MAIL_AND_MOBILE
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

int TO=0,TB=0,TS=0,sts=11;
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
struct STRUCT_INDICATOR
  {
   //--- input parameters
   string            Name;
   indicators        Indicator;
   ENUM_TIMEFRAMES   TimeFrame;
   ENUM_TYPE_OF_ENTRY TypeOfEntry;
   int               Shift;
   //--- dynamic parameters
   STRUCT_SIGNAL     LastSignal[]; //--- last known indicator signal per symbol
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


struct STRUCT_TRADE
  {
   int               ticket[1];
   uint              magic[1];
   int               be_count[1];
  };

struct STRUCT_127031
  {
   string            symbol;
   STRUCT_TRADE      trades[];
  };

STRUCT_127031 SymbolTrades[];
STRUCT_SYMBOL_SIGNAL ManualSignals[];


double SL=0,TP=0;
enum caraclose
  {
   opposite = 0,   // Indicator Reversal Signal
   sltp = 1,       // Take Profit and Stop Loss
   bar = 2,       // Close With N Bar
   date = 3       // Close With Date
  };
enum DYS_WEEK
  {
   Sunday=0,
   Monday=1,
   Tuesday=2,
   Wednesday,
   Thursday=4,
   Friday=5,
   Saturday
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


//TRADING TECHNICS
enum TRADING_TECHNICS_FILTER
  {

   JOINT, STOCHASTIC, MOVING_AVERAGE, RANDOM,CCI, HEIKEN_ASHI,PARABOLIC,SEPARATE,RSI,CUSTOM_INDICATOR

  };

enum  TRADE_PAIRS { ALL_PAIRS,  SINGLE_PAIR,CUSTOM_PAIRS};


enum MONEYMANAGEMENT { FIXED_SIZE =1, //Fix trade  Size
                       Risk_Percent_Per_Trade =2,// Risk Percent %
                       POSITION_SIZE=3, //Position Size
                       MARTINGALE_OR_ANTI_MATINGALE=4,//Martingale or Antimartingale
                       MARTINEGALE_STEPPING=5, // Martingale Stepping
                       LOT_OPTIMIZE=6 //Lot Optimize
                     };

enum Filteration
  {

   B1=1, //M5 < M30
   B2=2, //M5 < H1
   B3=3, //M5 < M30 + DOM by BULLVSBEAR®
   B4=4, //M5 < H1  + DOM by BULLVSBEAR®
  };

//+------------------------------------------------------------------+
//|                           TrendFilter                                       |
//+------------------------------------------------------------------+
enum TrendFilter
  {
   E1=1, //Relative Strength Index
   E2=2, //Stochastic_Old Technique
  };

const string indicator_names[] =
  {

   IndicatorName0,
   IndicatorName1,
   IndicatorName2,
   IndicatorName3,
   IndicatorName4,
   IndicatorName5,
   IndicatorName6,
   IndicatorName7,
   IndicatorName8,
   IndicatorName9,
   IndicatorName10


   IndicatorName11,
   IndicatorName12,
   IndicatorName12,
   IndicatorName13,
   IndicatorName14,
   IndicatorName15,
   IndicatorName16,
   IndicatorName17,
   IndicatorName18,
   IndicatorName19,

   IndicatorName20,
   IndicatorName21,
   IndicatorName22,
   IndicatorName23,
   IndicatorName24,
   IndicatorName25
   IndicatorName26,
   IndicatorName27,
   IndicatorName28,
   IndicatorName29,
   IndicatorName30,
   IndicatorName31,
   IndicatorName32
  };
enum mode_of_alert
  {
   E_MAIL,MOBILE,E_MAIL_AND_MOBILE
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

int TO=0,TB=0,TS=0,sts=11;
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
struct STRUCT_INDICATOR
  {
   //--- input parameters
   string            Name;
   indicators        Indicator;
   ENUM_TIMEFRAMES   TimeFrame;
   ENUM_TYPE_OF_ENTRY TypeOfEntry;
   int               Shift;
   //--- dynamic parameters
   STRUCT_SIGNAL     LastSignal[]; //--- last known indicator signal per symbol
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


struct STRUCT_TRADE
  {
   int               ticket[1];
   uint              magic[1];
   int               be_count[1];
  };

struct STRUCT_127031
  {
   string            symbol;
   STRUCT_TRADE      trades[];
  };

STRUCT_127031 SymbolTrades[];
STRUCT_SYMBOL_SIGNAL ManualSignals[];


double SL=0,TP=0;
enum caraclose
  {
   opposite = 0,   // Indicator Reversal Signal
   sltp = 1,       // Take Profit and Stop Loss
   bar = 2,       // Close With N Bar
   date = 3       // Close With Date
  };
enum DYS_WEEK
  {
   Sunday=0,
   Monday=1,
   Tuesday=2,
   Wednesday,
   Thursday=4,
   Friday=5,
   Saturday
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


//TRADING TECHNICS
enum TRADING_TECHNICS_FILTER
  {

   JOINT, STOCHASTIC, MOVING_AVERAGE, NONE, RANDOM,CCI, HEIKEN_ASHI,PARABOLIC,SEPARATE,RSI,CUSTOM_INDICATOR

  };

enum  TRADE_PAIRS { ALL_PAIRS,  SINGLE_PAIR,CUSTOM_PAIRS};


enum MONEYMANAGEMENT { FIXED_SIZE =1, //Fix trade  Size
                       Risk_Percent_Per_Trade =2,// Risk Percent %
                       POSITION_SIZE=3, //Position Size
                       MARTINGALE_OR_ANTI_MATINGALE=4,//Martingale or Antimartingale
                       MARTINEGALE_STEPPING=5, // Martingale Stepping
                       LOT_OPTIMIZE=6 //Lot Optimize
                     };

enum Filteration
  {

   B1=1, //M5 < M30
   B2=2, //M5 < H1
   B3=3, //M5 < M30 + DOM by BULLVSBEAR®
   B4=4, //M5 < H1  + DOM by BULLVSBEAR®
  };

//+------------------------------------------------------------------+
//|                           TrendFilter                                       |
//+------------------------------------------------------------------+
enum TrendFilter
  {
   E1=1, //Relative Strength Index
   E2=2, //Stochastic_Old Technique
  };


///////////////////////////////////////VARIABLES/////////////////////////////////

//--- internals
  string indName0 ="OFF";
   string indName1="OFF";
   string indName2="OFF";
   string indName3="OFF";
   string mytrade="tradePic";
int timer_ms;
string _sep=",";                                                 // A separator as a character
ushort _u_sep;                                                    // The code of the separator character

int  TBa=0;//Total buy ordes counter
bool _isBuy[];                //--- buy state array for each symbol
bool _isSell[];               //--- sell state array for each symbol
int SymbolButtonSelected = 0; //--- index of symbol button pressed

STRUCT_INDICATOR OpeningIndicators[];
STRUCT_INDICATOR ClosingIndicators[];

string messages="no message";
string a111="a111", b111="b111",p111="p111",v111="v111";
string  EXPERT_VERSION="4.0";//expert version

md     Mode            = nm;      // Mode
// SL if strength for pair is crossing or crossed

int                       x_axis                    =0;
int                       y_axis                    =20;

bool                      UseDefaultPairs            = true;              // Use the default 28 pairs
string                    OwnPairs                   = "";                // Comma seperated own pair list

double Px = 0, Sx = 0, Rx = 0, S1x = 0, R1x = 0, S2x = 0, R2x = 0, S3x = 0, R3x = 0;//support and resistance pivot variables

STRUCT_SYMBOL_SIGNAL signal;
string symbol=Symbol();


double ask=0;
double bid=0;
int myPoint=10;
int vdigits=4;


//--- Get signals for buy/sell order opening
STRUCT_SYMBOL_SIGNAL OpenSignals[];
STRUCT_SYMBOL_SIGNAL CloseSignals[];

int ttlbuy=0,ttlsell=0;
///
bool exitBuy=false,exitSell =false;

bool crossed[2]; //initialized to true, used in function Cross
//---
int panelwidth=400;
int panelheight= 250;
int buttonwidth=(panelwidth-8)/3;
int buttonheight=(panelheight-36)/5;
int editwidth=(panelwidth-8)/4;

//--- GUI debug
int y_offset;
int IndicatorSubWindow = 0;

string message="none";
int startx = CLIENT_BG_X; //X
int starty = CLIENT_BG_Y; //Y
int startx_symbolpanel = startx;
int starty_symbolpanel = starty+panelheight+10;
int startx_closepanel  = startx+panelwidth+10;
int starty_closepanel  = starty;
string CloseButtonNames[MAX_CLOSE_BUTTONS] = {"CPCloseBuy","CPCloseSell","CPCloseProfit","CPCloseLoss","CPCloseLimit","CPCloseStop","CPCloseAll"};
bool previous_trend=false;
const ENUM_TIMEFRAMES _periods[] = {PERIOD_M1,PERIOD_M5,PERIOD_M15,PERIOD_M30,PERIOD_H1,PERIOD_H4,PERIOD_D1,PERIOD_W1,PERIOD_MN1};
CComment       comment ;//create objet=c comment to store variables comments
ENUM_RUN_MODE  run_mode;
datetime       time_check;
int            web_error;
int            init_error;
string         photo_id=NULL;
int ticket=-1;
//---- Get new daily prices & calculate pivots
double cur_day  = 0;
double yesterday_close = 0,
       today_open = 0,
       yesterday_high = 0,//day_high;
       yesterday_low = 0,//day_low;
       day_high = 0,
       day_low  =0;
double prev_day = cur_day;
int TargetReachedForDay=-1;
int ThisDayOfYear=0;
datetime TMN=0;
datetime NewCandleTime=0;
string postfix="",prefix="";
bool Os,Om,Od,Oc;
bool CloseOP=false;
color  warnatxt = clrAqua;// Warning Text
double HEDING=true;
double maxlot,minlot;
ENUM_BASE_CORNER Info_Corner = 0;
color  FontColorUp1 = Yellow,FontColorDn1 = Pink,FontColor = White,FontColorUp2 = LimeGreen,FontColorDn2 = Red;
double PR=0,PB=0,PS=0,LTB=0,LTS=0;
string closeAskedFor ="";
datetime expire_date;
datetime e_d ;
double minlotx;
datetime sendOnce;
double startbalance;
datetime starttime;
bool isNewBar;
bool trade=true;
string google_urlx;

color highc          = clrRed;     // Colour important news
color mediumc        = clrBlue;    // Colour medium news
color lowc           = clrLime;    // The color of weak news
int   Style          = 2;          // Line style
int   Upd            = 86400;      // Period news updates in seconds

bool  Vtunggal       = false;
bool  Vhigh          = false;
bool  Vmedium        = false;
bool  Vlow           = false;
int   MinBefore=0;
int   MinAfter=0;

int NomNews=0;
string NewsArr[5][3000];
int Now=0;
datetime LastUpd;
string str1;

double harga;
double lastprice;
string jamberita;
string judulberita;
string infoberita=" >>>> checking news <<<";

double P1=0,Wp1=0,MNp1=0,P2=0,P3=0,Persentase1=0,Persentase2=0,Persentase3=0;

//extern     string mysimbol = "EURUSD,USDJPY,GBPUSD,AUDUSD,USDCAD,USDCHF,NZDUSD,EURJPY,EURGBP,EURCAD,EURCHF,EURAUD,EURNZD,AUDJPY,CHFJPY,CADJPY,NZDJPY,GBPJPY,GBPCHF,GBPAUD,GBPCAD,CADCHF,AUDCHF,GBPNZD,AUDNZD,AUDCAD,NZDCAD,NZDCHF";

int xc,xpair,xbuy,xsell,xcls,xlot,xpnl,xexp,yc,ypair,ysell,ybuy,ylot,ycls,ypnl,yexp,ytxtb,ytxts,ytxtcls,ytxtpnl,ytxtexp;
double poexp[100];//= { 0,0.00000000000002,0.000000000000000000003,
double profitss[100];
double DayProfit ;
double BalanceStart;
double DayPnLPercent;
datetime mydate=TimeLocal();
string sep=",";                // A separator as a character
ushort u_sep;                  // The code of the separator character
// string result;               // An array to get strings
datetime _opened_last_time = mydate ;
datetime _closed_last_time = mydate  ;

int NumOfSymbols=100;
const int OpenOrExit0 = 0, OpenOrExit1 = 1;
const int IndicatorNum0 = 0, IndicatorNum1 = 1, IndicatorNum2 = 2, IndicatorNum3 = 3,IndicatorNum4=4,IndicatorNum5=5;

datetime LastIndicatorSignalTime[][TOTAL_OpenOrExit][TOTAL_IndicatorNum];
int LotDigits=1; //initialized in OnInit
string pcom1="",pcom2="",pcom3="",pcom4="";
string pcom1x="",pcom2x="",pcom3x="",pcom4x="";
int xSell1=0;
int xSell2=0;
int xSell3=0;
int xSell4=0;
int xBuy1=0;
int xBuy2=0;
int xBuy3=0;
int xBuy4=0;
int sinyalb1 ;
int sinyalb2 ;
int sinyalb3 ;
int sinyalb4 ;
int sinyal1;
int sinyal2;
int sinyal3;
int sinyal4;
datetime PrevTime=D'2015.01.01 00:00';



input double FIBO_LEVEL_0=0.0;

input double FIBO_LEVEL_1=0.236;
input bool ALERT_ACTIVE_FIBO_LEVEL_1=true;

input double FIBO_LEVEL_2=0.382;
input bool ALERT_ACTIVE_FIBO_LEVEL_2=true;

input double FIBO_LEVEL_3=0.50;
input bool ALERT_ACTIVE_FIBO_LEVEL_3=true;

input double FIBO_LEVEL_4=0.618;
input bool ALERT_ACTIVE_FIBO_LEVEL_4=true;

input double FIBO_LEVEL_5=0.786;
input bool ALERT_ACTIVE_FIBO_LEVEL_5=true;

input double FIBO_LEVEL_6=1.0;
input bool ALERT_ACTIVE_FIBO_LEVEL_6=true;

input double FIBO_LEVEL_7=1.214;
input bool ALERT_ACTIVE_FIBO_LEVEL_7=true;

input double FIBO_LEVEL_8=1.618;
input bool ALERT_ACTIVE_FIBO_LEVEL_8=true;

input double FIBO_LEVEL_9=2.618;
input bool ALERT_ACTIVE_FIBO_LEVEL_9=true;

input double FIBO_LEVEL_10=4.236;
input bool ALERT_ACTIVE_FIBO_LEVEL_10=true;

bool alarm_fibo_level_1=false;
bool alarm_fibo_level_2=false;
bool alarm_fibo_level_3=false;
bool alarm_fibo_level_4=false;
bool alarm_fibo_level_5=false;
bool alarm_fibo_level_6=false;
bool alarm_fibo_level_7=false;
bool alarm_fibo_level_8=false;
bool alarm_fibo_level_9=false;
bool alarm_fibo_level_10=false;

int fibo_levels=11;
double current_high;
double current_low;
double price_delta;

string headerString = "AutoFibo_";

long         magic_number=MagicNumber;
double           stoploss= MaxSL;
double   takeprofit=MaxTP;
double          distance_pending=InpDeviation;
double           distance_stoplimit=orderdistance;
uint           slippage=MaxSlippage;
bool           trailing_on=TrailingStart;
double         trailing_stop=TrailingStop;
double         trailing_step=TrailingStep;
double          trailing_start=TrailingStart;
uint           stoploss_to_modify;
uint           takeprofit_to_modify;

//+-------------------------END DEFINE PARAMETERS---------------------------------+


//+------------------------------------------------------------------------------+
//|                        DEFINE  EA FUNCTIONS                                                       |
//+------------------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrder(STRUCT_SYMBOL_SIGNAL &signals)
  {
   ENUM_ORDER_TYPE op_type=OP_SELL;
//--- get buy and sell opened order count for symbol
   int boc = _funcOC(ORDER_TYPE_BUY,symbol);
   if(boc > 0)
      return;
   int soc = _funcOC(ORDER_TYPE_SELL,symbol);
   if(soc > 0)
      return;
   double pip;
   pip=SymbolInfoDouble(symbol,SYMBOL_POINT);
   if(SymbolInfoInteger(symbol,SYMBOL_DIGITS)==5 || SymbolInfoInteger(symbol,SYMBOL_DIGITS)==3 || StringFind(symbol,"XAU",0)>=0)
      pip*=10;
   switch(inpTradeMode)
     {
      default:
         break;
      case Automatic:
        {
         //--- check for time constraints

         if(CheckTradingTime()==false)
           {
            //Print("TIme");
            return;
           }
         double fVol = LotsOptimized(symbol);
         for(int i=0; i<NumOfSymbols; i++)
           {

            OpenOrderAuto(symbol,op_type,pip,fVol,i);
            fVol-=(TradeSize(InpMoneyManagement)-inpSubLot);
            if(fVol< SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN))
              {
               fVol = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
              }
           }
         break;
        }
      case Manual:
        {
         double fVol = signal.volume;
         for(int i=0; i<signal.not; i++)
           {
            OpenOrderManual(symbol,op_type,pip,fVol,i);
            fVol-=(TradeSize(InpMoneyManagement)-inpSubLot);
            if(fVol< SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN))
              {
               fVol = SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
              }
           }
         break;
        }
     }

  }

//+------------------------------------------------------------------------------+
//| ChartEventMouseMoveSet                                                       |
//+------------------------------------------------------------------------------+
bool ChartEventMouseMoveSet(const bool value)
  {
//-- reset the error value
   ResetLastError();
//--
   if(!ChartSetInteger(0,CHART_EVENT_MOUSE_MOVE,IndicatorSubWindow,value))
     {
      Print(__FUNCTION__,
            ", Error Code = ",_LastError);
      return(false);
     }
//--
   return(true);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int getIndiValues(indicators jj, ENUM_TIMEFRAMES tf,  string sName)
  {

   switch(jj)
     {
      case  ind1:
         return _ind1(tf,inpShift0,sName);
         break;
      case  ind2:
         return _ind2(tf,inpShift1,sName);
         break;
      case  ind3:
         return _ind3(tf,inpShift2,sName);
         break;
      case  ind4:
         return _ind4(tf,inpShift3,sName);
         break;
      case  ind5:
         return _ind5(tf,inpShift0,sName);
         break;
      case  ind6:
         return _ind6(tf,inpShift1,sName);
         break;
      case  ind7:
         return _ind7(tf,inpShift2,sName);
         break;
      case  ind8:
         return _ind8(tf,inpShift3,sName);
         break;
      case  ind9:
         return _ind9(tf,inpShift0,sName);
         break;
      case  ind10:
         return _ind10(tf,inpShift1,sName);
         break;
      default:
         return 0;
         break;
     }
  }

int  tradecount=0;
//+------------------------------------------------------------------+
int _ind1(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {

   int i = 0;
   double va1=0,va2=0,va3=0,va4=0 ;
   va1=(int)iCustom(sName,tf,IndicatorName1,period,method, pricess,0,inpBar);
   va2=(int)iCustom(sName,tf,IndicatorName1,  period,method,  pricess,1,inpBar);
   if(!inpAligned)
     {
      if(va1 == 1 && va2==-1)
        {
         return 1;
        }
      if(va1 == -1 && va2==1)
        {
         return -1;

        }


     }
   else
     {

      if(va1 == 1 && va2==-1)
        {
         tradecount++;
        }
      if(va1 == -1 && va2==1)
        {
         tradecount++;
        }

      if(va1 == 1)
        {
         return 1;
        }
      if(va1 == -1)
        {
         return -1;

        }

     }

   return 0;
  }
//+------------------------------------------------------------------+
int _ind2(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {
   int ret = 0;
   double va1 = iCustom(sName,tf,IndicatorName2,Rperiod,LSMA_Period,0,inpBar);
   double va2 = iCustom(sName,tf,IndicatorName2,Rperiod,LSMA_Period,0,1);
   double va3 = iCustom(sName,tf,IndicatorName2,Rperiod,LSMA_Period,1,inpBar+1);
   double va4 = iCustom(sName,tf,IndicatorName2,Rperiod,LSMA_Period,1,inpBar+1);

   if(!inpAligned)
     {
      if(va1== va3 && va4==EMPTY_VALUE)
        {
         ret = 1;
        }
      if(va3== EMPTY_VALUE && va4!=EMPTY_VALUE)
        {
         ret = -1;
        }
     }
   else
     {

      if(va1== va3 && va4==EMPTY_VALUE)
        {
         tradecount++;
        }
      if(va3== EMPTY_VALUE && va4!=EMPTY_VALUE)
        {
         tradecount++;
        }


      if(va1== va3)
        {
         ret = 1;
        }
      else   //--- This fixes the original code behavior which prevented buy orders
        {
         //--- reason: va1 always different from EMPTY_VALUE so when a buy signal occur
         //--- due to (va1 == va3) the next if condition always set a sell signal
         if(va1!= EMPTY_VALUE)
           {
            ret = -1;
           }
        }
     }
   return ret;
  }
//+------------------------------------------------------------------+
int _ind3(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {
//unicross
   double buy=iCustom(sName,tf, IndicatorName3,UseSound,TypeChart,       UseAlert,NameFileSound, T3Period,           T3Price,bFactor,Snake_HalfCycle,Inverse,0,0,0.5,500,0,1),

          sell=iCustom(sName,tf,IndicatorName3,
                       UseSound,
                       TypeChart,
                       UseAlert,
                       NameFileSound, T3Period,
                       T3Price,
                       bFactor,
                       Snake_HalfCycle,
                       Inverse,
                       0,0,0.5,500,1,1);
   ;
   double green_1 = buy;
   double red_1   = sell;
   if(green_1 != EMPTY_VALUE)
      return SIGNAL_BUY;
   if(red_1   != EMPTY_VALUE)
      return SIGNAL_SELL;
   return SIGNAL_NONE;

   return 0;
  }

//+------------------------------------------------------------------+
int _ind4(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {
   int i = 0;
   double va1=0,va2=0 ;

//---Buy
   va1 = iCustom(sName,tf,IndicatorName4,
                 UseSound,TypeChart,UseAlert,NameFileSound,T3Period,T3Price,
                 bFactor,Snake_HalfCycle,Inverse,DeltaForSell,DeltaForBuy,ArrowOffset,Maxbars,0,inpBar);
//---Sell
   va2 = iCustom(sName,tf,IndicatorName4,
                 UseSound,TypeChart,UseAlert,NameFileSound,T3Period,T3Price,
                 bFactor,Snake_HalfCycle,Inverse,DeltaForSell,DeltaForBuy,ArrowOffset,Maxbars,1,inpBar);



   if(!inpAligned)
     {



      if(va1!=EMPTY_VALUE)
        {
         return 1;
        }
      if(va2!=EMPTY_VALUE)
        {
         return -1;
        }
     }
   else
     {
      bool check = false;
      if(va1!=EMPTY_VALUE)
        {
         tradecount++;
        }
      if(va2!=EMPTY_VALUE)
        {
         tradecount++;
        }
      inpBar = 0;
      while(!check)
        {
         //---Buy
         double buy_1 = iCustom(sName,tf,IndicatorName4,period,InpDepth, InpDeviation,InpBackstep,alerts,EmailAlert,alertonbar,sendnotify, 0,1);
         //---Sell
         double sel_1 =iCustom(sName,tf, IndicatorName4,period,InpDepth,   InpDeviation, InpBackstep, alerts,EmailAlert,alertonbar,sendnotify, 1,1);
         if((buy_1 > 0)&&(sel_1==0))
            return SIGNAL_BUY;
         if((sel_1 > 0)&&(buy_1==0))
            return SIGNAL_SELL;
         inpBar++;
         if(inpBar>=iBars(sName,tf))
            break;
        }
     }
   return SIGNAL_NONE;
  }


//+------------------------------------------------------------------+
//--Triggerliner
int _ind5(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {

   double slope = iCustom(sName,tf,IndicatorName5,Rperiod,LSMA_Period,0,1);
   ;

   if(inpAligned)
     {
      double slope_1 = iCustom(sName,tf,IndicatorName5,Rperiod,LSMA_Period,1,1);      //PrintFormat("slope:%f slope_1:%f",slope,slope_1);
      if((slope >=  1)/*&&(slope_1 != 1)*/)
         return SIGNAL_BUY;
      if((slope <= -1)/*&&(slope_1 !=-1)*/)
         return SIGNAL_SELL;
     }
   else
     {
      if(slope >=  1)
         return SIGNAL_BUY;
      if(slope <= -1)
         return SIGNAL_SELL;
     }
   return SIGNAL_NONE;
  }
//--- Hull Parabolic 2.1
int _ind6(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {

   double slope = iCustom(sName,tf,IndicatorName6,ind7HmaLength,ind7Price,ind7Power,ind7Shift,ind7Interpolate,0,1);
   if(inpAligned)
     {
      double slope_1 = iCustom(sName,tf,IndicatorName6,ind7HmaLength,ind7Price,ind7Power,ind7Shift,ind7Interpolate,1,1);
      //PrintFormat("slope:%f slope_1:%f",slope,slope_1);
      if((slope ==  1)/*&&(slope_1 != 1)*/)
         return SIGNAL_BUY;
      if((slope == -1)/*&&(slope_1 !=-1)*/)
         return SIGNAL_SELL;
     }
   else
     {
      if(slope ==  1)
         return SIGNAL_BUY;
      if(slope == -1)
         return SIGNAL_SELL;
     }
   return SIGNAL_NONE;
  }
//--- HMA nrp alerts + arrows
//--- Hull Parabolic 2.1

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int _ind7(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {

   double slope = iCustom(sName,tf,IndicatorName7,ind7HmaLength,ind7Price,ind7Power,ind7Shift,ind7Interpolate,3,inpBar);
   if(inpAligned)
     {
      double slope_1 = iCustom(sName,tf,IndicatorName7,ind7HmaLength,ind7Price,ind7Power,ind7Shift,ind7Interpolate,3,inpBar+1);
      //PrintFormat("slope:%f slope_1:%f",slope,slope_1);
      if((slope ==  1)/*&&(slope_1 != 1)*/)
         return SIGNAL_BUY;
      if((slope == -1)/*&&(slope_1 !=-1)*/)
         return SIGNAL_SELL;
     }
   else
     {
      if(slope ==  1)
         return SIGNAL_BUY;
      if(slope == -1)
         return SIGNAL_SELL;
     }
   return SIGNAL_NONE;
  }
//--- HMA nrp alerts + arrows

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int _ind8(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {

   double trend = iCustom(sName,tf,IndicatorName8,
                          ind8HMAPeriod,ind8HMAPrice,ind8HMAMethod,
                          ind8HMASpeed,ind8DisplayType,ind8Shift,ind8LinesWidth,
                          ind8alertsOn,ind8alertsOnCurrent,ind8alertsMessage,ind8alertsSound,
                          ind8alertsEmail,ind8alertsPushNotif,ind8ArrowOnFirst,ind8UpArrowSize,
                          ind8DnArrowSize,ind8UpArrowCode,ind8DnArrowCode,ind8UpArrowGap,
                          ind8DnArrowGap,ind8UpArrowColor,ind8DnArrowColor,ind8Interpolate,6,inpBar);

   if(trend == 1)
      return SIGNAL_BUY;
   if(trend == -1)
      return SIGNAL_SELL;
   return SIGNAL_NONE;
  }
//--- 127031_Signal_line_with_alert
int _ind9(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {
   double buy_1 = iCustom(sName,tf,IndicatorName9,ind9period,ind9method,ind9price,ind9UseAlert,0,inpBar);
   double sell_1= iCustom(sName,tf,IndicatorName9,ind9period,ind9method,ind9price,ind9UseAlert,1,inpBar);
   PrintFormat("%s: buy:%f sell:%f",EnumToString(tf),buy_1,sell_1);
   if((buy_1  > 0) && (buy_1 != EMPTY_VALUE))
      return SIGNAL_BUY;
   if((sell_1 > 0) && (sell_1 != EMPTY_VALUE))
      return SIGNAL_SELL;

   return SIGNAL_NONE;
  }
//--- vinin-hma-indicator
int _ind10(ENUM_TIMEFRAMES tf,int inpBar, string sName)
  {
   double buy_1 = iCustom(sName,tf,IndicatorName10,ind10period,ind10method,ind10price,ind10sdvig,
                          ind10AlertsMessage,ind10AlertsSound,ind10AlertsEmail,ind10AlertsMobile,ind10AlertsSoundFile,ind10SignalBar,1,inpBar);
   double sell_1 = iCustom(sName,tf,IndicatorName10,ind10period,ind10method,ind10price,ind10sdvig,
                           ind10AlertsMessage,ind10AlertsSound,ind10AlertsEmail,ind10AlertsMobile,ind10AlertsSoundFile,ind10SignalBar,2,inpBar);
   if((buy_1 > 0) && (buy_1 != EMPTY_VALUE))
      return SIGNAL_BUY;
   if((sell_1 > 0) && (sell_1 != EMPTY_VALUE))
      return SIGNAL_SELL;

   return SIGNAL_NONE;
  }

//+-----------------------------------------------------------------+
int  _funcOrdTotal(string sName)
  {

   int count=OrdersTotal();
   int ts=0;
   while(count>0)
     {
      int os=OrderSelect(count-1,SELECT_BY_POS,MODE_TRADES);
      if(OrderMagicNumber()==MagicNumber && OrderSymbol()==sName)
        {
         ts++;
        }
      count--;
     }

   return ts;
  }
//+------------------------------------------------------------------+
void  _funcClose(ENUM_ORDER_TYPE oType,string sName)
  {

   int count=OrdersTotal();
   double ts=0;
   while(count>0)
     {
      int os=OrderSelect(count-1,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()== oType
         && OrderSymbol()==sName
         && OrderMagicNumber()==MagicNumber)
        {
         double cPrice = oType==ORDER_TYPE_BUY?SymbolInfoDouble(sName,SYMBOL_BID):SymbolInfoDouble(sName,SYMBOL_ASK);
         bool ordClose = OrderClose(OrderTicket(),OrderLots(),cPrice,5,clrYellow);
        }

      count--;
     }
  }
//////////////////////////////ENTER  BUY||SELL SIGNAL 1//////////////////////////////

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Signal1()    //buy sell 1
  {



   if(getIndiValues(ind0, inpTF0,symbol)==1)
     {
      return "BUY";
     }
   else
      if(getIndiValues(ind0, inpTF0,symbol)==-1)
        {
         return "SELL";
        }

   return "NO SIGNAL";
  }



//////////////////////////////ENTER  BUY||SELL SIGNAL 2//////////////////////////////

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Signal2()
  {

   if(getIndiValues(ind1, inpTF1,symbol)==1)
     {
      return "BUY";
     }
   else
      if(getIndiValues(ind1, inpTF1,symbol)==-1)
        {
         return "SELL";
        }

   return "NO SIGNAL";
  }


//////////////////////////////ENTER  BUY||SELL SIGNAL 3//////////////////////////////

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Signal3() //unicross
  {

   if(getIndiValues(ind2, inpTF2,symbol)==1)
     {
      return "BUY";
     }
   else
      if(getIndiValues(ind2, inpTF2,symbol)==-1)
        {
         return "SELL";
        }

   return "NO SIGNAL";
  }


//////////////////////////////ENTER  BUY||SELL SIGNAL 4//////////////////////////////
string Signal4() //zigzag pointer
  {

   if(getIndiValues(ind3, inpTF3,symbol)==1)
     {
      return "BUY";
     }
   else
      if(getIndiValues(ind3, inpTF3,symbol)==-1)
        {
         return "SELL";
        }

   return "NO SIGNAL";
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Signal5()
  {


   if(_ind5(inpTF3,ind7Shift,symbol)==1)
     {
      return "BUY";

     }
   else
      if(_ind5(inpTF3,ind7Shift,symbol)==-1)
        {
         return "SELL";
        }
   return "No Signal";
  };

//+------------------------------------------------------------------+
//|                TradeSignal   Get signals Data                                            |
//+------------------------------------------------------------------+
string TradeSignal() //Get    trades signals
  {
  
 
   int aa=(int)EnumToString(inpInd0);
   printf("aa"+EnumToString(inpInd0));
   int bb=(int)EnumToString(inpInd1);
   int cc=(int)EnumToString(inpInd2);
   int dd=(int)EnumToString(inpInd3);

   switch(inpInd0)
     {

      default :
         indName0="OFF";
         break;
      case ind0:
         indName0="OFF";
         break;
      case ind1:
         indName0=IndicatorName1;
         break;
      case ind2:
         indName0=IndicatorName2;
         break;
      case ind3:
         indName0=IndicatorName3;
         break;
      case ind4:
         indName0=IndicatorName4;
         break;
      case ind5:
         indName0=IndicatorName5;
         break;
      case ind6:
         indName0=IndicatorName6;
         break;
      case ind7:
         indName0=IndicatorName7;
         break;
      case ind8:
         indName0=IndicatorName8;
         break;
      case ind9:
         indName0=IndicatorName9;
         break;
      case ind10:
         indName0=IndicatorName10;
         break;
      case ind11:
         indName0=IndicatorName11;
         break;
      case ind12:
         indName0=IndicatorName12;
         break;
      case ind13:
         indName0=IndicatorName13;
         break;
      case ind14:
         indName0=IndicatorName14;
         break;
      case ind15:
         indName0=IndicatorName15;
         break;
      case ind16:
         indName0=IndicatorName16;
         break;
      case ind17:
         indName0=IndicatorName17;
         break;
      case ind18:
         indName0=IndicatorName18;
         break;
      case ind19:
         indName0=IndicatorName19;
         break;
      case ind20:
         indName0=IndicatorName20;
         break;
      case ind21:
         indName0=IndicatorName21;
         break;
      case ind22:
         indName0=IndicatorName22;
         break;
      case ind23:
         indName0=IndicatorName23;
         break;
      case ind24:
         indName0=IndicatorName24;
         break;
      case ind25:
         indName0=IndicatorName25;
         break;
      case ind26:
         indName0=IndicatorName26;
         break;
      case ind27:
         indName0=IndicatorName27;
         break;
      case ind28:
         indName0=IndicatorName28;
         break;
      case ind29:
         indName0=IndicatorName29;
         break;
      case ind30:
         indName0=IndicatorName30;
         break;
      case ind31:
         indName0=IndicatorName31;
         break;
      case ind32:
         indName0=IndicatorName32;
         break;


     }

   switch(inpInd1)
     {

      default :
         indName1="OFF";
         break;
      case ind0:
         indName1="OFF";
         break;
      case ind1:
         indName1=IndicatorName1;
         break;
      case ind2:
         indName1=IndicatorName2;
         break;
      case ind3:
         indName1=IndicatorName3;
         break;
      case ind4:
         indName1=IndicatorName4;
         break;
      case ind5:
         indName1=IndicatorName5;
         break;
      case ind6:
         indName1=IndicatorName6;
         break;
      case ind7:
         indName1=IndicatorName7;
         break;
      case ind8:
         indName1=IndicatorName8;
         break;
      case ind9:
         indName1=IndicatorName9;
         break;
      case ind10:
         indName1=IndicatorName10;
         break;
      case ind11:
         indName1=IndicatorName11;
         break;
      case ind12:
         indName1=IndicatorName12;
         break;
      case ind13:
         indName1=IndicatorName13;
         break;
      case ind14:
         indName1=IndicatorName14;
         break;
      case ind15:
         indName1=IndicatorName15;
         break;
      case ind16:
         indName1=IndicatorName16;
         break;
      case ind17:
         indName1=IndicatorName17;
         break;
      case ind18:
         indName1=IndicatorName18;
         break;
      case ind19:
         indName1=IndicatorName19;
         break;
      case ind20:
         indName1=IndicatorName20;
         break;
      case ind21:
         indName1=IndicatorName21;
         break;
      case ind22:
         indName1=IndicatorName22;
         break;
      case ind23:
         indName1=IndicatorName23;
         break;
      case ind24:
         indName1=IndicatorName24;
         break;
      case ind25:
         indName1=IndicatorName25;
         break;
      case ind26:
         indName1=IndicatorName26;
         break;
      case ind27:
         indName1=IndicatorName27;
         break;
      case ind28:
         indName1=IndicatorName28;
         break;
      case ind29:
         indName1=IndicatorName29;
         break;
      case ind30:
         indName1=IndicatorName30;
         break;
      case ind31:
         indName1=IndicatorName31;
         break;
      case ind32:
         indName1=IndicatorName32;
         break;


     }

   switch(inpInd2)
     {

      default :
         indName2="OFF";
         break;
      case ind0:
         indName2="OFF";
         break;
      case ind1:
         indName2=IndicatorName1;
         break;
      case ind2:
         indName2=IndicatorName2;
         break;
      case ind3:
         indName2=IndicatorName3;
         break;
      case ind4:
         indName2=IndicatorName4;
         break;
      case ind5:
         indName2=IndicatorName5;
         break;
      case ind6:
         indName2=IndicatorName6;
         break;
      case ind7:
         indName2=IndicatorName7;
         break;
      case ind8:
         indName2=IndicatorName8;
         break;
      case ind9:
         indName2=IndicatorName9;
         break;
      case ind10:
         indName2=IndicatorName10;
         break;
      case ind11:
         indName2=IndicatorName11;
         break;
      case ind12:
         indName2=IndicatorName12;
         break;
      case ind13:
         indName2=IndicatorName13;
         break;
      case ind14:
         indName2=IndicatorName14;
         break;
      case ind15:
         indName2=IndicatorName15;
         break;
      case ind16:
         indName2=IndicatorName16;
         break;
      case ind17:
         indName2=IndicatorName17;
         break;
      case ind18:
         indName2=IndicatorName18;
         break;
      case ind19:
         indName2=IndicatorName19;
         break;
      case ind20:
         indName2=IndicatorName20;
         break;
      case ind21:
         indName2=IndicatorName21;
         break;
      case ind22:
         indName2=IndicatorName22;
         break;
      case ind23:
         indName2=IndicatorName23;
         break;
      case ind24:
         indName2=IndicatorName24;
         break;
      case ind25:
         indName2=IndicatorName25;
         break;
      case ind26:
         indName2=IndicatorName26;
         break;
      case ind27:
         indName2=IndicatorName27;
         break;
      case ind28:
         indName2=IndicatorName28;
         break;
      case ind29:
         indName2=IndicatorName29;
         break;
      case ind30:
         indName2=IndicatorName30;
         break;
      case ind31:
         indName2=IndicatorName31;
         break;
      case ind32:
         indName2=IndicatorName32;
         break;


     }


   switch(inpInd3)
     {

      default :
         indName3="OFF";
         break;
      case ind0:
         indName3="OFF";
         break;
      case ind1:
         indName3=(string)IndicatorName1;
         break;
      case ind2:
         indName3=IndicatorName2;
         break;
      case ind3:
         indName3=IndicatorName3;
         break;
      case ind4:
         indName3=IndicatorName4;
         break;
      case ind5:
         indName3=IndicatorName5;
         break;
      case ind6:
         indName3=IndicatorName6;
         break;
      case ind7:
         indName3=IndicatorName7;
         break;
      case ind8:
         indName3=IndicatorName8;
         break;
      case ind9:
         indName3=IndicatorName9;
         break;
      case ind10:
         indName3=IndicatorName10;
         break;
      case ind11:
         indName3=IndicatorName11;
         break;
      case ind12:
         indName3=IndicatorName12;
         break;
      case ind13:
         indName3=IndicatorName13;
         break;
      case ind14:
         indName3=IndicatorName14;
         break;
      case ind15:
         indName3=IndicatorName15;
         break;
      case ind16:
         indName3=IndicatorName16;
         break;
      case ind17:
         indName3=IndicatorName17;
         break;
      case ind18:
         indName3=IndicatorName18;
         break;
      case ind19:
         indName3=IndicatorName19;
         break;
      case ind20:
         indName3=IndicatorName20;
         break;
      case ind21:
         indName3=IndicatorName21;
         break;
      case ind22:
         indName3=IndicatorName22;
         break;
      case ind23:
         indName3=IndicatorName23;
         break;
      case ind24:
         indName3=IndicatorName24;
         break;
      case ind25:
         indName3=IndicatorName25;
         break;
      case ind26:
         indName3=IndicatorName26;
         break;
      case ind27:
         indName3=IndicatorName27;
         break;
      case ind28:
         indName3=IndicatorName28;
         break;
      case ind29:
         indName3=IndicatorName29;
         break;
      case ind30:
         indName3=IndicatorName30;
         break;
      case ind31:
         indName3=IndicatorName31;
         break;
      case ind32:
         indName3=IndicatorName32;
         break;


     }
   string result="NO SIGNAL";
   bool check=false;

   if(inpOpenTradeStrategy ==JOINT)
     {
      smartBot.SendChatAction(InpChatID,ACTION_TYPING);

      if(((Signal1()=="SELL"&& Signal2() =="SELL")&& (Signal3()=="SELL" && Signal3()=="SELL")))
        {
         check=true;

         //+---------------------------------------------------------------------------------------------+


         result="SELL";


        }
      else




         if((((Signal1()=="BUY"&& Signal2() =="BUY")&& (Signal3()=="BUY" && Signal3()=="BUY"))))

           {



            result="BUY";

           }

      if(mysignal==3)
        {
         check=true;


         smartBot.SendChatAction(InpChatID,ACTION_TYPING);
         smartBot.SendChatAction(InpChatID,ACTION_SELL_SIGNAL);

         tradeReason= "---- SELL LIMIT SIGNAL----\n\nSTRATEGY :"+EnumToString(inpOpenTradeStrategy)+
                      StringFormat("\nName: Signal\xF4E3\nSymbol: %s\nTimeframe: %s\nSIGNAL : SELLLIMIT\nPrice: %2.4f\nTime: %s\nSL : %s\nTP :%s",
                                   symbol,
                                   EnumToString(InpTimFrame),
                                   bid,
                                   TimeToString(TimeCurrent()),(string)SL,(string)TP
                                  )+

                      "\n"+"REASONS :Signal1 :"+Signal1() +"\nTimeFrame1:"+EnumToString(inpTF1)  +"\nSIGNAL2 :"+Signal2()+"\nTimeFrame2:"+EnumToString(inpTF2) +"\nSignal3: "+Signal3()+"\n\n"+IndicatorName3 +"\nTimeFrame3:"+EnumToString(inpTF3)+"\n\n"+IndicatorName4 +"\nTimeFrame4:"+EnumToString(inpTF3) +"\nSignal4: "+Signal4()+"\n";

         smartBot.SendMessageToChannel(InpChannel,tradeReason);

         smartBot.SendMessage(InpChatID2,tradeReason);
         smartBot.SendScreenShotToChannel(InpChannel,symbol,InpTimFrame,InpIndiNAME,SendScreenshot);
        mytrade="tradePic";
         int count=0;
         //+---------------------------------------------------------------------------------------------+


         smartBot.SendMessageToChannel(InpChannel,tradeReason);
         smartBot.SendMessage(InpChatID2,tradeReason);
         result="SELL";


        }

      if(mysignal==2)
        {

         smartBot.SendChatAction(InpChatID,ACTION_TYPING);

         smartBot.SendMessage(InpChatID2,tradeReason);
         tradeReason= "---- BUY LIMIT SIGNAL----\nStrategy :"+EnumToString(inpOpenTradeStrategy)+StringFormat("\xF4E3\nSymbol: %s\nTimeframe: %s\nSIGNAL :@ BUYLIMIT\nPrice: %s\nTime: %s\nSL : %s\nTP :%s",
                      symbol,
                      EnumToString(PERIOD_CURRENT),
                      DoubleToString(SymbolInfoDouble(symbol,SYMBOL_ASK),vdigits),
                      TimeToString(TimeCurrent()),(string)SL,(string)TP)+
                      "\nREASONS: "+IndicatorName2 +"\nTimeFrame2:"+EnumToString(inpTF2)  +"\nSignal2: "+Signal2()+"\n\n"+IndicatorName3 +"\nTimeFrame3:"+EnumToString(inpTF3) +"\nSignal3: "+Signal3()+"\n\n"+IndicatorName4 +"\nTimeFrame4:"+EnumToString(inpTF3) +"\nSignal4: "+Signal4()+"\n";

         smartBot.SendMessageToChannel(InpChannel,tradeReason);
         smartBot.SendMessage(InpChatID,tradeReason);


         smartBot.SendMessageToChannel(InpChannel,tradeReason);
         smartBot.SendScreenShotToChannel(InpChannel,symbol,InpTimFrame,InpIndiNAME,SendScreenshot);
       
         int count=0;
         //+---------------------------------------------------------------------------------------------+

         smartBot.SendPhotoToChannel(mytrade,InpChannel,mytrade);

         smartBot.SendMessage(InpChatID2,tradeReason);

         smartBot.SendScreenShot(InpChatID2,symbol,InpTimFrame,InpIndiNAME,SendScreenshot);

         result="BUYLIMIT";

        }


      if(signal.type==5)
        {
         check=true;




         tradeReason= "---- SELL STOP SIGNAL----\n\nSTRATEGY :"+EnumToString(inpOpenTradeStrategy)+
                      StringFormat("\nName: Signal\xF4E3\nSymbol: %s\nTimeframe: %s\nSIGNAL : SELLSTOP\nPrice: %2.4f\nTime: %s\nSL : %s\nTP :%s",
                                   symbol,
                                   EnumToString(InpTimFrame),
                                   bid,
                                   TimeToString(TimeCurrent()),(string)SL,(string)TP
                                  )+

                      "\n"+"REASONS :Signal1 :"+Signal1() +"\nTimeFrame1:"+EnumToString(inpTF1)  +"\nSIGNAL2 :"+Signal2()+"\nTimeFrame2:"+EnumToString(inpTF2) +"\nSignal3: "+Signal3()+"\n\n"+IndicatorName3 +"\nTimeFrame3:"+EnumToString(inpTF3)+"\n\n"+IndicatorName4 +"\nTimeFrame4:"+EnumToString(inpTF3) +"\nSignal4: "+Signal4()+"\n";

         smartBot.SendMessageToChannel(InpChannel,tradeReason);
         smartBot.SendMessage(InpChatID2,tradeReason);

         smartBot.SendMessageToChannel(InpChannel,tradeReason);


         smartBot. SendChatAction(InpChatID,ACTION_UPLOAD_PHOTO);
         smartBot.SendScreenShotToChannel(InpChannel,symbol,InpTimFrame,InpIndiNAME,SendScreenshot);
     
         int count=0;
         //+---------------------------------------------------------------------------------------------+

         smartBot. SendChatAction(InpChatID,ACTION_UPLOAD_PHOTO);
         smartBot.SendPhotoToChannel(mytrade,InpChannel,mytrade,symbol);

         smartBot.SendMessage(InpChatID2,tradeReason);

         result="SELLSTOP";


        }

      if(mysignal==4)
        {



         smartBot.SendMessage(InpChatID,tradeReason);
         tradeReason= "---- BUY STOP SIGNAL----\nStrategy :"+EnumToString(inpOpenTradeStrategy)+StringFormat("\xF4E3\nSymbol: %s\nTimeframe: %s\nSIGNAL :@ BUYSTOP\nPrice: %s\nTime: %s\nSL : %s\nTP :%s",
                      symbol,
                      EnumToString(PERIOD_CURRENT),
                      DoubleToString(SymbolInfoDouble(symbol,SYMBOL_ASK),vdigits),
                      TimeToString(TimeCurrent()),(string)SL,(string)TP)+
                      "\nREASONS: "+IndicatorName2 +"\nTimeFrame2:"+EnumToString(inpTF2)  +"\nSignal2: "+Signal2()+"\n\n"+IndicatorName3 +"\nTimeFrame3:"+EnumToString(inpTF3) +"\nSignal3: "+Signal3()+"\n\n"+IndicatorName4 +"\nTimeFrame4:"+EnumToString(inpTF3) +"\nSignal4: "+Signal4()+"\n";

         smartBot. SendChatAction(InpChatID,ACTION_UPLOAD_PHOTO);
         smartBot.SendMessageToChannel(InpChannel,tradeReason);
         smartBot.SendMessage(InpChatID2,tradeReason);


         smartBot.SendMessageToChannel(InpChannel,tradeReason);
         smartBot.SendScreenShotToChannel(InpChannel,symbol,InpTimFrame,InpIndiNAME,SendScreenshot);
        mytrade="tradePic";
         int count=0;
         //+---------------------------------------------------------------------------------------------+


         smartBot.SendPhotoToChannel(mytrade,InpChannel,mytrade);

         smartBot.SendMessage(InpChatID2,tradeReason);

         smartBot. SendChatAction(InpChatID,ACTION_UPLOAD_PHOTO);
         smartBot.SendScreenShot(InpChatID2,symbol,InpTimFrame,InpIndiNAME,SendScreenshot);

         result="BUYSTOP";

        }


      return result;

     }
   else
      if(inpOpenTradeStrategy ==SEPARATE)
        {




        }

   if(check==false)
     {



      tradeReason= "---- NEUTRAL SIGNAL----\nStrategy :"+EnumToString(inpOpenTradeStrategy)+"\nTime :"+(string)TimeCurrent()+"\nSymbol:"+symbol+"\n\nSignal :>>  No trade signal found!  <<\n\nReasons :"+"\nIndicatorName1: "+IndicatorName1 +"\nTimeFrame1:  "+ EnumToString(inpTF1) +"\nSignal1: "+Signal1()+"\n\n"+
                   IndicatorName2 +"\nTimeFrame2:"+EnumToString(inpTF2)  +"\nSignal2: "+Signal2()+"\n\n"+IndicatorName3 +"\nTimeFrame3:"+EnumToString(inpTF3) +"\nSignal3: "+Signal3()+"\n\n"+IndicatorName4 +"\nTimeFrame4:"+EnumToString(inpTF3) +"\nSignal4: "+Signal4()+"\n";
      if(UseBot)
         smartBot.SendMessageToChannel(InpChannel,tradeReason);

     }

   return result;
  };






string tradeReason;
//+------------------------------------------------------------------+
//|                       SIGNAL MESSAGE                                           |
//+------------------------------------------------------------------+

string signalMessage() //signalmessage return only signal message for channels or chats
  {



   if(LongTradingts261M30)
     {
      message+="\n_______Overbought______ \nsymbol: "+overboversellSymbol[0] +"Period:"+EnumToString(PERIOD_M30);
      smartBot.SendMessage(InpChatID,message);
     }
   else
      if(!LongTradingts261M30)
        {
         message+="\n_______OverSold______ \nsymbol:"+overboversellSymbol[0]  +"Period:"+EnumToString(PERIOD_M30);

         smartBot.SendMessage(InpChatID,message);
        }

   smartBot.SendChatAction(InpChatID,ACTION_TYPING);
  


   if(TradeSignal()=="BUY")
     {




      smartBot.SendChatAction(InpChatID,ACTION_SELL_SIGNAL);
      tradeReason=StringFormat("\nMARKET BUY SIGNAL: %s\n Date :%s \nSymbol:%s\nSignal: %s\n______Reasons_________%s\n,Indi1Name:%s,\nTF1:%s ,\nShift1:%d,\nsignal1:%s, \nIndi2Name:%s,\nTF2:%s,\nShift2:%d,\nsigna2:%s, \nIndi3Name:%s,\nTF3:%s,\nShift3:%d ,\nsignal3:%s, \nIndi4Name:%s,\nTF4:%s,\nShift4:%d,\nsignal4:%s \n------------->><<---------------",
                               "\xF4E3", (string)TimeCurrent(),symbol,TradeSignal(),"__",
                               indName0,EnumToString(inpTF0),inpShift0,Signal1(),
                               indName1,EnumToString(inpTF1),inpShift1,Signal2(),
                               indName2,EnumToString(inpTF2),inpShift2,Signal3()
                               ,indName3,EnumToString(inpTF3),inpShift3,Signal4(),"-----------------"
                              );

     }
   if(TradeSignal()=="SELL")
     {

      tradeReason=StringFormat("\nMARKET SELL SIGNAL: %s\n Date :%s \nSymbol:%s\nSignal: %s\n______Reasons_________%s\n,Indi1Name:%s,\nTF1:%s ,\nShift1:%d,\nsignal1:%s, \nIndi2Name:%s,\nTF2:%s,\nShift2:%d,\nsigna2:%s, \nIndi3Name:%s,\nTF3:%s,\nShift3:%d ,\nsignal3:%s, \nIndi4Name:%s,\nTF4:%s,\nShift4:%d,\nsignal4:%s \n",


                               "\xF4E3", (string)TimeCurrent(),symbol,TradeSignal(),"__",
                               indName0,EnumToString(inpTF0),inpShift0,Signal1(),
                               indName1,EnumToString(inpTF1),inpShift1,Signal2(),
                               indName2,EnumToString(inpTF2),inpShift2,Signal3()
                               , indName3,EnumToString(inpTF3),inpShift3,Signal4(),"-----------------"
                              );

      smartBot.SendChatAction(InpChatID,ACTION_BUY_SIGNAL);

      smartBot.SendMessageToChannel(InpChannel,tradeReason);
      smartBot.SendMessage(InpChatID,tradeReason);



     }
   else
     {
      tradeReason=StringFormat("\nINVALID SIGNAL: %s\n Date :%s \nSymbol:%s\nSignal: %s\n______Reasons_________%s\n,Indi1Name:%s,\nTF1:%s ,\nShift1:%d,\nsignal1:%s, \nIndi2Name:%s,\nTF2:%s,\nShift2:%d,\nsigna2:%s, \nIndi3Name:%s,\nTF3:%s,\nShift3:%d ,\nsignal3:%s, \nIndi4Name:%s,\nTF4:%s,\nShift4:%d,\nsignal4:%s \n",


                               "\xF4E3", (string)TimeCurrent(),symbol,"not matched","__",
                               EnumToString(inpInd0),EnumToString(inpTF0),inpShift0,Signal1(),
                               EnumToString(inpInd1),EnumToString(inpTF1),inpShift1,Signal2(),
                               EnumToString(inpInd2),EnumToString(inpTF2),inpShift2,Signal3()
                               ,EnumToString(inpInd3),EnumToString(inpTF3),inpShift3,Signal4(),"-----------------"
                              );
      Sleep(100000);

      smartBot.SendChatAction(InpChatID,ACTION_NO_TRADE_NOW);

      smartBot.SendMessageToChannel(InpChannel,tradeReason);
      smartBot.SendMessage(InpChatID,tradeReason);


     };


   return "";
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void snrfibo(bool showfibolines)
  {
   if(!showfibolines)
      return;
   int counted_bars = IndicatorCounted();
   double day_highx = 0;
   double day_lowx = 0;
   double yesterday_highx = 0;
   double yesterday_openx = 0;
   double yesterday_lowx = 0;
   double yesterday_closex = 0;
   double today_openx = 0;
   double P = 0, S = 0, R = 0, S1 = 0, R1 = 0, S2 = 0, R2 = 0, S3 = 0, R3 = 0;
   int cnt = 720;
   double cur_dayx = 0;
   double prev_dayx = 0;
   double rates_d1x[2][6];
//---- exit if period is greater than daily charts
   if(Period() > 1440)
     {
      Print("Error - Chart period is greater than 1 day.");
      return; // then exit
     }
   cur_dayx = TimeDay(datetime(Time[0] - (gmtoffset()*3600)));
   yesterday_closex = iClose(NULL,snrperiod,1);
   today_openx = iOpen(NULL,snrperiod,0);
   yesterday_highx = iHigh(NULL,snrperiod,1);//day_high;
   yesterday_lowx = iLow(NULL,snrperiod,1);//day_low;
   day_highx = iHigh(NULL,snrperiod,1);
   day_lowx  = iLow(NULL,snrperiod,1);
   prev_dayx = cur_dayx;

   yesterday_highx = MathMax(yesterday_highx,day_highx);
   yesterday_lowx = MathMin(yesterday_lowx,day_lowx);
// messages="Yesterday High : "+ yesterday_high + ", Yesterday Low : " + yesterday_low + ", Yesterday Close : " + yesterday_close ;

//------ Pivot Points ------
   R = (yesterday_highx - yesterday_lowx);
   P = (yesterday_highx + yesterday_lowx + yesterday_closex)/3; //Pivot
   R1 = P + (R * 0.382);
   R2 = P + (R * 0.618);
   R3 = P + (R * 1);
   S1 = P - (R * 0.382);
   S2 = P - (R * 0.618);
   S3 = P - (R * 1);
//---- Set line labels on chart window
   drawLine(R3, "R3", clrLime, 0);
   drawLabel("Resistance 3", R3, clrLime);
   drawLine(R2, "R2", clrGreen, 0);
   drawLabel("Resistance 2", R2, clrGreen);
   drawLine(R1, "R1", clrDarkGreen, 0);
   drawLabel("Resistance 1", R1, clrDarkGreen);
   drawLine(P, "PIVIOT", clrBlue, 1);
   drawLabel("Piviot level", P, clrBlue);
   drawLine(S1, "S1", clrMaroon, 0);
   drawLabel("Support 1", S1, clrMaroon);
   drawLine(S2, "S2", clrCrimson, 0);
   drawLabel("Support 2", S2, clrCrimson);
   drawLine(S3, "S3", clrRed, 0);
   drawLabel("Support 3", S3, clrRed);
   return;
//----
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLabel(string A_name_0, double A_price_8, color A_color_16)
  {
   if(ObjectFind(A_name_0) != 0)
     {
      ObjectCreate(A_name_0, OBJ_TEXT, 0, Time[10], A_price_8);
      ObjectSetText(A_name_0, A_name_0, 8, "Arial", CLR_NONE);
      ObjectSet(A_name_0, OBJPROP_COLOR, A_color_16);
      return;
     }
   ObjectMove(A_name_0, 0, Time[10], A_price_8);
  }
//+------------------------------------------------------------------+
void drawLabel(string Ln, string Lt, int th, string ts, color Lc, int cr, int xp, int yp)
  {
   ObjectCreate(Ln, OBJ_LABEL, 0, 0, 0);
   ObjectSetText(Ln, Lt, th, ts, Lc);
   ObjectSet(Ln, OBJPROP_CORNER, cr);
   ObjectSet(Ln, OBJPROP_XDISTANCE, xp);
   ObjectSet(Ln, OBJPROP_YDISTANCE, yp);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void drawLine(double A_price_0, string A_name_8, color A_color_16, int Ai_20)
  {
   if(ObjectFind(A_name_8) != 0)
     {
      ObjectCreate(A_name_8, OBJ_HLINE, 0, Time[0], A_price_0, Time[0], A_price_0);
      if(Ai_20 == 1)
         ObjectSet(A_name_8, OBJPROP_STYLE, STYLE_SOLID);
      else
         ObjectSet(A_name_8, OBJPROP_STYLE, STYLE_DOT);
      ObjectSet(A_name_8, OBJPROP_COLOR, A_color_16);
      ObjectSet(A_name_8, OBJPROP_WIDTH, 1);
      return;
     }
   ObjectDelete(A_name_8);
   ObjectCreate(A_name_8, OBJ_HLINE, 0, Time[0], A_price_0, Time[0], A_price_0);
   if(Ai_20 == 1)
      ObjectSet(A_name_8, OBJPROP_STYLE, STYLE_SOLID);
   else
      ObjectSet(A_name_8, OBJPROP_STYLE, STYLE_DOT);
   ObjectSet(A_name_8, OBJPROP_COLOR, A_color_16);
   ObjectSet(A_name_8, OBJPROP_WIDTH, 1);
  }




//-------- Debit/Credit total -------------------
double ProfitValue=0;
bool StopTarget()
  {
   if((P1/AccountBalance()) *100 >= ProfitValue)
      return (true);
   return (false);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int gmtoffset()
  {
   int gmthour;
   int gmtminute;
   datetime timegmt; // Gmt time
   datetime timecurrent; // Current time
   int gmtoffset=0;
   timegmt=TimeGMT();
   timecurrent=TimeCurrent();
   gmthour=(int)StringToInteger(StringSubstr(TimeToStr(timegmt),11,2));
   gmtminute=(int)StringToInteger(StringSubstr(TimeToStr(timegmt),14,2));
   gmtoffset=TimeHour(timecurrent)-gmthour;
   if(gmtoffset<0)
      gmtoffset=24+gmtoffset;
   return(gmtoffset);
  }


//--- HUD Rectangle
void HUD()
  {
   ObjectCreate(ChartID(), "HUD", OBJ_RECTANGLE_LABEL, 0, 0, 0);
//--- set label coordinates
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_XDISTANCE, Xordinate+0);
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_YDISTANCE, Yordinate+20);
//--- set label size
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_XSIZE, 220);
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_YSIZE, 75);
//--- set background color
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_BGCOLOR, color5);
//--- set border type
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_BORDER_TYPE, BORDER_FLAT);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_CORNER, 4);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_COLOR, clrWhite);
//--- set flat border line style
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_STYLE, STYLE_SOLID);
//--- set flat border width
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_WIDTH, 1);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_BACK, false);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_SELECTED, false);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_HIDDEN, false);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(ChartID(), "HUD", OBJPROP_ZORDER, 0);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void HUD2()
  {
   EA_name() ;
   ObjectCreate(ChartID(), "HUD2", OBJ_RECTANGLE_LABEL, 0, 0, 0);
//--- set label coordinates
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_XDISTANCE, Xordinate+0);
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_YDISTANCE, Yordinate+75);
//--- set label size
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_XSIZE, 220);
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_YSIZE, 200);
//--- set background color
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_BGCOLOR, color6);
//--- set border type
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_BORDER_TYPE, BORDER_FLAT);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_CORNER, 4);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_COLOR, clrWhite);
//--- set flat border line style
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_STYLE, STYLE_SOLID);
//--- set flat border width
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_WIDTH, 1);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_BACK, false);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_SELECTABLE, false);
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_SELECTED, false);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_HIDDEN, false);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(ChartID(), "HUD2", OBJPROP_ZORDER, 0);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void EA_name()
  {
   string txt2 ="BOT_NAME: " +smartBot.Name()+ "20";
   if(ObjectFind(txt2) == -1)
     {
      ObjectCreate(txt2, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt2, OBJPROP_CORNER, 0);
      ObjectSet(txt2, OBJPROP_XDISTANCE, Xordinate+15);
      ObjectSet(txt2, OBJPROP_YDISTANCE, Yordinate+17);
     }
   ObjectSetText(txt2, "", 10, "Century Gothic", color1);


   txt2 = "reel" + "22";
   if(ObjectFind(txt2) == -1)
     {
      ObjectCreate(txt2, OBJ_LABEL, 1, 1, 1);
      ObjectSet(txt2, OBJPROP_CORNER, 0);
      ObjectSet(txt2, OBJPROP_XDISTANCE, Xordinate+10);
      ObjectSet(txt2, OBJPROP_YDISTANCE, Yordinate+55);
     }
   ObjectSetText(txt2, "_______________________", 11, "Arial", Gold);




  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GUI()
  {


   string matauang = "none";

   if(AccountCurrency() == "USD")
      matauang = "$";
   if(AccountCurrency() == "JPY")
      matauang = "¥";
   if(AccountCurrency() == "EUR")
      matauang = "€";
   if(AccountCurrency() == "GBP")
      matauang = "£";
   if(AccountCurrency() == "CHF")
      matauang = "CHF";
   if(AccountCurrency() == "AUD")
      matauang = "A$";
   if(AccountCurrency() == "CAD")
      matauang = "C$";
   if(AccountCurrency() == "RUB")
      matauang = "руб";

   if(matauang == "none")
      matauang = AccountCurrency();

//--- Equity / balance / floating

   string txt2, content;
   int content_len = StringLen(content);
   ObjectSetText(txt2, "[Time: "+TimeToStr(TimeCurrent(),TIME_DATE|TIME_MINUTES)+"]", 6, "Arial", clrWhite);

   string txt1 = "tatino" + "100";
   if(AccountEquity() >= AccountBalance())
     {
      if(ObjectFind(txt1) == -1)
        {
         ObjectCreate(txt1, OBJ_LABEL,0, 1, 0);
         ObjectSet(txt1, OBJPROP_CORNER, 4);
         ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +10);
         ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +70);
        }

      if(AccountEquity() == AccountBalance())
         ObjectSetText(txt1, "Equity : " + DoubleToStr(AccountEquity(), 2) + matauang, 16, "Century Gothic", color3);
      if(AccountEquity() != AccountBalance())
         ObjectSetText(txt1, "Equity : " + DoubleToStr(AccountEquity(), 2) + matauang, 11, "Century Gothic", color3);
     }
   if(AccountEquity() < AccountBalance())
     {
      if(ObjectFind(txt1) == -1)
        {
         ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
         ObjectSet(txt1, OBJPROP_CORNER, 4);
         ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +30);
         ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +100);
        }
      if(AccountEquity() == AccountBalance())
         ObjectSetText(txt1, "Equity : " + DoubleToStr(AccountEquity(), 2) + matauang, 17, "Century Gothic", color4);
      if(AccountEquity() != AccountBalance())
         ObjectSetText(txt1, "Equity : " + DoubleToStr(AccountEquity(), 2) + matauang, 14, "Century Gothic", color4);
     }

   txt1 = "tatino" + "101";
   if(AccountEquity() - AccountBalance() > 0)
     {
      if(ObjectFind(txt1) == -1)
        {
         ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
         ObjectSet(txt1, OBJPROP_CORNER, 4);
         ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
         ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +125);
        }
      ObjectSetText(txt1, "Floating PnL : +" + DoubleToStr(AccountEquity() - AccountBalance(), 2) + matauang, 9, "Century Gothic", color3);
     }
   if(AccountEquity() - AccountBalance() < 0)
     {
      if(ObjectFind(txt1) == -1)
        {
         ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
         ObjectSet(txt1, OBJPROP_CORNER, 4);
         ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
         ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +125);
        }
      ObjectSetText(txt1, "Floating PnL : " + DoubleToStr(AccountEquity() - AccountBalance(), 2) + matauang, 9, "Century Gothic", color4);
      message= "Floating PnL : " + DoubleToStr(AccountEquity() - AccountBalance(), 2);
      if(EventSetTimer(InpNews_Message_Interval))
         smartBot.SendMessage(InpChatID,message);

     }

   txt1 = "tatino" + "102";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +140);
     }
   if(OrdersTotal() != 0)
      ObjectSetText(txt1, "Balance      : " + DoubleToStr(AccountBalance(), 2) + matauang, 9, "Century Gothic", color2);
   if(OrdersTotal() == 0)
      ObjectSetText(txt1, "Balance      : " + DoubleToStr(AccountBalance(), 2) + matauang, 9, "Century Gothic", color2);

   txt1 = "tatino" + "103";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +155);
     }
   ObjectSetText(txt1, "AcNumber: " + string(AccountNumber()), 9, "Century Gothic", color2);

   txt1 = "tatino" + "104";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +235);
     }
   ObjectSetText(txt1, "NewsInfo : " + jamberita, 9, "Century Gothic", color3);

   message="NewsInfo : " + jamberita;
   if(EventSetTimer(InpNews_Message_Interval))
     {
      smartBot.SendMessage(InpChatID,message);
      smartBot.SendMessageToChannel(InpChannel,message);
     }
   txt1 = "tatino" + "105";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +250);
     }
   ObjectSetText(txt1, infoberita, 9, "Century Gothic", color3);

   txt1 = "tatino" + "106";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +170);
     }
   if(P1 >= 0)
      ObjectSetText(txt1, "Day Profit    : " + DoubleToStr(P1, 2) + matauang, 9, "Century Gothic", color3);
   if(P1 < 0)
      ObjectSetText(txt1, "Day Profit    : " + DoubleToStr(P1, 2) + matauang, 9, "Century Gothic", color4);

   txt1 = "tati" + "106w";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +185);
     }
   if(Wp1 >= 0)
      ObjectSetText(txt1, "WeekProfit : " + DoubleToStr(Wp1, 2) + matauang, 9, "Century Gothic", color3);
   if(Wp1 < 0)
      ObjectSetText(txt1, "WeekProfit : " + DoubleToStr(Wp1, 2) + matauang, 9, "Century Gothic", color4);

   txt1 = "tatino" + "107";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +100);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +210);
     }
   ObjectSetText(txt1, "Spread : " + DoubleToStr(MarketInfo(symbol,MODE_SPREAD)*0.1, 1) + " Pips", 9, "Century Gothic", color3);

   txt1 = "tato" + "108";
   if(ObjectFind(txt1) == -1)
     {
      ObjectCreate(txt1, OBJ_LABEL, 0, 0, 0);
      ObjectSet(txt1, OBJPROP_CORNER, 4);
      ObjectSet(txt1, OBJPROP_XDISTANCE, Xordinate +25);
      ObjectSet(txt1, OBJPROP_YDISTANCE, Yordinate +210);
     }
   if(harga > lastprice)
      ObjectSetText(txt1,  DoubleToStr(harga, vdigits), 14, "Century Gothic", Lime);
   if(harga < lastprice)
      ObjectSetText(txt1,  DoubleToStr(harga, vdigits), 14, "Century Gothic", Red);
   lastprice = harga;

  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void QnDeleteObject()
  {
   for(int i=ObjectsTotal()-1; i>=0; i--)
     {
      string oName = ObjectName(i);
      ObjectDelete(oName);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double rata_price(int tipe, string Pair)
  {
   double total_lot=0;
   double total_kali=0;
   double rata_price=0;
   for(int cnt=0; cnt<OrdersTotal(); cnt++)
     {
      int xx=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol()==Pair && (OrderType()==tipe) && OrderMagicNumber()==MagicNumber)
        {
         total_lot  = total_lot + OrderLots();
         total_kali = total_kali + (OrderLots() * OrderOpenPrice());
        }
     }
   if(total_lot!=0)
     {
      rata_price = total_kali / total_lot;
     }
   else
     {
      rata_price = 0;
     }
   return (rata_price);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool LookupLiveAccountNumbers()
  {
   bool ff=false;

   if(AccountNumber() ==2721926)
     {
      ff=true;
     }; //reo Citro wikarsa


   return (ff);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TextPosB(string nama, string isi, int ukuran, int x, int y, color warna, int pojok)
  {
   if(ObjectFind(nama)<0)
     {
      ObjectCreate(nama,OBJ_LABEL,0,0,0,0,0);
     }
   ObjectSet(nama,OBJPROP_CORNER,pojok);
   ObjectSet(nama,OBJPROP_XDISTANCE,x);
   ObjectSet(nama,OBJPROP_YDISTANCE,y);
   ObjectSetText(nama,isi,ukuran,"Arial bold",warna);

  }

//===========
void SET(int baris, string label2, color col)
  {
   int x,y1;
   y1=12;
   for(int t=0; t<100; t++)
     {
      if(baris==t)
        {
         y1=t*y1;
         break;
        }
     }


   x=63;
   y1=y1+10;
   string bar=DoubleToStr(baris,0);
   string kk=" : ";
   TextPos("SN"+bar, label2, 8, x, y1, col,Info_Corner);

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TextPos(string nama, string isi, int ukuran, int x, int y1, color warna, int pojok)
  {
   if(ObjectFind(nama)<0)
     {
      ObjectCreate(nama,OBJ_LABEL,0,0,0,0,0);
     }
   ObjectSet(nama,OBJPROP_CORNER,pojok);
   ObjectSet(nama,OBJPROP_XDISTANCE,x);
   ObjectSet(nama,OBJPROP_YDISTANCE,y1);
   ObjectSetText(nama,isi,ukuran,"Arial",warna);
  }



//===========
void SET2(int baris3, string label3, color col3)
  {
   int x3,y3;
   y3=12;
   for(int t3=0; t3<100; t3++)
     {
      if(baris3==t3)
        {
         y3=t3*y3;
         break;
        }
     }


   x3=170;
   y3=y3+10;
   string bar3=DoubleToStr(baris3,0);
   string kk3=" : ";
   TextPos3("SN3"+bar3, label3, 8, x3, y3, col3,Info_Corner);

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TextPos3(string nama3, string isi3, int ukuran3, int x3, int y3, color warna3, int pojok3)
  {
   if(ObjectFind(nama3)<0)
     {
      ObjectCreate(nama3,OBJ_LABEL,0,0,0,0,0);
     }
   ObjectSet(nama3,OBJPROP_CORNER,pojok3);
   ObjectSet(nama3,OBJPROP_XDISTANCE,x3);
   ObjectSet(nama3,OBJPROP_YDISTANCE,y3);
   ObjectSetText(nama3,isi3,ukuran3,"Arial",warna3);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Bt(string nm,int ys,color cl)
  {
   ObjectCreate(0,nm,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,nm,OBJPROP_XSIZE,110);
   ObjectSetInteger(0,nm,OBJPROP_YSIZE,30);
   ObjectSetInteger(0,nm,OBJPROP_BORDER_COLOR,clrSilver);
   ObjectSetInteger(0,nm,OBJPROP_XDISTANCE,ys);
   ObjectSetInteger(0,nm,OBJPROP_YDISTANCE,35);
   ObjectSetString(0,nm,OBJPROP_TEXT,nm);
   ObjectSetInteger(0,nm,OBJPROP_CORNER,2);
   ObjectSetInteger(0,nm,OBJPROP_BGCOLOR,cl);
   ObjectSetString(0,nm,OBJPROP_FONT,"Arial Bold");
   ObjectSetInteger(0,nm,OBJPROP_FONTSIZE,9);
   ObjectSetInteger(0,nm,OBJPROP_COLOR,White);
   ObjectSetInteger(0,nm,OBJPROP_BACK, false);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllm(int gg=0)
  {

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      Os=OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()==OP_BUY&& ((gg==1 && OrderProfit()>0)||gg==0))
        {
         Oc=OrderClose(i, OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), 3, CLR_NONE);

         continue;
        }
      if(OrderType()==OP_SELL&& ((gg==1 && OrderProfit()>0)||gg==0))
        {
         Oc=OrderClose(i, OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), 3, CLR_NONE);

        }
     }
  }

//+------------------------------------------------------------------+

//Function: check indicators signalbfr buffer value
bool signalbfr(double value)
  {
   if(value != 0 && value != EMPTY_VALUE)
      return true;
   else
      return false;
  }


//--------------------------------------------
void tradeResponse()
  {
//tggggg

   if(telegram== No)
      return;
   if(sendorder == Yes)
     {

      int total=OrdersTotal();
      datetime max_time = 0;

      for(int pos=0; pos<total; pos++) // Current orders -----------------------
        {
         if(OrderSelect(pos,SELECT_BY_POS)==false)
            continue;
         if(OrderOpenTime() <= _opened_last_time)
            continue;


         message = StringFormat(
                      "\n----TRADE_EXPERT\n OPEN ORDER----\r\n%s %s lots \r\n%s @ %s \r\nSL - %s\r\nTP - %s\r\n----------------------\r\n\n",
                      order_type(),
                      DoubleToStr(OrderLots(),2),
                      OrderSymbol(),
                      DoubleToStr(OrderOpenPrice(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                      DoubleToStr(OrderStopLoss(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                      DoubleToStr(OrderTakeProfit(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS))
                   );
         smartBot.SendMessageToChannel(InpChannel,message);
         if(StringLen(message) > 0)
           {

            smartBot.SendMessageToChannel(InpChannel,message);
           }
         max_time = MathMax(max_time,OrderOpenTime());

        }

      _opened_last_time = MathMax(max_time,_opened_last_time);

     }

   if(sendclose == Yes)
     {
      datetime max_time = 0;
      double day_profit = 0;

      bool is_closed = false;
      int total = OrdersHistoryTotal();
      for(int pos=0; pos<total; pos++)  // History orders-----------------------
        {

         if(TimeDay(TimeCurrent()) == TimeDay(OrderCloseTime()) && OrderCloseTime() > iTime(NULL,1440,0))
           {
            day_profit += order_pips();
           }

         if(OrderSelect(pos,SELECT_BY_POS,MODE_HISTORY)==false)
            continue;
         if(OrderCloseTime() <= _closed_last_time)
            continue;

         printf(TimeToStr(OrderCloseTime()));
         is_closed = true;
         message = StringFormat("\n"+smartBot.Name() +"CLOSE PROFIT----\r\n%s %s lots\r\n%s @ %s\r\nCP - %s \r\nTP - %s \r\nProfit: %s PIPS \r\n--------------------------------\r\n\n",
                                order_type(),
                                DoubleToStr(OrderLots(),2),
                                OrderSymbol(),
                                DoubleToStr(OrderOpenPrice(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                                DoubleToStr(OrderClosePrice(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                                DoubleToStr(OrderTakeProfit(),(int)MarketInfo(OrderSymbol(),MODE_DIGITS)),
                                DoubleToStr(order_pips()/10,1)
                               );

         if(is_closed)
            smartBot.SendMessageToChannel(InpChannel,message);
         if(StringLen(message) > 0)
           {
            if(is_closed)
               message += StringFormat("Total Profit of today : %s PIPS",DoubleToStr(day_profit/10,1));
            printf(message);
            smartBot.SendMessageToChannel(InpChannel,message);
            Sleep(200);
            smartBot.SendMessage(InpChatID2,message);
           }

         max_time = MathMax(max_time,OrderCloseTime());

        }
      _closed_last_time = MathMax(max_time,_closed_last_time);

     }


  } //tggggggggggggggggg

//===============tg
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
//|                                                                  |
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

datetime _tms_last_time_messaged;



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string ReadCBOE()
  {

   string cookie=NULL,headers;
   char post[],result[];
   string TXT="";
   int res;
//--- to work with the server, you must add the URL "https://www.google.com/finance"
//--- the list of allowed URL (Main menu-> Tools-> Settings tab "Advisors"):
   string google_url="http://ec.forexprostools.com/?columns=exc_currency,exc_importance&importance=1,2,3&calType=week&timeZone=15&lang=1";
//string google_url="http://ec.forexprostools.com/?columns=exc_currency,exc_importance&importance=1,2,3&calType=week&timeZone=15&lang=1";
//---
   ResetLastError();
//--- download html-pages
   int timeout=5000; //--- timeout less than 1,000 (1 sec.) is insufficient at a low speed of the Internet
   res=WebRequest("GET",google_url,cookie,NULL,timeout,post,0,result,headers);
//--- error checking
   if(res==-1)
     {
      Print("WebRequest error, err.code  =",GetLastError());
      MessageBox("You must add the address ' "+google_url+"' in the list of allowed URL tab 'Advisors' "," Error ",MB_ICONINFORMATION);
      //--- You must add the address ' "+ google url"' in the list of allowed URL tab 'Advisors' "," Error "
     }
   else
     {
      //--- successful download
      //PrintFormat("File successfully downloaded, the file size in bytes  =%d.",ArraySize(result));
      //--- save the data in the file
      int filehandle=FileOpen("realTatino-log.html",FILE_WRITE|FILE_BIN);
      //--- ïðîâåðêà îøèáêè
      if(filehandle!=INVALID_HANDLE)
        {
         //---save the contents of the array result [] in file
         FileWriteArray(filehandle,result,0,ArraySize(result));
         //--- close file
         FileClose(filehandle);

         int filehandle2=FileOpen("realTatino-log.html",FILE_READ|FILE_BIN);
         TXT=FileReadString(filehandle2,ArraySize(result));
         FileClose(filehandle2);
        }
      else
        {
         Print("Error in FileOpen. Error code =",GetLastError());
        }
     }

   return(TXT);
  }

//+------------------------------------------------------------------+
datetime TimeNewsFunck(int nomf)
  {
   string s=NewsArr[0][nomf];
   string time=StringConcatenate(StringSubstr(s,0,4),".",StringSubstr(s,5,2),".",StringSubstr(s,8,2)," ",StringSubstr(s,11,2),":",StringSubstr(s,14,4));
   return((datetime)(StringToTime(time) + offsets*3600));
  }
//////////////////////////////////////////////////////////////////////////////////
void UpdateNews()
  {
   string TEXT=ReadCBOE();
   int sh = StringFind(TEXT,"pageStartAt>")+12;
   int sh2= StringFind(TEXT,"</tbody>");
   TEXT=StringSubstr(TEXT,sh,sh2-sh);

   sh=0;
   while(!IsStopped())
     {
      sh = StringFind(TEXT,"event_timestamp",sh)+17;
      sh2= StringFind(TEXT,"onclick",sh)-2;
      if(sh<17 || sh2<0)
         break;
      NewsArr[0][NomNews]=StringSubstr(TEXT,sh,sh2-sh);

      sh = StringFind(TEXT,"flagCur",sh)+10;
      sh2= sh+3;
      if(sh<10 || sh2<3)
         break;
      NewsArr[1][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      if(StringFind(str1,NewsArr[1][NomNews])<0)
         continue;

      sh = StringFind(TEXT,"title",sh)+7;
      sh2= StringFind(TEXT,"Volatility",sh)-1;

      if(sh<7 || sh2<0)
         break;
      NewsArr[2][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      if(StringFind(NewsArr[3][NomNews],judulnews)>=0 && !Vtunggal)
         continue;
      if(StringFind(NewsArr[2][NomNews],"High")>=0 && !Vhigh)
         continue;
      if(StringFind(NewsArr[2][NomNews],"Medium")>=0 && !Vmedium)
         continue;
      if(StringFind(NewsArr[2][NomNews],"Low")>=0 && !Vlow)
         continue;

      sh=StringFind(TEXT,"left event",sh)+12;
      int sh1=StringFind(TEXT,"Speaks",sh);
      sh2=StringFind(TEXT,"<",sh);
      if(sh<12 || sh2<0)
         break;
      if(sh1<0 || sh1>sh2)
         NewsArr[3][NomNews]=StringSubstr(TEXT,sh,sh2-sh);
      else
         NewsArr[3][NomNews]=StringSubstr(TEXT,sh,sh1-sh);

      NomNews++;
      if(NomNews==300)
         break;
     }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void datanews()
  {

   if(MQLInfoInteger(MQL_TESTER) || AvoidNews==false)
      printf("Avoid news status:OFF");
   return;

   offsets = gmtoffset();
   double CheckNews=0;
   if(AfterNewsStop>0)
     {
      if(TimeCurrent()-LastUpd>=Upd)
        {
         Comment("News Loading...");
         Print("News Loading...");
         UpdateNews();
         LastUpd=TimeCurrent();
         Comment("");
         messages="___NEWS LOADING_____";
         smartBot.SendMessageToChannel(InpChannel,messages);


        }
      WindowRedraw();
      //---Draw a line on the chart news--------------------------------------------
      if(DrawLines)
        {
         for(int i=0; i<NomNews; i++)
           {
            string Name=StringSubstr(TimeToStr(TimeNewsFunck(i),TIME_MINUTES)+"_"+NewsArr[1][i]+"_"+NewsArr[3][i],0,63);
            if(NewsArr[3][i]!="")
               if(ObjectFind(Name)==0)
                  continue;
            if(StringFind(str1,NewsArr[1][i])<0)
               continue;
            if(TimeNewsFunck(i)<TimeCurrent() && Next)
               continue;

            color clrf = clrNONE;
            if(Vtunggal && StringFind(NewsArr[3][i],judulnews)>=0)
               clrf=highc;
            if(Vhigh && StringFind(NewsArr[2][i],"High")>=0)
               clrf=highc;
            if(Vmedium && StringFind(NewsArr[2][i],"Medium")>=0)
               clrf=mediumc;
            if(Vlow && StringFind(NewsArr[2][i],"Low")>=0)
               clrf=lowc;

            if(clrf==clrNONE)
               continue;

            if(NewsArr[3][i]!="")
              {
               ObjectCreate(Name,0,OBJ_VLINE,TimeNewsFunck(i),0);
               ObjectSet(Name,OBJPROP_COLOR,clrf);
               ObjectSet(Name,OBJPROP_STYLE,Style);
               ObjectSetInteger(0,Name,OBJPROP_BACK,true);
              }
           }
        }
      //---------------event Processing------------------------------------
      int i;
      CheckNews=0;
      for(i=0; i<NomNews; i++)
        {
         int power=0;
         if(Vtunggal && StringFind(NewsArr[3][i],judulnews)>=0)
            power=1;
         if(Vhigh && StringFind(NewsArr[2][i],"High")>=0)
            power=1;
         if(Vmedium && StringFind(NewsArr[2][i],"Medium")>=0)
            power=2;
         if(Vlow && StringFind(NewsArr[2][i],"Low")>=0)
            power=3;
         if(power==0)
            continue;
         if(TimeCurrent()+MinBefore*60>TimeNewsFunck(i) && TimeCurrent()-60*MinAfter<TimeNewsFunck(i) && StringFind(str1,NewsArr[1][i])>=0)
           {
            jamberita= " In "+string((int)(TimeNewsFunck(i)-TimeCurrent())/60)+" Minutes ["+NewsArr[1][i]+"]";
            infoberita = ">> "+StringSubstr(NewsArr[3][i],0,28);
            CheckNews=1;
            break;
           }
         else
            CheckNews=0;
        }
      if(CheckNews==1 && i!=Now && Signal)
        {

         Alert("within  ",(int)(TimeNewsFunck(i)-TimeCurrent())/60," minutes released news Currency ",NewsArr[1][i],"_",NewsArr[3][i]);
        };
      if(CheckNews==1 && i!=Now  && sendnews == Yes)
        {
         messages="     >> NEWS ALERT <<\nTIME :Within "+string((int)(TimeNewsFunck(i)-TimeCurrent())/60)+" minutes released news \nCurrency : "+NewsArr[1][i]+"\nImpact : "+NewsArr[2][i]+"\nTitle : "+NewsArr[3][i]+"\nForecast: \nPreviours:------more detail https://bit.ly/35NPVPi --------------";
         Now=i;
         smartBot.SendMessageToChannel(InpChannel,messages);
         smartBot.SendMessage(InpChatID2,messages);
        }

     }

   if(CheckNews>0 && NewsFilter)
      trade=false;
   if(CheckNews>0)
     {

      /////  We are doing here if we are in the framework of the news
      if(!StopTarget() && NewsFilter)

         infoberita ="News Time >> TRADING OFF";
      smartBot.SendMessageToChannel(InpChannel,infoberita);
      smartBot.SendMessage(InpChatID2,messages);

      if(!StopTarget()&& !NewsFilter)

         infoberita="Attention!! News Time";
      smartBot.SendMessageToChannel(InpChannel,infoberita);
      smartBot.SendMessage(InpChatID,messages);

     }
   else
     {
      if(NewsFilter)
         trade=true;
      // We are out of scope of the news release (No News)
      if(!StopTarget())

         jamberita= "\nWe are now out of scope of the news release\n"+(string)TimeCurrent();
      infoberita = "waiting......";
      smartBot.SendMessageToChannel(InpChannel,jamberita+"  "+infoberita);
      smartBot.SendMessage(InpChannelChat,infoberita);

     }
   return;
  }

//+------------------------------------------------------------------+
//|                      CHECK TRAILING                              |
//+------------------------------------------------------------------+
void  checkTrail(bool usetrailing)
  {
   if(usetrailing==false)
      printf("trailling stop status:OFF");
   return;
   int count=OrdersTotal();
   double ts=0;
   while(count>0)
     {
      int os=OrderSelect(count-1,MODE_TRADES);

      if(OrderMagicNumber()==MagicNumber)
        {
         //--- symbol variables
         double pip=SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT);
         if(SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==5 || SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==3)
            pip*=10;
         int digits = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);

         switch(OrderType())
           {
            default:
               break;
            case ORDER_TYPE_BUY:
              {
               switch(TrailingUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > TrailingStart;
                     if(is_activated)
                       {
                        double steps = MathFloor((profit_distance - TrailingStart)/TrailingStep);
                        if(steps>0)
                          {
                           //--- calculate stop loss distance
                           double stop_distance = GetDistanceInPoints(OrderSymbol(),TrailingUnit,TrailingStop*steps,1,OrderLots()); //--- pip value forced to 1 because TrailingStop*steps already in points
                           double stop_price = NormalizeDouble(OrderOpenPrice()+stop_distance,digits);
                           //--- move stop if needed
                           if((OrderStopLoss()==0)||(stop_price > OrderStopLoss()))
                             {
                              if(DebugTrailingStop)
                                {
                                 Print("TS[Start:$"+DoubleToString(TrailingStart,2)
                                       +",Step:$"+DoubleToString(TrailingStep,2)
                                       +",Stop:$"+DoubleToString(TrailingStop,2)+"]"
                                       +" p:$"+DoubleToString(profit_distance,digits)
                                       +" s:$"+DoubleToString(steps,digits)
                                       +" sd:"+DoubleToString(stop_distance,digits)
                                       +" sp:"+DoubleToString(stop_price,digits));
                                }
                              if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                {
                                 Print("Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));

                                 message="Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());
                                 smartBot.SendMessage(InpChatID2,message);

                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = SymbolInfoDouble(OrderSymbol(),SYMBOL_BID) - OrderOpenPrice();
                     bool is_activated = profit_distance > TrailingStart*pip;
                     if(is_activated)    //--- get trailing steps
                       {
                        double steps = MathFloor((profit_distance - TrailingStart*pip)/(TrailingStep*pip));
                        if(steps>0)
                          {
                           //--- calculate stop loss distance
                           double stop_distance = TrailingStop*pip*steps;
                           double stop_price = NormalizeDouble(OrderOpenPrice()+stop_distance,digits);
                           //--- move stop if needed
                           if((OrderStopLoss()==0)||(stop_price > OrderStopLoss()))
                             {
                              if(DebugTrailingStop)
                                {
                                 Print("TS[Start:"+DoubleToString(TrailingStart)
                                       +",Step:"+DoubleToString(TrailingStep)
                                       +",Stop:"+DoubleToString(TrailingStop)+"]"
                                       +" p:"+DoubleToString(profit_distance,digits)
                                       +" s:"+DoubleToString(steps)
                                       +" sd:"+DoubleToString(stop_distance,digits)
                                       +" sp:"+DoubleToString(stop_price,digits));
                                }
                              if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                {
                                 Print("Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));

                                 message="Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());
                                 smartBot.SendMessage(InpChatID,message);

                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
            case ORDER_TYPE_SELL:
              {
               switch(TrailingUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > TrailingStart;
                     if(is_activated)
                       {
                        double steps = MathFloor((profit_distance - TrailingStart)/TrailingStep);
                        if(steps>0)
                          {
                           //--- calculate stop loss distance
                           double stop_distance = GetDistanceInPoints(OrderSymbol(),TrailingUnit,TrailingStop*steps,1,OrderLots());//--- pip value forced to 1 because TrailingStop*steps already in points
                           double stop_price = NormalizeDouble(OrderOpenPrice()-stop_distance,digits);
                           //--- move stop if needed
                           if((OrderStopLoss()==0)||(stop_price < OrderStopLoss()))
                             {
                              if(DebugTrailingStop)
                                {
                                 Print("TS[Start:$"+DoubleToString(TrailingStart,2)
                                       +",Step:$"+DoubleToString(TrailingStep,2)
                                       +",Stop:$"+DoubleToString(TrailingStop,2)+"]"
                                       +" p:$"+DoubleToString(profit_distance,digits)
                                       +" s:$"+DoubleToString(steps,digits)
                                       +" sd:"+DoubleToString(stop_distance,digits)
                                       +" sp:"+DoubleToString(stop_price,digits));
                                }
                              if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                {
                                 Print("Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                 if(UseBot)
                                    message="Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());
                                 smartBot.SendMessage(InpChatID2,message);

                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = OrderOpenPrice() - SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK);
                     bool is_activated = profit_distance > TrailingStart*pip;
                     if(is_activated)    //--- get trailing steps
                       {
                        double steps = MathFloor((profit_distance - TrailingStart*pip)/(TrailingStep*pip));
                        if(steps>0)
                          {
                           //--- calculate stop loss distance
                           double stop_distance = TrailingStop*pip*steps;
                           double stop_price = NormalizeDouble(OrderOpenPrice()-stop_distance,digits);
                           //--- move stop if needed
                           if((OrderStopLoss()==0) || (stop_price < OrderStopLoss()))
                             {
                              if(DebugTrailingStop)
                                {
                                 Print("TS[Start:"+DoubleToString(TrailingStart)
                                       +",Step:"+DoubleToString(TrailingStep)
                                       +",Stop:"+DoubleToString(TrailingStop)+"]"
                                       +" p:"+DoubleToString(profit_distance,digits)
                                       +" s:"+DoubleToString(steps)
                                       +" sd:"+DoubleToString(stop_distance,digits)
                                       +" sp:"+DoubleToString(stop_price,digits));
                                }
                              if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                {
                                 Print("Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                 if(UseBot)
                                    message="Failed to modify trailing stop. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());
                                 smartBot.SendMessage(InpChatID2,message);

                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
           }
        }
      count--;
     }
  }

//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetDistanceInPoints(const string symbols,ENUM_UNIT unit,double value,double pip_value,double volume)
  {
   switch(unit)
     {
      default:
         PrintFormat("Unhandled unit %s, returning -1",EnumToString(unit));
         break;
      case InPips:
        {
         double distance = value;

         if(IsTesting()&&DebugUnit)
            PrintFormat("%s:%.2f dist: %.5f",EnumToString(unit),value,distance);

         return value;
        }
      case InDollars:
        {
         double tickSize        = SymbolInfoDouble(symbols,SYMBOL_TRADE_TICK_SIZE);
         double tickValue       = SymbolInfoDouble(symbols,SYMBOL_TRADE_TICK_VALUE);
         double dVpL            = tickValue / tickSize;
         double distance        = (value /(volume * dVpL))/pip_value;

         if(IsTesting()&&DebugUnit)
            PrintFormat("%s:%s:%.2f dist: %.5f volume:%.2f dVpL:%.5f pip:%.5f",symbols,EnumToString(unit),value,distance,volume,dVpL,pip_value);

         return distance;
        }
     }
   return -1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void  _funcBE(bool usebreakeaven)
  {
   if(usebreakeaven==false)
      return;
   int count=OrdersTotal();
   double ts=0;
   while(count>0)
     {
      int os=OrderSelect(count-1,MODE_TRADES);

      if(OrderMagicNumber()==MagicNumber)
        {
         //--- symbol variables
         double pip=SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT);
         if(SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==5 || SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==3)
            pip*=10;
         int digits = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);

         switch(OrderType())
           {
            default:
               break;
            case ORDER_TYPE_BUY:
              {
               switch(BreakEvenUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > BreakEvenTrigger;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / BreakEvenTrigger);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoBreakEven)
                             {
                              //--- calculate stop loss distance
                              double stop_distance   = GetDistanceInPoints(OrderSymbol(),BreakEvenUnit,BreakEvenProfit*steps,1,OrderLots()); //--- pip value forced to 1 because BreakEvenProfit*steps already in points
                              double stop_price      = NormalizeDouble(OrderOpenPrice()+stop_distance,digits);
                              //--- move stop if needed
                              if((OrderStopLoss()==0)||(stop_price > OrderStopLoss()))
                                {
                                 if(DebugBreakEven)
                                   {
                                    Print("BE[Trigger:$"+DoubleToString(BreakEvenTrigger,2)
                                          +",Profit:$"+DoubleToString(BreakEvenProfit,2)
                                          +",Max:"+DoubleToString(MaxNoBreakEven,2)+"]"
                                          +" p:$"+DoubleToString(profit_distance,digits)
                                          +" s:$"+DoubleToString(steps,digits)
                                          +" sd:"+DoubleToString(stop_distance,digits)
                                          +" sp:"+DoubleToString(stop_price,digits));
                                   }
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                   {
                                    Print("Failed to modify break even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                    if(UseBot)
                                       message="Failed to modify break even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());
                                    smartBot.SendMessage(InpChatID2,message);

                                   }
                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = SymbolInfoDouble(OrderSymbol(),SYMBOL_BID) - OrderOpenPrice();
                     bool is_activated = profit_distance > BreakEvenTrigger*pip;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / BreakEvenTrigger*pip);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoBreakEven)
                             {
                              double stop_distance = BreakEvenProfit*pip*steps;
                              double stop_price = NormalizeDouble(OrderOpenPrice()+stop_distance,digits);
                              //--- move stop if needed
                              if((OrderStopLoss()==0)||(stop_price > OrderStopLoss()))
                                {
                                 if(DebugBreakEven)
                                   {
                                    Print("BE[Trigger:"+DoubleToString(BreakEvenTrigger)
                                          +",Profit:"+DoubleToString(BreakEvenProfit)
                                          +",Max:"+IntegerToString(MaxNoBreakEven)+"]"
                                          +" p:"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps)
                                          +" sd:"+DoubleToString(stop_distance,digits)
                                          +" sp:"+DoubleToString(stop_price,digits));
                                    messages="BE[Trigger:"+DoubleToString(BreakEvenTrigger)
                                             +",Profit:"+DoubleToString(BreakEvenProfit)
                                             +",Max:"+IntegerToString(MaxNoBreakEven)+"]"
                                             +" p:"+DoubleToString(profit_distance,digits)
                                             +" s:"+DoubleToString(steps)
                                             +" sd:"+DoubleToString(stop_distance,digits)
                                             +" sp:"+DoubleToString(stop_price,digits);
                                    if(UseBot)
                                       smartBot.SendMessage(InpChatID2,messages);
                                   }
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                   {
                                    Print("Failed to modify break even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                    if(UseBot)
                                       message="Failed to modify Break Even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());





                                    smartBot.SendMessage(InpChatID2,message);

                                   }
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
            case ORDER_TYPE_SELL:
              {
               switch(BreakEvenUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > BreakEvenTrigger;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / BreakEvenTrigger);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoBreakEven)
                             {
                              //--- calculate stop loss distance
                              double stop_distance = GetDistanceInPoints(OrderSymbol(),BreakEvenUnit,BreakEvenProfit*steps,1,OrderLots());
                              double stop_price    = NormalizeDouble(OrderOpenPrice()-stop_distance,digits);
                              //--- move stop if needed
                              if((OrderStopLoss()==0)||(stop_price < OrderStopLoss()))
                                {
                                 if(DebugBreakEven)
                                   {
                                    Print("BE[Trigger:$"+DoubleToString(BreakEvenTrigger,2)
                                          +",Profit:$"+DoubleToString(BreakEvenProfit,2)
                                          +",Max:"+IntegerToString(MaxNoBreakEven)+"]"
                                          +" p:$"+DoubleToString(profit_distance,digits)
                                          +" s:$"+DoubleToString(steps,digits)
                                          +" sd:"+DoubleToString(stop_distance,digits)
                                          +" sp:"+DoubleToString(stop_price,digits));
                                    messages="BE[Trigger:$"+DoubleToString(BreakEvenTrigger,2)
                                             +",Profit:$"+DoubleToString(BreakEvenProfit,2)
                                             +",Max:"+IntegerToString(MaxNoBreakEven)+"]"
                                             +" p:$"+DoubleToString(profit_distance,digits)
                                             +" s:$"+DoubleToString(steps,digits)
                                             +" sd:"+DoubleToString(stop_distance,digits)
                                             +" sp:"+DoubleToString(stop_price,digits);
                                    if(UseBot)
                                       smartBot.SendMessage(InpChatID2,messages);
                                   }
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                   {
                                    Print("Failed to modify break even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                    if(UseBot)
                                       message="Failed to modify Break Even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());
                                    smartBot.SendMessage(InpChatID2,message);

                                   }
                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = OrderOpenPrice() - SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK);
                     bool is_activated = profit_distance > BreakEvenTrigger*pip;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / BreakEvenTrigger*pip);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoBreakEven)
                             {
                              double stop_distance = BreakEvenProfit*pip*steps;
                              double stop_price    = NormalizeDouble(OrderOpenPrice()-stop_distance,digits);
                              //--- move stop if needed
                              if((OrderStopLoss()==0)||(stop_price < OrderStopLoss()))
                                {
                                 if(DebugBreakEven)
                                   {
                                    Print("BE[Trigger:"+DoubleToString(BreakEvenTrigger)
                                          +",Profit:"+DoubleToString(BreakEvenProfit)
                                          +",Max:"+IntegerToString(MaxNoBreakEven)+"]"
                                          +" p:"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps)
                                          +" sd:"+DoubleToString(stop_distance,digits)
                                          +" sp:"+DoubleToString(stop_price,digits));
                                   }
                                 if(!OrderModify(OrderTicket(),OrderOpenPrice(),stop_price,OrderTakeProfit(),0,clrGold))
                                   {
                                    Print("Failed to modify break even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                    if(UseBot)
                                       message="Failed to modify Break Even. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());
                                    smartBot.SendMessage(InpChatID2,message);

                                   }
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
           }

        }
      count--;
     }
  }

//+------------------------------------------------------------------+
//|                 CHECK PARTIAL CLOSE                              |
//+------------------------------------------------------------------+
void CheckPartialClose(bool   checkPartialClose)
  {
   if(!checkPartialClose)
      return;
   int count=OrdersTotal();
   double ts=0;
   while(count>0)
     {
      int os=OrderSelect(count-1,MODE_TRADES);

      if(OrderMagicNumber()==MagicNumber)
        {
         //--- symbol variables
         double pip=SymbolInfoDouble(OrderSymbol(),SYMBOL_POINT);
         if(SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==5 || SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS)==3)
            pip*=10;
         int digits = (int)SymbolInfoInteger(OrderSymbol(),SYMBOL_DIGITS);

         switch(OrderType())
           {
            default:
               break;
            case ORDER_TYPE_BUY:
              {
               switch(PartialCloseUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > PartialCloseTrigger;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / PartialCloseTrigger);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoPartialClose)
                             {
                              //--- calculate new lot size
                              int lot_digits = (int)(MathLog(SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_STEP))/MathLog(0.1));
                              double lots = NormalizeDouble(OrderLots() * PartialClosePercent,lot_digits);
                              if(lots < SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_MIN))    //--- close all
                                {
                                 lots = OrderLots();
                                }
                              if(OrderClose(OrderTicket(),lots,SymbolInfoDouble(OrderSymbol(),SYMBOL_BID),MaxSlippage,clrYellow))
                                {
                                 if(DebugPartialClose)
                                   {
                                    Print("PC[Trigger:$"+DoubleToString(PartialCloseTrigger,2)
                                          +",Percent:"+DoubleToString(PartialClosePercent,2)
                                          +",Max:"+IntegerToString(MaxNoPartialClose)+"]"
                                          +" p:$"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps,digits)
                                          +" l:"+DoubleToString(lots,lot_digits));
                                   }
                                }
                              else
                                {
                                 Print("Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));

                                 messages=   "Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());

                                 if(UseBot)
                                    smartBot.SendMessageToChannel(InpChannel,messages);
                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = SymbolInfoDouble(OrderSymbol(),SYMBOL_BID) - OrderOpenPrice();
                     bool is_activated = profit_distance > PartialCloseTrigger*pip;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / PartialCloseTrigger*pip);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoPartialClose)
                             {
                              //--- calculate new lot size
                              int lot_digits = (int)(MathLog(SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_STEP))/MathLog(0.1));
                              double lots = NormalizeDouble(OrderLots() * PartialClosePercent,lot_digits);
                              if(lots < SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_MIN))    //--- close all
                                {
                                 lots = OrderLots();
                                }
                              if(OrderClose(OrderTicket(),lots,SymbolInfoDouble(OrderSymbol(),SYMBOL_BID),MaxSlippage,clrYellow))
                                {
                                 if(DebugPartialClose)
                                   {
                                    Print("PC[Trigger:"+DoubleToString(PartialCloseTrigger,2)
                                          +",Percent:"+DoubleToString(PartialClosePercent,2)
                                          +",Max:"+IntegerToString(MaxNoPartialClose)+"]"
                                          +" p:"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps,digits)
                                          +" l:"+DoubleToString(lots,lot_digits));
                                   }
                                }
                              else
                                {
                                 Print("Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                 messages="Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());

                                 if(UseBot)
                                    smartBot.SendMessage(InpChatID2,messages);
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
            case ORDER_TYPE_SELL:
              {
               switch(PartialCloseUnit)
                 {
                  default:
                  case InDollars:
                    {
                     double profit_distance = OrderProfit();
                     bool is_activated = profit_distance > PartialCloseTrigger;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / PartialCloseTrigger);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoPartialClose)
                             {
                              //--- calculate new lot size
                              int lot_digits = (int)(MathLog(SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_STEP))/MathLog(0.1));
                              double lots = NormalizeDouble(OrderLots() * PartialClosePercent,lot_digits);
                              if(lots < SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_MIN))    //--- close all
                                {
                                 lots = OrderLots();
                                }
                              if(OrderClose(OrderTicket(),lots,SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK),MaxSlippage,clrYellow))
                                {
                                 if(DebugPartialClose)
                                   {
                                    Print("PC[Trigger:$"+DoubleToString(PartialCloseTrigger,2)
                                          +",Percent:"+DoubleToString(PartialClosePercent,2)
                                          +",Max:"+IntegerToString(MaxNoPartialClose)+"]"
                                          +" p:$"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps,digits)
                                          +" l:"+DoubleToString(lots,lot_digits));
                                   }
                                }
                              else
                                {
                                 Print("Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                 if(UseBot)
                                    message="Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());
                                 smartBot.SendMessage(InpChatID2,message);

                                }
                             }
                          }
                       }
                     break;
                    }
                  case InPips:
                    {
                     double profit_distance = OrderOpenPrice() - SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK);
                     bool is_activated = profit_distance > PartialCloseTrigger*pip;
                     if(is_activated)
                       {
                        double steps = MathFloor(profit_distance / PartialCloseTrigger*pip);
                        if(steps>0)
                          {
                           //--- check current step count is within limit
                           if(steps <= MaxNoPartialClose)
                             {
                              //--- calculate new lot size
                              int lot_digits = (int)(MathLog(SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_STEP))/MathLog(0.1));
                              double lots = NormalizeDouble(OrderLots() * PartialClosePercent,lot_digits);
                              if(lots < SymbolInfoDouble(OrderSymbol(),SYMBOL_VOLUME_MIN))    //--- close all
                                {
                                 lots = OrderLots();
                                }
                              if(OrderClose(OrderTicket(),lots,SymbolInfoDouble(OrderSymbol(),SYMBOL_ASK),MaxSlippage,clrYellow))
                                {
                                 if(DebugPartialClose)
                                   {
                                    Print("PC[Trigger:"+DoubleToString(PartialCloseTrigger,2)
                                          +",Percent:"+DoubleToString(PartialClosePercent,2)
                                          +",Max:"+IntegerToString(MaxNoPartialClose)+"]"
                                          +" p:"+DoubleToString(profit_distance,digits)
                                          +" s:"+DoubleToString(steps,digits)
                                          +" l:"+DoubleToString(lots,lot_digits));
                                   }
                                }
                              else
                                {
                                 Print("Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError()));
                                 messages="Failed to partial close. Order " + IntegerToString(OrderTicket()) + ", error: " + IntegerToString(GetLastError());
                                 if(UseBot)
                                    smartBot.SendMessageToChannel(InpChannel,messages);
                                }
                             }
                          }
                       }
                     break;
                    }
                 }
               break;
              }
           }

        }
      count--;
     }
  }
//+------------------------------------------------------------------+
void CloseAll()
  {
   int totalOP  = OrdersTotal(),tiket=0;
   for(int cnt = totalOP-1 ; cnt >= 0 ; cnt--)
     {
      Os=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()==OP_BUY && OrderMagicNumber() == MagicNumber)
        {
         Oc=OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_BID), MaxSlippage, clrViolet);
         Sleep(300);
         continue;
        }
      if(OrderType()==OP_SELL && OrderMagicNumber() == MagicNumber)
        {
         Oc=OrderClose(OrderTicket(), OrderLots(), MarketInfo(OrderSymbol(), MODE_ASK), MaxSlippage, clrYellow);
         Sleep(300);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double DYp(datetime start_)
  {

   double total = 0;
   for(int i = OrdersHistoryTotal()-1; i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         if(OrderMagicNumber() == MagicNumber  &&OrderCloseTime()>=start_)
           {
            total+=(OrderProfit()+OrderSwap()+OrderCommission());
           }
        }
     }
   return(total);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool IsNewM1Candle()
  {

//If the time of the candle when the function last run
//is the same as the time of the time this candle started
//return false, because it is not a new candle
   if(NewCandleTime==iTime(symbol,PERIOD_CURRENT,0))
      return false;

//otherwise it is a new candle and return true
   else
     {
      //if it is a new candle then we store the new value
      NewCandleTime=iTime(symbol,PERIOD_CURRENT,0);
      return true;
     }
  }

//-------------------------------------------------------------------------------------------]
//FUNCTION TO CHECK FOR NEW BAR
bool NewBar()
  {
   static datetime time=0;
   if(time==0)
     {
      time=Time[0];
      return false;
     }
   if(time!=Time[0])
     {
      time=Time[0];
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void timelockaction(void)
  {
   if(CheckTradingTime()==false)
      return;

   double stoplevel=0,proffit=0,newsl=0;

   string sy=symbol;
   int sy_digits=0;
   double sy_points=0;
   bool ans=false;
   bool next=false;
   int otype=-1;
   int kk=0;

   for(int i=OrdersTotal()-1; i>=0; i--)
     {
      if(!OrderSelect(i,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderMagicNumber()!=MagicNumber)
         continue;
      next=false;
      ans=false;
      sy=OrderSymbol();
      sy_digits=vdigits;
      sy_points=myPoint;
      stoplevel=MarketInfo(sy, MODE_STOPLEVEL)*sy_points;
      otype=OrderType();
      kk=0;
      proffit=OrderProfit()+OrderSwap()+OrderCommission();
      newsl=OrderOpenPrice();

      switch(EA_TIME_LOCK_ACTION)
        {
         case closeall:
            if(otype>1)
              {
               while(kk<5 && !OrderDelete(OrderTicket()))
                 {
                  kk++;
                 }
              }
            else
              {
               double  price=(otype==OP_BUY)?bid:ask;
               while(kk<5 && !OrderClose(OrderTicket(),OrderLots(),price,10))
                 {
                  kk++;
                  price=(otype==OP_BUY)?SymbolInfoDouble(sy,SYMBOL_BID):SymbolInfoDouble(sy,SYMBOL_ASK);
                 }
              }
            break;
         case closeprofit:
            if(proffit<=0)
               break;
            else
              {
               double price=(otype==OP_BUY)?bid:ask;
               while(otype<2 && kk<5 && !OrderClose(OrderTicket(),OrderLots(),price,10))
                 {
                  kk++;
                  price=(otype==OP_BUY)?SymbolInfoDouble(sy,SYMBOL_BID):SymbolInfoDouble(sy,SYMBOL_ASK);
                 }
              }
            break;
         case breakevenprofit:
            if(proffit<=0)
               break;
            else
              {
               double price=(otype==OP_BUY)?bid:ask;
               while(otype<2 && kk<5 && MathAbs(price-newsl)>=stoplevel && !OrderModify(OrderTicket(),newsl,newsl,OrderTakeProfit(),OrderExpiration()))
                 {
                  kk++;
                  price=(otype==OP_BUY)?SymbolInfoDouble(sy,SYMBOL_BID):SymbolInfoDouble(sy,SYMBOL_ASK);
                 }
              }
            break;

        }
      continue;
     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int SymbolNumOfSymbol(string symbols)
  {
   for(int i = 0; i < NumOfSymbols; i++)
     {
      if(symbols==mysymbolList[i]+postfix)
         return(i);
     }
   return(-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClosetradePairs(string Pair)
  {
   if(closetype != opposite)
      return;
   int SymbolNum = SymbolNumOfSymbol(Pair);
   if(SymbolNum < 0)
      return;

   /* if(ExitTrade()=="EXITSELL")
    {//Print("Opposite Close Sell ",Pair);
       closeOP(OP_SELL,Pair);
    }
    else if(ExitTrade()=="EXITBUY")
    {//Print("Opposite Close Buy ",Pair);
       closeOP(OP_BUY,Pair);
    }*/

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int closeOP(int Ordertype,string pair)
  {
   int kode=Ordertype;
//Print( "in closeOP with closeAskedFor" + closeAskedFor);
   int totalOP  = OrdersTotal(),tiket=0;
   for(int cnt = totalOP-1 ; cnt >= 0 ; cnt--)
     {
      if(!OrderSelect(cnt,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderMagicNumber()==MagicNumber)
        {
         if(OrderSymbol()==pair&& OrderType()==OP_BUY && kode==OP_BUY)
           {tiket = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),MaxSlippage,clrNONE);}
         if(OrderSymbol()==pair&& OrderType()==OP_SELL&& kode==OP_SELL)
           {tiket = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),MaxSlippage,clrNONE);}
         if(OrderSymbol()==pair&& OrderType()==OP_BUYSTOP && kode==OP_BUYSTOP)
           {tiket = OrderDelete(OrderTicket()); Print("delete PObuy");}
         if(OrderSymbol()==pair&& OrderType()==OP_SELLSTOP&& kode==OP_SELLSTOP)
           {tiket = OrderDelete(OrderTicket()); Print("delete POsell");}
         if(kode == -1)
           {
            if(OrderSymbol()==pair && OrderType()==OP_SELL)
              {tiket = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_ASK),MaxSlippage,clrNONE);}
            if(OrderSymbol()==pair && OrderType()==OP_BUY)
              {tiket = OrderClose(OrderTicket(),OrderLots(),MarketInfo(OrderSymbol(),MODE_BID),MaxSlippage,clrNONE);}
            if(OrderSymbol()==pair && OrderType()>1)
              {
               tiket = OrderDelete(OrderTicket(),clrNONE);
              }
           }
        }
     }

// RESET LEVEL_SL FLAG FOR OPERAION AND PAIR
   if(kode== OP_BUY && closeAskedFor== "BUY"+pair)
      closeAskedFor ="";
   if(kode== OP_SELL && closeAskedFor== "SELL"+pair)
      closeAskedFor ="";


   return(tiket);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int warna(string Ad_0)
  {
   color Li_ret_8=_Neutral;
   if(Ad_0 =="SELL")
      Li_ret_8 = _SellSignal;
   if(Ad_0 =="BUY")
      Li_ret_8 = _BuySignal;
   return (Li_ret_8);
  }





input string Comment_ea="";


//+------------------------------------------------------------------+
bool RectLabelCreate(const long             chart_ID=0,               // chart's ID
                     const string           name="RectLabel",         // label name
                     const int              sub_window=0,             // subwindow index
                     const int              x=0,                      // X coordinate
                     const int              y=0,                      // Y coordinate
                     const int              width=50,                 // width
                     const int              height=18,                // height
                     const color            back_clr=C'236,233,216',  // background color
                     const ENUM_BORDER_TYPE border=BORDER_SUNKEN,     // border type
                     const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                     const color            clr=clrRed,               // flat border color (Flat)
                     const ENUM_LINE_STYLE  style=STYLE_SOLID,        // flat border style
                     const int              line_width=1,             // flat border width
                     const bool             back=false,               // in the background
                     const bool             selection=false,          // highlight to move
                     const bool             hidden=true,              // hidden in the object list
                     const long             z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ObjectDelete(chart_ID,name);
   ResetLastError();
//--- create a rectangle label
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set label size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border type
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_TYPE,border);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set flat border color (in Flat mode)
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set flat border line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set flat border width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,line_width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move rectangle label                                             |
//+------------------------------------------------------------------+
bool RectLabelMove(const long   chart_ID=0,       // chart's ID
                   const string name="RectLabel", // label name
                   const int    x=5,              // X coordinate
                   const int    y=7)              // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the rectangle label
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
bool LabelCreate(const long              chart_ID=0,               // chart's ID
                 const string            name="Label",             // label name
                 const int               sub_window=0,             // subwindow index
                 const int               x=0,                      // X coordinate
                 const int               y=0,                      // Y coordinate
                 const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                 const string            text="Label",             // text
                 const string            font="Arial",             // font
                 const int               font_size=10,             // font size
                 const color             clr=C'183,28,28',// color
                 const double            angle=0.0,                // text slope
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                 const bool              back=false,               // in the background
                 const bool              selection=false,          // highlight to move
                 const bool              hidden=true,              // hidden in the object list
                 const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ObjectDelete(chart_ID,name);

   ResetLastError();
//--- create a text label
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create text label! Error code = ",GetLastError());
      return(false);
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the slope angle of the text
   ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the text label                                              |
//+------------------------------------------------------------------+
bool LabelMove(const long   chart_ID=0,   // chart's ID
               const string name="Label", // label name
               const int    x=0,          // X coordinate
               const int    y=0)          // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the text label
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the label! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
bool ButtonCreate(const long              chart_ID=0,               // chart's ID
                  const string            name="Button",            // button name
                  const int               sub_window=0,             // subwindow index
                  const int               x=0,                      // X coordinate
                  const int               y=0,                      // Y coordinate
                  const int               width=50,                 // button width
                  const int               height=18,                // button height
                  const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                  const string            text="Button",            // text
                  const string            font="Arial",             // font
                  const int               font_size=10,             // font size
                  const color             clr=clrBlack,             // text color
                  const color             back_clr=C'236,233,216',  // background color
                  const color             border_clr=clrNONE,       // border color
                  const bool              state=false,              // pressed/released
                  const bool              back=false,               // in the background
                  const bool              selection=false,          // highlight to move
                  const bool              hidden=true,              // hidden in the object list
                  const long              z_order=0)                // priority for mouse click
  {
   ObjectDelete(chart_ID,name);
//--- reset the error value
   ResetLastError();
//--- create the button
   if(!ObjectCreate(chart_ID,name,OBJ_BUTTON,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create the button! Error code = ",GetLastError());
      return(false);
     }
//--- set button coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set button size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- set button state
   ObjectSetInteger(chart_ID,name,OBJPROP_STATE,state);
//--- enable (true) or disable (false) the mode of moving the button by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the button                                                  |
//+------------------------------------------------------------------+
bool ButtonMove(const long   chart_ID=0,    // chart's ID
                const string name="Button", // button name
                const int    x=0,           // X coordinate
                const int    y=0)           // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the button
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the button! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
bool EditCreate(const long             chart_ID=0,               // chart's ID
                const string           name="Edit",              // object name
                const int              sub_window=0,             // subwindow index
                const int              x=0,                      // X coordinate
                const int              y=0,                      // Y coordinate
                const int              width=50,                 // width
                const int              height=18,                // height
                const string           text="Text",              // text
                const string           font="Arial",             // font
                const int              font_size=10,             // font size
                const ENUM_ALIGN_MODE  align=ALIGN_CENTER,       // alignment type
                const bool             read_only=false,          // ability to edit
                const ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                const color            clr=clrBlack,             // text color
                const color            back_clr=clrWhite,        // background color
                const color            border_clr=clrNONE,       // border color
                const bool             back=false,               // in the background
                const bool             selection=false,          // highlight to move
                const bool             hidden=true,              // hidden in the object list
                const long             z_order=0)                // priority for mouse click
  {
   ObjectDelete(chart_ID,name);
//--- reset the error value
   ResetLastError();
//--- create edit field
   if(!ObjectCreate(chart_ID,name,OBJ_EDIT,sub_window,0,0))
     {
      Print(__FUNCTION__,
            ": failed to create \"Edit\" object! Error code = ",GetLastError());
      return(false);
     }
//--- set object coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set object size
   ObjectSetInteger(chart_ID,name,OBJPROP_XSIZE,width);
   ObjectSetInteger(chart_ID,name,OBJPROP_YSIZE,height);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
//--- set font size
   ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
//--- set the type of text alignment in the object
   ObjectSetInteger(chart_ID,name,OBJPROP_ALIGN,align);
//--- enable (true) or cancel (false) read-only mode
   ObjectSetInteger(chart_ID,name,OBJPROP_READONLY,read_only);
//--- set the chart's corner, relative to which object coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set text color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set background color
   ObjectSetInteger(chart_ID,name,OBJPROP_BGCOLOR,back_clr);
//--- set border color
   ObjectSetInteger(chart_ID,name,OBJPROP_BORDER_COLOR,border_clr);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move Edit object                                                 |
//+------------------------------------------------------------------+
bool EditMove(const long   chart_ID=0,  // chart's ID
              const string name="Edit", // object name
              const int    x=0,         // X coordinate
              const int    y=0)         // Y coordinate
  {
//--- reset the error value
   ResetLastError();
//--- move the object
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x))
     {
      Print(__FUNCTION__,
            ": failed to move X coordinate of the object! Error code = ",GetLastError());
      return(false);
     }
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y))
     {
      Print(__FUNCTION__,
            ": failed to move Y coordinate of the object! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
double LotsOptimized(const string symbols)
  {


   double lot=InpLot;
   int    orders=HistoryTotal();     // history orders total
   int    losses=0;                  // number of losses orders without a break
//--- select lot size
   lot=NormalizeDouble(AccountFreeMargin()*MaximumRisk/1000.0,1);
//--- calcuulate number of losses orders without a break
   if(DecreaseFactor>0)
     {
      for(int i=orders-1; i>=0; i--)
        {
         if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY)==false)
           {
            Print("Error in history!");
            break;
           }
         if(OrderSymbol()!=symbols || OrderType()>OP_SELL)
            continue;
         //---
         if(OrderProfit()>0)
            break;
         if(OrderProfit()<0)
            losses++;
        }
      if(losses>1)
         lot=NormalizeDouble(lot-lot*losses/DecreaseFactor,1);
     }
//--- return lot size
   if(lot<0.01)
      lot=0.01;
   return(lot);
  }
//+------------------------------------------------------------------+
int _funcOC(ENUM_ORDER_TYPE postypes, string sName)
  {
   int count=OrdersTotal();
   double ts=0;
   int res = 0;
   while(count>0)
     {
      int os=OrderSelect(count-1,MODE_TRADES);
      if(OrderType()==postypes
         && OrderSymbol()==sName
         && OrderMagicNumber()==MagicNumber && OrderOpenPrice()!=OrderStopLoss())
        {
         res++;
        }

      count--;
     }
   return res;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInitIndicators()
  {
   indicators open_indicators[MAX_OPENING_INDICATORS];
   open_indicators[0] = inpInd0;
   open_indicators[1] = inpInd1;
   open_indicators[2] = inpInd2;
   open_indicators[3] = inpInd3;


   ENUM_TIMEFRAMES open_timeframes[MAX_OPENING_INDICATORS];
   open_timeframes[0] = inpTF0;
   open_timeframes[1] = inpTF1;
   open_timeframes[3] = inpTF2;
   open_timeframes[3] = inpTF3;


   ENUM_TYPE_OF_ENTRY open_types[MAX_OPENING_INDICATORS];
   open_types[0] = inpType0;
   open_types[1] = inpType1;
   open_types[2] = inpType2;
   open_types[3] = inpType3;

   int open_shifts[MAX_OPENING_INDICATORS];
   open_shifts[0] = inpShift0;
   open_shifts[1] = inpShift1;
   open_shifts[2] = inpShift2;
   open_shifts[3] = inpShift3;


   indicators close_indicators[MAX_CLOSING_INDICATORS];
   close_indicators[0] = inpInd0Ex;
   close_indicators[1] = inpInd1Ex;
   close_indicators[2] = inpInd2Ex;
   close_indicators[3] = inpInd3Ex;

   ENUM_TIMEFRAMES close_timeframes[MAX_CLOSING_INDICATORS];
   close_timeframes[0] = inpTF0Ex;
   close_timeframes[1] = inpTF1Ex;
   close_timeframes[2] = inpTF2Ex;
   close_timeframes[3] = inpTF3Ex;
   ENUM_TYPE_OF_ENTRY close_types[MAX_CLOSING_INDICATORS];
   close_types[0] = inpType0Ex;
   close_types[1] = inpType1Ex;
   close_types[2] = inpType2Ex;
   close_types[3] = inpType3Ex;

   int close_shifts[MAX_CLOSING_INDICATORS];
   close_shifts[0] = inpShift0Ex;
   close_shifts[1] = inpShift1Ex;
   close_shifts[2] = inpShift2Ex;
   close_shifts[3] = inpShift3Ex;

   ArrayResize(OpeningIndicators,0);
   ArrayResize(ClosingIndicators,0);
   for(int i=0; i<MAX_OPENING_INDICATORS; i++)
     {
      if(open_indicators[i] != ind0)
        {
         if(isNotDuplicate(OpeningIndicators,open_indicators[i],open_timeframes[i],open_types[i],open_shifts[i]))
           {
            int size = ArraySize(OpeningIndicators);
            ArrayResize(OpeningIndicators,size+1);
            OpeningIndicators[size].Name        = indicator_names[open_indicators[i]];
            OpeningIndicators[size].Indicator   = open_indicators[i];
            OpeningIndicators[size].TimeFrame   = open_timeframes[i];
            OpeningIndicators[size].TypeOfEntry = open_types[i];
            OpeningIndicators[size].Shift       = open_shifts[i];
            ArrayResize(OpeningIndicators[size].LastSignal,NumOfSymbols);

            for(int s=0; s<NumOfSymbols; s++)
              {
               OpeningIndicators[size].LastSignal[s].active = false;
               OpeningIndicators[size].LastSignal[s].type = -1;
               OpeningIndicators[size].LastSignal[s].date = EPOCH;
               OpeningIndicators[size].LastSignal[s].count = 0;
               OpeningIndicators[size].LastSignal[s].current_type = -1;
               OpeningIndicators[size].LastSignal[s].previous_type = -1;
              }
           }
        }
     }
   for(int i=0; i<MAX_CLOSING_INDICATORS; i++)
     {
      if(close_indicators[i] != ind0)
        {
         if(isNotDuplicate(ClosingIndicators,close_indicators[i],close_timeframes[i],close_types[i],close_shifts[i]))
           {
            int size = ArraySize(ClosingIndicators);
            ArrayResize(ClosingIndicators,size+1);
            ClosingIndicators[size].Name        = indicator_names[close_indicators[i]];
            ClosingIndicators[size].Indicator   = close_indicators[i];
            ClosingIndicators[size].TimeFrame   = close_timeframes[i];
            ClosingIndicators[size].TypeOfEntry = close_types[i];
            ClosingIndicators[size].Shift       = close_shifts[i];
            ArrayResize(ClosingIndicators[size].LastSignal,NumOfSymbols);

            for(int s=0; s<NumOfSymbols; s++)
              {
               ClosingIndicators[size].LastSignal[s].active = false;
               ClosingIndicators[size].LastSignal[s].type = -1;
               ClosingIndicators[size].LastSignal[s].date = start1;
               ClosingIndicators[size].LastSignal[s].count = 0;
               ClosingIndicators[size].LastSignal[s].current_type = -1;
               ClosingIndicators[size].LastSignal[s].previous_type = -1;
              }
           }
        }
     }
//--- validate trade mode against active indicators
   if(inpTradeMode == Automatic)    //--- at least, one opening indicator is needed
     {
      if(ArraySize(OpeningIndicators)<1)
        {
         Print("In Trade Mode 'Auto', at least one entry indicator is required.");

         message="In Trade Mode 'Auto', at least one entry indicator is required.";
         smartBot.SendMessageToChannel(InpChannel,message);
         return INIT_PARAMETERS_INCORRECT;
        }
     }
   if(inpTradeCloseMode == CloseOnReversedSignal)    //--- at least, one closing indicator is needed
     {
      if(ArraySize(ClosingIndicators)<1)
        {
         Print("In Trade Close Mode 'CloseOnReverseSignal', at least one exit indicator is required.");
         message="In Trade Close Mode 'CloseOnReverseSignal', at least one exit indicator is required.";
         smartBot.SendMessageToChannel(InpChannel,message);

         return INIT_PARAMETERS_INCORRECT;
        }
     }
   return INIT_SUCCEEDED;
  }

//--- ensure the passed indicator parameters are not already in array
bool isNotDuplicate(STRUCT_INDICATOR &array[], indicators ind, ENUM_TIMEFRAMES tf, ENUM_TYPE_OF_ENTRY type, int shift)
  {
   bool results = true; //--- by default assume not duplicate
   for(int i=0; i<ArraySize(array); i++)
     {
      if(ind == array[i].Indicator)
        {
         if(tf == array[i].TimeFrame)
           {
            if(type == array[i].TypeOfEntry)
              {
               if(shift == array[i].Shift)    //--- indicator is already in array
                 {
                  results = false;
                  break;
                 }
              }
           }
        }
     }
   return results;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetValidSignalIfPossible(STRUCT_SIGNAL &signals)
  {
//--- NOTE: If indicators are not aligned they can return no signal
//--- the following code will ensure that type is as much as possible valid
   if(signals.current_type != -1)
     {
      signals.type = signals.current_type;
      signals.active = true;
     }
   else
      if(signals.previous_type != -1)
        {
         signals.type = signals.previous_type;
         signals.active = true;
        }
   mysignal=signals.type;
   return signals.type;
  }










//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetOpeningSignals(STRUCT_SYMBOL_SIGNAL &opened_signal[])
  {














   ArrayResize(opened_signal,0);
   switch(inpTradeMode)
     {
      default:
         break;
      case Manual:   //--- Signals are generated by selection of buy/sell buttons of the trading panel
        {
         for(int i=0; i<ArraySize(ManualSignals); i++)
           {
            if(ManualSignals[i].done)
              {
               continue;
              }
            int size = ArraySize(opened_signal);
            ArrayResize(opened_signal,size+1);
            opened_signal[size].symbol = ManualSignals[i].symbol;
            opened_signal[size].type   = ManualSignals[i].type;
            opened_signal[size].stop   = ManualSignals[i].stop;
            opened_signal[size].tp     = ManualSignals[i].tp;
            opened_signal[size].volume = ManualSignals[i].volume;
            opened_signal[size].not    = ManualSignals[i].not;
            ManualSignals[i].done = true;
           }
         break;
        }
      case Automatic:   //--- Signals are generated by indicators
        {
         for(int s=0; s<NumOfSymbols; s++) //--- for each symbol
           {
            //--- Get signals
            for(int i=0; i<ArraySize(OpeningIndicators); i++)
              {
               if(UseAllsymbol==Yes)
                 {
                  if(InpSelectPairs_By_Basket_Schedule==Yes)
                    {

                     // scheduled pairs and time

                     symbol=TradeScheduleSymbol(s,InpSelectPairs_By_Basket_Schedule);

                    }
                  else
                    {
                     symbol=mysymbolList[s]  ; //normal opening time


                    }
                 }
               else
                 {

                  symbol=Symbol();

                 }

               //select trading pairs
               ENUM_INDICATOR_SIGNAL ind_signal = (ENUM_INDICATOR_SIGNAL)getIndiValues(OpeningIndicators[i].Indicator,OpeningIndicators[i].TimeFrame,symbol);
               if(ShowIndicator1Panel)
                 {
                  y_offset+=15;
                  string name = OBJPFX"_IOpening";
                  if(ObjectFind(name)<0)
                    {
                     LabelCreate(ChartID(),name,0,10,y_offset,CORNER_LEFT_UPPER,"Opening Indicators Status","Arial",10,clrBlack);
                     y_offset+=15;
                    }
                  name = OBJPFX"_IO"+IntegerToString(i)+"_"+symbol+"_"+EnumToString(OpeningIndicators[i].TimeFrame);
                  if(ObjectFind(name)<0)
                    {
                     LabelCreate(ChartID(),name,0,10,y_offset,CORNER_LEFT_UPPER,OpeningIndicators[i].Name,"Arial",10,clrBlack);
                    }

                  string ls = "";
                  ObjectSetString(ChartID(),name,OBJPROP_TEXT,OpeningIndicators[i].Name+":"+mysymbolList[s]+","+EnumToString(OpeningIndicators[i].TimeFrame)+", Signal:"+(ind_signal<0?"SELL":(ind_signal>0?"BUY ":"----"))+ls);
                  color c = (ind_signal<0?clrRed:(ind_signal>0?clrGreen:clrGray));
                  ObjectSet(name,OBJPROP_COLOR,c);


                 }

               switch(ind_signal)
                 {
                  case NoSignal:
                  default:
                    {

                     //--- update previous signal if LastSignal was not NEUTRAL
                     UpdateSignal(OpeningIndicators,s,i);
                     //--- reset signal
                     OpeningIndicators[i].LastSignal[s].active = false;
                     OpeningIndicators[i].LastSignal[s].current_type = -1;
                     break;
                    }
                  case SellSignal:
                    {
                     //--- update previous signal if LastSignal was not NEUTRAL
                     UpdateSignal(OpeningIndicators,s,i);
                     //--- set new signal
                     OpeningIndicators[i].LastSignal[s].active = true;
                     OpeningIndicators[i].LastSignal[s].date = iTime(symbol,OpeningIndicators[i].TimeFrame,OpeningIndicators[i].Shift);
                     OpeningIndicators[i].LastSignal[s].current_type = OP_SELL;
                     OpeningIndicators[i].LastSignal[s].count++;
                     break;
                    }
                  case BuySignal:
                    {
                     //--- update previous signal if LastSignal was not NEUTRAL
                     UpdateSignal(OpeningIndicators,s,i);
                     //--- set new signal
                     OpeningIndicators[i].LastSignal[s].active = true;
                     OpeningIndicators[i].LastSignal[s].date = iTime(symbol,OpeningIndicators[i].TimeFrame,OpeningIndicators[i].Shift);
                     OpeningIndicators[i].LastSignal[s].current_type = OP_BUY;
                     OpeningIndicators[i].LastSignal[s].count++;
                     break;
                    }
                 }
              }
            //--- Filter signals according to their type of entry
            for(int i=0; i<ArraySize(OpeningIndicators); i++)
              {
               switch(OpeningIndicators[i].TypeOfEntry)
                 {
                  default:
                     break;
                  case With_Trend:
                    {
                     mysignal= GetValidSignalIfPossible(OpeningIndicators[i].LastSignal[s]);
                     break;
                    }
                  case When_Trend_Change:
                    {
                     if(OpeningIndicators[i].LastSignal[s].count>=2)
                       {
                        if(OpeningIndicators[i].LastSignal[s].current_type != OpeningIndicators[i].LastSignal[s].previous_type)
                          {
                           mysignal= OpeningIndicators[i].LastSignal[s].type = OpeningIndicators[i].LastSignal[s].current_type;
                          }
                       }
                     else     //--- the first signal is ignored but previous_type will be updated with it when a new signal
                       {
                        // will be generated
                        mysignal=  OpeningIndicators[i].LastSignal[s].type = -1;
                       }
                     break;
                    }
                 }
              }
            //--- Filter signals according to open trade strategy
            switch(inpOpenTradeStrategy)
              {
               default:
                  break;
               case JOINT:   //--- all indicator signals aligned to generate one signal
                 {
                  bool aligned = true;
                  bool first = true;
                  int expected_signal = -1;
                  for(int i=0; i<ArraySize(OpeningIndicators); i++)
                    {
                     if(!OpeningIndicators[i].LastSignal[s].active)   //--- signal not active (either not triggered or already used)
                       {
                        aligned = false;
                        break;
                       }
                     if(OpeningIndicators[i].LastSignal[s].type == -1)   //--- invalid signal (either no signal or error from indicator)
                       {

                        aligned = false;
                        break;
                       }
                     //--- here opening indicator i for symbol s has a valid signal
                     if(first)    //--- set the expected aligned signal


                       {
                        first = false;
                        expected_signal =OpeningIndicators[i].LastSignal[s].type;
                        aligned=true;
                       }
                     else
                       {
                        if(OpeningIndicators[i].LastSignal[s].type != expected_signal)    //--- at least one indicator not aligned
                          {
                           aligned = false;
                           break;
                          }
                       }
                    }
                  if(aligned&&(expected_signal!=-1))    //--- generate one signal
                    {
                     int size = ArraySize(opened_signal);
                     ArrayResize(opened_signal,size+1);
                     opened_signal[size].symbol = symbol;
                     signal.type= opened_signal[size].type = expected_signal;


                     //--- deactivate signals
                     DeactivateSignals(OpeningIndicators,s);
                    }

                  else
                     if(aligned&&(expected_signal!=1))    //--- generate one signal
                       {
                        int size = ArraySize(opened_signal);
                        ArrayResize(opened_signal,size+1);
                        opened_signal[size].symbol = symbol;
                        opened_signal[size].type = expected_signal;
                        message="Current aligned signal:symbol:"+TradeScheduleSymbol(s,InpSelectPairs_By_Basket_Schedule)+" expected:"+(string)opened_signal[size].type ;
                        smartBot.SendMessage(InpChatID,message);

                        //--- deactivate signals
                        DeactivateSignals(OpeningIndicators,s);
                       }
                  break;
                 }
               case SEPARATE:   //--- all indicator signals generate one signal
                 {
                  for(int i=0; i<ArraySize(OpeningIndicators); i++)
                    {
                     if(!OpeningIndicators[i].LastSignal[s].active)   //--- signal not active (either not triggered or already used)
                       {
                        continue;
                       }
                     if(OpeningIndicators[i].LastSignal[s].type == -1)   //--- invalid signal (either no signal or error from indicator)
                       {

                        continue;
                       }
                     //--- here opening indicator i for symbol s has a valid signal
                     int size = ArraySize(opened_signal);
                     ArrayResize(opened_signal,size+1);
                     opened_signal[size].symbol =symbol;

                     opened_signal[size].type= OpeningIndicators[i].LastSignal[i].type;

                     //--- deactivate signal
                     DeactivateSignals(OpeningIndicators,s,i);
                    }
                  break;
                 }
              }
           }
        }
     }
  }

string tradesignal="";
int mysignal;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetClosingSignals(STRUCT_SYMBOL_SIGNAL &closed_signal[])
  {
   ArrayResize(closed_signal,0);
   switch(inpTradeCloseMode)
     {
      default:
         break;
      case CloseUsingTP_SL:   //--- No signal generation from indicator, TP and SL value are used
        {
         break;
        }
      case CloseOnReversedSignal:   //--- Signals are generated by indicators
        {
         for(int s=0; s<NumOfSymbols; s++) //--- for each symbol
           {
            //--- Get signals
            for(int i=0; i<ArraySize(ClosingIndicators); i++)
              {
               ENUM_INDICATOR_SIGNAL ind_signal = (ENUM_INDICATOR_SIGNAL)getIndiValues(ClosingIndicators[i].Indicator,ClosingIndicators[i].TimeFrame,TradeScheduleSymbol(s,InpSelectPairs_By_Basket_Schedule));
               if(ShowIndicator1Panel)
                 {
                  y_offset+=15;
                  string name = OBJPFX"_IClosing";
                  if(ObjectFind(name)<0)
                    {
                     LabelCreate(ChartID(),name,0,10,y_offset,CORNER_LEFT_UPPER,"Closing Indicators Status","Arial",10,clrBlack);
                     y_offset+=15;
                    }
                  name = OBJPFX"_IC"+IntegerToString(i)+"_"+TradeScheduleSymbol(s,InpSelectPairs_By_Basket_Schedule)+"_"+EnumToString(ClosingIndicators[i].TimeFrame);
                  if(ObjectFind(name)<0)
                    {
                     LabelCreate(ChartID(),name,0,10,y_offset,CORNER_LEFT_UPPER,ClosingIndicators[i].Name,"Arial",10,clrBlack);
                    }
                  string ls = "";
                  ObjectSetString(ChartID(),name,OBJPROP_TEXT,ClosingIndicators[i].Name+":"+TradeScheduleSymbol(s,InpSelectPairs_By_Basket_Schedule)+","+EnumToString(ClosingIndicators[i].TimeFrame)+", Signal:"+(ind_signal<0?"SELL":(ind_signal>0?"BUY ":"----"))+ls);
                  color c = (ind_signal<0?clrRed:(ind_signal>0?clrGreen:clrGray));
                  ObjectSet(name,OBJPROP_COLOR,c);
                 }
               switch(ind_signal)
                 {
                  case NoSignal:
                  default:
                    {
                     tradesignal="NO TRADE SIGNAL";
                     //--- update previous signal if LastSignal was not NEUTRAL
                     UpdateSignal(ClosingIndicators,s,i);
                     //--- set reset signal
                     ClosingIndicators[i].LastSignal[s].active = false;
                     ClosingIndicators[i].LastSignal[s].current_type = -1;
                     break;
                    }
                  case SellSignal:
                    {

                     tradesignal="SELL";
                     //--- update previous signal if LastSignal was not NEUTRAL
                     UpdateSignal(ClosingIndicators,s,i);
                     //--- set new signal
                     ClosingIndicators[i].LastSignal[s].active = true;
                     ClosingIndicators[i].LastSignal[s].date = iTime(TradeScheduleSymbol(s,InpSelectPairs_By_Basket_Schedule),ClosingIndicators[i].TimeFrame,ClosingIndicators[i].Shift);
                     ClosingIndicators[i].LastSignal[s].current_type = OP_SELL;
                     ClosingIndicators[i].LastSignal[s].count++;
                     break;
                    }
                  case BuySignal:
                    {
                     tradesignal="BUY";
                     //--- update previous signal if LastSignal was not NEUTRAL
                     UpdateSignal(ClosingIndicators,s,i);
                     //--- set new signal
                     ClosingIndicators[i].LastSignal[s].active = true;
                     ClosingIndicators[i].LastSignal[s].date = iTime(TradeScheduleSymbol(s,InpSelectPairs_By_Basket_Schedule),ClosingIndicators[i].TimeFrame,ClosingIndicators[i].Shift);
                     ClosingIndicators[i].LastSignal[s].current_type = OP_BUY;
                     ClosingIndicators[i].LastSignal[s].count++;
                     break;
                    }
                 }
              }
            //--- Filter signals according to their type of entry
            for(int i=0; i<ArraySize(ClosingIndicators); i++)
              {
               switch(ClosingIndicators[i].TypeOfEntry)
                 {
                  default:
                     break;
                  case With_Trend:
                    {
                     GetValidSignalIfPossible(ClosingIndicators[i].LastSignal[s]);
                     break;
                    }
                  case When_Trend_Change:
                    {
                     if(ClosingIndicators[i].LastSignal[s].count>=2)
                       {
                        if(ClosingIndicators[i].LastSignal[s].current_type != ClosingIndicators[i].LastSignal[s].previous_type)
                          {
                           ClosingIndicators[i].LastSignal[s].type = ClosingIndicators[i].LastSignal[s].current_type;
                          }
                       }
                     else     //--- the first signal is ignored but previous_type will be updated with it when a new signal
                       {
                        // will be generated
                        ClosingIndicators[i].LastSignal[s].type = -1;
                       }
                     break;
                    }
                 }
              }
            //--- Filter signals according to close trade strategy
            switch(inpCloseTradeStrategy)
              {
               default:
                  break;
               case JOINT:   //--- all indicator signals aligned to generate one signal
                 {
                  bool aligned = true;
                  bool first = true;
                  int expected_signal = -1;
                  for(int i=0; i<ArraySize(ClosingIndicators); i++)
                    {
                     if(!ClosingIndicators[i].LastSignal[s].active)   //--- signal not active (either not triggered or already used)
                       {
                        aligned = false;
                        break;
                       }
                     if(ClosingIndicators[i].LastSignal[s].type == -1)   //--- invalid signal (either no signal or error from indicator)
                       {
                        aligned = false;
                        break;
                       }
                     //--- here closing indicator i for symbol s has a valid signal
                     if(first)    //--- set the expected aligned signal
                       {
                        first = false;
                        expected_signal = ClosingIndicators[i].LastSignal[s].type;
                       }
                     else
                       {
                        if(ClosingIndicators[i].LastSignal[s].type != expected_signal)    //--- at least one indicator not aligned
                          {
                           aligned = false;
                           break;
                          }
                       }
                    }
                  if(aligned && (expected_signal!=-1))    //--- generate one signal
                    {
                     int size = ArraySize(closed_signal);
                     ArrayResize(closed_signal,size+1);
                     closed_signal[size].symbol = TradeScheduleSymbol(s,InpSelectPairs_By_Basket_Schedule);
                     closed_signal[size].type = expected_signal;
                     //--- deactivate signals
                     DeactivateSignals(ClosingIndicators,s);
                    }
                  break;
                 }
               case SEPARATE:   //--- all indicator signals generate one signal
                 {
                  for(int i=0; i<ArraySize(ClosingIndicators); i++)
                    {
                     if(!ClosingIndicators[i].LastSignal[s].active)   //--- signal not active (either not triggered or already used)
                       {
                        continue;
                       }
                     if(ClosingIndicators[i].LastSignal[s].type == -1)   //--- invalid signal (either no signal or error from indicator)
                       {
                        continue;
                       }
                     //--- here closing indicator i for symbol s has a valid signal
                     int size = ArraySize(closed_signal);
                     ArrayResize(closed_signal,size+1);
                     closed_signal[size].symbol = TradeScheduleSymbol(s,InpSelectPairs_By_Basket_Schedule);
                     closed_signal[size].type = ClosingIndicators[i].LastSignal[s].type;
                     //--- deactivate signal
                     DeactivateSignals(ClosingIndicators,s,i);
                    }
                  break;
                 }
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ValidateSignals(STRUCT_SYMBOL_SIGNAL &opened_signal[], STRUCT_SYMBOL_SIGNAL &closed_signal[])
  {
   STRUCT_SYMBOL_SIGNAL validated_open[];
   ArrayResize(validated_open,0);
//--- validation depends on closing strategy
   switch(inpTradeCloseMode)
     {
      default:
         break;
      case CloseUsingTP_SL:   //--- No validation needed : TP and SL value are used for close
        {



         break;
        }
      case CloseOnReversedSignal:   //--- validation is needed
        {
         for(int i=0; i<ArraySize(opened_signal); i++)
           {
            //--- assume signal is valid
            bool is_open_valid = true;
            //--- check against close signals
            for(int j=0; j<ArraySize(closed_signal); j++)
              {
               if(closed_signal[j].symbol == opened_signal[i].symbol)    //--- close signal on same symbol
                 {
                  if((closed_signal[j].type == OP_SELL) && (opened_signal[i].type == OP_BUY))    //--- reversal condition on close signal
                    {
                     exitBuy=true;
                     is_open_valid = false;
                     break;
                    }
                  else
                     if((closed_signal[j].type == OP_BUY) && (opened_signal[i].type == OP_SELL))    //--- reversal condition on close signal
                       {
                        exitSell=true;
                        is_open_valid = false;
                        break;
                       }
                 }
              }
            //--- keep signal if still valid
            if(is_open_valid)
              {
               int size = ArraySize(validated_open);
               ArrayResize(validated_open,size+1);
               validated_open[size] = opened_signal[i];
              }
           }
         //--- update opened signals
         int size = ArraySize(validated_open);
         ArrayResize(opened_signal,size);
         for(int i=0; i<size; i++)
           {
            opened_signal[i]=validated_open[i];
            Sleep(100);
           }
         break;
        }

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeactivateSignals(STRUCT_INDICATOR &array[],const int symbol_index, int indicator_index=-1)
  {
//--- indicator_index == -1 means deactivate all indicators
   int start_index = (indicator_index == -1) ? 0                : indicator_index;
   int stop_index = (indicator_index == -1) ?  ArraySize(array) : indicator_index + 1;
   for(int i=start_index; i<stop_index; i++)
     {
      array[i].LastSignal[symbol_index].active = false;
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void UpdateSignal(STRUCT_INDICATOR &array[], const int symbol_index, int indicator_index)
  {
   if(array[indicator_index].LastSignal[symbol_index].current_type == -1)     //--- don't update if no signal
     {

      return;
     }
   array[indicator_index].LastSignal[symbol_index].previous_type = array[indicator_index].LastSignal[symbol_index].current_type;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseBuyOrders(const string symbols)
  {
   symbol=symbols;

   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderType() == ORDER_TYPE_BUY)
           {
            if(OrderSymbol() == symbol)
              {
               if(OrderMagicNumber() == MagicNumber)
                 {
                  if(OrderCloseTime() == 0)
                    {
                     if(!OrderClose(OrderTicket(),OrderLots(),SymbolInfoDouble(symbol,SYMBOL_BID),5,clrYellow))
                       {
                        PrintFormat("Failed to close order %d, error:%d",OrderTicket(),GetLastError());
                       }
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseSellOrders(const string symbols)
  {
   symbol=symbols;

   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderType() == ORDER_TYPE_SELL)
           {
            if(OrderSymbol() == symbol)
              {
               if(OrderMagicNumber() == MagicNumber)
                 {
                  if(OrderCloseTime() == 0)
                    {
                     if(!OrderClose(OrderTicket(),OrderLots(),SymbolInfoDouble(symbol,SYMBOL_ASK),5,clrYellow))
                       {
                        PrintFormat("Failed to close order %d, error:%d",OrderTicket(),GetLastError());
                       }
                    }
                 }
              }
           }
        }
     }

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseProfitOrders(const string symbols)
  {
   symbol=symbols;
   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if((OrderType() == ORDER_TYPE_BUY)||(OrderType()==ORDER_TYPE_SELL))
           {
            if(OrderSymbol() == symbol)
              {
               if(OrderMagicNumber() == MagicNumber)
                 {
                  if(OrderCloseTime() == 0)
                    {
                     if(OrderProfit()>0)
                       {
                        double price = (OrderType() == ORDER_TYPE_BUY ? SymbolInfoDouble(symbol,SYMBOL_BID) : SymbolInfoDouble(symbol,SYMBOL_ASK));
                        if(!OrderClose(OrderTicket(),OrderLots(),price,5,clrYellow))
                          {
                           PrintFormat("Failed to close order %d, error:%d",OrderTicket(),GetLastError());
                          }
                       }
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseLossOrders(const string symbols)
  {
   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if((OrderType() == ORDER_TYPE_BUY)||(OrderType()==ORDER_TYPE_SELL))
           {
            if(OrderSymbol() == symbols)
              {
               if(OrderMagicNumber() == MagicNumber)
                 {
                  if(OrderCloseTime() == 0)
                    {
                     if(OrderProfit()<0)
                       {
                        double price = (OrderType() == ORDER_TYPE_BUY ? SymbolInfoDouble(symbols,SYMBOL_BID) : SymbolInfoDouble(symbols,SYMBOL_ASK));
                        if(!OrderClose(OrderTicket(),OrderLots(),price,5,clrYellow))
                          {
                           PrintFormat("Failed to close order %d, error:%d",OrderTicket(),GetLastError());
                          }
                       }
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClosePendingLimitOrders(const string symbols)
  {
   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if((OrderType() == ORDER_TYPE_BUY_LIMIT)||(OrderType()==ORDER_TYPE_SELL_LIMIT))
           {
            if(OrderSymbol() == symbols)
              {
               if(OrderMagicNumber() == MagicNumber)
                 {
                  if(OrderCloseTime() == 0)
                    {
                     if(!OrderDelete(OrderTicket(),clrYellow))
                       {
                        PrintFormat("Failed to delete order %d, error:%d",OrderTicket(),GetLastError());
                       }
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ClosePendingStopOrders(const string symbols)
  {
   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if((OrderType() == ORDER_TYPE_BUY_STOP)||(OrderType()==ORDER_TYPE_SELL_STOP))
           {
            if(OrderSymbol() == symbols)
              {
               if(OrderMagicNumber() == MagicNumber)
                 {
                  if(OrderCloseTime() == 0)
                    {
                     if(!OrderDelete(OrderTicket(),clrYellow))
                       {
                        PrintFormat("Failed to delete order %d, error:%d",OrderTicket(),GetLastError());
                       }
                    }
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseAllOrders(const string symbols)
  {
   symbol=symbols;
   for(int i=OrdersTotal(); i>=0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS))
        {
         if(OrderSymbol() == symbols)
           {
            if(OrderMagicNumber() == MagicNumber)
              {
               if(OrderCloseTime() == 0)
                 {
                  switch(OrderType())
                    {
                     default:
                        break;
                     case ORDER_TYPE_BUY:
                     case ORDER_TYPE_SELL:
                       {
                        double price = (OrderType() == ORDER_TYPE_BUY ? SymbolInfoDouble(symbols,SYMBOL_BID) : SymbolInfoDouble(symbols,SYMBOL_ASK));
                        if(!OrderClose(OrderTicket(),OrderLots(),price,5,clrYellow))
                          {
                           PrintFormat("Failed to close order %d, error:%d",OrderTicket(),GetLastError());
                          }
                        break;

                       }
                     case ORDER_TYPE_BUY_LIMIT:
                     case ORDER_TYPE_BUY_STOP:
                     case ORDER_TYPE_SELL_LIMIT:
                     case ORDER_TYPE_SELL_STOP:
                       {
                        if(!OrderDelete(OrderTicket(),clrYellow))
                          {
                           PrintFormat("Failed to delete order %d, error:%d",OrderTicket(),GetLastError());
                          }
                        break;
                       }
                    }

                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void controlSignal()
  {


//--- get buy and sell opened order count for symbol
   int boc = (int)_funcOC(ORDER_TYPE_BUY,symbol);
   if(boc > 0)
      return;
   int soc = (int)_funcOC(ORDER_TYPE_SELL,symbol);
   if(soc > 0)
      return;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEventTesting()
  {
//--- check symbol selection buttons
   ENUM_ORDER_TYPE op_type;
   int y=40;
   if(ChartGetInteger(0,CHART_SHOW_ONE_CLICK))
      y=120;
   comment.Create("BotPanel",20,y);
   comment.SetColor(clrDimGray,clrGreen,220);
   string name;
   bool state;
   long lparam = 0;
   double dparam = 0;
   if(ShowTradedSymbols)
     {
      for(int s=0; s<NumOfSymbols; s++)
        {
         name = OBJPFX+"SGGS"+IntegerToString(s);
         state = ObjectGetInteger(ChartID(),name,OBJPROP_STATE);
         if(state)    //--- button is selected, check if symbol selected has changed
           {

            if(SymbolButtonSelected != s)    //--- trigger button event
              {


               OnChartEvent(CHARTEVENT_OBJECT_CLICK,lparam,dparam,name);
              }
           }
        }
     }
   if(inpTradeMode == Manual)    //--- Trade panel is created in manual mode only
     {
      //--- check buy / sell buttons
      name = OBJPFX"btnSell";
      state = ObjectGetInteger(ChartID(),name,OBJPROP_STATE);
      if(state)
        {
         op_type=OP_SELL;
         OnChartEvent(CHARTEVENT_OBJECT_CLICK,lparam,dparam,name);
        }
      name = OBJPFX"btnBuy";
      state = ObjectGetInteger(ChartID(),name,OBJPROP_STATE);
      if(state)
        {
         op_type=OP_BUY;
         OnChartEvent(CHARTEVENT_OBJECT_CLICK,lparam,dparam,name);
        }
      name = OBJPFX"btnSS";
      state = ObjectGetInteger(ChartID(),name,OBJPROP_STATE);
      if(state)
        {
         op_type=OP_SELLLIMIT;
         OnChartEvent(CHARTEVENT_OBJECT_CLICK,lparam,dparam,name);
        }
      name = OBJPFX"btnBS";
      state = ObjectGetInteger(ChartID(),name,OBJPROP_STATE);
      if(state)
        {
         op_type=OP_SELLSTOP;
         OnChartEvent(CHARTEVENT_OBJECT_CLICK,lparam,dparam,name);
        }
      name = OBJPFX"btnSL";
      state = ObjectGetInteger(ChartID(),name,OBJPROP_STATE);
      if(state)
        {
         op_type=OP_BUYSTOP;
         OnChartEvent(CHARTEVENT_OBJECT_CLICK,lparam,dparam,name);
        }
      name = OBJPFX"btnBL";
      state = ObjectGetInteger(ChartID(),name,OBJPROP_STATE);
      if(state)
        {
         op_type=OP_BUYLIMIT;
         OnChartEvent(CHARTEVENT_OBJECT_CLICK,lparam,dparam,name);
        }

      //--- close panel
      for(int i=0; i<MAX_CLOSE_BUTTONS; i++)
        {
         name = OBJPFX+CloseButtonNames[i];
         state = ObjectGetInteger(ChartID(),name,OBJPROP_STATE);
         if(state)
           {
            OnChartEvent(CHARTEVENT_OBJECT_CLICK,lparam,dparam,name);
           }
        }

     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ReleaseOtherButtons(const long index)
  {
   for(int s=0; s<NumOfSymbols; s++)
     {
      if(s != index)
        {
         string name = OBJPFX+"SGGS"+IntegerToString(s);
         ObjectSetInteger(ChartID(),name,OBJPROP_BGCOLOR,clrRed);
         ObjectSetInteger(ChartID(),name,OBJPROP_STATE,false);
        }
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GetManualSignalIndex()
  {
   bool found = false;
   int index = -1;
   int size = ArraySize(ManualSignals);
   for(int i=0; i<size; i++)
     {
      if(ManualSignals[i].done)
        {
         index = i;
         break;
        }
     }
   if(index < 0)
     {
      ArrayResize(ManualSignals,size+1);
      index = size;
     }
   return index;
  }

//+------------------------------------------------------------------+
//| Create the arrow                                                 |
//+------------------------------------------------------------------+
bool ArrowCreate(const long              chart_ID=0,           // chart's ID
                 const string            name="Arrow",         // arrow name
                 const int               sub_window=0,         // subwindow index
                 datetime                time=0,               // anchor point time
                 double                  prices=0,              // anchor point price
                 const uchar             arrow_code=252,       // arrow code
                 const ENUM_ANCHOR_POINT anchor=ANCHOR_CENTER, // anchor point position
                 const color             clr=clrRed,           // arrow color
                 const ENUM_LINE_STYLE   style=STYLE_SOLID,    // border line style
                 const int               width=1,              // arrow size
                 const bool              back=true,           // in the background
                 const bool              selection=false,       // highlight to move
                 const bool              hidden=true,          // hidden in the object list
                 const long              z_order=0)            // priority for mouse click
  {
   double price=prices;
//--- set anchor point coordinates if they are not set
   ChangeArrowEmptyPoint(time,price);
//--- reset the error value
   ResetLastError();
//--- create an arrow
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create an arrow! Error code = ",GetLastError());
      return(false);
     }
//--- set the arrow code
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,arrow_code);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set the arrow color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set the border line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set the arrow's size
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the arrow by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the anchor point                                            |
//+------------------------------------------------------------------+
bool ArrowMove(const long   chart_ID=0,   // chart's ID
               const string name="Arrow", // object name
               datetime     time=0,       // anchor point time coordinate
               double       prices=0)      // anchor point price coordinate
  {
   double price=prices;
//--- if point position is not set, move it to the current bar having Bid price
   if(!time)
      time=mydate;
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value
   ResetLastError();
//--- move the anchor point
   if(!ObjectMove(chart_ID,name,0,time,price))
     {
      Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change the arrow code                                            |
//+------------------------------------------------------------------+
bool ArrowCodeChange(const long   chart_ID=0,   // chart's ID
                     const string name="Arrow", // object name
                     const uchar  code=252)     // arrow code
  {
//--- reset the error value
   ResetLastError();
//--- change the arrow code
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,code))
     {
      Print(__FUNCTION__,
            ": failed to change the arrow code! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Change anchor type                                               |
//+------------------------------------------------------------------+
bool ArrowAnchorChange(const long              chart_ID=0,        // chart's ID
                       const string            name="Arrow",      // object name
                       const ENUM_ARROW_ANCHOR anchor=ANCHOR_TOP) // anchor type
  {
//--- reset the error value
   ResetLastError();
//--- change anchor type
   if(!ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor))
     {
      Print(__FUNCTION__,
            ": failed to change anchor type! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete an arrow                                                  |
//+------------------------------------------------------------------+
bool ArrowDelete(const long   chart_ID=0,   // chart's ID
                 const string name="Arrow") // arrow name
  {
//--- reset the error value
   ResetLastError();
//--- delete an arrow
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete an arrow! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Check anchor point values and set default values                 |
//| for empty ones                                                   |
//+------------------------------------------------------------------+
void ChangeArrowEmptyPoint(datetime &time,double &prices)
  {
   double price=prices;
//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=mydate;
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MoveSymbolPanel()
  {
   int x =0;
   int y =0;
   for(int j=0; j<NumOfSymbols; j++)
     {
      //--- Creation of GUI buttons
      ButtonMove(0,OBJPFX"SGGS"+(string)j,startx_symbolpanel+x,starty_symbolpanel+y+10);
      x+=(panelwidth/5);
      if(x>=panelwidth)
        {
         x=0;
         y+= buttonheight;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckSymbolPanel()
  {
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateClosePanel()
  {
   if(inpTradeMode == Manual)    //--- Close panel is created in manual mode only
     {
      RectLabelCreate(0,OBJPFX"CPTop",0,startx_closepanel,starty_closepanel,buttonwidth+10,30,(C'33,33,33'),true,CORNER_LEFT_UPPER,
                      clrWhite,STYLE_SOLID,2,false,false,true,-1);

      LabelCreate(0,OBJPFX"CPTitle",0,startx_closepanel+5,starty_closepanel+2,CORNER_LEFT_UPPER,"Close Panel","Calibri",PanelFontSize,clrWhite,0,ANCHOR_LEFT_UPPER,false,false,false,0);

      ButtonCreate(0,OBJPFX"CPCloseBuy",0,startx_closepanel+5,starty_closepanel+32,buttonwidth,buttonheight,CORNER_LEFT_UPPER,"Close Buy","Calibri",PanelFontSize,clrWhite,clrRed,clrNONE,false,false,false,true,0);
      ButtonCreate(0,OBJPFX"CPCloseSell",0,startx_closepanel+5,starty_closepanel+32+(1*buttonheight),buttonwidth,buttonheight,CORNER_LEFT_UPPER,"Close Sell","Calibri",PanelFontSize,clrWhite,clrRed,clrNONE,false,false,false,true,0);
      ButtonCreate(0,OBJPFX"CPCloseProfit",0,startx_closepanel+5,starty_closepanel+32+(2*buttonheight),buttonwidth,buttonheight,CORNER_LEFT_UPPER,"Close Profit","Calibri",PanelFontSize,clrWhite,clrRed,clrNONE,false,false,false,true,0);
      ButtonCreate(0,OBJPFX"CPCloseLoss",0,startx_closepanel+5,starty_closepanel+32+(3*buttonheight),buttonwidth,buttonheight,CORNER_LEFT_UPPER,"Close Loss","Calibri",PanelFontSize,clrWhite,clrRed,clrNONE,false,false,false,true,0);
      ButtonCreate(0,OBJPFX"CPCloseLimit",0,startx_closepanel+5,starty_closepanel+32+(4*buttonheight),buttonwidth,buttonheight,CORNER_LEFT_UPPER,"Close Pend. Limit","Calibri",PanelFontSize,clrWhite,clrRed,clrNONE,false,false,false,true,0);
      ButtonCreate(0,OBJPFX"CPCloseStop",0,startx_closepanel+5,starty_closepanel+32+(5*buttonheight),buttonwidth,buttonheight,CORNER_LEFT_UPPER,"Close Pend. Stop","Calibri",PanelFontSize,clrWhite,clrRed,clrNONE,false,false,false,true,0);
      ButtonCreate(0,OBJPFX"CPCloseAll",0,startx_closepanel+5,starty_closepanel+32+(6*buttonheight),buttonwidth,buttonheight,CORNER_LEFT_UPPER,"Clear All Positions","Calibri",PanelFontSize,clrWhite,clrRed,clrNONE,false,false,false,true,0);

     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MoveClosePanel()
  {
   if(inpTradeMode == Manual)    //--- Close panel is created in manual mode only
     {
      RectLabelMove(0,OBJPFX"CPTop",startx_closepanel,starty_closepanel);

      LabelMove(0,OBJPFX"CPTitle",startx_closepanel+5,starty_closepanel+2);

      ButtonMove(0,OBJPFX"CPCloseBuy",startx_closepanel+5,starty_closepanel+32);
      ButtonMove(0,OBJPFX"CPCloseSell",startx_closepanel+5,starty_closepanel+32+(1*buttonheight));
      ButtonMove(0,OBJPFX"CPCloseProfit",startx_closepanel+5,starty_closepanel+32+(2*buttonheight));
      ButtonMove(0,OBJPFX"CPCloseLoss",startx_closepanel+5,starty_closepanel+32+(3*buttonheight));
      ButtonMove(0,OBJPFX"CPCloseLimit",startx_closepanel+5,starty_closepanel+32+(4*buttonheight));
      ButtonMove(0,OBJPFX"CPCloseStop",startx_closepanel+5,starty_closepanel+32+(5*buttonheight));
      ButtonMove(0,OBJPFX"CPCloseAll",startx_closepanel+5,starty_closepanel+32+(6*buttonheight));

     }
  }


//--- GUI
//+------------------------------------------------------------------+
//| OnTester                                                         |
//+------------------------------------------------------------------+
void _OnTester()
  {
//--- CheckObjects
   OnChartEventTesting();

//-- GetSetUserInputs
   GetSetInputs();

//-- MoveClient
   bool coordinates_set = false;
   if(inpTradeMode == Manual)    //--- Trade panel is created in manual mode only
     {
      if(ObjectFind(0,OBJPFX"Back")==IndicatorSubWindow)//ObjectIsPresent
        {
         //-- GetCurrentPos
         int bg_x=(int)ObjectGetInteger(0,OBJPFX"Back",OBJPROP_XDISTANCE);
         int bg_y=(int)ObjectGetInteger(0,OBJPFX"Back",OBJPROP_YDISTANCE);
         //-- MoveObjects
         if(bg_x!=startx || bg_y!=starty)
           {
            GetSetCoordinates();
            MoveGUI();
            coordinates_set = true;
           }
        }
      //--- Move close panel
      if(ObjectFind(0,OBJPFX"BackCP")==IndicatorSubWindow)//ObjectIsPresent
        {
         //-- GetCurrentPos
         int bg_x=(int)ObjectGetInteger(0,OBJPFX"BackCP",OBJPROP_XDISTANCE);
         int bg_y=(int)ObjectGetInteger(0,OBJPFX"BackCP",OBJPROP_YDISTANCE);
         //-- MoveObjects
         if(bg_x!=startx_closepanel || bg_y!=starty_closepanel)
           {
            if(!coordinates_set)
               GetSetCoordinates();
            MoveClosePanel();
            coordinates_set = true;
           }
        }
     }
//--- move symbol panel
   if(ObjectFind(0,OBJPFX"BackSP")==IndicatorSubWindow)//ObjectIsPresent
     {
      //-- GetCurrentPos
      int bg_x=(int)ObjectGetInteger(0,OBJPFX"BackSP",OBJPROP_XDISTANCE);
      int bg_y=(int)ObjectGetInteger(0,OBJPFX"BackSP",OBJPROP_YDISTANCE);
      //-- MoveObjects
      if(bg_x!=startx_symbolpanel || bg_y!=starty_symbolpanel)
        {
         if(!coordinates_set)
            GetSetCoordinates();
         MoveSymbolPanel();
         coordinates_set = true;
        }
     }
//---
  }
//+------------------------------------------------------------------+
//| GetSetInputs                                                     |
//+------------------------------------------------------------------+
void GetSetInputs()
  {
//--
  }

//+------------------------------------------------------------------+
//| GetSetCoordinates                                                |
//+------------------------------------------------------------------+
void GetSetCoordinates()
  {
//--

//--- check symbol selection buttons

   int y=40;
   if(ChartGetInteger(0,CHART_SHOW_ONE_CLICK))
      y=120;
   comment.Create("BotPanel",20,y);
   comment.SetColor(clrDimGray,clrGreen,220);
   string name;
   bool state;
   long lparam = 0;
   double dparam = 0;
   if(ShowTradedSymbols)
     {
      for(int s=0; s<NumOfSymbols; s++)
        {
         name = OBJPFX+"SGGS"+IntegerToString(s);
         state = ObjectGetInteger(ChartID(),name,OBJPROP_STATE);
         if(state)    //--- button is selected, check if symbol selected has changed
           {

            if(SymbolButtonSelected != s)    //--- trigger button event
              {
               OnChartEvent(CHARTEVENT_OBJECT_CLICK,lparam,dparam,name);
              }
           }
        }
     }
   if(inpTradeMode == Manual)    //--- Trade panel is created in manual mode only
     {
      if(ObjectFind(OBJPFX"Back")<0)//--- ObjectNotFound
        {
         string ExpertName = JOB"TradeExpert @"+Symbol();
         //-- GetXYValues (Saved)
         if(GlobalVariableGet(ExpertName+" - X")!=0 && GlobalVariableGet(ExpertName+" - Y")!=0)
           {
            startx=(int)GlobalVariableGet(ExpertName+" - X");
            starty=(int)GlobalVariableGet(ExpertName+" - Y");
           }
         //-- SetXYValues (Default)
         else
           {
            startx=CLIENT_BG_X;
            starty=CLIENT_BG_Y;
           }

         //-- CreateObject (Background)
         RectLabelCreate(0,OBJPFX"Back",0,startx,starty,panelwidth,panelheight,(C'72,72,72'),true,CORNER_LEFT_UPPER,
                         clrWhite,STYLE_SOLID,2,false,true,true,0);
         ObjectSetInteger(0,OBJPFX"Back",OBJPROP_SELECTED,false);//UnselectObject
        }

      //-- GetCoordinates
      startx=(int)ObjectGetInteger(0,OBJPFX"Back",OBJPROP_XDISTANCE);
      starty=(int)ObjectGetInteger(0,OBJPFX"Back",OBJPROP_YDISTANCE);
      //--- close panel
      if(ObjectFind(OBJPFX"BackCP")<0)//--- ObjectNotFound
        {
         string ExpertName = JOB""+Symbol();
         //-- GetXYValues (Saved)
         if(GlobalVariableGet(ExpertName+" - XCP")!=0 && GlobalVariableGet(ExpertName+" - YCP")!=0)
           {
            startx_closepanel=(int)GlobalVariableGet(ExpertName+" - XCP");
            starty_closepanel=(int)GlobalVariableGet(ExpertName+" - YCP");
           }
         //-- SetXYValues (Default)
         else
           {
            startx_closepanel=CLIENT_BG_X+panelwidth+10;
            starty_closepanel=CLIENT_BG_Y;
           }

         //-- CreateObject (Background)
         RectLabelCreate(0,OBJPFX"BackCP",0,startx_closepanel,starty_closepanel,buttonwidth+10,40+MAX_CLOSE_BUTTONS*buttonheight,(C'72,72,72'),true,CORNER_LEFT_UPPER,
                         clrWhite,STYLE_SOLID,2,false,true,true,0);
         ObjectSetInteger(0,OBJPFX"BackCP",OBJPROP_SELECTED,false);//UnselectObject
        }

      //-- GetCoordinates
      startx_closepanel=(int)ObjectGetInteger(0,OBJPFX"BackCP",OBJPROP_XDISTANCE);
      starty_closepanel=(int)ObjectGetInteger(0,OBJPFX"BackCP",OBJPROP_YDISTANCE);
     }
//--- symbol panel
   if(ShowTradedSymbols)
     {
      if(ObjectFind(OBJPFX"BackSP")<0)//--- ObjectNotFound
        {
         string ExpertName = JOB""+Symbol();
         //-- GetXYValues (Saved)
         if(GlobalVariableGet(ExpertName+" - XSP")!=0 && GlobalVariableGet(ExpertName+" - YSP")!=0)
           {
            startx_symbolpanel=(int)GlobalVariableGet(ExpertName+" - XSP");
            starty_symbolpanel=(int)GlobalVariableGet(ExpertName+" - YSP");
           }
         //-- SetXYValues (Default)
         else
           {
            startx_symbolpanel=CLIENT_BG_X;
            starty_symbolpanel=CLIENT_BG_Y+panelheight+10;
           }

         //-- CreateObject (Background): set the width to a button width and the height to a button heigth + toolbar size in order to be able to select the dashboard
         //--- without selecting a symbol
         int pw = (panelwidth/5)*(1 + (NumOfSymbols>=5 ? 4 : (NumOfSymbols % 5)-1));
         int ph = 10 + buttonheight*(1 + (NumOfSymbols>5 ? NumOfSymbols/5 : 0));

         RectLabelCreate(0,OBJPFX"BackSP",0,startx_symbolpanel,starty_symbolpanel,pw,ph,(C'72,72,72'),true,CORNER_LEFT_UPPER,
                         clrWhite,STYLE_SOLID,2,false,true,true,0);
         ObjectSetString(ChartID(),OBJPFX"BackSP",OBJPROP_TEXT,"Symbol"+(NumOfSymbols>1 ? "s":""));
         ObjectSetInteger(0,OBJPFX"BackSP",OBJPROP_SELECTED,false);//UnselectObject
        }

      //-- GetCoordinates
      startx_symbolpanel=(int)ObjectGetInteger(0,OBJPFX"BackSP",OBJPROP_XDISTANCE);
      starty_symbolpanel=(int)ObjectGetInteger(0,OBJPFX"BackSP",OBJPROP_YDISTANCE);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateGUI()
  {
   if(inpTradeMode == Manual)    //--- Trade panel is created in manual mode only
     {
      RectLabelCreate(0,OBJPFX"top",0,startx,starty,panelwidth,30,(C'33,33,33'),true,CORNER_LEFT_UPPER,
                      clrWhite,STYLE_SOLID,2,false,false,true,-1);

      LabelCreate(0,OBJPFX"indName",0,startx+5,starty+2,CORNER_LEFT_UPPER,"Funmitemi Fx Panel","Calibri",PanelFontSize,clrWhite,0,ANCHOR_LEFT_UPPER,false,false,false,0);

      ButtonCreate(0,OBJPFX"btnSell",0,startx+5,starty+32,buttonwidth,buttonheight,CORNER_LEFT_UPPER,"Sell","Calibri",PanelFontSize,
                   clrWhite,clrRed,clrNONE,false,false,false,true,0);

      EditCreate(0,OBJPFX"editLot",0,startx+5+(buttonwidth),starty+32,buttonwidth,buttonheight,(string)TradeSize(InpMoneyManagement),"Calibri",PanelFontSize,ALIGN_CENTER,false,
                 CORNER_LEFT_UPPER,clrWhite,clrGray,clrNONE,false,false,true,10);
      ButtonCreate(0,OBJPFX"btnBuy",0,startx+5+(buttonwidth*2),starty+32,buttonwidth,buttonheight,CORNER_LEFT_UPPER,"Buy","Calibri",PanelFontSize,
                   clrWhite,clrLime,clrNONE,false,false,false,true,0);

      LabelCreate(0,OBJPFX"lblStop",0,startx+5,starty+2+(buttonheight*2),CORNER_LEFT_UPPER,"STOP","Calibri",PanelFontSize,clrWhite,0,ANCHOR_LEFT_UPPER,false,false,false,0);
      LabelCreate(0,OBJPFX"lblTP",0,startx+5+(buttonwidth),starty+2+(buttonheight*2),CORNER_LEFT_UPPER,"PROFIT","Calibri",PanelFontSize,clrWhite,0,ANCHOR_LEFT_UPPER,false,false,false,0);


      LabelCreate(0,OBJPFX"lblTN",0,startx+5+(buttonwidth*2),starty+2+(buttonheight*2),CORNER_LEFT_UPPER,"No. Of Trades","Calibri",PanelFontSize,clrWhite,0,ANCHOR_LEFT_UPPER,false,false,false,0);


      EditCreate(0,OBJPFX"editStop",0,startx+5,starty-10+(buttonheight*3),buttonwidth,buttonheight,(string)inpSL,"Calibri",PanelFontSize,ALIGN_CENTER,false,
                 CORNER_LEFT_UPPER,clrWhite,clrGray,clrNONE,false,false,true,10);
      EditCreate(0,OBJPFX"editTP",0,startx+5+(buttonwidth),starty-10+(buttonheight*3),buttonwidth,buttonheight,(string)inpTP,"Calibri",PanelFontSize,ALIGN_CENTER,false,
                 CORNER_LEFT_UPPER,clrWhite,clrGray,clrNONE,false,false,true,10);

      EditCreate(0,OBJPFX"editTN",0,startx+5+(buttonwidth*2),starty-10+(buttonheight*3),buttonwidth,buttonheight,(string)MaxOpenTrades,"Calibri",PanelFontSize,ALIGN_CENTER,false,
                 CORNER_LEFT_UPPER,clrWhite,clrGray,clrNONE,false,false,true,10);

      ButtonCreate(0,OBJPFX"btnSS",0,startx+(int)5,starty-10+(buttonheight*4),(int)(buttonwidth*1.5),(int)buttonheight,CORNER_LEFT_UPPER,"Sell Stop","Calibri",PanelFontSize,
                   clrWhite,clrRed,clrNONE,false,false,false,true,0);
      ButtonCreate(0,OBJPFX"btnBS",0,startx+(int)5+(int)(buttonwidth*1.5),starty-10+(buttonheight*4),(int)(buttonwidth*1.5),buttonheight,CORNER_LEFT_UPPER,"But Stop","Calibri",PanelFontSize,
                   clrWhite,clrLime,clrNONE,false,false,false,true,0);

      ButtonCreate(0,OBJPFX"btnSL",0,startx+5,starty-10+(buttonheight*5),(int)(buttonwidth*1.5),buttonheight,CORNER_LEFT_UPPER,"Sell Limit","Calibri",PanelFontSize,
                   clrWhite,clrRed,clrNONE,false,false,false,true,0);
      ButtonCreate(0,OBJPFX"btnBL",0,startx+5+(int)(buttonwidth*1.5),starty-10+(buttonheight*5),(int)(buttonwidth*1.5),buttonheight,CORNER_LEFT_UPPER,"Buy Limit","Calibri",PanelFontSize,
                   clrWhite,clrLime,clrNONE,false,false,false,true,0);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void MoveGUI()
  {
   if(inpTradeMode == Manual)    // Trade panel is created in manual mode only
     {
      RectLabelMove(0,OBJPFX"top",startx,starty);

      LabelMove(0,OBJPFX"indName",startx+5,starty+2);

      ButtonMove(0,OBJPFX"btnSell",startx+5,starty+32);

      EditMove(0,OBJPFX"editLot",startx+5+(buttonwidth),starty+32);
      ButtonMove(0,OBJPFX"btnBuy",startx+5+(buttonwidth*2),starty+32);

      LabelMove(0,OBJPFX"lblStop",startx+5,starty+2+(buttonheight*2));
      LabelMove(0,OBJPFX"lblTP",startx+5+(buttonwidth),starty+2+(buttonheight*2));

      LabelMove(0,OBJPFX"lblTN",startx+5+(buttonwidth*2),starty+2+(buttonheight*2));

      EditMove(0,OBJPFX"editStop",startx+5,starty-10+(buttonheight*3));
      EditMove(0,OBJPFX"editTP",startx+5+(buttonwidth),starty-10+(buttonheight*3));

      EditMove(0,OBJPFX"editTN",startx+5+(buttonwidth*2),starty-10+(buttonheight*3));

      ButtonMove(0,OBJPFX"btnSS",startx+(int)5,starty-10+(buttonheight*4));
      ButtonMove(0,OBJPFX"btnBS",startx+(int)5+(int)(buttonwidth*1.5),starty-10+(buttonheight*4));

      ButtonMove(0,OBJPFX"btnSL",startx+5,starty-10+(buttonheight*5));
      ButtonMove(0,OBJPFX"btnBL",startx+5+(int)(buttonwidth*1.5),starty-10+(buttonheight*5));
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CheckGUI()
  {
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CreateSymbolPanel(bool   showSymbolPanel)
  {
   if(!showSymbolPanel)
      return;
   int x =0;
   int y =0;
   for(int j=0; j<NumOfSymbols; j++)
     {
      //--- Initialization of buy/sell state arrays
      _isBuy[j] = false;
      _isSell[j] = false;
      //--- Creation of GUI buttons
      ButtonCreate(0,OBJPFX"SGGS"+(string)j,0,startx_symbolpanel+x,starty_symbolpanel+y+10,panelwidth/5,buttonheight,CORNER_LEFT_UPPER,mysymbolList[j],"Calibri",TradedSymbolsFontSize,
                   clrWhite,j==0?clrLime:clrRed,clrNONE,j==SymbolButtonSelected?true:false,false,false,true,0);
      x+=(panelwidth/5);
      if(x>=panelwidth)
        {
         x=0;
         y+= buttonheight;
        }
     }
  }



//+------------------------------------------------------------------+
//|                      CloseByDuration                                            |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void CloseByDuration(int sec) //close trades opened longer than sec seconds
  {
   if(!IsTradeAllowed())
      return;
   bool success = false;
   int err = 0;
   int total = OrdersTotal();
   int orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy())
         Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != symbol || OrderType() > 1 || OrderOpenTime() + sec > mydate)
         continue;
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = (int)OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(!OrderSelect(orderList[i][1], SELECT_BY_TICKET, MODE_TRADES))
         continue;
      while(IsTradeContextBusy())
         Sleep(100);
      RefreshRates();
      double    price = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),vdigits);
      if(OrderType() == OP_SELL)
         price =  NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK),vdigits);
      success = OrderClose(OrderTicket(), NormalizeDouble(OrderLots(), LotDigits), NormalizeDouble(price, vdigits), MaxSlippage, clrWhite);
      if(!success)
        {
         err = GetLastError();
         myAlert("error", "OrderClose failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
        }
     }
   if(success)
      myAlert("order", "Orders closed by duration: "+symbol+" Magic #"+IntegerToString(MagicNumber));
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MM_Size(double SLs) //Risk % per trade, SL = relative Stop Loss to calculate risk
  {

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
   double MaxLot = MarketInfo(symbol, MODE_MAXLOT);
   double MinLot = MarketInfo(symbol, MODE_MINLOT);
   SL=SLs;
   double tickvalue = MarketInfo(symbol, MODE_TICKVALUE);
   double ticksize = MarketInfo(symbol, MODE_TICKSIZE);
   double lots = Risk_Percentage * 1.0 / 100 * AccountBalance() / (SL / ticksize * tickvalue);
   if(lots > MaxLot)
      lots = MaxLot;
   if(lots < MinLot)
      lots = MinLot;
   return(lots);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MM_Size_BO() //Risk % per trade for Binary Options
  {

   double MaxLot = MarketInfo(symbol, MODE_MAXLOT);
   double MinLot = MarketInfo(symbol, MODE_MINLOT);
   MaxLot = MarketInfo(symbol, MODE_MAXLOT);
   MinLot = MarketInfo(symbol, MODE_MINLOT);
   double tickvalue = MarketInfo(symbol, MODE_TICKVALUE);
   double ticksize = MarketInfo(symbol, MODE_TICKSIZE);
   return(Risk_Percentage * 1.0 / 100 * AccountBalance());
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void myAlert(string type, string messagess)
  {
   message=messagess;
   int handle;
   if(type == "print")
      Print(message);
   else
      if(type == "error")
        {
         Print(type+" | TradeExpert @ "+symbol+","+IntegerToString(Period())+" | "+message);
         if(Send_Email)
            SendMail("TradeExpert ", type+" | TradeExpert @ "+symbol+","+IntegerToString(Period())+" | "+message);
         message=type+" | TradeExpert @ "+symbol+","+IntegerToString(Period())+" | "+message;
         smartBot.SendMessageToChannel(InpChannel,message);

        }
      else
         if(type == "order")
           {
            Print(type+" | TradeExpert @ "+symbol+","+IntegerToString(Period())+" | "+message);
            if(Audible_Alerts)
               Alert(type+" |TradeExpert @ "+symbol+","+IntegerToString(Period())+" | "+message);
            if(Send_Email)
               SendMail("TradeExpert", type+" | TradeExpert @ "+symbol+","+IntegerToString(Period())+" | "+message);
            handle = FileOpen("SmartTrader1.txt", FILE_TXT|FILE_READ|FILE_WRITE|FILE_SHARE_READ|FILE_SHARE_WRITE, ';');
            if(handle != INVALID_HANDLE)
              {
               FileSeek(handle, 0, SEEK_END);
               FileWrite(handle, type+" | TradeExpert @ "+symbol+","+IntegerToString(Period())+" | "+message);
               FileClose(handle);
              }
            if(Push_Notifications)
               SendNotification(type+" | TradeExpert @"+symbol+","+IntegerToString(Period())+" | "+message);
           }
         else
            if(type == "modify")
              {
               Print(type+" |TradeExpert @"+symbol+","+IntegerToString(Period())+" | "+message);
               if(Audible_Alerts)
                  Alert(type+" | TradeExpert @ "+Symbol()+","+IntegerToString(Period())+" | "+message);
               if(Send_Email)
                  SendMail("TradeExpert", type+" | TradeExpert @"+Symbol()+","+IntegerToString(Period())+" | "+message);
               handle = FileOpen("SmartTrader1.txt", FILE_TXT|FILE_READ|FILE_WRITE|FILE_SHARE_READ|FILE_SHARE_WRITE, ';');
               if(handle != INVALID_HANDLE)
                 {
                  FileSeek(handle, 0, SEEK_END);
                  FileWrite(handle, type+" | TradeExpert @ "+symbol+","+IntegerToString(Period())+" | "+message);
                  FileClose(handle);
                 }
               if(Push_Notifications)
                  SendNotification(type+" | TradeExpert @ "+symbol+","+IntegerToString(Period())+" | "+message);
              }
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime LastOpenTradeTime()
  {
   datetime result = 0;
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderType() > 1)
         continue;
      if(OrderSymbol() == symbol && OrderMagicNumber() == MagicNumber)
        {
         result = OrderOpenTime();
         break;
        }
     }
   return(result);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime LastOpenTime()
  {
   datetime opentime1 = 0, opentime2 = 0;
   if(SelectLastHistoryTrade())
      opentime1 = OrderOpenTime();
   opentime2 = LastOpenTradeTime();
   if(opentime1 > opentime2)
      return opentime1;
   else
      return opentime2;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int myOrderSend(int type, double price, double volume, string ordername) //send order, return ticket ("price" is irrelevant for market orders)
  {

   if(!IsTradeAllowed())
      return(-1);
   ticket = -1;
   int retries = 0;
   int err = 0;
   int long_trades = TradesCount(OP_BUY);
   int short_trades = TradesCount(OP_SELL);
   int long_pending = TradesCount(OP_BUYLIMIT) + TradesCount(OP_BUYSTOP);
   int short_pending = TradesCount(OP_SELLLIMIT) + TradesCount(OP_SELLSTOP);
   string ordername_ = ordername;
   if(ordername != "")
      ordername_ = "("+ordername+")";
//test Hedging
   if(!Hedging && ((type % 2 == 0 && short_trades + short_pending > 0) || (type % 2 == 1 && long_trades + long_pending > 0)))
     {
      myAlert("print", "Order"+ordername_+" not sent, hedging not allowed");
      message="Order"+ordername_+" not sent, hedging not allowed";
      smartBot.SendMessage(InpChatID2,message);
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
      myAlert("print", "Order"+ordername_+" not sent, maximum reached");
      message="Order"+ordername_+" not sent, maximum reached";
      smartBot.SendMessage(InpChatID2,message);
      return(-1);
     }
//prepare to send order
   while(IsTradeContextBusy())
      Sleep(100);
   RefreshRates();
   if(type == OP_BUY)
      price =NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK),vdigits);
   else
      if(type == OP_SELL)
         price = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),vdigits);
      else
         if(price < 0) //invalid price for pending order
           {
            myAlert("order", "Order"+ordername_+" not sent, invalid price for pending order");
            message= "Order"+ordername_+" not sent, maximum reached";
            smartBot.SendMessage(InpChatID2,message);
            return(-1);
           }
   int clr = (type % 2 == 1) ? clrRed : clrBlue;
//adjust price for pending order if it is too close to the market price
   double MinDistance = PriceTooClose * myPoint;
   if(type == OP_BUYLIMIT && NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK),vdigits)- price < MinDistance)
      price = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK),vdigits) - MinDistance;
   else
      if(type == OP_BUYSTOP && price - NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK),vdigits) < MinDistance)
         price = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK),vdigits) + MinDistance;
      else
         if(type == OP_SELLLIMIT && price - NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),vdigits) < MinDistance)
            price = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),vdigits) + MinDistance;
         else
            if(type == OP_SELLSTOP && NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),vdigits) - price < MinDistance)
               price = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),vdigits)- MinDistance;
   while(ticket < 0 && retries < OrderRetry+1)
     {

      double tpx2=NormalizeDouble(MinTP*myPoint,(int)vdigits);
      double  TradingLots=0;
      if(type==OP_BUY|| type==OP_BUYLIMIT||type==OP_BUYSTOP)
        {

         if(UseFibo_TP)
           {
            if(OrderProfit()<0)
              {


               datetime expr = 0;
               xlimit =NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID)-orderdistance*myPoint,(int)vdigits);
               xstop =NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID)+orderdistance*myPoint,(int)vdigits);
               slimit =NormalizeDouble(xlimit-MaxSL*myPoint,(int)vdigits);
               slstop =NormalizeDouble(xstop-MaxSL*myPoint,(int)vdigits);
               tplimit =NormalizeDouble(xlimit+MaxTP*myPoint,(int)vdigits)+(tpx2*TB);
               tpstop =NormalizeDouble(xstop+MaxTP*myPoint,(int)vdigits)+(tpx2*TB);
               SL=NormalizeDouble(S3x,(int)vdigits);
               TP=NormalizeDouble(R3x,(int)vdigits);
               if(UseFibo_TP==Yes && S3x == 0)
                  SL=NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK)-MaxSL*myPoint,(int)vdigits);
               if(UseFibo_TP==Yes && R3x == 0)
                  TP=NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK)+MaxTP*myPoint,(int)vdigits)+(tpx2*TB);
               if(TB>0)
                 {
                  TradingLots=SubLots;
                 }
               else
                 {
                  TradingLots=TradeSize(InpMoneyManagement);
                 }

              }


           }
         else
           {

            SL=NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK)-MaxSL*myPoint,(int)vdigits);
            TP=NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK)+MaxTP*myPoint,(int)vdigits)+(tpx2*TB);
           }

        }
      else
        {

         if(UseFibo_TP)
           {




            datetime expr = 0;
            xlimit =NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK)+orderdistance*myPoint,(int)vdigits);
            xstop =NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK)-orderdistance*myPoint,(int)vdigits);
            slimit =NormalizeDouble(xlimit-MaxSL*myPoint,(int)vdigits);
            slstop =NormalizeDouble(xstop-MaxSL*myPoint,(int)vdigits);
            tplimit =NormalizeDouble(xlimit-MaxTP*myPoint,(int)vdigits)-(tpx2*TB);
            tpstop =NormalizeDouble(xstop-MaxTP*myPoint,(int)vdigits)-(tpx2*TB);
            SL=NormalizeDouble(S3x,(int)vdigits);
            TP=NormalizeDouble(R3x,(int)vdigits);
            if(UseFibo_TP==Yes && S3x == 0)
               SL=NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID)+MaxSL*myPoint,(int)vdigits);
            if(UseFibo_TP==Yes && R3x == 0)
               TP=NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID)-MaxTP*myPoint,(int)vdigits)+(tpx2*TB);
            if(TB>0)
              {
               TradingLots=SubLots;
              }
            else
              {
               TradingLots=TradeSize(InpMoneyManagement);
              }




           }
         else
           {

            SL=NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID)-MaxSL*myPoint,(int)vdigits);
            TP=NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID)-MaxTP*myPoint,(int)vdigits)-(tpx2*TB);
           }

        }
      ticket = OrderSend(symbol, type, NormalizeDouble(volume, LotDigits), NormalizeDouble(price, vdigits), MaxSlippage,SL, TP, ordername, MagicNumber, 0, clr);
      if(ticket < 0)
        {
         err = GetLastError();
         myAlert("print", "OrderSend"+ordername_+" error #"+IntegerToString(err)+" "+ErrorDescription(err));
         message="OrderSend"+ordername_+" error #"+IntegerToString(err)+" "+ErrorDescription(err);
         smartBot.SendMessageToChannel(InpChannel,message);
         smartBot.SendMessage(InpChatID2,message);
         Sleep(OrderWait*1000);
        }
      retries++;
     }
   if(ticket < 0)
     {
      myAlert("error", "OrderSend"+ordername_+" failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err));
      message="error"+"OrderSend"+ordername_+" failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err);
      smartBot.SendMessageToChannel(InpChannel,message);
      smartBot.SendMessage(InpChatID2,message);
      return(-1);
     }
   string typestr[6] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop"};
   myAlert("order", "Order sent"+ordername_+": "+typestr[type]+" "+symbol+" Magic #"+IntegerToString(MagicNumber));
   message= "Order sent"+ordername_+": "+typestr[type]+" "+symbol+" Magic #"+IntegerToString(MagicNumber);
   smartBot.SendMessageToChannel(InpChannel,message);
   smartBot.SendMessage(InpChatID2,message);
   return(ticket);
  }

//+------------------------------------------------------------------+
//| Set StopLoss to all orders and positions                         |
//+------------------------------------------------------------------+
void SetStopLoss()
  {
   if(stoploss_to_modify==0)
      return;
//--- Set StopLoss to all positions where it is absent
   CArrayObj* list=engine.GetListMarketPosition();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SL,0,EQUAL);
   if(list==NULL)
      return;
   int total=list.Total();
   for(int i=total-1; i>=0; i--)
     {
      COrder* position=list.At(i);
      if(position==NULL)
         continue;
      SL=CorrectStopLoss(position.Symbol(),position.TypeByDirection(),0,stoploss_to_modify);
#ifdef __MQL5__
      trade.PositionModify(position.Ticket(),SL,position.TakeProfit());
#else
      PositionModify(position.Ticket(),SL,position.TakeProfit());
#endif
     }
//--- Set StopLoss to all pending orders where it is absent
   list=engine.GetListMarketPendings();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_SL,0,EQUAL);
   if(list==NULL)
      return;
   total=list.Total();
   for(int i=total-1; i>=0; i--)
     {
      COrder* order=list.At(i);
      if(order==NULL)
         continue;
      SL=CorrectStopLoss(order.Symbol(),(ENUM_ORDER_TYPE)order.TypeOrder(),order.PriceOpen(),stoploss_to_modify);
#ifdef __MQL5__
      trade.OrderModify(order.Ticket(),order.PriceOpen(),SL,order.TakeProfit(),trade.RequestTypeTime(),trade.RequestExpiration(),order.PriceStopLimit());
#else
      PendingOrderModify(order.Ticket(),order.PriceOpen(),SL,order.TakeProfit());
#endif
     }
  }
//+------------------------------------------------------------------+
//| Set TakeProfit to all orders and positions                       |
//+------------------------------------------------------------------+
void SetTakeProfit(void)
  {
   if(takeprofit_to_modify==0)
      return;
//--- Set TakeProfit to all positions where it is absent
   CArrayObj* list=engine.GetListMarketPosition();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TP,0,EQUAL);
   if(list==NULL)
      return;
   int total=list.Total();
   for(int i=total-1; i>=0; i--)
     {
      COrder* position=list.At(i);
      if(position==NULL)
         continue;
      TP=CorrectTakeProfit(position.Symbol(),position.TypeByDirection(),0,takeprofit_to_modify);
#ifdef __MQL5__
      trade.PositionModify(position.Ticket(),position.StopLoss(),TP);
#else
      PositionModify(position.Ticket(),position.StopLoss(),TP);
#endif
     }
//--- Set TakeProfit to all pending orders where it is absent
   list=engine.GetListMarketPendings();
   list=CSelect::ByOrderProperty(list,ORDER_PROP_TP,0,EQUAL);
   if(list==NULL)
      return;
   total=list.Total();
   for(int i=total-1; i>=0; i--)
     {
      COrder* order=list.At(i);
      if(order==NULL)
         continue;
      TP=CorrectTakeProfit(order.Symbol(),(ENUM_ORDER_TYPE)order.TypeOrder(),order.PriceOpen(),takeprofit_to_modify);
#ifdef __MQL5__
      trade.OrderModify(order.Ticket(),order.PriceOpen(),order.StopLoss(),TP,trade.RequestTypeTime(),trade.RequestExpiration(),order.PriceStopLimit());
#else
      PendingOrderModify(order.Ticket(),order.PriceOpen(),order.StopLoss(),TP);
#endif
     }
  }
//+------------------------------------------------------------------+
//| Trailing stop of a position with the maximum profit              |
//+------------------------------------------------------------------+
void TrailingPositions(bool  trailingPositions)
  {
   if(trailingPositions==false)
      return;
   MqlTick tick;

   if(!SymbolInfoTick(symbol,tick))
      return;
   double stop_level=StopLevel(symbol,2)*myPoint;
//--- Get the list of all open positions
   CArrayObj* list=engine.GetListMarketPosition();
//--- Select only Buy positions from the list
   CArrayObj* list_buy=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_BUY,EQUAL);
//--- Sort the list by profit considering commission and swap
   list_buy.Sort(SORT_BY_ORDER_PROFIT_FULL);
//--- Get the index of the Buy position with the maximum profit
   int index_buy=CSelect::FindOrderMax(list_buy,ORDER_PROP_PROFIT_FULL);
   if(index_buy>WRONG_VALUE)
     {
      COrder* buy=list_buy.At(index_buy);
      if(buy!=NULL)
        {
         //--- Calculate the new StopLoss
         SL=NormalizeDouble(tick.bid-trailing_stop,vdigits);
         //--- If the price and the StopLevel based on it are higher than the new StopLoss (the distance by StopLevel is maintained)
         if(tick.bid-stop_level>SL)
           {
            //--- If the new StopLoss level exceeds the trailing step based on the current StopLoss
            if(buy.StopLoss()+trailing_step<SL)
              {
               //--- If we trail at any profit or position profit in points exceeds the trailing start, modify StopLoss
               if(trailing_start==0 || buy.ProfitInPoints()>(int)trailing_start)
                 {
#ifdef __MQL5__
                  trade.PositionModify(buy.Ticket(),sl,buy.TakeProfit());
#else
                  PositionModify(buy.Ticket(),SL,buy.TakeProfit());
#endif
                 }
              }
           }
        }
     }
//--- Select only Sell positions from the list
   CArrayObj* list_sell=CSelect::ByOrderProperty(list,ORDER_PROP_TYPE,POSITION_TYPE_SELL,EQUAL);
//--- Sort the list by profit considering commission and swap
   list_sell.Sort(SORT_BY_ORDER_PROFIT_FULL);
//--- Get the index of the Sell position with the maximum profit
   int index_sell=CSelect::FindOrderMax(list_sell,ORDER_PROP_PROFIT_FULL);
   if(index_sell>WRONG_VALUE)
     {
      COrder* sell=list_sell.At(index_sell);
      if(sell!=NULL)
        {
         //--- Calculate the new StopLoss
         SL=NormalizeDouble(tick.ask+trailing_stop,vdigits);
         //--- If the price and StopLevel based on it are below the new StopLoss (the distance by StopLevel is maintained)
         if(tick.ask+stop_level<SL)
           {
            //--- If the new StopLoss level is below the trailing step based on the current StopLoss or a position has no StopLoss
            if(sell.StopLoss()-trailing_step>SL || sell.StopLoss()==0)
              {
               //--- If we trail at any profit or position profit in points exceeds the trailing start, modify StopLoss
               if(trailing_start==0 || sell.ProfitInPoints()>(int)trailing_start)
                 {
#ifdef __MQL5__
                  trade.PositionModify(sell.Ticket(),SL,sell.TakeProfit());
#else
                  PositionModify(sell.Ticket(),SL,sell.TakeProfit());
#endif
                 }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Trailing the farthest pending orders                             |
//+------------------------------------------------------------------+
void TrailingOrders(bool trailingOrders)
  {
   if(!trailingOrders)
      return;


   MqlTick tick;

   if(!SymbolInfoTick(symbol,tick))
      return;
   double stop_level=StopLevel(symbol,2)*myPoint;
//--- Get the list of all placed orders
   CArrayObj* list=engine.GetListMarketPendings();
//--- Select only Buy orders from the list
   CArrayObj* list_buy=CSelect::ByOrderProperty(list,ORDER_PROP_DIRECTION,ORDER_TYPE_BUY,EQUAL);
//--- Sort the list by distance from the price in points (by profit in points)
   list_buy.Sort(SORT_BY_ORDER_PROFIT_PT);
//--- Get the index of the Buy order with the greatest distance
   int index_buy=CSelect::FindOrderMax(list_buy,ORDER_PROP_PROFIT_PT);
   if(index_buy>WRONG_VALUE)
     {
      COrder* buy=list_buy.At(index_buy);
      if(buy!=NULL)
        {
         //--- If the order is below the price (BuyLimit) and it should be "elevated" following the price
         if(buy.TypeOrder()==ORDER_TYPE_BUY_LIMIT)
           {
            //--- Calculate the new order price and stop levels based on it
            double price=NormalizeDouble(tick.ask-trailing_stop,vdigits);
            SL=(buy.StopLoss()>0 ? NormalizeDouble(price-(buy.PriceOpen()-buy.StopLoss()),vdigits) : 0);
            TP=(buy.TakeProfit()>0 ? NormalizeDouble(price+(buy.TakeProfit()-buy.PriceOpen()),vdigits) : 0);
            //--- If the calculated price is below the StopLevel distance based on Ask order price (the distance by StopLevel is maintained)
            if(price<tick.ask-stop_level)
              {
               //--- If the calculated price exceeds the trailing step based on the order placement price, modify the order price
               if(price>buy.PriceOpen()+trailing_step)
                 {
#ifdef __MQL5__
                  trade.OrderModify(buy.Ticket(),price,SL,TP,trade.RequestTypeTime(),trade.RequestExpiration(),buy.PriceStopLimit());
#else
                  PendingOrderModify(buy.Ticket(),price,SL,TP);
#endif
                 }
              }
           }
         //--- If the order exceeds the price (BuyStop and BuyStopLimit), and it should be "decreased" following the price
         else
           {
            //--- Calculate the new order price and stop levels based on it
            double price=NormalizeDouble(tick.ask+trailing_stop,vdigits);
            SL=(buy.StopLoss()>0 ? NormalizeDouble(price-(buy.PriceOpen()-buy.StopLoss()),vdigits) : 0);
            TP=(buy.TakeProfit()>0 ? NormalizeDouble(price+(buy.TakeProfit()-buy.PriceOpen()),vdigits) : 0);
            //--- If the calculated price exceeds the StopLevel based on Ask order price (the distance by StopLevel is maintained)
            if(price>tick.ask+stop_level)
              {
               //--- If the calculated price is lower than the trailing step based on order price, modify the order price
               if(price<buy.PriceOpen()-trailing_step)
                 {
#ifdef __MQL5__
                  trade.OrderModify(buy.Ticket(),price,SL,TP,trade.RequestTypeTime(),trade.RequestExpiration(),(buy.PriceStopLimit()>0 ? price-distance_stoplimit*myPoint: 0));
#else
                  PendingOrderModify(buy.Ticket(),price,SL,TP);
#endif
                 }
              }
           }
        }
     }
//--- Select only Sell order from the list
   CArrayObj* list_sell=CSelect::ByOrderProperty(list,ORDER_PROP_DIRECTION,ORDER_TYPE_SELL,EQUAL);
//--- Sort the list by distance from the price in points (by profit in points)
   list_sell.Sort(SORT_BY_ORDER_PROFIT_PT);
//--- Get the index of the Sell order having the greatest distance
   int index_sell=CSelect::FindOrderMax(list_sell,ORDER_PROP_PROFIT_PT);
   if(index_sell>WRONG_VALUE)
     {
      COrder* sell=list_sell.At(index_sell);
      if(sell!=NULL)
        {
         //--- If the order exceeds the price (SellLimit), and it needs to be "decreased" following the price
         if(sell.TypeOrder()==ORDER_TYPE_SELL_LIMIT)
           {
            //--- Calculate the new order price and stop levels based on it
            double price=NormalizeDouble(tick.bid+trailing_stop,vdigits);
            SL=(sell.StopLoss()>0 ? NormalizeDouble(price+(sell.StopLoss()-sell.PriceOpen()),vdigits) : 0);
            TP=(sell.TakeProfit()>0 ? NormalizeDouble(price-(sell.PriceOpen()-sell.TakeProfit()),vdigits) : 0);
            //--- If the calculated price exceeds the StopLevel distance based on the Bid order price (the distance by StopLevel is maintained)
            if(price>tick.bid+stop_level)
              {
               //--- If the calculated price is lower than the trailing step based on order price, modify the order price
               if(price<sell.PriceOpen()-trailing_step)
                 {
#ifdef __MQL5__
                  trade.OrderModify(sell.Ticket(),price,SL,TP,trade.RequestTypeTime(),trade.RequestExpiration(),sell.PriceStopLimit());
#else
                  PendingOrderModify(sell.Ticket(),price,SL,TP);
#endif
                 }
              }
           }
         //--- If the order is below the price (SellStop and SellStopLimit), and it should be "elevated" following the price
         else
           {
            //--- Calculate the new order price and stop levels based on it
            double price=NormalizeDouble(tick.bid-trailing_stop,vdigits);
            SL=(sell.StopLoss()>0 ? NormalizeDouble(price+(sell.StopLoss()-sell.PriceOpen()),vdigits) : 0);
            TP=(sell.TakeProfit()>0 ? NormalizeDouble(price-(sell.PriceOpen()-sell.TakeProfit()),vdigits) : 0);
            //--- If the calculated price is below the StopLevel distance based on the Bid order price (the distance by StopLevel is maintained)
            if(price<tick.bid-stop_level)
              {
               //--- If the calculated price exceeds the trailing step based on the order placement price, modify the order price
               if(price>sell.PriceOpen()+trailing_step)
                 {
#ifdef __MQL5__
                  trade.OrderModify(sell.Ticket(),price,SL,TP,trade.RequestTypeTime(),trade.RequestExpiration(),(sell.PriceStopLimit()>0 ? price+distance_stoplimit*Point() : 0));
#else
                  PendingOrderModify(sell.Ticket(),price,SL,TP);
#endif
                 }
              }
           }
        }
     }
  }


//--- Custom functions -----------------------------------------------

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Price_Gap()
  {

   if((High[1]-Low[2])/2>1)
     {

      return(High[1] / Low[1]);
     }
   return(High[1] - Low[1]);
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int myOrderModifyRel(int ticketS, double SLs, double TPs) //modify SL and TP (relative to open price), zero targets do not modify
  {
   SL=SLs;
   TP=TPs;
   ticketS=ticket;

   smartBot.SendMessage(InpChatID,"Current Price gap: "+(string)Price_Gap(),smartBot.ReplyKeyboardMarkup(KEYB_MAIN,FALSE,FALSE),FALSE,FALSE);
   if(!IsTradeAllowed())
      return(-1);
   bool success = false;
   int retries = 0;
   int err = 0;
   SL = NormalizeDouble(SL, (int)MarketInfo(symbol,MODE_DIGITS));
   TP = NormalizeDouble(TP, (int)MarketInfo(symbol,MODE_DIGITS));
   if(SL < 0)
      SL = 0;
   if(TP < 0)
      TP = 0;
//prepare to select order
   while(IsTradeContextBusy())
      Sleep(100);
   if(!OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES))
     {
      err = GetLastError();
      myAlert("error", "OrderSelect failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
      return(-1);
     }
//prepare to modify order
   while(IsTradeContextBusy())
      Sleep(100);
   RefreshRates();
//convert relative to absolute
   if(OrderType() % 2 == 0) //buy
     {
      if(NormalizeDouble(SL, (int)MarketInfo(symbol,MODE_DIGITS)) != 0)
         SL = OrderOpenPrice() - SL;
      if(NormalizeDouble(TP, (int)MarketInfo(symbol,MODE_DIGITS)) != 0)
         TP = OrderOpenPrice() + TP;
     }
   else //sell
     {
      if(NormalizeDouble(SL,(int)MarketInfo(symbol,MODE_DIGITS)) != 0)
         SL = OrderOpenPrice() + SL;
      if(NormalizeDouble(TP, (int)MarketInfo(symbol,MODE_DIGITS)) != 0)
         TP = OrderOpenPrice() - TP;
     }
   if(CompareDoubles(SL, 0))
      SL = OrderStopLoss(); //not to modify
   if(CompareDoubles(TP, 0))
      TP = OrderTakeProfit(); //not to modify
   if(CompareDoubles(SL, OrderStopLoss()) && CompareDoubles(TP, OrderTakeProfit()))
      return(0); //nothing to do
   while(!success && retries < OrderRetry+1)
     {
      success = OrderModify(ticket, NormalizeDouble(OrderOpenPrice(), (int)MarketInfo(symbol,MODE_DIGITS)), NormalizeDouble(SL, Digits()), NormalizeDouble(TP, Digits()), OrderExpiration(), CLR_NONE);
      if(!success)
        {
         err = GetLastError();
         myAlert("print", "OrderModify error #"+IntegerToString(err)+" "+ErrorDescription(err));
         Sleep(OrderWait*1000);
        }
      retries++;
     }
   if(!success)
     {
      myAlert("error", "OrderModify failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err));
      return(-1);
     }
   string alertstr = "Order modified: ticket="+IntegerToString(ticket);
   if(!CompareDoubles(SL, 0))
      alertstr = alertstr+" SL="+DoubleToString(SL);
   if(!CompareDoubles(TP, 0))
      alertstr = alertstr+" TP="+DoubleToString(TP);
   myAlert("modify", alertstr);
   return(0);
  }
//--- End of custom functions ----------------------------------------

//timeInterval control
bool inTimeInterval(datetime t, int From_Hour, int From_Min, int To_Hour, int To_Min)
  {
   string TOD = TimeToString(t, TIME_MINUTES);
   string TOD_From = StringFormat("%02d", From_Hour)+":"+StringFormat("%02d", From_Min);
   string TOD_To = StringFormat("%02d", To_Hour)+":"+StringFormat("%02d", To_Min);
   return((StringCompare(TOD, TOD_From) >= 0 && StringCompare(TOD, TOD_To) <= 0)
          || (StringCompare(TOD_From, TOD_To) > 0
              && ((StringCompare(TOD, TOD_From) >= 0 && StringCompare(TOD, "23:59") <= 0)
                  || (StringCompare(TOD, "00:00") >= 0 && StringCompare(TOD, TOD_To) <= 0))));
  }

//+------------------------------------------------------------------+
//|                 Check Demo Period                                |
//+------------------------------------------------------------------+
bool CheckDemoPeriod(int day,int month,int year)
  {
   if(


      (TimeDay(TimeCurrent())>=day && TimeMonth(TimeCurrent())==month && TimeYear(TimeCurrent())==year) ||
      (TimeMonth(TimeCurrent())>month && TimeYear(TimeCurrent())==year) ||
      (TimeYear(TimeCurrent())>year)
   )
     {
      Print("@TradeExpert: EA"+EnumToString(LicenseMode)+" version expired..!");
      MessageBox("TradeExpert EA "+EnumToString(LicenseMode)+" version expired..!|Contact Seller: NGUEMECHIEU@LIVE.COM","Error:");
      //  EABlocked=true;
      return false;
     }
   else
      return(true);

  }












//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void createFibo()
  {
   int bar = WindowFirstVisibleBar();

   int shiftLowest  = iLowest(Symbol(), 0, MODE_LOW, bar - 1, 1);
   int shiftHighest = iHighest(Symbol(), 0, MODE_HIGH, bar - 1, 1);

   current_low=iLow(Symbol(),PERIOD_CURRENT,shiftLowest);
   current_high=iHigh(Symbol(),PERIOD_CURRENT,shiftHighest);
   price_delta=current_high-current_low;

   bool   isDownTrend = shiftHighest > shiftLowest;
   string fiboObjectId1 = headerString + "1";
   string fiboObjectHigh = headerString + "High";
   string fiboObjectLow = headerString + "Low";
   string unretracedZoneObject = headerString + "UnretracedZone";
   int shiftMostRetraced;

   if(isDownTrend == true)
     {

      ObjectCreate(fiboObjectId1, OBJ_FIBO,0, Time[shiftHighest], High[shiftHighest], Time[shiftLowest], Low[shiftLowest]);
      ObjectSet(fiboObjectId1, OBJPROP_LEVELWIDTH, fiboWidth);
      ObjectSet(fiboObjectId1, OBJPROP_LEVELSTYLE, fiboStyle);

      if(showUnretracedZone == true)
        {
         if(shiftLowest > 0)
           {
            shiftMostRetraced = iHighest(NULL, 0, MODE_HIGH, shiftLowest - 1, 0);
            ObjectCreate(unretracedZoneObject, OBJ_RECTANGLE, 0, Time[shiftMostRetraced], High[shiftHighest], Time[0], High[shiftMostRetraced]);
            ObjectSet(unretracedZoneObject, OBJPROP_COLOR, unretracedZoneColor);
           }
        }
     }

   else
     {

      ObjectCreate(fiboObjectId1, OBJ_FIBO, 0, Time[shiftLowest], Low[shiftLowest], Time[shiftHighest], High[shiftHighest]);
      ObjectSet(fiboObjectId1, OBJPROP_LEVELWIDTH, fiboWidth);
      ObjectSet(fiboObjectId1, OBJPROP_LEVELSTYLE, fiboStyle);
      if(showUnretracedZone == true)
        {
         if(shiftHighest > 0)
           {
            shiftMostRetraced = iLowest(NULL, 0, MODE_LOW, shiftHighest - 1, 0);
            ObjectCreate(unretracedZoneObject, OBJ_RECTANGLE, 0, Time[shiftMostRetraced], Low[shiftLowest], Time[0], Low[shiftMostRetraced]);
            ObjectSet(unretracedZoneObject, OBJPROP_COLOR, unretracedZoneColor);
           }
        }


     }
//__________________________________________________________________________________________________________________________________________________
//
   ObjectSet(fiboObjectId1, OBJPROP_LEVELCOLOR, fiboColor);
   ObjectSet(fiboObjectId1, OBJPROP_LEVELSTYLE, fiboStyle);
   ObjectSet(fiboObjectId1, OBJPROP_LEVELWIDTH, fiboWidth);
   ObjectSet(fiboObjectId1, OBJPROP_FIBOLEVELS, 11);

   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 0, FIBO_LEVEL_0);
   ObjectSetFiboDescription(fiboObjectId1, 0, DoubleToString(FIBO_LEVEL_0*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 1, FIBO_LEVEL_1);
   ObjectSetFiboDescription(fiboObjectId1, 1, DoubleToString(FIBO_LEVEL_1*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 2, FIBO_LEVEL_2);
   ObjectSetFiboDescription(fiboObjectId1, 2, DoubleToString(FIBO_LEVEL_2*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 3, FIBO_LEVEL_3);
   ObjectSetFiboDescription(fiboObjectId1, 3, DoubleToString(FIBO_LEVEL_3*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 4, FIBO_LEVEL_4);
   ObjectSetFiboDescription(fiboObjectId1, 4, DoubleToString(FIBO_LEVEL_4*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 5, FIBO_LEVEL_5);
   ObjectSetFiboDescription(fiboObjectId1, 5, DoubleToString(FIBO_LEVEL_5*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 6, FIBO_LEVEL_6);
   ObjectSetFiboDescription(fiboObjectId1, 6, DoubleToString(FIBO_LEVEL_6*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 7, FIBO_LEVEL_7);
   ObjectSetFiboDescription(fiboObjectId1, 7, DoubleToString(FIBO_LEVEL_7*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 8, FIBO_LEVEL_8);
   ObjectSetFiboDescription(fiboObjectId1, 8, DoubleToString(FIBO_LEVEL_8*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 9, FIBO_LEVEL_9);
   ObjectSetFiboDescription(fiboObjectId1, 9, DoubleToString(FIBO_LEVEL_9*100,1)+"  - %$");
   ObjectSet(fiboObjectId1, OBJPROP_FIRSTLEVEL + 10,FIBO_LEVEL_10);
   ObjectSetFiboDescription(fiboObjectId1, 10, DoubleToString(FIBO_LEVEL_10*100,1)+"  - %$");

   if(previous_trend!=isDownTrend)
      RESET_ALARMS();

   previous_trend=isDownTrend;
//__________________________________________________________________________________________________________________________________________________
//
// FIBO MESSAGES ON LEVEL CROSSING UP
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_1*price_delta&&alarm_fibo_level_1==false&&ALERT_ACTIVE_FIBO_LEVEL_1==true&&isDownTrend==false)
     {
      alarm_fibo_level_1=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(SymbolInfoDouble(symbol,SYMBOL_BID),5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(SymbolInfoDouble(symbol,SYMBOL_BID),5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(SymbolInfoDouble(symbol,SYMBOL_BID),5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_2*price_delta&&alarm_fibo_level_2==false&&ALERT_ACTIVE_FIBO_LEVEL_2==true&&isDownTrend==false)
     {
      alarm_fibo_level_2=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(SymbolInfoDouble(symbol,SYMBOL_BID),5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(SymbolInfoDouble(symbol,SYMBOL_BID),5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(SymbolInfoDouble(symbol,SYMBOL_BID),5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(SymbolInfoDouble(symbol,SYMBOL_BID),5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_3*price_delta&&alarm_fibo_level_3==false&&ALERT_ACTIVE_FIBO_LEVEL_3==true&&isDownTrend==false)
     {
      alarm_fibo_level_3=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_4*price_delta&&alarm_fibo_level_4==false&&ALERT_ACTIVE_FIBO_LEVEL_4==true&&isDownTrend==false)
     {
      alarm_fibo_level_4=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_5*price_delta&&alarm_fibo_level_5==false&&ALERT_ACTIVE_FIBO_LEVEL_5==true&&isDownTrend==false)
     {
      alarm_fibo_level_5=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_6*price_delta&&alarm_fibo_level_6==false&&ALERT_ACTIVE_FIBO_LEVEL_6==true&&isDownTrend==false)
     {
      alarm_fibo_level_6=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_7*price_delta&&alarm_fibo_level_7==false&&ALERT_ACTIVE_FIBO_LEVEL_7==true&&isDownTrend==false)
     {
      alarm_fibo_level_7=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_8*price_delta&&alarm_fibo_level_8==false&&ALERT_ACTIVE_FIBO_LEVEL_8==true&&isDownTrend==false)
     {
      alarm_fibo_level_8=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_9*price_delta&&alarm_fibo_level_9==false&&ALERT_ACTIVE_FIBO_LEVEL_9==true&&isDownTrend==false)
     {
      alarm_fibo_level_9=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)<=current_high-FIBO_LEVEL_10*price_delta&&alarm_fibo_level_10==false&&ALERT_ACTIVE_FIBO_LEVEL_10==true&&isDownTrend==false)
     {
      alarm_fibo_level_10=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
// FIBO MESSAGES ON LEVEL CROSSING DOWN
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_1*price_delta&&alarm_fibo_level_1==false&&ALERT_ACTIVE_FIBO_LEVEL_1==true&&isDownTrend==true)
     {
      alarm_fibo_level_1=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_1,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_2*price_delta&&alarm_fibo_level_2==false&&ALERT_ACTIVE_FIBO_LEVEL_2==true&&isDownTrend==true)
     {
      alarm_fibo_level_2=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_2,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_3*price_delta&&alarm_fibo_level_3==false&&ALERT_ACTIVE_FIBO_LEVEL_3==true&&isDownTrend==true)
     {
      alarm_fibo_level_3=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_3,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_4*price_delta&&alarm_fibo_level_4==false&&ALERT_ACTIVE_FIBO_LEVEL_4==true&&isDownTrend==true)
     {
      alarm_fibo_level_4=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_4,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_5*price_delta&&alarm_fibo_level_5==false&&ALERT_ACTIVE_FIBO_LEVEL_5==true&&isDownTrend==true)
     {
      alarm_fibo_level_5=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_5,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_6*price_delta&&alarm_fibo_level_6==false&&ALERT_ACTIVE_FIBO_LEVEL_6==true&&isDownTrend==true)
     {
      alarm_fibo_level_6=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_6,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_7*price_delta&&alarm_fibo_level_7==false&&ALERT_ACTIVE_FIBO_LEVEL_7==true&&isDownTrend==true)
     {
      alarm_fibo_level_7=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_7,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_8*price_delta&&alarm_fibo_level_8==false&&ALERT_ACTIVE_FIBO_LEVEL_8==true&&isDownTrend==true)
     {
      alarm_fibo_level_8=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_8,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_9*price_delta&&alarm_fibo_level_9==false&&ALERT_ACTIVE_FIBO_LEVEL_9==true&&isDownTrend==true)
     {
      alarm_fibo_level_9=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_9,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
   if(SymbolInfoDouble(symbol,SYMBOL_BID)>=current_low+FIBO_LEVEL_10*price_delta&&alarm_fibo_level_10==false&&ALERT_ACTIVE_FIBO_LEVEL_10==true&&isDownTrend==true)
     {
      alarm_fibo_level_10=true;

      if(ALERT_MODE==E_MAIL_AND_MOBILE)
        {
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));

         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
        }

      if(ALERT_MODE==E_MAIL)
         SendMail("FIBO MT4 NOTIFICATION",Symbol()+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
      if(ALERT_MODE==MOBILE)
         SendNotification(symbol+" "+TimeToString(TimeCurrent())+" "+"CROSSING FIBO LEVEL "+" "+DoubleToString(100*FIBO_LEVEL_10,1)+" "+" PRICE "+" "+DoubleToStr(Bid,5));
     }
//__________________________________________________________________________________________________________________________________________________
//
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TrendlinePriceUpper(int shift) //returns current price on the highest horizontal line or trendline found in the chart
  {
   int obj_total = ObjectsTotal();
   double maxprice = -1;
   for(int i = obj_total - 1; i >= 0; i--)
     {
      string name = ObjectName(i);
      double price;
      if(ObjectType(name) == OBJ_HLINE && StringFind(name, "#", 0) < 0
         && (price = ObjectGet(name, OBJPROP_PRICE1)) > maxprice
         && price > 0)
         maxprice = price;
      else
         if(ObjectType(name) == OBJ_TREND && StringFind(name, "#", 0) < 0
            && (price = ObjectGetValueByShift(name, shift)) > maxprice
            && price > 0)
            maxprice = price;
     }
   return(maxprice); //not found => -1
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double TrendlinePriceLower(int shift) //returns current price on the lowest horizontal line or trendline found in the chart
  {
   int obj_total = ObjectsTotal();
   double minprice = MathPow(10, 308);
   for(int i = obj_total - 1; i >= 0; i--)
     {
      string name = ObjectName(i);
      double price;
      if(ObjectType(name) == OBJ_HLINE && StringFind(name, "#", 0) < 0
         && (price = ObjectGet(name, OBJPROP_PRICE1)) < minprice
         && price > 0)
         minprice = price;
      else
         if(ObjectType(name) == OBJ_TREND && StringFind(name, "#", 0) < 0
            && (price = ObjectGetValueByShift(name, shift)) < minprice
            && price > 0)
            minprice = price;
     }
   if(minprice > MathPow(10, 307))
      minprice = -1; //not found => -1
   return(minprice);
  }








//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawFiboSimpleSell(string fiboName,datetime firstTime,double firstPrice,datetime secondTime,double secondPrice)
  {
   int HighestCandle=iHighest(Symbol(),Period(),MODE_OPEN,30,0);
   int LowestCandle=iLowest(Symbol(),Period(),MODE_CLOSE,1,0);

   ObjectDelete("TS261FiboBuy");
   ObjectDelete("TS261FiboSell");


   ObjectCreate(fiboName,OBJ_FIBO,0,Time[0],Low[LowestCandle],Time[30],High[HighestCandle]);
   ObjectSet(fiboName,OBJPROP_COLOR,Red);
   ObjectSet(fiboName,OBJPROP_BACK,true);
   ObjectSet(fiboName,OBJPROP_WIDTH,3);
   ObjectSet(fiboName,OBJPROP_FIBOLEVELS,25);
   ObjectSet(fiboName,OBJPROP_LEVELCOLOR,Red);
   ObjectSet(fiboName,OBJPROP_LEVELWIDTH,3);
//---

   ObjectSet(fiboName,OBJPROP_FIRSTLEVEL+0,-3.236);
   ObjectSetFiboDescription(fiboName,0,"SL 3= %$");
   ObjectSet(fiboName,OBJPROP_FIRSTLEVEL+1,-1.618);
   ObjectSetFiboDescription(fiboName,1,"SL 2= %$");
   ObjectSet(fiboName,OBJPROP_FIRSTLEVEL+2,-0.618);
   ObjectSetFiboDescription(fiboName,2,"SL 1= %$");
   ObjectSet(fiboName,OBJPROP_FIRSTLEVEL+3,0.000);
   ObjectSetFiboDescription(fiboName,3,"Highest Shadow= %$");
   ObjectSet(fiboName,OBJPROP_FIRSTLEVEL+4,1.000);
   ObjectSetFiboDescription(fiboName,4,"Entry= %$");
   ObjectSet(fiboName,OBJPROP_FIRSTLEVEL+5,1.618);
   ObjectSetFiboDescription(fiboName,5,"TP 1= %$");
   ObjectSet(fiboName,OBJPROP_FIRSTLEVEL+6,2.618);
   ObjectSetFiboDescription(fiboName,6,"TP 2= %$");
   ObjectSet(fiboName,OBJPROP_FIRSTLEVEL+7,4.236);
   ObjectSetFiboDescription(fiboName,7,"TP 3= %$");
//----
   ObjectSet(fiboName,OBJPROP_RAY,false);
   ObjectSet(fiboName,OBJPROP_RAY_RIGHT,false);



  }



string AccountMode() // function: to known account trade mode
   {
//----
//--- Demo, Contest or Real account 
   ENUM_ACCOUNT_TRADE_MODE account_type=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE);
 //---
   string trade_mode;
   //--
   switch(account_type) 
     { 
      case  ACCOUNT_TRADE_MODE_DEMO: 
         trade_mode="Demo"; 
         break; 
      case  ACCOUNT_TRADE_MODE_CONTEST: 
         trade_mode="Contest"; 
         break; 
      default: 
         trade_mode="Real"; 
         break; 
     }
   //--
   return(trade_mode);
//----
   } //-end AccountMode()
//---------//

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void RemoveAllObjects()
  {
   for(int i = ObjectsTotal() - 1; i >= 0; i--)
     {
      if(StringFind(ObjectName(i),"EA-",0) > -1)
         ObjectDelete(ObjectName(i));
     }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DrawLine(string objname, double price, int count, int start_index) //creates or modifies existing object if necessary
  {
   if((price < 0) && ObjectFind(objname) >= 0)
     {
      ObjectDelete(objname);
     }
   else
      if(ObjectFind(objname) >= 0 && ObjectType(objname) == OBJ_TREND)
        {
         ObjectSet(objname, OBJPROP_TIME1, Time[start_index]);
         ObjectSet(objname, OBJPROP_PRICE1, price);
         ObjectSet(objname, OBJPROP_TIME2, Time[start_index+count-1]);
         ObjectSet(objname, OBJPROP_PRICE2, price);
        }
      else
        {
         ObjectCreate(objname, OBJ_TREND, 0, Time[start_index], price, Time[start_index+count-1], price);
         ObjectSet(objname, OBJPROP_RAY, false);
         ObjectSet(objname, OBJPROP_COLOR, C'0x00,0x00,0xFF');
         ObjectSet(objname, OBJPROP_STYLE, STYLE_SOLID);
         ObjectSet(objname, OBJPROP_WIDTH, 2);
        }
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RESET_ALARMS()
  {
//fibo alarm
   alarm_fibo_level_1=false;
   alarm_fibo_level_2=false;
   alarm_fibo_level_3=false;
   alarm_fibo_level_4=false;
   alarm_fibo_level_5=false;
   alarm_fibo_level_6=false;
   alarm_fibo_level_7=false;
   alarm_fibo_level_8=false;
   alarm_fibo_level_9=false;
   alarm_fibo_level_10=false;
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void myOrderDelete(int type, string ordername) //delete pending orders of "type"
  {
   if(!IsTradeAllowed())
      return;
   bool success = false;
   int err = 0;
   string ordername_ = ordername;
   if(ordername != "")
      ordername_ = "("+ordername+")";
   int total = OrdersTotal();
   int orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy())
         Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != symbol || OrderType() != type)
         continue;
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = (int)OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(!OrderSelect(orderList[i][1], SELECT_BY_TICKET, MODE_TRADES))
         continue;
      while(IsTradeContextBusy())
         Sleep(100);
      RefreshRates();
      success = OrderDelete(OrderTicket());
      if(!success)
        {
         err = GetLastError();
         myAlert("error", "OrderDelete"+ordername_+" failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
        }
     }
   string typestr[6] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop"};
   if(success)
      myAlert("order", "Orders deleted"+ordername_+": "+typestr[type]+" "+symbol+" Magic #"+IntegerToString(MagicNumber));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Support(int time_interval, bool fixed_tod, int hh, int mm, bool draw, int shift)
  {
   int start_index = shift;
   int count = time_interval / 60 / Period();
   if(fixed_tod)
     {
      datetime start_time;
      if(shift == 0)
         start_time = TimeCurrent();
      else
         start_time = Time[shift-1];
      datetime dt = StringToTime(StringConcatenate(TimeToString(start_time, TIME_DATE)," ",hh,":",mm)); //closest time hh:mm
      if(dt > start_time)
         dt -= 86400; //go 24 hours back
      int dt_index = iBarShift(NULL, 0, dt, true);
      datetime dt2 = dt;
      while(dt_index < 0 && dt > Time[Bars-1-count]) //bar not found => look a few days back
        {
         dt -= 86400; //go 24 hours back
         dt_index = iBarShift(NULL, 0, dt, true);
        }
      if(dt_index < 0)  //still not found => find nearest bar
         dt_index = iBarShift(NULL, 0, dt2, false);
      start_index = dt_index + 1; //bar after S/R opens at dt
     }
   double ret = Low[iLowest(NULL, 0, MODE_LOW, count, start_index)];
   if(draw)
      DrawLine("Support", ret, count, start_index);
   return(ret);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckTradingTime()
  {
   int min  = TimeMinute(TimeCurrent());
   int hour = TimeHour(TimeCurrent());

// check if we can trade from 00:00 - 24:00
   if(Start_Hour == 0 && Finish_Hour == 24)
     {
      if(Start_Minute==0 && Finish_Minute==0)
        {
         // yes then return true
         return true;
        }
     }

   if(Start_Hour > Finish_Hour)
     {
      return(true);
     }

// suppose we're allowed to trade from 14:15 - 19:30

// 1) check if hour is < 14 or hour > 19
   if(hour < Start_Hour || hour > Finish_Hour)
     {
      // if so then we are not allowed to trade
      return false;
     }

// if hour is 14, then check if minute < 15
   if(hour == Start_Hour && min < Start_Minute)
     {
      // if so then we are not allowed to trade
      return false;
     }

// if hour is 19, then check  minute > 30
   if(hour == Finish_Hour && min > Finish_Minute)
     {
      // if so then we are not allowed to trade
      return false;
     }
   return true;
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string  TradeScheduleSymbol(int symbolindex, Answer selectByBasket)  //execute trade base on schedule symbols
  {
   if(selectByBasket==Yes)
     {



      int schedulselect=0;
      if(TimeCurrent()<start1 &&TimeCurrent()<stop1)
        {

         schedulselect=1;

        }
      else
         if(TimeCurrent()<start2 &&TimeCurrent()<stop2)
           {


            schedulselect=2;

           }
         else
            if(TimeCurrent()<start3 &&TimeCurrent()<stop3)
              {

               schedulselect=3;
              }




      if(schedulselect==1&&symbolList1!=NULL) //time interval 1
        {
         string symbolList11[];
         string _split=symbolList1;

         _u_sep=StringGetCharacter(_sep,0);
         int Per_k=StringSplit(_split,_u_sep,symbolList11);

         //--- Set the number of symbols in SymbolArraySize
         NumOfSymbols = ArraySize(symbolList11);


         return symbolList11[symbolindex];

        }
      else
         if(schedulselect==2&&symbolList2!=NULL) //time interval 2
           {
            string symbolList22[];

            string _split=symbolList2;

            _u_sep=StringGetCharacter(_sep,0);
            int Per_k=StringSplit(_split,_u_sep,symbolList22);

            //--- Set the number of symbols in SymbolArraySize
            NumOfSymbols = ArraySize(symbolList22);


            return symbolList22[symbolindex];
           }
         else
            if(schedulselect==3&&symbolList3!=NULL) //time interval 3
              {
               string symbolList33[];
               string _split=symbolList3;

               _u_sep=StringGetCharacter(_sep,0);
               int Per_k=StringSplit(_split,_u_sep,symbolList33);

               //--- Set the number of symbols in SymbolArraySize
               NumOfSymbols = ArraySize(symbolList33);


               return symbolList33[symbolindex];

              }

     }

   else
     {
      return mysymbolList[symbolindex];
      //Go back to normal Trading time

     };


   return "none";


  }
CMyBot smartBot;


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Resistance(int time_interval, bool fixed_tod, int hh, int mm, bool draw, int shift)
  {
   int start_index = shift;
   int count = time_interval / 60 / Period();
   if(fixed_tod)
     {
      datetime start_time;
      if(shift == 0)
         start_time = TimeCurrent();
      else
         start_time = Time[shift-1];
      datetime dt = StringToTime(StringConcatenate(TimeToString(start_time, TIME_DATE)," ",hh,":",mm)); //closest time hh:mm
      if(dt > start_time)
         dt -= 86400; //go 24 hours back
      int dt_index = iBarShift(NULL, 0, dt, true);
      datetime dt2 = dt;
      while(dt_index < 0 && dt > Time[Bars-1-count]) //bar not found => look a few days back
        {
         dt -= 86400; //go 24 hours back
         dt_index = iBarShift(NULL, 0, dt, true);
        }
      if(dt_index < 0)  //still not found => find nearest bar
         dt_index = iBarShift(NULL, 0, dt2, false);
      start_index = dt_index + 1; //bar after S/R opens at dt
     }
   double ret = High[iHighest(NULL, 0, MODE_HIGH, count, start_index)];
   if(draw)
      DrawLine("Resistance", ret, count, start_index);
   return(ret);
  }



//+------------------------------------------------------------------+
//|                   MyOrderModify                                  |
//+------------------------------------------------------------------+
int myOrderModify(int tickets, double SLs, double TPs) //modify SL and TP (absolute price), zero targets do not modify
  {
   if(symbol!=OrderSymbol())
      return 0;

   if(OrderTicket()==tickets &&OrderSymbol()==symbol)
     {

      ticket=tickets;
      TP=TPs;
      SL=SLs;
      if(!IsTradeAllowed())
         return(-1);
      bool success = false;
      int retries = 0;
      int err = 0;
      SL = NormalizeDouble(SL, vdigits);
      TP = NormalizeDouble(TP, vdigits);
      if(SL < 0)
         SL = 0;
      if(TP < 0)
         TP = 0;
      //prepare to select order
      while(IsTradeContextBusy())
         Sleep(100);
      if(!OrderSelect(ticket, SELECT_BY_TICKET, MODE_TRADES))
        {
         err = GetLastError();
         myAlert("error", "OrderSelect failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));

         if(UseBot)
            message="OrderSelect failed; error #"+IntegerToString(err)+" "+ErrorDescription(err);
         smartBot.SendMessage(InpChatID2,message);

         return(-1);
        }
      //prepare to modify order
      while(IsTradeContextBusy())
         Sleep(100);
      RefreshRates();
      //adjust targets for market order if too close to the market price
      double MinDistance = PriceTooClose *myPoint;
      if(OrderType() == OP_BUY)
        {
         if(NormalizeDouble(SL, vdigits) != 0 && ask - SL < MinDistance)
            SL = ask - MinDistance;
         if(NormalizeDouble(TP, vdigits) != 0 && TP - ask < MinDistance)
            TP = ask + MinDistance;
        }
      else
         if(OrderType() == OP_SELL)
           {
            if(NormalizeDouble(SL, vdigits) != 0 && SL - bid < MinDistance)
               SL = bid + MinDistance;
            if(NormalizeDouble(TP, vdigits) != 0 && bid - TP < MinDistance)
               TP = bid - MinDistance;
           }
      if(CompareDoubles(SL, 0))
         SL = OrderStopLoss(); //not to modify
      if(CompareDoubles(TP, 0))
         TP = OrderTakeProfit(); //not to modify
      if(CompareDoubles(SL, OrderStopLoss()) && CompareDoubles(TP, OrderTakeProfit()))
         return(0); //nothing to do
      while(!success && retries < OrderRetry+1)
        {
         success = OrderModify(OrderTicket(), NormalizeDouble(OrderOpenPrice(),vdigits), NormalizeDouble(SL, vdigits), NormalizeDouble(TP, vdigits), OrderExpiration(), CLR_NONE);
         if(!success)
           {
            err = GetLastError();
            myAlert("print", "OrderModify error #"+IntegerToString(err)+" "+ErrorDescription(err));
            if(UseBot)
               message="OrderModify error #"+IntegerToString(err)+" "+ErrorDescription(err);
            smartBot.SendMessage(InpChatID2,message);

            Sleep(OrderWait*1000);
           }
         retries++;
        }
      if(!success)
        {
         myAlert("error", "OrderModify failed "+IntegerToString(OrderRetry+1)+" times; error #"+IntegerToString(err)+" "+ErrorDescription(err));
         return(-1);
        }
      string alertstr = "Order modified: ticket="+IntegerToString(ticket);
      if(!CompareDoubles(SL, 0))
         alertstr = alertstr+" SL="+DoubleToString(SL);
      if(!CompareDoubles(TP, 0))
         alertstr = alertstr+" TP="+DoubleToString(TP);
      myAlert("modify", alertstr);
     }
   return(0);
  }



//+------------------------------------------------------------------+
//|                 M5tillM30                                                 |
//+------------------------------------------------------------------+
bool  M5tillM30Factor=false;
bool M5tillM30()
  {
   if(FILTER_SELECTION==B1)
      M5tillM30Factor=true;
   return M5tillM30Factor;
  }
//+------------------------------------------------------------------+
//|                  M5tillM30DOM                                                |
//+------------------------------------------------------------------+
bool  M5tillM30DOMFactor;
bool M5tillM30DOM()
  {
   if(FILTER_SELECTION==B3)
      M5tillM30DOMFactor=true;
   return M5tillM30DOMFactor;
  }
//+------------------------------------------------------------------+
//|              AutoTrade                                                    |
//+------------------------------------------------------------------+
bool AutoTrade()
  {
   if(inpTradeMode ==Automatic)
     {
      return true;
     };

   return false ;
  }
//+------------------------------------------------------------------+
//|            M5tillH1                                                      |
//+------------------------------------------------------------------+
bool M5tillH1Factor=false;
bool M5tillH1()
  {
   if(FILTER_SELECTION==B2)
      M5tillH1Factor=true;
   return M5tillH1Factor;
  }
//+------------------------------------------------------------------+
//|                    M5tillH1DOM                                              |
//+------------------------------------------------------------------+
bool M5tillH1DOM()
  {
   if(FILTER_SELECTION==B4)
     {
      return true;
     };
   return false;
  }
//+------------------------------------------------------------------+
//|                         LongTradingts261H1                                          |
//+------------------------------------------------------------------+
bool LongTradingts261H1=false;
bool   ShortTradingts261H1=true;
bool LongTradingts261M30=false;
bool   ShortTradingts261M30=true;
bool LongTradingts261M15=false;
bool   ShortTradingts261M15=true;

//+------------------------------------------------------------------+
//|                 HedgeTrade                                                 |
//+------------------------------------------------------------------+
bool HedgeTrade()
  {
   if(!Hedging)
      return false;


   return true;
  }
//+------------------------------------------------------------------+
//|                  CheckStochts261m5                                          |
//+------------------------------------------------------------------+
bool CheckStochts261m5(string symbols)
  {
   double ts261m5;
   double OverSold;
   double OverBought;

   for(int i=1; i>=0; i--)
     {
      ts261m5=iCustom(symbols,Period(),"1mfsto",5,5,5,3,i);
      OverSold=-45;
      OverBought=45;

      if(bar!=Bars)

        {

         if(ts261m5<OverSold)
           {
            LongTradingts261M5=true;
            ShortTradingts261M5=false;
           }
         if(ts261m5>OverBought)

           {
            LongTradingts261M5=false;
            ShortTradingts261M5=true;
           }
        }
     }

   return(false);
  }
//+------------------------------------------------------------------+
//|                     CheckStochts261m15                                              |
//+------------------------------------------------------------------+
bool CheckStochts261m15(string symbols)
  {
   double ts261m15;
   double OverSold;
   double OverBought;
   for(int i=0; i<NumOfSymbols; i++)
     {
      ts261m15=iCustom(symbols,Period(),"1mfsto",15,15,15,3,i);
      OverSold=-45;
      OverBought=45;

      if(bar!=Bars)
        {
         if(ts261m15<OverSold)
           {
            LongTradingts261M15=true;
            ShortTradingts261M15=false;
           }
         if(ts261m15>OverBought)

           {
            LongTradingts261M15=false;
            ShortTradingts261M15=true;
           }
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                     CheckStochts261m30                                             |
//+------------------------------------------------------------------+
string overboversellSymbol[2]= {};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool CheckStochts261m30(int symbolindex)
  {
   double ts261m30;
   double OverSold;
   double OverBought;
   for(int i=0; i<NumOfSymbols; i++)
     {
      ts261m30=iCustom(mysymbolList[symbolindex],Period(),"1mfsto",30,30,30,3,i);
      OverSold=-45;
      OverBought=45;
      overboversellSymbol[0]=mysymbolList[symbolindex];
      if(bar!=Bars)
        {
         if(ts261m30<OverSold)
           {
            LongTradingts261M30=true;
            ShortTradingts261M30=false;
           }
         if(ts261m30>OverBought)

           {
            LongTradingts261M30=false;
            ShortTradingts261M30=true;
           }
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                      CheckStochts261h1                                            |
//+------------------------------------------------------------------+
bool CheckStochts261h1()
  {
   double ts261h1;
   double OverSold;
   double OverBought;

   for(int i=0; i<NumOfSymbols; i++)
     {

      ts261h1=iCustom(symbol,Period(),"1mfsto",60,60,60,3,i);
      OverSold=-45;
      OverBought=45;

      if(bar!=Bars)
        {
         if(ts261h1<OverSold)
           {
            LongTradingts261H1=true;
            ShortTradingts261H1=false;
            overboversellSymbol[0]=symbol;
           }
         if(ts261h1>OverBought)

           {
            overboversellSymbol[0]=symbol;
            LongTradingts261H1=false;
            ShortTradingts261H1=true;
           }
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                       CheckRSIts261m5                                           |
//+------------------------------------------------------------------+
bool CheckRSIts261m5()
  {
   double ts261m5high;
   double ts261m5low;
   double OverSold;
   double OverBought;

   for(int i=0; i<NumOfSymbols; i++)
     {
      ts261m5high=iCustom(mysymbolList[i],Period(),"MTF_RSI",9,2,1,i);
      ts261m5low=iCustom(mysymbolList[i],Period(),"MTF_RSI",9,3,1,i);
      OverSold=20;
      OverBought=80;

      if(bar!=Bars)

        {

         if(ts261m5low<OverSold)
           {
            LongTradingts261M5=true;
            ShortTradingts261M5=false;
           }
         if(ts261m5high>OverBought)

           {
            LongTradingts261M5=false;
            ShortTradingts261M5=true;
           }
        }
     }
   return(false);
  }

bool  LongTradingts261M5=false;
bool  ShortTradingts261M5=true;
//+------------------------------------------------------------------+
//|                       CheckRSIts261m15                                           |
//+------------------------------------------------------------------+
bool CheckRSIts261m15()
  {
   double ts261m15high;
   double ts261m15low;
   double OverSold;
   double OverBought;
   for(int i=0; i<=NumOfSymbols; i++)
     {
      ts261m15high=iCustom(mysymbolList[i],Period(),"MTF_RSI",9,2,2,i);
      ts261m15low=iCustom(mysymbolList[i],Period(),"MTF_RSI",9,3,2,i);
      OverSold=20;
      OverBought=80;

      if(bar!=Bars)
        {
         if(ts261m15low<OverSold)
           {
            LongTradingts261M15=true;
            ShortTradingts261M15=false;
           }
         if(ts261m15high>OverBought)

           {
            LongTradingts261M15=false;
            ShortTradingts261M15=true;
           }
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                       CheckRSIts261m30                                            |
//+------------------------------------------------------------------+
bool CheckRSIts261m30()
  {
   double ts261m30high;
   double ts261m30low;
   double OverSold;
   double OverBought;
   for(int i=0; i<=NumOfSymbols; i++)
     {
      ts261m30high=iCustom(mysymbolList[i],Period(),"MTF_RSI",9,2,3,i);
      ts261m30low=iCustom(mysymbolList[i],Period(),"MTF_RSI",9,3,3,i);
      OverSold=20;
      OverBought=80;

      if(bar!=Bars)
        {
         if(ts261m30low<OverSold)
           {
            LongTradingts261M30=true;
            ShortTradingts261M30=false;
           }
         if(ts261m30high>OverBought)

           {
            LongTradingts261M30=false;
            ShortTradingts261M30=true;
           }
        }
     }
   return(false);
  }
//+------------------------------------------------------------------+
//|                         CheckRSIts261h1                                          |
//+------------------------------------------------------------------+
bool CheckRSIts261h1()
  {
   double ts261h1high;
   double ts261h1low;
   double OverSold;
   double OverBought;

   for(int i=0; i<=0; i++)
     {

      ts261h1high=iCustom(mysymbolList[i],Period(),"MTF_RSI",9,2,4,i);
      ts261h1low=iCustom(mysymbolList[i],Period(),"MTF_RSI",9,3,4,i);
      OverSold=20;
      OverBought=80;

      if(bar!=Bars)
        {
         if(ts261h1low<OverSold)
           {
            LongTradingts261H1=true;
            ShortTradingts261H1=false;
           }
         if(ts261h1high>OverBought)

           {
            LongTradingts261H1=false;
            ShortTradingts261H1=true;
           }
        }
     }
   return(false);
  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double getRates(string selection, string symbols)   //v for digits m for point b for bid a for ask rates
  {
   if(selection=="v111")
      return MarketInfo(symbols,MODE_DIGITS);

   else
      if(selection=="p111")
         return NormalizeDouble(MarketInfo(symbols,MODE_POINT),vdigits);
      else

         if(selection=="b111")
            return  SymbolInfoDouble(symbols,SYMBOL_BID);
         else
            if(selection=="a111")
               return SymbolInfoDouble(symbols,SYMBOL_ASK);

            else
               return 0;

  };




//+------------------------------------------------------------------+
//|                  CopyRightlogo                                                |
//+------------------------------------------------------------------+
void CopyRightlogo()
  {

   ObjectCreate(ChartID(),"logo",OBJ_BITMAP_LABEL,0,Time[0],Ask);
   ObjectSetString(ChartID(),"logo",OBJPROP_BMPFILE,"Images");
   ObjectSetInteger(ChartID(),"logo",OBJPROP_CORNER,CORNER_LEFT_LOWER);
   ObjectSetInteger(ChartID(),"logo",OBJPROP_ANCHOR,CORNER_LEFT_LOWER);
   ObjectSetInteger(ChartID(),"logo",OBJPROP_BACK,true);
   ObjectSetInteger(ChartID(),"logo",OBJPROP_XDISTANCE,40);
   ObjectSetInteger(ChartID(),"logo",OBJPROP_YDISTANCE,0);

  }
//---------------------------------------------------

//+------------------------------------------------------------------+
//|                        Cross                                          |
//+------------------------------------------------------------------+
bool Cross(int i, bool condition) //returns true if "condition" is true and was false in the previous call
  {
   bool ret = condition && !crossed[i];
   crossed[i] = condition;
   return(ret);
  }

void CloseTradesAtPL(double PL) //close all trades if total P/L >= profit (positive) or total P/L <= loss (negative)
  {
   double totalPL = TotalOpenProfit(0);
   if((PL > 0 && totalPL >= PL) || (PL < 0 && totalPL <= PL))
     {
      myOrderClose(OP_BUY, 100, "");
      myOrderClose(OP_SELL, 100, "");
     }
  }



//+------------------------------------------------------------------+
//|                        ModifyTP                                           |
//+------------------------------------------------------------------+
void ModifyTP(int tipe, double TP_Mart, string Pair)
  {
   vdigits = (int)MarketInfo(Pair,MODE_DIGITS);
   for(int cnt = OrdersTotal(); cnt >= 0; cnt--)
     {
      int xx=OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
      if(OrderSymbol() == Pair && (OrderType()==tipe) && OrderMagicNumber()==MagicNumber)
        {
         if(NormalizeDouble(OrderTakeProfit(),vdigits)!=NormalizeDouble(TP_Mart,vdigits))
           {
            xx=OrderModify(OrderTicket(), OrderOpenPrice(), OrderStopLoss(), NormalizeDouble(TP_Mart,vdigits), 0, CLR_NONE);
           }
        }
     }
  }

//+------------------------------------------------------------------+
//|                         TotalOpenProfit                                         |
//+------------------------------------------------------------------+
double TotalOpenProfit(int direction)
  {
   double result1 = 0;
   int total = OrdersTotal();
   for(int i = 0; i < total; i++)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderSymbol() != symbol || OrderMagicNumber() != MagicNumber)
         continue;
      if((direction < 0 && OrderType() == OP_BUY) || (direction > 0 && OrderType() == OP_SELL))
         continue;
      result1 += OrderProfit();
     }
   return(result1);
  }



//+------------------------------------------------------------------+
//|                    myOrderClose                                               |
//+------------------------------------------------------------------+
void myOrderClose(int type, double volumepercent, string ordername) //close open orders for current symbol, magic number and "type" (OP_BUY or OP_SELL)
  {
   if(!IsTradeAllowed())
      return;
   if(type > 1)
     {
      myAlert("error", "Invalid type in myOrderClose");
      messages= "Invalid type in myOrderClose";
      smartBot.SendMessageToChannel(InpChannel,messages);
      return;
     }
   bool success = false;
   int err = 0;
   string ordername_ = ordername;
   if(ordername != "")
      ordername_ = "("+ordername+")";
   int total = OrdersTotal();
   int orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy())
         Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != symbol || OrderType() != type)
         continue;
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = (int)OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(!OrderSelect(orderList[i][1], SELECT_BY_TICKET, MODE_TRADES))
         continue;
      while(IsTradeContextBusy())
         Sleep(100);
      RefreshRates();
      double price = (type == OP_SELL) ? SymbolInfoDouble(symbol,SYMBOL_ASK) : SymbolInfoDouble(symbol,SYMBOL_BID);
      double volume = OrderLots()*volumepercent * 1.0 / 100;
      if(volume== 0)
         continue;
      success = OrderClose(OrderTicket(), volume,price, MaxSlippage, clrWhite);
      if(!success)
        {
         err = GetLastError();
         myAlert("error", "OrderClose"+ordername_+" failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
         messages="OrderClose"+ordername_+" failed; error #"+IntegerToString(err)+" "+ErrorDescription(err);
         smartBot.SendMessageToChannel(InpChannel,messages);
        }
     }
   string typestr[6] = {"Buy", "Sell", "Buy Limit", "Sell Limit", "Buy Stop", "Sell Stop"};
   if(success)
      myAlert("order", "Orders closed"+ordername_+": "+typestr[type]+" "+symbol+" Magic #"+IntegerToString(MagicNumber));
   messages= "Orders closed"+ordername_+": "+typestr[type]+" "+symbol+" Magic #"+IntegerToString(MagicNumber);
   smartBot.SendMessageToChannel(InpChannel,messages);
  }

//+------------------------------------------------------------------+
//|                       TrailingStopTrail                                           |
//+------------------------------------------------------------------+
void TrailingStopTrail(int type, double TSs, double step, bool aboveBE, double aboveBEval,bool  trailingStopTrail) //set Stop Loss to "TS" if price is going your way with "step"
  {
   if(trailingStopTrail)
      return ;
   int total = OrdersTotal();
   double ts = TSs;
   step =step;
   for(int i = total-1; i >= 0; i--)
     {
      while(IsTradeContextBusy())
         Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != symbol || OrderType() != type)
         continue;
      RefreshRates();
      if((type == OP_BUY && !aboveBE) || ((SymbolInfoDouble(symbol,SYMBOL_BID) > OrderOpenPrice() + ts + aboveBEval) && (OrderStopLoss()<= 0))||(SymbolInfoDouble(symbol,SYMBOL_BID) > OrderStopLoss() + TS + step))
         myOrderModify(OrderTicket(),OrderStopLoss(),SymbolInfoDouble(symbol,SYMBOL_BID)- ts);
      else
         if((type == OP_SELL && !aboveBE)|| ((SymbolInfoDouble(symbol,SYMBOL_ASK) < OrderOpenPrice() - ts- aboveBEval) && OrderStopLoss() <= 0)|| (SymbolInfoDouble(symbol,SYMBOL_ASK) < OrderStopLoss() - TS - step))
            myOrderModify(OrderTicket(), OrderStopLoss(),SymbolInfoDouble(symbol,SYMBOL_ASK) +ts);
     }
  }

//---


//+------------------------------------------------------------------+
//|                     LicenseControl                                             |
//+------------------------------------------------------------------+
bool LicenseControl()
  {

   if(License=="none")
     {


      return true;

     }
   return false;

  }


//+------------------------------------------------------------------+
//|                             Riskpertrade                                      |
//+------------------------------------------------------------------+
double Riskpertrade(double sls) //Risk % per trade, SL = relative Stop Loss to calculate risk
  {
   SL=sls;
   double MaxLot = MarketInfo(symbol, MODE_MAXLOT);
   double MinLot = MarketInfo(symbol, MODE_MINLOT);
   double tickvalue = MarketInfo(symbol, MODE_TICKVALUE);
   double ticksize = MarketInfo(symbol, MODE_TICKSIZE);
   double lots = Risk_Percentage * 1.0 / 100 * AccountBalance() / (MaxSL / ticksize * tickvalue);
   if(lots > MaxLot)
      lots = MaxLot;
   if(lots < MinLot)
      lots = MinLot;
   return(lots);
  }


//+------------------------------------------------------------------+
//|                    MARTINGALE                                             |
//+------------------------------------------------------------------+
double Martingale_Size() //martingale / anti-martingale
  {
   double lots = MM_Martingale_Start;

   double MaxLot = MarketInfo(symbol, MODE_MAXLOT);
   double MinLot = MarketInfo(symbol, MODE_MINLOT);
   if(SelectLastHistoryTrade())
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
   if(ConsecutivePL(false, MM_Martingale_RestartLosses))
      lots = MM_Martingale_Start;
   if(ConsecutivePL(true, MM_Martingale_RestartProfits))
      lots = MM_Martingale_Start;
   if(lots > MaxLot)
      lots = MaxLot;
   if(lots < MinLot)
      lots = MinLot;
   return(lots);
  }
//+------------------------------------------------------------------+
//|                      POSITION SIZE                              |
//+------------------------------------------------------------------+
double PositionSize() //position sizing
  {
   double MaxLot = MarketInfo(symbol, MODE_MAXLOT);
   double MinLot = MarketInfo(symbol, MODE_MINLOT);
   double lots = AccountBalance() / Position_size;
   if(lots > MaxLot)
      lots = MaxLot;
   if(lots < MinLot)
      lots = MinLot;
   return(lots);
  }


//+------------------------------------------------------------------+
//|                       TradesCount                                           |
//+------------------------------------------------------------------+
int TradesCount(int type) //returns # of open trades for order type, current symbol and magic number
  {
   int result = 0;
   int total = OrdersTotal();
   for(int i = 0; i < total; i++)
     {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == false)
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != symbol || OrderType() != type)
         continue;
      result++;
     }
   return(result);
  }

//+------------------------------------------------------------------+
//|                  Select Last History Trade                       |
//+------------------------------------------------------------------+
bool SelectLastHistoryTrade()
  {
   int lastOrder = -1;
   int total = OrdersHistoryTotal();
   for(int i = total-1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
         continue;
      if(OrderSymbol() == symbol && OrderMagicNumber() == MagicNumber)
        {
         lastOrder = i;
         break;
        }
     }
   return(lastOrder >= 0);
  }

//+------------------------------------------------------------------+
//|                  BOProfit       for Binary Options               |
//+------------------------------------------------------------------+
double BOProfit(int tickets) //Binary Options profit
  {
   ticket=tickets;
   int total = OrdersHistoryTotal();
   for(int i = total-1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
         continue;
      if(StringSubstr(OrderComment(), 0, 2) == "BO" && StringFind(OrderComment(), "#"+IntegerToString(ticket)+" ") >= 0)
         return OrderProfit();
     }
   return 0;
  }

//+------------------------------------------------------------------+
//|                     Consecutive Profits and Losses               |
//+------------------------------------------------------------------+
bool ConsecutivePL(bool profits, int n)
  {
   int count=0;

   int total = OrdersHistoryTotal();
   for(int i = total-1; i >= 0; i--)
     {
      if(!OrderSelect(i, SELECT_BY_POS, MODE_HISTORY))
         continue;
      if(OrderSymbol() == symbol && OrderMagicNumber() == MagicNumber)
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
//|             TRADE SIZE                                           |
//+------------------------------------------------------------------+
double TradeSize(MONEYMANAGEMENT moneymanagement)
  {

   double MaxLot = MarketInfo(symbol, MODE_MAXLOT);
   double MinLot = MarketInfo(symbol, MODE_MINLOT);
   double TradingLots=0.03;
   switch(moneymanagement)
     {

      case FIXED_SIZE:
         return TradingLots= Fixed_size;
         break;
      case Risk_Percent_Per_Trade:
         return TradingLots=Riskpertrade(MaxSL);
         break;
      case POSITION_SIZE:
         return TradingLots= PositionSize();
         break;
      case MARTINGALE_OR_ANTI_MATINGALE:
         return TradingLots= Martingale_Size();
         break;
      case LOT_OPTIMIZE:
         TradingLots= LotsOptimized(symbol);
         if(TBa>0)
           {
            TradingLots=SubLots;
           };
         if(TS>0)
           {
            TradingLots=SubLots;
           };
         if(TradingLots>MaxLot)
           {
            return  TradingLots=MaxLot;
           }
         if(TradingLots<MinLot)
           {
            return TradingLots=MinLot;
           }

         break;
      default :
         TradingLots=Fixed_size;
         break;
     }
   return TradingLots;
  }

double StopLoss=MaxSL,TakeProfit=MaxTP;

//+------------------------------------------------------------------+
//|                   Delete Orders By Duration                      |
//+------------------------------------------------------------------+
void DeleteByDuration(int sec) //delete pending order after time since placing the order
  {
   if(!IsTradeAllowed())
      return;
   bool success = false;
   int err = 0;
   int total = OrdersTotal();
   int orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy())
         Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != symbol || OrderType() <= 1 || OrderOpenTime() + sec >mydate)
         continue;
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = (int)OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(!OrderSelect(orderList[i][1], SELECT_BY_TICKET, MODE_TRADES))
         continue;
      while(IsTradeContextBusy())
         Sleep(100);
      RefreshRates();
      success = OrderDelete(OrderTicket());
      if(!success)
        {
         err = GetLastError();
         myAlert("error", "OrderDelete failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
        }
     }
   if(success)
      messages= "Orders deleted by duration: "+symbol+" Magic #"+IntegerToString(MagicNumber);
   if(UseBot)
      smartBot.SendMessageToChannel(InpChannel,messages);
  }
bool init_status;


//+------------------------------------------------------------------+
//|                   Delete Orders By Distance                      |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DeleteByDistance(double distance) //delete pending order if price went too far from it
  {
   if(!IsTradeAllowed())
      return;
   bool success = false;
   int err = 0;
   int total = OrdersTotal();
   int orderList[][2];
   int orderCount = 0;
   int i;
   for(i = 0; i < total; i++)
     {
      while(IsTradeContextBusy())
         Sleep(100);
      if(!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
         continue;
      if(OrderMagicNumber() != MagicNumber || OrderSymbol() != symbol || OrderType() <= 1)
         continue;
      orderCount++;
      ArrayResize(orderList, orderCount);
      orderList[orderCount - 1][0] = (int)OrderOpenTime();
      orderList[orderCount - 1][1] = OrderTicket();
     }
   if(orderCount > 0)
      ArraySort(orderList, WHOLE_ARRAY, 0, MODE_ASCEND);
   for(i = 0; i < orderCount; i++)
     {
      if(!OrderSelect(orderList[i][1], SELECT_BY_TICKET, MODE_TRADES))
         continue;
      while(IsTradeContextBusy())
         Sleep(100);
      RefreshRates();
      double price = (OrderType() % 2 == 1) ? NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK), (int)MarketInfo(symbol,MODE_DIGITS)) : NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),(int)MarketInfo(symbol,MODE_DIGITS));
      if(MathAbs(OrderOpenPrice() - price) <= distance)
         continue;
      success = OrderDelete(OrderTicket());
      if(!success)
        {
         err = GetLastError();
         myAlert("error", "OrderDelete failed; error #"+IntegerToString(err)+" "+ErrorDescription(err));
        }
     }


  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrderAuto(const string symbols, int op_type, double pip, double fVol, int i)
  {
   int buys  = 0;
   symbol=symbols;
   int sells = 0;

   switch(op_type)
     {
      case OP_BUY:
        {
         if(AccountEquity()>=inpReqEquity && (inpTradeStyle==LONG || inpTradeStyle==BOTH)&&(ttlbuy<=MaxLongTrades))
           {
            switch(Order_Type)
              {
               default:
                  break;
               case MARKET_ORDERS:
                 {
                  if(IsTesting() && (symbol != Symbol()))
                    {
                     //Print("Tester skip instant BUY " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
                    }
                  else
                    {
                     myOrderSend(OP_BUY,ask,fVol,inpComment);
                    }
                  break;
                 }
               case STOP_ORDERS:
                 {
                  if(IsTesting() && (symbol != Symbol()))
                    {
                     //Print("Tester skip stop BUY " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
                    }
                  else
                    {
                     double entry_distance = GetDistanceInPoints(symbol,OrderDistanceUnit,inpStopDis,pip,fVol);
                     double stop_distance  = GetDistanceInPoints(symbol,StopLossUnit,inpSL,pip,fVol);
                     double tp_distance    = GetDistanceInPoints(symbol,TakeProfitUnit,inpTP*(i+1),pip,fVol);
                     ticket = -1;
                     while(ticket<0)
                       {
                        ticket = OrderSend(symbol,OP_BUYSTOP,fVol,SymbolInfoDouble(symbol,SYMBOL_ASK)+(entry_distance*pip),5,(SymbolInfoDouble(symbol,SYMBOL_ASK)+(entry_distance*pip))-(stop_distance*pip),(SymbolInfoDouble(symbol,SYMBOL_ASK)+(entry_distance*pip))+((tp_distance*pip)),inpComment,MagicNumber,DeletePendingOrders ? (TimeCurrent()+(Period()*inpPendingBar*60)) : 0,clrBlue);
                        if(ticket<0)
                          {
                           Sleep(100);
                          }
                       }
                    }
                  break;
                 }
               case LIMIT_ORDERS:
                 {
                  if(IsTesting() && (symbol != Symbol()))
                    {
                     //Print("Tester skip limit BUY " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
                    }
                  else
                    {
                     double entry_distance = GetDistanceInPoints(symbol,OrderDistanceUnit,inpStopDis,pip,fVol);
                     double stop_distance  = GetDistanceInPoints(symbol,StopLossUnit,inpSL,pip,fVol);
                     double tp_distance    = GetDistanceInPoints(symbol,TakeProfitUnit,inpTP*(i+1),pip,fVol);
                     ticket = -1;
                     while(ticket<0)
                       {
                        ticket = OrderSend(symbol,OP_BUYLIMIT,fVol,SymbolInfoDouble(symbol,SYMBOL_ASK)-(entry_distance*pip),5,(SymbolInfoDouble(symbol,SYMBOL_ASK)-(entry_distance*pip))-(stop_distance*pip),(SymbolInfoDouble(symbol,SYMBOL_ASK)-(entry_distance*pip))+(tp_distance*pip),inpComment,MagicNumber,DeletePendingOrders ? (TimeCurrent()+(Period()*inpPendingBar*60)) : 0,clrBlue);
                        if(ticket<0)
                          {
                           Sleep(100);
                          }
                       }
                    }
                  break;
                 }
              }
           }

         break;
        }
      case OP_BUYLIMIT:
        {
         break;
        }
      case OP_BUYSTOP:
        {
         break;
        }
      case OP_SELL:
        {
         if(AccountEquity()>=inpReqEquity && (inpTradeStyle ==SHORT || inpTradeStyle ==BOTH)&&(ttlsell<=MaxShortTrades))
           {
            switch(Order_Type)
              {
               default:
                  break;
               case MARKET_ORDERS:
                 {
                  if(IsTesting() && (symbol != Symbol()))
                    {
                     //Print("Tester skip instant SELL " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
                    }
                  else
                    {
                     myOrderSend(OP_SELL,bid,fVol,inpComment);
                    }
                  break;
                 }
               case STOP_ORDERS:
                 {
                  if(IsTesting() && (symbol != Symbol()))
                    {
                     //Print("Tester skip stop SELL " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
                    }
                  else
                    {
                     double entry_distance = GetDistanceInPoints(symbol,OrderDistanceUnit,inpStopDis,pip,fVol);
                     double stop_distance  = GetDistanceInPoints(symbol,StopLossUnit,inpSL,pip,fVol);
                     double tp_distance    = GetDistanceInPoints(symbol,TakeProfitUnit,inpTP*(i+1),pip,fVol);
                     ticket = -1;
                     while(ticket<0)
                       {
                        ticket = OrderSend(symbol,ORDER_TYPE_SELL_STOP,fVol,SymbolInfoDouble(symbol,SYMBOL_BID)-(entry_distance*pip),5,(SymbolInfoDouble(symbol,SYMBOL_BID)-(entry_distance*pip))+(stop_distance*pip),SymbolInfoDouble(symbol,SYMBOL_BID)-(entry_distance*pip)-((tp_distance*pip)),inpComment,MagicNumber,DeletePendingOrders ? (TimeCurrent()+(Period()*inpPendingBar*60)):0,clrRed);
                        if(ticket<0)
                          {
                           Sleep(100);
                          }
                       }
                    }
                  break;
                 }
               case LIMIT_ORDERS:
                 {
                  if(IsTesting() && (symbol != Symbol()))
                    {
                     //Print("Tester skip limit SELL " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
                    }
                  else
                    {
                     double entry_distance = GetDistanceInPoints(symbol,OrderDistanceUnit,inpStopDis,pip,fVol);
                     double stop_distance  = GetDistanceInPoints(symbol,StopLossUnit,inpSL,pip,fVol);
                     double tp_distance    = GetDistanceInPoints(symbol,TakeProfitUnit,inpTP*(i+1),pip,fVol);
                     ticket = -1;
                     while(ticket<0)
                       {
                        ticket = OrderSend(symbol,ORDER_TYPE_SELL_LIMIT,fVol,SymbolInfoDouble(symbol,SYMBOL_BID)+(entry_distance*pip),5,(SymbolInfoDouble(symbol,SYMBOL_BID)+(entry_distance*pip))+(stop_distance*pip),(SymbolInfoDouble(symbol,SYMBOL_BID)+(entry_distance*pip))-((tp_distance*pip)),inpComment,MagicNumber,DeletePendingOrders ? (TimeCurrent()+(Period()*inpPendingBar*60)):0,clrRed);
                        if(ticket<0)
                          {
                           Sleep(100);
                          }
                       }
                    }
                  break;
                 }
              }
           }

         break;
        }
      case OP_SELLLIMIT:
        {
         break;
        }
      case OP_SELLSTOP:
        {
         break;
        }
     }

  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OpenOrderManual(const string symbolS, ENUM_ORDER_TYPE op_type, double pip, double fVol, int i)
  {
   symbol=symbolS;
   switch(op_type)
     {
      case OP_BUY:
        {
         if(AccountEquity()>=inpReqEquity && (inpTradeStyle== LONG||inpTradeStyle ==BOTH))
           {
            if(IsTesting() && (symbol != Symbol()))
              {
               //Print("Tester skip instant BUY " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
              }
            else
              {
               myOrderSend(OP_BUY,ask,fVol,inpComment);
              }
           }
         break;
        }
      case OP_BUYSTOP:
        {
         if(AccountEquity()>=inpReqEquity && (inpTradeStyle ==LONG || inpTradeStyle ==BOTH))
           {
            if(IsTesting() && (symbol != Symbol()))
              {
               //Print("Tester skip stop BUY " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
              }
            else
              {
               double entry_distance = GetDistanceInPoints(symbol,OrderDistanceUnit,inpStopDis,pip,fVol);
               double stop_distance  = GetDistanceInPoints(symbol,StopLossUnit,inpSL,pip,fVol);
               double tp_distance    = GetDistanceInPoints(symbol,TakeProfitUnit,inpTP*(i+1),pip,fVol);
               ticket= -1;
               while(ticket<0)
                 {
                  ticket = OrderSend(symbol,ORDER_TYPE_BUY_STOP,fVol,SymbolInfoDouble(symbol,SYMBOL_ASK)+(entry_distance*pip),5,(SymbolInfoDouble(symbol,SYMBOL_ASK)+(entry_distance*pip))-(stop_distance*pip),(SymbolInfoDouble(symbol,SYMBOL_ASK)+(entry_distance*pip))+((tp_distance*pip)),inpComment,MagicNumber,DeletePendingOrders ? (TimeCurrent()+(Period()*inpPendingBar*60)):0,clrBlue);
                  if(ticket<0)
                    {
                     Sleep(100);
                    }
                 }
              }
           }
         break;
        }
      case OP_BUYLIMIT:
        {
         if(AccountEquity()>=inpReqEquity && (inpTradeStyle ==LONG || inpTradeStyle ==BOTH))
           {
            if(IsTesting() && (symbol != Symbol()))
              {
               //Print("Tester skip limit BUY " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
              }
            else
              {
               double entry_distance = GetDistanceInPoints(symbol,OrderDistanceUnit,inpStopDis,pip,fVol);
               double stop_distance  = GetDistanceInPoints(symbol,StopLossUnit,inpSL,pip,fVol);
               double tp_distance    = GetDistanceInPoints(symbol,TakeProfitUnit,inpTP*(i+1),pip,fVol);
               ticket = -1;
               while(ticket<0)
                 {
                  ticket = OrderSend(symbol,ORDER_TYPE_BUY_LIMIT,fVol,SymbolInfoDouble(symbol,SYMBOL_ASK)-(entry_distance*pip),5,(SymbolInfoDouble(symbol,SYMBOL_ASK)-(entry_distance*pip))-(stop_distance*pip),(SymbolInfoDouble(symbol,SYMBOL_ASK)-(entry_distance*pip))+(tp_distance*pip),inpComment,MagicNumber,DeletePendingOrders ? (TimeCurrent()+(Period()*inpPendingBar*60)):0,clrBlue);
                  if(ticket<0)
                    {
                     Sleep(100);
                    }
                 }
              }
           }
         break;
        }
      case OP_SELL:
        {
         if(AccountEquity()>=inpReqEquity && (inpTradeStyle ==SHORT || inpTradeStyle ==BOTH))
           {
            if(IsTesting() && (symbol != Symbol()))
              {
               //Print("Tester skip instant SELL " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
              }
            else
              {
               myOrderSend(OP_SELL,bid,fVol,inpComment);
              }
           }
         break;
        }
      case OP_SELLSTOP:
        {
         if(AccountEquity()>=inpReqEquity && (inpTradeStyle ==SHORT ||inpTradeStyle ==BOTH))
           {
            if(IsTesting() && (symbol != Symbol()))
              {
               //Print("Tester skip stop SELL " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
              }
            else
              {
               double entry_distance = GetDistanceInPoints(symbol,OrderDistanceUnit,inpStopDis,pip,fVol);
               double stop_distance  = GetDistanceInPoints(symbol,StopLossUnit,inpSL,pip,fVol);
               double tp_distance    = GetDistanceInPoints(symbol,TakeProfitUnit,inpTP*(i+1),pip,fVol);
               ticket = -1;
               while(ticket<0)
                 {
                  ticket = OrderSend(symbol,ORDER_TYPE_SELL_STOP,fVol,SymbolInfoDouble(symbol,SYMBOL_BID)-(entry_distance*pip),5,(SymbolInfoDouble(symbol,SYMBOL_BID)-(entry_distance*pip))+(stop_distance*pip),SymbolInfoDouble(symbol,SYMBOL_BID)-(entry_distance*pip)-((tp_distance*pip)),inpComment,MagicNumber,DeletePendingOrders ? (TimeCurrent()+(Period()*inpPendingBar*60)):0,clrRed);
                  if(ticket<0)
                    {
                     Sleep(100);
                    }
                 }
              }
           }
         break;
        }
      case OP_SELLLIMIT:
        {
         if(AccountEquity()>=inpReqEquity && (inpTradeStyle ==SHORT || inpTradeStyle ==BOTH))
           {
            if(IsTesting() && (symbol != Symbol()))
              {
               //Print("Tester skip limit SELL " + symbol + ", lots:"+DoubleToString(fVol,2) + ", i:"+IntegerToString(i));
              }
            else
              {
               double entry_distance = GetDistanceInPoints(symbol,OrderDistanceUnit,inpStopDis,pip,fVol);
               double stop_distance  = GetDistanceInPoints(symbol,StopLossUnit,inpSL,pip,fVol);
               double tp_distance    = GetDistanceInPoints(symbol,TakeProfitUnit,inpTP*(i+1),pip,fVol);
               ticket = -1;
               while(ticket<0)
                 {
                  ticket = OrderSend(symbol,ORDER_TYPE_SELL_LIMIT,fVol,SymbolInfoDouble(symbol,SYMBOL_BID)+(entry_distance*pip),5,(SymbolInfoDouble(symbol,SYMBOL_BID)+(entry_distance*pip))+(stop_distance*pip),(SymbolInfoDouble(symbol,SYMBOL_BID)+(entry_distance*pip))-((tp_distance*pip)),inpComment,MagicNumber,DeletePendingOrders ? (TimeCurrent()+(Period()*inpPendingBar*60)):0,clrRed);
                  if(ticket<0)
                    {
                     Sleep(100);
                    }
                 }
              }
           }
         break;
        }
     }
  }
//+------------------------------------------------------------------+
//|   GetCustomInfo                                                  |
//+------------------------------------------------------------------+
void GetCustomInfo(CustomInfo &info,
                   const int _error_code,
                   const ENUM_LANGUAGES _lang)
  {


//--- show init error
   if(init_error!=0)
     {
      //--- show error on display

      GetCustomInfo(info,init_error,InpLanguage);

      //---
      comment.Clear();
      comment.SetText(0,StringFormat("%s v.%s","TradeExpert",IntegerToString(2.0)),      clrBlue);
      comment.SetText(1,info.text1, clrWhite);
      if(info.text2!="")
         comment.SetText(3,info.text2,clrWheat);
      comment.Show();

      return;
     }

//--- show web error
   if(run_mode==RUN_LIVE)
     {

      //--- check bot registration
      if(time_check<TimeLocal()-PeriodSeconds(PERIOD_H1))
        {
         time_check=TimeLocal();
         if(TerminalInfoInteger(TERMINAL_CONNECTED))
           {
            //---
            web_error=smartBot.GetMe();
            if(web_error!=0)
              {
               //---
               if(web_error==ERR_NOT_ACTIVE)
                 {
                  time_check=TimeCurrent()-PeriodSeconds(PERIOD_H1)+300;
                 }
               //---
               else
                 {
                  time_check=TimeCurrent()-PeriodSeconds(PERIOD_H1)+5;
                 }
              }
           }
         else
           {
            web_error=ERR_NOT_CONNECTED;
            time_check=0;
           }
        }

      //--- show error
      if(web_error!=0)
        {
         comment.Clear();
         comment.SetText(0,StringFormat("%s v.%s","TRADE_EXPERT",IntegerToString(1)),clrGold);

         if(
#ifdef __MQL4__ web_error==ERR_FUNCTION_NOT_CONFIRMED #endif
#ifdef __MQL5__ web_error==ERR_FUNCTION_NOT_ALLOWED #endif
         )
           {
            time_check=0;


            GetCustomInfo(info,web_error,InpLanguage);
            comment.SetText(1,info.text1,clrWhite);
            comment.SetText(2,info.text2, clrWheat);
           }
         else
            comment.SetText(1,GetErrorDescription(web_error,InpLanguage),clrWheat);

         comment.Show();
         return;
        }
     }


//---
   if(run_mode==RUN_LIVE)
     {
      comment.Clear();

      comment.SetText(1,StringFormat("%s: %s",(InpLanguage==LANGUAGE_EN)?"Bot Name":"Имя Бота",smartBot.Name()),clrGoldenrod);
      comment.SetText(2,StringFormat("%s: %d",(InpLanguage==LANGUAGE_EN)?"Chats":"Чаты",smartBot.ChatsTotal()),clrAqua);
      comment.Show();
     }

   switch(_error_code)
     {
#ifdef __MQL5__
      case ERR_FUNCTION_NOT_ALLOWED:
         info.text1 = (_lang==LANGUAGE_EN)?"The URL does not allowed for WebRequest":"Этого URL нет в списке для WebRequest.";
         info.text2 = TELEGRAM_BASE_URL;
         break;
#endif
#ifdef __MQL4__
      case ERR_FUNCTION_NOT_CONFIRMED:
         info.text1 = (_lang==LANGUAGE_EN)?"The URL does not allowed for WebRequest":"Этого URL нет в списке для WebRequest.";
         info.text2 = TELEGRAM_BASE_URL;
         break;
#endif

      case ERR_TOKEN_ISEMPTY:
         info.text1 = (_lang==LANGUAGE_EN)?"The 'Token' parameter is empty.":"Параметр 'Token' пуст.";
         info.text2 = (_lang==LANGUAGE_EN)?"Please fill this parameter.":"Пожалуйста задайте значение для этого параметра.";
         break;
     }
   message=info.text1;
   if(UseBot)
      smartBot.SendMessageToChannel(InpChannel,message);

  }




//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
   if(vdigits == 5 || vdigits == 3)
     {
      myPoint *= 10;
      MaxSlippage *= 10;
     }
//initialize LotDigits
   double LotStep = MarketInfo(symbol, MODE_LOTSTEP);
   if(NormalizeDouble(LotStep, 3) == round(LotStep))
     {
      LotDigits = 0;
     }
   else
      if(NormalizeDouble(10*LotStep, 3) == round(10*LotStep))
        {
         LotDigits = 1;
        }
      else
         if(NormalizeDouble(100*LotStep, 3) == round(100*LotStep))
           {
            LotDigits = 2;
           }
         else
           {
            LotDigits = 3;
           }

   if(!CheckDemoPeriod(12,2,2022))
      return INIT_FAILED;
   else

      ObjectsDeleteAll(0,-1,OBJ_LABEL);
   _opened_last_time = mydate ;
   _closed_last_time = mydate  ;
   sendOnce=mydate;
   startbalance = AccountBalance();
   starttime =Start_Hour;

   datetime start_= StrToTime(TimeToStr(mydate, TIME_DATE) + " 00:00");
   bool TARGET=true;
   ThisDayOfYear=DayOfYear();

   P1=DYp(iTime(symbol,PERIOD_D1,0));
   Wp1=DYp(iTime(symbol,PERIOD_W1,0));
   MNp1=DYp(iTime(symbol,PERIOD_MN1,0));
   if(UseBot)
     {



      //--- set timer

      switch(InpUpdateMode)
        {
         case UPDATE_FAST:
            timer_ms=1000;
            break;
         case UPDATE_NORMAL:
            timer_ms=2000;
            break;
         case UPDATE_SLOW:
            timer_ms=3000;
            break;
         default:
            timer_ms=3000;
            break;
        };

      smartBot.GetUpdates();
      //--- set language
      smartBot.Language(InpLanguage);

      //--- set token
      init_error=smartBot.Token(InpTocken);

      //--- set filter
      smartBot.UserNameFilter(InpUserNameFilter);

      //--- set templates
      smartBot.Templates(InpTemplates);



      smartBot.GetMe();


      if(mydate>=PrevTime &&EA_START_DAY<DayOfWeek())
        {

         message="\nWelcome to TradeExpert\nHere is "+smartBot.Name()+"\nToday date is "+(string)mydate + "\nI'm your trade assistant\n.Our final goal is to help you trade well..!";
         smartBot.SendMessageToChannel(InpChannel,message);
         smartBot.SendMessage(InpChatID,message,smartBot.ReplyKeyboardMarkup(KEYB_MAIN,FALSE,FALSE));

        }
      else
        {
         PrevTime=mydate;
        }

      smartBot.ChatsTotal();
      smartBot.m_symbol=symbol;


      smartBot.ChartColorSet();//set chart color
      smartBot.ForceReply();

     }

   string _split=mysymbol;

   _u_sep=StringGetCharacter(_sep,0);
   int Per_k=StringSplit(_split,_u_sep,mysymbolList);

//--- Set the number of symbols in SymbolArraySize
   NumOfSymbols = ArraySize(mysymbolList);
   timer_ms=3000;

   sendOnce=mydate;
   if(!LicenseControl())
     {
      MessageBox("Invalid LICENSE KEY!\nPlease contact support at nguemechieu@live.com for any assistance","License Control",1);

      messages="Invalid LICENSE KEY!\nPlease contact support at nguemechieu@live.com for any assistance";

      smartBot.SendMessage(InpChatID2,messages);

      return INIT_FAILED;
     }
//---

   EventSetMillisecondTimer(timer_ms);

   run_mode=GetRunMode();


//--- Initialization of indicators
   if(init_status == INIT_SUCCEEDED)
     {
      init_status = OnInitIndicators();
     }
//--- Initialization of trade structures per symbol
   if(init_status == INIT_SUCCEEDED)
     {
      ArrayResize(SymbolTrades,NumOfSymbols);
      for(int i=0; i<NumOfSymbols; i++)
        {
         SymbolTrades[i].symbol = TradeScheduleSymbol(i,InpSelectPairs_By_Basket_Schedule);
         ArrayResize(SymbolTrades[i].trades,0);
        }
      ArrayResize(ManualSignals,0);
     }
//---


   OnTimer();
   return init_status;

  }



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {


   if(!IsTesting())
     {
      ObjectsDeleteAll(ChartID(),OBJPFX);
     }
   if(reason==REASON_CLOSE ||
      reason==REASON_PROGRAM ||
      reason==REASON_PARAMETERS ||
      reason==REASON_REMOVE ||
      reason==REASON_RECOMPILE ||
      reason==REASON_ACCOUNT ||
      reason==REASON_INITFAILED)
     {
      time_check=0;
      comment.Destroy();
     }
//---

   ChartRedraw();
//--- destroy timer
   EventKillTimer();
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {


   HUD();
   HUD2();
   GUI();
   EA_name();
//---
   OnChartEventTesting();

   string _split=mysymbol;
   _sep=",";                                                 // A separator as a character
// The code of the separator character
   _u_sep=StringGetCharacter(_sep,0);
   int Per_k=StringSplit(_split,_u_sep,mysymbolList);

//--- Set the number of symbols in SymbolArraySize
   NumOfSymbols = ArraySize(mysymbolList);
//--- Set size of buy/sell state arrays
//--- Set the number of symbols in SymbolArraySize

//--- Set size of buy/sell state arrays
   ArrayResize(_isBuy,NumOfSymbols);
   ArrayResize(_isSell,NumOfSymbols);
   int jk=NumOfSymbols;
//-- SetXYAxis
   GetSetCoordinates();

//-- EnableEventMouseMove
   if(!IsTesting())
     {
      if(!ChartGetInteger(0,CHART_EVENT_MOUSE_MOVE))
         ChartEventMouseMoveSet(true);
     }
//--- Set the number of symbols in SymbolArraySize



   for(jk=0; jk<NumOfSymbols; jk++) //Looping trought each symbols
     {

      symbol=TradeScheduleSymbol(jk,InpSelectPairs_By_Basket_Schedule);

      myPoint=(int)getRates(p111,symbol);
      vdigits = (int)getRates(v111,symbol);
      bid=getRates(b111,symbol);
      ask= getRates(a111,symbol);
      CreateSymbolPanel(inpShowSymbolPanel);
      STRUCT_SIGNAL signals;
      if(CheckStochts261m30(jk))
        {
         overboversellSymbol[0]=mysymbolList[jk];
        };//overbought and oversold signal

      if(UseBot)
        {
         smartBot.ForceReply();
         smartBot.GetUpdates();
         string status2="Copyright © 2021, NOEL M NGUEMECHIEU" +"Bot name :"+smartBot.Name();
         ObjectCreate("M5", OBJ_LABEL, 0, 0, 0);
         ObjectSetText("M5",status2,10,"Arial",clrBlue);
         ObjectSet("M5", OBJPROP_CORNER, 2);
         ObjectSet("M5", OBJPROP_XDISTANCE, 0);
         ObjectSet("M5", OBJPROP_YDISTANCE, 0);

        }


      int cnt = 720;
      cur_day = 0;
      prev_day = 0;
      double rates_d1[2][6];
      //---- exit if period is greater than daily charts
      //---- Get new daily prices & calculate pivots
      cur_day  = TimeDay(Time[0] - (GMTshift*3600));
      yesterday_close = iClose(symbol,snrperiod,1);
      today_open = iOpen(symbol,snrperiod,0);
      yesterday_high = iHigh(symbol,snrperiod,1);//day_high;
      yesterday_low = iLow(symbol,snrperiod,1);//day_low;
      day_high = iHigh(symbol,snrperiod,1);
      day_low  = iLow(symbol,snrperiod,1);
      prev_day = cur_day;

      yesterday_high = MathMax(yesterday_high,day_high);
      yesterday_low = MathMin(yesterday_low,day_low);
      message="___Market Infos__\n"+symbol+"\nYesterday high :"+(string)yesterday_high+"\nYesterday low :"+(string)yesterday_low+"\nYesterdayClose : "+(string)yesterday_close+"\nToday Low :"+(string)+day_low+"\nTodayHigh :"+(string)iHigh(symbol,PERIOD_CURRENT,1)
              +"\nDifference%:" +(string)((yesterday_high-day_low)*(100))+"\n______>>Happy Trading<<________";
      if(EventSetMillisecondTimer(50000))
        {
         smartBot.SendMessageToChannel(InpChannel,message);
        }
      if(EventSetMillisecondTimer(50000))
        {
         smartBot.SendMessage(InpChatID,message);
        }

      //------ Pivot Points ------
      Rx = (yesterday_high - yesterday_low);
      Px = (yesterday_high + yesterday_low + yesterday_close)/3; //Pivot
      R1x = Px + (Rx * 0.38);
      R2x = Px + (Rx * 0.62);
      R3x = Px + (Rx * 0.99);
      S1x = Px - (Rx * 0.38);
      S2x = Px - (Rx * 0.62);
      S3x = Px - (Rx * 0.99);
      //++++++++++++++++++++++++++++++++++++++++
      if(bid > R3x)
        {
         R3x = 0;
         S3x = R2x;
        }
      if(bid > R2x && bid < R3x)
        {
         R3x = 0;
         S3x = R1x;
        }
      if(bid > R1x && bid < R2x)
        {
         R3x = R3x;
         S3x = Px;
        }
      if(bid > Px && bid < R1x)
        {
         R3x = R2x;
         S3x = S1x;
        }
      if(bid > S1x && bid < Px)
        {
         R3x = R1x;
         S3x = S2x;
        }
      if(bid > S2x && bid < S1x)
        {
         R3x = Px;
         S3x = S3x;
        }
      if(bid > S3x && bid < S2x)
        {
         R3x = S1x;
         S3x = 0;
        }
      if(bid < S3x)
        {
         R3x = S2x;
         S3x = 0;
        }


      if(IsTesting())
        {
         OnTester();
        }

      datanews();

      createFibo();
      snrfibo(showfibo);

      //News control

      //News control
      if(CloseBeforNews)
        {
         NewsFilter = True;
        }
      else
        {
         NewsFilter = AvoidNews;
        }

      if(CurrencyOnly)
        {
         NewsSymb ="";
         if(StringLen(NewsSymb)>1)
            str1=NewsSymb;
        }
      else
        {
         str1=mysymbolList[jk];
        }


      Vtunggal = NewsTunggal;
      Vhigh=NewsHard;
      Vmedium=NewsMedium;
      Vlow=NewsLight;

      MinBefore=BeforeNewsStop;
      MinAfter=AfterNewsStop;

      string sf="";

      int v2 = (StringLen(mysymbol)-6);
      if(v2>0)
        {
         sf = StringSubstr(mysymbol,6,v2);
        }
      postfix=sf;
      TMN=0;
      e_d = expire_date;
      if(CloseBeforNews)
        {
         NewsFilter = True;
        }
      else
        {
         NewsFilter = AvoidNews;
        }

      if(CurrencyOnly)
        {
         NewsSymb ="";
         if(StringLen(NewsSymb)>1)
            str1=NewsSymb;
        }
      else
        {
         str1=symbol;
        }
      Vtunggal = NewsTunggal;
      Vhigh=NewsHard;
      Vmedium=NewsMedium;
      Vlow=NewsLight;

      MinBefore=BeforeNewsStop;
      MinAfter=AfterNewsStop;


      if(v2>0)
        {
         sf = StringSubstr(symbol,6,v2);
        }
      postfix=sf;
      TMN=0;
      e_d = expire_date;

      y_offset=offsets;

      timelockaction();
      TradeSignal();
      signalMessage();


      if(AccountBalance()>0)
        {
         Persentase1=(P1/AccountBalance())*100;

        }
      int   TSa=0;
      //=================================================
      //     bool time=(Hour()>=Start && Hour()<End);
      bool time= CheckTradingTime();


      double prs=0,prb=0;

      for(int pos=0; pos<=OrdersTotal(); pos++)

        {
         if(!OrderSelect(pos,SELECT_BY_POS))
           {
            continue;
           }
         if(OrderMagicNumber()==MagicNumber && OrderSymbol()==symbol) //&& OrderType()==OP_BUY)
           {
            TBa++;
           }
         if(OrderMagicNumber()==MagicNumber && OrderSymbol()==symbol) //&& OrderType()==OP_SELL)
           {
            TSa++;
           }
         if(OrderMagicNumber()==MagicNumber && OrderType()==OP_BUY)
           {
            ttlbuy ++;
           }
         if(OrderMagicNumber()==MagicNumber && OrderType()==OP_SELL)
           {
            ttlsell ++;
           }
        }
      Alert("t buy : ",ttlbuy," ttl sell : ",ttlsell);


      double MaxSl = MaxSL * myPoint;
      MinSL = MinSL * myPoint;
      double MaxTp = MaxTP * myPoint;
      MinTP = MinTP * myPoint;

      if(UsePartialClose)
        {
         CheckPartialClose(UsePartialClose);
        }
      if(UseTrailingStop)
        {
         checkTrail(UseTrailingStop);
        }

      if(UseTrailingOrders)
        {
         TrailingOrders(UseTrailingOrders);
        }

      if(UseBreakEven)
        {
         _funcBE(UseBreakEven);
        }


      DeleteByDistance(DeleteOrderAtDistance * myPoint);

      CheckPartialClose(UsePartialClose);
      TrailingOrders(UseTrailingStop);
      TrailingPositions(UseTrailingStop);
      checkTrail(UseTrailingStop);

      TrailingStopTrail(OP_BUY, TrailingStart * myPoint, TrailingStep * myPoint,false, 1 * myPoint,UseTrailingStop); //Trailing Stop = trail
      TrailingStopTrail(OP_SELL, TrailingStart * myPoint, TrailingStep * myPoint, false, 5 * myPoint,UseTrailingStop); //Trailing Stop = trail
      if(inpTradeMode==Automatic)
        {

         y_offset = 0;//--- GUI Debugging utils used in GetOpeningSignals,GetClosingSignals

         GetOpeningSignals(OpenSignals);
         GetClosingSignals(CloseSignals);
         //--- check that an opening signal is not counter by a closing one
         ValidateSignals(OpenSignals,CloseSignals);
         //--- check for closing opened order
         for(int i=0; i<ArraySize(CloseSignals); i++)
           {
            if(_funcOrdTotal(CloseSignals[i].symbol)==0)   //--- no order for symbol, skip closing
              {
               continue;
              }
            switch(CloseSignals[i].type)
              {
               case OP_BUY:   //--- close SELL orders
                 {
                  _funcClose(OP_BUY,CloseSignals[i].symbol);
                  break;
                 }
               case OP_SELL:   //--- close BUY orders
                 {
                  _funcClose(OP_BUY,CloseSignals[i].symbol);
                  break;
                 }
               default: //--- no match
                  break;
              }
           }


         //--- check for opening trades
         for(int i=0; i<ArraySize(OpenSignals); i++)
           {
            OpenOrder(OpenSignals[i]);
           }
         //Display MENU
         ;

         //Open Buy Order (BUY Strategy)
         if(MarketInfo(symbol,MODE_SPREAD)<=inpMaxSpread &&AccountEquity()>=inpReqEquity&&OrdersTotal()<MaxOpenTrades&&(TradeSignal()=="BUY"||TradeSignal()=="BUYLIMT"||TradeSignal()=="BUYSTOP")&&IsNewM1Candle()&&(iTime(NULL,inpTF1,0) > sendOnce|| !IsNewM1Candle())&& exitBuy==false&&TBa<MaxLongTrades && ttlbuy<MaxLongTrades && (((closetype == opposite) || (closetype != opposite))&&(inpTradeStyle==LONG || inpTradeStyle == BOTH)

                                                                                                                                                                                                                                                                                                                                        ))
           {
            sendOnce= iTime(NULL,inpTF2,0);
            RefreshRates();
            double price = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_ASK),vdigits);
            SL = 100 * myPoint; //Stop Loss = value in points (relative to price)
            if(SL > MaxSL)
               SL = MaxSL;
            if(SL < MinSL)
               SL = MinSL;
            TP = 100 * myPoint; //Take Profit = value in points (relative to price)
            if(TP > MaxTP)
               TP = MaxTP;
            if(TP < MinTP)
               TP = MinTP;
            if(CheckTradingTime())
               return; //open trades only on specific days of the week
            if(IsTradeAllowed())
              {

               switch(Order_Type)
                 {
                  case MARKET_ORDERS:
                     ticket= myOrderSend(OP_BUY, price, TradeSize(InpMoneyManagement), "BUY Strategy");

                     break;
                  case LIMIT_ORDERS:
                     ticket= myOrderSend(OP_BUYLIMIT, price, TradeSize(InpMoneyManagement), "BUY Strategy");

                     break;
                  case STOP_ORDERS :
                     ticket = myOrderSend(OP_BUYSTOP, price, TradeSize(InpMoneyManagement), "BUY Strategy");

                     break;
                  default:
                     break;
                 }
               if(ticket <= 0)
                  return;
              }
            else  //not autotrading => only send alert
              {

               myAlert("order", "BUY Strategy");
               //  NextTradeTime = StringToTime(IntegerToString(NextOpenTradeAfterTOD_Hour)+":"+IntegerToString(NextOpenTradeAfterTOD_Min));
               // while(NextTradeTime <= TimeCurrent()) NextTradeTime += 86400;
               myOrderModifyRel(ticket, 0, TP);
               myOrderModifyRel(ticket, SL, 0);


              }

           }


        }
      if(MarketInfo(symbol,MODE_SPREAD)<=inpMaxSpread)
        {
         message="__Market Infos--\n "+symbol+ " spread  is  above  Maxspread ,order will not be placed if valid signal found.\n";
         smartBot.SendMessage(InpChatID,message);
         Alert("as it is above set maxpread ,Order will not be placed if valid signal found.\n");
        }


      //Open Sell Order (sell Strategy)
      if(MarketInfo(symbol,MODE_SPREAD)<=inpMaxSpread <AccountEquity()>=inpReqEquity&&OrdersTotal()<MaxOpenTrades&&(TradeSignal()=="SELL"||TradeSignal()=="SELLLIMT"||TradeSignal()=="SELLSTOP")&&IsNewM1Candle()&&(iTime(NULL,inpTF1,0) > sendOnce|| !IsNewM1Candle())&& exitSell==false&&TBa<MaxShortTrades && ttlsell<MaxOpenTrades && (((closetype == opposite) || (closetype != opposite))&&(inpTradeStyle==SHORT || inpTradeStyle== BOTH)

                                                                                                                                                                                                                                                                                                                                          ))
        {
         sendOnce= iTime(NULL,inpTF2,0);

         RefreshRates();
         double price = NormalizeDouble(SymbolInfoDouble(symbol,SYMBOL_BID),vdigits);

         SL = 100 * myPoint; //Stop Loss = value in points (relative to price)
         if(SL > MaxSL)
            SL = MaxSL;
         if(SL < MinSL)
            SL = MinSL;
         TP = 100 * myPoint; //Take Profit = value in points (relative to price)
         if(TP > MaxTP)
            TP = MaxTP;
         if(TP < MinTP)
            TP = MinTP;
         if(!CheckTradingTime())
            return; //open trades only on specific days of the week
         if(IsTradeAllowed())
           {


            switch(Order_Type)
              {

               case MARKET_ORDERS:
                  ticket+= myOrderSend(OP_SELL, price, TradeSize(InpMoneyManagement), "BUY Strategy");

                  break;
               case LIMIT_ORDERS:
                  ticket+= myOrderSend(OP_SELLLIMIT, price, TradeSize(InpMoneyManagement), "BUY Strategy");

                  break;
               case STOP_ORDERS :
                  ticket+= myOrderSend(OP_SELLSTOP, price, TradeSize(InpMoneyManagement), "BUY Strategy");

                  break;
               default:
                  break;


              }

            if(ticket <= 0)
               return;
           }
         else  //not autotrading => only send alert
           {

            myAlert("order", "BUY Strategy");
            //  NextTradeTime = StringToTime(IntegerToString(NextOpenTradeAfterTOD_Hour)+":"+IntegerToString(NextOpenTradeAfterTOD_Min));
            // while(NextTradeTime <= TimeCurrent()) NextTradeTime += 86400;
            myOrderModifyRel(ticket, 0, TP);
            myOrderModifyRel(ticket, SL, 0);
           }

        }

     }//End Auto trading



// Calculer les floating profits pour le magic
   for(int i=0; i<OrdersTotal(); i++)
     {
      int xx=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()==OP_BUY && OrderMagicNumber()==MagicNumber)
        {
         PB+=OrderProfit()+OrderCommission()+OrderSwap();
        }
      if(OrderType()==OP_SELL && OrderMagicNumber()==MagicNumber)
        {
         PS+=OrderProfit()+OrderCommission()+OrderSwap();
        }
     }


// Profit floating pour toutes les paires , variable TPM

// if(TPm>0&&PB+PS>=TPm)
   if(1<0)
     {
      messages="Profit TP closing all trades.PB,PS "+(string)(PB+PS);
      smartBot.SendMessageToChannel(InpChannel,messages);

      smartBot.SendMessage(InpChatID2,messages);
      Print("Profit TP closing all trades.PB,PS "+string(PB+PS));
      //CloseAll();
     }

// Si les floating profit + ce qui est déjà fermé, pour le magic,  atteint le daily profit, on vire les trades pour le magic
// Si non on reparcourt les ordres pour gérer les martis
   double DailyProfit=P1+PB+PS;

   if(ProfitValue>0 && ((P1+PB+PS)/(AccountEquity()-(P1+PB+PS)))*100 >=ProfitValue &&  TargetReachedForDay!=ThisDayOfYear)
     {
      Alert("Daily Target reached. Closed running trades");
      messages="Daily Target reached. Closed running trades";

      smartBot.SendMessageToChannel(InpChannel,messages);
      smartBot.SendMessage(InpChatID2,messages);
      CloseAll();
      TargetReachedForDay=ThisDayOfYear;
     }
   else
     {
      for(int i=0; i<OrdersTotal(); i++)
        {
         int xx=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(!xx)
            continue;
         if(OrderType()==OP_BUY && OrderMagicNumber()==MagicNumber)
           {
            TO++;
            TB++;
            PB+=OrderProfit()+OrderCommission()+OrderSwap();
            LTB+=OrderLots();

            //if(closeAskedFor!= "BUY"+OrderSymbol())
            ClosetradePairs(OrderSymbol());
           }
         if(OrderType()==OP_SELL && OrderMagicNumber()==MagicNumber)
           {
            TO++;
            TS++;
            PS+=OrderProfit()+OrderCommission()+OrderSwap();
            LTS+=OrderLots();
            //if(closeAskedFor!= "SELL"+OrderSymbol())
            ClosetradePairs(OrderSymbol());
           }
        }


      // Calculer les floating profits pour le magic
      for(int i=0; i<OrdersTotal(); i++)
        {
         int xx=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
         if(OrderType()==OP_BUY && OrderMagicNumber()==MagicNumber)
           {
            PB+=OrderProfit()+OrderCommission()+OrderSwap();
           }
         if(OrderType()==OP_SELL && OrderMagicNumber()==MagicNumber)
           {
            PS+=OrderProfit()+OrderCommission()+OrderSwap();
           }
        }


      // Profit floating pour toutes les paires , variable TPM

      // if(TPm>0&&PB+PS>=TPm)
      if(1<0)
        {
         messages="Profit TP closing all trades.PB,PS "+(string)(PB+PS);
         smartBot.SendMessageToChannel(InpChannel,messages);

         smartBot.SendMessage(InpChatID2,messages);
         Print("Profit TP closing all trades.PB,PS "+string(PB+PS));
         //CloseAll();
        }

      // Si les floating profit + ce qui est déjà fermé, pour le magic,  atteint le daily profit, on vire les trades pour le magic
      // Si non on reparcourt les ordres pour gérer les martis
      DailyProfit=P1+PB+PS;

      if(ProfitValue>0 && ((P1+PB+PS)/(AccountEquity()-(P1+PB+PS)))*100 >=ProfitValue &&  TargetReachedForDay!=ThisDayOfYear)
        {
         Alert("Daily Target reached. Closed running trades");
         messages="Daily Target reached. Closed running trades";

         smartBot.SendMessageToChannel(InpChannel,messages);
         smartBot.SendMessage(InpChatID2,messages);
         CloseAll();
         TargetReachedForDay=ThisDayOfYear;
        }
      else
        {
         for(int i=0; i<OrdersTotal(); i++)
           {
            int xx=OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
            if(!xx)
               continue;
            if(OrderType()==OP_BUY && OrderMagicNumber()==MagicNumber)
              {
               TO++;
               TB++;
               PB+=OrderProfit()+OrderCommission()+OrderSwap();
               LTB+=OrderLots();

               //if(closeAskedFor!= "BUY"+OrderSymbol())
               ClosetradePairs(OrderSymbol());
              }
            if(OrderType()==OP_SELL && OrderMagicNumber()==MagicNumber)
              {
               TO++;
               TS++;
               PS+=OrderProfit()+OrderCommission()+OrderSwap();
               LTS+=OrderLots();
               //if(closeAskedFor!= "SELL"+OrderSymbol())
               ClosetradePairs(OrderSymbol());
              }
           }



        }
      Sleep(100);


     }



  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---


///--- Launch the library timer (only not in the tester)
   if(!MQLInfoInteger(MQL_TESTER))




      //--- show init error
      if(init_error!=0)
        {
         //--- show error on display
         CustomInfo info;
         GetCustomInfo(info,init_error,InpLanguage);

         //---
         comment.Clear();
         comment.SetText(0,StringFormat("%s v.%s",EXPERT_NAME,EXPERT_VERSION),CAPTION_COLOR);
         comment.SetText(1,info.text1, LOSS_COLOR);
         if(info.text2!="")
            comment.SetText(2,info.text2,LOSS_COLOR);
         comment.Show();

        }

//--- show web error
   if(run_mode==RUN_LIVE)
     {

      //--- check bot registration
      if(time_check<TimeLocal()-PeriodSeconds(PERIOD_H1))
        {
         time_check=TimeLocal();
         if(TerminalInfoInteger(TERMINAL_CONNECTED))
           {
            //---
            web_error=smartBot.GetMe();
            if(web_error!=0)
              {
               //---
               if(web_error==ERR_NOT_ACTIVE)
                 {
                  time_check=mydate-PeriodSeconds(PERIOD_H1)+300;
                 }
               //---
               else
                 {
                  time_check=mydate-PeriodSeconds(PERIOD_H1)+5;
                 }
              }
           }
         else
           {
            web_error=ERR_NOT_CONNECTED;
            time_check=0;
           }
        }

      //--- show error
      if(web_error!=0)
        {
         comment.Clear();
         comment.SetText(0,StringFormat("%s v.%s",EXPERT_NAME,EXPERT_VERSION),CAPTION_COLOR);

         if(
#ifdef __MQL4__ web_error==ERR_FUNCTION_NOT_CONFIRMED

#endif
#ifdef __MQL5__ web_error==ERR_FUNCTION_NOT_ALLOWED #endif
         )
           {
            time_check=0;

            CustomInfo info= {0};
            GetCustomInfo(info,web_error,InpLanguage);
            comment.SetText(1,info.text1,LOSS_COLOR);
            comment.SetText(2,info.text2,LOSS_COLOR);
           }
         else
            comment.SetText(1,GetErrorDescription(web_error,InpLanguage),LOSS_COLOR);

         comment.Show();
         return;
        }


      engine.OnTimer();
      if(UseBot)
        {
         smartBot.GetUpdates();
         smartBot.ForceReply();
         smartBot.ReplyKeyboardHide();
         smartBot.ChatsTotal();
         smartBot.ProcessMessages();



         comment.Clear();
         comment.SetText(0,StringFormat("%s v.%s",EXPERT_NAME,EXPERT_VERSION),CAPTION_COLOR);
         comment.SetText(1,StringFormat("%s: %s",(InpLanguage==LANGUAGE_EN)?"Bot Name":"Имя Бота",smartBot.Name()),CAPTION_COLOR);
         comment.SetText(2,StringFormat("%s: %d",(InpLanguage==LANGUAGE_EN)?"Chats":"Чаты",smartBot.ChatsTotal()),CAPTION_COLOR);
         comment.Show();
        }

     }

  }


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
//--- Symbol selection buttons
   if(id == CHARTEVENT_OBJECT_CLICK)
     {
      if(StringFind(sparam,OBJPFX"SGGS",0)>=0)
        {
         ObjectSetInteger(ChartID(),sparam,OBJPROP_BGCOLOR,clrLime);
         //--- extract index from button name
         int index = (int)StringToInteger(StringSubstr(sparam,StringLen(OBJPFX"SGGS")));
         ReleaseOtherButtons(index);
         SymbolButtonSelected = (int)index;
        }
      if(inpTradeMode == Manual)
        {

         string _sName = mysymbolList[SymbolButtonSelected];
         double pip;
         pip=SymbolInfoDouble(_sName,SYMBOL_POINT);
         if(SymbolInfoInteger(_sName,SYMBOL_DIGITS)==5 || SymbolInfoInteger(_sName,SYMBOL_DIGITS)==3 || StringFind(_sName,"XAU",0)>=0)
            pip*=10;

         double vol = (double)ObjectGetString(0,OBJPFX"editLot",OBJPROP_TEXT);
         double sl = (double)ObjectGetString(0,OBJPFX"editStop",OBJPROP_TEXT)*pip;
         double tp = (double)ObjectGetString(0,OBJPFX"editTP",OBJPROP_TEXT)*pip;
         int not = (int)ObjectGetString(0,OBJPFX"editTN",OBJPROP_TEXT);
         double fVol = LotsOptimized(_sName);

         for(int i=0; i<MAX_CLOSE_BUTTONS; i++)
           {
            if(sparam==OBJPFX+CloseButtonNames[i])
              {
               if(IsTesting())
                 {
                  PrintFormat("%s pressed",CloseButtonNames[i]);
                 }
               switch((ENUM_CLOSE_BUTTON_TYPES)i)
                 {
                  default:
                     PrintFormat("Unhandled close button type: %d",i);
                     break;
                  case CloseBuy:
                    { CloseBuyOrders(_sName); break; }
                  case CloseSell:
                    { CloseSellOrders(_sName); break; }
                  case CloseProfit:
                    { CloseProfitOrders(_sName); break; }
                  case CloseLoss:
                    { CloseLossOrders(_sName); break; }
                  case ClosePendingLimit:
                    { ClosePendingLimitOrders(_sName); break; }
                  case ClosePendingStop:
                    { ClosePendingStopOrders(_sName); break; }
                  case CloseAll:
                    { CloseAllOrders(_sName); break; }
                 }
               //--- unset state
               ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
              }

           }

         if(sparam==OBJPFX"btnSell")
           {

            int size = GetManualSignalIndex();
            ManualSignals[size].symbol = _sName;
            ManualSignals[size].type = OP_SELL;
            ManualSignals[size].volume = fVol;
            ManualSignals[size].stop = sl;
            ManualSignals[size].tp = tp;
            ManualSignals[size].not = not;
            ManualSignals[size].done = false;
            if(IsTesting())
               Print(_sName + ":"+ sparam+":"+IntegerToString(size)+",t:"+IntegerToString(ManualSignals[size].type));

            ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
           }
         else
            if(sparam==OBJPFX"btnBuy")
              {
               int size = GetManualSignalIndex();
               ManualSignals[size].symbol = _sName;
               ManualSignals[size].type = OP_BUY;
               ManualSignals[size].volume = fVol;
               ManualSignals[size].stop = sl;
               ManualSignals[size].tp = tp;
               ManualSignals[size].not = not;
               ManualSignals[size].done = false;
               if(IsTesting())
                  Print(_sName + ":"+ sparam+":"+IntegerToString(size)+",t:"+IntegerToString(ManualSignals[size].type));

               ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
              }
            else
               if(sparam==OBJPFX"btnSS")
                 {
                  int size = GetManualSignalIndex();
                  ManualSignals[size].symbol = _sName;
                  ManualSignals[size].type = OP_SELLSTOP;
                  ManualSignals[size].volume = fVol;
                  ManualSignals[size].stop = sl;
                  ManualSignals[size].tp = tp;
                  ManualSignals[size].not = not;
                  ManualSignals[size].done = false;
                  if(IsTesting())
                     Print(_sName + ":"+ sparam+":"+IntegerToString(size)+",t:"+IntegerToString(ManualSignals[size].type));

                  ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
                 }
               else
                  if(sparam==OBJPFX"btnBS")
                    {
                     int size = GetManualSignalIndex();
                     ManualSignals[size].symbol = _sName;
                     ManualSignals[size].type = OP_BUYSTOP;
                     ManualSignals[size].volume = fVol;
                     ManualSignals[size].stop = sl;
                     ManualSignals[size].tp = tp;
                     ManualSignals[size].not = not;
                     ManualSignals[size].done = false;
                     if(IsTesting())
                        Print(_sName + ":"+ sparam+":"+IntegerToString(size)+",t:"+IntegerToString(ManualSignals[size].type));

                     ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
                    }
                  else
                     if(sparam==OBJPFX"btnSL")
                       {
                        int size = GetManualSignalIndex();
                        ManualSignals[size].symbol = _sName;
                        ManualSignals[size].type = OP_SELLLIMIT;
                        ManualSignals[size].volume = fVol;
                        ManualSignals[size].stop = sl;
                        ManualSignals[size].tp = tp;
                        ManualSignals[size].not = not;
                        ManualSignals[size].done = false;
                        if(IsTesting())
                           Print(_sName + ":"+ sparam+":"+IntegerToString(size)+",t:"+IntegerToString(ManualSignals[size].type));

                        ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
                       }
                     else
                        if(sparam==OBJPFX"btnBL")
                          {
                           int size = GetManualSignalIndex();
                           ManualSignals[size].symbol = _sName;
                           ManualSignals[size].type = OP_BUYLIMIT;
                           ManualSignals[size].volume = fVol;
                           ManualSignals[size].stop = sl;
                           ManualSignals[size].tp = tp;
                           ManualSignals[size].not = not;
                           ManualSignals[size].done = false;
                           if(IsTesting())
                              Print(_sName + ":"+ sparam+":"+IntegerToString(size)+",t:"+IntegerToString(ManualSignals[size].type));

                           ObjectSetInteger(0,sparam,OBJPROP_STATE,false);
                          }
        }
     }
   if(id==CHARTEVENT_MOUSE_MOVE)
     {
      //-- UserIsHolding (Left-Click)
      if(sparam=="1")
        {
         bool coordinates_set = false;
         //-- MoveClient
         if(inpTradeMode == Manual)    //--- Trade panel is created in manual mode only
           {
            if(ObjectGetInteger(0,OBJPFX"Back",OBJPROP_SELECTED)/* || ObjectFind(0,OBJPFX"Back")!=0*/)
              {
               //-- MoveObjects
               GetSetCoordinates();
               MoveGUI();
               coordinates_set = true;
              }
            if(ObjectGetInteger(0,OBJPFX"BackCP",OBJPROP_SELECTED)/* || ObjectFind(0,OBJPFX"Back")!=0*/)
              {
               //-- MoveObjects
               if(!coordinates_set)
                  GetSetCoordinates();
               MoveClosePanel();
               coordinates_set = true;
              }

           }
         if(ShowTradedSymbols)
           {
            if(ObjectGetInteger(0,OBJPFX"BackSP",OBJPROP_SELECTED)/* || ObjectFind(0,OBJPFX"Back")!=0*/)
              {
               //-- MoveObjects
               if(!coordinates_set)
                 {
                  GetSetCoordinates();
                  coordinates_set = true;
                 }
               MoveSymbolPanel();
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Tester function                                                  |
//+------------------------------------------------------------------+
double OnTester()
  {
//---
   _OnTester();
   double ret=0.0;
//---

//---
   return(ret);
  }
//+------------------------------------------------------------------+
