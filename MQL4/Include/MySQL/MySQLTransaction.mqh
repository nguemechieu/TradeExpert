//+------------------------------------------------------------------+
//|                                             MySQLTransaction.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#include  <MySQL\MySQLErrors.mqh>
#include  <MySQL\MySQLLoginRequest.mqh>
#include  <MySQL\MySQLResponse.mqh>

//--- Macro substitutions
#define MYSQL_RESPONSES_RESERVE_SIZE  10

//--- States
enum ENUM_TRANSACTION_STATE
  {
   MYSQL_TRANSACTION_ERROR=-1,         // Error
   MYSQL_TRANSACTION_IN_PROGRESS=0,    // In progress
   MYSQL_TRANSACTION_COMPLETE,         // Fully completed
   MYSQL_TRANSACTION_SUBQUERY_COMPLETE // Partially completed
  };

//--- Error types
enum ENUM_TRANSACTION_ERROR
  {
   MYSQL_ERR_SUCCESS=0,             // No errors
   MYSQL_ERR_GREETING_TIMEOUT,      // Server greeting waiting timeout
   MYSQL_ERR_AUTHORIZATION_TIMEOUT, // Timeout of waiting for a response to an authorization request
   MYSQL_ERR_PING_TIMEOUT,          // Ping timeout
   MYSQL_ERR_QUERY_TIMEOUT,         // Query timeout
   MYSQL_ERR_INTERNAL_ERROR,        // Internal error
   MYSQL_ERR_SERVER_ERROR           // MySQL server error
  };

//+------------------------------------------------------------------+
//| MySQL transaction class                                          |
//+------------------------------------------------------------------+
class CMySQLTransaction
  {
private:
   //--- Authorization data
   string            m_host;        // MySQL server IP address
   uint              m_port;        // TCP port
   string            m_user;        // User name
   string            m_password;    // Password
   //--- Timeouts
   uint              m_timeout;        // timeout of waiting for TCP data (ms)
   uint              m_timeout_conn;   // timeout of establishing a server connection
   //--- Keep Alive
   uint              m_keep_alive_tout;      // time(ms), after which the connection is closed; the value of 0 - Keep Alive is not used
   uint              m_ping_period;          // period of sending ping (in ms) in the Keep Alive mode
   bool              m_ping_before_query;    // send 'ping' before 'query' (this is reasonable in case of large ping sending periods)
   //--- Network
   int               m_socket;      // socket handle
   ulong             m_rx_counter;  // counter of bytes received
   ulong             m_tx_counter;  // counter of bytes passed
   //--- Timestamps
   ulong             m_dT;                   // last query time
   uint              m_last_resp_timestamp;  // last response time
   uint              m_last_ping_timestamp;  // last ping time
   //--- Server response
   CMySQLPacket      m_packet;      // accepted packet
   uchar             m_hdr[4];      // packet header
   uint              m_rcv_len;     // counter of packet header bytes
   //--- Transfer buffer
   CData             m_tx_buf;
   //--- Authorization request class
   CMySQLLoginRequest m_auth;
   //--- Server response buffer and its size
   CMySQLResponse    m_rbuf[];
   uint              m_responses;
   //--- Waiting and accepting data from the socket
   bool              ReceiveData(ushort error_code);
   //--- Handle received data
   ENUM_TRANSACTION_STATE  Incoming(uchar &data[], uint len);
   //--- Packet handlers for each type
   ENUM_TRANSACTION_STATE  PacketOkHandler(CMySQLPacket *p);
   ENUM_TRANSACTION_STATE  PacketGreetingHandler(CMySQLPacket *p);
   ENUM_TRANSACTION_STATE  PacketDataHandler(CMySQLPacket *p);
   ENUM_TRANSACTION_STATE  PacketEOFHandler(CMySQLPacket *p);
   ENUM_TRANSACTION_STATE  PacketErrorHandler(CMySQLPacket *p);
   //--- Miscellaneous
   bool              ping(void);                // send ping
   bool              query(string s);           // send a query
   bool              reset_rbuf(void);          // initialize the server response buffer
   uint              tick_diff(uint prev_ts);   // get the timestamp difference
   //--- Parser class
   CMySQLPacketReader   reader;
public:
                     CMySQLTransaction();
                    ~CMySQLTransaction();
   //--- Set connection parameters
   bool              Config(string host,uint port,string user,string password,uint keep_alive_tout);
   //--- Keep Alive mode
   void              KeepAliveTimeout(uint tout);                       // set timeout
   void              PingPeriod(uint period) {m_ping_period=period;}    // set ping period in seconds
   void              PingBeforeQuery(bool st) {m_ping_before_query=st;} // enable/disable ping before a query
   //--- Handle timer events (relevant when using Keep Alive)
   void              OnTimer(void);
   //--- Get the pointer to the class for working with authorization
   CMySQLLoginRequest *Handshake(void) {return &m_auth;}
   //--- Send a request
   bool              Query(string q);
   //--- Get the number of server responses
   uint              Responses(void) {return m_responses;}
   //--- Get the pointer to the server response by index
   CMySQLResponse    *Response(uint idx);
   CMySQLResponse    *Response(void) {return Response(0);}
   //--- Get the server error structure
   MySQLServerError  GetServerError(void) {return m_packet.error;}
   //--- Options
   ulong             RequestDuration(void) {return m_dT;}                     // get the last transaction duration
   ulong             RxBytesTotal(void) {return m_rx_counter;}                // get the number of received bytes
   ulong             TxBytesTotal(void) {return m_tx_counter;}                // get the number of passed bytes
   void              ResetBytesCounters(void) {m_rx_counter=0; m_tx_counter=0;} // reset the counters of received and passed bytes
  };

