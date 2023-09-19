//+------------------------------------------------------------------+
//|                                            MySQLLoginRequest.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#include  <MySQL\MySQLPacketReader.mqh>
#include  <MySQL\MySQLGreeting.mqh>

//+------------------------------------------------------------------+
//| Form authorization request                                       |
//+------------------------------------------------------------------+
class CMySQLLoginRequest : public CMySQLGreeting
  {
private:
   //--- User name
   string            m_username;
   //--- Password as a string
   string            m_password;
   //--- Password as the uchar buffer
   uchar             m_pwd[];
   //--- Flags of client capabilities
   uint              m_client_capabilities;
   //--- Maximum packet length
   uint              m_max_packet;
   //--- Encoding
   uchar             m_charset;
   //--- Authentication method
   string            m_auth_plugin;
   //--- Scramble the password
   bool              ScramblePassword(uchar &pwd[], uchar &salt[], uchar &pwd_hash[]);
public:
                     CMySQLLoginRequest();
                    ~CMySQLLoginRequest();
   //--- Set username and password
   bool              SetLogin(string username,string password);
   //--- Build authorization request
   bool              BuildRequest(CData *data);
   //--- Set bit masks of client capabilities
   void              SetClientCapabilities(uint c) {m_client_capabilities=c;}
   //--- Set the maximum packet length
   void              SetMaxPacketSize(uint sz) {m_max_packet=sz;}
   //--- Set the encoding
   void              SetCharset(uchar ch) {m_charset=ch;}
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMySQLLoginRequest::CMySQLLoginRequest() : m_client_capabilities(0x005FA685),
   m_max_packet(0xFFFFFF),
   m_charset(0x08)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMySQLLoginRequest::~CMySQLLoginRequest()
  {
  }
//+------------------------------------------------------------------+
//| Build authorization request                                      |
//+------------------------------------------------------------------+
bool CMySQLLoginRequest::BuildRequest(CData *data)
  {
//--- Reserve a place for the header (place 4 zero bytes)
   data.Add(0x00,4);
//--- Place the parameters
   data+=ushort(m_client_capabilities&0xFFFF);
   data+=ushort((m_client_capabilities>>16)&0xFFFF);
   data+=m_max_packet;
   data+=m_charset;
//--- Add 23 zeros
   data.Add(0x00,23);
   data+=m_username;
   uchar scr_pwd[20];
//--- Scramble the password
   if(ScramblePassword(m_pwd,Salt,scr_pwd)==false)
      return false;
   data.Add(0x14,1);
   data+=scr_pwd;
   data+=AuthPlugin;
   data.Add(0x00,1);
//--- After all the data is placed, add the header
//--- The argument (the packet index) is always equal to one in this case
   data.AddHeader(1);
   return true;
  }
//+------------------------------------------------------------------+
//| Set username and password                                        |
//+------------------------------------------------------------------+
bool CMySQLLoginRequest::SetLogin(string username,string password)
  {
//--- Check username and password adequacy
   int pw_len = StringLen(password);
   if(pw_len==0 || StringLen(username)==0)
      return false;
   m_username = username;
   m_password = password;
//--- Convert the password into the uchar array
   if(StringToCharArray(password,m_pwd)==0)
      return false;
   if(ArrayResize(m_pwd,pw_len)!=pw_len)
      return false;
   return true;
  }
//+------------------------------------------------------------------+
//| Scramble the password                                            |
//+------------------------------------------------------------------+
bool CMySQLLoginRequest::ScramblePassword(uchar &pwd[], uchar &salt[], uchar &pwd_hash[])
  {
//--- Prepare the buffer of 20 zeros
   uchar key_buf[20];
   ArrayFill(key_buf,0,20,0);
//--- The feature of the CryptEncode function is that
//--- the buffer of zeros is passed for the CRYPT_HASH_SHA1 encryption method as the key[] argument
   uchar hash1[20];
   if(CryptEncode(CRYPT_HASH_SHA1,pwd,key_buf,hash1)!=20)
      return false;
   uchar hash2[20];
   if(CryptEncode(CRYPT_HASH_SHA1,hash1,key_buf,hash2)!=20)
      return false;
   uchar buffer[40];
   ArrayCopy(buffer,salt,0,0);
   ArrayCopy(buffer,hash2,20,0);
   uchar hash3[20];
   if(CryptEncode(CRYPT_HASH_SHA1,buffer,key_buf,hash3)!=20)
      return false;
   if(ArrayResize(pwd_hash,20)!=20)
      return false;
//--- XOR for hash4
   for(int i = 0; i < 20; i++)
      pwd_hash[i] = hash1[i] ^ hash3[i];
   return true;
  }
//+------------------------------------------------------------------+
