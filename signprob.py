import numpy as np
import matplotlib.pyplot as plt

deno = lambda x, p: np.exp(1.0j*p*x)
nume = lambda x, p: x**2 * np.exp(1.0j*p*x)
obs = lambda x, p: np.abs(nume(x, p) / deno(x, p) / (1 - p**2))

Nsample = 10000
list_p = np.arange(0, 100, 2)
list_obs = [np.mean([obs(np.random.normal(0.0, 1.0, 1), p) for i in np.arange(Nsample)]) for p in list_p]
plt.plot(list_p, list_obs)
plt.yscale('log')
plt.show()
