
# 以下実験用

s_log_flg = true
e_log_flg = true

lambda {
  setups = []
  events = []

  Kernel.send :define_method, :setup do |&block|
    setups << block
  end

  Kernel.send :define_method, :event do |description, &block|
    events << { description: description, condition: block }
  end

  Kernel.send :define_method, :each_setup do |&block|
    setups.each do |setup|
      p 'S:No1' if s_log_flg 
      block.call setup
      p 'S:No4' if s_log_flg 
    end
  end

  Kernel.send :define_method, :each_event do |&block|
    events.each do |event|
      p 'E:No1' if e_log_flg
      block.call event
      p 'E:No4' if e_log_flg
    end
  end
}.call

load 'events.rb'

# 以下をmapやeachのように捉えてはいけない。
# 単純なメソッドと、ブロックとして捉えよう。 (ex: メソッド＝each_setup ブロック＝setup.call)
# ブロックに指定された手続きは、各each_XXXX の中で、block.call の形で呼ばれている。
# map/eachにあたるものは、各each_XXXX の中で、lambdaのローカル変数(setups, events)から取得されている。

each_event do |event|
  p 'E:No2' if e_log_flg
  each_setup do |setup|
    p 'S:No2' if s_log_flg 
    setup.call
    p 'S:No3' if s_log_flg 
  end
  puts "ALEART: #{event[:description]}" if event[:condition].call
  p 'E:No3' if e_log_flg
end