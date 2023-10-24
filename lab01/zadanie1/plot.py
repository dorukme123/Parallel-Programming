import matplotlib.pyplot as plt
import numpy as np

timing_results = np.loadtxt('C:/Users/Meric/Desktop/lab01/zadanie1/timing_results.txt')
plt.hist(timing_results, bins=20, edgecolor='k')

plt.xlabel('Execution Time (ms)')
plt.ylabel('Frequency')
plt.title('Execution Time Histogram')
plt.show()