if !defined?(PROFILE_RB)
  PROFILE_RB = true

  require_relative "Extension"

  class Profile
    @@path = [[1,0,1,0,0],[0,1,0,1,0],[1,0,0,1,1]]

    def self.nash_equilibrium # インスタンス変数actionがnash均衡かどうかを調べboolで返す
      profile = [@@path[0],@@path[1],@@path[2]].repeated_combination(4).to_a
      res = []

      profile.each_with_index do |obj,idx| # profile一つ一つ確認
        utility = profile[idx].calc_u_for_ary(@@path)
        flag = true

        profile[idx].map.with_index do |obj_bar,idx_bar|
          path_idx = obj_bar.get_idx(@@path) # Array#get_idx
          for j in 1..2
            profile[idx][idx_bar] = @@path[path_idx-j] # 戦略を変える
            if profile[idx].calc_u_for_ary(@@path)[idx_bar] > utility[idx_bar]
              flag = false # ナッシュ均衡でない
            end
          end
          if !flag then
            break # このactionはナッシュ均衡でない
          end
        end

        if flag then
          res.push(profile[idx]) # ナッシュ均衡
        end
      end

      return res
    end

    def self.abs_utility_max
      profile = [@@path[0],@@path[1],@@path[2]].repeated_combination(4).to_a
      max = 0
      profile.each_with_index do |obj,idx|
        max = obj.calc_u_for_ary(@@path).push(max).min
      end
      return - max
    end

    def self.abs_utility_min
      profile = [@@path[0],@@path[1],@@path[2]].repeated_combination(4).to_a
      min = -1000
      profile.each_with_index do |obj,idx|
        min = obj.calc_u_for_ary(@@path).push(min).max
      end
      return - min
    end

  end

end
