//+------------------------------------------------------------------+
//|                                             Profit by Symbol.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property show_confirm
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void printprofitbysymbol()
{
   int total;
   int pos, i;
   int symbolstotal;
   double sum[];
   double swap[];
   double lots[];   
   string sym[];
   double s;
   
   symbolstotal = 5;
   ArrayResize(sym, symbolstotal);
   ArrayResize(sum, symbolstotal);
   ArrayResize(lots, symbolstotal);
   ArrayResize(swap, symbolstotal);
   
   sym[0] = "EURUSD";
   sym[1] = "USDCHF";
   sym[2] = "NZDCHF";
   sym[3] = "AUDCHF";
   sym[4] = "EURJPY";
   
   
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
      sum[i] = sum[i] + OrderProfit() + OrderSwap() + OrderCommission();
      lots[i] = lots[i] + OrderLots();
      }
      }
      }
   }
   
   for (i = 0; i<symbolstotal; i++)
   {
      s = s + sum[i];
      Print(sym[i], " : ",sum[i], " lots: ", lots[i], " swap: ", swap[i]);
      if (lots[i] > 0.05)
      {
      OrderSend(sym[i], OP_SELL, lots[i], MarketInfo(sym[i], MODE_BID), 0, 0, 0);
      }
      //OrderSend(Symbol(), determinateoperation(otype, price), lotsize, price, 0, 0, 0, strategyname + DoubleToStr(price,Digits-1));
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