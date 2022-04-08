
rm(list=ls())

install.packages('mcmcplots')

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
library(forcats)
#library(tidymcmc)
library(plyr)
library(mcmcplots)

tidy <- function(x, q=c(0.025, 0.5, 0.975)){
  
  # generate summary statistics
  x.s <- summary(x, q=q)
  
  # pull out mean and quantiles
  x.df <- data.frame(Mean=x.s$statistics[, "Mean"],
                     x.s$quantiles)
  
  # a variable is more important than a row name
  x.df$term <- factor(row.names(x.df),
                      levels=row.names(x.df),
                      ordered = F)
  
  row.names(x.df) <- NULL # no one wants row names
  
  ncols <- ncol(x.df) # need to permute the columns
  
  return(x.df[, c(ncols, 1:(ncols-1))])
}

#rm(list=ls())

load(file="model_output_V21.RData")
mean(dic$deviance)





######################################################## Posterior distribution


Rec.pred<- tidy(out.pred)

Rec.model<-dat.spread%>%
  mutate(Prob=Rec.pred$Mean)%>%
  data.frame

Rec.stat<-Rec.model%>%
  group_by(image)%>%
  tally()


Recsummary <- ddply(Rec.model, .(image), summarise, Mean=mean(Prob), sd=sd(Prob), 
                    min=min(Prob), max=max(Prob))

Recsummary<-inner_join(Recsummary,Rec.stat)


#Rec_mean<-Recsummary
#quant_dist<-quantile(Rec_mean$Mean)

#Prob.group<-rep(NA,nrow(Rec_mean))
#Prob.group[which(Rec_mean$Mean<=quant_dist[2])]<-"Low"
#Prob.group[which(Rec_mean$Mean>quant_dist[2]&Rec_mean$Mean<=quant_dist[4])]<-"Medium"
#Prob.group[which(Rec_mean$Mean>quant_dist[4])]<-"High"

#Rec_mean$Probability<-as.factor(Prob.group)

#new_lev<-c("High","Medium","Low")

#Rec_mean<-Rec_mean%>%
#  mutate(Probability=factor(Probability, levels=new_lev))


#windows()
#ggplot(Rec_mean,aes(x=as.factor(ImageID),y=Mean,color=Probability))+geom_point(size=2.8)+ ggtitle("")+theme_bw()+ylab("Probability")+ylim(0,1)+
#  theme(axis.text=element_text(size=12),axis.title=element_text(size=14),axis.text.x = element_text(angle=90))+theme(plot.title = element_text(hjust=0.5,vjust=2,size=18, face="bold"))+
#  xlab("Image ID")+geom_hline(yintercept = quant_dist[2],linetype = "longdash")+geom_hline(yintercept = quant_dist[4],linetype = "longdash")

########################################################## Model parameters - aesthetic indicators 
Rec.beta <- tidy(out.grand.mean)[17:23,]

param <- c("colour_image","snow_presence","good_weather","human_presence","biodiversity_presence","iconic_species_presence",
                               "human_impact_presence")


Rec.beta<-Rec.beta%>%
  mutate(parameter= rep(param,each=1))%>%
  mutate(parameter = fct_reorder(parameter, desc(Mean)))

Rec.beta$parameter <- as.factor(Rec.beta$parameter)

Rec.beta$Perception <- rep(NA,nrow(Rec.beta))
Rec.beta$Perception[which(Rec.beta$Mean<0)]<-"Negative"
Rec.beta$Perception[which(Rec.beta$Mean>0)]<-"Positive"

Rec.beta$Perception<-as.factor(Rec.beta$Perception)
Rec.beta$Perception<-factor(Rec.beta$Perception,levels=c("Positive","Negative"))

ggplot(Rec.beta,aes(x=Mean,y=parameter,col=Perception))+geom_point(size=1.8)+geom_segment(aes(x = X2.5., xend = X97.5.,
                                                                              y =parameter, yend=parameter,col=Perception))+
  xlab("Posterior mean and 95%CI")+theme_bw()+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14))+
  theme(plot.title = element_text(vjust=2,size=18, face="bold"))+ 
  geom_vline(xintercept = 0,linetype = "longdash")


######################################################## Demographic (+site)

Rec.dem <- tidy(out.beta.dem)
param2 <- c("age","group","gender","site")

Rec.dem<-Rec.dem%>%
  mutate(parameter= rep(param2,each=1))%>%
  arrange(Mean)

ggplot(Rec.dem,aes(x=Mean,y=parameter))+geom_point(size=1.8)+geom_segment(aes(x = X2.5., xend = X97.5.,
                                                                         y =parameter, yend=parameter))+
  xlab("Posterior mean and 95%CI")+theme_bw()+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14))+
  theme(plot.title = element_text(vjust=2,size=18, face="bold"))+ 
  geom_vline(xintercept = 0,linetype = "longdash")


############ Goodness-of-Fit assessment 

Rec.perf<- tidy(out.perf)

Rec.model<-Rec.model%>%
  mutate(Prob=Rec.perf$Mean[1:298])%>%
  mutate(Residuals=Rec.perf$Mean[299:596])%>%
  mutate(Nrow=seq(1:nrow(Rec.model)))


ggplot(Rec.model,aes(x=as.factor(image),y=Prob,color=Residuals))+geom_jitter(size=2.8,width=0.3)+ ggtitle("")+theme_bw()+ylab("Probability")+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14),axis.text.x = element_text(angle=90))+theme(plot.title = element_text(hjust=0.5,vjust=2,size=18, face="bold"))+
  xlab("Image ID")+geom_hline(yintercept = 0.5,linetype = "longdash")+
  scale_colour_gradient2(low="red",mid="gold1",high="blue")

ggplot(Rec.model,aes(x=Nrow,y=Residuals))+geom_point(size=2.8)+ ggtitle("")+theme_bw()+ylab("Residuals")+xlab("Index")+
  theme(axis.text=element_text(size=12),axis.title=element_text(size=14),axis.text.x = element_text(angle=90))+theme(plot.title = element_text(hjust=0.5,vjust=2,size=18, face="bold"))+
  geom_hline(yintercept = 0,linetype = "longdash")

# Assessment of model adequacy based on posterior predictive distributions:
# 1. graphically, in a plot of the lack of fit for the ideal data vs. the lack of fit for the actual data 
## -- if the model fits the data, then about half of the points should lie above and half of them below a 1:1 line

lim <- c(min(c(unlist(out.ppc[,1,1]), unlist(out.ppc[,2,1]))), max(c(unlist(out.ppc[,1,1]), unlist(out.ppc[,2,1]))))
plot(unlist(out.ppc[,1,1]), unlist(out.ppc[,2,1]),
     main="Graphical posterior predictive check", las=1, xlab="SSQ for observed data set", ylab="SSQ for  simulated data sets", 
     xlim=c(25,40), ylim=c(15,45), col="blue")
abline(0, 1)

mean(unlist(out.ppc[,2,1])>unlist(out.ppc[,1,1]))

### Convergence diagnostics


lower_level_aesthetic<-out.grand.mean
mcmcplot(lower_level_aesthetic)

higher_level_aesthetic<-out.beta
mcmcplot(higher_level_aesthetic)

higher_level_demographic<-out.beta.dem
mcmcplot(higher_level_demographic)

