require(XLConnect)
require(plyr)
require(VGAM)

#==================
# Read Excel data

# Load workbook
wb <- loadWorkbook("~/Code/RPS/BearRiverBand-Rancheria-WindTurbine-Log-2009-2014.xlsx")

# loop through worksheets
lst = readWorksheet(wb, sheet = getSheets(wb))
Inverter.dat=data.frame()
for (l in 1:(length(lst)-4))
{
  # Rename data columns, add to dataframe dat
  s <- data.frame(lst[l])
  names(s) <- c('TIME','DATA','BY')
  Inverter.dat <- merge(Inverter.dat,s,all = TRUE)
}

# Parse timestamp
Inverter.dat$TIME <- strptime(Inverter.dat$TIME, format='%Y-%m-%d')
Inverter.dat$month <- as.numeric(format(Inverter.dat$TIME,'%m'))
Inverter.dat$day <- as.numeric(format(Inverter.dat$TIME,'%j'))

# Save energy data as numbers
Inverter.dat$DATA <- as.numeric(Inverter.dat$DATA)

# Find delta(KWHR) values and AVG Watts/Day
Inverter.dat$Watts <- 0
for (i in 2:length(Inverter.dat$TIME))
{
  if(is.na(Inverter.dat$DATA[i-1])) Inverter.dat$Watts[i] <- 0
  else
  {
    if(is.na(Inverter.dat$DATA[i])) Inverter.dat$Watts[i] <- 0
    else
    {  
      if(Inverter.dat$DATA[i]>Inverter.dat$DATA[i-1])
      {
        # <useful description>
        Inverter.dat$Watts[i] <- (as.numeric(Inverter.dat$DATA[i]-Inverter.dat$DATA[i-1])/as.numeric(Inverter.dat$TIME[i]-Inverter.dat$TIME[i-1]))*1000/24
      }
      else Inverter.dat$Watts[i] <- NA
    }
  }
}

# Remove NA and inf Values. Remove mysterious 27311 and 7539
Inverter.dat <- subset(Inverter.dat,Inverter.dat$Watts>0 & Inverter.dat$Watts<13000)
Inverter.dat$Watts <- as.numeric(Inverter.dat$Watts)

# fit data from turbine company to a 7th degree polynomial
powwa <- data.frame('speed'=seq(0.9,20.5,0.01))
powwa$power <- wpcm(powwa$speed,1)

# map from power to speed
for (i in 1:length(Inverter.dat$Watts))
{
  l=TRUE
  for (j in 1:length(powwa$power))
  {
    if (powwa$power[j]>Inverter.dat$Watts[i])
    {
      if(l==TRUE) Inverter.dat$wind[i] <- 0.9 + 0.01*j
      l=FALSE
    }
  }
  if (l==TRUE)
  {
    Inverter.dat$wind <- 20.5
  }
}

# extrapolate to new height
newHeight=140
Inverter.dat$extrapolated <- Inverter.dat$wind * (newHeight/100)^(1/7)

# find monthly averages
avg.months=data.frame('month'=c(1:12))
for (i in 1:12)
{
  m <- subset(Inverter.dat,month==i)
  avg.months$wind.measured[i]<-mean(m$wind)
  avg.months$wind.ext[i]<-mean(m$extrapolated)
}


# for each month
avg.invmonths=data.frame('month'=c(1:12))
for (i in 1:12)
{
  
  # make subset with only that month
  m <- subset(Inverter.dat,month==i)
  
  # record average extrapolated speeds
  avg.invmonths$wind.ext[i] <- mean(m$extrapolated)
  
  # Find monthly extrapolated power
  
  # get appropriate x values
  x <- density(m$extrapolated)$x
  
  # use Rayleigh distribution based on 
  # average extrapolated speed
  drey <- density(drayleigh(x,scale = mean(m$extrapolated)))
  
  #  find delta x distance for set of x values
  #  found by density function
  dx <- drey$x[4]-drey$x[3]
   
  # Forecast monthly average power [kW] using 
  # energy generation density
  avg.invmonths$power.Aeolos[i] <- sum(drey$y*(drey$x[4]-drey$x[3])*wpcm(x,2))
  avg.invmonths$power.Endurance[i] <- sum(drey$y*(drey$x[4]-drey$x[3])*wpcm(x,3))
  avg.invmonths$power.Northern[i] <- sum(drey$y*(drey$x[4]-drey$x[3])*wpcm(x,4))
}