This set of functions was used to forecast power for a local client. Electricity generation of an installed turbine was estimated using two sets of available data:
  AC Cumulative Output Energy Generation Data: The Rancheria has been recording electricity generation from cumulative measurements taken by the inverter connected to the installed Bergey Excel 10-kW turbine at the casino. The installed inverter’s cumulative energy generation data were recorded for five years, August 2009 through August 2014.
  NREL Anemometer Data: Wind speed data was collected near the existing wind turbine using an anemometer loaned by the National Renewable Energy Laboratory
3 (NREL). Average wind speeds were recorded every ten minutes from December 2000 through November 2001.
Both sets of data were used to estimate power generated by an Aeolos H-50 and an Endurance E-3120 wind turbine at a hub height of 140 feet. Additionally, a Northern Power 100-kW turbine was forecasted at 120 feet due to the unavailability of a 140-ft tower from the manufacturer. The wind speed power curve specifications are shown in Appendix C. This analysis was done using the R data analysis program.


<h1>ExcelParser.R</h1>

Daily measurements were taken of the cummulative energy generated by the wind turbine at Bear River Rancheria. These data were collected by manually reading the cummulative power generated from the inverter and recording each entry in an Excel workbook, storing each month of information as a separate worksheet.

<h1>NRELParser.R</h1>
NREL recorded wind speed data from October 13, 2000 to November 1, 2001 (Jiminez, 2013). The NREL was contacted, and this data was obtained. The data supplied range across 343 days. These data were collected at a 60 foot height in ten minute intervals. These data were mapped to a height of 100 feet using the wind profile power law, assuming an alpha value of 1/7. The average wind speed varies across the day, which can be useful for calculating energy generation times. The extrapolated wind speed distribution was used to predict power generation using the same turbines used in the AC cummulative output energy generation data analysis

To repeat analysis, compile in the following order:
Master_Function.R
Excel_Parser.R
NREL_Parser.py
Subsets.R
Basic_Forecast.R
