$:.unshift File.join(File.dirname(__FILE__), '..', 'ch05')
$:.unshift File.join(File.dirname(__FILE__), '..', 'ch06')

require 'eliza1'
require 'pat_read'
require 'pat_match'

Exp = Struct.new(:lhs, :op, :rhs)

Pattern.match_abbrev(:"?x*", %w(?* ?x))
Pattern.match_abbrev(:"?y*", %w(?* ?y))

class Rule
  STUDENT_RULES = 
    [
     ["?x* .",                         "?x"],
     ["?x* . ?y*",             "?x ?y"],
     ["if ?x* , then ?y*",     "?x ?y"],
     ["if ?x* then ?y*",       "?x ?y"],
     ["if ?x* , ?y*",          "?x ?y"],
     ["?x* , and ?y*",         "?x ?y"],
     ["find ?x* and ?y*",      "(to_find_1 == ?x) (to_find_2 == ?y)"],
     ["find ?x*",              "to_find == ?x"],
     ["?x* equals ?y*",        "to_find == ?x"],
     ["?x* same as ?y*",       "to_find == ?x"],
     ["?x* = ?y*",             "to_find == ?x"],
     ["?x* is equal to ?y*",   "to_find == ?x"],
     ["?x* is ?y*",            "to_find == ?x"],
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
     ["?x* % less than ?y*",   "?y * ((100 - ?x) / 100)"],
     ["?x* % more than ?y*",   "?y * ((100 + ?x) / 100)"],
     ["?x* % ?y*",             "(?x / 100) * ?y"]
    ].map{ |s| x=[Pattern.from_string(s[0]), s[1]]; p x; x }
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
      p(Rule::STUDENT_RULES.some? do |pattern, replace|
        result = pattern.match(words)
        if result
          [result, replace]
        end
      end)
    end
  end
end


if __FILE__ == $0
  require 'pp'
  pp Rule::STUDENT_RULES

  Student.solve(%w(If the number of customers Tom gets is twice the square of 20 % of the number of advertisements he runs , and the number of advertisements is 45 , then what is the number of customers Tom gets ?))
end
