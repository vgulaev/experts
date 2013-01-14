//+------------------------------------------------------------------+
//|                                                         Test.mq4 |
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
   //OrderCloseBy(4864566, 4864392);
   Print(OrdersTotal());
   Print(OrdersHistoryTotal());
   Print("Hello word!!!");
//----
   return(0);
  }
//+------------------------------------------------------------------+