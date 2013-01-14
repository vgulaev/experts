//+------------------------------------------------------------------+
//|                                         SELLBUY close oposit.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//#property show_confirm

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
string strategyname;
int namelenght;

bool checkstrategy(string sn)
{
   bool result;
   result = (StringSubstr(sn,0,namelenght) == strategyname);
   return(result);
}

int findorderbuy()
{
   strategyname = "EURCHF v0_010 ";
   int pos;
   int total;
   int result;
   double minprice;
   
   result = -1;
   minprice = 10;
   
   total = OrdersTotal();
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS)==false) continue;
   if (OrderType() != OP_BUY) continue;
   //if (checkstrategy(OrderComment())) continue;
   //if (OrderLots() < 0.1) continue;
   if (OrderTicket() != 14447595) continue;
   //if (OrderOpenPrice() != 1.2086) continue;
   
   if (OrderOpenPrice() < minprice)
   {
   result = OrderTicket();
   minprice = OrderOpenPrice();
   }
   }
   return(result);
}

int findordersell()
{
   strategyname = "EURCHF v0_009 ";
   int pos;
   int total;
   int result;
   double price;
   
   result = -1;
   //price = 5;
   price = 10;
   
   total = OrdersTotal();
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS)==false) continue;
   if (OrderType() != OP_SELL) continue;
   //if (OrderLots() != 0.2) continue;
   //if (OrderTakeProfit() == 0) continue;
   //if (!checkstrategy(OrderComment())) continue;
   //if (OrderOpenPrice() != 1.2083) continue;
   //if (OrderOpenPrice() < price)
   if (OrderTicket()!= 14346224) continue;
   if (OrderOpenPrice() < price)
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
   strategyname = "EURCHF v0_009 ";
   namelenght = StringLen(strategyname);
   
   int ticketbuy;
   int ticketsell;
   
   while (true)
   {
   ticketsell = findordersell();
   if (ticketsell == -1) break;
   ticketbuy = findorderbuy();
   if (ticketbuy == -1) break;
   Print("b:",ticketbuy, " s:",ticketsell);
   OrderCloseBy(ticketbuy,ticketsell);
   break;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+