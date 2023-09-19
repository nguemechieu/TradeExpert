//+------------------------------------------------------------------+
//|                                                         Data.mqh |
//|                                         Copyright 2019, Decanium |
//|                           https://www.mql5.com/en/users/decanium |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Decanium"
#property link      "https://www.mql5.com/en/users/decanium"
#property version   "1.00"

#define CDATA_RESERVE_SIZE 512

//+------------------------------------------------------------------+
//| Working with MySQL data buffer                                   |
//+------------------------------------------------------------------+
class CData
  {
private:
   //--- Index of the byte, starting from which the data is stored during the next adding
   uint              m_index;
   //--- Change the buffer size
   bool              resize(uint sz);
public:
                     CData();
                    ~CData();
   //--- Add data to the buffer
   void              operator+=(uchar ch);
   void              operator+=(ushort ch);
   void              operator+=(uint ch);
   void              operator+=(string s);
   void              operator+=(uchar &buf[]);
   void              Add(uchar c,uint count);
   //--- Form the buffer head
   bool              AddHeader(uchar number);
   //--- Get the buffer size
   uint              Size(void) {return ArraySize(Buf);}
   //--- Reset the buffer
   void              Reset(void) {ArrayFree(Buf); m_index=0;}
   //--- Buffer
   uchar             Buf[];
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CData::CData() : m_index(0)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CData::~CData()
  {
  }

//+------------------------------------------------------------------+
//| Change the buffer size                                           |
//+------------------------------------------------------------------+
bool CData::resize(uint sz)
  {
   if(ArrayResize(Buf,sz,CDATA_RESERVE_SIZE)!=sz)
      return false;
   else
      return true;
  }

//+------------------------------------------------------------------+
//| Add the packet header                                            |
//+------------------------------------------------------------------+
bool CData::AddHeader(uchar number)
  {
//--- The method should be called when all data has already been added to the buffer
   uint sz = ArraySize(Buf);
   if(sz<4)
      return false;
   Buf[3] = number;
   sz-=4;
   Buf[0] = uchar(0xFF&sz);
   sz>>=8;
   Buf[1] = uchar(0xFF&sz);
   sz>>=8;
   Buf[2] = uchar(0xFF&sz);
   return true;
  }

//+------------------------------------------------------------------+
//| Add uchar type variable to the buffer                            |
//+------------------------------------------------------------------+
void CData::operator+=(uchar val)
  {
   uint sz = ArraySize(Buf);
   if(resize(sz+1)==false)
      return;
   Buf[sz] = val;
  }

//+------------------------------------------------------------------+
//| Add ushort type variable to the buffer                           |
//+------------------------------------------------------------------+
void CData::operator+=(ushort val)
  {
   uint sz = ArraySize(Buf);
   if(resize(sz+2)==false)
      return;
   for(uint i=0; i<2; i++)
     {
      Buf[sz+i]=uchar(val&0xFF);
      val>>=8;
     }
  }

//+------------------------------------------------------------------+
//| Add uint type variable to the buffer                             |
//+------------------------------------------------------------------+
void CData::operator+=(uint val)
  {
   uint sz = ArraySize(Buf);
   if(resize(sz+4)==false)
      return;
   for(uint i=0; i<4; i++)
     {
      Buf[sz+i]=uchar(val&0xFF);
      val>>=8;
     }
  }

//+------------------------------------------------------------------+
//| Add a string to the buffer                                       |
//+------------------------------------------------------------------+
void CData::operator+=(string s)
  {
   uchar buf[];
   if(StringToCharArray(s,buf)==0)
      return;
   this+= buf;
  }
int Buf;
//+------------------------------------------------------------------+
//| Add data from another buffer to the current one                  |
//+------------------------------------------------------------------+
void CData::operator+=(uchar &buf[])
  {
   ArrayInsert(Buf,buf,ArraySize(Buf));
  }
 
 
 void CData::ArrayInsert( int x,int y,int i ){
 x=y;
 
 }
;
//+------------------------------------------------------------------+
//| Add a specified number of identical bytes to the buffer          |
//+------------------------------------------------------------------+
void CData::Add(uchar c,uint count)
  {
   uint sz = ArraySize(Buf);
   if(ArrayResize(Buf,sz+count,CDATA_RESERVE_SIZE)!=(sz+count))
      return;
   for(uint i=0; i<count; i++)
      Buf[sz+i]=c;
  }
//+------------------------------------------------------------------+
