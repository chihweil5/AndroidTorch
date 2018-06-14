import matplotlib.pyplot as plt
import matplotlib.animation as animation
import numpy as np
import time
import subprocess
import platform

sys = platform.system()
if sys == 'Linux':
    command = './cpu.sh'
elif sys == 'Darwin':
    command = 'sh cpu.sh'

proc = subprocess.Popen([command], shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

title = ["CPU", "CPU0", "CPU1", "CPU2", "CPU3"]
fig, axs = plt.subplots(5, 1, sharex=True, figsize=(10,7))
fig.subplots_adjust(hspace=1)

def animate(i):
    pullData = open("cpu_usage.txt","r").read()
    dataArray = pullData.split('\n')
    line = 0
    x = []
    y_cpu  = [[],[],[],[],[]]
    for eachLine in dataArray:
        if len(eachLine)>1:
            x.append(line)
            line += 1
            cpu = eachLine.split(' ')
            for num, value in enumerate(cpu):
                y_cpu[num].append(int(value))

    for num in range(5):
        axs[num].clear()
        axs[num].title.set_text(title[num])
        axs[num].set_ylim([0, 100])
        axs[num].set_ylabel('usage (%)')
        axs[num].plot(x, y_cpu[num])
        plt.xlabel('relative time (s)')

ani = animation.FuncAnimation(fig, animate, interval=1000)
plt.show()
