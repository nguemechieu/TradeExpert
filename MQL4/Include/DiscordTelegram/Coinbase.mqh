//+------------------------------------------------------------------+
//|                                                     Coinbase.mqh |
//|                                 Copyright 2022, tradeexperts.org |
//|                       https://github.com/nguemechieu/TradeExpert |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, tradeexperts.org"
#property link      "https://github.com/nguemechieu/TradeExpert"
#property version   "1.00"
#property strict

#include <Arrays/List.mqh>

#include <jason.mqh>

#define coinbaseApiUrl "https://api.coinbase.com/v2/"
#define  urlSpotPrice "prices/"
   //GET SPOT PRICE        :prices/BTC-USD/spot"

class
Transactions{
Transactions();~Transactions();
};
Transactions::Transactions(){};
Transactions::~Transactions(){};

class Users{

private:
    long id;
    string name,username,profile_location,profile_bio,profile_url,avatar_url,resource,resource_path;
    
    
    
      string email,
    time_zone,native_currency,bitcoin_unit,country_code,country_name;datetime created_at;

    public :string getEmail() {
        return email;
    }

    public :void setEmail(string xemail) {
        this.email = xemail;
    }

    public: string getTime_zone() {
        return time_zone;
    }

    public: void setTime_zone(string xtime_zone) {
        this.time_zone = xtime_zone;
    }

    public :string getNative_currency() {
        return native_currency;
    }

    public :void setNative_currency(string xnative_currency) {
        this.native_currency = xnative_currency;
    }

    public: string getBitcoin_unit() {
        return bitcoin_unit;
    }

    public :void setBitcoin_unit(string xbitcoin_unit) {
        this.bitcoin_unit = xbitcoin_unit;
    }

    public: string getCountry_code() {
        return country_code;
    }

    public: void setCountry_code(string xcountry_code) {
        this.country_code = xcountry_code;
    }

    public: string getCountry_name() {
        return country_name;
    }

    public :void setCountry_name(string xcountry_name) {
        this.country_name = xcountry_name;
    }

    public :datetime getCreated_at() {
        return created_at;
    }

    public: void setCreated_at(datetime xcreated_at) {
        this.created_at = xcreated_at;
    }

    public: string toString() {
        return "Users{" +
                "email=" +(string) email +
                ", time_zone=" +(string) time_zone +
                ", native_currency=" +(string) native_currency +
                ", bitcoin_unit=" + (string)bitcoin_unit +
                ", country_code=" + (string)country_code +
                ", country_name=" + (string)country_name +
                ", created_at=" + (string)created_at +
                "}"
    ;}

  public :long getId() {
        return id;
    }

    public :void setId(long xid) {
        this.id = xid;
    }

    public :string getName() {
        return name;
    }

    public :void setName(string xname) {
        this.name = xname;
    }

    public: string getUsername() {
        return username;
    }

    public :void setUsername(string xusername) {
        this.username = xusername;
    }

    public :string getProfile_location() {
        return profile_location;
    }

    public :void setProfile_location(string xprofile_location) {
        this.profile_location = xprofile_location;
    }

    public :string getProfile_bio() {
        return profile_bio;
    }

    public :void setProfile_bio(string xprofile_bio) {
        this.profile_bio = xprofile_bio;
    }

    public: string getProfile_url() {
        return profile_url;
    }

    public: void setProfile_url(string xprofile_url) {
        this.profile_url = xprofile_url;
    }

    public :string getAvatar_url() {
        return avatar_url;
    }

    public :void setAvatar_url(string xavatar_url) {
        this.avatar_url = xavatar_url;
    }

    public: string getResource() {
        return resource;
    }

    public :void setResource(string xresource) {
        this.resource = xresource;
    }

    public: string getResource_path() {
        return resource_path;
    }

    public :void setResource_path(string xresource_path) {
        this.resource_path = xresource_path;
    }


    public: string toStrings() {
        return "Users{" +
                "id=" + (string)id +
                ", name=" + (string)name +
                ", username=" + (string)username +
                ", profile_location=" +(string) profile_location +
                ", profile_bio=" + (string)profile_bio +
                ", profile_url=" +(string) profile_url +
                ", avatar_url=" +(string) avatar_url +
                ", resource=" + (string)resource +
                ", resource_path=" + (string)resource_path +
                "}";
    }


Users();~Users();


};
Users::Users(){};
class Account {


private:
 long id;
    string name;
    string primary;
    
