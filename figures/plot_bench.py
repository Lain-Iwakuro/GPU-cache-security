import matplotlib.pyplot as plt
import numpy as np

plt.rcParams['font.family'] = 'Times New Roman'
# 示例数据
group_labels = ['FIR', 'AES', 'PR', 'MM']
data = [
    [0.02852941, 4.6730935
, 4.672318
],  # 第一组数据
    [0.021122835
, 0.02317544
, 0.02374974
],  # 第二组数据
    [0.03661138
, 0.075621345
, 0.075650115
],  # 第三组数据
    [0.4255
, 0.8879
, 0.8873
]   # 第四组数据
]
num_groups = len(data)
num_bars = len(data[0])

# 创建4个子图
fig, axs = plt.subplots(1, 4, figsize=(6, 2.5), sharey=False)

colors = ['blue', 'green', 'red']
labels = [f'Data {i+1}' for i in range(num_bars)]
# 绘制每个子图的柱状图
for i in range(4):
    axs[i].bar(range(num_bars), data[i], color=colors, width=0.75)
    axs[i].set_title(group_labels[i])
    # axs[i].set_xlabel('Data Points')
    if i == 0:
        axs[i].set_ylabel('Time/s')
    axs[i].set_ylim(0, max(data[i]) * 1.2)  # 根据每个子图的数据设置y轴范围
    # axs[i].set_xticks(range(num_bars))
    # axs[i].set_xticklabels([f'Data {j+1}' for j in range(num_bars)])
    axs[i].set_xticklabels([])

# 调整子图之间的间距
plt.subplots_adjust(wspace=0.1)
custom_handles = [plt.Line2D([0], [0], color=color, lw=4) for color in colors]
fig.legend(custom_handles, ['no guard', 'guard', 'dummy guard'], loc='upper center', ncol=num_bars, bbox_to_anchor=(0.5, 0.95))

# plt.tight_layout()
fig.tight_layout(rect=[0, 0, 1, 0.8])

# 显示图形
# plt.show()

# 保存为SVG格式
plt.savefig('bench_time.svg', format='svg')
plt.savefig('bench_time.pdf', format='pdf')