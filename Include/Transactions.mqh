//+------------------------------------------------------------------+
//|                                                 Transactions.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
#include <Sizing.mqh>


bool makeTransaction(string tradeType){

if(tradeType == "buy")
  {
    if(checkTrend() == "buy" && isStrongSignal(tradeType) == true)
      {
        return true;
      }
  }else if(tradeType == "sell" && isStrongSignal(tradeType) == true)
          {
            if(checkTrend() == "sell")
              {
                return true;
              }
          }

return false;

}


string checkTrend(){

double spanA = iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,0);
double spanB = iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,0);
double openPrice = Open[0];

 if((spanA < openPrice) && (spanB < openPrice))
   {
     return "buy";
     
   }else if((spanA > openPrice) && (spanB > openPrice))
           {
             return "sell";
           }else
              {
                return "none";
              }
}


bool executeTrade(string tradeType, double m_riskRatio){

int ticket;
double stop = StopLossRange(tradeType);
double lot;

if(tradeType == "buy"){

lot = OptimalLotSize(m_riskRatio, Ask, stop);
ticket=OrderSend(Symbol(),OP_BUY,lot,Ask,3,NULL,NULL,"My order",16384,0,clrGreen);

}else if(tradeType == "sell")
        {
          lot = OptimalLotSize(m_riskRatio, Bid, stop);
          ticket=OrderSend(Symbol(),OP_SELL,lot,Bid,3,NULL,NULL,"My order",16384,0,clrGreen);
        }
   if(ticket<0)
     {
      Print("OrderSend failed with error #",GetLastError());
      return false;
     }
   Print("OrderSend placed successfully");
   return true;
}


void closeTrade(){

  string m_symbol = Symbol();
  
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


bool checkToCloseTrade(string m_previousTrend){
   if(checkTrend() != m_previousTrend || IsSaturated(m_previousTrend))
         {
           closeTrade();
           return true;
        }
        return false;
}

string okayToTransact(string m_previousTrend, double m_riskRatio=0.02){

if(m_previousTrend == "buy")
     {
         if(makeTransaction("sell"))
          {
            if(executeTrade("sell", m_riskRatio)){
                 return "true";
             }
          }
          
    }else if(m_previousTrend == "sell"){
          if(makeTransaction("buy")){
               if(executeTrade("buy", m_riskRatio)){
                       return "true";
                }        
           }
      }else{
          return "none";
        }
        return "false";
}


bool isStrongSignal(string m_tradeType){

   double spanA = NormalizeDouble(iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,0), Digits);
    double spanB = NormalizeDouble(iIchimoku(NULL,0,9,26,52,MODE_SENKOUSPANA,0), Digits);
    double openPrice = NormalizeDouble(Close[0], Digits);
    double diffMargin = 15.0;
    
     if(m_tradeType == "buy")
   {
     double diff = MathAbs((spanB - openPrice) / GetPipValue());
     if(diff >= diffMargin)
       {
         return true;
       }
     
   }else if(m_tradeType == "sell")
           {
             double diff = MathAbs((spanA - openPrice) / GetPipValue());
             if(diff >= diffMargin)
             {
               return true;
             }
            
          }
          return false;
}