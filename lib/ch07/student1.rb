$:.unshift File.join(File.dirname(__FILE__), '..', 'ch05')
$:.unshift File.join(File.dirname(__FILE__), '..', 'ch06')

require 'eliza1'
require 'pat_read'
require 'pat_match'

Exp = Struct.new(:lhs, :op, :rhs)

Pattern.match_abbrev(:"?x*", %w(?* ?x))
Pattern.match_abbrev(:"?y*", %w(?* ?y))

class Rule
  def self.split(obj)
    case obj
    when String
      o = obj.split
      o.length == 1 ? o[0] : o
    when Array
      obj.map { |x| split(x) }
    end
  end
  
  STUDENT_RULES = 
    [
     ["?x* .",                         "?x"],
     ["?x* . ?y*",             "?x ?y"],
     ["if ?x* , then ?y*",     "?x ?y"],
     ["if ?x* then ?y*",       "?x ?y"],
     ["if ?x* , ?y*",          "?x ?y"],
     ["?x* , and ?y*",         "?x ?y"],
     ["find ?x* and ?y*",      ["to_find_1 == ?x", "to_find_2 == ?y"]],
     ["find ?x*",              "to_find == ?x"],
     ["?x* equals ?y*",        "?x == ?y"],
     ["?x* same as ?y*",       "?x == ?y"],
     ["?x* = ?y*",             "?x == ?y"],
     ["?x* is equal to ?y*",   "?x == ?y"],
     ["?x* is ?y*",            "?x == ?y"],
     ["?x* - ?y*",             "?x - ?y"],
     ["?x* minus ?y*",         "?x - ?y"],
     ["difference between ?x* and ?y*", "?x - ?y"],
     ["difference ?x* and ?y*",         "?x - ?y"],
     ["?x* + ?y*",             "?x + ?y"],
     ["?x* plus ?y*",          "?x + ?y"],
     ["sum ?x* and ?y*",       "?x + ?y"],
     ["product ?x* and ?y*",   "?x * ?y"],
     ["?x* * ?y*",             "?x * ?y"],
     ["?x* times ?y*",         "?x * ?y"],
     ["?x* / ?y*",             "?x / ?y"],
     ["?x* per ?y*",           "?x / ?y"],
     ["?x* divided by ?y*",    "?x / ?y"],
     ["half ?x*",              "?x / ?y"],
     ["one half ?x*",          "?x / ?y"],
     ["twice ?x*",             "2 * ?x"],
     ["square ?x*",            "?x * ?x"],
     ["?x* % less than ?y*",   ["?y", "*", [["100 - ?x"], "/", "100"]]],
     ["?x* % more than ?y*",   ["?y", "*", [["100 + ?x"], "/", "100"]]],
     ["?x* % ?y*",             ["?x / 100", "*", "?y"]]
    ].map{ |s| [Pattern.from_string(s[0]), split(s[1])]}
end

module Student
  class << self
    def solve(words)
    solve_equations(
        create_list_of_equations(
          translate_to_expression(
            words.find_all do |word|
              !noise_word?(word)
            end)))
    end
    
    def noise_word?(word)
      %w(a an the this number of $ ).include?(word)
    end
    
    def translate_to_expression(words)
      rule_based_translator(words, 
                            Rule::STUDENT_RULES,
                            :rule_if => lambda{|obj| obj[0]},
                            :rule_then => lambda{|obj| obj[1]},
                            :action => lambda{|bindings, response|
                              res = bindings.inject({}){|sum, vals| xx = translate_pair(vals[0], vals[1]); sum[xx[0]] = xx[1]; sum}
                              recproc = proc{ |x| x.is_a?(Array) ? x.map(&recproc) : (res[x] || x) }
                              response.map(&recproc)
                            }) ||
        make_variable(words)
    end
    
    def make_variable(words)
      words.first
    end
    
    def rule_based_translator(input, rules, options={})
      rules.some? do |rule|
        result = options[:rule_if][rule].match(input)
        if result
          options[:action][result, options[:rule_then][rule]]
        end
      end
    end
    
    def translate_pair(first, second)
      [first, translate_to_expression(second)]
    end
  end
end


if __FILE__ == $0
  require 'pp'

  Student.solve(%w(If the number of customers Tom gets is twice the square of 20 % of the number of advertisements he runs , and the number of advertisements is 45 , then what is the number of customers Tom gets ?).map{ |w| w.downcase })
end
