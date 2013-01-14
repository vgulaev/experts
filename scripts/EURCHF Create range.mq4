//+------------------------------------------------------------------+
//|                                          EURCHF Create range.mq4 |
//|                      Copyright © 2011, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2011, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//----
   int op;
   int pos;
   double lotsize;
   double openprice;
   string ordername;
   
   //op = OP_BUYSTOP;
   op = OP_SELLLIMIT;
   //op = OP_SELLSTOP;
   //op = OP_BUYLIMIT;
   lotsize = 0.05;
   //lotsize = 0.04;
   
   openprice = 1.3328;
   ordername = "EU v0_001 " + DoubleToStr(openprice, 4);
   //ordername = "sellbuy v0_01 SELL " + DoubleToStr(openprice, 4);
   //ordername = "sellbuy v0_01 BUY " + DoubleToStr(openprice, 4);
   //ordername = "Subgrid Grid 001 " + DoubleToStr(openprice, 4);
   //OrderSend(Symbol(), op, lotsize, openprice, 0, 0, 0, ordername);
   
   //openprice = 1.2008;
   for (pos = 0;pos<8;pos++)
   {
   //op = OP_BUYLIMIT;
   //op = OP_SELLSTOP;
   //op = OP_SELLLIMIT;
   //ordername = "EURCHF v0_020 " + DoubleToStr(openprice, 4);
   ordername = "EU v0_001 " + DoubleToStr(openprice, 4);
   //ordername = "Subgrid Grid " + DoubleToStr(openprice, 4);
   //ordername = "Subgrid Grid 001 " + DoubleToStr(openprice, 4);
   OrderSend(Symbol(), op, lotsize, openprice, 0, 0, 0, ordername);
   openprice = openprice + 10*Point;
   }
   
//----
   return(0);
  }
//+------------------------------------------------------------------+