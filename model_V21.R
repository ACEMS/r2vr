rm(list=ls())
install.packages('rjags')
install.packages('reshape')

# Load packages
library(ggplot2)
library(reshape)
library(dplyr)
library(tidyr)
library(broom)
library(nlme)
library(gridExtra)
library(grid)
library(purrr)
library(rjags)


load(file="input_V6.RData")

# Removing NAs in gender 
covariates.ready$gender_fct <- replace_na(covariates.ready$gender_fct,2)

# Replacing 0 in uncertainty by 1 (neutral opinion) and 1 by 2 (agree/disagree and strongly agree/disagree are now equivalent) 
#dat.spread.unc[dat.spread.unc==1] <- 2 
#dat.spread.unc[dat.spread.unc==0] <- 1 
dat.spread.unc = dat.spread.unc+1


# write model
cat(
  "
  model{
  
  # likelihood for bernouilli distribution
  for (i in 1:n){
  y[i] ~ dbern(p[i])
  logit(p[i]) <- a[ImageID[i]]+b1[colour_image_unc[i]]*colour_image[i]+
  b2[snow_presence_unc[i]]*snow_presence[i]+
  b3[good_weather_unc[i]]*good_weather[i]+
  b4[human_presence_unc[i]]*human_presence[i]+
  b5[biodiversity_presence_unc[i]]*biodiversity_presence[i]+
  b6[iconic_species_presence_unc[i]]*iconic_species_presence[i]+
  b7[human_impact_presence_unc[i]]*human_impact_presence[i]+
  b8*age_fct[i] + b9*grp_fct[i] + b10*gender_fct[i] + b11*site[i]
  }
  
  # priors
  
  for (j in 1:nimages){
  a[j]~dnorm(0, taua)}
    
  for (s in 1:ns){
  b1[s] ~ dnorm(b.hat1.0, tau1[s])
  b2[s] ~ dnorm(b.hat2.0, tau2[s])
  b3[s] ~ dnorm(b.hat3.0, tau3[s])
  b4[s] ~ dnorm(b.hat4.0, tau4[s])
  b5[s] ~ dnorm(b.hat5.0, tau5[s])
  b6[s] ~ dnorm(b.hat6.0, tau6[s])
  b7[s] ~ dnorm(b.hat7.0, tau7[s])
  }

  b8 ~ dnorm(0, 1.0E-2)
  b9 ~ dnorm(0, 1.0E-2)
  b10 ~ dnorm(0, 1.0E-2)
  b11 ~ dnorm(0, 1.0E-2)

  tau0~dgamma(1.0E-2, 1.0E-2)  
  taua~dgamma(1.0E-2, 1.0E-2)
  taub.0~dgamma(1.0E-2, 1.0E-2)
  b.hat1.0~dnorm(0,1.0E-2)
  b.hat2.0~dnorm(0,1.0E-2)
  b.hat3.0~dnorm(0,1.0E-2)
  b.hat4.0~dnorm(0,1.0E-2)
  b.hat5.0~dnorm(0,1.0E-2)
  b.hat6.0~dnorm(0,1.0E-2)
  b.hat7.0~dnorm(0,1.0E-2)

  for (s in 1:ns){  
  tau1[s]~dgamma(1.0E-2, 1.0E-3)
  tau2[s]~dgamma(1.0E-2, 1.0E-3)
  tau3[s]~dgamma(1.0E-2, 1.0E-3)
  tau4[s]~dgamma(1.0E-2, 1.0E-3)
  tau5[s]~dgamma(1.0E-2, 1.0E-3)
  tau6[s]~dgamma(1.0E-2, 1.0E-3)
  tau7[s]~dgamma(1.0E-2, 1.0E-3)
  }
  
  # Assess model fit using a sum-of-squares-type discrepancy
  for (i in 1:n) {
  predicted[i] <- p[i]            # Predicted values
  residual[i] <- y[i]-predicted[i]  # Residuals for observed data                                     
  sq[i] <- pow(residual[i], 2)      # Squared residuals
  
  # Generate replicate data and compute fit statistics for them -- perfect dataset
  y.new[i]~dbern(p[i])     # One new data set at each MCMC iteration
  sq.new[i] <- pow(y.new[i]-predicted[i], 2)  # Squared residuals for new data
  }
  
  fit <- sum(sq[])              # Sum of squared residuals for actual data set
  fit.new <- sum(sq.new[])      # Sum of squared residuals for new data set
  }  
  ", file="model_V21.txt"
)

