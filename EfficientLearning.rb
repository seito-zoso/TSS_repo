if !defined?(EFFICIENT_LEARNING_RB)
  EFFICIENT_LEARNING_RB = true

  require_relative "Extension"
  require_relative "Profile"
  require_relative "SimpleLearning"

  class EfficientLearning < SimpleLearning # クラスの継承

    def initialize(num, path, epsilon = 0.1, constant = 5)
      @mood = Array.new(4,true) # true:content、false:discontentに対応
      @constant = constant # step2での指数計算で使用
      @max = Profile.abs_utility_max # 符号は+
      @min = Profile.abs_utility_min # 符号は＋

      super(num,path,epsilon)
    end

    def calc_u() # 効用関数を[０，１]区間に
      super()
      @utility.map! do |obj| # 最大値Profile.utility_max
        obj = obj + @min - 1 # 効用関数が~-1に
        obj = (obj / (@max - @min + 1)).to_f + 1
      end
    end

    def step2(benchmark_action)
      @action.map!.with_index do |obj, idx|
        if @mood[idx] then
          if Random.rand < @epsilon**@constant
            path_idx = obj.get_idx # Array#get_idx
            obj = @path[path_idx - 1 - Random.rand(2)] # bench以外から
          else
            obj = benchmark_action.action[idx]
          end
        else
          obj = @path[Random.rand(3)]
        end
      end
      self.calc_u()
    end

    def step3(benchmark_action)
      for i in 0..3 do
        if @mood[i] && benchmark_action.action[i] == @action[i] \
          && benchmark_action.utility == @utility[i] then
          @mood[i] = true
        elsif Random.rand < @epsilon**(1 - @utility[i])
          @mood[i] = true
        else
          @mood[i] = false
        end
        benchmark_action.action[i] = @action[i]
        benchmark_action.utility[i] = @utility[i]
      end
    end

  end

end