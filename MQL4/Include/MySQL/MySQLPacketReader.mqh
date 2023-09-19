//+------------------------------------------------------------------+
//|                                            MySQLPacketReader.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#include  <MySQL\MySQLPacket.mqh>

//--- Parsing error types
enum ENUM_PACKET_READER_ERROR
  {
   PACKET_READER_ERR_SUCCESS=0,
   PACKET_READER_ERR_OUT_OF_RANGE
  };

//+------------------------------------------------------------------+
//| Parse MySQL packets                                              |
//+------------------------------------------------------------------+
class CMySQLPacketReader
  {
private:
   //--- Parsing error
   ENUM_PACKET_READER_ERROR   m_error;
   //--- Read the variable of the specified size (len argument)
   ulong             read_val(CMySQLPacket *p,uint len);
   uint              read_val(uchar &buf[], uint len);
public:
                     CMySQLPacketReader();
                    ~CMySQLPacketReader();
   //--- Skip the specified number of bytes
   void              Dummy(CMySQLPacket *p,uint len);
   //--- Read the "salt" from the server greeting packet
   uchar             Salt(uchar &buf[],uchar start_pos,CMySQLPacket *p);
   //--- Read the one-byte modular variable
   uchar             Uint8(CMySQLPacket *p);
   //--- Read the two-byte modular variable
   ushort            Uint16(CMySQLPacket *p);
   //--- Read the four-byte modular variable
   uint              Uint32(CMySQLPacket *p);
   //--- Read the string variable
   string            String(CMySQLPacket *p);
   //--- Read the variable placed in the Data Field format
   long              GetDataFieldLen(CMySQLPacket *p);
   //--- Read the variable whose size is specified in the Data Field format
   int               GetDataField(uchar &buf[], CMySQLPacket *p);
   //--- Read the string whose size is specified in the Data Field format
   string            DfString(CMySQLPacket *p);
   //--- Read the total data size in the packet
   uint              TotalLength(uchar &buf[]);
   //--- Read the number of warnings and server states for Ok and End of file type packets
   ushort            Warnings(CMySQLPacket *p);
   ushort            ServerStatus(CMySQLPacket *p);
   //--- Read the number of strings affected by the previous operation (relevant for Ok type packets)
   ulong             AffectedRows(CMySQLPacket *p);
   //--- Read the error code from the Error type packet
   ushort            ErrorCode(CMySQLPacket *p);
   //--- Read the server message from the Error type packet
   string            ErrorMessage(CMySQLPacket *p);
   //--- Read the server message from the Ok type packet
   string            OkMessage(CMySQLPacket *p);
   //--- Reset the last parsing error
   void              ResetLastError(void) {m_error=PACKET_READER_ERR_SUCCESS;}
   //--- Receive the last parsing error
   ENUM_PACKET_READER_ERROR   GetLastError(void) {return m_error;}
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMySQLPacketReader::CMySQLPacketReader() : m_error(PACKET_READER_ERR_SUCCESS)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMySQLPacketReader::~CMySQLPacketReader()
  {
  }
//+------------------------------------------------------------------+
//| Read the total data size in the packet                           |
//+------------------------------------------------------------------+
uint CMySQLPacketReader::TotalLength(uchar &buf[])
  {
   return read_val(buf,3);
  }
//+------------------------------------------------------------------+
//| Read the number of warnings                                      |
//+------------------------------------------------------------------+
ushort CMySQLPacketReader::Warnings(CMySQLPacket *p)
  {
   if(p.type==MYSQL_PACKET_OK)
     {
      p.warnings = p.data[6];
      p.warnings<<= 8;
      p.warnings|= p.data[5];
      p.index+=2;
     }
   else
      if(p.type==MYSQL_PACKET_EOF)
        {
         p.warnings = p.data[2];
         p.warnings<<= 8;
         p.warnings|= p.data[1];
         p.index+=2;
        }
      else
         p.warnings=0;
   return p.warnings;
  }
//+------------------------------------------------------------------+
//| Read the bit mask of the server status                           |
//+------------------------------------------------------------------+
ushort CMySQLPacketReader::ServerStatus(CMySQLPacket *p)
  {
   if(p.type==MYSQL_PACKET_OK || p.type==MYSQL_PACKET_EOF)
     {
      p.server_status = p.data[4];
      p.server_status<<= 8;
      p.server_status|= p.data[3];
      p.index+=2;
     }
   else
      p.server_status=0;
   return p.server_status;
  }
//+------------------------------------------------------------------+
//| Read the number of affected strings                              |
//+------------------------------------------------------------------+
ulong CMySQLPacketReader::AffectedRows(CMySQLPacket *p)
  {
   if(p.type==MYSQL_PACKET_OK)
     {
      p.index = 1;
      p.affected_rows = GetDataFieldLen(p);
     }
   else
      p.affected_rows = 0;
   return p.affected_rows;
  }
//+------------------------------------------------------------------+
//| Read the error code returned by the server                       |
//+------------------------------------------------------------------+
ushort CMySQLPacketReader::ErrorCode(CMySQLPacket *p)
  {
   if(p.type==MYSQL_PACKET_ERROR)
     {
      p.error.code = p.data[2];
      p.error.code<<= 8;
      p.error.code|= p.data[1];
      p.index+=2;
     }
   else
      p.error.code=0;
   return p.error.code;
  }
//+------------------------------------------------------------------+
//| Read the message (for Error type packets)                        |
//+------------------------------------------------------------------+
string CMySQLPacketReader::ErrorMessage(CMySQLPacket *p)
  {
   if(p.data[3]=='#')
     {
      string s = CharArrayToString(p.data,4);
      p.error.sqlstate = uint(StringToInteger(StringSubstr(s,0,5)));
      p.error.message = StringSubstr(s,5);
     }
   else
     {
      p.error.sqlstate = 0;
      p.error.message = "";
     }
   return p.error.message;
  }
//+------------------------------------------------------------------+
//| Read the message (for Ok type packets)                           |
//+------------------------------------------------------------------+
string CMySQLPacketReader::OkMessage(CMySQLPacket *p)
  {
   p.message = DfString(p);
   return p.message;
  }
//+------------------------------------------------------------------+
//| Read the string variable                                         |
//+------------------------------------------------------------------+
string CMySQLPacketReader::String(CMySQLPacket *p)
  {
//  look for a string till the locking zero, shift 'index' in CMySQLPacket
   string s = CharArrayToString(p.data,p.index);
   p.index+= StringLen(s)+1;
   return s;
  }
//+------------------------------------------------------------------+
//| Read the variable placed in the Data Field format                |
//+------------------------------------------------------------------+
long CMySQLPacketReader::GetDataFieldLen(CMySQLPacket *p)
  {
   ulong len = 0;
   if(p.data[p.index]<251)
     {
      len = p.data[p.index];
      p.index++;
     }
   else
      if(p.data[p.index]==252)
        {
         len = p.data[p.index+2];
         len = (len<<8)|p.data[p.index+1];
         p.index+=3;
        }
      else
         if(p.data[p.index]==253)
           {
            len = p.data[p.index+3];
            len = (len<<8)|p.data[p.index+2];
            len = (len<<8)|p.data[p.index+1];
            p.index+=4;
           }
         else
            if(p.data[p.index]==254)
              {
               len = p.data[p.index+8];
               len = (len<<8)|p.data[p.index+7];
               len = (len<<8)|p.data[p.index+6];
               len = (len<<8)|p.data[p.index+5];
               len = (len<<8)|p.data[p.index+4];
               len = (len<<8)|p.data[p.index+3];
               len = (len<<8)|p.data[p.index+2];
               len = (len<<8)|p.data[p.index+1];
               p.index+=9;
              }
            else
              {
               //--- 251 code is NULL
               p.index+=1;
               return -1;
              }
   return long(len);
  }
//+---------------------------------------------------------------------+
//| Read the variable whose size is specified in the Data Field format  |
//+---------------------------------------------------------------------+
int CMySQLPacketReader::GetDataField(uchar &buf[], CMySQLPacket *p)
  {

   int len = int(GetDataFieldLen(p));
//--- If NULL is received
   if(len<0)
      return len;
   if(ArrayResize(buf,int(len))==len)
      ArrayCopy(buf,p.data,0,p.index,len);
   p.index+=len;
   return len;
  }
//+------------------------------------------------------------------+
//| Read the string whose size is specified in the Data Field format |
//+------------------------------------------------------------------+
string CMySQLPacketReader::DfString(CMySQLPacket *p)
  {
   uchar buf[];
   int len = GetDataField(buf,p);
//--- If NULL is received
   if(len<1)
      return "NULL";
   return CharArrayToString(buf);
  }
//+------------------------------------------------------------------+
//| Skip the specified number of bytes                               |
//+------------------------------------------------------------------+
void CMySQLPacketReader::Dummy(CMySQLPacket *p,uint len)
  {
   if(p.Size()<(p.index+len))
     {
      m_error = PACKET_READER_ERR_OUT_OF_RANGE;
      return;
     }
   p.index+=len;
  }
//+------------------------------------------------------------------+
//| Read the variable of the specified size from the MySQL packet    |
//+------------------------------------------------------------------+
ulong CMySQLPacketReader::read_val(CMySQLPacket *p,uint len)
  {
   if(p.Size()<(p.index+len))
     {
      m_error = PACKET_READER_ERR_OUT_OF_RANGE;
      return 0;
     }
   ulong tmp = 0;
   for(uint i=0; i<len; i++)
     {
      tmp<<=8;
      tmp|= p.data[p.index+len-i-1];
     }
   p.index+=len;
   return tmp;
  }
//+------------------------------------------------------------------+
//| Read the variable of the specified size from the buffer          |
//+------------------------------------------------------------------+
uint CMySQLPacketReader::read_val(uchar &buf[], uint len)
  {
   uint tmp = 0;
   for(uint i=0; i<len; i++)
     {
      tmp<<=8;
      tmp|= buf[len-i-1];
     }
   return tmp;
  }
//+------------------------------------------------------------------+
//| Read the one-byte modular variable                               |
//+------------------------------------------------------------------+
uchar CMySQLPacketReader::Uint8(CMySQLPacket *p)
  {
   return uchar(read_val(p,1));
  }
//+------------------------------------------------------------------+
//| Read the two-byte modular variable                               |
//+------------------------------------------------------------------+
ushort CMySQLPacketReader::Uint16(CMySQLPacket *p)
  {
   return ushort(read_val(p,2));
  }
//+------------------------------------------------------------------+
//| Read the four-byte modular variable                              |
//+------------------------------------------------------------------+
uint CMySQLPacketReader::Uint32(CMySQLPacket *p)
  {
   return uint(read_val(p,4));
  }
//+------------------------------------------------------------------+
//| Read the "salt" from the server greeting packet                  |
//+------------------------------------------------------------------+
uchar CMySQLPacketReader::Salt(uchar &buf[],uchar start_pos,CMySQLPacket *p)
  {
   uint sz = p.Size();
   uchar cnt = 0;
   for(uint i=p.index; i<sz; i++)
     {
      if(p.data[i]==0)
         break;
      buf[start_pos+cnt] = p.data[i];
      cnt++;
     }
   p.index+=cnt+1;
   return cnt;
  }
//+------------------------------------------------------------------+
