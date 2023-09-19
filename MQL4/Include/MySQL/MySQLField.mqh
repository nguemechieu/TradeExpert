//+------------------------------------------------------------------+
//|                                                   MySQLField.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#include  <MySQL/MySQLPacketReader.mqh>
#include  <MySQL/MySQLField.mqh>
//+------------------------------------------------------------------+
//| Parse field descriptions                                         |
//+------------------------------------------------------------------+
class CMySQLField
  {
private:

   //--- Field parameters
   string            m_catalog;
   string            m_database;
   string            m_table;
   string            m_original_table;
   string            m_name;
   string            m_original_name;
   ushort            m_charset;
   uint              m_length;
   uchar             m_type;
   ushort            m_flags;
   uchar             m_decimals;
   //--- Parser class
   CMySQLPacketReader   reader;
   enum ENUM_DATABASE_FIELD_TYPE {};
public:
                     CMySQLField();
                    ~CMySQLField();
   //--- Read data from the received packet
   bool              Read(CMySQLPacket *p);
   //--- Methods of obtaining field parameters
   string            Catalog(void)        {return m_catalog;}
   string            Database(void)       {return m_database;}
   string            Table(void)          {return m_table;}
   string            OriginalTable(void)  {return m_original_table;}
   string            Name(void)           {return m_name;}
   string            OriginalName(void)   {return m_original_name;}
   ushort            Charset(void)        {return m_charset;}
   uint              Length(void)         {return m_length;}
   uchar             Type(void)           {return m_type;}
   ushort            Flags(void)          {return m_flags;}
   uchar             Decimals(void)       {return m_decimals;}
   //--- Return the field type as the ENUM_DATABASE_FIELD_TYPE value
   ENUM_DATABASE_FIELD_TYPE   MQLType(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMySQLField::CMySQLField()
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMySQLField::~CMySQLField()
  {
  }
//+------------------------------------------------------------------+
//| Read data from the received packet                               |
//+------------------------------------------------------------------+
bool CMySQLField::Read(CMySQLPacket *p)
  {
//--- Reset the parser error
   reader.ResetLastError();
//--- Parse parameter values
   m_catalog = reader.DfString(p);
   m_database = reader.DfString(p);
   m_table = reader.DfString(p);
   m_original_table = reader.DfString(p);
   m_name = reader.DfString(p);
   m_original_name = reader.DfString(p);
//--- Skip one byte
   reader.Dummy(p,1);
   m_charset = reader.Uint16(p);
   m_length = reader.Uint32(p);
   m_type = reader.Uint8(p);
   m_flags = reader.Uint16(p);
   m_decimals = reader.Uint8(p);
//--- Make sure there are no errors
   if(reader.GetLastError()==0)
      return true;
   else
      return false;
  };
//+------------------------------------------------------------------+
//| Return the field type as the ENUM_DATABASE_FIELD_TYPE value      |
//+------------------------------------------------------------------+

ENUM_DATABASE_FIELD_TYPE CMySQLField::MQLType(void)
  {
   switch(m_type)
     {
      case 0x00:  // decimal
      case 0x04:  // float
      case 0x05:  // double
      case 0xf6:  // newdecimal
         return DATABASE_FIELD_TYPE_FLOAT;
      case 0x01:  // tiny
      case 0x02:  // short
      case 0x03:  // long
      case 0x08:  // longlong
      case 0x09:  // int24
      case 0x10:  // bit
      case 0x07:  // timestamp
      case 0x0c:  // datetime
         return DATABASE_FIELD_TYPE_INTEGER;
      case 0x0f:  // varchar
      case 0xfd:  // varstring
      case 0xfe:  // string
         return DATABASE_FIELD_TYPE_TEXT;
      case 0xfb:  // blob
         return DATABASE_FIELD_TYPE_BLOB;
      default:
         return DATABASE_FIELD_TYPE_INVALID;
     }
  }
//+------------------------------------------------------------------+
