# 以下の様に既存のメソッドを直したい場合に、
# すでに他プロジェクトのコードで使用されている可能性があり、
# 使用箇所を書き換えるという修正は現実的ではない。

# この場合、クロスマクロを使って古い名前を廃止することによって、メソッドの名前を変更することができる。

class Book
  # def GetTitle
  #   # このメソッドは命名規則に従うと,修正しなければならない。
  # end

  # def title2
  #   # このメソッドは命名規則に従うと,修正しなければならない。
  # end

  # def LEND_TO_USER
  #   # このメソッドは命名規則に従うと,修正しなければならない。
  # end

  def title
    'title'
  end

  def subtitle
    'subtitle'
  end

  def lend_to(user)
    puts "Lending to #{user}"
  end

  def self.deprecate(old_method, new_method)
    define_method(old_method) do |*args, &block|
      warn "Warning: #{old_method}() is deprecated. Use #{new_method}()."
      send(new_method, *args, &block)
    end
  end

  deprecate :GetTitle, :title
  deprecate :LEND_TO_USER, :lend_to
  deprecate :title, :subtitle
end

book = Book.new
book.LEND_TO_USER('Bill')

# deprecate によって、古い名前のメソッドは「警告と、新しいメソッドを呼び出す」メソッドに再定義する
