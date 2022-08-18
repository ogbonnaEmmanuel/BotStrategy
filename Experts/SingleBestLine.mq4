//+------------------------------------------------------------------+
//|                                               SingleBestLine.mq4 |
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
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
input int max__profit_pips = 3;
input int max_stop_loss_pips= 20;
input double lot_size = 0.08;

int OnInit()
  {
//--- create timer
   EventSetTimer(60);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
               string symbol = Symbol();
               string max_line = max_stochasLine(symbol);  
                if(max_line !="none")
                  { 
                    if(uniqueTrade(symbol))
                      {
                        initiateOrder(max_line, symbol, lot_size, max__profit_pips, max_stop_loss_pips);
                      }
                  }else
                     {
                      Print("no sure trade found");
                     }
   
  }
//+------------------------------------------------------------------+
