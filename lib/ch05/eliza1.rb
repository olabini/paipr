require 'pat5'

module Enumerable
  def some?
    self.each do |v|
      result = yield v
      return result if result
    end
    nil
  end
end

class Array
  def random_elt
    self[rand(self.length)]
  end
end

class Rule
  attr_reader :pattern, :responses

  def initialize(pattern, *responses)
    @pattern, @responses = pattern, responses
  end

  ELIZA_RULES = 
    [
     Rule.new(Pattern.new(%w(*x hello *y)),
              "How do you do. Please state your problem"),
     Rule.new(Pattern.new(%w(*x I want *y)),
              "What would it mean if you got ?y?",
              "Why do you want ?y?",
              "Suppose you got ?y soon"),
     Rule.new(Pattern.new(%w(*x if *y)),
              "Do you really think it's likely that ?y? ",
              "Do you wish that ?y?",
              "What do you think about ?y?",
              "Really-- if ?y?"),
     Rule.new(Pattern.new(%w(*x no *y)),
              "Why not?",
              "You are being a bit negative",
              "Are you saying \"NO\" just to be negative?"),
     Rule.new(Pattern.new(%w(*x I was *y)),
              "Were you really?",
              "Perhaps I already knew you were ?y?",
              "Why do you tell me you were ?y now?"),
     Rule.new(Pattern.new(%w(*x I feel *y)),
              "Do you often feel ?y?"),
     Rule.new(Pattern.new(%w(*x I felt *y)),
              "What other feelings do you have?")
    ]
end

module Eliza
  class << self
    def run(rules = Rule::ELIZA_RULES)
      while true
        print "eliza> "
        puts eliza_rule(gets.downcase.split, rules)
      end
    end
    
    def eliza_rule(input, rules)
      rules.some? do |rule|
        result = rule.pattern.match(input)
        if result
          switch_viewpoint(result).inject(rule.responses.random_elt) do |sum, repl|
            sum.gsub(repl[0], repl[1].join(" "))
          end
        end
      end
    end
    
    def switch_viewpoint(words)
      replacements = [%w(I you), 
                      %w(you I), 
                      %w(me you), 
                      %w(am are)]
      hash = {}
      words.each do |key, val|
        hash[key] = replacements.inject(val) do |sum, repl|
          sum.map { |val| val == repl[0] ? repl[1] : val}
        end
      end
      hash
    end
  end
end

if __FILE__ == $0
  Eliza.run
end
