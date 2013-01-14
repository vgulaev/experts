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
   datetime timeofstart, timeofend;
   datetime t;
   
   t = TimeCurrent();
   t = t - (TimeDayOfWeek(t)-1)*60*60*24- TimeHour(t)*60*60 - TimeMinute(t)*60 - TimeSeconds(t);
   
   timeofstart = t;
   timeofend = TimeCurrent();
   //timeofstart = StrToTime("2011.12.01 00:00");
   //timeofend = StrToTime("2011.12.31 23:59");
   
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
   profit = profit + OrderProfit() + OrderSwap()+OrderCommission();
   }
   }
   
   Print("lots:", volume, " pieces: ", pieces, " profit: ", profit, " grow percent: " ,profit/(AccountBalance()-profit)*100);
}

int start()
  {
//----
   printstatistic();   
//----
   return(0);
  }
//+------------------------------------------------------------------+