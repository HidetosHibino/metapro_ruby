# hashieの実装を見る

# https://github.com/hashie/hashie/blob/master/lib/hashie/mash.rb

def method_missing(method_name, *args, &blk) # rubocop:disable Style/MethodMissing
  return self.[](method_name, &blk) if key?(method_name)
  name, suffix = method_name_and_suffix(method_name)
  case suffix
  when '='.freeze
    assign_property(name, args.first)
  when '?'.freeze
    !!self[name]
  when '!'.freeze
    initializing_reader(name)
  when '_'.freeze
    underbang_reader(name)
  else
    self[method_name]
  end
end

# return self.[](method_name, &blk) if key?(method_name)
# ->対応する値があれば取り出す。

# メモ !!self[name] はtrue/false を返したいが、self[name]のままだと 値/nilを返すから
# ！を使って真偽値の反転化、さらにそれの反転を返してるっぽい
