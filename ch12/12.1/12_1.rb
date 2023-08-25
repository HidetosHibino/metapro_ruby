# タスクが含まれるデータベーステーブルを作ったとする。
# これでActiveRecord::Base を継承した空のTaskクラスを定義できる。
# このクラスのオブジェクトを使えば、データベースとやりとりできる。

require 'active_record'

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'metapro.sqlite3'

ActiveRecord::Base.connection.create_table :tasks do |t|
  t.string :description
  t.boolean :completed
end

class Task < ActiveRecord::Base; end

task = Task.new
task.description = 'ガレージの削除'
task.completed = true
task.save

task.description
task.completed?

# 2つの書き込み用のアクセサ(description= と completed= ) と
# 1つの読み取り用のアクセサ(description)と、1つの問い合わせ用のアクセサ(completed?)だ
# これらは、ミミックメソッドであり、Taskクラスに定義されたものではない。
# このように自動生成されたアクセサのことをアトリビュートメソッドという。

# description= のようなアトリビュートメソッドは、method_missing を使ったゴーストメソッドか、
# define_method を使って定義された動的メソッド のいずれかだと思うかもしれない。

# 実際にはそれより複雑である。
