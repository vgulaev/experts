
#property copyright "Copyright © 2009, BroCo Investments Inc."
#property link      "http://www.brocompany.com"

#property indicator_separate_window
#property indicator_buffers 1
#property indicator_minimum 0.0
#property indicator_maximum 0.1

#define SYMBOLS_MAX 1024

#define TYPE            0
#define SYMBOL          1
#define TICKET          0
#define VOLUME          1
#define OPEN_PRICE      2
#define SL              3
#define TP              4
#define CURRENT_PRICE   5
#define COMISSEE        6
#define SWAP            7
#define PROFIT          8
#define DEALS           9

extern color ExtColor=LightSeaGreen;
extern string ExtSort = "Order";
extern string ExtOption = "Up";

string ExtName="Broco Indicator";
string ExtSymbols[SYMBOLS_MAX];
double ExtTickets[SYMBOLS_MAX];
int    ExtSymbolsTotal=0;
double ExtSymbolsSummaries[SYMBOLS_MAX][10];
datetime ExtSymbolsDatetimes[SYMBOLS_MAX];
string ExtSymbolsStrings[SYMBOLS_MAX][2];
int    ExtLines=-1;
string ExtCols[12]={"Order",
                   "Time",
                   "Type",
                   "Volume",
                   "Symbol",
                   "Price",
                   "S/L",
                   "T/P",
                   "Price",
                   "Commission",
                   "Swap",
                   "Profit"};

string ExtSortTypes[6]={"Order",
                        "Type",
                        "Open Time",
                        "Profit",
                        "Symbol",
                        "Volume"};  
                        
string ExtOptionTypes[2] = {"Up",
                             "Down"};                 

int    ExtShifts[12]={ 10, 80, 200, 250, 300, 380, 450, 520,580, 650, 730, 780 };
int    ExtVertShift=14;
double ExtMapBuffer[];

void init()
  {
	IndicatorShortName(ExtName);
   SetIndexBuffer(0,ExtMapBuffer);
   SetIndexStyle(0,DRAW_NONE);
   IndicatorDigits(0);
	SetIndexEmptyValue(0,0.0);
  }


void deinit()
  {
   int windex=WindowFind(ExtName);
   if(windex>0) ObjectsDeleteAll(windex);
  }


void start()
  {
  
  string sym = Symbol();
  //while(!IsStopped())     // До тех пор, пока пользователь..     
    {                    // ..не прекратит исполнение программы     
      RefreshRates();      // Обновление данных
   string name;
   int    i,col,line,windex=WindowFind(ExtName);
  //----
   if(windex>0) ObjectsDeleteAll(windex);
      if(windex<0) return;
   //---- header line
   ExtLines = -1;
   if(ExtLines<0)
     {
      for(col=0; col<12; col++)
        {
         name="Head_"+col;
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
           {
            ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[col]);
            ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift);
            ObjectSetText(name,ExtCols[col],9,"Arial",ExtColor);
           }
        }
      ExtLines=0;
     }
