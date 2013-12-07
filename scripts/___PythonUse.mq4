//+------------------------------------------------------------------+
//|                                                    PythonUse.mq4 |
//|                        Copyright 2013, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2013, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

#import "shell32.dll"
int ShellExecuteA(int hwnd,string Operation,string File,string Parameters,string Directory,int ShowCmd);
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int proccessingcreate()
   {
   int handle;
   double price;
   double lots;
   int type;
   
   handle = FileOpen("create.csv",FILE_CSV|FILE_READ, ";");   
   
   while (FileIsEnding(handle) == false)
      {
      price = FileReadNumber(handle);
      lots = FileReadNumber(handle);
      type = FileReadNumber(handle);
      OrderSend("EURUSD", type, lots, price, 0, 0, 0);
      //OrderDelete(ticket);
      //Print(ticket);
      }
   }

int proccessingdelete()
   {
   int handle;
   int ticket;
   
   handle = FileOpen("delete.csv",FILE_CSV|FILE_READ, ";");   
   
   while (FileIsEnding(handle) == false)
      {
      ticket = FileReadNumber(handle);
      OrderDelete(ticket);
      Print(ticket);
      }
   }

int start()
  {
//----
   //MessageBox("Hello");
   double total;
   int pos;
   int handle;
   int handleproccess;
   string strorder;
   
   total = OrdersTotal();
   
   handleproccess = FileOpen("proccess.csv",FILE_BIN|FILE_WRITE);
   FileWriteString(handleproccess, "start", 0);
   
   handle = FileOpen("my_data.csv",FILE_BIN|FILE_WRITE);

   FileWriteString(handle, "{\'AccountBalance\' : " + DoubleToStr(AccountBalance(), 2) + ", ", 0);
   FileWriteString(handle, "\'Ask\' : " + DoubleToStr(Ask, 5) + ", ", 0);
   FileWriteString(handle, "\'Bid\' : " + DoubleToStr(Bid, 5) + ", ", 0);
   FileWriteString(handle, "\'Orders\' : [", 0);
   //FileWriteDouble(handle, 1.2354544, DOUBLE_VALUE);
   for (pos = 0; pos<total; pos++)
   {
      if (OrderSelect(pos, SELECT_BY_POS) == false) continue;
      strorder = "{\'OrderTicket\' : " + DoubleToStr(OrderTicket(), 0);
      strorder = strorder + ", \'OrderOpenPrice\' : " + DoubleToStr(OrderOpenPrice(), 5);
      strorder = strorder + ", \'OrderType\' : " + DoubleToStr(OrderType(), 0);
      strorder = strorder + ", \'OrderLots\' : " + DoubleToStr(OrderLots(), 2);
      strorder = strorder + "}";
      if (pos < (total - 1))
         {
         strorder = strorder + ", ";
         }      
      FileWriteString(handle, strorder, 0);
      //Print("Hello");
   }
   FileWriteString(handle, "]}", 0);
   FileClose(handle);
   
   //ShellExecuteA(0, "Open", "python.exe", "C:\Users\Administrator\workspace\fxmaker\mainfxdecider.py", "", 1);   
   
   //while (FileSize(handleproccess) != 3)
   {
   }
   
   //proccessingdelete();
   //proccessingcreate();
   
//----
   return(0);
  }
//+------------------------------------------------------------------+