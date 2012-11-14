//+------------------------------------------------------------------+
//|                                                    commision.mq4 |
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
   double s;
   int total;
   int pos;
   //strategyname = "EURUSD v0_002";
   total = OrdersHistoryTotal();
   
   for (pos=0;pos<total;pos++)   
   {
   if (OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)==false) continue;
   //if (checkstrategy(OrderComment()) == false) continue;
   s = s + OrderCommission();
   }
   
   Print(s);
//----
   return(0);
  }
//+------------------------------------------------------------------+