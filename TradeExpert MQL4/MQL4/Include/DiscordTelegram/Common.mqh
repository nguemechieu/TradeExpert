//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include  <DiscordTelegram/Enums.mqh>
//+------------------------------------------------------------------+
//|   Define                                                         |
//+------------------------------------------------------------------+
#define  ERR_LICENSE_KEY_EXPIRED    ERROR_INVALID_LICENSE
#define  LICENSE_IS_VALID
#define CUSTOM_ERROR_FIRST          ERR_USER_ERROR_FIRST
#define ERR_JSON_PARSING            ERR_USER_ERROR_FIRST+1
#define ERR_JSON_NOT_OK             ERR_USER_ERROR_FIRST+2
#define ERR_TOKEN_ISEMPTY           ERR_USER_ERROR_FIRST+3
#define ERR_RUN_LIMITATION          ERR_USER_ERROR_FIRST+4
//---
#define ERR_NOT_ACTIVE              ERR_USER_ERROR_FIRST+100
#define ERR_NOT_CONNECTED           ERR_USER_ERROR_FIRST+101
#define ERR_ORDER_SELECT            ERR_USER_ERROR_FIRST+102
#define ERR_INVALID_ORDER_TYPE      ERR_USER_ERROR_FIRST+103
#define ERR_INVALID_SYMBOL_NAME     ERR_USER_ERROR_FIRST+104
#define ERR_INVALID_EXPIRATION_TIME ERR_USER_ERROR_FIRST+105
#define ERR_HTTP_ERROR_FIRST        ERR_USER_ERROR_FIRST+1000 //+511

;
enum ENUM_LANGUAGES {LANGUAGE_EN,LANGUAGE_RU,LANGUAGE_FR,LANGUAGE_DE,LANGUAGE_CH};
ENUM_LANGUAGES ENGLISH=LANGUAGE_EN;
//+------------------------------------------------------------------+
//|   ENUM_ERROR_LEVEL                                               |
//+------------------------------------------------------------------+
enum ENUM_ERROR_LEVEL
{
   LEVEL_INFO,
   LEVEL_WARNING,
   LEVEL_ERROR,
   LEVEL_CRITICAL
};
//+------------------------------------------------------------------+
//|   CustomInfo                                                     |
//+------------------------------------------------------------------+
struct CustomInfo
{
   string            text1;
   string            text2;
   color             colour;
   ENUM_ERROR_LEVEL  level;
};
struct ErrorInfo
{
   int               code;
   string            desc;
   ENUM_ERROR_LEVEL  level;
   ENUM_LANGUAGES   lang;
};

