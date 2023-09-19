//+------------------------------------------------------------------+
//|                                                signals_to_db.mq5 |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+

#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"
#property script_show_inputs

input string   inp_server     = "127.0.0.1";          // MySQL server address
input uint     inp_port       = 3306;                 // TCP port
input string   inp_login      = "admin";              // Login
input string   inp_password   = "12345";              // Password
input string   inp_db         = "signals_mt5";        // Database name
input bool     inp_creating   = true;                 // Allow creating tables
input uint     inp_period     = 30;                   // Signal loading period
input bool     inp_notifications = true;              // Send error notifications

//--- Include MySQL transaction class
#include  <MySQL\MySQLTransaction.mqh>
CMySQLTransaction mysqlt;

//--- Structures of signal properties description for each type
struct STR_SIGNAL_BASE_DOUBLE
  {
   string                     name;
   ENUM_SIGNAL_BASE_DOUBLE    id;
  };
struct STR_SIGNAL_BASE_INTEGER
  {
   string                     name;
   ENUM_SIGNAL_BASE_INTEGER   id;
  };
struct STR_SIGNAL_BASE_DATETIME
  {
   string                     name;
   ENUM_SIGNAL_BASE_INTEGER   id;
  };
struct STR_SIGNAL_BASE_STRING
  {
   string                     name;
   ENUM_SIGNAL_BASE_STRING    id;
  };

//--- Arrays of structures of signal properties description for each type
const STR_SIGNAL_BASE_DOUBLE tab_signal_base_double[]=
  {
     {"Balance",    SIGNAL_BASE_BALANCE},
     {"Equity",     SIGNAL_BASE_EQUITY},
     {"Gain",       SIGNAL_BASE_GAIN},
     {"Drawdown",   SIGNAL_BASE_MAX_DRAWDOWN},
     {"Price",      SIGNAL_BASE_PRICE},
     {"ROI",        SIGNAL_BASE_ROI}
  };
const STR_SIGNAL_BASE_INTEGER tab_signal_base_integer[]=
  {
     {"Id",         SIGNAL_BASE_ID},
     {"Leverage",   SIGNAL_BASE_LEVERAGE},
     {"Pips",       SIGNAL_BASE_PIPS},
     {"Rating",     SIGNAL_BASE_RATING},
     {"Subscribers",SIGNAL_BASE_SUBSCRIBERS},
     {"Trades",     SIGNAL_BASE_TRADES},
     {"TradeMode",  SIGNAL_BASE_TRADE_MODE}
  };
const STR_SIGNAL_BASE_DATETIME tab_signal_base_datetime[]=
  {
     {"Published",  SIGNAL_BASE_DATE_PUBLISHED},
     {"Started",    SIGNAL_BASE_DATE_STARTED},
     {"Updated",    SIGNAL_BASE_DATE_UPDATED}
  };
const STR_SIGNAL_BASE_STRING tab_signal_base_string[]=
  {
     {"AuthorLogin",   SIGNAL_BASE_AUTHOR_LOGIN},
     {"Broker",        SIGNAL_BASE_BROKER},
     {"BrokerServer",  SIGNAL_BASE_BROKER_SERVER},
     {"Name",          SIGNAL_BASE_NAME},
     {"Currency",      SIGNAL_BASE_CURRENCY}
  };

//--- Structure for working with signal properties (reading, copying, comparing, etc.)
struct SignalProperties
  {
   //--- Property buffers
   double            props_double[6];
   long              props_int[7];
   datetime          props_datetime[3];
   string            props_str[5];
   //--- Read signal properties
   void              Read(void)
     {
      for(int i=0; i<6; i++)
         props_double[i] = SignalBaseGetDouble(ENUM_SIGNAL_BASE_DOUBLE(tab_signal_base_double[i].id));
      for(int i=0; i<7; i++)
         props_int[i] = SignalBaseGetInteger(ENUM_SIGNAL_BASE_INTEGER(tab_signal_base_integer[i].id));
      for(int i=0; i<3; i++)
         props_datetime[i] = datetime(SignalBaseGetInteger(ENUM_SIGNAL_BASE_INTEGER(tab_signal_base_datetime[i].id)));
      for(int i=0; i<5; i++)
         props_str[i] = SignalBaseGetString(ENUM_SIGNAL_BASE_STRING(tab_signal_base_string[i].id));
     }
   //--- Compare signal Id with the passed value
   bool              CompareId(long id)
     {
      if(id==props_int[0])
         return true;
      else
         return false;
     }
   //--- Compare signal property values with the ones passed via the link
   bool              Compare(SignalProperties &sig)
     {
      for(int i=0; i<6; i++)
        {
         if(props_double[i]!=sig.props_double[i])
            return false;
        }
      for(int i=0; i<7; i++)
        {
         if(props_int[i]!=sig.props_int[i])
            return false;
        }
      for(int i=0; i<3; i++)
        {
         if(props_datetime[i]!=sig.props_datetime[i])
            return false;
        }
      return true;
     }
   //--- Compare signal property values with the one located inside the passed buffer (search by Id)
   bool              Compare(SignalProperties &buf[])
     {
      int n = ArraySize(buf);
      for(int i=0; i<n; i++)
        {
         if(props_int[0]==buf[i].props_int[0])  // Id
            return Compare(buf[i]);
        }
      return false;
     }
  };

