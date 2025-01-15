library(tibble)
library(MASS)

# Simulation of independent phenotypes #

distance <- read.csv('DistancesR.csv')
distance <- na.omit(distance)
Vid_label <- unique(distance$Videos)
c <- 1
for (i in Vid_label){
  distance$Videos[distance$Videos == i ] <- c
  c <- c+1
}
frame_an_index <- as.integer(distance$Videos)

#Fixed data 
gm <- 0          # Grand mean               
varc <- 1         # Variance                   
es <- c(0.5, 0.5, 0.5, 1, 1, 1, 1.5, 1.5, 1.5)  # Effect Size 
r <- c(0.3, 0.5, 0.8, 0.3, 0.5, 0.8, 0.3, 0.5, 0.8) # Repeatability 
nanim <- length(unique(frame_an_index)) # Number of individuals /Videos
num_simulations <- 1000 # Per data frame 
Ydf <- data.frame(matrix(nrow = length(unique(frame_an_index)), ncol = num_simulations)) 
Xdf <- data.frame(matrix(nrow = length(frame_an_index), ncol = num_simulations))
Grpdf <- data.frame(matrix(nrow = floor(nanim/2), ncol = num_simulations)) 
simul_output <- data.frame(matrix(nrow=6, ncol=length(r)))
Yl <- list() 
Xl <- list()

grpdf <- data.frame(matrix(nrow = 15, ncol = 1000))
for (i in 1:num_simulations){
  set.seed(i)
  gp <- sample(1:nanim, floor(nanim/2), replace=FALSE)
  grpdf[,i] <- gp
}

# Simulation
for (j in 1:length(r)){ # 9 Scenarios based on es and r combinations
  esm <- es[j]
  rm <- r[j]
  diff <- esm*sqrt(varc)
  m1 <- (diff/2)+gm
  m2 <- -(diff/2)+gm
  varm <- ((1/rm^2)-1)*varc
  for (i in 1:num_simulations){
    x <- 1000*j + i
    set.seed(x)
    gp1 <- grpdf[,i]
    grp <- rep(2, nanim)
    grp[gp1] <- 1
    grp_mn <- c(m1, m2)
    anim_eff <- rnorm(n = nanim, mean = grp_mn[grp], sd = sqrt(varc))
    frame_eff <- rnorm(n = length(frame_an_index), mean = anim_eff[frame_an_index],sd = sqrt(varm))
    Ydf[,i] <- anim_eff
    Xdf[,i] <- frame_eff
    Xdf2 <- cbind(data.frame(frame_an_index), Xdf)
    Grpdf[,i] <- gp1
  }
  variables <- t(cbind(m1,m2,varm,esm,rm,diff))
  Xl[[j]] <- Xdf2
  Yl[[j]] <- Ydf
  simul_output[,j] <- variables
}

# Checking
plot(cbind(as.vector(by(Xl[[7]]$X50,Xl[[7]]$frame_an_index,mean)),Yl[[7]]$X50))
abline(0,1)

#####################################################################
# LMER on one simulation scenario#
# Same pipeline used for ground truth and top prediction models #

i <- 1
s <- 1
input_df = tibble(horse = as.factor(frame_an_index), 
                  grp = as.factor(ifelse(frame_an_index %in% as.integer(grpdf[,s]), 1,2)),
                  y = Xl[[i]][,s+1])
lm1<-lmer(y ~ grp + (1|horse), data = input_df)

summary(lm1)

