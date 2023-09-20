#include <WinUser32.mqh>
#include <stderror.mqh>

// Function to send a GET request to the Binance US API
string SendRequest(string url) {
   char result[];
   string result_head="";
   char data [];
   string headers="";
   int res = WebRequest("GET", url ,headers, 5000, data,result, result_head);
   if (res == 200) {
      return CharArrayToString(result,0,WHOLE_ARRAY);
   } else {
      Print("Failed to retrieve data. HTTP Error Code: ", res);
      return "";
   }
}

// Function to parse JSON response and extract trading pairs
void ParseTradingPairs(string json) {
   int start = StringFind(json, "\"symbol\":\"") + StringLen("\"symbol\":\"");
   while (start > 0) {
      int end = StringFind(json, "\"", start);
      string tradingPair = StringSubstr(json, start, end - start);
      Print("Trading Pair: ", tradingPair);
      start = StringFind(json, "\"symbol\":\"", end) + StringLen("\"symbol\":\"");
   }
}

// The main function
int starts() {
   string binanceApiEndpoint = "https://api.binance.us/api/v3/exchangeInfo";
   string response = SendRequest(binanceApiEndpoint);
   
   if (StringLen(response) > 0) {
      ParseTradingPairs(response);
   }
   
   return(0);
}