//+------------------------------------------------------------------+
//|                                             Удаление ордеров.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
#property show_confirm

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int deleteTikets[];
string strategyname;

void sortticketbyabsolutlength()
{
   int total;
   int i1, i2;
   int sw;
   double length;
   double aim;
   double min;
   
   total = ArraySize(deleteTikets);
   aim = (Ask+Bid)/2;
   
   for (i1=0;i1<total-1;i1++)
   {
   if (OrderSelect(deleteTikets[i1], SELECT_BY_TICKET) == false) continue;
   min = MathAbs(aim - OrderOpenPrice());
      for (i2=i1+1;i2<total;i2++)
      {
      if (OrderSelect(deleteTikets[i2], SELECT_BY_TICKET) == false) continue;
      if (min > MathAbs(aim - OrderOpenPrice()))
      {
      min = MathAbs(aim - OrderOpenPrice());
      sw = deleteTikets[i1];
      deleteTikets[i1]  = deleteTikets[i2];
      deleteTikets[i2] = sw;
      }
      }
   }   
}

bool checkstrategy(string sn)
{
   bool result;
   result = (StringSubstr(sn,0,13) == strategyname);
   return(result);
}

int start()
  {
//----
   int total;
   total = OrdersTotal();
   Print(total);
   
   int k = 0;
   int otype;
   int pos;
   double price;
   string idstategy;
   price = 1.6114;
   
   //idstategy = Symbol() + " Cushion Butterfly";
   strategyname = "EURUSD v0_001";
   //strategyname = "sellgrig v0_01";
   //strategyname = "Subgrid Grid";
   
   ArrayResize(deleteTikets, total);
   
   for (pos = 0; pos < total; pos++)
   {
   OrderSelect(pos, SELECT_BY_POS, MODE_TRADES);
   if (OrderSymbol() != Symbol()) continue;
   //if (OrderComment() != idstategy) continue;
   otype = OrderType();   
   if ((otype != OP_BUY)&&(otype != OP_SELL)&&(OrderOpenPrice()<1.1000))
   //if ((otype != OP_BUY)&&(otype != OP_SELL)&&(checkstrategy(OrderComment()))&&(OrderOpenPrice()>1.245))
   //if ((otype != OP_BUY)&&(otype != OP_SELL)&&(OrderOpenPrice()>1.2437)&&(OrderOpenPrice()<1.2475))
   //if ((otype != OP_BUY)&&(otype != OP_SELL)&&(otype == OP_BUYSTOP))
   //if ((otype != OP_BUY)&&(otype != OP_SELL))
   //if ((otype != OP_BUY)&&(otype != OP_SELL)&&(OrderTakeProfit()!=0))
   //if ((otype != OP_BUY)&&(otype != OP_SELL)&&(OrderLots() == 0.01))
   //if ((otype != OP_BUY)&&(otype != OP_SELL)&&(checkstrategy(OrderComment()))&&(OrderOpenPrice()>1.2049))
   //if ((otype != OP_BUY)&&(otype != OP_SELL)&&(OrderOpenPrice()>1.219)&&(checkstrategy(OrderComment())))
      {
      deleteTikets[k] = OrderTicket();
      k++;
      }
   }
   
   sortticketbyabsolutlength();
   
   for (pos = 0; pos < k; pos ++)
   {
   OrderDelete(deleteTikets[pos]);
   }
//----
   return(0);
  }
//+------------------------------------------------------------------+