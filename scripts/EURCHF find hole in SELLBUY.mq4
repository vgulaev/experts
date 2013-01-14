//+------------------------------------------------------------------+
//|                                  EURCHF find hole in SELLBUY.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
string strategyname;
double prices[];

bool checkstrategy(string sn)
{
   bool result;
   result = (StringSubstr(sn,0,13) == strategyname);
   return(result);
}

double pricefromcomment(string sc)
{
   double result;
   result = StrToDouble(StringSubstr(OrderComment(), 19));
   return(result);
}

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
         if (pricearray[i1] < pricearray[i2])
         {
         cash = pricearray[i1];
         pricearray[i1] = pricearray[i2];
         pricearray[i2] = cash;
         }
      }
   }
   
}

int determinateoperation(int op, double p) 
{
   int result;
   RefreshRates();
   if (op == OP_BUY)
   {
   if (p < Ask)
   {
   result = OP_BUYLIMIT;
   }
   else
   {
   result = OP_BUYSTOP;
   }
   }
   else if (op == OP_SELL)
   {
   if (p > Bid)
   {
   result = OP_SELLLIMIT;
   }
   else
   {
   result = OP_SELLSTOP;
   }
   }
   return(result);
}

string modificator(int op, double p) 
{
   string result;
   if (op == OP_BUY)
   {
   result = " BUY  ";
   }
   else
   {
   result = " SELL ";
   }
   result = result + DoubleToStr(p,4);
   return(result);
}

void createorders(double min, double max)
{
   double price;
   double lotsize;
   int otype;
   
   //Print("min:", min, " max:", max);
   price = min + Point;
   while (NormalizeDouble(price,4) < NormalizeDouble(max,4))
   {
   otype = NormalizeDouble(price * 10000, 0);
   otype = otype % 2;
   //lotsize = 0.02;
   lotsize = 0.01;
   if (otype == 1)
   {
   //lotsize = 0.02;
   lotsize = 0.01;
   }
   OrderSend(Symbol(), determinateoperation(otype, price), lotsize, price, 0, 0, 0, strategyname + modificator(otype, price));
   Print(price, " ot:", otype);
   price = price + Point;
   price = NormalizeDouble(price, 4);
   }
}

void findhole()
{
   strategyname = "sellbuy v0_01";
   
   int total;
   int pos;
   int count;
   
   total = OrdersTotal();
   count = 0;
   
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   if (!checkstrategy(OrderComment())) continue;
   //if (OrderLots() == 0.01) continue;
   if (OrderTakeProfit() != 0) continue;
   if (OrderOpenPrice() >1.2419) continue;
   
   ArrayResize(prices, count+1);
   prices[count] = pricefromcomment(OrderComment());
   //Print(prices[count]);
   count = count + 1;
   }
   
   sortarray(prices);
   
   for (pos=0;pos<count-1;pos++)
   {
   if (NormalizeDouble(prices[pos]-prices[pos+1]-Point, 4) !=0)
   {
   //Print(prices[pos], " ",prices[pos+1]);
   createorders(prices[pos+1],prices[pos]);
   }
   }
}
   
int start()
  {
//----
   findhole();
//----
   return(0);
  }
//+------------------------------------------------------------------+