class Roulette
  def method_missing(name, *args)
    person = name.to_s.capitalize
    3.times do
      number = rand(10) + 1
      puts "#{number}..."
    end

    "#{person} got a #{number}"
  end
end

# number_of = Roulette.new
# puts number_of.bob
# puts number_of.frank

# 上記は無限ループになる
# 大元の原因は 「 "#{person} got a #{number}" 」における number のスコープがおかしいこと
# スコープが外れているため、selfに対するnumberメソッドだと解釈するが、numberメソッドは存在しない。
# そのため、method_mising(name=number)で呼ばれてしまう

# 必要もないのにゴーストメソッドを導入しないようにする。
# 以下のようにして、受け取れる名前を制限する

class Roulette
  def method_missing(name, *args)
    person = name.to_s.capitalize
    super unless %w[Bob Frank Bill].include? person
    number = 0
    3.times do
      number = rand(10) + 1
      puts "#{number}..."
    end

    "#{person} got a #{number}"
  end
end

number_of = Roulette.new
puts number_of.bob
puts number_of.frank

# 上記では、「super unless %w[Bob Frank Bill].include? person」で、personが「Bob Frank Bill」のいずれでもない場合、
# superのmethod_missingを呼び出している。
# number = 0 を込めとアウトすると、undefined local variable or method `number' for #<Roulette:0x000000010109e848> (NameError)　となる