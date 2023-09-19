//+------------------------------------------------------------------+
//|                                                     MySQLRow.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#include  <MySQL\MySQLPacketReader.mqh>
#include  <MySQL\MySQLField.mqh>

//--- Value structure
struct MySQLValue
  {
   CMySQLField       *fp;      // pointer to the appropriate field
   string            val;     // value in the form of a string
   bool              isnull;  // if the cell has the value of NULL
  };

//+------------------------------------------------------------------+
//| Row class                                                        |
//+------------------------------------------------------------------+
class CMySQLRow
  {
private:
   //--- Buffer of field values
   MySQLValue        m_buf[];
   uint              m_bufsize;
   //--- Parser class
   CMySQLPacketReader   reader;
   //--- Get the field index by name
   int               idx_by_name(string name);
public:
                     CMySQLRow(CMySQLPacket *p,CMySQLField &fields[],uint number_of_fields);
                    ~CMySQLRow();
   //--- Get the field name by index
   string            Value(uint idx);
   //--- Get the field value by name
   string            operator[](string name);
   //--- Get the field type as the ENUM_DATABASE_FIELD_TYPE value
   ENUM_DATABASE_FIELD_TYPE   MQLType(uint idx);
   ENUM_DATABASE_FIELD_TYPE   MQLType(string name);
   //--- Get the field value as a string
   bool              Text(uint field_idx,string &value);
   bool              Text(string field_name,string &value);
   //--- Get the int type value
   bool              Integer(uint field_idx,int &value);
   bool              Integer(string field_name,int &value);
   //--- Get the long type value
   bool              Long(uint field_idx,long &value);
   bool              Long(string field_name,long &value);
   //--- Get the double type value
   bool              Double(uint field_idx,double &value);
   bool              Double(string field_name,double &value);
   //--- Get the field value as an array
   bool              Blob(uint field_idx,uchar &value[]);
   bool              Blob(string field_name,uchar &value[]);
  };


