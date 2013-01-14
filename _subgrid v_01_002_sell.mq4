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
int step = 2;
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
   double hprice;
   int lstep;
   
   result = -1;
   lstep = step;
   total = ArraySize(price);
   for (pos = 0; pos < total-1; pos++)
   {
   //Print("f: ",price[pos], " s: ",price[pos+1], " d: ", Point * step, " dif: ", price[pos]-price[pos+1]);
   if ((price[pos] != price[pos+1])&&(price[pos+1]>1.200)&&(NormalizeDouble(price[pos]-Point, Digits) != NormalizeDouble(price[pos+1],Digits)))
      {
      //Print("f: ",price[pos], " s: ",price[pos+1], " d: ", Point * step, " dif: ", (price[pos]-Point));
      result = price[pos]-Point;
      //result = price[pos+1]+Point;
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
   
   hprice = 1.212;
   
   if (price[0]< hprice)
   {
   result = hprice;
   }
   
   return(result);
}

int init()
  {
//----
   strategyname = "EURCHF v0_009";
   
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
bool checkstrategy(string sn)
{
   bool result;
   result = (StringSubstr(sn,0,13) == strategyname);
   return(result);
}

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
   if ((OrderType() == OP_BUY)||(OrderType() == OP_BUYLIMIT)||(OrderType() == OP_BUYSTOP)) continue;
   if (checkstrategy(OrderComment()) == false) continue;
   ArrayResize(price, count + 1);
   //Print(StringLen(OrderComment()));
   if (StringLen(OrderComment())==20)
   {
   price[count] = StrToDouble(StringSubstr(OrderComment(), StringLen(OrderComment())-6));
   }
   else
   {
   price[count] = OrderOpenPrice();
   }
   
   if ((OrderTakeProfit() == 0)&&(OrderLots()==0.01))
   {
      if ((OrderType() == OP_SELL)||(OrderType() == OP_SELLLIMIT)||(OrderType() == OP_SELLSTOP))
      {
      OrderModify(OrderTicket(), price[count],0, price[count] - 4*Point,0);
      //OrderModify(OrderTicket(), price[count],0, price[count] - 2*Point,0);
      //Print("try modify ",OrderOpenPrice());
      }
   }
   
   if ((OrderOpenPrice()-OrderTakeProfit() > 3 * Point)&&(OrderType() == OP_SELL))
   {
   OrderModify(OrderTicket(), price[count],0, price[count] - 2*Point,0);
   }
   
   count = count + 1;
   }
}

void makeorder(double openprice)
{
   string ordername;
   int op;
   int ticket;
   int err;

   RefreshRates();
   
   op = OP_SELLLIMIT;
   
   if (Bid > openprice)
   {
      op = OP_SELLSTOP;
   }
   
   ordername = strategyname + " " + DoubleToStr(openprice, 4);
   //Print()
   
   if ((openprice == 0.2050))
   {
   ticket = OrderSend(Symbol(), op, 0.5, openprice, 0, 0, openprice + 5 * Point, ordername);
   }
   else if ((openprice == 0.2150))
   {
   ticket = OrderSend(Symbol(), op, 0.06, openprice, 0, 0, openprice + 5 * Point, ordername);
   //Print("try open deca");
   }
   else
   {
   //ticket = OrderSend(Symbol(), op, lotsize, openprice, 0, 0, openprice + step * Point, ordername);
   ticket = OrderSend(Symbol(), op, lotsize, openprice, 0, 0, 0, ordername);
   //Print("Price open: ", openprice);
   }
   if (ticket == -1)
   {
   err = GetLastError();
   Print("Error: ",err);
   }
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