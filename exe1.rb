require_relative "Extension"
require_relative "SimpleLearning"

path = [[1,0,1,0,0],[0,1,0,1,0],[1,0,0,1,1]]
# Step1 初期化(ユーザ入力)#############################
  to = 100000
  from = 90000
  epsilon = 0.1
  # インスタンスで管理
  action = SimpleLearning.new([0,0,1,2],path,epsilon) # idxずれに注意
  benchmark_action = SimpleLearning.new([0,0,1,2],path)
####################################################

# 効用関数の計算 インスタンス変数として保持
action.calc_u()
benchmark_action.calc_u()
# 戦略プロファイル全通り
profile = [path[0],path[1],path[2]].repeated_combination(4).to_a

begin
  f2 = File.open("hist1-2.csv", "w")

  for i in 1..to do
    action.step2(benchmark_action)
    action.step3(benchmark_action)
    if i > from then
      action.log(profile)
    end
  end

  action.hist.each do |obj|
    f2.puts(obj)
  end

  f2.close
rescue => ex
  print ex.message, "\n"
end