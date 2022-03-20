def get_onsets (*args)
    params, opts = split_params_and_merge_opts_array(args)
    res = []
    l = lambda {|c| res = c ; c[0]}
    s = params
    sample s, opts, onset: l, amp: 0
    
    times = []
    time = 0
    res.each do |n|
      n = n[:index]
      dur = sample_duration s, onset: n
      times.push(time)
      time += dur
    end
  
    return res, times
  end