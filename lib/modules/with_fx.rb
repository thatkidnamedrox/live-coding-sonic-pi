def with_cfx(args, *nodes, &block)
    chain = args.dup
    if chain.length > 0
      fx_args = chain.shift
      params, opts = split_params_and_merge_opts_array(fx_args)
      fx_name = params[0]
      proceed = fx_names.to_a.include?(fx_name)
      ##| proceed = fx_name
      ##| puts proceed
      if proceed
        # only if valid fx name, could extend to external fx
        with_fx fx_name, opts do |s|
          with_cfx(chain,nodes.push(s),&block)
        end
      else
        # in the event we encounter empty params
        # debatble whether or not to leave this in?
        ##| with_cfx(chain,nodes,&block)
      end
    else
      block.(nodes.flatten)
    end
  end
  
  def fx(*args, &block)
    if is_list_like?(args[0])
      with_cfx(args[0], &block)
    else
      params, opts = split_params_and_merge_opts_array(args)
      with_fx(params[0], opts, &block)
    end
  end
