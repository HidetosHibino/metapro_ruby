user_input = "User input: #{ARGV[0]}"
puts user_input.tainted?

# tainted 系は機能していないらしい https://imaizumimr.hatenablog.com/entry/2020/12/05/000000
# https://imaizumimr.hatenablog.com/entry/2020/12/05/000000