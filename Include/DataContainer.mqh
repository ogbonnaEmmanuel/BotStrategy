//+------------------------------------------------------------------+
//|                                                DataContainer.mqh |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

class DataContainer
{
   string         m_symbol;
public:
   DataContainer()
   { 
     
   }
   
   string getName(){
     return m_symbol;
   }
};