//+------------------------------------------------------------------+
//| Write signal properties to the database                          |
//+------------------------------------------------------------------+
bool  DB_Write(SignalProperties &sbuf[],string tab_name,datetime tc)
  {
//--- prepare a query
   string q = "insert ignore into `"+inp_db+"`.`"+tab_name+"` (";
   q+= "`TimeInsert`";
   for(int i=0; i<6; i++)
      q+= ",`"+tab_signal_base_double[i].name+"`";
   for(int i=0; i<7; i++)
      q+= ",`"+tab_signal_base_integer[i].name+"`";
   for(int i=0; i<3; i++)
      q+= ",`"+tab_signal_base_datetime[i].name+"`";
   for(int i=0; i<5; i++)
      q+= ",`"+tab_signal_base_string[i].name+"`";
   q+= ") values ";
   int sz = ArraySize(sbuf);
   for(int s=0; s<sz; s++)
     {
      q+=(s==0)?"(":",(";
      q+= "'"+DatetimeToMySQL(tc)+"'";
      for(int i=0; i<6; i++)
         q+= ",'"+DoubleToString(sbuf[s].props_double[i],4)+"'";
      for(int i=0; i<7; i++)
         q+= ",'"+IntegerToString(sbuf[s].props_int[i])+"'";
      for(int i=0; i<3; i++)
         q+= ",'"+DatetimeToMySQL(sbuf[s].props_datetime[i])+"'";
      for(int i=0; i<5; i++)
         q+= ",'"+sbuf[s].props_str[i]+"'";
      q+=")";
     }
//--- send a query
   if(mysqlt.Query(q)==false)
      return false;
//--- if the query is successful, get the pointer to it
   CMySQLResponse *r = mysqlt.Response(0);
   if(CheckPointer(r)==POINTER_INVALID)
      return false;
//--- the Ok type packet should be received as a response featuring the number of affected rows; display it
   if(r.Type()==MYSQL_RESPONSE_OK)
      Print("Added ",r.AffectedRows()," entries");
//
   return true;
  }

//+------------------------------------------------------------------+
//| Read signal properties from the database                         |
//+------------------------------------------------------------------+
bool  DB_Read(SignalProperties &sbuf[],string tab_name)
  {
//--- prepare a query
   string q="select * from `"+inp_db+"`.`"+tab_name+"` "+
            "where `TimeInsert`= ("+
            "select `TimeInsert` "+
            "from `"+inp_db+"`.`"+tab_name+"` order by `TimeInsert` desc limit 1)";
//--- send a query
   if(mysqlt.Query(q)==false)
      return false;
//--- if the query is successful, get the pointer to it
   CMySQLResponse *r = mysqlt.Response();
   if(CheckPointer(r)==POINTER_INVALID)
      return false;
//--- read the number of rows in the accepted response
   uint rows = r.Rows();
//--- prepare the array
   if(ArrayResize(sbuf,rows)!=rows)
      return false;
//--- read property values to the array
   for(uint n=0; n<rows; n++)
     {
      //--- read the pointer to the current row
      CMySQLRow *row = r.Row(n);
      if(CheckPointer(row)==POINTER_INVALID)
         return false;
      for(int i=0; i<6; i++)
        {
         if(row.Double(tab_signal_base_double[i].name,sbuf[n].props_double[i])==false)
            return false;
        }
      for(int i=0; i<7; i++)
        {
         if(row.Long(tab_signal_base_integer[i].name,sbuf[n].props_int[i])==false)
            return false;
        }
      for(int i=0; i<3; i++)
         sbuf[n].props_datetime[i] = MySQLToDatetime(row[tab_signal_base_datetime[i].name]);
      for(int i=0; i<5; i++)
         sbuf[n].props_str[i] = row[tab_signal_base_string[i].name];
     }
   return true;
  }

