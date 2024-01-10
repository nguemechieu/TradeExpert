         //+------------------------------------------------------------------+
         //|                                                    BinanceUs.mqh |
         //|                                 Copyright 2022, tradeexperts.org |
         //|                       https://github.com/nguemechieu/TradeExpert |
         //+------------------------------------------------------------------+
         #property copyright "Copyright 2022, tradeexperts.org"
         #property link      "https://github.com/nguemechieu/TradeExpert"
         #property version   "1.00"
         #property strict
         #include <Arrays/List.mqh>
         
         #include <WinUser32.mqh>
                #include <Jason.mqh>

         // Binance US API endpoint and your API key/secret
        string BinanceApiEndpoint = "https://api.binance.us";
         input string BinanceApiKey = "Cq6ObijDDPlyyR18Ddgi4YJJsXzeFa3KM6cqouRwavymglwglOhRsgooGHKO4HfA";
         input string BinanceApiSecret = "YOUR_API_SECRET_HERE";
         
         
         
         
       enum TRADING_STATUS
       {PRE_TRADING,
   TRADING,
   POST_TRADING,
   END_OF_DAY,
   HALT,
   AUCTION_MATCH,
   BREAK,
   };
   enum SYMBOL_TYPE
      {
         LEVERAGE,
         SPOT
         ,DERIVATIVE
         };
         
         enum ORDER_STATUS{
       ACCEPTED,
   PARTIALLY_FILLED	,
   FILLED	,
   CANCELED	,
   PENDING_CANCEL,
   REJECTED,
   EXPIRED
         };
         
       
         class CBinanceUs : public CList
           {
         private:
         string  api_key;
          string api;
          string  username;
          string password;
          string token;
          string coin;
          string xsymbol;
          string balance;
          struct MARKET_DATA{
          
          string symbol;
          double open;
          double close;
          double high;
          double low;
          double volume;
          
          };
          
             string  recvWindow;
          long timestamp;
          
         double price;
         string side;
         int type;
         
          int quantity;
             string  timeInForce	;
             char data[];
             char resultx[];
             string header;
          
            string SendRequest(string method="POST",string paramsx="",string urlx=""){
            
            int res =WebRequest(method,urlx,"",paramsx,5000,data,0,resultx,header);
            
            if(res==200){
              return CharArrayToString(resultx,0,WHOLE_ARRAY);     
            }else{


                printf( CharArrayToString(resultx,0,WHOLE_ARRAY));
          

            }
            
            
             
            return  CharArrayToString(resultx,0,WHOLE_ARRAY);    
          
          
          
           }
      
       
   
                     
            public:double getPrice() {
              return price;
          }
      
          public :void setPrice(double xprice) {
              this.price = xprice;
          }
      
       public:   string getSide() {
              return side;
          }
      
          public :void setSide(string xside) {
              this.side = xside;
          }
      
          public :int getType() {
              return type;
          }
      
          public :void setType(int xtype) {
              this.type = xtype;
          }
      
          public :string getTimeInForce() {
              return timeInForce;
          }
      
          public :void setTimeInForce(string xtimeInForce) {
              this.timeInForce = xtimeInForce;
          }
      
          public: int getQuantity() {
              return quantity;
          }
      
          public :void setQuantity(int xquantity) {
              this.quantity = xquantity;
          }
      
          public :string getRecvWindow() {
              return recvWindow;
          }
      
          public :void setRecvWindow(string xrecvWindow) {
              this.recvWindow = xrecvWindow;
          }
      
          public :long getTimestamp() {
              return timestamp;
          }
      
          public :void setTimestamp(long xtimestamp) {
              this.timestamp = xtimestamp;
          }
      
      
      
              
          bool deposit(double amount){return false;};
         bool    withdraw(double amount){
              return false;
           }
                  
                   
       void wallet(double amounts){// operate wallet actions
                
                
                if(deposit(amounts)){
                printf("DEPOSIT SUCCESS!");
                }else   { printf("DEPOSIT FAILED!");}
                if(withdraw(amounts)){
                printf("WHITDRAWAL SUCCESS!");
                }else   { printf("WHITDRAWAL FAILED!");
                
                } 
                
                
                
         }       
      
      
      ////////////////// GET NETWORK CONNECTIVITIES ///////////////////////
      //------Use this endpoint to test connectivity to the exchange.
      //curl 'https://api.binance.us/api/v3/ping'
      
     string GetNetworkConnectivity(){
      
      const string urlNetwork=BinanceApiEndpoint+"/api/v3/ping";
      
      string messageNetwork="POOR NETWORK CONNECTIVITY";
      
            string requestResponses="";
        
        
      
       string method="GET";string paramsx="";string urlx="";
            
        int res =WebRequest(method,urlx,"",paramsx,5000,data,0,resultx,header);
        
            
          requestResponses= CharArrayToString(resultx,0,WHOLE_ARRAY);     
            
            
            
         printf( CharArrayToString(resultx,0,WHOLE_ARRAY));
          
   if(res==200){   
            
        CJAVal js(NULL,requestResponses),item;
        js.Deserialize(resultx);
        
        
        
        
    string ghd="{}";
        string anss;
        for(int jk=0;jk<ArraySize(js.m_e);jk++){
        
        item=js.m_e[jk];
      
                    anss=item["Parameters"].ToStr();
                 anss=item[""].ToStr();
                    
       }
           Alert("connectivity  " +    anss);
        if(anss==ghd){ printf("server GOOD CONNECTION");
        messageNetwork="server GOOD CONNECTION";
        
         return messageNetwork;
       }}
        
        return messageNetwork;
      }
      
      
      
      
   
      
      
      
      
      
      
      
      
      
      
      
      
      
      
                
         
      double GetLivePrice(string xxsymbol){//return live Market  prices
       
      string apiBinance=BinanceApiEndpoint+"/api/v3/trades?symbol="+xxsymbol;
      
       string outx;
       
       string query = "timestamp=" + IntegerToString(timestamp);
   string signature ="";// HmacEncode(HMAC_SHA256, apiSecret, query);
   
   
   
   string headers = "X-MBX-APIKEY: " + BinanceApiKey ;
   string url = BinanceApiEndpoint + "?" + query + "&signature=" + signature;
       
       outx= SendRequest("GET",headers ,apiBinance);
        CJAVal js(NULL,outx),item;
        
        js.Deserialize(resultx);
        int jk=0;
        while(jk<ArraySize(js.m_e)){
        
        item=js.m_e[jk];
        string symbolf=item["symbol"].ToStr();
        price=item["price"].ToDbl();
        printf(symbolf+"--"+(string)price);
   
        jk++
        ;
        
        }
         return price;
       
        }
                 
   bool CloseBinanceOrder(
    string xsymbols,     // Trading pair symbol (e.g., "BTCUSD")
    double orderId    // Order ID to be canceled
) {
    string endpoint = "https://api.binance.us/api/v3/order";
    
    // Construct the DELETE data as a JSON string
    string deleteData = StringFormat("{\"symbol\":\"%s\",\"orderId\":%.0f}", xsymbols, orderId);
    
    string headers = "X-MBX-APIKEY: YOUR_API_KEY_HERE"; // Replace with your Binance US API key
   char result[];
    string result_header="";
 
    int res = WebRequest("DELETE", endpoint,deleteData,headers, 5000,data,0, result, result_header);
    
    if (res == 200) {
        return true;
    }
    
    Print("Failed to close order. HTTP Error Code: ", res);
    return false;
}
        
        
        
      bool OpenBinanceOrder(
    string xsymbols,           // Trading pair symbol (e.g., "BTCUSD")
    ENUM_ORDER_TYPE orderType, // Order type (e.g., OP_BUY or OP_SELL)
    double xquantity,         // Order quantity
    double xprice,            // Order price
    datetime  validity, // Order validity (e.g., ORDER_GTC for "Good 'Til Cancelled")
    int orderId          // Variable to store the order ID
) {
    string endpoint = BinanceApiEndpoint+"/api/v3/order";
 
    
    // Construct the POST data as a JSON string
    string postData = StringFormat(
        "{\"symbol\":\"%s\",\"side\":\"%s\",\"type\":\"%s\",\"quantity\":%.6f,\"price\":%.6f,\"timeInForce\":\"%s\"}",
        xsymbols, (orderType == OP_BUY) ? "BUY" : "SELL", "LIMIT", xquantity, xprice, validity
    );
    
    string headers = "X-MBX-APIKEY: YOUR_API_KEY_HERE"; // Replace with your Binance US API key
    char results[];
    string result_header="";char postData2[];
    
    int res = WebRequest("POST", endpoint,postData,headers, 5000,postData2,0,results,result_header);
    
    if (res == 200) {
        // Parse the response to get the order ID
        string orderIdStr = StringSubstr(CharArrayToString(results,0,WHOLE_ARRAY), StringFind(CharArrayToString(results,0,WHOLE_ARRAY), "\"orderId\":") + StringLen("\"orderId\":"), -1);
        orderIdStr = StringSubstr(orderIdStr, 0, StringFind(orderIdStr, ",") - 1);
        orderId = (int)StringToDouble(orderIdStr);
        return true;
    }
    
    Print("Failed to open order. HTTP Error Code: ", res);
    return false;
}  
        
        
        
        
        
        
        
        
        
        
        
        
        
        
       bool OrderClosePrices(){
              
              
              
              
              
              
              
              
              return false;
              
              }    
                 
                   
                   
                   
      bool OrderOpenPrices(){
              
              
              
              
              
              
              
              
              return false;
              
              }    
                 
                   
       bool OpenPendingOrder(){
              
              
              
              
              
              
              
              
              return false;
              
              }    
                 
                   
      bool OpenLimitOrder(){
              
              
              
              
              
              
              
              
              return false;
              
              }    
             bool OpenStopOrder(){
            
              return false;
              
              }    
                  
                        
                   
                   
                   
            
      
          public :string getApi_key() {
              return api_key;
          }
      
          void setApi_key(string xapi_key) {
              this.api_key = xapi_key;
          }
      
          public: string getApi() {
              return api;
          }
      
               void setApi(string apix) {
              this.api = apix;
          }
      
           string getUsername() {
              return username;
          }
      
           void setUsername(string usernamec) {
              this.username = usernamec;
          }
      
          public: string getPassword() {
              return password;
          }
      
          public: void setPassword(string passwordc) {
              this.password = passwordc;
          }
      
          public :string getToken() {
              return token;
          }
      
          public :void setToken(string tokenc) {
              this.token = tokenc;
          }
      
          public :string getCoin() {
              return coin;
          }
      
          public :void setCoin(string coinx) {
              this.coin = coinx;
          }
      
          public :string getSymbol() {
              return xsymbol;
          }
      
          public :void setSymbol(string symbolx) {
              this.xsymbol = symbolx;
          }
      
          public :string getBalance() {
              return balance;
          }
      
          public :void setBalance(string balancex) {
              this.balance = balancex;
          }
      
             
                   
  
      
// Function to send a GET request to the Binance US API
public:
  
  string SendRequests(string url,string method="GET") {
   char result[];
   string result_head="";
 
   string headers="";
   int res = WebRequest(method, url ,headers, 5000, data,result, result_head);
   if (res == 200) {
      return CharArrayToString(result,0,WHOLE_ARRAY);
   } else {
      Print("Failed to retrieve data. HTTP Error Code: ", res);
      return "";
   }
}


// Function to parse JSON response and extract trading pairs
void ParseTradingPairs(string json) {
   int ops=FileOpen("\\Files\\tradepair.csv",FILE_READ||FILE_WRITE||FILE_CSV||FILE_BIN);
    
   
   int start0 = StringFind(json, "\"symbol\":\"") + StringLen("\"symbol\":\"");
   while (start0 > 0) {
      int end = StringFind(json, "\"", start0);
      string tradingPair = StringSubstr(json, start0, end - start0);
      Print("Trading Pair: ", tradingPair);
   
  
      int i=0;i++;
      ArrayResize(tradePairs,i,0);
   
    
      FileWrite(ops,"SYMBOLS");
      
      
            FileWrite(ops,tradingPair);
            tradePairs[i]=tradingPair;
       FileClose(ops);
      start0 = StringFind(json, "\"symbol\":\"", end) + StringLen("\"symbol\":\"");
      
   
   }
   
}

string tradePairs[];
void ReadCSVAndExtractPairs(string fileName) { int t=0;
   // Open the .csv file for reading
   int fileHandle = FileOpen(fileName, FILE_CSV ||FILE_READ||FILE_SHARE_READ);
   
   if (fileHandle != INVALID_HANDLE) {
      string line="";
      ushort delimiter = ','; // Assuming a comma is used as a delimiter in the .csv file
      
      // Read and process each line in the .csv file
      while (!FileIsEnding(fileHandle)) {
         // Read a line from the .csv file
        line= FileReadString(fileHandle,0);
         
         // Split the line into fields using the specified delimiter
         string fields[];
         StringSplit(line,delimiter, fields);
         
         // Assuming the trading pair is in the first column (index 0)
         string tradingPair = fields[0];
         
         // Print the trading pair (you can modify this part for your specific use case)
         Print("Trading Pair: ", tradingPair);
         
        
      
         
         tradePairs[t]=tradingPair;
            t++;
         
      }
      
      // Close the file
      FileClose(fileHandle);
   } else {
      Print("Failed to open the .csv file for reading.");
   }
}

        
// The main function
public:int getTradingPairs (){
   string binanceApiEndpoint =BinanceApiEndpoint+ "/api/v3/exchangeInfo";
   string response = SendRequests(binanceApiEndpoint,"GET");
   
   if (StringLen(response) > 0) {
      ParseTradingPairs(response);
   
  
   }
   return StringLen(response);
   }
            
                   
    // Define a custom function to fetch candlestick data from Binance US
bool FetchBinanceCandleData(
       // Trading pair symbol (e.g., "BTCUSD")
    ENUM_TIMEFRAMES timeframe,  // Timeframe (e.g., PERIOD_M1 for 1-minute candles)
    datetime startTime,   // Start time of the data range
    datetime endTime,     // End time of the data range
    int limit,            // Maximum number of candles to fetch (max 1000)
    MqlRates &candles[]  // Array to store candlestick data
) {
    string url = StringFormat("https://api.binance.us/api/v3/klines?symbol=%s&interval=%s&startTime=%lld&endTime=%lld&limit=%d",
                               xsymbol, EnumToString(timeframe), startTime, endTime, limit);
                               
     char resultxx[];
     
     char dat[];

    string response="";
    int res =WebRequest("GET", url, "", "", 5000,dat,0,resultxx, response);



    if (res == 200) {
        int totalCandles = ArraySize(resultxx);
        if (totalCandles%6== 0) {
            ArrayResize(dat, totalCandles / 6);
            return true;
        }
    }
    return false;
}

// Example usage:
void OnCandle() {
  string xsymbols = "BTCUSD";              // Trading pair symbol
    ENUM_TIMEFRAMES timeframe = PERIOD_M1; // 1-minute candles
    datetime startTime = D'2023.01.01';   // Start date and time
    datetime endTime = D'2023.01.02';     // End date and time
    int limit = 100;                      // Maximum number of candles
    MqlRates candles[];
    if (FetchBinanceCandleData(timeframe, startTime, endTime, limit,candles)) {
        // Candles fetched successfully, you can process the data here
        for (int i = 0; i < ArraySize(candles); i++) {
            Print("Time: ", TimeToString(candles[i].time, TIME_DATE|TIME_MINUTES), 
                  " Open: ", candles[i].open, 
                  " High: ", candles[i].high,
                  " Low: ", candles[i].low,
                  " Close: ", candles[i].close,
                  " Volume: ", candles[i].tick_volume);
        }
        
        
    } else {
        Print("Failed to fetch candle data from Binance US.");
    }
}               
               CBinanceUs();
                             ~CBinanceUs();      
                   
                   
                   
                             
                             
           };
         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         CBinanceUs::CBinanceUs()
           {
           }
         //+------------------------------------------------------------------+
         //|                                                                  |
         //+------------------------------------------------------------------+
         CBinanceUs::~CBinanceUs()
           {
           }
         //+------------------------------------------------------------------+
