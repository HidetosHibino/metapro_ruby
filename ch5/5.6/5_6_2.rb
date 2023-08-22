# メソッドラッパー
# Refinemrnts はアラウンドエイリアスの代わりに使うことができる。

# リファインしたメソッドからsuper を呼び出すと、元のリファインしていないメソッドが呼び出せる。

module StringRefiments
  refine String do
    def length
      super > 5 ? 'long' : 'short'
    end
  end
end

using StringRefiments

p 'War and Peace'.length # -> "long"

# 上記のコードはStringクラスをリファインして、length メソッドの周囲に機能を追加したものである。
# この Refinements ラッパーが適応されるのは、ファイルの最後まで(Ruby2.1からはモジュールの最後まで)

