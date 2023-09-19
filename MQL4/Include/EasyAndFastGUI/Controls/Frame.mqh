//+------------------------------------------------------------------+
//|                                                        Frame.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                              http://www.mql5.com |
//+------------------------------------------------------------------+
#include "..\Element.mqh"
#include "TextLabel.mqh"
//+------------------------------------------------------------------+
// | Class for creating an area for arranging elements               |
//+------------------------------------------------------------------+
class CFrame : public CElement
  {
private:
   //--- Instances for creating a control
   CTextLabel        m_text_label;
   //--- 
public:
                     CFrame(void);
                    ~CFrame(void);
   //--- Return the pointer to the text label
   CTextLabel       *GetTextLabelPointer(void) { return(::GetPointer(m_text_label)); }
   //--- Methods for creating the area
   bool              CreateFrame(const string text,const int x_gap,const int y_gap);
   //---
private:
   void              InitializeProperties(const string text,const int x_gap,const int y_gap);
   bool              CreateCanvas(void);
   bool              CreateTextLabel(void);
   //---
public:
   //--- Draws the control
   virtual void      Draw(void);
   //---
private:
   //--- Change the width at the right edge of the window
   virtual void      ChangeWidthByRightWindowSide(void);
   //--- Change the height at the bottom edge of the window
   virtual void      ChangeHeightByBottomWindowSide(void);
  };
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CFrame::CFrame(void)
  {
//--- Store the name of the element class in the base class
   CElementBase::ClassName(CLASS_NAME);
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CFrame::~CFrame(void)
  {
  }
//+------------------------------------------------------------------+
//| Create a group of text edit box objects                          |
//+------------------------------------------------------------------+
bool CFrame::CreateFrame(const string text,const int x_gap,const int y_gap)
  {
//--- Leave, if there is no pointer to the main control
   if(!CElement::CheckMainPointer())
      return(false);
//--- Initialization of the properties
   InitializeProperties(text,x_gap,y_gap);
//--- Create element
   if(!CreateCanvas())
      return(false);
   if(!CreateTextLabel())
      return(false);
//---
   return(true);
  }
//+------------------------------------------------------------------+
//| Initialization of the properties                                 |
//+------------------------------------------------------------------+
void CFrame::InitializeProperties(const string text,const int x_gap,const int y_gap)
  {
   m_x          =CElement::CalculateX(x_gap);
   m_y          =CElement::CalculateY(y_gap);
   m_x_size     =(m_x_size<1 || m_auto_xresize_mode)? m_main.X2()-m_x-m_auto_xresize_right_offset : m_x_size;
   m_y_size     =(m_y_size<1 || m_auto_yresize_mode)? m_main.Y2()-m_y-m_auto_yresize_bottom_offset : m_y_size;
   m_label_text =text;
//--- Default background color
   m_back_color=(m_back_color!=clrNONE)? m_back_color : m_main.BackColor();
//--- Indents and color of the text label
   m_label_color =(m_label_color!=clrNONE)? m_label_color : clrBlack;
   m_label_x_gap =(m_label_x_gap!=WRONG_VALUE)? m_label_x_gap : 0;
   m_label_y_gap =(m_label_y_gap!=WRONG_VALUE)? m_label_y_gap : 0;
//--- Offsets from the extreme point
   CElementBase::XGap(x_gap);
   CElementBase::YGap(y_gap);
  }
//+------------------------------------------------------------------+
//| Creates the canvas for drawing                                   |
//+------------------------------------------------------------------+
bool CFrame::CreateCanvas(void)
  {
//--- Formation of the window name
   string name=CElementBase::ElementName("frame");
//--- Creating the object
   if(!CElement::CreateCanvas(name,m_x,m_y,m_x_size,m_y_size))
      return(false);
//---
   ShowTooltip(true);
   return(true);
  }
//+------------------------------------------------------------------+
//| Create a text label                                              |
//+------------------------------------------------------------------+
bool CFrame::CreateTextLabel(void)
  {
//--- Save the pointer to the parent control
   m_text_label.MainPointer(this);
//--- Coordinates
   int x=12;
   int y=-6;
//--- Properties
   if(m_label_text=="")
     {
      y=1;
      m_text_label.YSize(1);
      m_border_color=m_back_color;
     }
//---
   m_text_label.LabelXGap(5);
   m_text_label.Font(CElement::Font());
   m_text_label.FontSize(CElement::FontSize());
//--- Creating the object
   if(!m_text_label.CreateTextLabel(m_label_text,x,y))
      return(false);
//--- Add the control to the array
   CElement::AddToArray(m_text_label);
   return(true);
  }
//+------------------------------------------------------------------+
//| Change the width at the right edge of the form                   |
//+------------------------------------------------------------------+
void CFrame::ChangeWidthByRightWindowSide(void)
  {
//--- Exit, if anchoring mode to the right side of the window is enabled
   if(m_anchor_right_window_side)
      return;
//--- Sizes
   int x_size=0;
//--- Calculate and set the new size to the control background
   x_size=m_main.X2()-m_canvas.X()-m_auto_xresize_right_offset;
//--- Do not change the size, if it is less than the specified limit
   if(x_size==m_x_size)
      return;
//---
   CElementBase::XSize(x_size);
   m_canvas.XSize(x_size);
   m_canvas.Resize(x_size,m_y_size);
//--- Redraw the control
   Draw();
//--- Update the position of objects
   Moving();
  }
//+------------------------------------------------------------------+
//| Change the height at the bottom edge of the window               |
//+------------------------------------------------------------------+
void CFrame::ChangeHeightByBottomWindowSide(void)
  {
//--- Exit, if anchoring mode to the bottom side of the window is enabled
   if(m_anchor_bottom_window_side)
      return;
//--- Sizes
   int y_size=0;
//--- Calculate and set the new size to the control background
   y_size=m_main.Y2()-m_canvas.Y()-m_auto_yresize_bottom_offset;
//--- Do not change the size, if it is less than the specified limit
   if(y_size==m_y_size)
      return;
//---
   CElementBase::YSize(y_size);
   m_canvas.YSize(y_size);
   m_canvas.Resize(m_x_size,y_size);
//--- Redraw the control
   Draw();
//--- Update the position of objects
   Moving();
  }
//+------------------------------------------------------------------+
//| Draws the control                                                |
//+------------------------------------------------------------------+
void CFrame::Draw(void)
  {
//--- Draw the background
   CElement::DrawBackground();
//--- Draw frame
   CElement::DrawBorder();
  }
//+------------------------------------------------------------------+
