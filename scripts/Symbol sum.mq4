//+------------------------------------------------------------------+
//|                                                   Symbol sum.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   int total;
   int pos;
   double s;
   double swap;
      
   total = OrdersTotal();
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   if (OrderSymbol() != Symbol()) continue;
   s = s + OrderSwap()+OrderProfit() + OrderCommission();
   swap = swap + OrderSwap();
   }
   
   Print(Symbol(), "Current sum: ", s, " current swap: ", swap);
   s = 0;
   total = OrdersHistoryTotal();
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY) == false) continue;
   if (OrderSymbol() != Symbol()) continue;
   s = s + OrderSwap()+OrderProfit() + OrderCommission();
   }
   
   Print(Symbol(), "History sum: ", s);
//----
   return(0);
  }
//+------------------------------------------------------------------+