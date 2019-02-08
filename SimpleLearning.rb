 if !defined?(SIMPLE_LEARNING_RB)
  SIMPLE_LEARNING_RB = true

  require_relative "Extension"

  class SimpleLearning

    attr_accessor :action,:utility,:hist,:data
    def initialize(num, path, epsilon = 0.1)
      @action = [path[num[0]],path[num[1]],path[num[2]],path[num[3]]]
      @path = path
      @epsilon = epsilon
      @utility = Array.new(4,0)
      @hist = Array.new(15,0)
    end

    def calc_e() # 各道を通過する台数を計算
      res = []
      i = 0
      while i < @action[0].size
        res << @action[0][i] + @action[1][i] + @action[2][i] + @action[3][i]
        i = i + 1
      end
      return res
    end

    def calc_u() # 効用関数
      e = self.calc_e
      @utility = [0,0,0,0]
      @utility.map!.with_index do |obj, idx|
        obj += -(22 + 3*e[0] + 1*e[2]).truth?(@action[idx] == @path[0])
        obj += -(22 + 1*e[1] + 3*e[3]).truth?(@action[idx] == @path[1])
        obj += -(12 + 3*e[0] + 1*e[4] + 3*e[3]).truth?(@action[idx] == @path[2])
      end
    end

    def step2(benchmark_action)
      @action.map!.with_index do |obj, idx|
        if Random.rand < @epsilon
          obj = @path[Random.rand(3)]
        else
          obj = benchmark_action.action[idx]
        end
      end
      self.calc_u()
    end

    def step3(benchmark_action) # benchmark_actionは引数にして値の更新
      for i in 0..3 do
        if @action[i] == benchmark_action.action[i]
          benchmark_action.utility[i] = @utility[i]
        elsif benchmark_action.utility[i] >= @utility[i] # 何もしない
        else
          benchmark_action.action[i] = @action[i]
          benchmark_action.utility[i] = @utility[i]
        end
      end
    end

    def log(profile)
      profile.each_with_index do |obj,idx|
        if @action.sort_by_path(@path) == obj # Array#sort_by_path
          @hist[idx] += 1
        end
      end
    end

  end

end

    # def nash? # インスタンス変数actionがnash均衡かどうかを調べboolで返す
    #   flag = true
    #   self.calc_u
    #   for idx in 0..@action.size-1
    #     path_idx = @action[idx].get_idx(@path) # Array#get_idx
    #     @action[idx] = @path[path_idx-1]
    #     if @action.calc_u_for_ary(@path)[idx] > @utility[idx]
    #       flag = false
    #       @action[idx] = @path[path_idx]
    #       break
    #     end
    #     @action[idx] = @path[path_idx-2]
    #     if @action.calc_u_for_ary(@path)[idx] > @utility[idx]
    #       flag = false
    #       @action[idx] = @path[path_idx]
    #       break
    #     end
    #     @action[idx] = @path[path_idx]
    #   end
    #   return flag
    # end