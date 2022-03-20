

def calculate_sample_bpm(*args)
    sample_name, args_h = split_params_and_merge_opts_array(args)
    num_beats = args_h[:num_beats] || 1
    min = args_h[:min] || 0
    max = args_h[:max] || 300
    
    raise ArgumentError, "#{__method__} num_beats should be a number. Got #{num_beats.inspect}" unless num_beats.is_a?(Numeric)
    raise ArgumentError, "#{__method__} min should be a number. Got #{min.inspect}" unless min.is_a?(Numeric)
    raise ArgumentError, "#{__method__} max should be a number. Got #{max.inspect}" unless max.is_a?(Numeric)
    
    scaling = __thread_locals.get(:sonic_pi_spider_arg_bpm_scaling)
    __thread_locals.set(:sonic_pi_spider_arg_bpm_scaling, false)
    sd = sample_duration(sample_name, args_h)
    __thread_locals.set(:sonic_pi_spider_arg_bpm_scaling, scaling)
    
    res = num_beats * (60.0 / sd)
    while res < min
      num_beats *= 2
      res = num_beats * (60.0 / sd)
    end
    while res > max && res > 0
      num_beats /= 2
      res = num_beats * (60.0 / sd)
    end
    
    [res, num_beats]
  end

 
  
 