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

bool checkstrategy(string sn)
{
   bool result;
   result = (StringSubstr(sn,0,13) == strategyname);
   return(result);
}

int findorderbuy()
{
   int pos;
   int total;
   int result;
   double minprice;
   
   strategyname = "EURUSD v0_002";
   
   result = -1;
   minprice = 200;
   
   total = OrdersTotal();
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS)==false) continue;
   if (OrderSymbol() != Symbol()) continue;
   if (OrderType() != OP_BUY) continue;
   //if (checkstrategy(OrderComment()) == false) continue;
   //if (OrderLots() != 0.01) continue;
   //if (OrderOpenPrice() < 1.)
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
   int pos;
   int total;
   int result;
   double price;
   
   strategyname = "EURUSD v0_003";
   
   result = -1;
   price = 200;
   
   total = OrdersTotal();
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS)==false) continue;
   if (OrderSymbol() != Symbol()) continue;
   if (OrderType() != OP_SELL) continue;
   //if (checkstrategy(OrderComment()) == false) continue;
   //if (OrderOpenPrice() < 1.2326) continue;
   //if (OrderTakeProfit() != 0) continue;
   //if (OrderLots() != 0.01) continue;
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
   int ticketbuy;
   int ticketsell;
   
   while (true)
   {
   ticketbuy = findorderbuy();
   if (ticketbuy == -1) break;
   ticketsell = findordersell();
   if (ticketsell == -1) break;
   Print("b:",ticketbuy, " s:",ticketsell);
   OrderCloseBy(ticketbuy,ticketsell);
   //break;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+