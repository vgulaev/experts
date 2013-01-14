//+------------------------------------------------------------------+
//|                                                 _grid_border.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
double averagelots[];
double averageprice[];
void calculategridborder()
{
   int pos;
   int total;
   int isymbol;
   double borderprice;
   
   total = OrdersTotal();
   
   for (pos=0;pos<total;pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      if (OrderSymbol() == "EURUSD")
      {
      isymbol = 0;
      }
      else if (OrderSymbol() == "USDCHF")
      {
      isymbol = 1;
      }
      
      averageprice[isymbol] = (averageprice[isymbol]* averagelots[isymbol]+OrderOpenPrice()* OrderLots())/(averagelots[isymbol] + OrderLots());
      averagelots[isymbol] = averagelots[isymbol] + OrderLots();
   }
   
   Print("EURUSD: ", averagelots[0], " lots by ", averageprice[0]);
   
   borderprice = 100000*averagelots[0]*averageprice[0]/(99800*averagelots[0]+AccountBalance());
   Print("border price: ", borderprice);
   
}

void init()
{
   //EURUSD - 0
   //USDCHF - 1
   ArrayResize(averagelots, 2);
   ArrayResize(averageprice, 2);
}

int start()
  {
//----
   init();
   calculategridborder();   
//----
   return(0);
  }
//+------------------------------------------------------------------+