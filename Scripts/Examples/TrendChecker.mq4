//+------------------------------------------------------------------+
//|                                                 TrendChecker.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property show_inputs
#include <Arrays/ArrayString.mqh>
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
CArrayString * symbolsToCheck;
CArrayString * detectedSymbols;
int handler;
input int margin_diff = 10;

void OnStart()
  {
    symbolsToCheck = new CArrayString();
    detectedSymbols = new CArrayString();
    
    string file_name = "sym.txt";
    handler = FileOpen(file_name, FILE_WRITE|FILE_READ|FILE_TXT|FILE_ANSI);
    string str;
    int str_size;
    
    if(handler != INVALID_HANDLE)
      {
        while(!FileIsEnding(handler))
          {
               str_size = FileReadInteger(handler,INT_VALUE);
               str = FileReadString(handler,str_size);
               symbolsToCheck.Add(str);
          }
      }
     
     string current_symbol;
     
     for(int i=0; i<symbolsToCheck.Total(); i++)
       {
         current_symbol = symbolsToCheck.At(i);
         double green_line = iStochastic(current_symbol,0,5,3,3,MODE_SMA,0,MODE_MAIN,0);
         double red_line = iStochastic(current_symbol,0,5,3,3,MODE_SMA,0,MODE_SIGNAL,0);
         
         if((red_line - green_line) >= margin_diff)
           {
             detectedSymbols.Add(current_symbol);
             
           }else if((green_line - red_line) >= margin_diff)
                   {
                     detectedSymbols.Add(current_symbol);
                   }
       }
      
      string symbol_found = "None";
      for(int i=0; i<detectedSymbols.Total(); i++)
        { 
          symbol_found += ",   ";
          symbol_found += detectedSymbols.At(i);
        }
        
       Print(symbol_found);
  }
  
 void OnDeinit(const int reason)
         {
           delete(symbolsToCheck);
           delete(detectedSymbols);
           FileClose(handler);
         }
//+------------------------------------------------------------------+
