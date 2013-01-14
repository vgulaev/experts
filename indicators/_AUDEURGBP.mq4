//+------------------------------------------------------------------+
//|                                                   _AUDEURGBP.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//#property indicator_chart_window
#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Coral
//--- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   int limit;
   int pos;
   int i;
   int k;
   double s;
   string basketsymbol[];
   
   ArrayResize(basketsymbol,3);
   
   basketsymbol[0] = "EURUSD";
   basketsymbol[1] = "AUDUSD";
   basketsymbol[2] = "GBPUSD";
   
   limit=Bars-counted_bars;

   for (pos=0;pos<limit;pos++)
   {
      s = 0;
      for (i=0;i<3;i++)
      {
		  k = iBarShift(basketsymbol[i], 0, iTime(Symbol(), 0, pos), true);
		  if (k != -1)
		  {
		  s = s + iHigh(basketsymbol[i], 0, k);
		  }
      }
      ExtMapBuffer1[pos] = s/3;
      //Print(ExtMapBuffer1[pos]);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+