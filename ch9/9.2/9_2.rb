# ActiveRecord::Baseの機能がどのように礼儀されているかをみる。

require 'active_record' #から見ていく

# ch9/activerecord-7.0.4.3/lib/active_record.rb

require "active_support"
require "active_model"
# ...

module ActiveRecord
  extend ActiveSupport::Autoload # 引数で指定したモジュールのインスタンスメソッドを self の特異メソッドとして追加します。

  autoload :Base
  autoload :Callbacks
  autoload :ConnectionHandling
  autoload :Core
  autoload :CounterCache
  # ....


ActiveRecord は2つの大きなライブラリに依存している。
ActiveSupport と ActiveModel である。
それぞれをすぐにロードしている。

ActiveSupportの方はすぐにこのコードの中で使われている。
ActiveSupport::Autoloadモジュールでは、autoload が定義されている。
このメソッドでは、モジュール名を最初に使ったときに、自動的にモジュールやクラスのソースコードを探してrequire するという命名規則が使われている。

ActiveRecordは ActiveSupport::Autoload をエクステンドしているので、autoloadはActivaRecordモジュールのクラスメソッドになる。
ActiveRecordは autoloadをクラスマクロとして使い、多くのモジュールを登録している。
その結果、ActiveRecord はネームスペースのように振る舞い、ライブラリを構成するものを全て自動的にロードする。（:Base, :Callbacks ... のような感じと思われる。）
