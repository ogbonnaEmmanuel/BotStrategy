//+------------------------------------------------------------------+
//|                                                       sizing.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


double GetPipValue(){
  
  if(Digits >= 4)
  {
   return 0.0001;
  }
  return 0.01;
}


double OptimalLotSize(double maxRiskPrc, int maxLossInPips)
{

  double accEquity = AccountEquity();
  
  double lotSize = MarketInfo(NULL,MODE_LOTSIZE);
  
  double tickValue = MarketInfo(NULL,MODE_TICKVALUE);
  
  if(Digits <= 3)
  {
   tickValue = tickValue /100;
  }
  
 
  
  double maxLossDollar = accEquity * maxRiskPrc;
  
  double maxLossInQuoteCurr = maxLossDollar / tickValue;

  double optimalLotSize = NormalizeDouble(maxLossInQuoteCurr /(maxLossInPips * GetPipValue())/lotSize,2);
  
  return optimalLotSize;
 
}

double OptimalLotSize(double maxRiskPrc, double entryPrice, double stopLoss)
{
   int maxLossInPips = MathAbs(entryPrice - stopLoss)/GetPipValue();
   return OptimalLotSize(maxRiskPrc,maxLossInPips);
}


bool IsSaturated(string tradeType){

   double curRange = MathAbs(iWPR(NULL, 0, 14, 0));
   
   if(tradeType == "sell" && curRange < 50){
      return true;
   }else if(tradeType == "buy" && curRange > 50){
      return true;
   }
   return false;
}

bool volumeReversed(string prevTradeType){

   double curRange = MathAbs(iWPR(NULL, 0, 14, 0));
   
   if(prevTradeType == "sell" && curRange > 50){
      return true;
   }else if(prevTradeType == "buy" && curRange < 50){
      return true;
   }
   return false;
}

double StopLossRange(string tradeType){

  double atrRange = iATR(NULL, 0, 14, 0);
  
  double pipValue = NormalizeDouble(2 * (atrRange / GetPipValue()), Digits);
  
  double pipLoss = NormalizeDouble(pipValue * GetPipValue(), Digits);
  if(tradeType == "sell"){
      return NormalizeDouble(Ask + pipLoss, Digits);
  }
   return NormalizeDouble(Bid - pipLoss, Digits);
}