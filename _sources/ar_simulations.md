# AR Simulation
## Setup

- Data generation: Let ${y_1,\cdots,y_T}$ be a data series. The data is generated according to the following model: $$ y_{t+1} = \phi y_t + \epsilon_{t+1}, \quad \epsilon_{t+1} \sim N(0, \sigma^2),$$where $\phi = 0.8$ and $\sigma^2 = 1$.
- Settings: 
	  - Setting 1 with $T=3$
	  - Setting 2 with $T=10$
	  - Setting 3 with $T=100$
- For each setting, we generate $10000$ data series as training dataset and $1000$ as test dataset. 


## Accuracy and Variability of the Prediction Results

Prediction $\hat{y}_T = \frac{1}{m}\sum_{i=1}^{m}\hat{y}_{T,i}$

| Criterion                          |  m=1   |  m=5   | m=100  |
| :--------------------------------- | :----: | :----: | :----: |
| **Setting 1**                      |        |        |        |
| $E[(\hat{y}_3 - y_3)^2]$           | 2.157  | 1.322  | 1.211  |
| $E[(\hat{y}_3 - 0.8y_2)^2]$        | 1.253  | 0.418  |  0.25  |
| $E(\hat{y}_3 - 0.8y_2)$            | 0.051  | 0.035  | 0.016  |
| $var(\hat{y}_3 - 0.8y_2)$          | 1.251  | 0.417  | 0.249  |
| **Setting 2**                      |        |        |        |
| $E[(\hat{y}_{10} - y_{10})^2]$     | 1.399  | 1.354  | 1.346  |
| $E[(\hat{y}_{10} - 0.8y_9)^2]$     |  0.43  | 0.396  | 0.392  |
| $E(\hat{y}_{10} - 0.8y_9)$         | -0.032 | -0.034 | -0.033 |
| $var(\hat{y}_{10} - 0.8y_9)$       | 0.429  | 0.395  |  0.39  |
| **Setting 3**                      |        |        |        |
| $E[(\hat{y}_{100} - y_{100})^2]$   | 1.309  | 1.265  | 1.259  |
| $E[(\hat{y}_{100} - 0.8y_{99})^2]$ | 0.292  | 0.253  | 0.244  |
| $E(\hat{y}_{100} - 0.8y_{99})$     | 0.062  | 0.055  | 0.054  |
| $var(\hat{y}_{100} - 0.8y_{99})$   | 0.288  |  0.25  | 0.241  |
