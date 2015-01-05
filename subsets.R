# 11 months of data
#hist(NREL.dat$month,col='red')
#axis(side=1, at=c(0:12))

summer <- subset(NREL.dat,month>=5 & month <=10)

# no weekends
summer.peak <- subset(summer, hour>=12 & hour<=17 & day < 6 )

# hour should be greater than weedays 8:30, no weekends
summer.partial.peak <- subset(summer, format(summer$time,'%H %M')>="08 30" & format(summer$time,'%H %M')<="21 30" & day<6)

# summer offpeak: weekdays 9:30pm - 8:30 am, all weekends
summer.off.peak <- subset(summer, format(summer$time,'%H %M')>="21 30" | format(summer$time,'%H %M')<="08 30" | day>5)

winter <- subset(NREL.dat, month<5 | month >10)

#wind partial peak: weekdays 8:30 am - 9:30 pm no weekends
winter.partial.peak <- subset(winter, format(winter$time,'%H %M')>="08 30" & format(winter$time,'%H %M')<="21 30" & day<6 )

#winter off peak : 9:30 pm - 8:30 am, all weekends
winter.off.peak <- subset(winter, format(winter$time,'%H %M')>="21 30" | format(winter$time,'%H %M')<="08 30" | day >5 )

# Find total power in the wind
turbused = 2
comps <- data.frame('time'=c('summer peak','summer partial peak','summer off peak','winter off peak','winter partial peak'))
comps$NREL.wind.period.power <- c(mean(wpcm(summer.peak$avg.speed,turbused))*654,
                                  mean(wpcm(summer.partial.peak$avg.speed,turbused))*763,
                                  mean(wpcm(summer.off.peak$avg.speed,turbused))*2255,
                                  mean(wpcm(winter.off.peak$avg.speed,turbused))*3112,
                                  mean(wpcm(winter.partial.peak$avg.speed,turbused))*1976)

for (i in 1:length(comps$time))
{
  comps$frac[i] <- comps$NREL.wind.period.energy[i]/(mean(wpcm(NREL.dat$avg.speed,turbnum))Inv)
}

write.csv(comps,file='~/Desktop/fractions.csv',row.names=FALSE)