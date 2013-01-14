//+------------------------------------------------------------------+
//|                                                    _usdx_EUR.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 CornflowerBlue
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
double priceoffuture(int pos, string sym)
{
   int k;
   double res;
   res = -1;
   k = iBarShift(sym, 0, iTime(Symbol(), 0, pos), true);
   
   if (k != -1)
   {
   res = iHigh(sym, 0, k);
   }
   
   return(res);
}

int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   int limit;
   int pos;
   double eu;
   double bu;
   double ju;
   double cu;
   double su;
   double ku;
   
   limit=Bars-counted_bars;

   for (pos=0;pos<limit;pos++)
   {
      
      eu = priceoffuture(pos, "6EM1");
      bu = priceoffuture(pos, "6BM1");
      ju = priceoffuture(pos, "6JM1");
      cu = priceoffuture(pos, "6CM1");
      su = priceoffuture(pos, "6SM1");
      ku = priceoffuture(pos, "USDSEK");
      
		if ((eu>0)&&(bu>0)&&(ju>0)&&(cu>0)&&(su>0))
		{
		//ExtMapBuffer1[pos] = iHigh(NULL,0,pos)/MathPow(eu,-0.576)/MathPow(ju/100,-0.136)/MathPow(bu,-0.119)/MathPow(cu,-0.091)/MathPow(su,-0.091)/MathPow(ku,0.042);
		ExtMapBuffer1[pos] = iHigh(NULL,0,pos)/MathPow(eu,-0.576)/MathPow(ju/100,-0.136)/MathPow(bu,-0.119);
		//ExtMapBuffer1[pos] = iHigh(NULL,0,pos)/MathPow(ju/100,-0.136);
		}
		//s = s + iHigh(basketsymbol[i], 0, k);
      
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+