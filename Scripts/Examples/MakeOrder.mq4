//+------------------------------------------------------------------+
//|                                             profitCalculator.mq4 |
//|                                                 OGBONNA EMMANUEL |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "OGBONNA EMMANUEL"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property script_show_inputs
#include <TradeHelper.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
//input int max_loss_pips = 10;
//input int max_profit_pips = 5;
input double lot_size = 0.08;
input string trade_type = "Sell";
input string currency = "EURUSD";

void OnStart()
  {
      
      //initiateOrder(currency, max_loss_pips, max_profit_pips, lot_size, trade_type);
      
      for(int i=0;i<2;i++)
        {
          Print(noStopTrade(trade_type, Symbol(), lot_size));
        }
           
  }
//+------------------------------------------------------------------+
