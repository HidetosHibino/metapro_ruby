# ブロックを評価するためだけにオブジェクトを生成することもある。
# このようなオブジェクトはクリーンルームと呼ばれる。

# クリーンルームはブロックを評価する環境のことで、場合によっては、ブロックで使うメソッドを用意する。

class CleanRoom
  def current_temperture
    # ...
    10
  end
end

clean_room = CleanRoom.new
clean_room.instance_eval do
  if current_temperture < 20
    # TODO: ジャケットを着る
    p "TODO: ジャケットを着る"
  end
end