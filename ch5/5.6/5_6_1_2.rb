input  = ARGV[0] || 'Rakefile'
output = ARGV[1] || 'Thorfile'

$requires = []

module Kernel
  def require_with_record(file)
    $requires << file if caller[1] =~ /rake2thor:/
    require_without_record file
  end
  alias_method :require_without_record, :require
  alias_method :require, :require_with_record
end

load input

# 上記のコードは、グローバルの配列にrequire するファイルの名前を保管して、
# Kernelモジュールをオープンして、メソッドのトリックを使い、最後にRakefileをload している

# 簡略化したコードで考える。

module Kernel
  alias_method :require_without_record, :require

  def require(file)
    $requires << file if caller[1] =~ /rake2thor:/
    require_without_record file
  end
end

# 通常のKernel#require メソッドにエイリアスをつける。(require_without_record)
# require にモンキーパッチして、Rakefile からrequire されるファイルの名前を保管している。
# ここではKernel#caller メソッドで、呼び出しがわのスタックを取得している。
# スタックの2番目が rake2thor ならば、スタックの1番目はRakefileになる。つまりこれが require を読んでいる。
# 最後に、元の require を呼ぶ（今は require_without_record）

# どちらのバージョンにおいても Kernel#reqire は変わっている。
# 新しい require が 古い require の「周囲（アラウンド）をラップ」している。
# したがって、このトリックを「アラウンドエイリアス」と呼ぶ。

# アラウンドエイリアスは3つの手順で書ける。
# 1. メソッドにエイリアスをつける。
# 2. メソッドを再定義する。
# 3. 新しいメソッドから古いメソッドを呼ぶ。

# アラウンドエイリアスの欠点は、新しいメソッド名でクラスを汚染してしまうことだ。
# これは些細な問題で、メソッドをエイリアスした後でprivate にすれば解決できる。

# もう一つの潜在的な問題は、読み込みに関することである。アラウンドエイリアスは２回読み込んではいけない。
# メソッドを呼び出したときに例外が発生するかもしれないからだ。

# アラウンドエイリアスは一種のモンキーパッチなので、メソッド変更を考えていない既存のコードを破壊しかねないことが大きな問題だ。
