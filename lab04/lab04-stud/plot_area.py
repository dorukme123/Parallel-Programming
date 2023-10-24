#! /usr/bin/env python
#-*- coding:utf-8 -*-

import sys
import numpy as np

from matplotlib import pyplot as plt

plt.rcParams.update({
  "font.serif": ['Times New Roman'],
  "font.sans-serif": ['Arial'],
  "font.family": 'serif',
  # не использовать настройки шрифтов самого matplotlib
  "pgf.rcfonts": False,
  "pgf.texsystem": 'xelatex',
  "xtick.minor.visible": True,
  "ytick.minor.visible": True,
  "axes.grid": True,
  "axes.grid.which": 'both',
  "grid.linewidth": 0.25,
  "grid.linestyle": 'dashed',
  "grid.color": 'gray',
})


x, y = np.loadtxt(sys.stdin, delimiter=',', usecols=(0,1), comments='#', unpack=True)

fig01 = plt.figure(num=1, figsize=(10,10), dpi=600)
ax01 = fig01.add_subplot(1, 1, 1)

ax01.set_aspect('equal')

ax01.plot(x, y, marker=',', ls='None')

ax01.set_xlabel("$x$")
ax01.set_ylabel("$y$")


fig01.savefig('area.png', dpi=300, format='png', bbox_inches='tight', pad_inches=0.0)