//----
   ArrayInitialize(ExtSymbolsSummaries,0.0);
   for(int ii=0;ii<SYMBOLS_MAX;ii++)
   for(int jj=0;jj<10;jj++)
   ExtSymbolsSummaries[ii][jj] = 0.0;
   int total=Analyze();
  
  
   if(total>0)
     {
      line=0;
      for(i=0; i<total; i++)
        {
          if(ExtSymbolsSummaries[i][DEALS]<=0) 
          {
            continue;
            Print("index="+i);
          }
         line++;
      //   ---- add line
         if(line>ExtLines)
           {
            int y_dist=ExtVertShift*(line+1)+1;
            for(col=0; col<12; col++)
              {
               name="Line_"+line+"_"+col;
               if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
                 {
                  ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[col]);
                  ObjectSet(name,OBJPROP_YDISTANCE,y_dist);
                 }
              }
            ExtLines++;
           }
           
           
           
          int    digits=MarketInfo(ExtSymbolsStrings[i][SYMBOL],MODE_DIGITS);  
          
          name="Line_"+line+"_0";
          ObjectSetText(name,DoubleToStr(ExtSymbolsSummaries[i][TICKET],0),9,"Arial",ExtColor);
          name="Line_"+line+"_1";
          ObjectSetText(name,TimeToStr(ExtSymbolsDatetimes[i],TIME_DATE|TIME_MINUTES),9,"Arial",ExtColor);
          name="Line_"+line+"_2";
          ObjectSetText(name,ExtSymbolsStrings[i][TYPE],9,"Arial",ExtColor);
          name="Line_"+line+"_3";
          ObjectSetText(name,DoubleToStr(ExtSymbolsSummaries[i][VOLUME],2),9,"Arial",ExtColor);
          name="Line_"+line+"_4";
          ObjectSetText(name,ExtSymbolsStrings[i][SYMBOL],9,"Arial",ExtColor);
          name="Line_"+line+"_5";
          ObjectSetText(name,DoubleToStr(ExtSymbolsSummaries[i][OPEN_PRICE],digits),9,"Arial",ExtColor);
          name="Line_"+line+"_6";
          ObjectSetText(name,DoubleToStr(ExtSymbolsSummaries[i][SL],digits),9,"Arial",ExtColor);
          name="Line_"+line+"_7";
          ObjectSetText(name,DoubleToStr(ExtSymbolsSummaries[i][TP],digits),9,"Arial",ExtColor);
          name="Line_"+line+"_8";
          ObjectSetText(name,DoubleToStr(ExtSymbolsSummaries[i][CURRENT_PRICE],digits),9,"Arial",ExtColor);
          name="Line_"+line+"_9";
          ObjectSetText(name,DoubleToStr(ExtSymbolsSummaries[i][COMISSEE],2),9,"Arial",ExtColor);
          name="Line_"+line+"_10";
          ObjectSetText(name,DoubleToStr(ExtSymbolsSummaries[i][SWAP],2),9,"Arial",ExtColor);
          name="Line_"+line+"_11";
          ObjectSetText(name,DoubleToStr(ExtSymbolsSummaries[i][PROFIT],2),9,"Arial",ExtColor); 
          
          
        }
        //Print(line);
     }
     
//---- remove lines
 //  if(total<ExtLines)
 //    {
 //     for(line=ExtLines; line>total; line--)
 //       {
 //        name="Line_"+line+"_0";
 //        ObjectSetText(name,"");
 //        name="Line_"+line+"_1";
 //        ObjectSetText(name,"");
 //        name="Line_"+line+"_2";
 //        ObjectSetText(name,"");
 //        name="Line_"+line+"_3";
  //       ObjectSetText(name,"");
   //      name="Line_"+line+"_4";
    //     ObjectSetText(name,"");
     //    name="Line_"+line+"_5";
      //   ObjectSetText(name,"");
       //  name="Line_"+line+"_6";
        // ObjectSetText(name,"");
         //name="Line_"+line+"_7";
 //        ObjectSetText(name,"");
  //       name="Line_"+line+"_8";
   //      ObjectSetText(name,"");
    //     name="Line_"+line+"_9";
     //    ObjectSetText(name,"");
      //   name="Line_"+line+"_10";
       ///  ObjectSetText(name,"");
        // name="Line_"+line+"_11";
         //ObjectSetText(name,"");
   //     }
    // }
