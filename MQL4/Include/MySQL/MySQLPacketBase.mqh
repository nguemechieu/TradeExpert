//+------------------------------------------------------------------+
//|                                              MySQLPacketBase.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#include  <MySQL\Data.mqh>

//--- Packet types
enum ENUM_PACKET_TYPE
  {
   MYSQL_PACKET_NONE=0,    // None
   MYSQL_PACKET_DATA,      // Data
   MYSQL_PACKET_EOF,       // End of file
   MYSQL_PACKET_OK,        // Ok
   MYSQL_PACKET_GREETING,  // Greeting
   MYSQL_PACKET_ERROR      // Error
  };

//--- Structure of the error obtained from the MySQL server
struct MySQLServerError
  {
   ushort            code;
   uint              sqlstate;
   string            message;
   void              reset(void)
     {
      code = 0;
      message = "";
      sqlstate = 0;
     }
  };

//+------------------------------------------------------------------+
//| MySQL packet base class                                          |
//+------------------------------------------------------------------+
class CMySQLPacketBase
  {
private:

public:
   //--- Packet type
   ENUM_PACKET_TYPE        type;
   //--- Used only for Error type packets:
   MySQLServerError        error;
   //--- Used only for Ok and EOF type packets:
   ushort                  warnings;
   ushort                  server_status;
   //--- Used only for Ok type packets:
   ulong                   affected_rows;
   ulong                   last_id;
   string                  message;
                     CMySQLPacketBase();
                    ~CMySQLPacketBase();
   //--- Copy data from the packet passed by the pointer
   void              Copy(CMySQLPacketBase *p);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMySQLPacketBase::CMySQLPacketBase() : type(MYSQL_PACKET_NONE),
   warnings(0),
   server_status(0),
   affected_rows(0),
   last_id(0),
   message("")
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMySQLPacketBase::~CMySQLPacketBase()
  {
  }
//+------------------------------------------------------------------+
//| Copy data from the packet passed by the pointer                  |
//+------------------------------------------------------------------+
void CMySQLPacketBase::Copy(CMySQLPacketBase *p)
  {
   type           = p.type;
   error          = p.error;
   warnings       = p.warnings;
   server_status  = p.server_status;
   affected_rows  = p.affected_rows;
   last_id        = p.last_id;
   message        = p.message;
  }
//+------------------------------------------------------------------+
