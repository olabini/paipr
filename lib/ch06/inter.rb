
def interactive_interpreter(prompt)
  while true
    print prompt
    puts(yield(gets))
  end
end

def ruby
  interactive_interpreter '> ' do |str|
    eval(str)
  end
end


$:.unshift '../ch05'
require 'eliza2'

def eliza
  interactive_interpreter 'eliza> ' do |str|
    Eliza.eliza_rule(str.downcase.split, 
                     Rule::ELIZA_RULES2)
  end
end

def compose(first, second = nil, &block)
  second ||= block
  lambda do |*args|
    first[second[*args]]
  end
end

class Proc
  def +(other)
    lambda do |*args|
      self[other[*args]]
    end
  end
end

