//+------------------------------------------------------------------+
//|                                         SELLBUY close oposit.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int findorderbuy()
{
   int pos;
   int total;
   int result;
   double price;
   
   result = -1;
   price = 10;
   
   total = OrdersTotal();
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS)==false) continue;
   if (OrderType() != OP_BUY) continue;
   if (OrderOpenPrice() < price)
   {
   price = OrderOpenPrice();
   result = OrderTicket();
   }
   }
   return(result);
}

int findordersell()
{
   int pos;
   int total;
   int result;
   double price;
   
   result = -1;
   price = 0;
   
   total = OrdersTotal();
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS)==false) continue;
   if (OrderType() != OP_SELL) continue;
   if (OrderOpenPrice() > price)
   {
   price = OrderOpenPrice();
   result = OrderTicket();
   }
   }
   return(result);
}

int start()
  {
//----
   int ticketbuy;
   int ticketsell;
   
   while (true)
   {
   ticketbuy = findorderbuy();
   if (ticketbuy == -1) break;
   ticketsell = findordersell();
   Print("b:",ticketbuy, " s:",ticketsell);
   //OrderCloseBy(ticketbuy,ticketsell);
   break;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+