//+------------------------------------------------------------------+
//|   GetErrorInfo                                                   |
//+------------------------------------------------------------------+
bool GetErrorInfo(ErrorInfo &infos)
{  ErrorInfo info=infos;

   info.level=LEVEL_INFO;

   if(info.lang==LANGUAGE_EN)
   {

      switch(info.code)
      {
      case ERR_NOT_CONNECTED:
         info.desc="No connection with server";
         info.level=LEVEL_ERROR;
         break;
      case ERR_JSON_PARSING:
         info.desc="JSON parsing error";
         info.level=LEVEL_ERROR;
         break;
      case ERR_JSON_NOT_OK:
         info.desc="JSON parsing not OK";
         info.level=LEVEL_ERROR;
         break;
      case ERR_TOKEN_ISEMPTY:
         info.desc="Token is empty";
         info.level=LEVEL_ERROR;
         break;
      case ERR_RUN_LIMITATION:
         info.desc="The bot does not run in tester mode";
         info.level=LEVEL_ERROR;
         break;

      case ERR_WEBREQUEST_INVALID_ADDRESS:
         info.desc="Invalid URL";
         break;
      case ERR_WEBREQUEST_CONNECT_FAILED:
         info.desc="Failed to connect to specified URL";
         break;
      case ERR_WEBREQUEST_TIMEOUT:
         info.desc="Timeout exceeded";
         break;
      case ERR_WEBREQUEST_REQUEST_FAILED:
         info.desc="HTTP request failed";
         break;

#ifdef __MQL4__
      case ERR_FUNCTION_NOT_CONFIRMED:
         info.desc="URL does not allowed for WebRequest";
         break;
#endif

#ifdef __MQL5__
      case ERR_FUNCTION_NOT_ALLOWED:
         info.desc="URL does not allowed for WebRequest";
         break;
      case ERR_FILE_NOT_EXIST:
         info.desc="File is not exists";
         break;
      case ERR_CHART_NOT_FOUND:
         info.desc="Chart not found";
         break;
      case ERR_SUCCESS:
         info.desc="The operation completed successfully";
         break;
#endif
      //---
      case ERR_HTTP_ERROR_FIRST+100:
         info.desc="Continue";
         break;
      case ERR_HTTP_ERROR_FIRST+101:
         info.desc="Switching Protocols";
         break;
      case ERR_HTTP_ERROR_FIRST+103:
         info.desc="Checkpoint";
         break;
      case ERR_HTTP_ERROR_FIRST+200:
         info.desc="OK";
         break;
      case ERR_HTTP_ERROR_FIRST+201:
         info.desc="Created";
         break;
      case ERR_HTTP_ERROR_FIRST+202:
         info.desc="Accepted";
         break;
      case ERR_HTTP_ERROR_FIRST+203:
         info.desc="Non-Authoritative Information";
         break;
      case ERR_HTTP_ERROR_FIRST+204:
         info.desc="No Content";
         break;
      case ERR_HTTP_ERROR_FIRST+205:
         info.desc="Reset Content";
         break;
      case ERR_HTTP_ERROR_FIRST+206:
         info.desc="Partial Content";
         break;
      case ERR_HTTP_ERROR_FIRST+300:
         info.desc="Multiple Choices";
         break;
      case ERR_HTTP_ERROR_FIRST+301:
         info.desc="Moved Permanently";
         break;
      case ERR_HTTP_ERROR_FIRST+302:
         info.desc="Found";
         break;
      case ERR_HTTP_ERROR_FIRST+303:
         info.desc="See Other";
         break;
      case ERR_HTTP_ERROR_FIRST+304:
         info.desc="Not Modified";
         break;
      case ERR_HTTP_ERROR_FIRST+306:
         info.desc="Switch Proxy";
         break;
      case ERR_HTTP_ERROR_FIRST+307:
         info.desc="Temporary Redirect";
         break;
      case ERR_HTTP_ERROR_FIRST+308:
         info.desc="Resume Incomplete";
         break;
      case ERR_HTTP_ERROR_FIRST+400:
         info.desc="Bad Request";
         break;
      case ERR_HTTP_ERROR_FIRST+401:
         info.desc="Unauthorized";
         break;
      case ERR_HTTP_ERROR_FIRST+402:
         info.desc="Payment Required";
         break;
      case ERR_HTTP_ERROR_FIRST+403:
         info.desc="Forbidden";
         break;
      case ERR_HTTP_ERROR_FIRST+404:
         info.desc="Not Found";
         break;
      case ERR_HTTP_ERROR_FIRST+405:
         info.desc="Method Not Allowed";
         break;
      case ERR_HTTP_ERROR_FIRST+406:
         info.desc="Not Acceptable";
         break;
      case ERR_HTTP_ERROR_FIRST+407:
         info.desc="Proxy Authentication Required";
         break;
      case ERR_HTTP_ERROR_FIRST+408:
         info.desc="Request Timeout";
         break;
      case ERR_HTTP_ERROR_FIRST+409:
         info.desc="Conflict";
         break;
      case ERR_HTTP_ERROR_FIRST+410:
         info.desc="Gone";
         break;
      case ERR_HTTP_ERROR_FIRST+411:
         info.desc="Length Required";
         break;
      case ERR_HTTP_ERROR_FIRST+412:
         info.desc="Precondition Failed";
         break;
      case ERR_HTTP_ERROR_FIRST+413:
         info.desc="Request Entity Too Large";
         break;
      case ERR_HTTP_ERROR_FIRST+414:
         info.desc="Request-URI Too Long";
         break;
      case ERR_HTTP_ERROR_FIRST+415:
         info.desc="Unsupported Media Type";
         break;
      case ERR_HTTP_ERROR_FIRST+416:
         info.desc="Requested Range Not Satisfiable";
         break;
      case ERR_HTTP_ERROR_FIRST+417:
         info.desc="Expectation Failed";
         break;
      case ERR_HTTP_ERROR_FIRST+500:
         info.desc="Internal Server Error";
         break;
      case ERR_HTTP_ERROR_FIRST+501:
         info.desc="Not Implemented";
         break;
      case ERR_HTTP_ERROR_FIRST+502:
         info.desc="Bad Gateway";
         break;
      case ERR_HTTP_ERROR_FIRST+503:
         info.desc="Service Unavailable";
         break;
      case ERR_HTTP_ERROR_FIRST+504:
         info.desc="Gateway Timeout";
         break;
      case ERR_HTTP_ERROR_FIRST+505:
         info.desc="HTTP Version Not Supported";
         break;
      case ERR_HTTP_ERROR_FIRST+511:
         info.desc="Network Authentication Required";
         break;

         //--- The error codes returned by trade server:
#ifdef __MQL4__
      case ERR_NO_ERROR:
         info.desc="No error";
         break;
      case ERR_NO_RESULT:
         info.desc="No error returned, but the result is unknown";
         info.level=LEVEL_WARNING;
         break;
      case ERR_COMMON_ERROR:
         info.desc="Common error.";
         info.level=LEVEL_WARNING;
         break;
      case ERR_INVALID_TRADE_PARAMETERS:
         info.desc="Invalid trade parameters";
         info.level=LEVEL_WARNING;
         break;
      case ERR_SERVER_BUSY:
         info.desc="Trade server is busy";
         info.level=LEVEL_WARNING;
         break;
      case ERR_OLD_VERSION:
         info.desc="Old version of the client terminal";
         info.level=LEVEL_WARNING;
         break;
      case ERR_NO_CONNECTION:
         info.desc="No connection with trade server";
         info.level=LEVEL_WARNING;
         break;
      case ERR_NOT_ENOUGH_RIGHTS:
         info.desc="Not enough rights";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TOO_FREQUENT_REQUESTS:
         info.desc="Too frequent requests";
         info.level=LEVEL_WARNING;
         break;
      case ERR_MALFUNCTIONAL_TRADE:
         info.desc="Malfunctional trade operation";
         info.level=LEVEL_WARNING;
         break;
      case ERR_ACCOUNT_DISABLED:
         info.desc="Account disabled";
         info.level= LEVEL_ERROR;
         break;
      case ERR_INVALID_ACCOUNT:
         info.desc="Invalid account";
         info.level= LEVEL_WARNING;
         break;
      case ERR_TRADE_TIMEOUT:
         info.desc="Trade timeout";
         info.level=LEVEL_WARNING;
         break;
      case ERR_INVALID_PRICE:
         info.desc="Invalid price";
         info.level= LEVEL_WARNING;
         break;
      case ERR_INVALID_STOPS:
         info.desc="Invalid stops";
         info.level= LEVEL_WARNING;
         break;
      case ERR_INVALID_TRADE_VOLUME:
         info.desc="Invalid trade volume";
         info.level=LEVEL_WARNING;
         break;
      case ERR_MARKET_CLOSED:
         info.desc="Market is closed";
         info.level=LEVEL_ERROR;
         break;
      case ERR_TRADE_DISABLED:
         info.desc="Trade is disabled";
         info.level=LEVEL_ERROR;
         break;
      case ERR_NOT_ENOUGH_MONEY:
         info.desc="Not enough money";
         info.level=LEVEL_ERROR;
         break;
      case ERR_PRICE_CHANGED:
         info.desc="Price changed";
         info.level=LEVEL_WARNING;
         break;
      case ERR_OFF_QUOTES:
         info.desc="Off quotes";
         info.level=LEVEL_WARNING;
         break;
      case ERR_BROKER_BUSY:
         info.desc="Broker is busy";
         info.level=LEVEL_WARNING;
         break;
      case ERR_REQUOTE:
         info.desc="Requote";
         info.level=LEVEL_WARNING;
         break;
      case ERR_ORDER_LOCKED:
         info.desc="Order is locked";
         info.level=LEVEL_WARNING;
         break;
      case ERR_LONG_POSITIONS_ONLY_ALLOWED:
         info.desc="Long positions only allowed";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TOO_MANY_REQUESTS:
         info.desc="Too many requests";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TRADE_MODIFY_DENIED:
         info.desc="Modification denied because order too close to market";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TRADE_CONTEXT_BUSY:
         info.desc="Trade context is busy";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TRADE_EXPIRATION_DENIED:
         info.desc="Expirations are denied by broker";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TRADE_TOO_MANY_ORDERS:
         info.desc="The amount of open and pending orders has reached the limit set by the broker";
         info.level=LEVEL_ERROR;
         break;
      case ERR_TRADE_HEDGE_PROHIBITED:
         info.desc="An attempt to open a position opposite to the existing one when hedging is disabled";
         info.level=LEVEL_ERROR;
         break;
      case ERR_TRADE_PROHIBITED_BY_FIFO:
         info.desc="An attempt to close a position contravening the FIFO rule";
         info.level=LEVEL_WARNING;
         break;
      //--- MQL4 run time error codes
      case ERR_TRADE_NOT_ALLOWED:
         info.desc="Trade is not allowed. Enable checkbox (Allow live trading) in the expert properties";
         info.level=LEVEL_WARNING;
         break;
      case ERR_LONGS_NOT_ALLOWED:
         info.desc="Longs are not allowed. Check the expert properties";
         info.level=LEVEL_ERROR;
         break;
      case ERR_SHORTS_NOT_ALLOWED:
         info.desc="Shorts are not allowed. Check the expert properties";
         info.level=LEVEL_ERROR;
         break;
#endif

      //---
      case ERR_INVALID_ORDER_TYPE:
         info.desc="Invalid order type";
         info.level=LEVEL_ERROR;
         break;
      case ERR_INVALID_SYMBOL_NAME:
         info.desc="Invalid symbol name";
         info.level=LEVEL_ERROR;
         break;
      case ERR_INVALID_EXPIRATION_TIME:
         info.desc="Invalid expiration time";
         info.level=LEVEL_ERROR;
         break;
      case ERR_ORDER_SELECT:
         info.desc="Error function OrderSelect()";
         info.level=LEVEL_ERROR;
         break;
      //---

      default:
         info.desc="Unknown error "+IntegerToString(info.code);
         return(false);

      }
   }

//---
   if(info.lang==ENGLISH)
   {
      switch(info.code)
      {
      case ERR_NOT_ACTIVE:
         info.desc="Нет лицензии";
         break;
      case ERR_NOT_CONNECTED:
         info.desc="Нет соединения с торговым сервером";
         break;

      case ERR_JSON_PARSING:
         info.desc="Ошибка JSON структуры ответа";
         info.level=LEVEL_ERROR;
         break;
      case ERR_JSON_NOT_OK:
         info.desc="Парсинг JSON завершен с ошибкой";
         info.level=LEVEL_ERROR;
         break;
      case ERR_TOKEN_ISEMPTY:
         info.desc="Токен-пустая строка";
         info.level=LEVEL_ERROR;
         break;
      case ERR_RUN_LIMITATION:
         info.desc="Бот не работает в тестере стратегий";
         info.level=LEVEL_ERROR;
         break;
  
  
       info.level=LEVEL_ERROR;   //---
      case ERR_WEBREQUEST_INVALID_ADDRESS:
         info.desc="URL не прошел проверку";
         break;
      case ERR_WEBREQUEST_CONNECT_FAILED:
         info.desc="Не удалось подключиться к указанному URL";
         break;
      case ERR_WEBREQUEST_TIMEOUT:
         info.desc="Превышен таймаут получения данных";
         break;
      case ERR_WEBREQUEST_REQUEST_FAILED:
         info.desc="Ошибка в результате выполнения HTTP запроса";
         break;

#ifdef __MQL4__
      case ERR_FUNCTION_NOT_CONFIRMED:
         info.desc="URL нет в списке для WebRequest";
         break;
#endif

#ifdef __MQL5__
      case ERR_FUNCTION_NOT_ALLOWED:
         info.desc="URL нет в списке для WebRequest";
         break;
      case ERR_FILE_NOT_EXIST:
         info.desc="Файла не существует";
         break;
      case ERR_CHART_NOT_FOUND:
         info.desc="График не найден";
         break;
      case ERR_SUCCESS:
         info.desc="Операция выполнена успешно";
         break;
#endif
      //---
      case ERR_HTTP_ERROR_FIRST+100:
         info.desc="Continue";
         break;
      case ERR_HTTP_ERROR_FIRST+101:
         info.desc="Switching Protocols";
         break;
      case ERR_HTTP_ERROR_FIRST+103:
         info.desc="Checkpoint";
         break;
      case ERR_HTTP_ERROR_FIRST+200:
         info.desc="OK";
         break;
      case ERR_HTTP_ERROR_FIRST+201:
         info.desc="Created";
         break;
      case ERR_HTTP_ERROR_FIRST+202:
         info.desc="Accepted";
         break;
      case ERR_HTTP_ERROR_FIRST+203:
         info.desc="Non-Authoritative Information";
         break;
      case ERR_HTTP_ERROR_FIRST+204:
         info.desc="No Content";
         break;
      case ERR_HTTP_ERROR_FIRST+205:
         info.desc="Reset Content";
         break;
      case ERR_HTTP_ERROR_FIRST+206:
         info.desc="Partial Content";
         break;
      case ERR_HTTP_ERROR_FIRST+300:
         info.desc="Multiple Choices";
         break;
      case ERR_HTTP_ERROR_FIRST+301:
         info.desc="Moved Permanently";
         break;
      case ERR_HTTP_ERROR_FIRST+302:
         info.desc="Found";
         break;
      case ERR_HTTP_ERROR_FIRST+303:
         info.desc="See Other";
         break;
      case ERR_HTTP_ERROR_FIRST+304:
         info.desc="Not Modified";
         break;
      case ERR_HTTP_ERROR_FIRST+306:
         info.desc="Switch Proxy";
         break;
      case ERR_HTTP_ERROR_FIRST+307:
         info.desc="Temporary Redirect";
         break;
      case ERR_HTTP_ERROR_FIRST+308:
         info.desc="Resume Incomplete";
         break;
      case ERR_HTTP_ERROR_FIRST+400:
         info.desc="Bad Request";
         break;
      case ERR_HTTP_ERROR_FIRST+401:
         info.desc="Unauthorized";
         break;
      case ERR_HTTP_ERROR_FIRST+402:
         info.desc="Payment Required";
         break;
      case ERR_HTTP_ERROR_FIRST+403:
         info.desc="Forbidden";
         break;
      case ERR_HTTP_ERROR_FIRST+404:
         info.desc="Not Found";
         break;
      case ERR_HTTP_ERROR_FIRST+405:
         info.desc="Method Not Allowed";
         break;
      case ERR_HTTP_ERROR_FIRST+406:
         info.desc="Not Acceptable";
         break;
      case ERR_HTTP_ERROR_FIRST+407:
         info.desc="Proxy Authentication Required";
         break;
      case ERR_HTTP_ERROR_FIRST+408:
         info.desc="Request Timeout";
         break;
      case ERR_HTTP_ERROR_FIRST+409:
         info.desc="Conflict";
         break;
      case ERR_HTTP_ERROR_FIRST+410:
         info.desc="Gone";
         break;
      case ERR_HTTP_ERROR_FIRST+411:
         info.desc="Length Required";
         break;
      case ERR_HTTP_ERROR_FIRST+412:
         info.desc="Precondition Failed";
         break;
      case ERR_HTTP_ERROR_FIRST+413:
         info.desc="Request Entity Too Large";
         break;
      case ERR_HTTP_ERROR_FIRST+414:
         info.desc="Request-URI Too Long";
         break;
      case ERR_HTTP_ERROR_FIRST+415:
         info.desc="Unsupported Media Type";
         break;
      case ERR_HTTP_ERROR_FIRST+416:
         info.desc="Requested Range Not Satisfiable";
         break;
      case ERR_HTTP_ERROR_FIRST+417:
         info.desc="Expectation Failed";
         break;
      case ERR_HTTP_ERROR_FIRST+500:
         info.desc="Internal Server Error";
         break;
      case ERR_HTTP_ERROR_FIRST+501:
         info.desc="Not Implemented";
         break;
      case ERR_HTTP_ERROR_FIRST+502:
         info.desc="Bad Gateway";
         break;
      case ERR_HTTP_ERROR_FIRST+503:
         info.desc="Service Unavailable";
         break;
      case ERR_HTTP_ERROR_FIRST+504:
         info.desc="Gateway Timeout";
         break;
      case ERR_HTTP_ERROR_FIRST+505:
         info.desc="HTTP Version Not Supported";
         break;
      case ERR_HTTP_ERROR_FIRST+511:
         info.desc="Network Authentication Required";
         break;

         //---
#ifdef __MQL4__
      case ERR_NO_ERROR:
         info.desc="Нет ошибки";
         break;
      case ERR_NO_RESULT:
         info.desc="Нет ошибки, но результат неизвестен";
         info.level=LEVEL_WARNING;
         break;
      case ERR_COMMON_ERROR:
         info.desc="Общая ошибка";
         info.level=LEVEL_WARNING;
         break;
      case ERR_INVALID_TRADE_PARAMETERS:
         info.desc="Неправильные параметры";
         info.level=LEVEL_WARNING;
         break;
      case ERR_SERVER_BUSY:
         info.desc="Торговый сервер занят";
         info.level=LEVEL_WARNING;
         break;
      case ERR_OLD_VERSION:
         info.desc="Старая версия клиентского терминала";
         info.level=LEVEL_WARNING;
         break;
      case ERR_NO_CONNECTION:
         info.desc="Нет связи с торговым сервером";
         info.level=LEVEL_WARNING;
         break;
      case ERR_NOT_ENOUGH_RIGHTS:
         info.desc="Недостаточно прав";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TOO_FREQUENT_REQUESTS:
         info.desc="Слишком частые запросы";
         info.level=LEVEL_WARNING;
         break;
      case ERR_MALFUNCTIONAL_TRADE:
         info.desc="Недопустимая операция нарушающая функционирование сервера";
         info.level=LEVEL_WARNING;
         break;
      case ERR_ACCOUNT_DISABLED:
         info.desc="Счет заблокирован";
         info.level= LEVEL_ERROR;
         break;
      case ERR_INVALID_ACCOUNT:
         info.desc="Неправильный номер счета";
         info.level= LEVEL_WARNING;
         break;
      case ERR_TRADE_TIMEOUT:
         info.desc="Истек срок ожидания совершения сделки";
         info.level=LEVEL_WARNING;
         break;
      case ERR_INVALID_PRICE:
         info.desc="Неправильная цена";
         info.level= LEVEL_WARNING;
         break;
      case ERR_INVALID_STOPS:
         info.desc="Неправильные стопы";
         info.level= LEVEL_WARNING;
         break;
      case ERR_INVALID_TRADE_VOLUME:
         info.desc="Неправильный объем";
         info.level=LEVEL_WARNING;
         break;
      case ERR_MARKET_CLOSED:
         info.desc="Рынок закрыт";
         info.level=LEVEL_ERROR;
         break;
      case ERR_TRADE_DISABLED:
         info.desc="Торговля запрещена";
         info.level=LEVEL_ERROR;
         break;
      case ERR_NOT_ENOUGH_MONEY:
         info.desc="Недостаточно денег для совершения операции";
         info.level=LEVEL_ERROR;
         break;
      case ERR_PRICE_CHANGED:
         info.desc="Цена изменилась";
         info.level=LEVEL_WARNING;
         break;
      case ERR_OFF_QUOTES:
         info.desc="Нет цен";
         info.level=LEVEL_WARNING;
         break;
      case ERR_BROKER_BUSY:
         info.desc="Брокер занят";
         info.level=LEVEL_WARNING;
         break;
      case ERR_REQUOTE:
         info.desc="Новые цены";
         info.level=LEVEL_WARNING;
         break;
      case ERR_ORDER_LOCKED:
         info.desc="Ордер заблокирован и уже обрабатывается";
         info.level=LEVEL_WARNING;
         break;
      case ERR_LONG_POSITIONS_ONLY_ALLOWED:
         info.desc="Разрешена только покупка";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TOO_MANY_REQUESTS:
         info.desc="Слишком много запросов";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TRADE_MODIFY_DENIED:
         info.desc="Модификация запрещена, так как ордер слишком близок к рынку";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TRADE_CONTEXT_BUSY:
         info.desc="Подсистема торговли занята";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TRADE_EXPIRATION_DENIED:
         info.desc="Использование даты истечения ордера запрещено брокером";
         info.level=LEVEL_WARNING;
         break;
      case ERR_TRADE_TOO_MANY_ORDERS:
         info.desc="Количество открытых и отложенных ордеров достигло предела, установленного брокером.";
         info.level=LEVEL_ERROR;
         break;
      case ERR_TRADE_HEDGE_PROHIBITED:
         info.desc="Попытка открыть противоположную позицию к уже существующей в случае, если хеджирование запрещено";
         info.level=LEVEL_ERROR;
         break;
      case ERR_TRADE_PROHIBITED_BY_FIFO:
         info.desc="Попытка закрыть позицию по инструменту в противоречии с правилом FIFO";
         info.level=LEVEL_WARNING;
         break;
      //--- MQL4 run time error codes
      case ERR_TRADE_NOT_ALLOWED:
         info.desc="Торговля не разрешена. Необходимо включить опцию `Разрешить советнику торговать` в свойствах эксперта";
         info.level=LEVEL_WARNING;
         break;
      case ERR_LONGS_NOT_ALLOWED:
         info.desc="Ордера на покупку не разрешены. Необходимо проверить свойства эксперта";
         info.level=LEVEL_ERROR;
         break;
      case ERR_SHORTS_NOT_ALLOWED:
         info.desc="Ордера на продажу не разрешены. Необходимо проверить свойства эксперта";
         info.level=LEVEL_ERROR;
         break;
#endif
      //---  торговые
      case ERR_INVALID_ORDER_TYPE:
         info.desc="Неправильный тип ордера";
         info.level=LEVEL_ERROR;
         break;
      case ERR_INVALID_SYMBOL_NAME:
         info.desc="Неправильное имя инструмента";
         info.level=LEVEL_ERROR;
         break;
      case ERR_INVALID_EXPIRATION_TIME:
         info.desc="Неправильное время экспирации";
         info.level=LEVEL_ERROR;
         break;
      case ERR_ORDER_SELECT:
         info.desc="Ошибка функции OrderSelect()";
         info.level=LEVEL_ERROR;
         break;

      //---
      default:
         info.desc="Неизвестная ошибка "+IntegerToString(info.code);
         return(false);
      }
   }
   return(true);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string GetErrorDescription(const int _error_code,
                            ENUM_LANGUAGES _language=LANGUAGE_EN)
{
   ErrorInfo info;
   info.code=_error_code;
   info.lang=_language;

   GetErrorInfo(info);

   return(info.desc);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
ENUM_ERROR_LEVEL GetErrorLevel(const int _error_code)
{
   ErrorInfo info;
   info.code=_error_code;
   info.lang=ENGLISH;

   GetErrorInfo(info);
   return(info.level);
};
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|   ENUM_UPDATE_MODE                                               |
//+------------------------------------------------------------------+
enum ENUM_UPDATE_MODE
{
   UPDATE_FAST,   //Fast
   UPDATE_NORMAL, //Normal
   UPDATE_SLOW,   //Slow
};
//+------------------------------------------------------------------+
//|   ENUM_RUN_MODE                                                  |
//+------------------------------------------------------------------+
enum ENUM_RUN_MODE
{
   RUN_OPTIMIZATION,
   RUN_VISUAL,
   RUN_TESTER,
   RUN_LIVE
};
//+------------------------------------------------------------------+
//|   GetRunMode                                                     |
//+------------------------------------------------------------------+
ENUM_RUN_MODE GetRunMode(void)
{
   if(MQLInfoInteger(MQL_OPTIMIZATION))

      return(RUN_OPTIMIZATION);
   if(MQLInfoInteger(MQL_VISUAL_MODE))
      return(RUN_VISUAL);
   if(MQLInfoInteger(MQL_TESTER))
      return(RUN_TESTER);
   return(RUN_LIVE);
}
;


enum ENUM_ORDER_TYPES{ 
 
  OP_BUY1=1//BUY
 ,OP_BUYLIMIT1=2//BUY LIMIT
 ,OP_BUYSTOP1=3//BUY STOP
 ,OP_SELL1=4//SELL 
 ,OP_SELLLIMIT1=5//SELLLIMIT
 ,
 OP_SELLSTOP1=6//SELLSTOP
 };
 


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

//+------------------------------------------------------------------+
//|   PrintError                                                     |
//+------------------------------------------------------------------+
ENUM_ERROR_LEVEL PrintError(int _error_code,ENUM_LANGUAGES _lang=LANGUAGE_EN)
{
   ErrorInfo info;
   info.code=_error_code;
   info.lang=_lang;
//---
   GetErrorInfo(info);
//---
   if(_lang==LANGUAGE_RU)
      printf("Ошибка: %s",info.desc);
   else
      printf("Error: %s",info.desc);
//---
   return(info.level);
}

string msgs;

STRUCT_SYMBOL_SIGNAL ManualSignals[];

//+------------------------------------------------------------------+
//|   ErrorInfo                                                      |
//+------------------------------------------------------------------+


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
  
#include <DiscordTelegram/ccustomChat.mqh>
 