//+------------------------------------------------------------------+
//|                                             Profit by Symbol.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void printprofitbysymbol()
{
   int total;
   int pos, i;
   int symbolstotal;
   double sum[];
   double sum_sell[];
   double swap[];
   double lots[];
   double lots_sell[];
   string sym[];
   double s;
   
   symbolstotal = 1;
   ArrayResize(sym, symbolstotal);
   ArrayResize(sum, symbolstotal);
   ArrayResize(lots, symbolstotal);
   ArrayResize(swap, symbolstotal);
   
   ArrayResize(sum_sell, symbolstotal);
   ArrayResize(lots_sell, symbolstotal);

   sym[0] = "EURUSD";
   //sym[1] = "USDCHF";
   //sym[2] = "NZDCHF";
   //sym[3] = "AUDCHF";
   //sym[4] = "EURJPY";
   //sym[5] = "EURGBP";
   
   
   total = OrdersTotal();
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      for (i = 0; i<symbolstotal; i++)
      {
      if (OrderSymbol() == sym[i])
      {
      swap[i] = swap[i] + OrderSwap();
      if (OrderProfit() > 0)
      {
         if (OrderType() == OP_BUY)
         {
            sum[i] = sum[i] + OrderProfit() + OrderSwap() + OrderCommission();
            lots[i] = lots[i] + OrderLots();
         }
         if (OrderType() == OP_SELL)
         {
            sum_sell[i] = sum_sell[i] + OrderProfit() + OrderSwap() + OrderCommission();
            lots_sell[i] = lots_sell[i] + OrderLots();
         }
      }
      }
      }
   }
   
   for (i = 0; i<symbolstotal; i++)
   {
      s = s + sum[i];
      Print(sym[i], " Buy : ", sum[i], " lots: ", lots[i], " swap: ", swap[i]);
      Print(sym[i], " Sell : ", sum_sell[i], " lots: ", lots_sell[i], " swap: ", swap[i]);
   }
   Print("Total sum: ", s);
}

int start()
  {
//----
   printprofitbysymbol();   
//----
   return(0);
  }
//+------------------------------------------------------------------+