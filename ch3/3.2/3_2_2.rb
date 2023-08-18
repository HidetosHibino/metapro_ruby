require "pry"
# gem install pry

pry = Pry.new
pry.memory_size = 101
p pry.memory_size
p pry.quiet?

pry.refresh(:memory_size => 99, :quite => false)
p pry.memory_size
p pry.quiet?


# pry refrechの実装
# respond_to? は その名前のメソッドを持つとtrue

def refresh(options={})
  defaults   = {}
  attributes = [
                 :input, :output, :commands, :print, :quiet,
                 :exception_handler, :hooks, :custom_completions,
                 :prompt, :memory_size, :extra_sticky_locals
               ]

  attributes.each do |attribute|
    defaults[attribute] = Pry.send attribute
  end

  defaults[:input_stack] = Pry.input_stack.dup

  defaults.merge!(options).each do |key, value|
    send("#{key}=", value) if respond_to?("#{key}=")
  end

  true
end
