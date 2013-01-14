//+------------------------------------------------------------------+
//|                                                     LotsView.mq4 |
//|                          Copyright © 2010,Broco Inversments Inc. |
//|                                        http://www.brocompany.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010,Broco Inversments Inc."
#property link      "http://www.brocompany.com"

string ExtName="MarginView";
string forex_symbols[255];
string client_symbols[255];
double client_volume[255];
#property indicator_separate_window
extern color ExtColor=LightSeaGreen;

int    ExtShifts[12]={ 10, 80, 150, 230, 350, 420, 450, 520,580, 650, 730, 780 };
int    ExtVertShift=14;



double table_volume[15] = {3,5,8,10,13,15,20,25,30,35,40,45,50,100,1000};
double table_koef[15]   = {1,1.5,2,3,4,5,6,7,8,9,10,11,12,20,100};
double table_svolume[15] = {3,6,12,18,30,40,70,105,145,190,240,295,355,1355,10355};

string table_symbols[1024];
double table_margins[1024];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
IndicatorShortName(ExtName);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   int windex=WindowFind(ExtName);
   if(windex>0) ObjectsDeleteAll(windex);
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   for(int a = 0; a< 255;a++)
   {
      client_symbols[a] = "";
      client_volume[a] = 0;      
   }
   int windex=WindowFind(ExtName);
   if(windex>0) ObjectsDeleteAll(windex);
   if(windex<0) return;
   int handle=FileOpen("night_margin.csv",FILE_READ|FILE_CSV,';');
   if(handle<0) 
   {
      Print("error: can't open file! code #",GetLastError());
      return(0);
   }
   int i=0;
   string ss;
   while(!FileIsEnding(handle))
   {
       ss = FileReadString(handle);
       table_symbols[i] = ss;
       ss = FileReadString(handle);
       table_margins[i] = StrToDouble(ss);
       i++;       
   }
   int count_symbols = i;
   FileClose(handle);   
   i =0;
   int total=OrdersTotal();
   int cnt = 0;
   int total_orders = 0;
   for(int pos=0;pos<total;pos++)
   {
     if(OrderSelect(pos,SELECT_BY_POS,MODE_TRADES)==false) continue;
     int type = OrderType();
     string symbol = OrderSymbol();
     if(2==MarketInfo(symbol,MODE_MARGINCALCMODE))
     {
      int total_orders_cnt = 0;
      if(type == OP_BUY || type==OP_SELL)
      {
          bool ex = false;                     
          for(int j=0;j<total_orders;j++)
          {
             if(client_symbols[j] == symbol)
             {
                //Print("exist");
                if(type == OP_BUY) client_volume[j]+=OrderLots();
                else client_volume[j]-=OrderLots();
                ex = true;
                break;
             }
          }
          if(!ex)
          {
             //Print("new");
             client_symbols[total_orders] = symbol;
             if(type == OP_BUY) client_volume[total_orders]+=OrderLots();
             else client_volume[total_orders]-=OrderLots();
             total_orders++;
             if(total_orders>255) return(0);
          }
         // break;               
      }
    }
   // else
    //{
       //  double margin2 = MarketInfo(   symbol, MODE_MARGINREQUIRED  );  
     //    margin2 = margin2 *   OrderLots();
        // Print(margin2);
   // }
   }
   string name = "HEADS"+1;
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(1));
      ObjectSetText(name,"Symbol",9,"Arial",ExtColor);
   }
   name = "HEADS"+2;
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[1]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(1));
      ObjectSetText(name,"Volume",9,"Arial",ExtColor);
   }     
   name = "HEADS"+3;
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[2]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(1));
      ObjectSetText(name,"Day Margin",9,"Arial",ExtColor);
   }
   name = "HEADS"+4;
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[3]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(1));
      ObjectSetText(name,"Night Margin",9,"Arial",ExtColor);
   }
   name = "HEADS"+5;
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[4]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(1));
      ObjectSetText(name,"Your night level",9,"Arial",ExtColor);
   }
   double summ_night_margin = 0;
   double summ_day_margin   = 0;
   for(i=0;i<total_orders;i++)
   {
         if(client_volume[i]<0) client_volume[i]=-1*client_volume[i];
         name="Head_"+i+"col"+(i+1);
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
         {
            ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
            ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+2));
            ObjectSetText(name,client_symbols[i],9,"Arial",ExtColor);
         }      
         name="Head_"+i+"col"+(i+2);
         double new_lots = 0;
         string s;
         s = "";
         double margin = MarketInfo(   client_symbols[i], MODE_MARGINREQUIRED  );    
         double init_margin = MarketInfo(   client_symbols[i], MODE_MARGININIT  );    
         double maint_margin = MarketInfo(   client_symbols[i], MODE_MARGINMAINTENANCE  ); 
         margin = margin/init_margin*maint_margin;   
         //s = s + client_symbols[i];
         //s = s + "   ";
         string tmp = DoubleToStr(client_volume[i],2);
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
         {
            ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[1]);
            ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+2));
            ObjectSetText(name,tmp,9,"Arial",ExtColor);
         }   
         s = s + tmp;
         s = s + "             ";
         double margin_day = margin * client_volume[i];
         //Print(margin);
         summ_day_margin += margin_day;
         tmp = DoubleToStr(margin_day,2);
         name="Head_"+i+"col"+(i+3);
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
         {
            ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[2]);
            ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+2));
            ObjectSetText(name,tmp,9,"Arial",ExtColor);
         } 
         s = s + tmp; 
         s = s + "         ";   
         double margin_night=margin;
         for(j=0;j<count_symbols;j++)
         {
            int len = StringLen(table_symbols[j]);
            int len2 = StringLen(client_symbols[i]);            
            if(len+2 == len2)
            {
               string symbol_tmp = StringSubstr(client_symbols[i],0,len);
               if(symbol_tmp==table_symbols[j])
               {
                  margin_night = table_margins[j];
                  break;
               }                         
            }
         }     
         margin = MarketInfo(   client_symbols[i], MODE_MARGINREQUIRED  );    
         margin_night = margin*margin_night / init_margin;
         margin_night = margin_night * client_volume[i];
         summ_night_margin += margin_night;
         tmp = DoubleToStr(margin_night,2);
         name="Head_"+i+"col"+(i+4);
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
         {
            ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[3]);
            ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+2));
            ObjectSetText(name,tmp,9,"Arial",ExtColor);
         } 
         s = s + tmp;          
	/*		if(StringLen(s)>62) 
			{
			   Print(s);
			   string s1 = StringSubstr(s,0,64);
			   string s2 = StringSubstr(s,63,64);
			   name="Head_"+i+"col"+(i+3);
			   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
            {
               ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[1]);
               ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+2));
               ObjectSetText(name,s1,9,"Arial",ExtColor);
            }    
            name="Head_"+i+"col"+(i+4);
            if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
            {
               ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[2]);
               ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+2));
               ObjectSetText(name,s2,9,"Arial",ExtColor);
            }    
			}
			else
			{
			   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
            {
               ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[1]);
               ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+2));
               ObjectSetText(name,s,9,"Arial",ExtColor);
            }    
         }       */ 
   }
   string summ_night = DoubleToStr(summ_night_margin,2);
   string summ_day = DoubleToStr(summ_day_margin,2);  
   
   name="Head_"+total_orders+2+"col" + (i);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+2));
      ObjectSetText(name,"-----------------------------------------------------------------------------------------------------------------------",9,"Arial",ExtColor);
   } 
   name="Head_"+total_orders+3+"col" + (i);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[3]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+2));
      ObjectSetText(name,"---------------------------------------------------",9,"Arial",ExtColor);
   } 
   
    
   name="Head_"+total_orders+1+"col" + (i);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+3));
      ObjectSetText(name,"Total futures info:",9,"Arial",ExtColor);
   }  
   name="Head_"+total_orders+1+"col" + (i+1);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[2]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+3));
      ObjectSetText(name,summ_day,9,"Arial",ExtColor);
   }
   name="Head_"+total_orders+1+"col" + (i+2);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[3]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+3));
      ObjectSetText(name,summ_night,9,"Arial",ExtColor);
   }
   
   name="Head_"+total_orders+22+"col" + (i);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+4));
      ObjectSetText(name,"Total not futures info:",9,"Arial",ExtColor);
   }     
   name="Head_"+total_orders+2+"col" + (i+1);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[2]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+4));
      ObjectSetText(name,DoubleToStr(AccountMargin()-summ_day_margin,2),9,"Arial",ExtColor);
   }
   name="Head_"+total_orders+2+"col" + (i+2);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[3]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+4));
      ObjectSetText(name,DoubleToStr(AccountMargin()-summ_day_margin,2),9,"Arial",ExtColor);
   }
   
   name="Head_"+total_orders+33+"col" + (i);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+5));
      ObjectSetText(name,"Total account info:",9,"Arial",ExtColor);
   }     
   name="Head_"+total_orders+3+"col" + (i+1);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[2]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+5));
      ObjectSetText(name,DoubleToStr(AccountMargin(),2),9,"Arial",ExtColor);
   }
   name="Head_"+total_orders+3+"col" + (i+2);
   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
   {
      ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[3]);
      ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+5));
      ObjectSetText(name,DoubleToStr(AccountMargin()+summ_night_margin-summ_day_margin,2),9,"Arial",ExtColor);
   }
   
   name="Head_"+total_orders+3+"col" + (i+3);
   double night_level = AccountEquity()/(AccountMargin()+summ_night_margin-summ_day_margin)*100;  
   string str_night_level =  DoubleToStr(night_level,2);
   str_night_level = str_night_level + "%";
   if(night_level<100)
   {
      if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
      {
         ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[4]);
         ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+5));
         ObjectSetText(name,str_night_level,9,"Arial",Red);
      }
   }
   else
   {
      if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
      {
         ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[4]);
         ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(total_orders+5));
         ObjectSetText(name,str_night_level,9,"Arial",ExtColor);
      }
   }
  }
//+------------------------------------------------------------------+