//+------------------------------------------------------------------+
//| Create the table                                                 |
//+------------------------------------------------------------------+
bool  DB_CteateTable(string name)
  {
//--- prepare a query
   string q="CREATE TABLE `"+inp_db+"`.`"+name+"` ("+
            "`PKey` 			   BIGINT(20) 	NOT NULL AUTO_INCREMENT,"+
            "`TimeInsert`     DATETIME    NOT NULL,"+
            "`Id`             INT(11)     NOT NULL,"+
            "`Name`           CHAR(50)    NOT NULL,"+
            "`AuthorLogin`    CHAR(50)    NOT NULL,"+
            "`Broker`         CHAR(50)    NOT NULL,"+
            "`BrokerServer`   CHAR(50)    NOT NULL,"+
            "`Balance`        DOUBLE      NOT NULL,"+
            "`Equity`         DOUBLE      NOT NULL,"+
            "`Gain`           DOUBLE      NOT NULL,"+
            "`Drawdown`       DOUBLE      NOT NULL,"+
            "`Price`          DOUBLE      NOT NULL,"+
            "`ROI`            DOUBLE      NOT NULL,"+
            "`Leverage`       INT(11)     NOT NULL,"+
            "`Pips`           INT(11)     NOT NULL,"+
            "`Rating`         INT(11)     NOT NULL,"+
            "`Subscribers`    INT(11)     NOT NULL,"+
            "`Trades`         INT(11)     NOT NULL,"+
            "`TradeMode`      INT(11)     NOT NULL,"+
            "`Published`      DATETIME    NOT NULL,"+
            "`Started`        DATETIME    NOT NULL,"+
            "`Updated`        DATETIME    NOT NULL,"+
            "`Currency`       CHAR(50)    NOT NULL,"+
            "PRIMARY KEY (`PKey`),"+
            "UNIQUE INDEX `TimeInsert_Id` (`TimeInsert`, `Id`),"+
            "INDEX `TimeInsert` (`TimeInsert`),"+
            "INDEX `Currency` (`Currency`, `TimeInsert`),"+
            "INDEX `Broker` (`Broker`, `TimeInsert`),"+
            "INDEX `AuthorLogin` (`AuthorLogin`, `TimeInsert`),"+
            "INDEX `Id` (`Id`, `TimeInsert`)"+
            ") COLLATE='utf8_general_ci' "+
            "ENGINE=InnoDB "+
            "ROW_FORMAT=DYNAMIC";
//--- send a query
   if(mysqlt.Query(q)==false)
      return false;
   return true;
  }

//+------------------------------------------------------------------+
//| Print to console and send notification                           |
//+------------------------------------------------------------------+
void PrintNotify(string text)
  {
//--- display in the console
   Print(text);
//--- send a notification
   if(inp_notifications==true)
     {
      static datetime ts = 0;       // last notification sending time
      static string prev_text = ""; // last notification text
      if(text!=prev_text || (text==prev_text && (TimeLocal()-ts)>=(3600*6)))
        {
         // identical notifications are sent one after another no more than once every 6 hours
         if(SendNotification(text)==true)
           {
            ts = TimeLocal();
            prev_text = text;
           }
        }
     }
  }

