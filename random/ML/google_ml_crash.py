import numpy


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