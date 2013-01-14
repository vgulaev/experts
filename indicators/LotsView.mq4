//+------------------------------------------------------------------+
//|                                                     LotsView.mq4 |
//|                          Copyright © 2010,Broco Inversments Inc. |
//|                                        http://www.brocompany.com |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010,Broco Inversments Inc."
#property link      "http://www.brocompany.com"

string ExtName="LotsView";
string forex_symbols[255];
string client_symbols[255];
double client_volume[255];
#property indicator_separate_window
extern color ExtColor=LightSeaGreen;

int    ExtShifts[12]={ 10, 80, 457, 250, 300, 380, 450, 520,580, 650, 730, 780 };
int    ExtVertShift=14;



double table_volume[15] = {3,5,8,10,13,15,20,25,30,35,40,45,50,100,1000};
double table_koef[15]   = {1,1.5,2,3,4,5,6,7,8,9,10,11,12,20,100};
double table_svolume[15] = {3,6,12,18,30,40,70,105,145,190,240,295,355,1355,10355};
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
   int handle=FileOpen("forex.csv",FILE_READ|FILE_CSV,';');
   if(handle<0) 
   {
      Print("error: can't open file! code #",GetLastError());
      return(0);
   }
   int i=0;
   while(!FileIsEnding(handle))
   {
       string ss = FileReadString(handle);
       //Print(s);
       forex_symbols[i] = ss;
       i++;
   }
   int count = i;
   FileClose(handle);
   int total=OrdersTotal();
   int cnt = 0;
   int total_orders = 0;
   for(int pos=0;pos<total;pos++)
   {
     if(OrderSelect(pos,SELECT_BY_POS,MODE_TRADES)==false) continue;
     int type = OrderType();
     string symbol = OrderSymbol();
     int f = StringFind(symbol,"_FX",0);
     if(f!=-1)
      symbol =  StringSubstr(symbol,0,StringLen(symbol)-3);
     //Print(DoubleToStr(count,0));
     int total_orders_cnt = 0;
     if(type == OP_BUY || type==OP_SELL)
     {
         //Print(symbol);
         for(i=0;i<count;i++)
         {
               if(forex_symbols[i]==symbol)
               {
                     //Print("ok");
                     //total_orders_cnt++;
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
                     break;
               }
         }
     }
   }
   //Print("symbols="+total_orders+"orders="+total_orders_cnt);
   for(i=0;i<total_orders;i++)
   {
         if(client_volume[i]<0) client_volume[i]=-1*client_volume[i];
         //Print(client_symbols[i]);
         string name="Head_"+i+"col"+(i+1);
         if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
         {
            ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[0]);
            ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+1));
            ObjectSetText(name,client_symbols[i],9,"Arial",ExtColor);
         }      
         name="Head_"+i+"col"+(i+2);
         double new_lots = 0;
         string s;
         s = "";
         if(client_volume[i]>table_volume[0])
			{
				for(int k=0;k<15;k++)
				{				  
					if(table_volume[k]>client_volume[i])
					{							
						for(j=0;j<k;j++)
						{
					      if(j==0)
					      {
					          string tmp = DoubleToStr(table_volume[j],2);
					          tmp = StringConcatenate(tmp,"*",DoubleToStr(table_koef[j],2));  					          
					          s = StringConcatenate(s,tmp,"+");					          
					      }
					      else
					      {
					          tmp = DoubleToStr(table_volume[j]-table_volume[j-1],2);
					          tmp = StringConcatenate(tmp,"*",DoubleToStr(table_koef[j],2));					          					          
					          s = StringConcatenate(s,tmp,"+");
					      }
							//char ttt[20];
							//sprintf_s(ttt,20,"%.2lf*%.2lf+",j==0?table[j].volume:(table[j].volume-table[j-1].volume),table[j].koef);
							//s+=ttt;
						}
						//char ttt[20];
						if(client_volume[i]-table_volume[k-1]!=0) s = StringConcatenate(s,DoubleToStr(client_volume[i]-table_volume[k-1],2),"*",DoubleToStr(table_koef[k],2));
						else s = StringSubstr(s,0,StringLen(s)-1);
						//sprintf_s(ttt,20,"%.2lf*%.2lf",(summ-table[i-1].volume),table[i].koef);
						//if((summ-table[i-1].volume)!=0) s+=ttt;						
						new_lots = table_svolume[k-1]+(client_volume[i]-table_volume[k-1])*table_koef[k];
						break;
					}
				}
				if(new_lots==0)
				{
					for(j=0;j<15;j++)
					{
						if(j==0)
				      {
				          tmp = DoubleToStr(table_volume[j],2);
				          tmp = StringConcatenate(tmp,"*",DoubleToStr(table_koef[j],2));  					          
				          s = StringConcatenate(s,tmp,"+");					          
				      }
				      else
				      {
				          tmp = DoubleToStr(table_volume[j]-table_volume[j-1],2);
				          tmp = StringConcatenate(tmp,"*",DoubleToStr(table_koef[j],2));					          					          
				          s = StringConcatenate(s,tmp,"+");
				      }
					}
					s = StringConcatenate(s,DoubleToStr(client_volume[i]-table_volume[14],2),"*1");
					//char ttt[20];
					//sprintf_s(ttt,20,"%.2lf*1",(summ-table[table.size()-1].volume));
					//s+=ttt;
					new_lots = table_svolume[14]+client_volume[i]-table_volume[14];
				}
				s = StringConcatenate(s,"=",DoubleToStr(new_lots,2));
			}
			else
			{
				new_lots = client_volume[i]*table_koef[0];
				s = StringConcatenate(s,"",DoubleToStr(new_lots,2));
			}
			//sprintf_s(bufer,255,"%s=%.2lf",s.c_str(),new_lots);
			//s = StringConcatenate(s,"=",DoubleToStr(new_lots,2));
			if(StringLen(s)>62) 
			{
			   Print(s);
			   string s1 = StringSubstr(s,0,64);
			   string s2 = StringSubstr(s,63,64);
			   name="Head_"+i+"col"+(i+3);
			   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
            {
               ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[1]);
               ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+1));
               ObjectSetText(name,s1,9,"Arial",ExtColor);
            }    
            name="Head_"+i+"col"+(i+4);
            if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
            {
               ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[2]);
               ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+1));
               ObjectSetText(name,s2,9,"Arial",ExtColor);
            }    
			}
			else
			{
			   if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
            {
               ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[1]);
               ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+1));
               ObjectSetText(name,s,9,"Arial",ExtColor);
            }    
         }
        // name="Head_"+i+"col"+(i+3);
        // if(ObjectCreate(name,OBJ_LABEL,windex,0,0))
        // {
        //    ObjectSet(name,OBJPROP_XDISTANCE,ExtShifts[2]);
        //    ObjectSet(name,OBJPROP_YDISTANCE,ExtVertShift*(i+1));
        //    ObjectSetText(name,DoubleToStr(client_volume[i],2),9,"Arial",ExtColor);
        // }      
   }
//----
//if(!ObjectSetText("text_object", "Hello world!", 10, "Times New Roman", Green))
//{
 //   if(!ObjectCreate("text_object", OBJ_TEXT,windex, TimeCurrent(), 1.0045))
  //  {
   // int err = GetLastError();
    // Print("error: can't create text_object! code #",err);
    // Print("error(",err,"): ",ErrorDescription(err));

     //return(0);
//    }
 //   else ObjectSetText("text_object", "Hello world!", 10, "Times New Roman", Green);
  //  }

//----
 //  return(0);
  }
//+------------------------------------------------------------------+