//+------------------------------------------------------------------+
//|                                               IchimoReversal.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs

#include <sizing.mqh>
#include <Transactions.mqh>
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
string previousTrend;
bool onTransaction;
string reasonToClose;
input double riskRatio = 0.02;

int OnInit()
  {
//--- create timer
   EventSetTimer(300);
   previousTrend = checkTrend();
   onTransaction = false;
   reasonToClose = "";
   Print("current trend at the begining ", previousTrend);
   
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
     
      if(onTransaction)
     {
        if(checkToCloseTrade(previousTrend)){
           onTransaction = false;
        };
     }else
        {
          string isItOkay = okayToTransact(previousTrend, riskRatio);
          if(isItOkay == "true"){
             onTransaction = true;
             previousTrend = checkTrend();
          }else if(isItOkay == "none"){
            previousTrend = checkTrend();
          }
        }
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {

      if(onTransaction)
     {
        if(checkToCloseTrade(previousTrend)){
           onTransaction = false;
        };
     }else
        {
          string isItOkay = okayToTransact(previousTrend, riskRatio);
          if(isItOkay == "true"){
             onTransaction = true;
             previousTrend = checkTrend();
          }else if(isItOkay == "none"){
            previousTrend = checkTrend();
          }
        }
  }
//+------------------------------------------------------------------+
