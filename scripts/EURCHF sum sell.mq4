//+------------------------------------------------------------------+
//|                                              EURCHF sum sell.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
string strategyname;

bool checkstrategy(string sn)
{
   bool result;
   result = (StringSubstr(sn,0,13) == strategyname);
   return(result);
}

int start()
  {
//----
   int pos;
   int total;
   double s[2];
   double l[2];
   double sw;

   strategyname = "EURUSD v0_001";
   total = OrdersTotal();
   
   for (pos=0;pos<total;pos++)   
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   if (OrderSymbol() != Symbol()) continue;
   //if (checkstrategy(OrderComment())) continue;
   //if (OrderLots()!=0.01) continue;
   if ((OrderProfit()>0)&&(OrderType() == OP_BUY))
   {
      s[1] = s[1] + OrderProfit();
      l[1] = l[1] + OrderLots();
   }
   else if ((OrderType() == OP_SELL)&&(OrderProfit()>0))
   {
      s[0] = s[0] + OrderProfit();
      l[0] = l[0] + OrderLots();
   }
   sw = sw + OrderSwap();
   }
   
   Print("buy profit:", s[1], " lots:", l[1], " delta: ", (MarketInfo(Symbol(), MODE_HIGH)-MarketInfo(Symbol(), MODE_LOW))/Point);
   Print("sell profit:", s[0], " lots:", l[0], " swap:", sw);
   
//----
   return(0);
  }
//+------------------------------------------------------------------+