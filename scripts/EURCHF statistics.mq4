//+------------------------------------------------------------------+
//|                                            EURCHF statistics.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void printstatistic()
{
   int pos;
   int total;
   int pieces;
   double volume;
   double profit;
   
   total = OrdersHistoryTotal();
   
   for (pos = 0;pos < total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)==false) continue;
   //if ((OrderSymbol() == Symbol())&&(OrderProfit()!=0)&&(OrderLots()!=0.01))
   if ((OrderSymbol() == Symbol())&&(OrderProfit()!=0))
   {
   volume = volume + OrderLots();
   pieces = pieces + 1;
   profit = profit + OrderProfit();
   }
   }
   
   Print("lots:", volume, " pieces: ", pieces, " profit: ", profit, " avarage: ", profit/volume/100);
}

int start()
  {
//----
   printstatistic();   
//----
   return(0);
  }
//+------------------------------------------------------------------+