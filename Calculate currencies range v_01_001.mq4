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

void rebalansrangesimple()
{
   double priceEURhigh;
   double priceEURlow;
   double lots;
   double minEUR;
   
   minEUR = 1.3259;
   priceEURhigh = 1.3259;
   //priceEURlow = 1.2667 - NormalizeDouble((19000 - AccountMargin())/50*Point*10,4);
   
   //lots = 0.09169999967-1.600000000*10^(-10)*sqrt(3.284722633*10^17-7.812500001*10^12*k)
   //699999998E--2,0000000000E- sqrt(2,1022224999E--5,0000000000E- k)
   //lots = NormalizeDouble(0.091699999670-MathSqrt(0.008408889940-0.0000002 * AccountBalance()),4);
   lots = -1.175+0.9999999999*minEUR-MathSqrt(1.380625000-2.350000000*minEUR+minEUR*minEUR-0.0000002*AccountBalance()/2.2);
   
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

int sendincomeinformation()
{
   int total;
   int pos, i;
   int symbolstotal;
   double sum[];
   double swap[];
   double lots[];   
   string sym[];
   string msg;
   double s;
   
   symbolstotal = 1;
   ArrayResize(sym, symbolstotal);
   ArrayResize(sum, symbolstotal);
   ArrayResize(lots, symbolstotal);
   ArrayResize(swap, symbolstotal);
   
   sym[0] = "EURUSD";
   
   total = OrdersTotal();
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      for (i = 0; i<symbolstotal; i++)
      {
      if (OrderSymbol() == sym[i])
      {
      swap[i] = swap[i] + OrderSwap();
      if (OrderProfit() > 0)
      {
      sum[i] = sum[i] + OrderProfit() + OrderSwap() + OrderCommission();
      lots[i] = lots[i] + OrderLots();
      }
      }
      }
   }
   
   for (i = 0; i<symbolstotal; i++)
   {
      s = s + sum[i];
      msg = sym[i] + " : " + DoubleToStr(sum[i], 2) + "$ lots: " + DoubleToStr(lots[i], 2) + " swap: " + DoubleToStr(swap[i], 2);
      //SendNotification(msg);
      SendMail(msg, "Ñ íàéëó÷øèìè");
      Print("Send to phone: ", msg);
      sum[i] = 0;
      lots[i] = 0;
      swap[i] = 0;
   }
   //Print("Total sum: ", s);
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
   sendincomeinformation();
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