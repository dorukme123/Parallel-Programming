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


n, x = np.loadtxt(sys.stdin, delimiter=',', usecols=(0,1), comments='#', unpack=True)

fig01 = plt.figure(num=1, figsize=(6, 3), dpi=600)
ax01 = fig01.add_subplot(1, 1, 1)


ax01.step(n, x, lw=0.2)

ax01.set_xlabel("Время")
ax01.set_ylabel("Разность орлов и решек")


fig01.savefig('coin.png', dpi=600, format='png', bbox_inches='tight', pad_inches=0.0)
