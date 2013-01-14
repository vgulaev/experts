//+------------------------------------------------------------------+
//|                                                    _delta_DX.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Lime
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

double usdx(double ee,double ej,double eb,double ec,double ek,double es)
{
	double res;
	res = 93.80251457;
	res = res * MathPow(ee,-0.576)*MathPow(ej,-0.136)*MathPow(eb,-0.119)*MathPow(ec,-0.091)*MathPow(ek,0.042)*MathPow(es,-0.036);
	return(res);
}

int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   int limit;
   int pos;
   double ee;
   double ej;
   double eb;
   double ec;
   double ek;
   double es;
   double dx;
   double cdx;
   
   limit=Bars-counted_bars;

   for (pos=0;pos<limit;pos++)
   {
      
      ee = priceoffuture(pos, "EURUSD");
      eb = priceoffuture(pos, "6BU1#I");
      ej = priceoffuture(pos, "6JU1#I");
      ec = priceoffuture(pos, "6CU1#I");
      ek = priceoffuture(pos, "USDSEK");
      es = priceoffuture(pos, "6SU1#I");
      
      dx = priceoffuture(pos, "DXU1#I");
      
      cdx = usdx(ee, ej, eb, ec, ek, es);
      
		if ((ee>0)&&(ej>0)&&(eb>0)&&(ec>0)&&(ek>0)&&(es>0)&&(dx>0))
		{
		//ExtMapBuffer1[pos] = iHigh(NULL,0,pos)/MathPow(eu,-0.576)/MathPow(ju/100,-0.136)/MathPow(bu,-0.119)/MathPow(cu,-0.091)/MathPow(su,-0.091)/MathPow(ku,0.042);
		ExtMapBuffer1[pos] = dx - cdx;
		//ExtMapBuffer1[pos] = iHigh(NULL,0,pos)/MathPow(ju/100,-0.136);
		}
		//s = s + iHigh(basketsymbol[i], 0, k);
      
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+