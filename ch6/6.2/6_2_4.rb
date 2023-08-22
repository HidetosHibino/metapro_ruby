# instance_eval および class_eval はコード文字列またはブロックのいずれかを引数にとれる。
# 文字列にあるコードは、ブロックにあるコードと大きな違いはないから。

array = ['a', 'b', 'c']
x = 'd'
array.instance_eval 'self[1] = x'

p array # -> ["a", "d", "c"]
