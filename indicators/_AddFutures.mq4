//+------------------------------------------------------------------+
//|                                                  _AddFutures.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_chart_window
#property indicator_buffers 3
#property indicator_color1 DarkOrange
#property indicator_color2 DarkKhaki
#property indicator_color3 DarkOrange
//--- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ExtMapBuffer3);
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
   int k;
   string futurenear;
   string futurefar;
   
   limit=Bars-counted_bars;
   
   if (Symbol()=="AUDUSD")
   {
   futurenear = "6AM1#I";
   futurefar = "6AU1#I";
   }
   else if (Symbol()=="EURUSD")
   {
   futurenear = "6EM1#I";
   futurefar = "6EU1#I";
   }
   else if (Symbol()=="GBPUSD")
   {
   futurenear = "6BM1#I";
   futurefar = "6BU1#I";
   }
   else if (Symbol()=="NZDUSD")
   {
   futurenear = "6NM1#I";
   futurefar = "6NU1#I";
   }
   else if (Symbol()=="EURGBP")
   {
   futurenear = "RPM1#I";
   futurefar = "RPU1#I";
   }
   else if (Symbol()=="EURCHF")
   {
   futurenear = "RFM1#I";
   futurefar = "RFU1#I";
   }
   else if (Symbol()=="EURJPY")
   {
   futurenear = "RYM1#I";
   futurefar = "RYU1#I";
   }
   else if (Symbol()=="XAU")
   {
   futurenear = "GCM1#I";
   futurefar = "GCQ1#I";
   }
   else if (Symbol()=="CLN1")
   {
   futurenear = "CLQ1";
   //futurefar = "CLQ1";
   }
   
//----

   for (pos=0;pos<limit;pos++)
   {
      //ExtMapBuffer1[pos] = iHigh(futurenear, 0, pos);
      //ExtMapBuffer2[pos] = iHigh(futurefar, 0, pos);
      k = iBarShift(futurenear, 0, iTime(Symbol(), 0, pos), true);
      if (k != -1)
      {
      ExtMapBuffer1[pos] = iHigh(futurenear, 0, k);
      //ExtMapBuffer3[pos] = iLow(futurenear, 0, k);
      }

      k = iBarShift(futurefar, 0, iTime(Symbol(), 0, pos), true);
      if (k != -1)
      {
      ExtMapBuffer2[pos] = iHigh(futurefar, 0, k);
      }
      
      //if (iTime(Symbol(), 0, pos) != iTime(futurenear, 0, pos))
      //{
      //Print("Error");
      //}
      
   }
   
   //Print("Max pos:", pos);
//----
   return(0);
  }
//+------------------------------------------------------------------+