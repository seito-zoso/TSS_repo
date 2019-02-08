if !defined?(UNREASONABLE_LEARNING_RB)
  UNREASONABLE_LEARNING_RB = true

  require_relative "Extension"
  require_relative "Profile"
  require_relative "SimpleLearning"

  class UnreasonableLearning < SimpleLearning # クラスの継承

    def initialize(num, path, epsilon = 0.1)
      @max = Profile.abs_utility_max # 符号は+
      @min = Profile.abs_utility_min # 符号は＋

      super
    end

    def calc_u() # すべての効用関数の差を1/2以下に
      super()
      @utility.map! do |obj|
        obj = (obj / ( @max - @min + 1 )).to_f
        obj = (obj/2).to_f
      end
    end

    def step3(benchmark_action)
        for i in 0..3 do
        if @action[i] == benchmark_action.action[i]
          benchmark_action.utility[i] = @utility[i]
        elsif benchmark_action.utility[i] >= @utility[i]
          if Random.rand < @epsilon**(benchmark_action.utility[i] - @utility[i])
            benchmark_action.action[i] = @action[i]
            benchmark_action.utility[i] = @utility[i]
          else # 何もしない
          end
        else
          benchmark_action.action[i] = @action[i]
          benchmark_action.utility[i] = @utility[i]
        end
      end
    end

  end

end