//---- to avoid minimum==maximum
   ExtMapBuffer[Bars-1]=-1;
    
    
    // сортировка!!!
    // редакция 10,12,2009
    int up=0;
    if(ExtOption==ExtOptionTypes[0]) up=1;
    else up=0;
    int j=0;
    for(j=0;j<6;j++)
    {
      if(ExtSort==ExtSortTypes[j])
      {
         if(j==0)
         {
            int k=1;
            int l=0;
            //Print(DoubleToStr(total,0));
            for(l=0;l<total-1;l++)
            {
               for(k=1;k<total;k++)
               {
                  //k=total;
                  //l=total-1;
                  int k2 = k+1;
                  string name_on_graph = "Line_"+k+"_0";
                  string name_on_graph2 = "Line_"+k2+"_0";
                  string a = ObjectDescription(name_on_graph);
                  string b = ObjectDescription(name_on_graph2);
                  double aa = StrToDouble(a);
                  double bb = StrToDouble(b);
                  if(up==1)
                  {
                     if(aa>bb)
                     {
                        Swap(k,k2);
                     }
                  }
                  else
                  {
                     if(aa<bb)
                     {
                        Swap(k,k2);
                     }
                  }
                  //double a = ObjectGet(name_on_graph,0);
                  //Print(a);
                  //Print(b);
              }
            }
         }
         if(j==1)
         {
            k=1;
            l=0;
            //Print(DoubleToStr(total,0));
            for(l=0;l<total-1;l++)
            {
               for(k=1;k<total;k++)
               {
                  //k=total;
                  //l=total-1;
                  k2 = k+1;
                  name_on_graph = "Line_"+k+"_2";
                  name_on_graph2 = "Line_"+k2+"_2";
                  a = ObjectDescription(name_on_graph);
                  b = ObjectDescription(name_on_graph2);
                  //double aa = StrToDouble(a);
                  //double bb = StrToDouble(b);
                  if(up==1)      //buy
                  {
                     if(a=="Sell" && a!=b)
                     //if(aa>bb)
                     {
                        Swap(k,k2);
                     }
                  }
                  else
                  {
                     if(a=="Buy" && a!=b)
                     //if(aa<bb)
                     {
                        Swap(k,k2);
                     }
                  }
                  //double a = ObjectGet(name_on_graph,0);
                  //Print(a);
                  //Print(b);
              }
            }
         }
         //--------endif
         if(j==2)
         {
            k=1;
            l=0;
            //Print(DoubleToStr(total,0));
            for(l=0;l<total-1;l++)
            {
               for(k=1;k<total;k++)
               {
                  //k=total;
                  //l=total-1;
                  k2 = k+1;
                  name_on_graph = "Line_"+k+"_1";
                  name_on_graph2 = "Line_"+k2+"_1";
                  a = ObjectDescription(name_on_graph);
                  b = ObjectDescription(name_on_graph2);
                  datetime time1 = StrToTime(a);
                  datetime time2 = StrToTime(b);
                  
                  //Date
                  //double aa = StrToDouble(a);
                  //double bb = StrToDouble(b);
                  if(up==1)      //buy
                  {
                    // for(int asd=0;asd<StringLen(a);asd++)
                      //  if(a[asd]>b[asd])
                     //if(a=="Sell" && a!=b)
                     //if(aa>bb)
                     if(time1>time2)
                     {
                        Swap(k,k2);
                        //asd = 20;
                     }
                  }
                  else
                  {
                     
                    // for(asd=0;asd<StringLen(a);asd++)
                      //  if(a[asd]<b[asd])
                     //if(a=="Buy" && a!=b)
                     //if(aa<bb)
                     if(time1<time2)
                     {
                        Swap(k,k2);
                      //  asd = 20;
                     }
                  }
                  //double a = ObjectGet(name_on_graph,0);
                  //Print(a);
                  //Print(b);
              }
            }
         }
         //endif
         if(j==3)
         {
            k=1;
            l=0;
            //Print(DoubleToStr(total,0));
            for(l=0;l<total-1;l++)
            {
               for(k=1;k<total;k++)
               {
                  //k=total;
                  //l=total-1;
                  k2 = k+1;
                  name_on_graph = "Line_"+k+"_11";
                  name_on_graph2 = "Line_"+k2+"_11";
                  a = ObjectDescription(name_on_graph);
                  b = ObjectDescription(name_on_graph2);
                  aa = StrToDouble(a);
                  bb = StrToDouble(b);
                  if(aa<0) aa = aa*(-1);
                  if(bb<0) bb = bb*(-1);
                  if(up==1)      //buy
                  {                     
                     if(aa>bb)
                     {
                        Swap(k,k2);
                     }
                  }
                  else
                  {                    
                     if(aa<bb)
                     {
                        Swap(k,k2);
                     }
                  }
                  //double a = ObjectGet(name_on_graph,0);
                  //Print(a);
                  //Print(b);
              }
            }
         }
         //endif
         if(j==4)
         {
            k=1;
            l=0;
            for(l=0;l<total-1;l++)
            {
               for(k=1;k<total;k++)
               {
                  //k=total;
                  //l=total-1;
                  k2 = k+1;
                  name_on_graph = "Line_"+k+"_11";
                  name_on_graph2 = "Line_"+k2+"_11";
                  a = ObjectDescription(name_on_graph);
                  b = ObjectDescription(name_on_graph2);
                  int len1 = StringLen(a);
                  int len2 = StringLen(b);
                  int min = len1;
                  int abc;
                  if(len1>len2)
                  {
                     min = len2;
                  }
                  if(up==1)      //buy
                  {   
                     for(abc=0;abc<min;abc++)
                     {                        
                        if(StringGetChar(a,abc)<StringGetChar(b,abc))
                        {
                           Swap(k,k2);
                           abc = min;
                        }
                        else
                        {
                           if(StringGetChar(a,abc)==StringGetChar(b,abc))
                           {
                              continue;
                           }
                           else abc = min;
                        }
                      
                     }              
                    // if(a>b)
                    // {
                    //    Swap(k,k2);
                    // }
                  }
                  else
                  {   
                     for(abc=0;abc<min;abc++)
                     {                        
                        if(StringGetChar(a,abc)>StringGetChar(b,abc))
                        {
                           Swap(k,k2);
                           abc = min;
                        }
                        else
                        {
                           if(StringGetChar(a,abc)==StringGetChar(b,abc))
                           {
                              continue;
                           }
                           else abc = min;
                        }
                     }                     
                   /*  if(a<b)
                     {
                        Swap(k,k2);
                     }*/
                  }
              }
            }
         }
         //endif
         if(j==5)
         {
            k=1;
            l=0;
            for(l=0;l<total-1;l++)
            {
               for(k=1;k<total;k++)
               {
                  //k=total;
                  //l=total-1;
                  k2 = k+1;
                  name_on_graph = "Line_"+k+"_3";
                  name_on_graph2 = "Line_"+k2+"_3";
                  a = ObjectDescription(name_on_graph);
                  b = ObjectDescription(name_on_graph2);
                  aa = StrToDouble(a);
                  bb = StrToDouble(b);
                  if(up==1)      //buy
                  {                     
                     if(aa>bb)
                     {
                        Swap(k,k2);
                     }
                  }
                  else
                  {                    
                     if(aa<bb)
                     {
                        Swap(k,k2);
                     }
                  }
              }
            }
         }
         //endif
      }
    }
    // конец редакции
    //--------------------------------------------   
    
   //  Print(line);
      //string name;
    name="Line_"+(line+1)+"_01234";
    double total_profit=0.0;
    for(i=0;i<line;i++)
    {
         total_profit+=ExtSymbolsSummaries[i][PROFIT]+ExtSymbolsSummaries[i][COMISSEE]+ExtSymbolsSummaries[i][SWAP];
    }
    line++;
    
     ExtLines++;
     string Total;
     Total = "Balance: "+DoubleToStr(AccountBalance(),2)+
             " Equity: "+DoubleToStr(AccountBalance()+total_profit,2)+
             " Margin: "+DoubleToStr(AccountMargin(),2)+
             " Free Margin: "+DoubleToStr(AccountFreeMargin(),2);
             //" Уровень: ";//+DoubleToStr( ( ( AccountBalance()+total_profit )/AccountMargin()*100 ),2 );
    if(StringLen(Total)>62)
    {
         name="Line_"+(line+1)+"_1230";
         string part1 = StringSubstr(Total,0,64);
         string part2 = StringSubstr(Total,63,64);
         Print(part1);
         Print(part2);
         Print(line);
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
         {
            ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
            ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(line+1));
            ObjectSetText(name,part1,9,"Arial",Red);   
         }
         name="Line_"+(line+1)+"_1234";
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
         {
            ObjectSet(name,OBJPROP_XDISTANCE,391);
            ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(line+1));
            ObjectSetText(name,part2,9,"Arial",Red);   
         }
    }
    else
    {
         ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
         ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(line+1));
         ObjectSetText(name,Total,9,"Arial",Red);   
    }
   //  }
     //name="Line_"+line+"_5";
     //if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
    // {
     //string Total2;
     //Total2 = " Уровень: "+DoubleToStr( ( ( AccountBalance()+total_profit )/AccountMargin()*100 ),2 )+"%";
     //       ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[6]);
     //       ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(line+1));
     //       ObjectSetText(name,Total2,9,"Arial",Red);   
    // }
    name="Line_"+line+"_11";
    if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
     {
            ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[11]);
            ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(line+1));
            ObjectSetText(name,DoubleToStr(total_profit,2),9,"Arial",Red);   
     }
     
     if(sym!="SYNTETIC1")
      {
         line++;
         if(line>ExtLines)
           {
            y_dist=ExtVertShift*(line+1)+1;
            //for(col=0; col<12; col++)
             // {
               name="Line_"+line+"_"+0;
               if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
                 {
                  ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
                  ObjectSet(name,OBJPROP_YDISTANCE,y_dist);
                 }
            //  }
            ExtLines++;
           }
           name="Line_"+line+"_0";
            ObjectSetText(name,"The incorrect symbol is chosen. Correct symbol SYNTETIC1",9,"Arial",Red);
         
      }
    // Sleep(500);
     }
    // return;
