if !defined?(EXTENSION_RB)
  EXTENSION_RB = true

  class Numeric
    def truth?(proposition) # trueの時のみ値を返す
      if proposition
        return self
      else
        return 0
      end
    end
  end

  class Array

    def get_idx(path) # pathと一致するidxを返す
      for i in 0..path.size-1
        if self == path[i]
          return i
        end
      end
    end

    def sort_by_path(path) # pathの順でソート
      self.sort{|a,b| a.get_idx(path) <=> b.get_idx(path)}
    end

    def calc_e_for_ary(action)
      res = []
      i = 0
      while i < action[0].size
        res << action[0][i] + action[1][i] + action[2][i] + action[3][i]
        i = i + 1
      end
      return res
    end

    def calc_u_for_ary(path)
      e = calc_e_for_ary(self)
      utility = [0,0,0,0]
      utility.map!.with_index do |obj, idx|
        obj += -(22 + 3*e[0] + 1*e[2]).truth?(self[idx] == path[0])
        obj += -(22 + 1*e[1] + 3*e[3]).truth?(self[idx] == path[1])
        obj += -(12 + 3*e[0] + 1*e[4] + 3*e[3]).truth?(self[idx] == path[2])
      end
      return utility
    end

  end
  
end