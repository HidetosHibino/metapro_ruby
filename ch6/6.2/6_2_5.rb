# eval の問題点

# コード文字列はシンタックスハイライトや、自動保管といったエディタの機能が使えない。
# コード文字列は読むのも修正するのも難しいことが多い。
# Ruby は評価するまでコード文字列の構文エラーを報告しない。

# セキュリティの問題もある。

def explore_array(method)
  code = "['a', 'b', 'c'].#{method}"
  puts "Evaluting: #{code}"
  eval code
end

loop {p explore_array(gets.chomp)}

# ruby 6_2_5.rb 
# find_index("b")  
# Evaluting: ['a', 'b', 'c'].find_index("b")
# 1

# map! { |e| e.next }
# Evaluting: ['a', 'b', 'c'].map! { |e| e.next }
# ["b", "c", "d"]

# 以下は危険な呼び出し。(カレントディレクトリが抜かれる)
# object_id; Dir.glob("*")
# Evaluting: ['a', 'b', 'c'].object_id; Dir.glob("*")
# ["6_2.rb", "6_2_1.rb", "6_2_2.rb", "6_2_3.rb", "6_2_4.rb", "6_2_5.rb"]

# 上記のような攻撃を、コードインジェクションと呼ぶ。
# コードインジェクションにおいて、悪質なコードは外部からやってきた文字列に含まれる。
# なので、自分で書いた文字列にのみ eval を使うように制限する。

# eval を使わないようにするには？
# 動的メソッドやディスパッチで代用する。

def explore_array(method, *arguments)
  ['a', 'b', 'c'].send(method, *arguments)
end

# REST Clientではどうする？
# POSSIBLE_VERBS = ['get', 'put', 'post', 'delete']

# POSSIBLE_VERBS.each do |m|
#   eval <<-end_eval
#     def  #{m}(path, *args, &b)
#       r[path].#{m}(*args, &b)
#     end
#   end_eval
# end

POSSIBLE_VERBS.each do |m|
  define_method m do |path, *args, &b|
    r[path].send(m, *args, &b)
  end
end