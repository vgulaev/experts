//+------------------------------------------------------------------+
//|                             _Butterfly_Potencial_of_Strategy.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

int sortticketbyopenprice(int& ticketarray[], string turn)
{
   int pos1;
   int pos2;
   int sizearray;
   int swapticket;
   double curprice;
   
   sizearray = ArraySize(ticketarray);
   
   for (pos1=0; pos1<sizearray; pos1++)
   {
      if(OrderSelect(ticketarray[pos1],SELECT_BY_TICKET)==false) continue;      
      curprice = OrderOpenPrice();
      for (pos2=pos1+1; pos2<sizearray; pos2++)
      {
      if(OrderSelect(ticketarray[pos2],SELECT_BY_TICKET)==false) continue;
      if (((OrderOpenPrice() > curprice)&&(turn=="up"))||((OrderOpenPrice() < curprice)&&(turn=="down")))
      //if ((OrderOpenPrice() < curprice)&&(turn=="down"))
         {
         swapticket = ticketarray[pos1];
         ticketarray[pos1] = ticketarray[pos2];
         ticketarray[pos2] = swapticket;
         curprice = OrderOpenPrice();
         }
      }
   }
}

double calculatemaxlosses()
{
   int total;
   int pos;
   int bi;
   double minpricebuy;
   double swap;
   double selllots;
   double sellprice;
   double buylots;
   double buyprice;
   double s;
   double negativeprofit;
   int ticketbyu[];  
   
   total = OrdersTotal();
   minpricebuy = 10;
   //find min buy order
   for (pos = 0; pos < total; pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)==false) continue;
      if (OrderType() != OP_BUY) continue;
      if (minpricebuy > OrderOpenPrice())
      {
      minpricebuy  = OrderOpenPrice();
      }
   }
   
   
   for (pos = 0; pos < total; pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)==false) continue;
      if (OrderType() != OP_SELL) continue;
      if (OrderOpenPrice() > minpricebuy) continue;
      swap = swap + OrderSwap();
      selllots = selllots + OrderLots();
      sellprice = sellprice + OrderLots() * OrderOpenPrice();
   }
   
   bi = 0;
   for (pos = 0; pos < total; pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)==false) continue;
      //if (StringSubstr(OrderComment(),0, lengthName) != idstrategy) continue;
      if (OrderSymbol() != Symbol()) continue;
      if (OrderType() == OP_BUY)
      {
      ArrayResize(ticketbyu, bi+1);
      ticketbyu[bi] = OrderTicket();
      bi = bi + 1;
      }
   }
   
   sortticketbyopenprice(ticketbyu, "up");
   
   for (pos = 0; pos < total; pos++)
   {
      if(OrderSelect(ticketbyu[pos],SELECT_BY_TICKET)==false) continue;
      if (buylots < selllots)
      {
         swap = swap + OrderSwap();
      
         if ((buylots + OrderLots()) > selllots)
         {
         buyprice = buyprice + (selllots-buylots) * OrderOpenPrice();
         buylots = selllots; 
         break;
         }
         else
         {
         buylots = buylots + OrderLots(); 
         buyprice = buyprice + OrderLots() * OrderOpenPrice();
         }
      }
      else
      {
      break;
      }
   }
   
   
   Print("Min buy price: ",minpricebuy, "sell average price: ", sellprice / selllots, " lots: ", selllots);
   Print("buy average price: ", buyprice / buylots, " lots: ", buylots);
   
   negativeprofit = (1 - buyprice / sellprice )* selllots *100000;
   s = negativeprofit + swap + AccountBalance();
   
   Print(" security assets: ", s, " if losses is: ",negativeprofit);
   //Print(ticketbyu[0]);
   
   return(999);
}
int start()
  {
//----
   calculatemaxlosses();
//----
   return(0);
  }
//+------------------------------------------------------------------+