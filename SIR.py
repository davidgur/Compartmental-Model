"""
SIR.py
David Gurevich
February 9, 2019

Implementation of the SIR Model (with birth and death)
"""

import numpy as np
import matplotlib.pyplot as plt

from scipy.integrate import odeint

# ----- Parameters -----

with open("params.txt", 'r') as f:
    params = f.read().splitlines()[1::2]
    params = [float(x) for x in params]

birth_rate = params[0]
death_rate = params[1]
infection_death_rate = params[2]

duration = int(params[3])

init_population = int(params[4])
per_capita_infection_rate = params[5]
recovery_rate = 1. / params[6]

# ----- Model -----

t = np.linspace(0, duration, duration)

def deriv(y, t):
    S, I, R = y

    dS_dt = (birth_rate * init_population) - (death_rate * S) - (per_capita_infection_rate * ((S * I) / init_population))
    dI_dt = (per_capita_infection_rate * ((S * I) / init_population)) - (death_rate * I) - (recovery_rate * I) - (infection_death_rate * I)
    dR_dt = (recovery_rate * I) - (death_rate * R)

    return dS_dt, dI_dt, dR_dt

I0 = 1
R0 = 0
S0 = init_population - I0 - R0
y0 = S0, I0, R0
ret = odeint(deriv, y0, t)
S, I, R = ret.T

# ----- Graphing -----

fig = plt.figure()
ax = fig.add_subplot(111, axisbelow=True)
ax.plot(t, S, 'r', alpha=0.5, lw=2, label='Susceptible')
ax.plot(t, I, 'g', alpha=0.5, lw=2, label="Infected")
ax.plot(t, R, 'b', alpha=0.5, lw=2, label="Recovered")

ax.set_xlabel("Time (days)")
ax.set_ylabel("Population")
ax.set_title("SIR Graph (with birth and death)")

legend = ax.legend()
legend.get_frame().set_alpha(0.5)

print("Initial Parameters:")
print("\t birth_rate =", birth_rate)
print("\t death_rate =", death_rate)
print("\t infection_death_rate =", infection_death_rate)
print("\t init_population =", init_population)
print("\t per_capita_infection_rate =", per_capita_infection_rate)
print("\t recovery_rate =", params[6], "days")
print("\t time frame =", len(t), "days")
print("Results:")
print("\t Susceptible Population =", int(S[-1]))
print("\t Infected Population =", int(I[-1]))
print("\t Recovered Population =", int(R[-1]))
print("\t Total Population =", int((S+I+R)[-1]))
print()
try:
    print("\t Days until infected are all gone =", np.where(I < 1)[0][0])
except IndexError:
    print("\t Days until infected are all gone = D.N.E")

plt.show()

