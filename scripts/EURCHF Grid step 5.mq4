//+------------------------------------------------------------------+
//|                                           EURCHF Grid step 5.mq4 |
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

int start()
  {
//----
   int pos;
   int i;
   int otype;
   int ticket;
   double price;
   string strategyname;
   string strategynameBUY;
   
   strategyname = "Dozen Grid ";
   //strategyname = "Subgrid Grid ";
   //strategynameBUY = "EURCHF v0_003 ";
   price = 1.2060;
   
   
   //otype = OP_BUY;
   for (i=0;i<1;i++)
   {
   
   otype = OP_SELL;
   ticket = -1;
   while (ticket<0)
   {
   ticket = OrderSend(Symbol(), determinateoperation(otype, price), 0.1, price, 0, 0, 0, strategyname + DoubleToStr(price,4));
   if (ticket < 0)
      {
      //Print("Error: ", GetLastError());
      }
   }
   
   
   otype = OP_BUY;
   ticket = -1;
   while (ticket<0)
   {
   ticket = OrderSend(Symbol(), determinateoperation(otype, price), 0.1, price, 0, 0, 0, strategyname + DoubleToStr(price,4));
   if (ticket < 0)
      {
      //Print("Error: ", GetLastError());
      }
   }
   /**/
   
   price = NormalizeDouble(price + Point,4);
   }
   //----
   return(0);
  }
//+------------------------------------------------------------------+