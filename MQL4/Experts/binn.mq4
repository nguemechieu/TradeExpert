#include <WinUser32.mqh>
#include <stdlib.mqh>
#include <crypto/Hashes/Hashes.mqh>
#include <crypto/Hashes/SHA256.mqh>

// Binance US API endpoint and your API key/secret
input string BinanceApiEndpoint = "https://api.binance.us";
input string BinanceApiKey = "YOUR_API_KEY_HERE";
input string BinanceApiSecret = "YOUR_API_SECRET_HERE";

// Function to send a signed GET request to Binance US API
string SendSignedRequest(string endpoint, string apiKey, string apiSecret)
{
   ulong timestamp = TimeCurrent();
   string query = "timestamp=" + IntegerToString(timestamp);
   string signature ="";// HmacEncode(HMAC_SHA256, apiSecret, query);
   string headers = "X-MBX-APIKEY: " + apiKey;
   string url = endpoint + "?" + query + "&signature=" + signature;
   char result[];string result_header;
   char data[];
   
   int res = WebRequest(
      "GET",
      url,
      headers,
    
      5000,data,
      result,
   
      result_header);
   return CharArrayToString(result,0,WHOLE_ARRAY);
}

// Function to compute HMAC-SHA256 signature
string HmacEncode(int algo, string key, string data)
{
   uchar keyBytes[];
   StringToCharArray(key, keyBytes);
   uchar dataBytes[];
   StringToCharArray(data, dataBytes);
   uchar hash[];
   HMACCreate(algo, keyBytes, 0, hash);
   HMACUpdate(hash, dataBytes, 0);
   string signature = HMACFinal(hash);
   StringToCharArray(signature, hash);
   string result = "";
   for (int i = 0; i < ArraySize(hash); i++)
   {
      result += StringFormat("%.2X", hash[i]);
   }
   return result;
}

// Function to parse JSON response and extract price
double ParseBinancePrice(string json)
{
   int start = StringFind(json, "\"lastPrice\":\"") + StringLen("\"lastPrice\":\"");
   int end = StringFind(json, "\"", start);
   string priceStr = StringSubstr(json, start, end - start);
   double price = StringToDouble(priceStr);
   return price;
}

// The main function
int start()
{
   string endpoint = BinanceApiEndpoint + "/api/v3/ticker/price?symbol=BTCUSD";
   string apiKey = BinanceApiKey;
   string apiSecret = BinanceApiSecret;
   string response = SendSignedRequest(endpoint, apiKey, apiSecret);
   
   if (StringLen(response) > 0)
   {
      double btcusdPrice = ParseBinancePrice(response);
      Print("BTCUSD Price: ", btcusdPrice);
   }
   else
   {
      Print("Failed to fetch data from Binance US API.");
   }
   
   return(0);
}