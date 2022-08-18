//+------------------------------------------------------------------+
//|                                                  LineChecker.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict


bool isReversed(string current_symbol, string previousMainLine, double m_margin_diff, int m_period){
  string mainLine = "false";
  
  double green_line = iStochastic(current_symbol,m_period,5,3,3,MODE_SMA,0,MODE_MAIN,0);
  double red_line = iStochastic(current_symbol,m_period,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);
  
  if((red_line - green_line) >= m_margin_diff)
    {
       mainLine = "red";
       
    }else if((green_line - red_line) >= m_margin_diff)
            {
            
              mainLine = "green";
            }
    if(previousMainLine == mainLine)
      {
        return false;
      }else if(mainLine == "false")
              {
                return false;
              }
              else
                {
                  Print(mainLine, " ", previousMainLine);
                  return true;
                }
}

string buyOrSell(string symbol, int m_period){
 
    double green_line = NormalizeDouble(iStochastic(symbol,m_period,5,3,3,MODE_SMA,0,MODE_MAIN,0), Digits);
    double red_line = NormalizeDouble(iStochastic(symbol,m_period,5,3,3,MODE_SMA,0,MODE_SIGNAL,0), Digits);
    
    if(red_line > green_line)
      {
         return "Sell";
      }else
         {
           return "Buy";
         }
}

bool closeNow(string m_symbol, int m_period, string m_previous_trade, double m_margin_to_close){

   double green_line = NormalizeDouble(iStochastic(m_symbol,m_period,5,3,3,MODE_SMA,0,MODE_MAIN,0), Digits);
   double red_line = NormalizeDouble(iStochastic(m_symbol,m_period,5,3,3,MODE_SMA,0,MODE_SIGNAL,0), Digits);
   
   if(m_previous_trade == "Buy")
     {
       //prevLine = "green";
       //checking if reversed to close trade
       if((red_line - green_line) >= m_margin_to_close)
         {
            return true;
         }
     }else if(m_previous_trade == "Sell")
             {
               //prevLine = "red";
               if((green_line - red_line) >= m_margin_to_close)
                 {
                  return true;
                 }
             }
      return false;
}

string max_stochasLine(string m_symbol){

  int red_line_max = 0;
  int green_line_max = 0;
  
  int timeFrames[5] = {1,5, 15, 30, 60};
  
  for(int i=0; i<5; i++)
    {
      double green_line = NormalizeDouble(iStochastic(m_symbol, timeFrames[i],5,3,3,MODE_SMA,0,MODE_MAIN,0), Digits);
      double red_line = NormalizeDouble(iStochastic(m_symbol, timeFrames[i],5,3,3,MODE_SMA,0,MODE_SIGNAL,0), Digits);
      
      
      if(red_line > green_line)
        {
          red_line_max +=1;
        }else if(green_line > red_line)
                {
                  green_line_max +=1;
                }
    }
    
    Print("green = ", green_line_max, " red = ", red_line_max);
    
    if(red_line_max >= 4)
      {
        // reverse the trade
        return "Buy";
      }else if(green_line_max >= 4)
              { 
                return "Sell";
              }else
                 {
                   return "none";
                 }
}