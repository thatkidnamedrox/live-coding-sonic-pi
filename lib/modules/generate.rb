def generate_stepwise(start=0, steps=0, length=0, **opts)
  
    wrap = opts.fetch(:wrap, nil)
    ##| clip = opts.fetch(:clip, nil)
    
    res = []
    steps = [steps].flatten.ring
    
    n = start
    length.times do |idx|
      if wrap && (n >= (start+wrap))
        res.push(n % wrap + start)
      else
        res.push(n)
      end
      n += steps[idx]
    end
    
    res
  end

  def generate_divisor (start=0, divisor=0)
    res = []
    n = start.to_f
    divisor.times do |i|
      res.push(n)
      n += 12.0/divisor
    end
    res
  end

  def generate_exponents(start, finish, step, base)
    exp = range(start, finish, step)
    res = exp.map{ |x| base**x }
  end

  def generate_impulse (*args, **opts)
    res = args.each_slice(2).flat_map do |values, num_its|
      n, i, v, = [false]*num_its, 0, 0
      
      if !is_list_like?(values)
        values = [values]
      end
      while i < num_its
        p = values.ring[v]
        n[i] = true
        i += p + 1
        v += 1
      end
      n
    end
    rotate = opts.fetch(:rotate, 0)
    res.ring.rotate(rotate)
  end

  def generate_range_with_randomization (*args)
    params, opts = split_params_and_merge_opts_array(args)
    
    start = params[0] || opts.fetch(:start, 0)
    finish = params[1] || opts.fetch(:finish, 4)
    size = params[2] || opts.fetch(:size, finish)
    step = opts.fetch(:step, nil)
    pattern = opts.fetch(:pattern, false)
    
    seed = opts.fetch(:seed, nil)
    
    raise ArgumentError, "#{__method__} finish should be a number. Got #{finish.inspect}" unless finish.is_a?(Numeric)
    raise ArgumentError, "#{__method__} step should be a number. Got #{step.inspect}" unless !step || step.is_a?(Numeric)
    raise ArgumentError, "#{__method__} start should be a number. Got #{start.inspect}" unless start.is_a?(Numeric)
    raise ArgumentError, "#{__method__} seed should be a number. Got #{seed.inspect}" unless !seed || seed.is_a?(Numeric)
    raise ArgumentError, "#{__method__} size should be a number. Got #{size.inspect}" unless size.is_a?(Numeric)
    
    use_random_seed seed if seed
    res = []
    size.times do
      n = rrand(start,finish)
      n = quantise(n, step) if step
      res.push(n)
    end
    
    res
  end
  
  def generate_range_from_size(*args)
    params, opts = split_params_and_merge_opts_array(args)
    
    start = params[0] || opts.fetch(:start, 0)
    finish = params[1] || opts.fetch(:finish, 4)
    size = params[2] || opts.fetch(:size, 0)
    
    raise ArgumentError, "#{__method__} finish should be a number. Got #{finish.inspect}" unless finish.is_a?(Numeric)
    raise ArgumentError, "#{__method__} start should be a number. Got #{start.inspect}" unless start.is_a?(Numeric)
    raise ArgumentError, "#{__method__} size should be a number. Got #{size.inspect}" unless size.is_a?(Numeric)
    
    
    res = []
    val = start
    size.times do
      res.push(val)
      val += (finish-start)/size.to_f
    end
    
    (res||[]).ring
  end
  
  def generate_pattern_from_times(*args)
    params, opts = split_params_and_merge_opts_array(args)
    
    times = params[0] || opts.fetch(:times, [])
    finish = params[1] || opts.fetch(:finish, 4)
    step = params[2] || opts.fetch(:step, 0.25)
    start = opts.fetch(:start, 0)
    
    raise ArgumentError, "#{__method__} finish should be a number. Got #{finish.inspect}" unless finish.is_a?(Numeric)
    raise ArgumentError, "#{__method__} step should be a number. Got #{step.inspect}" unless step.is_a?(Numeric)
    raise ArgumentError, "#{__method__} times should be a list. Got #{times.inspect}" unless times.is_a?(Array)
    raise ArgumentError, "#{__method__} start should be a number. Got #{start.inspect}" unless start.is_a?(Numeric)
    
    return [] if times.empty?
    
    res = ""
    range(start, finish, step).each do |n|
      if times.include?(n)
        res += "x"
      else
        res += "-"
      end
    end
    
    res
  end
  
  def generate_times_from_pattern(*args)
    params, opts = split_params_and_merge_opts_array(args)
    
    pattern = params[0] || opts.fetch(:pattern,"")
    finish = params[1] || opts.fetch(:finish, 4)
    step = params[2] || opts.fetch(:step, 0.25)
    start = opts.fetch(:start, 0)
    
    raise ArgumentError, "#{__method__} pattern shouble be a string. Got #{pattern.inspect}" unless pattern.is_a?(String)
    raise ArgumentError, "#{__method__} finish should be a number. Got #{finish.inspect}" unless finish.is_a?(Numeric)
    raise ArgumentError, "#{__method__} step should be a number. Got #{step.inspect}" unless step.is_a?(Numeric)
    raise ArgumentError, "#{__method__} start should be a number. Got #{start.inspect}" unless start.is_a?(Numeric)
    
    return "" if pattern.size == 0
    
    res = []
    
    time = start
    pattern.split(//).each do |c|
      res.push(time) if c == "x"
      time += step
      break if time >= finish
    end
    
    res
    
  end