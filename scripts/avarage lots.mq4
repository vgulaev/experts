//+------------------------------------------------------------------+
//|                                       _find_min_of_portfolio.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
double kec;
double eec;

double profitUSD(double enter,double exit)
{
	double res;
	res = 100000*(1-enter/exit);
	return(res);
}

void recalculate_e_k(string sym, double lots, double price, int ortype)
{
	int k;
	k = -1;
	if ((ortype == OP_BUY)||(ortype == OP_BUYLIMIT)||(ortype == OP_BUYSTOP))
	{
   k = 1;
	}
	if (sym == "EURCHF")
	{
	eec = eec + (price * lots) * k;
	kec = kec + lots * k;
	}
}

int calculate_average_position()
{
   int total;
   int pos;
   double swap;
   
   total = OrdersTotal();
   
   for (pos=0;pos<total;pos++)
   {
		if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
		if ((OrderType() == OP_BUY)||(OrderType() == OP_SELL))
		{
		recalculate_e_k(OrderSymbol(), OrderLots(), OrderOpenPrice(), OrderType());
		swap = swap + OrderSwap();
		}
   }
   Print("lots=", kec, " price:", eec/kec, " curent p/l:", kec * profitUSD(eec/kec,1.199) * MarketInfo("EURUSD",MODE_ASK) + swap);
}

int start()
  {
//----
	calculate_average_position();
	Print("Current value: ", 0, " assetbacking: ", 0);
//----
   return(0);
  }
//+------------------------------------------------------------------+