    int type;
    string currency;
    double balance;
    double amount;
    string created_at;
    string updated_at;
    string resource;
    string esource_path;

   public :long getId() {
        return id;
    }

    public :void setId(long xid) {
        this.id = xid;
    }

    public :string getName() {
        return name;
    }

    public :void setName(string xname) {
        this.name = xname;
    }

    public :string getPrimary() {
        return primary;
    }

    public :void setPrimary(string xprimary) {
        this.primary = xprimary;
    }

    public :int getType() {
        return type;
    }

    public :void setType(int xtype) {
        this.type = xtype;
    }

    public :string getCurrency() {
        return currency;
    }

    public :void setCurrency(string xcurrency) {
        this.currency = xcurrency;
    }

    public :double getBalance() {
        return balance;
    }

    public: void setBalance(double xbalance) {
        this.balance = xbalance;
    }

    public :double getAmount() {
        return amount;
    }

    public :void setAmount(double xamount) {
        this.amount = xamount;
    }

    public :string getCreated_at() {
        return created_at;
    }

    public :void setCreated_at(string xcreated_at) {
        this.created_at = xcreated_at;
    }

    public :string getUpdated_at() {
        return updated_at;
    }

    public: void setUpdated_at(string xupdated_at) {
        this.updated_at = xupdated_at;
    }

    public :string getResource() {
        return resource;
    }

    public :void setResource(string resourcex) {
        this.resource = resourcex;
    }

    public :string getEsource_path() {
        return esource_path;
    }

    public :void setEsource_path(string esource_pathx) {
        this.esource_path = esource_pathx;
    }



Account();~Account();




}
;

Account::Account(){};
Account::~Account(){};


class Deposit{
private:
long id;
string status;

string payment_method_id,
payment_method_resource,payment_method_resource_path;
long transaction;
string transaction_resource,transaction_resource_path;
double amount;

string amount_currency;
double subtotal;
string subtotal_currency;
string created_at,updated_at,resource,resource_path,committed;
double fee;
string fee_currency;
datetime payout_at;

    public: long getId() {
        return id;
    }


    public :string toString() {
        return "CBinance{" +
                "id=" + (string)id +
                ", status=" + (string)status +
                ", payment_method_id=" +(string) payment_method_id +
                ", transaction=" + (string)transaction +
         
                ", amount=" + (string)amount +
             
                ", subtotal=" + (string)subtotal +
                ", created_at=" +(string) created_at +
                ", updated_at=" +(string) updated_at +
                ", resource=" +(string) resource +
                ", resource_path=" + (string)resource_path +
                ", committed=" +(string) committed +
                ", fee=" + (string)fee +
                ", fee=" + (string)fee +
                ", payout_at=" + (string)payout_at +"}";
    }

    public :void setId(long idx) {
        this.id = idx;
    }

    public :string getStatus() {
        return status;
    }

    public: void setStatus(string statusx) {
        this.status = statusx;
    }

    public :string getPayment_method_id() {
        return payment_method_id;
    }

    public :void setPayment_method_id(string payment_method_idx) {
        this.payment_method_id = payment_method_idx;
    }

    public: long getTransaction() {
        return transaction;
    }

    public: void setTransaction(int transactionx) {
        this.transaction = transactionx;
    }

    public :double getAmount() {
        return amount;
    }

    public :void setAmount(double xamount) {
        this.amount = xamount;
    }

    public: double getSubtotal() {
        return subtotal;
    }

    public :void setSubtotal(double xsubtotal) {
        this.subtotal = xsubtotal;
    }

    public :string getCreated_at() {
        return created_at;
    }

    public: void setCreated_at(string xcreated_at) {
        this.created_at = xcreated_at;
    }

    public :string getUpdated_at() {
        return updated_at;
    }

    public: void setUpdated_at(string xupdated_at) {
        this.updated_at = xupdated_at;
    }

    public :string getResource() {
        return resource;
    }

    public :void setResource(string xresource) {
        this.resource = xresource;
    }

    public: string getResource_path() {
        return resource_path;
    }

    public :void setResource_path(string xresource_path) {
        this.resource_path = xresource_path;
    }

    public :string getCommitted() {
        return committed;
    }

    public :void setCommitted(string xcommitted) {
        this.committed = xcommitted;
    }

