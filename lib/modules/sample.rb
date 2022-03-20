def extend_sample (*args)
    params, opts = split_params_and_merge_opts_array(args)
    
    # gate determines how long sound
    # is allowed to pass through
    gate = opts.fetch(:gate, nil)
    num_slices = opts.fetch(:num_slices, 16)
    
    duration = opts.fetch(:duration, nil)
    stutter = opts.fetch(:stutter, true)
    
    # make these arrays by default
    rate = [opts.fetch(:rate, 1)].flatten
    rpitch = [opts.fetch(:rpitch, 0)].flatten
    
    # base the duration off of
    # lowest pitched sample
    opts[:rpitch] = rpitch.min
    opts[:rate] = rate.min
    
    base_duration = sample_duration params, opts
    callback = lambda { |args| sample params, args }
    
    # hard clip the sound
    clip = opts.fetch(:clip, nil)
    stop_playing = false
    at clip do stop_playing = true end if clip
    
    # delay relative pitch stack and/or grains?
    ##| delay = opts.fetch(:delay, nil)
    
    
    # limit the length of the sound
    if gate
      finish = gate/base_duration
      # must be value between 0 and 1
      if finish > 1
        finish = 1
      elsif finish < 0
        finish = 0
      end
      opts[:finish] = finish
    end
    
    if duration
      c = callback
      slice = opts.fetch(:slice, nil)
      callback = lambda {|args|
        num_slices.times do |idx|
          break if stop_playing
          args[:slice] = idx if !slice
          args[:start] = idx/num_slices.to_f
          args[:finish] = args[:start] + 1/num_slices.to_f
          args[:rate] = rate.ring[idx]
          ##| args[:rpitch] = rpitch.ring[idx]
          c.(args)
          if stutter
            sleep duration/num_slices.to_f
          else
            d = sample_duration params, args
            sleep d
          end
        end
      }
      
    elsif rate.size > 1
      # stack different rates
      a = callback
      callback = lambda {|args|
        rate.each do |r|
          args[:rate] = r
          a.(args)
        end
      }
    end
    
    
    # stack relative pitched samples
    if rpitch.size > 1
      b = callback
      callback = lambda { |args|
        rpitch.each do |p|
          args[:rpitch] = p
          b.(args)
        end
      }
    end
    
    in_thread do
      callback.(opts)
    end
  end
  