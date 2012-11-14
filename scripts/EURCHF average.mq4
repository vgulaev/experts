//+------------------------------------------------------------------+
//|                                               EURCHF average.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   int pos;
   int total;
   double lotsbuy;
   double heapbuy;
   double lotssell;
   double heapsell;
   double lotsselll;
   double heapselll;
   double lotsbuys;
   double heapbuys;
   
   total = OrdersTotal();
   
   for (pos=0;pos<total;pos++)   
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      if (OrderSymbol() != Symbol()) continue;
      //if ((OrderType()==OP_BUY)&&(OrderTakeProfit() == 0))
      if ((OrderType()==OP_BUY))
      {
         lotsbuy = lotsbuy + OrderLots();
         heapbuy = heapbuy + OrderLots()*OrderOpenPrice();
      }
      else if (OrderType()==OP_SELL)
      {
         lotssell = lotssell - OrderLots();
         heapsell = heapsell - OrderLots()*OrderOpenPrice();
      }
      else if (OrderType()==OP_SELLLIMIT)
      {
         lotsselll = lotsselll - OrderLots();
         heapselll = heapselll - OrderLots()*OrderOpenPrice();
      }
      else if (OrderType()==OP_BUYSTOP)
      {
         lotsbuys = lotsbuys + OrderLots();
         heapbuys = heapbuys + OrderLots()*OrderOpenPrice();
      }
   }
   Print("lots buy: ", lotsbuy, " average price buy: ", heapbuy/lotsbuy);
   Print("with sell limmit & buy stop lots: ", lotsbuy+lotssell+lotsselll+lotsbuys, " average price total: ", (heapbuy+heapsell+heapselll+heapbuys)/(lotsbuys+lotsbuy+lotssell+lotsselll));
   Print("lots total: ", lotsbuy+lotssell, " average price total: ", (heapbuy+heapsell)/(lotsbuy+lotssell));
   //Print("b:", lotsbuy, " s:", lotssell);
//----
   return(0);
  }
//+------------------------------------------------------------------+