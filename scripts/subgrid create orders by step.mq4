//+------------------------------------------------------------------+
//|                                        create orders by step.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void createordersbystep()
{
   string sym;
   string srategyname;
   int i;
   int op;
   double price;
   
   srategyname = "subgrid v0_001";
   price = 75.080;
   
   for (i = 0; i<1;i++)
   {
   if (price < Bid)
   {
   op = OP_BUYLIMIT;
   }
   else
   {
   op = OP_BUYSTOP;
   }
   OrderSend(Symbol(), op, 0.01,price, 0, 0, price + 100*Point, srategyname);
   price = price + 100 * Point;
   if (price >= 75.500) break;
   }
}

int start()
  {
//----
   createordersbystep();   
//----
   return(0);
  }
//+------------------------------------------------------------------+