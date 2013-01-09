//+------------------------------------------------------------------+
//|                                         EURUSD minimal price.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   int total;
   int pos, i;
   double lots;
   double price;
   double sum;

   lots = 0;
   sum = 0;   
   total = OrdersTotal();
   for (pos = 0; pos<total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      if (OrderSymbol() != "EURUSD") continue;
      if (OrderType() == OP_BUYSTOP) continue;
      //if (OrderType() != OP_BUY) continue;
      sum = sum + OrderLots() * OrderOpenPrice();
      lots = lots + OrderLots();
   }
   price = sum/lots;
   
   double delta;
   delta = (AccountBalance() - 270 * lots) / (100000 * lots);
   
   Print("Total lots: ", lots, " average price: ", price, " minimal: ", price - delta, " in persent: ": (Bid-(price - delta))/Bid*100);
//----
   return(0);
  }
//+------------------------------------------------------------------+