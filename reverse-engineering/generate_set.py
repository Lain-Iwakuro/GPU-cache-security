from collections import defaultdict

with open('set.txt', 'r', encoding='utf-8') as file:
    old_lines = file.readlines()
    old_lines = [[int(part) for part in line.strip().split(', ') if len(part) > 0] for line in old_lines]
    # print(old_lines)
    old_dict = {key: value for key, value in old_lines}

rev_dict = defaultdict(list)
for key, value in old_dict.items():
    rev_dict[value].append(key)

with open('rev_set.txt', 'w', encoding='utf-8') as file:
    updated_lines = [','.join(map(str, value)) + '\n' for key, value in rev_dict.items()]
    file.writelines(updated_lines)