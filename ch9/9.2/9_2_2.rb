# ActiveRecord::Base の実装をみる。
# ch9/activerecord-7.0.4.3/lib/active_record/base.rb
# 適宜 gem unpack activerecord で展開する

module ActiveRecord
  class Base
    extend ActiveModel::Naming

    extend ActiveSupport::Benchmarkable
    extend ActiveSupport::DescendantsTracker

    extend ConnectionHandling
    extend QueryCache::ClassMethods
    extend Querying
    extend Translation
    extend DynamicMatchers
    extend DelegatedType
    extend Explain
    extend Enum
    extend Delegation::DelegateCache
    extend Aggregations::ClassMethods

    include Core
    include Persistence
    include ReadonlyAttributes
    include ModelSchema
    include Inheritance
    include Scoping
    include Sanitization
    include AttributeAssignment
    include ActiveModel::Conversion
    include Integration
    include Validations
    include CounterCache
    include Attributes
    include Locking::Optimistic
    include Locking::Pessimistic
    include AttributeMethods
    include Callbacks
    include Timestamp
    include Associations
    include ActiveModel::SecurePassword
    include AutosaveAssociation
    include NestedAttributes
    include Transactions
    include TouchLater
    include NoTouching
    include Reflection
    include Serialization
    include Store
    include SecureToken
    include SignedId
    include Suppressor
    include Encryption::EncryptableRecord
  end

  ActiveSupport.run_load_hooks(:active_record, Base)
end

# Baseの役割
# モジュールの外側にある機能をまとめているクラス。(extend もしくは include)
# run_load_hooks を呼び出す。これはオートロードしたモジュール設定用のコードを呼び出せるようにするもの。
# つまり、Base がインクルードした多くのモジュールが、さらに多くのモジュールをインクルードしている。

# ここでオートローディングの仕組みが役に立つ。ActiveRecord::Baseはモジュールのソースコードをrequire してからモジュールをinclude する必要がない。
# module をinclude するだけで良い。( なぜなら module ActiveRecord extend ActiveSupport::Autoload で autoloadされる。)
#   https://github.com/rails/rails/blob/main/activesupport/lib/active_support/dependencies/autoload.rb