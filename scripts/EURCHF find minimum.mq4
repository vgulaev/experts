//+------------------------------------------------------------------+
//|                                          EURCHF find minimum.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
double averageprice;
double totallots;

int calculateaverage(double l_openprice, double l_lots, int l_type)
{
   averageprice = (averageprice * totallots + l_openprice * l_lots * (1 - 2 * l_type))/(totallots + l_lots * (1 - 2 * l_type));
   totallots = totallots + l_lots * (1 - 2 * l_type);
   return(0);
}

double calculateminimum(double floorprice)
{
   double result;
   //double floorprice = 1.199;
   
   if (totallots > 3)
   {
   result = totallots * 100000 * (1 - averageprice/floorprice) - 3 * 500 - (totallots - 3) * 750;
   }
   else
   {
   result = totallots * 100000 * (1 - averageprice/floorprice) - totallots * 500;
   }
   
   return(result);
}

int sorttisketsarray(int& ticketarray[])
{
   int pos1;
   int pos2;
   int sizearray;
   int swapticket;
   double curprice;
   string turn;
   
   turn = "up";
   sizearray = ArraySize(ticketarray);
   
   for (pos1=0; pos1<sizearray; pos1++)
   {
      if(OrderSelect(ticketarray[pos1],SELECT_BY_TICKET)==false) continue;      
      curprice = OrderOpenPrice();
      for (pos2=pos1+1; pos2<sizearray; pos2++)
      {
      if(OrderSelect(ticketarray[pos2],SELECT_BY_TICKET)==false) continue;
      if (((OrderOpenPrice() > curprice)&&(turn=="up"))||((OrderOpenPrice() < curprice)&&(turn=="down")))
         {
         swapticket = ticketarray[pos1];
         ticketarray[pos1] = ticketarray[pos2];
         ticketarray[pos2] = swapticket;
         curprice = OrderOpenPrice();
         }
      }
   }
  
   return(0);
}

int findminimum()
{
   int pos;
   int total;
   int i;
   int tickets[];
   int n;
   double swapsum;
   double assets;
   
   total = OrdersTotal();
   n = 0;
   swapsum = 0;
   
   for (pos=0;pos<total;pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      if (OrderSymbol() != Symbol()) continue;
   
      if ((OrderType() == OP_BUY)||(OrderType() == OP_SELL))
      {
      calculateaverage(OrderOpenPrice(), OrderLots(), (OrderType() % 2));
      swapsum = swapsum + OrderSwap();
      }
      else if ((OrderType() == OP_BUYLIMIT)||(OrderType() == OP_SELLSTOP))
      {
      ArrayResize(tickets, n + 1);
      tickets[n] = OrderTicket();
      n = n + 1;
      }
   }
   
   sorttisketsarray(tickets);
   
   assets = AccountBalance() + AccountCredit() + swapsum;
   //Print(n);
   for (pos=0;pos<n-1;pos++)
   {
      if (OrderSelect(tickets[pos], SELECT_BY_TICKET) == false) continue;
      
      calculateaverage(OrderOpenPrice(), OrderLots(), (OrderType() % 2));
      if (calculateminimum(OrderOpenPrice()) +  assets < 0) 
      {
      //Print(OrderOpenPrice(), " == ", calculateminimum(OrderOpenPrice()) +  assets);
      }
      Print(OrderOpenPrice(), " == ", calculateminimum(OrderOpenPrice()) +  assets, " total lots: ", totallots);
      //Print(OrderOpenPrice());
   }   
   
   Print("assets: ", assets," average price: ", averageprice, " total lots: ", totallots, " minimum: ", calculateminimum(1.199)+assets);
      
   return(0);
}
 
int start()
  {
//----
   findminimum();
//----
   return(0);
  }
//+------------------------------------------------------------------+