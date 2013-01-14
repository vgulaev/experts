//+------------------------------------------------------------------+
//|                                            EURCHF statistics.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
void printstatistic()
{
   int pos;
   int total;
   int pieces;
   double volume;
   double profit;
   double pips;
   datetime timeofstart, timeofend;
   datetime t;
   
   t = TimeCurrent();
   t = t - TimeHour(t)*60*60 - TimeMinute(t)*60 - TimeSeconds(t);
   
   //Print(TimeToStr(t, TIME_DATE|TIME_MINUTES));
   //Print(TimeToStr(t+24*60*60-1, TIME_DATE|TIME_MINUTES));
   //timeofstart = StrToTime("2012.04.04 00:00");
   //timeofend = StrToTime("2012.04.04 23:59");   
   timeofstart = t;
   timeofend = t + 24*60*60 - 1;
   
   total = OrdersHistoryTotal();
   
   for (pos = 0;pos < total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY)==false) continue;
   //if ((OrderSymbol() == Symbol())&&(OrderProfit()!=0)&&(OrderLots()!=0.01))
   //if ((OrderSymbol() == Symbol())&&(OrderProfit()!=0)&&(OrderCloseTime()<timeofend)&&(OrderCloseTime()>timeofstart))
   if ((OrderType() < 5)&&(OrderCloseTime()<timeofend)&&(OrderCloseTime()>timeofstart)&&(OrderComment() != "cancelled"))
   {
   volume = volume + OrderLots();
   pieces = pieces + 1;
   pips = pips + MathAbs(OrderOpenPrice() - OrderClosePrice());
   profit = profit + OrderProfit() + OrderSwap()+OrderCommission();
   }
   }
   
   Print("lots:", volume, " profit: ", profit, " grow percent: " ,profit/(AccountBalance()-profit)*100);
}

int start()
  {
//----
   printstatistic();   
//----
   return(0);
  }
//+------------------------------------------------------------------+