//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMySQLTransaction::CMySQLTransaction() : m_host("127.0.0.1"),
   m_port(3306),
   m_user("username"),
   m_password("12345"),
   m_timeout(2000),
   m_timeout_conn(1000),
   m_keep_alive_tout(60000),
   m_ping_period(10000),
   m_responses(0),
   m_rx_counter(0),
   m_tx_counter(0),
   m_socket(INVALID_HANDLE),
   m_ping_before_query(false)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMySQLTransaction::~CMySQLTransaction()
  {
   if(m_socket==INVALID_HANDLE)
      SocketClose(m_socket);
   ArrayFree(m_rbuf);
  }

//+------------------------------------------------------------------+
//| Set connection parameters                                        |
//+------------------------------------------------------------------+
bool CMySQLTransaction::Config(string host,uint port,string user,string password,uint keep_alive_tout=0)
  {
   m_host = host;
   m_port = port;
   m_user = user;
   m_password = password;
   m_keep_alive_tout = keep_alive_tout;
   return m_auth.SetLogin(m_user,m_password);
  }

//+------------------------------------------------------------------+
//| Handling timer events                                            |
//+------------------------------------------------------------------+
void CMySQLTransaction::OnTimer(void)
  {
//--- Exit if there are no open connections
   if(m_socket==INVALID_HANDLE)
      return;
//--- If there are open connections, then we are in the Keep Alive mode
//--- Check if it is time to close the connection
   if(tick_diff(m_last_resp_timestamp)>=m_keep_alive_tout)
     {
      SocketClose(m_socket);
      m_socket = INVALID_HANDLE;
      return;
     }
//--- If periodic ping sending is enabled
   if(m_ping_period>0)
     {
      //--- Check if it is time to send ping
      if(tick_diff(m_last_resp_timestamp)>=m_ping_period && tick_diff(m_last_ping_timestamp)>=m_ping_period)
        {
         int result = 0;
         do
           {
            ::ResetLastError();
            if(ping()==false)
               break;
            if(ReceiveData(MYSQL_ERR_PING_TIMEOUT)==false)
               break;
            m_last_ping_timestamp = GetTickCount();
            break;
           }
         while(!IsStopped());
         if(::GetLastError()!=ERR_SUCCESS)
           {
            if(m_socket!=INVALID_HANDLE)
              {
               SocketClose(m_socket);
               m_socket = INVALID_HANDLE;
              }
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Set a timeout for Keep Alive                                     |
//+------------------------------------------------------------------+
void CMySQLTransaction::KeepAliveTimeout(uint tout)
  {
//--- If a non-zero Keep Alive timeout has been set before that, while the new value is zero,
//--- close open connections if present
   if(m_keep_alive_tout>0 && !tout)
     {
      if(m_socket!=INVALID_HANDLE)
        {
         SocketClose(m_socket);
         m_socket = INVALID_HANDLE;
        }
     }
   m_keep_alive_tout = tout;
  }

//+------------------------------------------------------------------+
//| Data receipt                                                     |
//+------------------------------------------------------------------+
bool CMySQLTransaction::ReceiveData(ushort error_code=0)
  {
   char buf[];
   uint   timeout_check=GetTickCount()+m_timeout;
   do
     {
      //--- Get the amount of data that can be read from the socket
      uint len=SocketIsReadable(m_socket);
      if(len)
        {
         //--- Read data from the socket to the buffer
         int rsp_len=SocketRead(m_socket,buf,len,m_timeout);
         m_rx_counter+= rsp_len;
         //--- Send the buffer for handling
         ENUM_TRANSACTION_STATE res = Incoming(buf,rsp_len);
         //--- Get the result the following actions will depend on
         if(res==MYSQL_TRANSACTION_COMPLETE) // server response fully accepted
            return true;   // exit (successful)
         else
            if(res==MYSQL_TRANSACTION_ERROR) // error
              {
               if(m_packet.error.code)
                  SetUserError(MYSQL_ERR_SERVER_ERROR);
               else
                  SetUserError(MYSQL_ERR_INTERNAL_ERROR);
               return false;  // exit (error)
              }
         //--- In case of another result, continue waiting for data in the loop
        }
     }
   while(GetTickCount()<timeout_check && !IsStopped());
//--- If waiting for the completion of the server response receipt took longer than m_timeout,
//--- exit with the error
   SetUserError(error_code);
   return false;
  }

//+------------------------------------------------------------------+
//| Send a query                                                     |
//+------------------------------------------------------------------+
bool CMySQLTransaction::Query(string q)
  {
//--- Remember the transaction start timestamp
   ulong t0 = GetMicrosecondCount();
   do
     {
      ::ResetLastError();
      //--- Prepare the server response array
      if(reset_rbuf()==false)
        {
         SetUserError(MYSQL_ERR_INTERNAL_ERROR);
         break;
        }
      if(!m_keep_alive_tout || m_socket==INVALID_HANDLE)
        {
         //--- Get the socket handle
         m_socket=SocketCreate();
         if(m_socket==INVALID_HANDLE)
           {
            break;
           }
         //--- Establish connection
         if(SocketConnect(m_socket,m_host,m_port,m_timeout_conn)==false)
           {
            break;
           }
         m_tx_buf.Reset();
         //--- Get the server greeting
         if(ReceiveData(MYSQL_ERR_GREETING_TIMEOUT)==false)
            break;
         //--- Authorization
         uint len = m_tx_buf.Size();   // authorization data prepared in the buffer
         if(len>0)
           {
            if(SocketSend(m_socket,m_tx_buf.Buf,len)!=len)
              {
               break;
              }
            m_tx_counter+= len;
           }
         else
           {
            SetUserError(MYSQL_ERR_INTERNAL_ERROR);
            break;
           }
         if(ReceiveData(MYSQL_ERR_AUTHORIZATION_TIMEOUT)==false)
            break;
        }
      //--- Ping (if enabled)
      if(m_ping_before_query==true)
        {
         if(ping()==false)
            break;
         if(ReceiveData(MYSQL_ERR_PING_TIMEOUT)==false)
            break;
        }
      //--- Send a query
      if(query(q)==false)
         break;
      if(ReceiveData(MYSQL_ERR_QUERY_TIMEOUT)==false)
         break;
      m_last_resp_timestamp = GetTickCount();
      //---
      break;
     }
   while(!IsStopped());
//--- Close connection (if Keep Alive is not enabled)
   if(!m_keep_alive_tout)
     {
      if(m_socket!=INVALID_HANDLE)
         SocketClose(m_socket);
      m_socket = INVALID_HANDLE;
     }
//--- Define transaction duration
   m_dT = GetMicrosecondCount()-t0;
//--- Return the result
   if(::GetLastError()!=ERR_SUCCESS)
      return false;
   else
      return true;
  }

//+------------------------------------------------------------------+
//| Parse received data                                              |
//+------------------------------------------------------------------+
ENUM_TRANSACTION_STATE CMySQLTransaction::Incoming(uchar &data[], uint len)
  {
   int ptr=0; // index of the current byte in the 'data' buffer
   ENUM_TRANSACTION_STATE result=MYSQL_TRANSACTION_IN_PROGRESS; // result of handling accepted data
   while(len>0)
     {
      if(m_packet.total_length==0)
        {
         //--- If the amount of data in the packet is unknown
         while(m_rcv_len<4 && len>0)
           {
            m_hdr[m_rcv_len] = data[ptr];
            m_rcv_len++;
            ptr++;
            len--;
           }
         //--- Received the amount of data in the packet
         if(m_rcv_len==4)
           {
            //--- Reset error codes etc.
            m_packet.Reset();
            m_packet.total_length = reader.TotalLength(m_hdr);
            m_packet.number = m_hdr[3];
            //--- Length received, reset the counter of length bytes
            m_rcv_len = 0;
            //--- Highlight the buffer of a specified size
            if(ArrayResize(m_packet.data,m_packet.total_length)!=m_packet.total_length)
               return MYSQL_TRANSACTION_ERROR;  // internal error
           }
         else // if the amount of data is still not accepted
            return MYSQL_TRANSACTION_IN_PROGRESS;
        }
      //--- Collect packet data
      while(len>0 && m_rcv_len<m_packet.total_length)
        {
         m_packet.data[m_rcv_len] = data[ptr];
         m_rcv_len++;
         ptr++;
         len--;
        }
      //--- Make sure the package has been collected already
      if(m_rcv_len<m_packet.total_length)
         return MYSQL_TRANSACTION_IN_PROGRESS;
      //--- Handle received MySQL packet
      m_packet.index = 0;
      m_packet.type = MYSQL_PACKET_NONE;
      if(m_packet.total_length>0)
        {
         if(m_packet.data[0]==0)
           {
            //--- Ok packet
            m_packet.type = MYSQL_PACKET_OK;
            m_packet.index++;
            m_packet.affected_rows = reader.GetDataFieldLen(&m_packet);
            m_packet.last_id = reader.GetDataFieldLen(&m_packet);
            m_packet.server_status = reader.Uint16(&m_packet);
            m_packet.warnings = reader.Uint16(&m_packet);
            if(m_packet.index<m_packet.total_length)
               m_packet.message = reader.DfString(&m_packet);
            if((result = PacketOkHandler(&m_packet))==MYSQL_TRANSACTION_ERROR)
               break;
           }
         else
            if(m_packet.data[0]==0xfe)
              {
               //--- End Of File packet
               m_packet.type = MYSQL_PACKET_EOF;
               m_packet.index++;
               m_packet.warnings = reader.Uint16(&m_packet);
               m_packet.server_status = reader.Uint16(&m_packet);
               if((result = PacketEOFHandler(&m_packet))==MYSQL_TRANSACTION_ERROR)
                  break;
              }
            else
               if(m_packet.data[0]==0xff)
                 {
                  //--- Error packet
                  m_packet.type = MYSQL_PACKET_ERROR;
                  m_packet.index++;
                  m_packet.error.code = reader.Uint16(&m_packet);
                  if((result = PacketErrorHandler(&m_packet))==MYSQL_TRANSACTION_ERROR)
                     break;
                 }
               else
                  if(!m_packet.number && m_packet.data[0]==0x0a)
                    {
                     //--- Greeting packet
                     m_packet.type = MYSQL_PACKET_GREETING;
                     if((result = PacketGreetingHandler(&m_packet))==MYSQL_TRANSACTION_ERROR)
                        break;
                    }
                  else
                    {
                     //--- Data packet
                     m_packet.type = MYSQL_PACKET_DATA;
                     if((result = PacketDataHandler(&m_packet))==MYSQL_TRANSACTION_ERROR)
                        break;
                    }
        }
      m_rcv_len = 0;
      m_packet.total_length = 0;
     }
   return result;
  }

//+------------------------------------------------------------------+
//|Ok packet handler                                                 |
//+------------------------------------------------------------------+
ENUM_TRANSACTION_STATE CMySQLTransaction::PacketOkHandler(CMySQLPacket *p)
  {
//--- Pass the received packet to the current server response class
   m_rbuf[m_responses]+=p;
   m_responses++;
   if((p.server_status&(1<<3))>0)  // if more answers are expected
     {
      //--- Prepare a place in the buffer for the next response
      if(ArrayResize(m_rbuf,m_responses+1,MYSQL_RESPONSES_RESERVE_SIZE)!=(m_responses+1))
         return MYSQL_TRANSACTION_ERROR;  // internal error
      //--- Initialize the next response class
      m_rbuf[m_responses].Reset();
      return MYSQL_TRANSACTION_SUBQUERY_COMPLETE;   // there will be more answers
     }
   return MYSQL_TRANSACTION_COMPLETE;   // answer accepted (single or last in multi query)
  }

//+------------------------------------------------------------------+
//| Greeting packet handler                                          |
//+------------------------------------------------------------------+
ENUM_TRANSACTION_STATE CMySQLTransaction::PacketGreetingHandler(CMySQLPacket *p)
  {
   m_auth.Read(p);
   m_auth.BuildRequest(&m_tx_buf);
   return MYSQL_TRANSACTION_COMPLETE;
  }

//+------------------------------------------------------------------+
//| Data packet handler                                              |
//+------------------------------------------------------------------+
ENUM_TRANSACTION_STATE CMySQLTransaction::PacketDataHandler(CMySQLPacket *p)
  {
//--- Pass the received packet to the current server response class
   m_rbuf[m_responses]+=p;
   return MYSQL_TRANSACTION_IN_PROGRESS;
  }

//+------------------------------------------------------------------+
//| End of file packet handler                                       |
//+------------------------------------------------------------------+
ENUM_TRANSACTION_STATE CMySQLTransaction::PacketEOFHandler(CMySQLPacket *p)
  {
//--- Pass the received packet to the current server response class
   if((m_rbuf[m_responses]+=p)==ST_PARSING_READY)
     {
      m_responses++;
      if((p.server_status&0x08)>0)
        {
         if(ArrayResize(m_rbuf,m_responses+1,MYSQL_RESPONSES_RESERVE_SIZE)!=(m_responses+1))
            return MYSQL_TRANSACTION_ERROR;  // something is wrong
         m_rbuf[m_responses].Reset();
         return MYSQL_TRANSACTION_SUBQUERY_COMPLETE;   // there will be more answers
        }
      return MYSQL_TRANSACTION_COMPLETE;   // answer accepted (single or last in multi query)
     }
   return MYSQL_TRANSACTION_IN_PROGRESS;   // in progress
  }

//+------------------------------------------------------------------+
//| Error packet handler                                             |
//+------------------------------------------------------------------+
ENUM_TRANSACTION_STATE CMySQLTransaction::PacketErrorHandler(CMySQLPacket *p)
  {
   if(p.data[3]=='#')
     {
      string s = CharArrayToString(p.data,4);
      p.error.sqlstate = uint(StringToInteger(StringSubstr(s,0,5)));
      p.error.message = StringSubstr(s,5);
     }
   m_rcv_len = 0;
   m_packet.total_length = 0;
   return MYSQL_TRANSACTION_ERROR;
  }

//+------------------------------------------------------------------+
//| Get the pointer to the server response by index                  |
//+------------------------------------------------------------------+
CMySQLResponse *CMySQLTransaction::Response(uint idx)
  {
   if(idx>=m_responses)
      return NULL;
   return &m_rbuf[idx];
  }

//+------------------------------------------------------------------+
//| Form and send ping                                               |
//+------------------------------------------------------------------+
bool CMySQLTransaction::ping(void)
  {
   if(reset_rbuf()==false)
     {
      SetUserError(MYSQL_ERR_INTERNAL_ERROR);
      return false;
     }
//--- Prepare the output buffer
   m_tx_buf.Reset();
//--- Reserve a place for the packet header
   m_tx_buf.Add(0x00,4);
//--- Place the command code
   m_tx_buf+=uchar(0x0E);
//--- Form a header
   m_tx_buf.AddHeader(0);
   uint len = m_tx_buf.Size();
//--- Send a packet
   if(SocketSend(m_socket,m_tx_buf.Buf,len)!=len)
      return false;
   m_tx_counter+= len;
   return true;
  }

//+------------------------------------------------------------------+
//| Form and send a query                                            |
//+------------------------------------------------------------------+
bool CMySQLTransaction::query(string s)
  {
   if(reset_rbuf()==false)
     {
      SetUserError(MYSQL_ERR_INTERNAL_ERROR);
      return false;
     }
//--- Prepare the output buffer
   m_tx_buf.Reset();
//--- Reserve a place for the packet header
   m_tx_buf.Add(0x00,4);
//--- Place the command code
   m_tx_buf+=uchar(0x03);
//--- Add the query string
   m_tx_buf+=s;
//--- Form a header
   m_tx_buf.AddHeader(0);
   uint len = m_tx_buf.Size();
//--- Send a packet
   if(SocketSend(m_socket,m_tx_buf.Buf,len)!=len)
      return false;
   m_tx_counter+= len;
   return true;
  }

//+------------------------------------------------------------------+
//| Clear the server response buffer                                 |
//+------------------------------------------------------------------+
bool CMySQLTransaction::reset_rbuf(void)
  {
   for(uint i=0; i<m_responses; i++)
      m_rbuf[i].Reset();
   if(ArrayResize(m_rbuf,1,MYSQL_RESPONSES_RESERVE_SIZE)!=1)
     {
      return false;
     }
   m_responses = 0;
   m_rbuf[m_responses].Reset();
   return true;
  }

//+------------------------------------------------------------------+
//| Get the timestamp difference in milliseconds                     |
//+------------------------------------------------------------------+
uint CMySQLTransaction::tick_diff(uint prev_ts)
  {
   uint tc = GetTickCount();
   uint dT;
   if(tc>=prev_ts)
      dT = tc-prev_ts;
   else
      dT = UINT_MAX-tc+prev_ts;
   return dT;
  }

//+------------------------------------------------------------------+
//| Convert 'datetime' to the "YYYY-MM-DD HH:MM:SS" string           |
//+------------------------------------------------------------------+
string DatetimeToMySQL(datetime t)
  {
   MqlDateTime dt;
   if(TimeToStruct(t, dt)==false)
      return "";
   string s = IntegerToString(dt.year,4);
   s+="-"+IntegerToString(dt.mon,   2,'0');
   s+="-"+IntegerToString(dt.day,   2,'0');
   s+=" "+IntegerToString(dt.hour,  2,'0');
   s+=":"+IntegerToString(dt.min,   2,'0');
   s+=":"+IntegerToString(dt.sec,   2,'0');
   return s;
  }

//+------------------------------------------------------------------+
//| Convert the "YYYY-MM-DD HH:MM:SS" string to 'datetime'           |
//+------------------------------------------------------------------+
datetime MySQLToDatetime(string s)
  {
   ushort u_sep;
   string ss[], st[], sd[];
//---
   u_sep=StringGetCharacter(" ",0);
   int k=StringSplit(s,u_sep,ss);
   if(k!=2)
      return 0;
   u_sep=StringGetCharacter("-",0);
   k=StringSplit(ss[0],u_sep,sd);
   if(k!=3)
      return 0;
   u_sep=StringGetCharacter(":",0);
   k=StringSplit(ss[1],u_sep,st);
   if(k!=3)
      return 0;
//---
   MqlDateTime dt;
   dt.year = int(StringToInteger(sd[0]));
   dt.mon  = int(StringToInteger(sd[1]));
   dt.day  = int(StringToInteger(sd[2]));
   dt.hour = int(StringToInteger(st[0]));
   dt.min  = int(StringToInteger(st[1]));
   dt.sec  = int(StringToInteger(st[2]));
   return StructToTime(dt);
  }
//+------------------------------------------------------------------+