//+------------------------------------------------------------------+
//| Service program start function                                   |
//+------------------------------------------------------------------+
void OnStart()
  {
//--- Configure MySQL transaction class
   mysqlt.Config(inp_server,inp_port,inp_login,inp_password);
//--- Assign a name to the table
//--- to do this, get the trade server name
   string s = AccountInfoString(ACCOUNT_SERVER);
//--- replace the space, period and hyphen with underscores
   string ss[]= {" ",".","-"};
   for(int i=0; i<3; i++)
      StringReplace(s,ss[i],"_");
//--- assemble the table name using the server name and the trading account login
   string tab_name = s+"__"+IntegerToString(AccountInfoInteger(ACCOUNT_LOGIN));
//--- set all letters to lowercase
   StringToLower(tab_name);
//--- display the result in the console
   Print("Table name: ",tab_name);
//--- set the time label of the previous reading of signal properties
   datetime chk_ts = 0;
//--- Declare the buffer of signal properties
   SignalProperties sbuf[];
//--- Raise the data from the database to the buffer
   bool exit = false;
   if(DB_Read(sbuf,tab_name)==false)
     {
      //--- if the reading function returns an error,
      //--- the table is possibly missing
      if(mysqlt.GetServerError().code==ER_NO_SUCH_TABLE && inp_creating==true)
        {
         //--- if we need to create a table and this is allowed in the settings
         if(DB_CteateTable(tab_name)==false)
            exit=true;
        }
      else
         exit=true;
     }
//--- if reading has failed, display the error description and in the console and complete the work
   if(exit==true)
     {
      if(GetLastError()==(ERR_USER_ERROR_FIRST+MYSQL_ERR_SERVER_ERROR))
        {
         // in case of a server error
         Print("MySQL Server Error: ",mysqlt.GetServerError().code," (",mysqlt.GetServerError().message,")");
        }
      else
        {
         if(GetLastError()>=ERR_USER_ERROR_FIRST)
            Print("Transaction Error: ",EnumToString(ENUM_TRANSACTION_ERROR(GetLastError()-ERR_USER_ERROR_FIRST)));
         else
            Print("Error: ",GetLastError());
        }
      return;
     }
//--- Declare the temporary buffer of signal properties
//--- to read the current values to it and compare them with the main one to detect differences
   SignalProperties buf[];
//--- Main loop of the service operation
   do
     {
      if((TimeLocal()-chk_ts)<inp_period)
        {
         Sleep(1000);
         continue;
        }
      //--- it is time to read signal properties
      chk_ts = TimeLocal();
      //--- get the number of available signals in the terminal
      int total=SignalBaseTotal();
      //--- prepare the buffer for copying properties
      if(ArrayResize(buf,total)<total)
        {
         Print("ERROR resize buffer");
         continue;
        }
      bool newdata = false;
      //--- if the number of signals has changed, set the data update flag
      if(total!=ArraySize(sbuf))
         newdata = true;
      //--- copy signal properties to the temporary buffer
      for(int i=0; i<total; i++)
        {
         if(SignalBaseSelect(i)==false)
            continue;
         //--- read signal properties
         buf[i].Read();
         //--- if the data update flag is not set yet,
         //--- compare read signal properties with their previous values from the main buffer
         if(newdata==false)
           {
            if(buf[i].Compare(sbuf)==false)
               newdata = true;
           }
        }
      //--- if the data is updated, read the entire buffer to the database
      //--- thus, if properties of a signal from the buffer have been updated,
      //--- a slice of values of all signals' properties is written to the database
      if(newdata==true)
        {
         bool bypass = false;
         if(DB_Write(buf,tab_name,chk_ts)==false)
           {
            //--- if we need to create a table and this is allowed in the settings
            if(mysqlt.GetServerError().code==ER_NO_SUCH_TABLE && inp_creating==true)
              {
               if(DB_CteateTable(tab_name)==true)
                 {
                  //--- if the table is created successfully, send the data
                  if(DB_Write(buf,tab_name,chk_ts)==false)
                     bypass = true; // sending failed
                 }
               else
                  bypass = true; // failed to create the table
              }
            else
               bypass = true; // there is no table and it is not allowed to create one
           }
         if(bypass==true)
           {
            if(GetLastError()==(ERR_USER_ERROR_FIRST+MYSQL_ERR_SERVER_ERROR))
              {
               // in case of a server error
               PrintNotify("MySQL Server Error: "+IntegerToString(mysqlt.GetServerError().code)+" ("+mysqlt.GetServerError().message+")");
              }
            else
              {
               if(GetLastError()>=ERR_USER_ERROR_FIRST)
                  PrintNotify("Transaction Error: "+EnumToString(ENUM_TRANSACTION_ERROR(GetLastError()-ERR_USER_ERROR_FIRST)));
               else
                  PrintNotify("Error: "+IntegerToString(GetLastError()));
              }
            continue;
           }
        }
      else
         continue;
      //--- copy new values of signal properties from the temporary buffer to the main one
      if(ArrayResize(sbuf,total)<total)
        {
         Print("ERROR resize buffer");
         continue;
        }
      for(int i=0; i<total; i++)
         sbuf[i]=buf[i];
      //
     }
   while(!IsStopped());
  }
//+------------------------------------------------------------------+
