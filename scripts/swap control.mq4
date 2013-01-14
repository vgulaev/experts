//+------------------------------------------------------------------+
//|                                                 swap control.mq4 |
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
      
   total = OrdersTotal();
   
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   s = s + OrderSwap();
   }
   
   Print("Swap sum: ", s);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+