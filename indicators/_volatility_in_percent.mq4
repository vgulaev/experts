//+------------------------------------------------------------------+
//|                                                     Èíòåãğàë.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Silver
//---- buffers
double Integral[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_HISTOGRAM);
   SetIndexBuffer(0,Integral);
   
   //IndicatorShortName("ÇÏ (" + DoubleToStr(range,2) + ")");
   //SetIndexLabel(0,"ÇÏ");
   
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
   int limit;
   int iday;
   int counted_bars=IndicatorCounted();
   int startperiod;
   double sum;
   
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- macd counted in the 1-st buffer
   
   
   for(int i=0; i<limit; i++)
   {
      //MathMin
      sum = 0;
      startperiod = iBarShift(NULL, PERIOD_D1, iTime(NULL, 0, i), false);
      //for (iday = startperiod; iday < startperiod+14; iday++)
      //{
      //sum = sum + MathAbs(iHigh(NULL, PERIOD_D1, iday) - iLow(NULL, PERIOD_D1, iday));
      //}
      Integral[i] = (MathAbs(iHigh(NULL, PERIOD_D1, startperiod) - iLow(NULL, PERIOD_D1, startperiod)))/iLow(NULL, PERIOD_D1, startperiod)*100;
      //Print("h:", iHigh(NULL, PERIOD_D1, startperiod), " l:", iLow(NULL, PERIOD_D1, startperiod));
   }
   return(0);
  }
//+------------------------------------------------------------------+