module Printable
  def print
    p 'print in Printable'
  end

  def prepare_cover
    p 'prepare_cover in Printable'
  end
end

module Document
  def print_to_screen
    prepare_cover
    format_for_screen
    print
  end

  def format_for_screen
    p 'format_for_screen in Document'
  end

  def print
    p 'print in Document'
  end
end

class Book
  include Document
  include Printable
end

book = Book.new
book.print_to_screen

# print_to_screen の実行結果は以下のようになる
# "prepare_cover in Printable"
# "format_for_screen in Document"
# "print in Printable"

# printの結果がなぜ Printable のものなのか考える。
# メソッドを実行する際は、メソッドが見つかるまで継承チェーンを辿っていく。
# この時の順番は Class.ancestors で確認できる。
# Book.ancestors の結果は以下の通り
# [Book, Printable, Document, Object, Kernel, BasicObject]
# このとき、printはPrintableで最初に見つかる。
# なのでPrintable#printが実行される