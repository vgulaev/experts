//+------------------------------------------------------------------+
//|                                                _set_stoploss.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
string strategyname;

bool checkstrategy(string sn)
{
   bool result;
   result = (StringSubstr(sn,0,13) == strategyname);
   return(result);
}

int start()
  {
//----
   int pos;
   int total;
   double tp;
   
   //strategyname = "EURUSD v0_001";
   total = OrdersTotal();
   
   for (pos = 0; pos<total; pos++)
   {
   if (OrderSelect(pos, SELECT_BY_POS)==false) continue;
   if (OrderSymbol() != Symbol()) continue;
   //if (OrderLots() != 0.02) continue;
   //if (OrderOpenPrice() < 1.235) continue;
   //if (!checkstrategy(OrderComment())) continue;
   //if (OrderOpenPrice() > 1.238) continue;
   //if (OrderStopLoss() == 0) continue;
   //if (OrderTakeProfit() != 0) continue;
   //if (OrderLots() != 0.01) continue;
   //if (OrderOpenPrice() > 1.215) continue;
   //if (OrderOpenPrice() < 1.3150) continue;
   //if (OrderType() != OP_BUY) continue;
   //if (OrderType() != OP_SELL) continue;
   
   if ((OrderType() == OP_BUY)||(OrderType() == OP_BUYLIMIT)||(OrderType() == OP_BUYSTOP))
   //if ((OrderType() == OP_SELL)||(OrderType() == OP_SELLLIMIT)||(OrderType() == OP_SELLSTOP))
   {
   tp = OrderOpenPrice() + 15 * Point * 10;
   }
   else
   {
   tp = OrderOpenPrice() - 4 * Point * 10;
   }
   //OrderModify(OrderTicket(), OrderOpenPrice(), 0, 0,0);
   OrderModify(OrderTicket(), OrderOpenPrice(), 0, tp,0);
   //break;
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+