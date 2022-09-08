//+------------------------------------------------------------------+
//|                                               ReversalTrader.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs

#include <Arrays/ArrayString.mqh>
#include <Arrays/ArrayInt.mqh>
#include <LineChecker.mqh>
#include <TradeHelper.mqh>

//input int max_loss_pips = 10;
input int max_profit_pips = 5;
input double lot_size = 0.08;
input double margin_diff = 10.0;
input int period = 60;
input double margin_to_close = 2.0;

CArrayString * availableSymbols;
CArrayString * pairsOfInterest;
CArrayString *lineOfInterest;
CArrayString * openOrderSymbols;
CArrayString * openTradeTypes;

int max_trade = 3;
int handler;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
    string file_name = "sym.txt";
    handler = FileOpen(file_name, FILE_WRITE|FILE_READ|FILE_TXT|FILE_ANSI);
    string str;
    int str_size;
    availableSymbols = new CArrayString();
    
    if(handler != INVALID_HANDLE)
      {
        while(!FileIsEnding(handler))
          {
               str_size = FileReadInteger(handler,INT_VALUE);
               str = FileReadString(handler,str_size);
               availableSymbols.Add(str);
          }
      }
      FileClose(handler);
   
    addPairsOfInterest();
    
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
    delete(availableSymbols);
    delete(pairsOfInterest);
    delete(lineOfInterest);
    delete(openOrderSymbols);
    delete(openTradeTypes);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  { 
    
  if(IsTradeAllowed() == false) return;
  
     closeTradeIfReversed();
     
       if((OrdersTotal()) < max_trade + 1)
         {
            for(int i=0; i<pairsOfInterest.Total(); i++)
              {
                string current_symbol = pairsOfInterest.At(i);
                string previous_main_line = lineOfInterest.At(i);
                
                if(isReversed(current_symbol, previous_main_line, margin_diff, period))
                  {
                     string trade_type = buyOrSell(current_symbol, period);
                     //initiateOrder(current_symbol, max_loss_pips, max_profit_pips, lot_size, trade_type);
                     if(noStopTrade(trade_type, current_symbol, lot_size, max_profit_pips) == true)
                       {
                         openOrderSymbols.Add(current_symbol);
                         openTradeTypes.Add(trade_type);
                       }
                  }
              }
         }else
            {
               addPairsOfInterest();
            }
  }

void closeTradeIfReversed(){

string currentTradeSymbol;
string currentTradeType;

  for(int i=0;i<openOrderSymbols.Total(); i++)
    {
      currentTradeSymbol = openOrderSymbols.At(i);
      currentTradeType = openTradeTypes.At(i);
      if((closeNow(currentTradeSymbol, period, currentTradeType, margin_to_close)) == true)
        {
            closeTrade(currentTradeSymbol);
        }
    }
}

void addPairsOfInterest(){

   pairsOfInterest = new CArrayString();
   string current_symbol;
   lineOfInterest = new CArrayString();
   openOrderSymbols = new CArrayString();
   openTradeTypes = new CArrayString();
   
   for(int i=0; i<availableSymbols.Total(); i++)
     {
       current_symbol = availableSymbols.At(i);
       double green_line = iStochastic(current_symbol,period,5,3,3,MODE_SMA,0,MODE_MAIN,0);
       double red_line = iStochastic(current_symbol,period,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);
       
       if((red_line - green_line) >= margin_diff)
           {
             pairsOfInterest.Add(current_symbol);
             lineOfInterest.Add("red");
             
           }else if((green_line - red_line) >= margin_diff)
                   {
                     pairsOfInterest.Add(current_symbol);
                     lineOfInterest.Add("green");
                   } 
     }
}
//+------------------------------------------------------------------+


