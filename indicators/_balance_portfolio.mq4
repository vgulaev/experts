//+------------------------------------------------------------------+
//|                                           _balance_portfolio.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_color1 Coral
//--- buffers
double ExtMapBuffer1[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
double lse,lsj,lsb,lsc,lsk,lss;
double kdx,ke,kj,kb,kc,kk,ks;
double edx,ee,ej,eb,ec,ek,es;


int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
//----
	lse = 1.25;
	lsj = 1.25;
	lsb = 0.65;
	lsc = 1;
	lsk = 1;
	lss = 1.25;
	
   int pos;
   pos = 100;
   
	edx = 74.8130;
	ee = 1.4359;
	ej = 1.2344;
	eb = 1.6332;
	ec = 1.0203;
	ek = 6.1396;
	es = 1.1867;
	
	kdx = 0.46;
	ke = 0.11;
	kj = 0.03;
	kb = 0.04;
	kc = 0.03;
	kk = 0.02;
	ks = 0.01;

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
double usdx(double ee,double ej,double eb,double ec,double ek,double es)
{
	double res;
	res = 93.80251457;
	res = res * MathPow(ee,-0.576)*MathPow(ej,-0.136)*MathPow(eb,-0.119)*MathPow(ec,-0.091)*MathPow(ek,0.042)*MathPow(es,-0.036);
	return(res);
}

double profitUSD(double enter,double exit)
{
	double res;
	res = 100000*(1-enter/exit);
	return(res);
}

double profitUSDX(double eDX,double de,double dj,double db,double dc,double dk,double ds)
{
	double res;
	res = (usdx(de,dj,db,dc,dk,ds) - eDX)*1000;
	return(res);
}

double curentprofit(double de,double dj,double db,double dc,double dk,double ds)
{
	double res;
	
	res = kdx * profitUSDX(edx,de,dj,db,dc,dk,ds);
	res = res + ke*lse*profitUSD(ee,de)*de;
	res = res + kj*lsj*profitUSD(ej,dj)*dj;
	res = res + kb*lsb*profitUSD(eb,db)*db;
	res = res + kc*lsc*profitUSD(ec,dc)*dc;
	res = res - kk*lsk*profitUSD(ek,dk);
	res = res + ks*lss*profitUSD(es,ds)*ds;
	
	return(res);	
}

double priceoffuture(int pos, string sym, string horl)
{
   int k;
   double res;
   res = -1;
   k = iBarShift(sym, 0, iTime(Symbol(), 0, pos), true);
   
   if (k != -1)
   {
   if (horl=="h") 
   {
   res = iHigh(sym, 0, k);
   }
   else
   {
   res = iLow(sym, 0, k);
   }
   }
   
   return(res);
}

int start()
  {
   int    counted_bars=IndicatorCounted();
//----
   int limit;
   int pos;
   
   double de,dj,db,dc,dk,ds;
   
   limit = Bars-counted_bars;
   for (pos=0;pos<limit;pos++)
   {
      
      //de = priceoffuture(pos, "6EM1");
      //db = priceoffuture(pos, "6BM1");
      //dj = priceoffuture(pos, "6JM1");
      //dc = priceoffuture(pos, "6CM1");
      //ds = priceoffuture(pos, "6SM1");
      //dk = priceoffuture(pos, "USDSEK");
      de = priceoffuture(pos, "6E_CONT", "l");
      db = priceoffuture(pos, "6B_CONT", "l");
      dj = priceoffuture(pos, "6J_CONT", "l");
      dc = priceoffuture(pos, "6C_CONT", "l");
      ds = priceoffuture(pos, "6S_CONT", "l");
      dk = priceoffuture(pos, "USDSEK", "h");
      
		if ((de>0)&&(db>0)&&(dj>0)&&(dc>0)&&(dk>0)&&(ds>0))
      {
      ExtMapBuffer1[pos] = curentprofit(de,dj,db,dc,dk,ds);
      }
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+