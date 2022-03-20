def extend_live_loop(name, *args, &block)
    args_h = resolve_synth_opts_hash_or_array(args)
    live_loop name, args_h do
      lpf = args_h.fetch(:lpf, nil)
      bpm = args_h.fetch(:bpm, current_bpm)
      amp = args_h.fetch(:amp, 1)
      use_bpm bpm
      if lpf
        res = args_h.fetch(:res, 0.5)
        with_fx :rlpf, cutoff: lpf, res: res, amp: amp do
          block.()
        end
      else
        with_fx :level, amp: amp do
          block.()
        end
      end
    end
  end
  
  def cycle(name, *args, &block)
    params, opts = split_params_and_merge_opts_array(args)
    if name == :clock
      extend_live_loop name, opts do
        block.() if block_given?
        sleep 1
      end
      return
    end
    
    extend_live_loop name, opts, bpm_sync: :clock do
      sync :clock
      stop if args.include?(:stop)
      
      in_thread() do
        tick_set (beat-1)
        block.() if block_given?
      end
      
    end
  end