//----
  }


int Swap(int a, int b)
{
  // Print("swap");
   int line;
   string name_on_graph = "Line_"+a+"_0";
   string name_on_graph2 = "Line_"+b+"_0";   
   string ticket1 = ObjectDescription(name_on_graph);
   string ticket2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_1";
   name_on_graph2 = "Line_"+b+"_1";
   string datetime1  = ObjectDescription(name_on_graph);
   string datetime2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_2";
   name_on_graph2 = "Line_"+b+"_2";
   string type1  = ObjectDescription(name_on_graph);
   string type2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_3";
   name_on_graph2 = "Line_"+b+"_3";
   string volume1  = ObjectDescription(name_on_graph);
   string volume2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_4";
   name_on_graph2 = "Line_"+b+"_4";
   string symbol1  = ObjectDescription(name_on_graph);
   string symbol2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_5";
   name_on_graph2 = "Line_"+b+"_5";
   string open_price1  = ObjectDescription(name_on_graph);
   string open_price2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_6";
   name_on_graph2 = "Line_"+b+"_6";
   string sl1  = ObjectDescription(name_on_graph);
   string sl2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_7";
   name_on_graph2 = "Line_"+b+"_7";
   string tp1  = ObjectDescription(name_on_graph);
   string tp2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_8";
   name_on_graph2 = "Line_"+b+"_8";
   string cur_price1  = ObjectDescription(name_on_graph);
   string cur_price2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_9";
   name_on_graph2 = "Line_"+b+"_9";
   string commes1  = ObjectDescription(name_on_graph);
   string commes2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_10";
   name_on_graph2 = "Line_"+b+"_10";
   string swap1  = ObjectDescription(name_on_graph);
   string swap2 = ObjectDescription(name_on_graph2);
   name_on_graph = "Line_"+a+"_11";
   name_on_graph2 = "Line_"+b+"_11";
   string profit1  = ObjectDescription(name_on_graph);
   string profit2 = ObjectDescription(name_on_graph2);
   line = b;
   string name;
   name="Line_"+line+"_0";
   ObjectSetText(name,ticket1,9,"Arial",ExtColor);
   name="Line_"+line+"_1";
   ObjectSetText(name,datetime1,9,"Arial",ExtColor);
   name="Line_"+line+"_2";
   ObjectSetText(name,type1,9,"Arial",ExtColor);
   name="Line_"+line+"_3";
   ObjectSetText(name,volume1,9,"Arial",ExtColor);
   name="Line_"+line+"_4";
   ObjectSetText(name,symbol1,9,"Arial",ExtColor);
   name="Line_"+line+"_5";
   ObjectSetText(name,open_price1,9,"Arial",ExtColor);
   name="Line_"+line+"_6";
   ObjectSetText(name,sl1,9,"Arial",ExtColor);
   name="Line_"+line+"_7";
   ObjectSetText(name,tp1,9,"Arial",ExtColor);
   name="Line_"+line+"_8";
   ObjectSetText(name,cur_price1,9,"Arial",ExtColor);
   name="Line_"+line+"_9";
   ObjectSetText(name,commes1,9,"Arial",ExtColor);
   name="Line_"+line+"_10";
   ObjectSetText(name,swap1,9,"Arial",ExtColor);
   name="Line_"+line+"_11";
   ObjectSetText(name,profit1,9,"Arial",ExtColor); 
   line = a;
   
   name="Line_"+line+"_0";
   ObjectSetText(name,ticket2,9,"Arial",ExtColor);
   name="Line_"+line+"_1";
   ObjectSetText(name,datetime2,9,"Arial",ExtColor);
   name="Line_"+line+"_2";
   ObjectSetText(name,type2,9,"Arial",ExtColor);
   name="Line_"+line+"_3";
   ObjectSetText(name,volume2,9,"Arial",ExtColor);
   name="Line_"+line+"_4";
   ObjectSetText(name,symbol2,9,"Arial",ExtColor);
   name="Line_"+line+"_5";
   ObjectSetText(name,open_price2,9,"Arial",ExtColor);
   name="Line_"+line+"_6";
   ObjectSetText(name,sl2,9,"Arial",ExtColor);
   name="Line_"+line+"_7";
   ObjectSetText(name,tp2,9,"Arial",ExtColor);
   name="Line_"+line+"_8";
   ObjectSetText(name,cur_price2,9,"Arial",ExtColor);
   name="Line_"+line+"_9";
   ObjectSetText(name,commes2,9,"Arial",ExtColor);
   name="Line_"+line+"_10";
   ObjectSetText(name,swap2,9,"Arial",ExtColor);
   name="Line_"+line+"_11";
   ObjectSetText(name,profit2,9,"Arial",ExtColor); 
}


