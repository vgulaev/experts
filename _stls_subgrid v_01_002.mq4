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
double lotsize = 0.03;
double price[];
double minopenprice;
double pricehigh;
double pricelow;
double lPoint;
double lowbuyprice;
double tpprice;
double pricehole;
int lDigits;

string hightname;
string lowname;

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
   if ((price[pos] != price[pos+1])&&(price[pos+1]<150)&&(NormalizeDouble(price[pos]-lPoint, Digits) != NormalizeDouble(price[pos+1],Digits)))
      {
      //Print("f: ",price[pos], " s: ",price[pos+1], " d: ", Point * step, " dif: ", (price[pos]-Point));
      result = price[pos]-lPoint;
      break;
      }
   }
   
   if (price[total-1] > NormalizeDouble(pricelow,lDigits)+Point)
   {
   result = pricelow;
   }
   
   if (price[0] < (NormalizeDouble(pricehigh,lDigits)-Point))
   {
   result = pricehigh;
   }
   
   //Print(pricehigh);
   
   return(NormalizeDouble(result,lDigits));
}

int init()
  {
//----
   strategyname = Symbol() + " v0_001";
   lPoint = Point*10;
   lowbuyprice = 1000;
   tpprice = 0;
   
   lDigits     = 4;
   
   pricehigh = 1.33;
   pricelow = 1.31;
   
   if (Symbol() == "EURUSD")
   {
   hightname = "EURUSD high";
   lowname = "EURUSD low";
   }
   else if (Symbol() == "USDCHF")
   {
   hightname = "USDCHF high (simple)";
   lowname = "USDCHF low (simple)";
   }
   else if (Symbol() == "AUDCHF")
   {
   hightname = "AUDCHF high";
   lowname = "AUDCHF low";
   }
   else if (Symbol() == "NZDCHF")
   {
   hightname = "NZDCHF high";
   lowname = "NZDCHF low";
   }
   else if (Symbol() == "EURJPY")
   {
   hightname = "EURJPY high";
   lowname = "EURJPY low";
   lDigits     = 2;
   }
   else if (Symbol() == "EURGBP")
   {
   hightname = "EURGBP high";
   lowname = "EURGBP low";
   }
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
   if (StringLen(OrderComment()) != 20) continue;
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
   
   /*
   if ((OrderTakeProfit() != tpprice)&&(OrderType() == OP_BUY)&&(tpprice > 0.2)&&(OrderOpenPrice()<tpprice)&&(pricehole < 0)&&(OrderOpenPrice()<(Ask+lPoint*15)))
   {
      OrderModify(OrderTicket(), price[count], 0, tpprice,0);
   }
   */
   
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
   
   ordername = strategyname + " " + DoubleToStr(openprice, lDigits);
   //Print()
   
   RefreshRates();
   if (MathAbs(openprice - Ask) > MarketInfo(Symbol(), MODE_STOPLEVEL) * Point)
   {
   //ticket = OrderSend(Symbol(), op, lotsize, openprice, 0, 0, openprice + step * Point, ordername);
   ticket = OrderSend(Symbol(), op, lotsize, openprice, 0, 0, 0, ordername);
   Print(openprice);
   }
   if (ticket == -1)
   {
   err = GetLastError();
   Print("Error: ",err);
   }
}

void checkrange()
{
   if (GlobalVariableCheck(hightname))
   {
      pricehigh = GlobalVariableGet(hightname);
   }
   
   if (GlobalVariableCheck(lowname))
   {
      pricelow = GlobalVariableGet(lowname);
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
         //Print(pricehole);
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