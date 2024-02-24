import numpy as np
import pylab as pl



count = 400 # steps
T = 10**6   # seconds

N = 1001
k = (-6 * count) / (T**3)  ## constant jerk
print(k)

t = np.linspace(0, T, N)
dt = t[1] - t[0]
v = k * t * (t - T)
a = np.gradient(v) / dt
j = np.gradient(a) / dt
p = np.cumsum(v) * dt
fig, ax = pl.subplots(4, figsize=(12, 12))
ax[0].plot(t, p)
ax[1].plot(t, v)
ax[2].plot(t, a)
ax[3].plot(t, j)


tt = 0
pp = 0
vv = 0
jj = -12 * count / (T ** 3)
ax[3].plot(tt, jj, 'ro')
max_delay = 10000
min_delay = 100;
delay = min_delay
while pp < count and tt < T:
    pp += 1
    tt += delay
    vv = k * tt ** 2 - k * tt * T
    delay = 1/vv
    if delay < min_delay:
        delay = min_delay
    if delay > max_delay:
        delay = max_delay
    print(tt, pp, vv, delay)
    ax[0].plot(tt, pp, 'r.')
print(pp, count)
pl.tight_layout()
pl.show()

def test():
    max_delay = .01 # seconds
    p = 0
    t = 0
    d = max_delay;
    data = []
    while p < count and t < T:
        t += d
        d = j / (2 * t * (t - T))
        if d > max_delay:
            d = max_delay
        p += 1
        data.append([t, p, d])

    data = np.array(data)
    pl.plot(data[:,0], data[:,1])
    pl.show()
