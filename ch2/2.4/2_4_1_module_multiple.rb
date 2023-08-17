# 多重インクルード
# 以下の例で、M3はM2をインクルードしている。
# このとき、M2でM1をインクルードしているが、M3ではそのインクルードは何の効果もない。
# なぜなら、M3内で先にM1をprependしており、Rubyでは2回目の挿入は無視されるからである。

module M1; end

module M2
  include M1
end

module M3
  prepend M1
  include M2
end

p M2.ancestors # -> [M2, M1]
p M3.ancestors # -> [M1, M3, M2]

# M3.ancestors # -> [M3, M2, M1]　ではない。
# prepend M1を削除すると、[M3, M2, M1]になる。

# Kernel
# Rubyではどこからでも呼び出せるメソッドがある。
# 例えば print がそう。
# これらは Kernel のprivate インスタンスメソッドである。
p Kernel.private_instance_methods.grep(/^p/)
# Object クラスがKernelモジュールをインクルードしているので、全てのオブジェクトの継承チェーンにKernelモジュールが挿入されている。
# Rubyのコードは常にオブジェクトの内部で実行されるので、Kernelモジュールのメソッドはどこからでも実行できる。

# 気になったので、トップレベルは　main
# Ruby　のトップレベルは main オブジェクト
# https://docs.ruby-lang.org/ja/latest/class/main.html
# トップレベルでの self を表すオブジェクトです。
# p self # -> main
# p self.class #-> Object