int Analyze()
  {
   double profit;
   int    i,index,type,total=OrdersTotal();
   int retval=0;
   //insertion by M.Ten
   // 29.09.09 18-54
   //----------
   //Print("orderstotal = "+total);
   int my_temp_index=0;
   int j=0;
   string name;
   string name_of_prices;
   double close_price,open_price;
   double tick_size,tick_price,lots;
   //----------m.ten-----
//----
ExtSymbolsTotal = 0;
//ExtSymbolsTotal = total;
   for(i=0; i<total; i++)
     {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      type=OrderType();
      if(type!=OP_BUY && type!=OP_SELL) continue;
      index=SymbolsIndex(OrderTicket());
      if(index<0 || index>=SYMBOLS_MAX) continue;

      ExtSymbolsSummaries[index][VOLUME]+=OrderLots();
      ExtSymbolsSummaries[index][OPEN_PRICE]+=OrderOpenPrice();
      
      name = StringSetChar(name,0,0);
      name = StringConcatenate( OrderSymbol(),"#I");

      double bid   =MarketInfo(name,MODE_BID);             
      double ask   =MarketInfo(name,MODE_ASK);

      double bid2   =MarketInfo(OrderSymbol(),MODE_BID);             
      double ask2   =MarketInfo(OrderSymbol(),MODE_ASK);

      if(type==OP_BUY)
      {
          if(bid!=0) ExtSymbolsSummaries[index][CURRENT_PRICE]+=bid;               
          else ExtSymbolsSummaries[index][CURRENT_PRICE]+=bid2;
      }
      else
      {
          if(ask!=0) ExtSymbolsSummaries[index][CURRENT_PRICE]+=ask;
          else ExtSymbolsSummaries[index][CURRENT_PRICE]+=ask2;
      }
      
      ExtSymbolsSummaries[index][DEALS]++;
      
      //Print("index=",index);
      
      if(type==OP_BUY)
      {
         if(bid==0) close_price = bid2;
         else close_price = bid;
      }
      else
      {
         if(ask==0) close_price = ask2;
         else close_price = ask;
      }
      
      tick_size = MarketInfo(name,MODE_TICKSIZE);
      tick_price = MarketInfo(name,MODE_TICKVALUE);
      
      if(tick_size==0) tick_size = MarketInfo(OrderSymbol(),MODE_TICKSIZE);
      if(tick_price==0) tick_price = MarketInfo(OrderSymbol(),MODE_TICKVALUE);      
      if(type==OP_BUY) profit =( ( close_price - ExtSymbolsSummaries[index][OPEN_PRICE] )/tick_size*tick_price*OrderLots()) + OrderCommission()+OrderSwap();
      else profit =( ( ExtSymbolsSummaries[index][OPEN_PRICE] - close_price )/tick_size*tick_price*OrderLots()) + OrderCommission()+OrderSwap();
      //ExtSymbolsSummaries[index][PROFIT]+=profit;
    
    
      if((OrderClosePrice()-ExtSymbolsSummaries[index][OPEN_PRICE])==0) profit = OrderProfit();
      else profit = ( close_price - ExtSymbolsSummaries[index][OPEN_PRICE] )*OrderProfit()/(OrderClosePrice()-ExtSymbolsSummaries[index][OPEN_PRICE]);
      ExtSymbolsSummaries[index][PROFIT]+=profit;
      
      
      ExtSymbolsSummaries[index][TICKET] = OrderTicket();
      ExtSymbolsSummaries[index][COMISSEE] = OrderCommission();
      ExtSymbolsSummaries[index][SWAP] = OrderSwap();
      ExtSymbolsSummaries[index][SL] = OrderStopLoss();
      ExtSymbolsSummaries[index][TP] = OrderTakeProfit();
      ExtSymbolsDatetimes[index] = OrderOpenTime();
      
      if(OrderType() == 0 ) ExtSymbolsStrings[index][TYPE] = "Buy";
      if(OrderType() == 1 ) ExtSymbolsStrings[index][TYPE] = "Sell";
      ExtSymbolsStrings[index][SYMBOL] = OrderSymbol();    
      
     }
//----
   total=0;
   for(i=0; i<ExtSymbolsTotal; i++)
     {
      if(ExtSymbolsSummaries[i][DEALS]>0) total++;
     }
//----
   return(total);
  }


