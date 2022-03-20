def choose_with_weights(list, weights)
  
    raise ArgumentError, "#{__method__} weights should be non-empty. Got: #{weights.inspect}" unless weights.size > 0
    
    invalid_args = weights.filter {|x| !x.is_a?(Numeric) }
    raise ArgumentError, "#{__method__} weights should be numbers. Got: #{invalid_args.inspect}" unless invalid_args.size == 0
    
    n = weights.size
    avg = weights.sum/n.to_f
    aliases = [[1,nil]]*n
    smalls = []
    bigs = []
    weights.each.with_index do |w,i|
      if w < avg
        smalls.append([i,w/avg])
      end
    end
    weights.each.with_index do |w,i|
      if w >= avg
        bigs.append([i,w/avg])
      end
    end
    
    big = bigs
    small = smalls
    while big != [] and small != []
      
      s = small[0]
      b = big[0]
      aliases[s[0]] = [s[1], b[0]]
      b = [b[0], b[1] - (1-s[1])]
      if b[1] < 1
        s = b
        big = big.drop(1)
        
      else
        small = small.drop(1)
      end
      
    end
    
    r = rand*n
    i = r.to_i
    odds, a = aliases[i]
    idx = ((r-i) > odds) ? a : i
    return list[i]
    
  end