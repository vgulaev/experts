//+------------------------------------------------------------------+
//|                                         EURCHF balance limit.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void calculatebalancelimit()
{
   int total;
   int pos;
   int count;
   double basketbuy;
   double basketbuylimit;
   double basketbuystop;
   double basketsell;
   double basketselllimit;
   double basketsellstop;
   int k;
   
   total = OrdersTotal();
   
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   if (OrderSymbol() != Symbol()) continue;
   if (OrderType() == OP_BUY) basketbuy = basketbuy + OrderLots();
   if (OrderType() == OP_BUYLIMIT) basketbuylimit = basketbuylimit + OrderLots();
   if (OrderType() == OP_BUYSTOP) basketbuystop = basketbuystop + OrderLots();
   if (OrderType() == OP_SELL) basketsell = basketsell + OrderLots();
   if (OrderType() == OP_SELLLIMIT) basketselllimit = basketselllimit + OrderLots();
   if (OrderType() == OP_SELLSTOP) basketsellstop = basketsellstop + OrderLots();
   }
   
   Print("Extrem basket: ", basketbuy+basketbuylimit+basketbuystop);
   Print("bs: ", basketbuystop, " sl: ", basketselllimit, " b-s:", basketbuystop-basketselllimit);
   Print("bl: ", basketbuylimit, " ss: ", basketsellstop, " b-s:", basketbuylimit-basketsellstop);
   Print("b: ", basketbuy, " s: ", basketsell, " b-s:", basketbuy-basketsell);
}

int start()
  {
//----
   calculatebalancelimit();   
//----
   return(0);
  }
//+------------------------------------------------------------------+