# Practicle ML
# Source: W3schools
# Url: 

import numpy
import matplotlib.pyplot as plt
from scipy import stats

speed = [99,86,87,88,111,86,103,87,94,78,77,85,86]

xbar = numpy.mean(speed)
print(xbar)

med = numpy.median(speed)
print(med)

from scipy import stats
mod = stats.mode(speed)
print(mod)

std = numpy.std(speed)
print(std)

var = numpy.var(speed)
print(var)

# Percentiles

prct = numpy.percentile(speed, 25)
print(prct)

runif = numpy.random.uniform(0,5, 100)
print(runif)

# Histogram

plt.hist(runif, 5)
plt.show()

rnorm = numpy.random.normal(5, 1, 500)
plt.hist(rnorm, 20)
plt.show()

# Scatter

x = numpy.random.uniform(2, 5, 20)
y = numpy.random.uniform(2, 5, 20)+numpy.random.uniform(-1, 1, 20)
plt.scatter(x, y)
plt.show()

# Another

x = [5,7,8,7,2,17,2,9,4,11,12,9,6]
y = [99,86,87,88,111,86,103,87,94,78,77,85,86]
plt.scatter(x, y)
plt.show()


# Linear regression 
slope, intercept, r, p, std_err = stats.linregress(x, y)
print(slope)
print(r)

# To predict future values

def myfunc(x):
    return slope * x + intercept

modl = list(map(myfunc, x))
plt.plot(x, modl)

plt.scatter(x, y)

# Alternative of list(map)()

