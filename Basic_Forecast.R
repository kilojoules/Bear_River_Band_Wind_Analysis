s <- data.frame('turbine' = c('100 kW Northern','50 kW Endurance'))
s$NREL[1] <- mean(wpcm(NREL.dat$avg.speed.150m,3))
s$NREL[2] <- mean(wpcm(NREL.dat$avg.speed.150m,4))

s$Inverter[1] <- mean(wpcm(Inverter.dat$extrapolated,3))
s$Inverter[2] <- mean(wpcm(Inverter.dat$extrapolated,4))
write.csv(s,row.names=FALSE,file='~/Desktop/fork.csv')