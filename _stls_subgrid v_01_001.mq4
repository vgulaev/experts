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
double pricehigh;
double pricelow;
double lPoint;
double lowbuyprice;
double tpprice;
double pricehole;

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
   if ((price[pos] != price[pos+1])&&(price[pos+1]<1.5)&&(NormalizeDouble(price[pos]-lPoint, Digits) != NormalizeDouble(price[pos+1],Digits)))
      {
      //Print("f: ",price[pos], " s: ",price[pos+1], " d: ", Point * step, " dif: ", (price[pos]-Point));
      result = price[pos]-lPoint;
      break;
      }
   }
   
   if (price[total-1] > NormalizeDouble(pricelow,4)+Point)
   {
   result = pricelow;
   }
   
   if (price[0] < (NormalizeDouble(pricehigh,4)-Point))
   {
   result = pricehigh;
   }
   
   //Print(pricehigh);
   
   return(NormalizeDouble(result,4));
}

int init()
  {
//----
   strategyname = "EURUSD v0_001";
   lPoint = Point*10;
   lowbuyprice = 10;
   tpprice = 0;
   
   pricehigh = 1.33;
   pricelow = 1.31;
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
   int deletecount;
   int deleteTikets[];
      
   total = OrdersTotal();
   count = 0;
   deletecount = 0;
   
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   if (OrderSymbol() != Symbol()) continue;
   if ((OrderType() == OP_SELL)||(OrderType() == OP_SELLLIMIT)) continue;
   if (checkstrategy(OrderComment()) == false) continue;
   if (((OrderOpenPrice() < pricelow-Point)||(OrderOpenPrice() > pricehigh+Point))&&(OrderType()!=OP_BUY))
   {
      ArrayResize(deleteTikets, deletecount+1);
      deleteTikets[deletecount] = OrderTicket();
      deletecount++;
      continue;
   }
   
   ArrayResize(price, count + 1);

   if (StringLen(OrderComment())==20)
   {
   price[count] = StrToDouble(StringSubstr(OrderComment(), StringLen(OrderComment())-6));
   }
   else
   {
   price[count] = OrderOpenPrice();
   }
   
   if ((OrderStopLoss() == 0)&&(OrderLots()==0.01))
   {
      if ((OrderType() == OP_BUY)||(OrderType() == OP_BUYLIMIT)||(OrderType() == OP_BUYSTOP))
      {
      //OrderModify(OrderTicket(), price[count], price[count] - 10*lPoint, OrderTakeProfit(),0);
      }
   }
   
   //definite a minimal price in buy heap
   if ((OrderType() == OP_BUY)&&(OrderOpenPrice() < lowbuyprice))
   {
   lowbuyprice = OrderOpenPrice();
   }
   
   if ((OrderTakeProfit() != tpprice)&&(OrderType() == OP_BUY)&&(tpprice > 1)&&(OrderOpenPrice()<tpprice)&&(pricehole < 0))
   {
      OrderModify(OrderTicket(), price[count], 0, tpprice,0);
      //OrderModify(OrderTicket(), price[count], OrderStopLoss(), tpprice,0);
      //Print("try");
   }
   
   count = count + 1;
   }
   
   tpprice = lowbuyprice + 100 * lPoint;
   lowbuyprice = tpprice;
   
   for (pos = 0; pos < deletecount; pos ++)
   {
   OrderDelete(deleteTikets[pos]);
   }
   
}

void makeorder(double openprice)
{
   string ordername;
   int op;
   int ticket;
   int err;

   RefreshRates();
   
   op = OP_BUYSTOP;
   
   if (Ask > openprice)
   {
      op = OP_BUYLIMIT;
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
   }
   if (ticket == -1)
   {
   err = GetLastError();
   Print("Error: ",err);
   }
}

void checkrange()
{
   /*if (GlobalVariableCheck("EURUSD high (simple)"))
   {
      pricehigh = GlobalVariableGet("EURUSD high (simple)");
   }
   
   if (GlobalVariableCheck("EURUSD low (simple)"))
   {
      pricelow = GlobalVariableGet("EURUSD low (simple)");
   }*/
   if (GlobalVariableCheck("EURUSD high"))
   {
      pricehigh = GlobalVariableGet("EURUSD high");
   }
   
   if (GlobalVariableCheck("EURUSD low"))
   {
      pricelow = GlobalVariableGet("EURUSD low");
   }
}

void dostep()
{
   if (IsTradeAllowed())
   {
      checkrange();
      initpricearray();
      sortarray(price);
   
      pricehole = findholeinpricearray();
   
      if (pricehole > 0)
      {
         Print(pricehole);
         makeorder(pricehole);
      }
   }
}


int start()
  {
//----
   //Print(pricelow);
   dostep();
//----
   return(0);
  }
//+------------------------------------------------------------------+