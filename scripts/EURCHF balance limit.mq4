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
   double s,scurent;
   double eurusd;
   double curentprice;
   double enter, exit;
   double lots;
   double openlots;
   double needassets;
   double swapsum;
   int k;
   
   eurusd = MarketInfo("EURUSD",MODE_BID);
   curentprice = Bid;
   exit = 1.199;
      
   total = OrdersTotal();
   
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   enter = OrderOpenPrice();
   if ((OrderType()==OP_SELLLIMIT)||(OrderType()==OP_BUYSTOP)) continue;
   //if (OrderTakeProfit()!=0) continue;
   if ((OrderType()==OP_SELL)||(OrderType()==OP_SELLLIMIT)||(OrderType()==OP_SELLSTOP))
   {
   k = -1;
   }
   else
   {
   k = 1;
   }
   if ((OrderType()==OP_BUY)||(OrderType()==OP_SELL))
      {
      openlots = openlots + OrderLots()*k;
      scurent = scurent + 100000*(1-enter/curentprice)*OrderLots()*eurusd*k;
      }
   s = s + 100000*(1-enter/exit)*OrderLots()*eurusd * k;
   lots = lots + OrderLots() * k;
   swapsum = swapsum + OrderSwap();
   }
   needassets = s-lots * AccountMargin()/openlots;
   Print("limit: ", s, " need magrin:", lots * 800, " limit+margin: ", needassets, " may be free assets:", needassets+AccountBalance(), " open lots: ", openlots, " curent P/L:", scurent, " swap:", swapsum);
   Print("curent margin:", AccountMargin(), " curent balance:",AccountBalance());
}

int start()
  {
//----
   calculatebalancelimit();   
//----
   return(0);
  }
//+------------------------------------------------------------------+