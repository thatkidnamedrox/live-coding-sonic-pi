

  def glide(*args, **opts)
    at do
      duration = [opts.fetch(:duration, 0)].flatten
      note = opts.fetch(:note, nil)
      slide = opts.fetch(:slide, note)
      note_slide = [opts.fetch(:note_slide, nil)].flatten
      
      slide = [slide] if !is_list_like?(slide)
      
      opts[:note_slide] = note_slide[0]
      if args[0].is_a?(Numeric)
        note = args[0]
      elsif args[0]
        use_synth args[0]
        use_synth_defaults
      end
      
      s = play opts.except(:duration, :slide)
      slide.each_with_index do |n, i|
        
        sleep duration.ring[i]
        if note_slide.ring[i]
          control s, note: n, note_slide: note_slide.ring[i]
        else
          control s, note: n, note_slide: 0
        end
      end
    end
    
  end