int SymbolsIndex(int Ticket)
  {
  bool found=false;
//----
   for(int i=0; i<ExtSymbolsTotal; i++)
     {
     //Print("ticket=",Ticket,"exttiket=",ExtTickets[i]);
      if(Ticket==ExtTickets[i])
        {
         found=true;
         break;
        }
     }
//----
   //if(found) return(i);
   if(ExtSymbolsTotal>=SYMBOLS_MAX) return(-1);
   i=ExtSymbolsTotal;
   ExtSymbolsTotal++;
  //ExtSymbols[i]=SymbolName;
   ExtTickets[i]=Ticket;
   ExtSymbolsSummaries[i][TICKET]=0;
   ExtSymbolsSummaries[i][VOLUME]=0;
   ExtSymbolsSummaries[i][OPEN_PRICE]=0;
   ExtSymbolsSummaries[i][SL]=0;
   ExtSymbolsSummaries[i][TP]=0;
   ExtSymbolsSummaries[i][CURRENT_PRICE]=0;
   ExtSymbolsSummaries[i][COMISSEE]=0;
   ExtSymbolsSummaries[i][SWAP]=0;
   ExtSymbolsSummaries[i][PROFIT]=0;
   ExtSymbolsDatetimes[i] = 0;
   ExtSymbolsStrings[i][TYPE] = 0;
   ExtSymbolsStrings[i][SYMBOL] = 0;
//----
   return(i);
  }
//+------------------------------------------------------------------+