//+------------------------------------------------------------------+
//|                                                MySQLResponse.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#include  <MySQL\MySQLField.mqh>
#include  <MySQL\MySQLRow.mqh>
#include  <MySQL\MySQLPacket.mqh>

#define MYSQL_ROWS_RESERVE_SIZE  500

//--- Current status
enum ENUM_PARSING_STATE
  {
   ST_PARSING_ERROR  =  -1,
   ST_PARSING_READY  =  0,
   ST_PARSING_FIELDS =  1,
   ST_PARSING_ROWS   =  2
  };

//--- Server response type
enum ENUM_RESPONSE_TYPE
  {
   MYSQL_RESPONSE_DATA, // Data
   MYSQL_RESPONSE_OK    // Ok
  };

//+------------------------------------------------------------------+
//| Get MySQL server response (data or Ok packet)                    |
//+------------------------------------------------------------------+
class CMySQLResponse
  {
private:
   //--- Response type: Data or Ok
   ENUM_RESPONSE_TYPE   m_type;
   //--- for the Data packet:
   ENUM_PARSING_STATE   m_parsing_state;     // what is parsed
   CMySQLField          m_fields[];          // field buffer
   uint                 m_number_of_fields;  // number of fields in the buffer
   CMySQLRow           *m_buf[];             // row buffer
   uint                 m_bufsize;           // number of rows in the buffer
   CMySQLPacketReader   reader;              // packet parser
   uint                 m_index;             // current row index during handling
   //--- for the Ok packet:
   CMySQLPacketBase    *m_ok;                // Ok packet class
public:
                     CMySQLResponse();
                    ~CMySQLResponse();
   //--- Get data
   ENUM_PARSING_STATE   operator+=(CMySQLPacket *p);
   //--- Server response type (data or Ok packet)
   ENUM_RESPONSE_TYPE   Type(void) {return m_type;}
   //--- Methods for the "Data" type packet:
   uint                 Fields(void) {return m_number_of_fields;} // get the number of fields
   CMySQLField         *Field(uint idx);                          // get the pointer to the field by index
   int                  Field(string name);                       // get the field index by name
   uint                 Rows(void) {return m_bufsize;}            // get the number of rows
   CMySQLRow           *Row(uint idx);                            // get the pointer to the row by index
   string               Value(uint row, uint col);                // get the value by row and field indices
   string               Value(uint row, string col_name);         // get the value by row index and field name
   //--- Read the values of the entire column to the array
   int                  ColumnToArray(string name,string &buf[]);
   int                  ColumnToArray(string name,int    &buf[],bool check_type);
   int                  ColumnToArray(string name,long   &buf[],bool check_type);
   int                  ColumnToArray(string name,double &buf[],bool check_type);
   //--- Methods for the Ok type packet:
   ulong                AffectedRows(void)   // get the number of rows affected by the last operation
     {               if(CheckPointer(m_ok)!=POINTER_INVALID)  return m_ok.affected_rows; else return 0;}
   ulong                LastId(void)         // get Last Insert Id
     {               if(CheckPointer(m_ok)!=POINTER_INVALID)  return m_ok.last_id;       else return 0;}
   ushort               ServerStatus(void)   // get the bit mask of the server status
     {               if(CheckPointer(m_ok)!=POINTER_INVALID)  return m_ok.server_status; else return 0;}
   ushort               Warnings(void)       // get the number of warnings
     {               if(CheckPointer(m_ok)!=POINTER_INVALID)  return m_ok.warnings;      else return 0;}
   string               Message(void)        // get the server text message
     {               if(CheckPointer(m_ok)!=POINTER_INVALID)  return m_ok.message;       else return "";}
   //--- Initialization
   void                 Reset(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMySQLResponse::CMySQLResponse() : m_type(MYSQL_RESPONSE_DATA),
   m_parsing_state(ST_PARSING_READY),
   m_index(0),
   m_bufsize(0),
   m_number_of_fields(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMySQLResponse::~CMySQLResponse()
  {
   Reset();
  }
//+------------------------------------------------------------------+
//| Get data                                                         |
//+------------------------------------------------------------------+
ENUM_PARSING_STATE CMySQLResponse::operator+=(CMySQLPacket *p)
  {
   if(p.type==MYSQL_PACKET_OK)
     {
      if(CheckPointer(m_ok)!=POINTER_DYNAMIC)
         m_ok = new CMySQLPacketBase;
      m_ok.Copy(p);
      m_type = MYSQL_RESPONSE_OK;
      m_parsing_state = ST_PARSING_READY;    // ready
     }
   else
      if(!m_number_of_fields && !m_bufsize)        // number of fields
        {
         m_number_of_fields = reader.Uint8(p);
         if(ArrayResize(m_fields,m_number_of_fields)!=m_number_of_fields)
            return ST_PARSING_ERROR;
         m_parsing_state = ST_PARSING_FIELDS;   // parse the column names
         m_index = 0;
        }
      else
         if(m_parsing_state==ST_PARSING_FIELDS)
           {
            if(p.type==MYSQL_PACKET_EOF)
              {
               m_parsing_state = ST_PARSING_ROWS;  // parse the rows
               m_bufsize = 0;
              }
            else
              {
               m_fields[m_index].Read(p);
               m_index++;
              }
           }
         else
            if(m_parsing_state==ST_PARSING_ROWS)
              {
               if(p.type==MYSQL_PACKET_EOF)
                 {
                  m_parsing_state = ST_PARSING_READY;    // ready
                 }
               else
                 {
                  uint sz = m_bufsize+1;
                  if(ArrayResize(m_buf,sz,MYSQL_ROWS_RESERVE_SIZE)!=sz)
                     return ST_PARSING_ERROR;
                  m_buf[m_bufsize] = new CMySQLRow(p,m_fields,m_number_of_fields);
                  if(CheckPointer(m_buf[m_bufsize])==POINTER_DYNAMIC)
                     m_bufsize++;
                 }
              }
   return m_parsing_state;
  }
//+------------------------------------------------------------------+
//| Get the pointer to the field class by index                      |
//+------------------------------------------------------------------+
CMySQLField *CMySQLResponse::Field(uint idx)
  {
   if(idx>=m_number_of_fields)
      return NULL;
   return &m_fields[idx];
  }
//+------------------------------------------------------------------+
//| Get the field index by name                                      |
//+------------------------------------------------------------------+
int CMySQLResponse::Field(string name)
  {
   int col = -1;
   for(uint i=0; i<m_number_of_fields; i++)
     {
      if(m_fields[i].Name()==name)
        {
         col = int(i);
         break;
        }
     }
   return col;
  }
//+------------------------------------------------------------------+
//| Get the pointer to the row class by index                        |
//+------------------------------------------------------------------+
CMySQLRow *CMySQLResponse::Row(uint idx)
  {
   if(m_type==MYSQL_RESPONSE_OK || idx>=m_bufsize)
      return NULL;
   return m_buf[idx];
  }
//+------------------------------------------------------------------+
//| Get the value by row and field indices                           |
//+------------------------------------------------------------------+
string CMySQLResponse::Value(uint row, uint col)
  {
   if(m_type==MYSQL_RESPONSE_OK || row>=m_bufsize || col>=m_number_of_fields)
      return("");
   return m_buf[row].Value(col);
  }
//+------------------------------------------------------------------+
//| Get the value by row index and field name                        |
//+------------------------------------------------------------------+
string CMySQLResponse::Value(uint row, string col_name)
  {
   if(m_type==MYSQL_RESPONSE_OK || row>=m_bufsize)
      return("");
   int col = Field(col_name);
   for(uint i=0; i<m_number_of_fields; i++)
     {
      if(m_fields[i].Name()==col_name)
        {
         col = int(i);
         break;
        }
     }
   if(col<0)
      return("");
   return m_buf[row].Value(col);
  }
//+------------------------------------------------------------------+
//| Initialization                                                   |
//+------------------------------------------------------------------+
void CMySQLResponse::Reset(void)
  {
   int sz = ArraySize(m_buf);
   for(int i=0; i<sz; i++)
     {
      if(CheckPointer(m_buf[i])==POINTER_DYNAMIC)
         delete m_buf[i];
     }
   ArrayFree(m_buf);
   m_bufsize = 0;
   ArrayFree(m_fields);
   m_number_of_fields = 0;
   m_type = MYSQL_RESPONSE_DATA;
   if(CheckPointer(m_ok)==POINTER_DYNAMIC)
      delete m_ok;
  }
//+------------------------------------------------------------------+
//| Read the values of the entire column to the string type array    |
//+------------------------------------------------------------------+
int CMySQLResponse::ColumnToArray(string name,string &buf[])
  {
   int idx = Field(name);
   if(ArrayResize(buf,m_bufsize)<int(m_bufsize))
      return -1;
   for(uint i=0; i<m_bufsize; i++)
      buf[i]=m_buf[i].Value(idx);
   return int(m_bufsize);
  }
//+------------------------------------------------------------------+
//| Read the values of the entire column to the int type array       |
//+------------------------------------------------------------------+
int CMySQLResponse::ColumnToArray(string name,int &buf[],bool check_type=true)
  {
   int idx = Field(name);
   if(ArrayResize(buf,m_bufsize)<int(m_bufsize))
      return -1;
   for(uint i=0; i<m_bufsize; i++)
     {
      if(check_type==true && m_buf[i].MQLType(idx)!=DATABASE_FIELD_TYPE_INTEGER)
         return -1;
      buf[i]=int(StringToInteger(m_buf[i].Value(idx)));
     }
   return int(m_bufsize);
  }
//+------------------------------------------------------------------+
//| Read the values of the entire column to the long type array      |
//+------------------------------------------------------------------+
int CMySQLResponse::ColumnToArray(string name,long &buf[],bool check_type=true)
  {
   int idx = Field(name);
   if(ArrayResize(buf,m_bufsize)<int(m_bufsize))
      return -1;
   for(uint i=0; i<m_bufsize; i++)
     {
      if(check_type==true && m_buf[i].MQLType(idx)!=DATABASE_FIELD_TYPE_INTEGER)
         return -1;
      buf[i]=StringToInteger(m_buf[i].Value(idx));
     }
   return int(m_bufsize);
  }
//+------------------------------------------------------------------+
//| Read the values of the entire column to the double type array    |
//+------------------------------------------------------------------+
int CMySQLResponse::ColumnToArray(string name,double &buf[],bool check_type=true)
  {
   int idx = Field(name);
   if(ArrayResize(buf,m_bufsize)<int(m_bufsize))
      return -1;
   for(uint i=0; i<m_bufsize; i++)
     {
      if(check_type==true && m_buf[i].MQLType(idx)!=DATABASE_FIELD_TYPE_FLOAT)
         return -1;
      buf[i]=StringToDouble(m_buf[i].Value(idx));
     }
   return int(m_bufsize);
  }
//+------------------------------------------------------------------+
