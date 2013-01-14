//+------------------------------------------------------------------+
//|                                    АнализВолотильностиРынков.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
double CalcVolotilnost(string sym, int day)
{
   int pos;
   double m = 0;
   
   for (pos=0; pos < day; pos++)
   {
      m = m + MathAbs(iHigh(sym, PERIOD_D1, pos) - iLow(sym, PERIOD_D1, pos));
      //Print(iHigh(sym, PERIOD_D1, pos), " ", m);
      //break;
   }
   
   return(m/day/MarketInfo(sym,MODE_POINT));
}

double CalcMaxD(string sym, int day)
{
   
   int pos;
   double m = 0;
   
   for (pos=0; pos < day; pos++)
   {
      if (MathAbs(iHigh(sym, PERIOD_D1, pos) - iLow(sym, PERIOD_D1, pos)) > m)
      {
      m = MathAbs(iHigh(sym, PERIOD_D1, pos) - iLow(sym, PERIOD_D1, pos));
      }
   }
   
   return(m/MarketInfo(sym,MODE_POINT));
}

int start()
  {
//----
   int pos;
   int count;
   int days;
   string sym[];
   
   ArrayResize(sym, 7);
   
   //sym[0] = "USDJPY";
   //sym[0] = "USDJPY";
   sym[0] = "EURUSD";
   //sym[2] = "EURCHF";
   sym[1] = "USDCHF";
   sym[2] = "NZDCHF";
   sym[3] = "AUDCHF";
   sym[4] = "GBPCHF";
   sym[5] = "CADCHF";
   sym[6] = "USDHKD";
   //sym[8] = "GBPAUD";
   
   
   count = ArraySize(sym);
   days = 14;
   
   for (pos = 0; pos < count; pos++)
   {
      Print(" Среднедневная волотильность ", sym[pos], " = ", CalcVolotilnost(sym[pos], days), " пунктов (", days," days)", " percent:", CalcVolotilnost(sym[pos], days)*MarketInfo(sym[pos], MODE_POINT)/MarketInfo(sym[pos], MODE_ASK)*100);
      Print(" Максимальное изменение цены ", sym[pos], " = ", CalcMaxD(sym[pos], 14), " пунктов (", days," days)");
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+