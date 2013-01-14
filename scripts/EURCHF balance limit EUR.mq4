//+------------------------------------------------------------------+
//|                                         EURCHF balance limit.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

void calculatebalancelimit()
{
   int total;
   int pos;
   int count;
   double supdown;
   double sdown;
   double curentprice;
   double enter, exit;
   double lotsupdown;
   double lotsdown;
   double openlots;
   double needassetsupdown;
   double needassetsdown;   
   double swapsum;
   double currentprofit;
   int k;
   
   curentprice = Bid;
   exit = 1.199;
      
   total = OrdersTotal();
   
   for (pos = 0; pos<total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      enter = OrderOpenPrice();
      if ((OrderType()==OP_SELL)||(OrderType()==OP_SELLLIMIT)||(OrderType()==OP_SELLSTOP))
      {
      k = -1;
      }
      else
      {
      k = 1;
      }
   
      if ((OrderType() == OP_BUY)||(OrderType() == OP_SELL))
      {
      openlots = openlots + OrderLots() * k;
      swapsum = swapsum + OrderSwap();
      }

      if (((OrderType() == OP_SELL)||(OrderType() == OP_SELLSTOP)||(OrderType() == OP_SELLLIMIT))&&(OrderTakeProfit() != 0))
      {
      k = 0;
      }

      currentprofit = 100000 * (1-enter/exit) * OrderLots() * k;
      
      if ((OrderType() == OP_BUY)||(OrderType() == OP_SELL)||(OrderType() == OP_BUYLIMIT)||(OrderType() == OP_SELLSTOP))
      {
         sdown = sdown + currentprofit;
         lotsdown = lotsdown + OrderLots() * k;
      }
      
      supdown = supdown + currentprofit;
      lotsupdown = lotsupdown + OrderLots() * k;
   }
   //Print(" think: ",sdown);
   if (lotsupdown < 3)
   {
   needassetsupdown = supdown - lotsupdown * 500;
   }
   else
   {
   needassetsupdown = supdown - 3 * 500 - (lotsupdown - 3) * 750;
   }
   
   if (lotsdown < 3)
   {
   needassetsdown = sdown - lotsdown * 500;
   }
   else
   {
   needassetsdown = sdown - 3 * (500) - (lotsdown - 3) * (750);
   Print("Care if buy more 8 lots");
   }
   //Print(lotsdown);
   //Print("limit: ", s, " need magrin:", lots * 500, " limit+margin: ", needassets, " may be free assets:", needassets+AccountBalance(), " open lots: ", openlots, " curent P/L:", scurent, " swap:", swapsum);
   Print("curent margin:", AccountMargin(), " curent balance:",AccountBalance(), " open lots: ", openlots, " swap:", swapsum, " esential assets: ", needassetsdown);
   Print("up down free assets:", needassetsupdown+AccountBalance(), " free+swap+credit:",needassetsupdown+AccountBalance()+swapsum);
   Print("down free assets:", needassetsdown+AccountBalance(), " open lots: ", " free+swap+credit: ", needassetsdown+AccountBalance()+swapsum);
}

int start()
  {
//----
   calculatebalancelimit();   
//----
   return(0);
  }
//+------------------------------------------------------------------+