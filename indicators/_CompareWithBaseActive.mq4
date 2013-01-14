//+------------------------------------------------------------------+
//|                                       _CompareWithBaseActive.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_minimum 1
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
   SetIndexStyle(0,DRAW_HISTOGRAM);
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
   int limit;
   int pos;
   int k;
   string baseactive;
   
   limit=Bars-counted_bars;
   
   if (Symbol() == "SBN1")
   {
   baseactive = "SBV1";
   }
   else if (Symbol() == "WQ1")
   {
   baseactive = "WV1";
   }
   else if (Symbol() == "GCM1")
   {
   baseactive = "GCQ1";
   }
   else if (Symbol() == "JON1")
   {
   baseactive = "JOU1";
   }
   else if (Symbol() == "RIM1")
   {
   baseactive = "RIU1";
   }
   else if (Symbol() == "CLM1")
   {
   baseactive = "CLQ1";
   }
   else if (Symbol() == "CLN1")
   {
   baseactive = "CLQ1";
   }
   
//----

   for (pos=0;pos<limit;pos++)
   {
      k = iBarShift(baseactive, 0, iTime(Symbol(), 0, pos), true);
      if (k != -1)
      {
      ExtMapBuffer1[pos] = (-iHigh(baseactive, 0, k)+iHigh(NULL, 0, pos))/Point;
      }
   }
   
   
//----
   return(0);
  }
//+------------------------------------------------------------------+