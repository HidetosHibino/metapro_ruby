class Lawyer; end
nick = Lawyer.new

# 以下はundefinedエラー undefined method `talk_simple' for #<Lawyer:0x0000000102ec9d18> (NoMethodError)
# p nick.talk_simple

# undefinedエラーということは、「呼び出したが、見つからなかった」ということ。
# Ruby ではメソッド呼び出しを制限するコンパイラは存在しない。つまり存在しないメソッドも呼び出せる。

# 継承チェーン上に当該のメソッドがなかった場合、Rubyは元のレシーバのmethod_missing メソッドを呼び出して、負けを認める。
# method_missing は　BasicObjectのprivateインスタンスメソッドである。
# この場合のレシーバはnick

# # method_missingを自分で呼び出すこともできる。第二引数に持っているはずのメソッド(例えばKernel#puts) を指定してもエラーとなる。
# nick.send :method_missing, :puts

# method_missing をオーバーライドすることで、不明なメッセージを捕まえることができる。
class Lawyer
  def method_missing(method, *args)
    puts "呼び出した: #{method}(#{args.join(',')})"
    puts "ブロックも渡した" if block_given?
  end
end

bob = Lawyer.new
bob.talk_simple('a', 'b') do
  # ブロック
end

# 上記の結果
# 呼び出した: talk_simple(a,b)
# ブロックも渡した

# method_missingをオーバーライドすると実際には存在しないメソッドを呼び出せる
# 危険じゃないか？