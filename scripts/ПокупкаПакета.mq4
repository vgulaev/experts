//+------------------------------------------------------------------+
//|                                                ПокупкаПакета.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
string makeid()
{
   int total;
   string res;
   
   res = "0.1658";
   
   return(res);
} 
int buysell(string sym, double lots, int op)
{
   double price;
   int ticket;
   string id;
   
   id = makeid();

   ticket = -1;
   while (ticket == -1)
   {
      if (op == OP_BUY)
      {
      price = MarketInfo(sym, MODE_ASK);
      ticket = OrderSend(sym, OP_BUY, lots, price,0,0,0, id);
      }
      else
      {
      price = MarketInfo(sym, MODE_BID);
      ticket = OrderSend(sym, OP_SELL, lots, price,0,0,0, id);
      }
   }
   
   return(0);
}
int start()
  {
//----
   buysell("6SU1",      0.01, OP_BUY);
   buysell("USDSEK",    0.02, OP_SELL);
   buysell("6CU1",      0.04, OP_BUY);
   buysell("6BU1",      0.05, OP_BUY);
   buysell("6JU1",      0.04, OP_BUY);
   buysell("EURUSD",    0.18, OP_BUY);
   buysell("DXU1",      0.59, OP_BUY);
   
   //kdx=0.59 s min:-91.8766 min/kdx: -155.723 ke:0.18 kj:0.04 kb:0.05 kc:0.04 kk:0.02 ks:0.01 $$: 907.448 subsidence: -45.9383
//----
   return(0);
  }
//+------------------------------------------------------------------+