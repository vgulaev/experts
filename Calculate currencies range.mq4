//+------------------------------------------------------------------+
//|                                   Calculate currencies range.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
datetime timeoflastmessage;
double minpriceEUR;

int init()
  {
//----
   minpriceEUR = 1.279;
   
   rebalansrangesimple();
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
void rebalansrangeEURUSD()
{
   int pos;
   int total;
   double priceEURmax;
   double openpriceEUR;
   double lotsEUR;
   double priceEURhigh;
   double priceEURlow;
   double priceCHFhigh;
   double balance;
   
   minpriceEUR = 1.243;
   total = OrdersTotal();
   priceEURmax = 0;
      
   for (pos = 0; pos<total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   
      if (OrderSymbol() == "EURUSD")
      {
         if ((OrderOpenPrice() > priceEURmax)&&(OrderType() == OP_BUY))
         {
         priceEURmax = OrderOpenPrice();
         }
      }
   }
   
   openpriceEUR = MarketInfo("EURUSD", MODE_ASK);
   //balance = AccountBalance()/2;
   balance = AccountBalance()*0.36;
   
   lotsEUR = -balance * minpriceEUR/(499*minpriceEUR-500*openpriceEUR)/400;
   //currentlots = currentbalance*borderprice/(501*borderprice-500*currentprice)/400;
   
   priceEURhigh = NormalizeDouble(openpriceEUR + MathRound(lotsEUR * 100 / 2) * Point * 10,4);
   //Print(priceEURhigh, " ", priceEURmax, " lots:", lotsEUR);
   if (priceEURhigh < priceEURmax)
   {
      priceEURhigh = priceEURmax;
      openpriceEUR = priceEURmax;
      lotsEUR = -99.8*minpriceEUR+100*openpriceEUR-0.02*MathSqrt(24900100*minpriceEUR*minpriceEUR-49900000*minpriceEUR*openpriceEUR+25000000*openpriceEUR*openpriceEUR-5*balance*minpriceEUR);
   }
   
   priceEURlow = NormalizeDouble(priceEURhigh - MathRound(lotsEUR * 100) * Point * 10,4);
   
   Print("EURUSD balance:",  balance, " lots: ", lotsEUR);
   Print("USD border: ", priceEURlow, " ", priceEURhigh);
   
   
   if (priceEURhigh > 0)
   {
      GlobalVariableSet("EURUSD high", priceEURhigh);
   }
   if (priceEURlow > 0)
   {
      GlobalVariableSet("EURUSD low", priceEURlow);
   }
}

//sym - symbol wich need recalculate
//bp - it is border (minimal) price wich decided like unachieved
//kbalance - it is what part of balanced amounted to this symbol,
//          if kbalance<1 than it is the part of AccountBalance, 
//          other side it is fix sum from balanse.
void rebalanssymbolrangesell(string sym, double bp, double kbalance)
{
   int pos;
   int total;
   double borderprice;
   double minprice;
   double currentprice;
   double currentbalance;
   double currentlots;
   double pricehigh;
   double pricelow;
   double lPoint;
   
   borderprice = bp;
   total = OrdersTotal();
   minprice = 1000;
      
   for (pos = 0; pos<total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   
      if (OrderSymbol() == sym)
      {
         if ((OrderOpenPrice() < minprice)&&(OrderType() == OP_SELL))
         {
         minprice = OrderOpenPrice();
         }
      }
   }
   
   currentprice = MarketInfo(sym, MODE_ASK);
   lPoint = MarketInfo(sym, MODE_POINT) * 10;
   
   //balance = AccountBalance()/2;
   //currentbalance = AccountBalance()*0.55 + AccountCredit()*0.7;
   if (kbalance < 1)
   {
   currentbalance = AccountBalance()* kbalance;
   }
   else
   {
   currentbalance = kbalance;
   }
   Print(sym + " balance:",  currentbalance);
   
   currentlots = currentbalance*borderprice/(501*borderprice-500*currentprice)/400;
   
   //Print("lots EURNZD: ", currentlots, " :: ",currentbalance*borderprice);
   pricehigh = NormalizeDouble(currentprice + MathRound(currentlots*100)*lPoint,MarketInfo(sym, MODE_DIGITS)-1);
   pricelow = NormalizeDouble(currentprice - MathRound(currentlots*100)*lPoint,MarketInfo(sym, MODE_DIGITS)-1);
   
   if (pricelow > minprice)
   {
      pricelow = minprice;
      currentlots = -(-501*borderprice+500*minprice+MathSqrt(251001*borderprice*borderprice-501000*borderprice*minprice+250000*minprice*minprice-500*lPoint*currentbalance*borderprice))/lPoint/100000;
      
      pricehigh = NormalizeDouble(pricelow + MathRound(2*currentlots*100) * lPoint,MarketInfo(sym, MODE_DIGITS)-1);
   }
   //Print("ttt:", lotsEUR);
   
   Print(sym + " border: ",pricelow, " ", pricehigh, " curent price: ", currentlots);
   
   if (pricehigh > 0)
   {
      GlobalVariableSet(sym + " high", pricehigh);
   }
   if (pricelow > 0)
   {
      GlobalVariableSet(sym + " low", pricelow);
   }
}

void rebalansrangesimple()
{
   double priceEURhigh;
   double priceEURlow;
   double lots;
   double minEUR;
   
   minEUR = 1.32;
   priceEURhigh = 1.32;
   //priceEURlow = 1.2667 - NormalizeDouble((19000 - AccountMargin())/50*Point*10,4);
   
   //lots = 0.09169999967-1.600000000*10^(-10)*sqrt(3.284722633*10^17-7.812500001*10^12*k)
   //699999998E--2,0000000000E- sqrt(2,1022224999E--5,0000000000E- k)
   //lots = NormalizeDouble(0.091699999670-MathSqrt(0.008408889940-0.0000002 * AccountBalance()),4);
   lots = -1.175+0.9999999999*minEUR-MathSqrt(1.380625000-2.350000000*minEUR+minEUR*minEUR-0.0000002*AccountBalance());
   
   //Print("lots: ", lots, " mult:", 0.0000002*AccountBalance());
   //Print("lots: ", lots, " mult: ", 0.008408889940-0.0000002 * AccountBalance());
   
   priceEURlow = NormalizeDouble(priceEURhigh - lots,4);
   //priceEURlow = 1.18;

   if (priceEURhigh > 0)
   {
      GlobalVariableSet("EURUSD high", priceEURhigh);
   }
   if (priceEURlow > 0)
   {
      GlobalVariableSet("EURUSD low", priceEURlow);
   }
}

void rebalansrangeCHFUSD()
{
   double priceEURhigh;
   double priceEURlow;

   if (NormalizeDouble(MarketInfo("USDCHF", MODE_ASK), 4) > 0.901)
   {
   priceEURhigh = NormalizeDouble(MarketInfo("USDCHF", MODE_ASK) + 0.005, 4);
   }
   else
   {
   priceEURhigh = 0.91;
   }
   //priceEURlow = NormalizeDouble(MarketInfo("USDCHF", MODE_BID) - 0.005, 4);
   priceEURlow = 0.9;

   if (priceEURhigh > 0)
   {
      GlobalVariableSet("USDCHF high (simple)", priceEURhigh);
   }
   if (priceEURlow > 0)
   {
      GlobalVariableSet("USDCHF low (simple)", priceEURlow);
   }
}

void rebalansrange50(string sym, double amountperposition, double kbalance)
{
   double currentlots;
   double minprice;
   double pricehigh;
   double pricelow;
   double currentprice;
   double lPoint;
   int total;
   int pos;
   
   total = OrdersTotal();
   minprice = 0;
      
   for (pos = 0; pos<total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
   
      if (OrderSymbol() == sym)
      {
         if ((OrderOpenPrice() > minprice)&&(OrderType() == OP_BUY))
         {
         minprice = OrderOpenPrice();
         }
      }
   }
   
   currentprice = MarketInfo(sym, MODE_ASK);
   lPoint = MarketInfo(sym, MODE_POINT) * 10;

   currentlots = kbalance/amountperposition/100;
   
   pricehigh = NormalizeDouble(currentprice + MathRound(currentlots*50)*lPoint,MarketInfo(sym, MODE_DIGITS)-1);
   pricelow = NormalizeDouble(currentprice - MathRound(currentlots*50)*lPoint,MarketInfo(sym, MODE_DIGITS)-1);

   if (pricehigh < minprice)
   {
      pricehigh = minprice;
      pricelow = NormalizeDouble(pricehigh - MathRound(currentlots*100)*lPoint,MarketInfo(sym, MODE_DIGITS)-1);
   }
   
   Print(sym + " border: ",pricelow, " ", pricehigh, " curent lots: ", currentlots);
   
   if (pricehigh > 0)
   {
      GlobalVariableSet(sym + " high", pricehigh);
   }
   if (pricelow > 0)
   {
      GlobalVariableSet(sym + " low", pricelow);
   }
}

int start()
  {
//----
   double price;
   datetime curenttime;
   string MailText;
   
   curenttime = TimeCurrent();
   
   if ((curenttime-timeoflastmessage > 60*10))
   {
   //price = MarketInfo("EURCHF", MODE_BID);
   //MailText = potentialOfStrategy() + "Best regards";
   rebalansrangesimple();
   //rebalansrangeEURUSD();
   //rebalansrangeCHFUSD();
   //rebalansrange50("AUDCHF", 50, 15000);
   //rebalansrange50("NZDCHF", 50, 20000);
   //rebalansrange50("EURJPY", 50, 30000);
   //rebalansrange50("EURGBP", 50, 10000);
   
   //rebalansrange50("CADCHF", 50, 12500);
   //rebalansrangeEURNZD();
   //rebalansrangeEURJPY();
   //uerusd balance = AccountBalance()*0.25;
   //for eurnzd annihilation need 11000
   //55000
   //rebalanssymbolrange("EURNZD", 1.68, 0.45);
   //rebalanssymbolrange("EURJPY", 113, 0.25);
   //rebalanssymbolrange("EURNZD", 1.68, 24000);
   //rebalanssymbolrange("EURJPY", 113, 13000);
   //rebalanssymbolrange("EURAUD", 1.33, AccountBalance()*0.75 - 24000 - 13000 + AccountMargin());
   //rebalansrangesimple();
   Print("I/'am rebalansed range, free assets: ", AccountBalance());
   timeoflastmessage = curenttime;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+