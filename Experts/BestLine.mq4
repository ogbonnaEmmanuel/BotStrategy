//+------------------------------------------------------------------+
//|                                                     BestLine.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
#include <LineChecker.mqh>
#include <TradeHelper.mqh>
#include <Arrays/ArrayString.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
CArrayString * availableSymbols;
int total_trade = 1;
input int max__profit_pips = 3;
input int max_stop_loss_pips= 20;
input double lot_size = 0.08;

int handler;

int OnInit()
  {
//---
   
//---
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
      EventSetTimer(60);
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
    EventKillTimer();
    delete(availableSymbols);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
     
  }

void OnTimer()
       {
             for(int i=0; i<availableSymbols.Total(); i++)
               {
                 string symbol = availableSymbols.At(i);
                 string max_line = max_stochasLine(symbol);
                 
                if(max_line !="none")
                  { 
                    if(uniqueTrade(Symbol()))
                      {
                        initiateOrder(max_line, symbol, lot_size, max__profit_pips, max_stop_loss_pips);
                      }
                  }else
                     {
                      Print("no sure trade found");
                     }
               }
       }
//+------------------------------------------------------------------+
