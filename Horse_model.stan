data{
  array[3226] real y;
  matrix[3226,30] z;
  array[30] int<lower=1, upper=2> trt;
}

parameters{
  real<lower=0> s_e ;
  real<lower=0> s_h;
  vector[2] trt_eff;
  vector[30] horse_eff;
}

model{
  horse_eff ~ normal(0, s_h);
  trt_eff ~ normal(0,100);
  s_e ~ lognormal(0,10);
  s_h ~ lognormal(0,10);
  vector[30] mu = trt_eff[trt]+horse_eff;
  for (i in 1:3226){
    vector[30] lps = log(to_vector(z[i,]));
    for (j in 1:30){
      lps[j] += normal_lpdf(y[i]|mu[j],s_e);
    }
    target += log_sum_exp(lps);
  }
}

generated quantities{
  real s2_e;
  real s2_h;
  s2_e = s_e^2;
  s2_h = s_h^2;
  real trt_f;
  trt_f = trt_eff[1]-trt_eff[2];
  matrix[3226, 30] horse_probs;
  for (i in 1:3226) {
    vector[30] lps = rep_vector(0, 30);
    for (j in 1:30) {
      lps[j] = log(z[i, j]) + normal_lpdf(y[i] | (trt_eff[trt[j]] + horse_eff[j]), s_e);
    }
    vector[30] probabilities = softmax(lps);
   for (j in 1:30) {
     horse_probs[i, j] = probabilities[j];
    }
  }
}
