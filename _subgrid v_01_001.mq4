//+------------------------------------------------------------------+
//|                                            _subgrid v_01_001.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
string strategyname;
int step = 4;
double lotsize = 0.01;
double price[];
double minopenprice;

void sortarray(double& pricearray[])
{
   int i1, i2;
   int total;
   double cash;
   
   total = ArraySize(pricearray);
   
   for (i1 = 0;i1 < total;i1++)
   {
      for (i2 = i1+1;i2 < total;i2++)
      {
         if (price[i1] < price[i2])
         {
         cash = price[i1];
         price[i1] = price[i2];
         price[i2] = cash;
         }
      }
   }
   
}


double findholeinpricearray()
{
   int pos;
   int total;
   double result;
   int lstep;
   
   result = -1;
   lstep = step;
   total = ArraySize(price);
   for (pos = 0; pos < total-1; pos++)
   {
   //Print("f: ",price[pos], " s: ",price[pos+1], " d: ", Point * step, " dif: ", price[pos]-price[pos+1]);
   if ((price[pos] != price[pos+1])&&(price[pos+1]<1.2100)&&(NormalizeDouble(price[pos]-Point, Digits) != NormalizeDouble(price[pos+1],Digits)))
      {
      //Print("f: ",price[pos], " s: ",price[pos+1], " d: ", Point * step, " dif: ", (price[pos]-Point));
      result = price[pos]-Point;
      break;
      }
   if (MathAbs(price[pos]-price[pos+1]) > (Point * lstep * 2 - Point))
      {
      if ((price[pos] - Point * lstep)!= price[pos+1])
         {
         result = price[pos] - Point * lstep;
         }
      break;
      }
   }
   
   return(result);
}

int init()
  {
//----
   strategyname = "EURCHF v0_001";   
   
   //dostep();
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
double initpricearray()
{
   int total;
   int pos;
   int count;
   
   total = OrdersTotal();
   count = 0;
   
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   if (OrderSymbol() != Symbol()) continue;
   ArrayResize(price, count + 1);
   price[count] = OrderOpenPrice();
   count = count + 1;
   }
}

void makeorder(double openprice)
{
   string ordername;
   int op;

   RefreshRates();
   
   op = OP_BUYSTOP;
   
   if (Ask > openprice)
   {
      op = OP_BUYLIMIT;
   }
   
   ordername = strategyname + " " + DoubleToStr(openprice, 4);
   //Print()
   OrderSend(Symbol(), op, lotsize, openprice, 0, 0, openprice + step * Point, ordername);
}

void dostep()
{
   double pricehole;
   
   initpricearray();
   sortarray(price);
   
   pricehole = findholeinpricearray();
   
   if (pricehole > 0)
   {
      Print(pricehole);
      makeorder(pricehole);
   }
}


int start()
  {
//----
   dostep();
//----
   return(0);
  }
//+------------------------------------------------------------------+