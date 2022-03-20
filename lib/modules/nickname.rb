NICKNAMES = {
  "calculate_sample_bpm" => "sample_bpm",
  "generate_stepwise" => "stack",
  "generate_divisor" => ["divisor", "octave"],
  "generate_exponents" => "exprange",
  "generate_impulse" => "pulse",
  "generate_range_with_randomization" => "rrange",
  "generate_range_from_size" => "srange",
  "generate_pattern_from_times" => "cpt",
  "generate_times_from_pattern" => ["ctp", "ptimes"],
  "get_onsets" => "onset",
  "extend_live_loop" => ["live_track", "ll"],
  "cycle" => ["live_cycle", "c"],
  "generate_lsystem" => ["lsystem", "lsys"],
  "shift_list" => "shift",
  "normalize_list_range" => "nrange",
  "normalize_list_sum" => "nsum",
  "choose_with_weights" => "wchoose",
  "extend_sample" => ["sound", "playback", "edit", "morph", "resample", "s"],
  "with_cfx" => "cfx"
}


def nickname
  names = NICKNAMES
  names.each do |k, v|
    x = [v].flatten
    x.each do |y|
      t = """
      def #{y} (*args)
        #{k}(*args)
      rescue => e
        message = e.message.split(" ")
        message[0] = __method__
        raise e.class, message.join(" ")
      end"""
      eval(t)
    end
  end
end




