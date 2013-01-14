//+------------------------------------------------------------------+
//|                                  EURCHF create SELL BUY grid.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int determinateoperation(int op, double p) 
{
   int result;
   RefreshRates();
   if (op == OP_BUY)
   {
   if (p < Ask)
   {
   result = OP_BUYLIMIT;
   }
   else
   {
   result = OP_BUYSTOP;
   }
   }
   else if (op == OP_SELL)
   {
   if (p > Bid)
   {
   result = OP_SELLLIMIT;
   }
   else
   {
   result = OP_SELLSTOP;
   }
   }
   return(result);
}

string modificator(int op, double p) 
{
   string result;
   if (op == OP_BUY)
   {
   result = " BUY ";
   }
   else
   {
   result = " SELL ";
   }
   result = result + DoubleToStr(p,4);
   return(result);
}

int start()
  {
//----
   int pos;
   double price;
   int otype;
   int ticket;
   string strategyname;
   strategyname = "sellbuy v0_01";
   
   price = 1.2067;
   otype = OP_SELL;
   //otype = OP_BUY;
   
   for (pos=0;pos<1;pos++)
   {
   otype = OP_SELL;
   ticket = -1;
   while (ticket < 0)
   {
   ticket = OrderSend(Symbol(), determinateoperation(otype, price), 0.01, price, 0, 0, 0, strategyname + modificator(otype, price));
   }

   otype = OP_BUY;
   ticket = -1;
   while (ticket < 0)
   {
   ticket = OrderSend(Symbol(), determinateoperation(otype, price), 0.01, price, 0, 0, 0, strategyname + modificator(otype, price));
   }

   otype = (otype + 1) % 2;
   price = price + Point;
   //price = price - Point*2;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+