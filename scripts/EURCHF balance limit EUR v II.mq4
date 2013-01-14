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
double profit(double enter, double exit)
{   
   return(100000 * (1-enter/exit));
}

void calculatebalancelimit()
{
   int total;
   int pos;
   double s;
   double exit;
   double swapsum;
   double essentialassets;
   double totallots;
   
   exit = 1.199;
      
   total = OrdersTotal();
   s = 0;
   
   for (pos = 0; pos<total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      
      if (((OrderType() == OP_SELL)||(OrderType() == OP_SELLSTOP)||(OrderType() == OP_SELLLIMIT))&&(OrderTakeProfit() != 0)) continue;

      if ((OrderType() == OP_BUY)||(OrderType() == OP_BUYLIMIT))
      {
      s = s + profit(OrderOpenPrice(), exit) * OrderLots();
      totallots = totallots + OrderLots();
      }
      else if ((OrderType() == OP_SELL)||(OrderType() == OP_SELLSTOP))
      {
      s = s - profit(OrderOpenPrice(), exit) * OrderLots();
      totallots = totallots - OrderLots();
      }
      
      swapsum = swapsum + OrderSwap();
   }
   
   essentialassets = s - totallots * 500;

   //Print("sum: ", s + swapsum, " ", AccountProfit(), " ", Ask);
   Print("essential assets: ", essentialassets);
   Print("free+swap+credit: ", AccountBalance()+swapsum+AccountCredit());
   Print("free assets: ", AccountBalance()+AccountCredit() + swapsum + essentialassets);
}

int start()
  {
//----
   calculatebalancelimit();   
//----
   return(0);
  }
//+------------------------------------------------------------------+