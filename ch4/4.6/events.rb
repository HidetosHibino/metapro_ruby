# # 1.単純な実装
# event '常に発生するイベント' do
#   true
# end

# event '接待に発生しないイベント' do
#   false
# end

# 2.変数を共有する。
def monthly_sales
  110
end

target_sales = 100

event '成功：月間売り上げ' do
  monthly_sales > target_sales # ここでmonthly_sales,target_salesにアクセスできるのがポイント(フラットスコープ)　ブロックはスコープゲートを生じないので
end

event '失敗：月間売り上げ' do
  monthly_sales < target_sales
end
