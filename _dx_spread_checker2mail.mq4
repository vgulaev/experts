//+------------------------------------------------------------------+
//|                                      _dx_spread_checker2mail.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
datetime timeoflastmessage;

int init()
  {
//----
   
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
double usdx(double ee,double ej,double eb,double ec,double ek,double es)
{
	double res;
	res = 93.80251457;
	res = res * MathPow(ee,-0.576)*MathPow(ej,-0.136)*MathPow(eb,-0.119)*MathPow(ec,-0.091)*MathPow(ek,0.042)*MathPow(es,-0.036);
	return(res);
}

double checkspread()
{
   double dx;
   double ee,ej,eb,ec,ek,es;
   double sp;
   
   sp = 0;
   
   dx = MarketInfo("DXU1#I", MODE_ASK);
   ee = MarketInfo("EURUSD", MODE_ASK);
   ej = MarketInfo("6JU1#I", MODE_ASK);
   eb = MarketInfo("6BU1#I", MODE_ASK);
   ec = MarketInfo("6CU1#I", MODE_ASK);
   ek = MarketInfo("USDSEK", MODE_BID);
   es = MarketInfo("6SU1#I", MODE_BID);
   
   if ((dx>0)&&(dx>0)&&(dx>0)&&(dx>0)&&(dx>0)&&(dx>0)&&(dx>0))
   {
   sp = dx - usdx(ee,ej,eb,ec,ek,es);
   }
   
   return(sp);
}

int sortticketbyopenprice(int& ticketarray[], string turn)
{
   int pos1;
   int pos2;
   int sizearray;
   int swapticket;
   double curprice;
   
   sizearray = ArraySize(ticketarray);
   
   for (pos1=0; pos1<sizearray; pos1++)
   {
      if(OrderSelect(ticketarray[pos1],SELECT_BY_TICKET)==false) continue;      
      curprice = OrderOpenPrice();
      for (pos2=pos1+1; pos2<sizearray; pos2++)
      {
      if(OrderSelect(ticketarray[pos2],SELECT_BY_TICKET)==false) continue;
      if (((OrderOpenPrice() > curprice)&&(turn=="up"))||((OrderOpenPrice() < curprice)&&(turn=="down")))
      //if ((OrderOpenPrice() < curprice)&&(turn=="down"))
         {
         swapticket = ticketarray[pos1];
         ticketarray[pos1] = ticketarray[pos2];
         ticketarray[pos2] = swapticket;
         curprice = OrderOpenPrice();
         }
      }
   }
}

string potentialOfStrategy()
{
   int ticketbyu[];
   int ticketsell[];
   int bi;
   int si;
   int total;
   int pos;
   int typeorder;
   double buyprofit;
   double averageprice;
   double buyselllots;
      
   bi = 0;
   si = 0;
   total = OrdersTotal();
   
   for (pos = 0; pos < total; pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)==false) continue;
      //if (StringSubstr(OrderComment(),0, lengthName) != idstrategy) continue;
      if (OrderSymbol() != "EURCHF") continue;
      if (OrderLots() !=  0.01) continue;
      //if (OrderOpenPrice() < 1.2280) continue;
      typeorder = OrderType();
      if (typeorder == OP_BUY)
      {
      ArrayResize(ticketbyu, bi+1);
      ticketbyu[bi] = OrderTicket();
      bi = bi + 1;
      
      if (OrderProfit() > 0.3)
      {
      buyprofit = buyprofit + OrderProfit();
      }
      }
      if (typeorder == OP_SELL)
      {
      ArrayResize(ticketsell, si+1);
      ticketsell[si] = OrderTicket();
      si = si + 1;
      }
      
      //calculate average PRICE_CLOSE
      if ((typeorder == OP_BUY)||(typeorder == OP_SELL))
      {
      averageprice = (averageprice * buyselllots + OrderOpenPrice()*OrderLots()*(1-2*typeorder))/(buyselllots + OrderLots()*(1-2*typeorder));
      buyselllots = buyselllots + OrderLots()*(1-2*typeorder);
      }
   }
   
   sortticketbyopenprice(ticketbyu, "down");
   sortticketbyopenprice(ticketsell, "up");
   double profit1;
   double s;
   double lotsamount;
   double swap;
   s = 0;
   
   for (pos = 0;pos < si; pos++)
   {
   if(OrderSelect(ticketbyu[pos],SELECT_BY_TICKET)==false) continue;
   //profit1 = OrderProfit();
   profit1 = OrderOpenPrice();
   swap = OrderSwap();
   //Print(profit1);
   if(OrderSelect(ticketsell[pos],SELECT_BY_TICKET)==false) continue;
   if (OrderOpenPrice() >= profit1)
      {
      s = s + (1 - profit1/OrderOpenPrice())*OrderLots()*100000 + OrderSwap() + swap;
      lotsamount = lotsamount + OrderLots();
      }
   }
   
   //Print("Potential profit: ",s , " size:", lotsamount);
   
   return(StringConcatenate("Potential profit Butterfly: ",s , " size:", lotsamount, "\r",
   "Buy profit: ", buyprofit, "\r",
   "Averrage price: ", averageprice, " buy sell lots: ", buyselllots, "\r"));
}

string returnsum()
{
   int total;
   int pos;
   double sum;
   double lots;

   total = OrdersTotal();
   
   for (pos = 0; pos < total; pos++)
   {
      if(OrderSelect(pos,SELECT_BY_POS)==false) continue;
      if (OrderType() < 2)
      {
      lots = lots + OrderLots() * (1 - 2 * OrderType());
      }
      if ((OrderType()==OP_BUY)&&(OrderProfit()>0.1))
      {
      sum = sum + OrderProfit();
      }
   }   
   
   return(StringConcatenate("Potential of close buy: ", sum, "\r", "Total lots: ", lots, "\r",
      "spread: ",MarketInfo("EURCHF", MODE_ASK) - MarketInfo("EURCHF", MODE_BID), "\r"));
}

int start()
  {
//----
   double price;
   datetime curenttime;
   string MailText;
   
   curenttime = TimeCurrent();
   
   if ((curenttime-timeoflastmessage > 60*20))
   {
   price = MarketInfo("EURCHF", MODE_BID);
   //MailText = potentialOfStrategy() + "Best regards";
   MailText = returnsum() + "Best regards";
   SendMail("pr:"+DoubleToStr(price, 4) + " b:"+DoubleToStr(AccountBalance(),2) + " " + TimeToStr(curenttime,TIME_MINUTES), MailText);
   Print("I/'am send mail");
   timeoflastmessage = curenttime;
   }
   //Print("I/'am work");
//----
   return(0);
  }
//+------------------------------------------------------------------+