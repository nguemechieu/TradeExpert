//+------------------------------------------------------------------+
//|                                                MySQLGreeting.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#include  <MySQL\MySQLPacketReader.mqh>

//+------------------------------------------------------------------+
//| Working with the MySQL server greeting                           |
//+------------------------------------------------------------------+
class CMySQLGreeting
  {
private:
   //--- Parameters:
   //--- Protocol version (always 10)
   uchar                m_protocol;
   //--- Server version
   string               m_version;
   //--- Thread ID
   uint                 m_thread_id;
   //--- Flags of the server capabilities
   uint                 m_server_capabilities;
   //--- Other
   uchar                m_server_language;
   uint                 m_server_status;
   uchar                m_auth_plugin_len;
   //--- Amount of "salt" bytes read at the moment
   uchar                m_salt_idx;
   //--- Parser class
   CMySQLPacketReader   reader;
public:
                     CMySQLGreeting();
                    ~CMySQLGreeting();
   //--- Read data from the received packet
   bool                 Read(CMySQLPacket *p);
protected:
   //--- "Salt"
   uchar                Salt[20];
   //--- Authentication method
   string               AuthPlugin;
public:
   //--- Methods for receiving parameters
   string               Version(void)                    {return m_version;}
   uint                 ThreadId(void)                   {return m_thread_id;}
   uint                 ServerCapabilities(void)         {return m_server_capabilities;}
   uchar                ServerLanguage(void)             {return m_server_language;}
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMySQLGreeting::CMySQLGreeting()
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMySQLGreeting::~CMySQLGreeting()
  {
  }
//+------------------------------------------------------------------+
//| Read data from the received packet                               |
//+------------------------------------------------------------------+
bool CMySQLGreeting::Read(CMySQLPacket *p)
  {
//--- Reset the last parser error
   reader.ResetLastError();
   m_salt_idx = 0;
//--- Read the parameters
   m_protocol              = reader.Uint8(p);
   m_version               = reader.String(p);
   m_thread_id             = reader.Uint32(p);
   m_salt_idx              = reader.Salt(Salt,m_salt_idx,p);
   uint capabilities_low   = reader.Uint16(p);
   m_server_language       = reader.Uint8(p);
   m_server_status         = reader.Uint16(p);
   m_server_capabilities   = reader.Uint16(p);
   m_server_capabilities   = (m_server_capabilities<<16)|capabilities_low;
   m_auth_plugin_len       = reader.Uint8(p);
//--- Skip 10 bytes   
   reader.Dummy(p,10);
   m_salt_idx              = reader.Salt(Salt,m_salt_idx,p);
   AuthPlugin              = reader.String(p);
//--- Make sure the parsing passed without errors
   if(reader.GetLastError()==0)
      return true;
   else
      return false;
  }
//+------------------------------------------------------------------+