    public: double getFee() {
        return fee;
    }

    public :void setFee(double xfees) {
        this.fee = xfees;
    }

    public: datetime getPayout_at() {
        return payout_at;
    }

    public: void setPayout_at(datetime xpayout_at) {
        this.payout_at = xpayout_at;
    }


  

   

    public :void setTransaction(long transactions) {
        this.transaction = transactions;
    }


Deposit();~Deposit();


};

Deposit::Deposit(){};

Deposit::~Deposit(){};

class Address {
private:
  int  id;
    string address,name,created_at,updated_at,network,resource,resource_path;


    public :int getId() {
        return id;
    }

    public: void setId(int ids) {
        this.id = ids;
    }

    public :string getAddress() {
        return address;
    }

    public :void setAddress(string aaddress) {
        this.address = aaddress;
    }

    public :string getName() {
        return name;
    }

    public: void setName(string namex) {
        this.name = namex;
    }

    public :string getCreated_at() {
        return created_at;
    }

    public :void setCreated_at(string created_ats) {
        this.created_at = created_ats;
    }

    public :string getUpdated_at() {
        return updated_at;
    }

    public :void setUpdated_at(string updated_ats) {
        this.updated_at = updated_ats;
    }

    public :string getNetwork() {
        return network;
    }

    public :void setNetwork(string networkx) {
        this.network = networkx;
    }

    public :string getResource() {
        return resource;
    }

    public :void setResource(string resourcex) {
        this.resource = resourcex;
    }

    public :string getResource_path() {
        return resource_path;
    }

    public :void setResource_path(string resource_pathx) {
        this.resource_path = resource_pathx;
    }










Address();~Address();
};
Address::Address(){};
Address::~Address(){};

class CCoinbase : public CList
  {



private:
double price;
string currency;



public :string SendRequest(string method="GET",string paramsx="",string urlx=""){
      char resultx[],data[];
      string header;
      int res =WebRequest(method,urlx,"",paramsx,5000,data,0,resultx,header);
      
      if(res==200){
      printf( CharArrayToString(resultx,0,WHOLE_ARRAY));
       return CharArrayToString(resultx,0,WHOLE_ARRAY);     
      }else {
      
      
       if(res==-1)
         {
            return((string)_LastError);return((string)_LastError);
         }
         else
         {
            //--- HTTP errors
            if(res>=100 && res<=511)
            {
               string out2=CharArrayToString(resultx,0,WHOLE_ARRAY);
               Print(out2);
              return  (string )("ERR_HTTP_ERROR_FIRST "+(string)res);
            }
            return (string ) res;
         }
      
      return (string )res;
      } return (string ) res;
     }

 string serverDetails;

string GetServerDetails(){

return serverDetails;



}
//var buyPriceThreshold  = 200;
//var sellPriceThreshold = 500;
//
//client.getAccount('primary', function(err, account) {
//
//  client.getSellPrice({'currency': 'USD'}, function(err, sellPrice) {
//    if (parseFloat(sellPrice['amount']) <= sellPriceThreshold) {
//      account.sell({'amount': '1',
//                    'currency': 'BTC'}, function(err, sell) {
//        console.log(sell);
//      });
//    }
//  });
//
//  client.getBuyPrice({'currency': 'USD'}, function(err, buyPrice) {
//    if (parseFloat(buyPrice['amount']) <= buyPriceThreshold) {
//      account.buy({'amount': '1',
//                   'currency': 'BTC'}, function(err, buy) {
//        console.log(buy);
//      });
//    }
//  });
//
//});
 
 
 double GetLivepotPrice(string symbolx){
 

string outx;
 outx= SendRequest("GET","","https://api.coinbase.com/v2/prices/"+symbolx);
  CJAVal js(NULL,outx),items;
  printf(outx);
  js.Deserialize(outx);
  
  for(int jk=0;jk<ArraySize(js.m_e);jk++){
  
  items=js.m_e[jk];
  
    price=(double) items["amount"].ToDbl();
    currency=items["currency"].ToStr();
    string symbolf=items["base"].ToStr()+currency;
      Comment(symbolf+ currency+"  "+ (string)price); 
   
      
 printf(symbolf+"  "+ currency+"  "+(string)price); 
   
   
 
  if(symbolx==symbolf)return price;
  

   }
   return price;
   
   }
   

CCoinbase(){};~CCoinbase(){};
};