# トップレベル変数を削除

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
      block.call setup
    end
  end

  Kernel.send :define_method, :each_event do |&block|
    events.each do |event|
      block.call event
    end
  end
}.call

load 'events.rb'

# env = object.new で each_evant のブロック内で毎回新たなオブジェクトを作る。
# そのオブジェクトのself　ごとにsetup/event を実行

# env が実行されるごとに。新たな実行するため環境として、obj が作成され、そのobj単位でsetup eventを実行する。

each_event do |event|
  env = Object.new
  each_setup do |setup|
    # setup.call
    env.instance_eval &setup
  end
  puts "ALEART: #{event[:description]}" if env.instance_eval &(event[:condition])
end
