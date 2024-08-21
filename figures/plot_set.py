import matplotlib.pyplot as plt
import numpy as np

plt.rcParams['font.family'] = 'Times New Roman'
# csfont = {'fontname':'Times New Roman'}
# 读取文件并解析数据
x_values = []
y_values = []

with open('./set-L2.txt', 'r') as file:
    for line in file:
        x, y = line.strip().split(',')
        x_values.append(float(x))
        y_values.append(float(y))
fig, ax = plt.subplots(figsize=(5, 4), dpi=100)

# 绘制散点图
# plt.scatter(x_values, y_values, s=0.25)
# plt.xlabel('Accessed Index in Array A')
# plt.ylabel('Evicted Index in Array B')
ax.scatter(x_values, y_values, s=0.25)
ax.set_xlabel('Accessed Index in Array A')
ax.set_ylabel('Evicted Index in Array B')

xticks = np.array([0, 1, 2, 3, 4, 5, 6]) * 256 * 1024
ax.set_xticks(xticks)
ax.set_xticklabels([str(int(tick / (256 * 1024))) if tick != 6 * 256 * 1024 else str(int(tick / (256 * 1024))) + '$\\times 2^{18}$' for tick in xticks], fontsize=12)
yticks = np.array([0, 1, 2, 3, 4, 5, 6, 7, 8]) * 16384
ax.set_yticks(yticks)
ax.set_yticklabels([str(tick) for tick in yticks], fontsize=12)

# plt.title('Evicted Index and Accessed Index')
fig.tight_layout()

# 保存为SVG格式
plt.savefig('evicted_index.svg', format='svg')
plt.savefig('evicted_index.pdf', format='pdf')

# 显示图表（如果需要）
# plt.show()
