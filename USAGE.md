# Live Coding with Sonic Pi

## Usage

### Generate

```slide``` slides over a list of values and embeds them. ```:repeats``` is the  number of segments. ```:size``` is the length of each segment. ```:step``` is how far to step the start of each segment from previous (can be negative). ```:start``` is what index to start at. ```:wrap```, if true (default), lets indexing wrap around if goes past beginning or end. If false, the pattern stops if it hits a nil element or goes outside the list bounds.

```slide``` is an implmeentation of [```Pslide```](https://doc.sccode.org/Classes/Pslide.html) class from SuperCollider.

```ruby
puts slide [0,1,2,3,4], reps: 3, size: 2, step: 1, wrap: true 
# (ring 0, 1, 1, 2, 2, 3)
```

```pulse``` takes pairs of spacings (number or array of numbers) and sizes (number) and returns an array of zeros and ones indicating impulses or onsets.

```ruby
puts pulse 0, 8
puts pulse 1, 8
puts pulse [1,0], 8
puts pulse 1, 4, 0, 4
puts pulse [1,2], 5, [0,1], 5

##| output:
##|  ├─ (ring 1, 1, 1, 1, 1, 1, 1, 1)
##|  ├─ (ring 1, 0, 1, 0, 1, 0, 1, 0)
##|  ├─ (ring 1, 0, 1, 1, 0, 1, 1, 0)
##|  ├─ (ring 1, 0, 1, 0, 1, 1, 1, 1)
##|  └─ (ring 1, 0, 1, 0, 0, 1, 1, 0, 1, 1)

live_loop :pulse do
  ##| stop
  s = 8
  p = pulse(3,s).rotate([0].choose)
  p2 = pulse(2,s).rotate([0,1].choose)
  s.times do
    tick
    sample :bd_haus if p.look == 1
    sample :sn_dolf, cutoff: 80 if p2.look == 1
    rewind :vinyl_scratch, pitch: -12, rate: -1, beat_stretch: 0.125, amp: 4 if p2.look == 1
    sleep 0.125
  end
end
```

```expand``` takes pairs of values (anything) and counts (number) and stretches a list of values, each value repeated count times. Can supply list of numbers for count.

```ruby
puts expand 0, 2
puts expand 0, [1,2]
puts expand [0,1], 2
puts expand [0,1], [1,2]
puts expand 0, 2, 1, 2, [2,3], 3

##| output:
##| ├─ (ring 0, 0)
##| ├─ (ring 0, 0, 0)
##| ├─ (ring 0, 0, 1, 1)
##| ├─ (ring 0, 1, 0, 0, 1, 1)
##| └─ (ring 0, 0, 1, 1, 2, 2, 2, 3, 3, 3)
```

```octave``` produces divisions of the octave from the given ```:note``` and ```:division```. You can select ```:tones``` or indicies from the list.

```ruby
puts octave
puts octave 60, 12
puts octave note: 60, divisor: 12
puts octave note: 60, divisor: 24
puts octave 60, divisor: 100, tones: 0
puts octave 60, divisor: 100, tones: [0,7]
puts octave 60, divisor: 12, tones: [0,7]

##| output:
##|  ├─ [60, 61.0, 62.0, 63.0, 64.0, 65.0, 66.0, 67.0, 68.0, 69.0, 70.0, 71.0]
##|  ├─ [60, 61.0, 62.0, 63.0, 64.0, 65.0, 66.0, 67.0, 68.0, 69.0, 70.0, 71.0]
##|  ├─ [60, 61.0, 62.0, 63.0, 64.0, 65.0, 66.0, 67.0, 68.0, 69.0, 70.0, 71.0]
##|  ├─ [60, 60.5, 61.0, 61.5, 62.0, 62.5, 63.0, 63.5, 64.0, 64.5, 65.0, 65.5, 66.0, 66.5, 67.0, 67.5, 68.0, 68.5, 69.0, 69.5, 70.0, 70.5, 71.0, 71.5]
##|  ├─ [60]
##|  ├─ [60, 60.83999999999998]
##|  └─ [60, 67.0]
```

```gdegree``` (or ```deg```) takes scale degrees (string, list, integer, or symbol), tonic (symbol or string), and scale name (symbol or string) and returns a list of notes. The degree can be either a decimal number or a roman numeral (if it’s a string or symbol), and may optionally be prefixed an augmentation (a/d for an augmented/diminished interval, aa/dd for double augmented/diminished or p for a perfect (unchanged) interval). 

```ruby
play_pattern_timed gdegree("d13 d12 10 d9 d7 d6 d5 3", :g, :major), 0.25
play_pattern_timed gdegree("1 4 8", :g, :chromatic), 0.25
play_pattern_timed gdegree("I II V dd7 aa13", :g, :major), 0.25
```

```ptimes``` returns a string of tablature notation based on given times (list), finish (number) and step (number).

```ruby
puts ptimes [0,1,3], 4, 1
puts ptimes [0,1,3], 4, 0.5
puts ptimes [0.25,0.75,1.25,2.75,3.5], 4, 0.25

##| output
##|  ├─ "xx-x"
##|  ├─ "x-x---x-"
##|  └─ "-x-x-x-----x--x-"
```

```prand``` returns a string of tablature notion based on given start (number), finish (number), and step (number).

```ruby
puts prand 0, 8, 1
puts prand 0, 8, 1
puts prand 0, 4, 0.5
puts prand 0, 4, 0.5

##| output
##|  ├─ "-xx-x-xx"
##|  ├─ "x--xxxxx"
##|  ├─ "----xxxx"
##|  └─ "-xx---x-"
```

```stack``` returns list of numbers generated from given distance(s) and an initial value. Can enforce wrapping by supplying a limit in relation to the initial value. Often used to generate chords.

```ruby
puts stack 60, 7, 4
puts stack 60, [4,3], 4

##| output
##|  ├─ [60, 67, 74, 81]
##|  └─ [60, 64, 67, 71]
```

### Normalize

```nrange``` returns given list with normalized to given range. Normalized range defaults to [0,1].

```ruby
live_loop :nrange do
  ##| stop
  a = range(0,101)
  b = nrange a
  b.size.times do
    synth :blade, note: 60, amp: b.tick
    sleep 0.0625
  end
end
```

```nsum``` returns given list with normalized sum.

```ruby

puts nsum range(1, 101)
puts nsum range(0,5)
##| output
##| └─ [0.00019801980198019798, 0.00039603960396039596, 0.0005940594059405939, 0.0007920792079207919, 0.00099009900990099, 0.0011881188118811879, 0.0013861386138613859, 0.0015841584158415838, 0.0017821782178217818, 0.00198019801980198, 0.002178217821782178, 0.0023762376237623757, 0.002574257425742574, 0.0027722772277227717, 0.00297029702970297, 0.0031683168316831677, 0.003366336633663366, 0.0035643564356435636, 0.003762376237623762, 0.00396039603960396, 0.004158415841584158, 0.004356435643564356, 0.004554455445544553, 0.0047524752475247515, 0.00495049504950495, 0.005148514851485148, 0.005346534653465345, 0.005544554455445543, 0.005742574257425742, 0.00594059405940594, 0.006138613861386137, 0.006336633663366335, 0.0065346534653465335, 0.006732673267326732, 0.006930693069306929, 0.007128712871287127, 0.0073267326732673254, 0.007524752475247524, 0.007722772277227721, 0.00792079207920792, 0.008118811881188117, 0.008316831683168316, 0.008514851485148514, 0.008712871287128712, 0.00891089108910891, 0.009108910891089108, 0.009306930693069307, 0.009504950495049505, 0.009702970297029703, 0.009900990099009901, 0.0100990099009901, 0.010297029702970296, 0.010495049504950494, 0.010693069306930692, 0.01089108910891089, 0.011089108910891089, 0.011287128712871287, 0.011485148514851485, 0.011683168316831683, 0.01188118811881188, 0.012079207920792078, 0.012277227722772276, 0.012475247524752474, 0.012673267326732674, 0.012871287128712872, 0.01306930693069307, 0.013267326732673267, 0.013465346534653465, 0.013663366336633663, 0.013861386138613862, 0.01405940594059406, 0.014257425742574258, 0.014455445544554456, 0.014653465346534654, 0.01485148514851485, 0.015049504950495049, 0.015247524752475247, 0.015445544554455445, 0.015643564356435644, 0.015841584158415842, 0.01603960396039604, 0.016237623762376238, 0.016435643564356436, 0.016633663366336635, 0.016831683168316833, 0.01702970297029703, 0.01722772277227723, 0.017425742574257424, 0.017623762376237622, 0.01782178217821782, 0.018019801980198015, 0.018217821782178213, 0.01841584158415841, 0.01861386138613861, 0.018811881188118808, 0.019009900990099006, 0.019207920792079204, 0.019405940594059402, 0.0196039603960396, 0.0198019801980198]
##| └─ [0.0, 0.1, 0.2, 0.3, 0.4]

live_loop :nsum do
  s = :bd_haus
  r = range(1,101)
  t = r.max() - 1
  r = nsum r
  t.times do
    sample s
    sleep r.tick
  end
end
```

### Pattern

```pden``` plays sequence based on given density and command.

```ruby
live_loop :pden do
  ##| stop
  tick
  b = lambda {|x| sample :bd_haus, x }
  ##| b = lmbda :bd_haus
  d = [1, 0, 2, 0, 3, 1, 1, 4].look
  pden(b, d, 0.125, {}) if d != 0
  sleep 0.25
end

live_loop :pden2 do
  ##| stop
  s = :drum_cymbal_closed
  7.times do
    sample s
    sleep 0.25
  end
  b = lambda {|x| sample s, x }
  ##| b = lmbda s
  d = pden(b,0.125,{rate: 1})
  sleep 0.25
end
```

```ptab``` returns hash of tablature notation and their corresponding commands and keys.

```ruby
tabs, keys = ptab lambda { |x| sample :bd_haus }
tabs[:x].()

tabs, _ = ptab lmbda :bd_haus
tabs[:r].()

puts keys

##| output
##|  └─ [:x, :d, :q, :t, :h, :b, :r, :p, :s, :g, :-, :" "]
```

```pplay``` plays sequence based on given pattern and commands.

```ruby
pplay :bd_haus, "x---x-x-", 0.25
```

```pgroup``` plays sequence based on given patterns and commands.

```ruby
live_loop :pgroup do
  ##| stop
  foo = lambda {|x| sample :bd_haus, x}
  bar = lambda {|x| sample :sn_dolf, x}
  kt = { k: foo, s: bar }
  pt = { k: "x--x--x-", s: "--x---x-" }
  st = pgroup(kt, pt, 0.125, 8)
  sleep st
end
```

### Sample

```rpitch``` takes the same arguments as ```sample``` plus an array of relative pitches and plays back the sample in a chordlike fashion.

```ruby
rpitch :ambi_drone, amp: 2, rpitch: [0,4,7]
```

```rewind``` takes the same arguments as ```sample``` and will playback the sample forwards then backwards or vice versa.

```ruby
rewind :bd_haus, reverse: true
```

```stutter``` takes the same arguments as ```sample``` and will playback the sample over the given duration using the given number of slices.

```ruby
stutter :loop_amen, duration: 4, num_slices: 128, beat_stretch: 2
```

### FX

In addition to ```with_fx```, you now have ```with_cfx``` and ```fx``` to handle FX.

```with_cfx``` applies given effects (FX) to everything within a given `do`/`end` block. Effects may take extra parameters to modify their behavior. See FX help for parameter details.

For advanced control, it is also possible to modify the parameters of an effect within the body of the block. If you define the block with a single argument, the argument becomes a list of references to the current effect and can be used to control each of their parameters respectively. See `with_fx`.

```fx``` is shorthand for FX and uses ```with_fx``` or ```with_cfx``` depending on the given arguments.

```ruby
fx :distortion, distort: 0.9 do
  fx :slicer, phase: 0.125 do
    play 60
  end
end

chain = [
  [:distortion, distort: 0.9],
  [:slicer, phase: 0.125],
]

fx chain do
  play 60
end
```

Here are some examples within a musical context.

```ruby
live_loop :with_cfx_pick do
  stop
  chain = [
    [:reverb],
    [:distortion],
    [:octaver],
  ]
  fx (chain.pick(2)) { play 60 }
  sleep 0.125
end

live_loop :with_cfx_control do
  stop
  chain = [
    [:reverb],
    [:distortion, distort: 0],
    [:octaver],
    [:panslicer, phase: 0.5]
  ]
  fx (chain) { |nodes|
    control nodes[3], phase: 0.125, phase_slide: 0.5
    control nodes[1], distort: 0.9, distort_slide: 1
    play 60, sustain: 0.75
  }
  sleep 1
end
```

### Collections

```CHAINS``` is a hash object where keys are descriptive names and values are an array of FXs formatted as arrays where the first item contains the FX name followed by optional aditional arguments. 

```ruby
CHAINS = {
    slicers: [
      [:slicer, phase: 0.75, prob_pos: 0.5, smooth: 0.25, mix: 0.75],
      [:slicer, phase: 0.25, smooth: 0.25],
      [:rhpf, cutoff: 70, res: 0.95],
      [:gverb, room: 100]
    ],
    # ...
}
```

You can select chains using filters (strings, symbols, regexp, or functions) from this hash object using ```all_chains```.

```
all_chains 0
all_chains :marvin
all_chains "f_", 8
all_chains pick
```

In practice, you can define an FX chain as an array of arrays representing FX names and additional arguments.

```ruby
chain = [
  [:slicer, phase: 0.75, mix: 0.75],
  [:slicer, phase: 0.25, smooth: 0.25],
  [:rhpf, cutoff: 70, res: 0.95],
]

fx chain do
  sample :ambi_drone
end
```

```PACKS``` is a hash object where keys are descriptive names and values are hash objects where keys designate instrument and values represent the corresponding sound. 

```ruby
PACKS = {
  dnb_1: {
    k:  lmbda { sample :bd_haus; sample :bd_boom },
    s: :sn_generic,
    sl: :drum_snare_soft,
    hh: :drum_cymbal_closed,
    hhd: :drum_cymbal_pedal,
    c: :drum_splash_hard,
    t: :drum_cymbal_pedal,
  },
  # ...
}
```

```PATTERNS``` is a hash object where keys are descriptive names and values are hash objects where keys designate instrument and values represent the corresponding pattern.

```ruby
PATTERNS = {
  think_break: {
    k:  "x-------|--------|x-------|--------",
    sl: "----x--x -x------|----x--x -x------",
    sm: "--------|--x-----|--------|--x-----",
    sh: "--------|----x---|--------|----x---",
    s: "----x---|----x---|----x---|----x---",
    sk: "x-x-x-x-|x-x-x-x-|x-x-x-x-|x-x-x-x-",
    v:  "x-------|--------|x-------|------x-",
  },
  # ...
}
```

```PACKS``` and ```PATTERNS``` go hand-in-hand. They represent an attempt at gathering sounds and patterns into a reusable repository. 

In practice, you can define a pack and a pattern using a hash object.

```ruby

pack = {
  k: :bd_haus,
  s: :sn_dolf,
  sl: :drum_snare_soft,
  hh: :drum_cymbal_closed,
  hhd: :drum_cymbal_pedal,
  c: :drum_splash_hard,
  t: :drum_cymbal_pedal,
}

pattern = {
  k:  "x-------|--------|x-------|--------",
  sl: "----x--x -x------|----x--x -x------",
  sm: "--------|--x-----|--------|--x-----",
  sh: "--------|----x---|--------|----x---",
  s: "----x---|----x---|----x---|----x---",
  sk: "x-x-x-x-|x-x-x-x-|x-x-x-x-|x-x-x-x-",
  v:  "x-------|--------|x-------|------x-",
}
```

Similiar to chains, you can select packs and patterns using filters (strings, symbols, regexp, or functions) from this hash object using ```all_packs``` and ```all_patterns``` respectively.

### General

```lmbda``` returns a lambda expression containing given block. Can supply name or path of sample with optional arguments.

```mute``` and ```unmute``` set the mixer volume to 0.0 and 1.0 respectively.

```sample_bpm``` takes the same arguments as ```sample``` plus additional arguments and returns the calculated bpm of the sample and corresponding number of beats unaffected by scaling. ```:num_beats``` denotes how many beats the sample duration would last. ```:min``` and ```:max``` denote the minimum and maximum possible bpm for the sample and adjusts the number of beats accordingly.

```ruby
puts sample_bpm :loop_amen
puts sample_bpm :loop_amen, num_beats: 3
puts sample_bpm :loop_amen, min: 60
puts sample_bpm :loop_amen, min: 60, max: 160, num_beats: 8

##| output:
##|  ├─ [34.22097489685855, 1]
##|  ├─ [102.66292469057565, 3]
##|  ├─ [68.4419497937171, 2]
##|  └─ [136.8838995874342, 4]

```

```convert_to_tablature_string``` or ```to_t``` can convert an integer, array, or string into tablature notation represented as a string.

```convert_to_binary_array``` or ```to_b``` can convert an integer or hexadecimal string into an array of zeros and ones.

```wchoose``` chooses an element with weighted randomness from a list (array). Always return a single element (or nil). This is an implementation of the weighted random algorithm called the ["alias method"](https://blog.bruce-hill.com/a-faster-weighted-random-choice) originally discovered by A.J. Walker in 1974.

```osc_receive``` receives an incomming OSC message that can be filtered by tag. 

```generate_lsystem``` or ```lsys``` initializes a L-system or Lindenmayer system with given variables, constants, an axiom, and rules. Returns lambda expression that takes number of iterations and produces string corresponding to the given number of iterations.

The is an implementation of a [deterministic, context-free L-system (D0L system)](https://en.wikipedia.org/wiki/L-system).

Here is an example using Lindenmayer's original L-system for modelling the growth of algae.

```ruby
L = lsys(
  variables: ["A","B"],
  constants: [],
  axiom: "A",
  rules: ["A","AB","B","A"]
)

7.times do |n|
  puts "n = #{n}, #{L.(n)}"
end

##| output:
##|  ├─ "n = 0, A"
##|  ├─ "n = 1, AB"
##|  ├─ "n = 2, ABA"
##|  ├─ "n = 3, ABAAB"
##|  ├─ "n = 4, ABAABABA"
##|  ├─ "n = 5, ABAABABAABAAB"
##|  └─ "n = 6, ABAABABAABAABABAABABA"
```
