data{
  array[1770] real y;
  matrix[1770,59] z;
}

parameters{
  real<lower=0> s_e ;
  real<lower=0> s_h;
  real trt_eff;
  vector[59] cow_eff;
}

model{
  cow_eff ~ normal(0, s_h);
  trt_eff ~ normal(0,100);
  s_e ~ lognormal(0,10);
  s_h ~ lognormal(0,10);
  vector[59] mu = trt_eff + cow_eff;
  for (i in 1:1770){
    vector[59] lps = log(to_vector(z[i,]));
    for (j in 1:59){
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
  matrix[1770, 59] cow_probs;
  for (i in 1:1770) {
    vector[59] lps = rep_vector(0, 59);
    for (j in 1:59) {
      lps[j] = log(z[i, j]) + normal_lpdf(y[i] | (trt_eff + cow_eff[j]), s_e);
    }
    vector[59] probabilities = softmax(lps);
   for (j in 1:59) {
     cow_probs[i, j] = probabilities[j];
    }
  }
}
