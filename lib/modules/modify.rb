def shift_list (list, num=0, bound=4)
    nlist = list.dup.to_a
    nlist.map! { |x|
      (x + num) % (bound)
    }.sort!
    return nlist
  end

  def normalize_list_range(*args)
    params, opts = split_params_and_merge_opts_array(args)
    
    min = opts.fetch(:min, 0)
    max = opts.fetch(:max, 1)
    list = params.flatten
    
    raise ArgumentError, "#{__method__} min should be a number. Got #{min.inspect}" unless min.is_a?(Numeric)
    raise ArgumentError, "#{__method__} max should be a number. Got #{max.inspect}" unless max.is_a?(Numeric)
    
    
    old_min = list.min().to_f
    old_max = list.max().to_f
    res = list.map {|x| (x-old_min)/(old_max-old_min)*(max-min)+min }
    (res||[]).ring
  end
  
  def normalize_list_sum(*args)
    params, opts = split_params_and_merge_opts_array(args)
    mode = params[1] || opts.fetch(:mode, 0)
    min = params[2] || opts.fetch(:min, 0.01)
    list = params[0].to_a
    
    raise ArgumentError, "#{__method__} mode should be a number. Got #{mode.inspect}" unless mode.is_a?(Numeric)
    raise ArgumentError, "#{__method__} min should be a number. Got #{min.inspect}" unless min.is_a?(Numeric)
    
    res = list.map{ |x| x/list.sum.to_f }
    if mode == 0
      res
    elsif mode == 1
      res.map {|x| x < min ? x = min : x }
    elsif mode == 2
      res.select {|x| x > min }
    else
      list
    end
  end