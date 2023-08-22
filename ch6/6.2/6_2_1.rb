module RestClient
  class Resource
    def get(additional_headers={}, &block)
      headers = (options[:headers] || {}).merge(additional_headers)
      Request.execute(options.merge(
              :method => :get,
              :url => url,
              :headers => headers,
              :log => log), &(block || @block))
    end

    def post(payload, additional_headers={}, &block)
      headers = (options[:headers] || {}).merge(additional_headers)
      Request.execute(options.merge(
              :method => :post,
              :url => url,
              :payload => payload,
              :headers => headers,
              :log => log), &(block || @block))
    end

    def put(payload, additional_headers={}, &block)
      headers = (options[:headers] || {}).merge(additional_headers)
      Request.execute(options.merge(
              :method => :put,
              :url => url,
              :payload => payload,
              :headers => headers,
              :log => log), &(block || @block))
    end

    def delete(additional_headers={}, &block)
      headers = (options[:headers] || {}).merge(additional_headers)
      Request.execute(options.merge(
              :method => :delete,
              :url => url,
              :headers => headers,
              :log => log), &(block || @block))
    end 
  end
end

# get などをインタプリタで使用できるように、REST Clientは4つのトップレベルのメソッドを定義している。
# そして、これらのメソッドから特定のURLのResourceのメソッドに移譲される。
# トップレベルからのget から、Resource(rメソッドの戻り値)に移譲される様子。

def get(path, *args, &b)
  r[path].get(*args, &b)
end

# これはソースコードの中で、そのまま定義されているのではない。
# コード文字列を作成することで、ループの中で一気に全てを作成している。

POSSIBLE_VERBS = ['get', 'put', 'post', 'delete']

POSSIBLE_VERBS.each do |m|
  eval <<-end_eval
    def  #{m}(path, *args, &b)
      r[path].#{m}(*args, &b)
    end
  end_eval
end

# https://github.com/rest-client/rest-client/blob/d96be9d1dc8b1b4c04d90a62244b87ded8d86f0c/bin/restclient

# 上記のコードはヒアドキュメントと呼ばれる構文を使っている。
# eval の後に続いているのは、通常のRubyの文字列である.
# クォートの代わりに <<- と任意の終端子(ここでは end_eval)で文字列が開始する。
# そして、終端子のみが含まれる行で文字列が終了する。
# つまり def から end までが文字列の範囲となる。

# このコードがこうした文字列の代わりになるものを使い、4つのコード文字列を生成してevalした結果、
# それぞれがget put post delete となる。
