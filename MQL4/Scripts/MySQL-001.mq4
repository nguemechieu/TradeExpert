//+------------------------------------------------------------------+
//|                                                    MySQL-001.mq4 |
//|                                   Copyright 2014, Eugene Lugovoy |
//|                                        http://www.fxcodexlab.com |
//| Test connections to MySQL. Reaching limit (DEMO)                 |
//+------------------------------------------------------------------+
#property copyright "Copyright 2014, Eugene Lugovoy"
#property link      "http://www.fxcodexlab.com"
#property version   "1.00"
#property strict

#include <DiscordTelegram/MQLMySQL.mqh>

string INI;
input  string Host="db-servers.mysql.database.azure.com", User="bigbossmanager", Password="Noelm307#", Database="db", Socket;
input int Port=3306; // database credentials
input  int ClientFlag=0;
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
{

 int DB1,DB2,DB3; // database identifiers
 
 Print (MySqlVersion());
 INI = TerminalPath()+"\\MQL4\\Scripts\\MyConnection.ini";

 

 Print ("Host: ",Host, ", User: ", User, ", Database: ",Database);
 
 // open database connection
 Print ("Connecting...");
 
 DB1 = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
 
 if (DB1 == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB1);}
 
 DB2 = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
 
 if (DB2 == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB2);}

 DB3 = MySqlConnect(Host, User, Password, Database, Port, Socket, ClientFlag);
 
 if (DB3 == -1) { Print ("Connection failed! Error: "+MySqlErrorDescription); } else { Print ("Connected! DBID#",DB3);}
 
 MySqlDisconnect(DB3);
 MySqlDisconnect(DB2);
 MySqlDisconnect(DB1);
 Print ("All connections closed. Script done!");
   
}
//+------------------------------------------------------------------+
