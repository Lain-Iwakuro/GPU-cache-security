import matplotlib.pyplot as plt
import numpy as np

plt.rcParams['font.family'] = 'Times New Roman'
# 读取文件中的数据
def read_data(file_path):
    with open(file_path, 'r') as file:
        data = [float(line.strip()) for line in file]
    return data

# 读取两个文件中的数据
data1 = read_data('./access.txt')[1::5]
data2 = read_data('./no-access.txt')[1::5]

# 设置直方图的bins数量
bins = np.linspace(min(data2), max(data1), 50)
fig, ax = plt.subplots(figsize=(5, 2.5), dpi=100)

# 绘制直方图
# plt.hist(data1, bins=bins, alpha=0.5, label='access', edgecolor='black')
# plt.hist(data2, bins=bins, alpha=0.5, label='no access', edgecolor='black')
ax.hist(data1, bins=bins, alpha=0.5, label='access', edgecolor='black')
ax.hist(data2, bins=bins, alpha=0.5, label='no access', edgecolor='black')
# 添加图例和标签
# plt.legend(loc='upper right')
# plt.xlabel('Probe Time')
# plt.ylabel('Frequency')
# ax.legend(loc='upper right', fontsize=12)
ax.legend(loc='upper right')
ax.set_xlabel('Probe Time/cycle')
ax.set_ylabel('Frequency')
ax.tick_params(axis='both', which='major')
# plt.title('Probe Time in 2 Cases')
fig.tight_layout()

# 显示图形
# plt.show()

# 保存为SVG格式
plt.savefig('probe_time.svg', format='svg')
plt.savefig('probe_time.pdf', format='pdf')
