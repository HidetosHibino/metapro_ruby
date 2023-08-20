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

# 以下をmapやeachのように捉えてはいけない。
# 単純なメソッドと、ブロックとして捉えよう。 (ex: メソッド＝each_setup ブロック＝setup.call)
# ブロックに指定された手続きは、各each_XXXX の中で、block.call の形で呼ばれている。
# map/eachにあたるものは、各each_XXXX の中で、lambdaのローカル変数(setups, events)から取得されている。

each_event do |event|
  each_setup do |setup|
    setup.call
  end
  puts "ALEART: #{event[:description]}" if event[:condition].call
end

=begin
ちょっとむずいので脳内トレース。

1.lambdaの定義
  setups = []
  events = []

  -> lambda　内のローカル変数宣言。 lambdaの中でしか生きないため、汚染が少ない

  Kernel に各メソッドを定義。

  .call で lambda を実行


2.events.rbの実行
  load でevents.rb の内容を取得/実行
  setup x 2 と event x 3 を実行する。

  setup は ブロック（do ~ end） をもらって　(引数: &block)、
  Proc オブジェクトとしてsetupsに追加

  event は 説明(description)　と ブロック（do ~ end） をもらって　(引数: &block)、
  ハッシュを作成。　events に追加

3.each_xxxx の実行
　A.each_event の処理
    each_event は　以下のブロックをもらう

    do |event|
      each_setup do |setup|
        setup.call
      end
      puts "ALEART: #{event[:description]}" if event[:condition].call
    end

    each_event は以下のような実装。ここの &block に　上記のブロックが代入される感じ

    Kernel.send :define_method, :each_event do |&block|
      events.each do |event|
        block.call event
      end
    end

    上記を読み解くと、
    events 配列のそれぞれ(event)に対して、 # events.each do |event|
    &blockでもらった Procオブジェクト を 
    引数=event で実行(call)する。

    になる

    ここで、以下のevent は、
    「events 配列のそれぞれ(event)に対して、 # events.each do |event|　」のevent になる。

    do |event|
      each_setup do |setup|
        setup.call
      end
      puts "ALEART: #{event[:description]}" if event[:condition].call
    end


    # もっと解説すると
    # ＆block は以下だったので、
    # do |event|
    #   each_setup do |setup|
    #     setup.call
    #   end
    #   puts "ALEART: #{event[:description]}" if event[:condition].call
    # end

    # each_event は以下のように解釈される。

    # Kernel.send :define_method, :each_event do |&block|
    #   events.each do |event|

    #     # before
    #     # block.call event

    #     # after
    #     each_setup do |setup|
    #       setup.call
    #     end
    #     puts "ALEART: #{event[:description]}" if event[:condition].call

    #   end
    # end

  B.each_setup の処理
    each_event メソッドの中で、each_setupは以下のように呼ばれる。

    each_setup do |setup|
      setup.call
    end

    これは、each_setup に、
    【ブロック】
      do |setup|
        setup.call
      end
    を与えて実行するということである。

    each_setup　は以下のような実装である。

    Kernel.send :define_method, :each_setup do |&block|
      setups.each do |setup|
        block.call setup
      end
    end

    つまり、上記の &block を
    【ブロック】
      do |setup|
        setup.call
      end
    として実行するということ

    setups.each do |setup|
      block.call setup
    end

    なので、
    setups のここの要素を順に、setup として、
    block の引数に setup を渡して blockをcall する

    -> block は　以下のようなので、
      do |setup|
        setup.call
      end

    ブロックの引数setuop(do |setup| )　に setups.eachのsetup (setups.each do |setup| )を代入してループ処理を行うとなる。

=end