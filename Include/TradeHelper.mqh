//+------------------------------------------------------------------+
//|                                                  TradeHelper.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict



void initiateOrder(string m_trade_type, string m_currency, double m_lot_size, int m_max_profit_pips, int m_max_loss_pips){

int ticket = 0;
double ask    = MarketInfo(m_currency,MODE_ASK);
double bid    = MarketInfo(m_currency,MODE_BID);
int  digits = (int)MarketInfo(m_currency,MODE_DIGITS);
int magicNb = 16384;
double tick_value = 0.0;

if(digits >= 4){
         tick_value = 0.0001; 
      }else{
          tick_value = 0.01;
      }
      
double profit_pips = NormalizeDouble(m_max_profit_pips * tick_value, digits);
double loss_pips = NormalizeDouble(m_max_loss_pips * tick_value, digits);

double stop_loss = 0.0;
double take_profit = 0.0;

   if(m_trade_type == "Buy")
     {
       if(uniqueTrade(m_currency) == true)
         {
           take_profit = NormalizeDouble(bid + profit_pips, digits);
           stop_loss = NormalizeDouble(bid - loss_pips, digits);
           RefreshRates();
           ticket = OrderSend(m_currency, OP_BUY, m_lot_size, bid, 3, stop_loss, take_profit, "stochaAlgo Order",magicNb, 0, clrBlue);
         }
     }else if(m_trade_type == "Sell")
             {
               if(uniqueTrade(m_currency) == true)
                 {
                   take_profit = NormalizeDouble(ask - profit_pips, digits);
                   stop_loss = NormalizeDouble(ask + loss_pips, digits);
                   RefreshRates();
                   ticket = OrderSend(m_currency, OP_SELL, m_lot_size, ask, 3, stop_loss, take_profit, "stochaAlgo Order",magicNb, 0, clrBlue);
                 }
             }
             
     if(ticket > 0)
        {
          Print(m_trade_type," order initiated");
        }else if(ticket < 0)
                {
                  Print("unable to initiate ", m_trade_type, " order");
                }else
                   {
                     Print("trade symbol not unique");
                   }
                  
}


bool uniqueTrade(string m_symbol){

  for(int i=OrdersTotal() - 1; i>=0; i--)
       {
          if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
              if(m_symbol == OrderSymbol())
                {
                  return false;
                }
               
            }
       }
       return true;
}

void closeTrade(string m_symbol){

 int slippage = 3;
    
    if(Digits ==3 || Digits ==5)
      {
        slippage = slippage * 10;
      }
     for(int i=OrdersTotal() - 1; i>=0; i--)
       {
          if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
            {
               double ClosePrice;
               RefreshRates();
               if(OrderType() == OP_BUY) ClosePrice = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_BID), Digits);
               if(OrderType() == OP_SELL) ClosePrice = NormalizeDouble(MarketInfo(OrderSymbol(), MODE_ASK), Digits);
               
               if(m_symbol == OrderSymbol())
                 {
                   
                   if(OrderClose(OrderTicket(), OrderLots(), ClosePrice, slippage, clrBlue))
                     {
                        Print("successfully closed");
                     }else
                     {
                        Print("unable to close order");
                    }
                  
                 }
       
            }
       }
}
