def pattern (*args, &block)
    string = args[0] || ""
    time = args[1] || 0.25
    if string.is_a?(Array)
      string = args[0][0] || ""
      time = args[0][1] || 0.25
    end
    in_thread do
      string.split(//).each do |c|
        block.() if c == "x"
        sleep time if c != "|"
      end
    end
    return string.size*time
  end

  def mark (divisor=1, offset=0, value=0, &block)
    res = (look % divisor) + offset == value
    if block_given?
      if res
        at do
        block.()
        end
      end
    end
    return res
  end
  
  
  def on (divisor=1, offset=0)
    return (look % divisor) + offset
  end

  def quant (str, m=1, n=1)
    idx = (look % m)*n
    str.split(//).filter{|x| x != '|'}.join("")[idx..idx+(n-1)]
  end

  def pspread (num_accents, size)
    spread(num_accents, size).map{|b| b ? "x":"-"}.join("")
  end
    
    def index(m, n, operator="+")
      eval("look % #{m} " + operator + "#{n}")
    end