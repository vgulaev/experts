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
int namelenght;
double prices[];

bool checkstrategy(string sn)
{
   bool result;
   result = (StringSubstr(sn,0,namelenght) == strategyname);
   return(result);
}

double pricefromcomment(string sc)
{
   double result;
   result = StrToDouble(StringSubstr(OrderComment(), 13));
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
   price = min + Point*10;
   while (NormalizeDouble(price,Digits-1) < NormalizeDouble(max,Digits-1))
   {
   otype = NormalizeDouble(price * 10000, 0);
   //otype = OP_SELL;
   otype = OP_BUY;
   //lotsize = 0.02;
   //lotsize = 0.01;
   lotsize = 0.05;
   //OrderSend(Symbol(), determinateoperation(otype, price), lotsize, price, 0, 0, 0, strategyname + modificator(otype, price));
   //if (determinateoperation(otype, price) == OP_BUYSTOP)
   //if (price < 1.2065)
   //{
   OrderSend(Symbol(), determinateoperation(otype, price), lotsize, price, 0, 0, 0, strategyname + DoubleToStr(price,Digits-1));
   //}
   
   Print(price, " ot:", otype);
   price = price + Point*10;
   price = NormalizeDouble(price, Digits-1);
   }
}

void findhole()
{
   //strategyname = "Subgrid Grid ";
   //strategyname = "EURCHF v0_001 ";
   //strategyname = "EURUSD v0_001 ";
   //strategyname = "USDCHF v0_001 ";
   strategyname = Symbol() + " v0_001 ";   
   namelenght = StringLen(strategyname);
   
   int total;
   int pos;
   int count;
   
   total = OrdersTotal();
   count = 0;
   
   for (pos=0;pos<total;pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   if (!checkstrategy(OrderComment())) continue;
   //if (OrderLots() != 0.01) continue;
   //if (OrderLots() != 0.02) continue;
   //if (OrderLots() != 0.03) continue;
   if (OrderType() % 2 != 0) continue;
   //if (OrderTakeProfit() != 0) continue;
   //if (OrderOpenPrice() >1.2419) continue;
   
   ArrayResize(prices, count+1);
   prices[count] = pricefromcomment(OrderComment());
   //Print(prices[count]);
   count = count + 1;
   }
   
   Print(count );
   
   sortarray(prices);
   
   for (pos=0;pos<count-1;pos++)
   {
   if (NormalizeDouble(prices[pos]-prices[pos+1]-Point, Digits-1) !=0)
   {
   //Print(prices[pos], " ",prices[pos+1]);
   createorders(prices[pos+1],prices[pos]);
   //break;
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