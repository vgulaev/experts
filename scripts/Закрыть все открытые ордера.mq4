//+------------------------------------------------------------------+
//|                                  Закрыть все открытые ордера.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property show_confirm

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   int pos;
   int total;
   int tickets[];
   int ordtype;
   int k;
   double price = 0;
   double priceorder;
   string idstrategy;
   int lengthName;
   idstrategy = "0.1366";
   lengthName = StringLen(idstrategy);
   
   total = OrdersTotal();

   for(pos=0;pos<total;pos++)
    {
     if(OrderSelect(pos,SELECT_BY_POS)==false) continue;
     ordtype = OrderType();
     //if (OrderSymbol() != Symbol()) continue;
     //if (((ordtype == OP_SELL)||(ordtype == OP_BUY))&&(StringSubstr(OrderComment(),0,lengthName) == idstrategy)&&OrderProfit()>0)
     //if (((ordtype == OP_SELL)||(ordtype == OP_BUY))&&(OrderComment()==idstrategy))
     //if (((ordtype == OP_SELL)||(ordtype == OP_BUY)))
     //if (((ordtype == OP_SELL)||(ordtype == OP_BUY))&&(OrderProfit()>0.3))
     //if ((ordtype == OP_BUY)&&(OrderSymbol() == Symbol()))
     if ((StringLen(OrderComment())< 17)&&(OrderProfit()+OrderCommission()>0.2))
     //if ((OrderLots() == 0.01)&&(OrderProfit()+OrderCommission()>0.2))
     {
      ArrayResize(tickets, k + 1);
      tickets[k] = OrderTicket();
      k = k + 1;
      }
     }

   bool ifclose;
   for (pos=0;pos < k; pos++)
   {
      if(OrderSelect(tickets[pos],SELECT_BY_TICKET)==false) continue;
      ordtype = OrderType();
      priceorder = OrderOpenPrice();
      ifclose = false;
      while (ifclose == false)
      {
      RefreshRates();
      if (ordtype == OP_SELL)
         {
         price = MarketInfo(OrderSymbol(), MODE_ASK);
         }
         else
         {
         price = MarketInfo(OrderSymbol(), MODE_BID);
         }
     ifclose = OrderClose(OrderTicket(),OrderLots(),price, 0);
     //Print(OrderComment());
     break;
     if (ifclose == true)
     {
     //OrderSend(Symbol(), OP_BUYLIMIT, 0.1, priceorder, 0, 0, 0, idstrategy + DoubleToStr(priceorder, Digits));
     }
     }
   }   
//----
   Print("Цикл прошел");
   return(0);
  }
//+------------------------------------------------------------------+