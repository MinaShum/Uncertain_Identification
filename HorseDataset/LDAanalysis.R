
# LDA for Z Matrix #

df <- read.csv("DistancesR.csv")
df <- na.omit(df)
to.exclude <- c("Frames")
df <- df[, !colnames(df) %in% to.exclude]
no <- length(unique(df$Videos))
Vid_label <- unique(df$Videos)
c <- 1
for (i in Vid_label){
  df$Videos[df$Videos == i ] <- c
  c <- c+1
}

# Random indices for cross validation 
set.seed(123)
total_numbers <- 3225
num_groups <- 5
num_to_choose_per_group <- 645
groups <- list()
available_numbers <- 1:total_numbers
for (i in 1:num_groups) {
  random_numbers <- sample(available_numbers, num_to_choose_per_group, replace = FALSE)
  available_numbers <- setdiff(available_numbers, random_numbers)
  groups[[i]] <- random_numbers
}
groups[[1]][646] <- 3226

ldal <- list()
pl <- list()
test <- list()
model <- list()
check <- list()
for (fold in 1:num_groups){
  df_test <- df[groups[[fold]], ]
  df_train<- df[-groups[[fold]], ]
  to.exclude <- c("Videos")
  test.set <- df_test[, !colnames(df) %in% to.exclude]
  #LDA Fit
  lda.model <- lda(Videos ~ ., df_train)
  #Predict
  p1 <- predict(lda.model, test.set)
  p <- p1$class
  # add to df
  l <- data.frame(matrix(nrow=length(groups[[fold]]), ncol=32))
  for (i in 1:length(p)) {
    a <- data.frame(p1$posterior[i,])
    l[i,3:32] <- t(a)
    check[[fold]] <- p1$posterior
  }
  l[,1] <- df_test$Videos
  l[,2] <- p1$class
  ldal[[fold]] <- l
  pl[[fold]] <- p1
  test[[fold]] <- df_test
  model[[fold]] <- lda.model
}
lda_result <- rbind(ldal[[1]], ldal[[2]], ldal[[3]], ldal[[4]], ldal[[5]])
lda_result <- lda_result[order(as.numeric(lda_result$X1)), ]
new_colnames <- c("Animal", "Prediction", 1:30)
colnames(lda_result)[1:32] <- new_colnames
