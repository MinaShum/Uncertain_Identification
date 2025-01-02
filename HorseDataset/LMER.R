# LMER for each scenario, 9k runs #
# Same pipeline used for ground truth and top prediction models #

lml <- list()
intermediate_df <- data.frame(matrix(nrow = 5, ncol = 1000))
horse = as.factor(frame_an_index)

models <- list()
for (i in 1:9){
  for (s in 1:1000){
    input_df = tibble(horse = as.factor(frame_an_index), 
                      grp = as.factor(ifelse(frame_an_index %in% as.integer(grpdf[,s]), 1,2)),
                      y = Xl[[i]][,s+1])
    lm1<-lmer(y ~ grp + (1|horse), data = input_df)
    estimate <- data.table(coef(summary(lm1)), keep.rownames = 'term')$Estimate
    std <- as.data.frame(VarCorr(lm1))$sdcor
    pval <- summary(lm1)$coefficients[2,5]
    intermediate_df[1,s]<-estimate[1]
    intermediate_df[2,s]<-estimate[1]+estimate[2]
    intermediate_df[3:4,s]<-std 
    intermediate_df[5,s]<-pval
    models[[s]] <- lm1
  }
  lml[[i]] <- intermediate_df
}