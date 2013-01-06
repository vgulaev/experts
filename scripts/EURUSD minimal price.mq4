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
   int symbolstotal;
   double sum[];
   double swap[];
   double lots[];   
   string sym[];
   string msg;
   double s;
   
   symbolstotal = 1;
   ArrayResize(sym, symbolstotal);
   ArrayResize(sum, symbolstotal);
   ArrayResize(lots, symbolstotal);
   ArrayResize(swap, symbolstotal);
   
   sym[0] = "EURUSD";
   
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
      msg = sym[i] + " : " + DoubleToStr(sum[i], 2) + "$ lots: " + DoubleToStr(lots[i], 2) + " swap: " + DoubleToStr(swap[i], 2);
      //SendNotification(msg);
      SendMail(msg, "С найлучшими");
      Print("Send to phone: ", msg);
      sum[i] = 0;
      lots[i] = 0;
      swap[i] = 0;
   }
   //Print("Total sum: ", s);
//----
   return(0);
  }
//+------------------------------------------------------------------+