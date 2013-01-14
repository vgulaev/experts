//+------------------------------------------------------------------+
//|                                              ExportOperation.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   int total;
   int pos;
   int handle;
   
   handle = FileOpen("export.csv", FILE_CSV|FILE_WRITE, ';');
   total = OrdersHistoryTotal();
   
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY) == false) continue;
   
   FileWrite(handle,TimeToStr(OrderOpenTime(),TIME_DATE|TIME_SECONDS), OrderType(), OrderLots(), OrderSymbol(), 
      OrderOpenPrice(), TimeToStr(OrderCloseTime(),TIME_DATE|TIME_SECONDS), OrderSwap(), OrderProfit(), OrderComment());
   
   //if (pos > 10) break;
   }
   
   FileClose(handle);
//----
   return(0);
  }
//+------------------------------------------------------------------+