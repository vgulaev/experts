//+------------------------------------------------------------------+
//|                                         SELLBUY close oposit.mq4 |
//|                      Copyright � 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//#property show_confirm

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int findorderbuy(double price)
{
   int pos;
   int total;
   int result;
   double minprice;
   
   result = -1;
   minprice = 0;
   
   total = OrdersTotal();
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS)==false) continue;
   if (OrderType() != OP_BUY) continue;
   //if (OrderLots() != 0.01) continue;
   //if (OrderOpenPrice() < 1.)
   if ((OrderOpenPrice() > minprice)&&(OrderOpenPrice()<price))
   {
   result = OrderTicket();
   minprice = OrderOpenPrice();
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
   //if (OrderLots() != 0.01) continue;
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
   double price;
   
   while (true)
   {
   ticketsell = findordersell();
   if (ticketsell == -1) break;
   OrderSelect(ticketsell, SELECT_BY_TICKET);
   price = OrderOpenPrice();
   ticketbuy = findorderbuy(price);
   if (ticketbuy == -1) break;
   Print("b:",ticketbuy, " s:",ticketsell);
   OrderCloseBy(ticketbuy,ticketsell);
   break;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+