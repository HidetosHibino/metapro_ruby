# https://github.com/rails/rails/blob/b738f1930f3c82f51741ef7241c1fee691d7deb2/activesupport/lib/active_support/dependencies.rb

# クラスがloadable を include したときに、Kernel#load よりも Loadable#load が継承チェーンの下にあれば、load の呼び出しは、Loadable#loadになる。
# Loadable を include したあとにLoadable の loadを削除したい場合のために、以下のコードがある。
# 言い換えれば、Lodable#load の使用を中断して、Kernel#load に戻りたい場合だ。

# ※Rubyには uninclude はないため、インクルードした Loadable を削除することはできない。

module Loadable #:nodoc:
  def self.exclude_from(base)
    base.class_eval do
      define_method(:load, Kernel.instance_method(:load))
      private :load

      define_method(:require, Kernel.instance_method(:require))
      private :require
    end
  end

  # ~~~
end

# 上記のコードを以下のように使う。
# Loadable をinclude した MyClass について考えるとき、

Loadable.exclude_from(MyClass)

# 上記を実行すると、元のloadメソッド：”Kernel.instance_method(:load)” が UnbaindMethod として取得される。
# そして、MyClassに対して、その新しいloadメソッドを定義する。 (MyClassに対してであることに注意)
# MyClassについて定義したため、MyClassは以下の3つのloadメソッドを持っていることになる。
# MyClass#load, Loadable#load, Kernal#load
# このうち、MyClass#load　と Kernal#load は似たものになる。
# Loadable#load　と Kernal#load　は全く呼び出されない。