## Inits
Nimages<-length(unique(ImageID))
ImID<-as.factor(ImageID)
Ns<-length(unique(dat.spread.unc$beauty_unc))

## Data
jd <- list(y=response, colour_image=covariates.ready$colour_image,snow_presence=covariates.ready$snow_presence,
           good_weather=covariates.ready$good_weather,human_presence=covariates.ready$human_presence,
           biodiversity_presence=covariates.ready$biodiversity_presence,iconic_species_presence=covariates.ready$iconic_species_presence,
           human_impact_presence=covariates.ready$human_impact_presence,
           n=length(response),nimages=Nimages,ImageID=ImID,ns=Ns,
           colour_image_unc=dat.spread.unc$colour_image,snow_presence_unc=dat.spread.unc$snow_presence,
           good_weather_unc=dat.spread.unc$good_weather,human_presence_unc=dat.spread.unc$human_presence,
           biodiversity_presence_unc=dat.spread.unc$biodiversity_presence,iconic_species_presence_unc=dat.spread.unc$iconic_species_presence,
           human_impact_presence_unc=dat.spread.unc$human_impact_presence,age_fct=covariates.ready$age_fct, grp_fct=covariates.ready$grp_fct,
           gender_fct=covariates.ready$gender_fct, site=dat.spread$image_loc)


mod <- jags.model("model_V21.txt", data= jd, n.chains=3, n.adapt=500)


burn.beta<-jags.samples(mod,c("p"),n.iter=90000)
dic<-dic.samples(mod,n.iter=5000)

#burn.beta<-jags.samples(mod,c("p"),n.iter=900)
#dic<-dic.samples(mod,n.iter=500)


# Aesthetic indicators 
out.beta <- coda.samples(mod, c("b1","b2","b3","b4","b5",
                                "b6","b7"),
                         n.iter=5000, thin=50)

#out.beta <- coda.samples(mod, c("b1","b2","b3","b4","b5",
#                                "b6","b7"),
#                         n.iter=500)

# Demographics indicators 
out.beta.dem<-coda.samples(mod,c("b8","b9","b10","b11"),n.iter=5000, thin=50)
#out.beta.dem<-coda.samples(mod,c("b8","b9","b10","b11"),n.iter=500)


# Grand mean 
out.grand.mean<-coda.samples(mod,c("a","b.hat1.0","b.hat2.0","b.hat3.0",
                                   "b.hat4.0","b.hat5.0","b.hat6.0","b.hat7.0"),n.iter=5000, thin=50)

#out.grand.mean<-coda.samples(mod,c("a","b.hat1.0","b.hat2.0","b.hat3.0",
#                                   "b.hat4.0","b.hat5.0","b.hat6.0","b.hat7.0"),n.iter=200)

# Probability being beautiful 
out.pred<-coda.samples(mod,c("p"),n.iter=5000, thin=50)
#out.pred<-coda.samples(mod,c("p"),n.iter=500)

# Model fit 
out.perf<-coda.samples(mod,c("predicted","residual"),n.iter=5000, thin=50)
out.ppc<-coda.samples(mod,c("fit","fit.new"),n.iter=5000, thin=50)

#out.perf<-coda.samples(mod,c("predicted","residual"),n.iter=500)
#out.ppc<-coda.samples(mod,c("fit","fit.new"),n.iter=500)

save.image(file="model_output_V21.RData")
