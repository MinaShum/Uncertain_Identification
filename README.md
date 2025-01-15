# Computer Vision Based Phenotyping and Analysis in Presence of Uncertain Identification
**Mina Shumaly, Yunsoo Park, Saif Agha, Santosh Pandey, Juan Steibel** <br>
This repository hosts the models and simulation used in our paper to reproduce the results.
<br>
<br>
- `Horse_model.stan`: This file contains the marginalization model used in STAN programming language for the horse dataset (simulated phenotype).
- `Cattle_model.stan`: This file contains the marginalization model used in STAN programming language for the dairy cattle dataset (extracted phenotype).
- `TestRun`: This folder contains a working example using stan models to fit a variational bayes model on one scenario of horse dataset.
<br>
- Image data and annotations for the horse dataset are available at: http://horse10.deeplabcut.org
- Mathis, A., Biasi, T., Schneider, S., Yuksekgonul, M., Rogers, B., Bethge, M., & Mathis, M. W. (2021). Pretraining boosts out-of-domain robustness for pose estimation. In Proceedings of the IEEE/CVF winter conference on applications of computer vision (pp. 1859-1868).
<br>
<br>
- Image data and annotations for the cattle dataset are not publicly available due to ongoing development of the algorithms but are available from the corresponding author on reasonable request. 
