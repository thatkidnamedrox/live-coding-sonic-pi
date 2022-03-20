def generate_lsystem(*args)
    params, opts = split_params_and_merge_opts_array(args)
    variables = params[0] || opts.fetch(:variables, [])
    constants = params[1] || opts.fetch(:constants, [])
    axiom = params[2] || opts.fetch(:axiom, "")
    rules = params[3] || opts.fetch(:rules, [])
    rules = rules.each_slice(2).map do |k, v|
      {k.to_s => v}
    end
    keys = rules.map{ |x| x.keys }.flatten
    lambda do |num_its|
      variables = variables
      constants = constants
      axiom = axiom.to_s
      rules = rules
      keys = keys
      current = axiom
      res = current
      
      num_its.times do
        res = ""
        current.split(//) do |c|
          if constants.include? c
            res = res + c
          elsif keys.include? c
            rule = rules.select { |x| x.has_key?(c) }[0]
            str = ""
            case rule[c]
            when Integer
              str = rule[c].to_s
            when Proc
              str = rule[c].()
            else
              str = rule[c].to_s
            end
            res = res + str
          end
        end
        current = res
      end
      res
    end
  end