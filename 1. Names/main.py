# python3 main.py

def alpha_sum(string):
    ans = 0
    for letter in string.lower():
        ans += ord(letter) - ord('a') + 1
    return ans


with open('names.txt', 'r') as file:
    names = file.read().replace('"', '').split(",")
names.sort()

result = 0
for i, name in enumerate(names):
    result += alpha_sum(name) * (i + 1)
print(result)
