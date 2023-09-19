//+------------------------------------------------------------------+
//|                                                  MySQLPacket.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#include  <MySQL\MySQLPacketBase.mqh>


//+------------------------------------------------------------------+
//| MySQL packet                                                     |
//+------------------------------------------------------------------+
class CMySQLPacket : public CMySQLPacketBase
  {
public:
   //--- Packet index
   uchar                   number;
   //--- Amount of data
   uint                    total_length;
   //--- Data
   uchar                   data[];
   //--- Current byte index when reading
   uint                    index;
public:
                     CMySQLPacket();
                    ~CMySQLPacket();
   uint              Size(void) {return ArraySize(data);}
   void              Reset(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMySQLPacket::CMySQLPacket() :   number(0),
   total_length(0),
   index(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMySQLPacket::~CMySQLPacket()
  {
  }
//+------------------------------------------------------------------+
//| Initialize the empty packet                                      |
//+------------------------------------------------------------------+
void CMySQLPacket::Reset(void)
  {
   ArrayFree(data);
   index=0;
   total_length=0;
   number=0;
   warnings=0;
   server_status=0;
   affected_rows=0;
   message="";
   error.reset();
  }
//+------------------------------------------------------------------+
