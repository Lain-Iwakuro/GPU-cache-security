
with open('out.txt', 'r', encoding='utf-8') as file:
    new_lines = file.readlines()
    # print(new_lines)
    modified_lines = [[int(part) for part in line.strip().split(', ') if len(part) > 0] for line in new_lines if ',' in line]
    new_dict = {key: value for key, value in modified_lines}
    # print(new_dict)

with open('set.txt', 'r', encoding='utf-8') as file:
    old_lines = file.readlines()
    old_lines = [[int(part) for part in line.strip().split(', ') if len(part) > 0] for line in old_lines]
    # print(old_lines)
    old_dict = {key: value for key, value in old_lines}

for key, value in new_dict.items():
    neighbors = [new_dict.get(k) for k in [key - 32, key + 32, key - 64, key + 64, key - 96, key + 96]]
    if new_dict.get(key) not in neighbors:
        old_dict[key] = value

with open('set.txt', 'w', encoding='utf-8') as file:
    updated_lines = [str(key) + ', ' + str(value) + '\n' for key, value in old_dict.items()]
    file.writelines(updated_lines)
