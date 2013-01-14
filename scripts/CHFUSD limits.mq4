//+------------------------------------------------------------------+
//|                                                CHFUSD limits.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void calculateCHFlimits()   
{
   int total;
   int i1, i2;
   double averageprice;
   double averagelots;
   double EURrate;
   total = OrdersTotal();
   
   for (i1=0;i1<total-1;i1++)
   {
   if (OrderSelect(i1, SELECT_BY_POS) == false) continue;
   if (OrderSymbol() != Symbol()) continue;
   averageprice = averageprice + OrderLots()*OrderOpenPrice();
   averagelots = averagelots + OrderLots();
   }   
   averageprice = averageprice/averagelots;
   EURrate = 1000000000*averagelots/(834028357*averagelots*averageprice -10000* (AccountBalance()-averagelots*200));
   
   Print("averageprice: ",averageprice , "averagelots: ", averagelots, " border rate EUR: ", EURrate, " border rate CHF: ", 1.199/EURrate);
 }

int start()
  {
//----
   calculateCHFlimits();   
//----
   return(0);
  }
//+------------------------------------------------------------------+