//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMySQLRow::CMySQLRow(CMySQLPacket *p,CMySQLField &fields[],uint number_of_fields)
  {
   uchar buf[];
   ArrayResize(m_buf,number_of_fields);
   for(uint i=0; i<number_of_fields; i++)
     {
      m_buf[i].fp  = &fields[i];
      int len = reader.GetDataField(buf,p);
      if(len<0)
        {
         m_buf[i].isnull = true;
         m_buf[i].val = "";
        }
      else
        {
         m_buf[i].isnull = false;
         m_buf[i].val = CharArrayToString(buf);
        }
     }
   m_bufsize = number_of_fields;
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMySQLRow::~CMySQLRow()
  {
  }
//+------------------------------------------------------------------+
//| Get the field value by index                                     |
//+------------------------------------------------------------------+
string CMySQLRow::Value(uint idx)
  {
   if(idx>=m_bufsize)
      return "";
   return m_buf[idx].val;
  }
//+------------------------------------------------------------------+
//| Get the field index by name                                      |
//+------------------------------------------------------------------+
int CMySQLRow::idx_by_name(string name)
  {
   for(uint i=0; i<m_bufsize; i++)
     {
      if(m_buf[i].fp.Name()==name)
         return int(i);
     }
   return -1;
  }
//+------------------------------------------------------------------+
//| Get the field value by name                                      |
//+------------------------------------------------------------------+
string CMySQLRow::operator[](string name)
  {
   int idx = idx_by_name(name);
   if(idx<0)
      return "";
   else
      return m_buf[idx].val;
  }
//+------------------------------------------------------------------+
//| Get the field type as the ENUM_DATABASE_FIELD_TYPE value         |
//+------------------------------------------------------------------+
ENUM_DATABASE_FIELD_TYPE CMySQLRow::MQLType(uint idx)
  {
   if(idx>=m_bufsize)
      return DATABASE_FIELD_TYPE_NULL;
   if(m_buf[idx].isnull==true)
      return DATABASE_FIELD_TYPE_NULL;
   return m_buf[idx].fp.MQLType();
  }
//+------------------------------------------------------------------+
//| Get the field type as the ENUM_DATABASE_FIELD_TYPE value         |
//+------------------------------------------------------------------+
ENUM_DATABASE_FIELD_TYPE CMySQLRow::MQLType(string name)
  {
   return MQLType(this[name]);
  }
//+------------------------------------------------------------------+
//| Get the field value as a string by index                         |
//+------------------------------------------------------------------+
bool CMySQLRow::Text(uint field_idx,string &value)
  {
   if(field_idx>=m_bufsize)
      return false;
   if(m_buf[field_idx].isnull==true || m_buf[field_idx].fp.MQLType()!=DATABASE_FIELD_TYPE_TEXT)
      return false;
   value = m_buf[field_idx].val;
   return true;
  }
//+------------------------------------------------------------------+
//| Get the field value as a string by name                          |
//+------------------------------------------------------------------+
bool CMySQLRow::Text(string field_name,string &value)
  {
   int idx = idx_by_name(field_name);
   if(idx<0)
      return false;
   return Text(idx,value);
  }
//+------------------------------------------------------------------+
//| Get the int type value by the field index                        |
//+------------------------------------------------------------------+
bool CMySQLRow::Integer(uint field_idx,int &value)
  {
   if(field_idx>=m_bufsize)
      return false;
   if(m_buf[field_idx].isnull==true || m_buf[field_idx].fp.MQLType()!=DATABASE_FIELD_TYPE_INTEGER)
      return false;
   value = int(StringToInteger(m_buf[field_idx].val));
   return true;
  }
//+------------------------------------------------------------------+
//| Get the int type value by the field name                         |
//+------------------------------------------------------------------+
bool CMySQLRow::Integer(string field_name,int &value)
  {
   int idx = idx_by_name(field_name);
   if(idx<0)
      return false;
   return Integer(idx,value);
  }
//+------------------------------------------------------------------+
//| Get the long type value by the field index                       |
//+------------------------------------------------------------------+
bool CMySQLRow::Long(uint field_idx,long &value)
  {
   if(field_idx>=m_bufsize)
      return false;
   if(m_buf[field_idx].isnull==true || m_buf[field_idx].fp.MQLType()!=DATABASE_FIELD_TYPE_INTEGER)
      return false;
   value = StringToInteger(m_buf[field_idx].val);
   return true;
  }
//+------------------------------------------------------------------+
//| Get the long type value by the field name                        |
//+------------------------------------------------------------------+
bool CMySQLRow::Long(string field_name,long &value)
  {
   int idx = idx_by_name(field_name);
   if(idx<0)
      return false;
   return Long(idx,value);
  }
//+------------------------------------------------------------------+
//| Get the double type value by the field index                     |
//+------------------------------------------------------------------+
bool CMySQLRow::Double(uint field_idx,double &value)
  {
   if(field_idx>=m_bufsize)
      return false;
   if(m_buf[field_idx].isnull==true || m_buf[field_idx].fp.MQLType()!=DATABASE_FIELD_TYPE_FLOAT)
      return false;
   value = StringToDouble(m_buf[field_idx].val);
   return true;
  }
//+------------------------------------------------------------------+
//| Get the double type value by the field name                      |
//+------------------------------------------------------------------+
bool CMySQLRow::Double(string field_name,double &value)
  {
   int idx = idx_by_name(field_name);
   if(idx<0)
      return false;
   return Double(idx,value);
  }
//+------------------------------------------------------------------+
//| Get the field value as an array                                  |
//+------------------------------------------------------------------+
bool CMySQLRow::Blob(uint field_idx,uchar &value[])
  {
   if(field_idx>=m_bufsize)
      return false;
   if(m_buf[field_idx].isnull==true || m_buf[field_idx].fp.MQLType()!=DATABASE_FIELD_TYPE_BLOB)
      return false;
   if(StringToCharArray(m_buf[field_idx].val,value)<1)
      return false;
   return true;
  }
//+------------------------------------------------------------------+
//|  Get the field value as an array                                 |
//+------------------------------------------------------------------+
bool CMySQLRow::Blob(string field_name,uchar &value[])
  {
   int idx = idx_by_name(field_name);
   if(idx<0)
      return false;
   return Blob(idx,value);
  }
//+------------------------------------------------------------------+
