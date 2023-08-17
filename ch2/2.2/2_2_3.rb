# 定数のスコープ

# module MyModule
#   MyConstant = '外側の定義'

#   class MyClass
#     MyConstant = '内側の定義'
#   end
# end

# 定数のパス

module M
  class C
    X = 'ある定数'
  end

  p C::X # -> "ある定数"
end

p M::C::X # -> "ある定数"

# ツリーの奥の場合は、ルートを示すコロン２つで始めれば外部の定数を絶対パスで指定できる。

Y = 'ルートレベルの定数'
module M
  Y = 'モジュールMの定数'
  p Y # -> 'ルートレベルの定数'
  p ::Y # -> 'モジュールMの定数'
end

# Module#constants は現在のスコープにある全ての定数を戻す。（そのModule内の定数を返す感じ)
p M.constants # -> [:Y, :C]
# クラスメソッドのModule.constants は、現在のプログラムのトップレベル定数を戻す。そこにはクラス名も含まれる。
p Module.constants.include? :Object # -> true
p Module.constants.include? :Module # -> true

# パスの確認は Module.nestingでできる

module M
  class C
    module M2
      p Module.nesting # -> [M::C::M2, M::C, M]
    end
  end
end