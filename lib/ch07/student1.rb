$:.unshift File.join(File.dirname(__FILE__), '..', 'ch05')
$:.unshift File.join(File.dirname(__FILE__), '..', 'ch06')

require 'eliza1'
require 'pat_read'
require 'pat_match'

Pattern.match_abbrev(:"?x*", %w(?* ?x))
Pattern.match_abbrev(:"?y*", %w(?* ?y))

def exp_rhs(exp)
  exp[2]
end

def exp_op(exp)
  exp[1]
end

def exp_lhs(exp)
  exp[0]
end

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
     ["?x* . ?y*",                     "?x ?y"],
     ["if ?x* , then ?y*",             "?x ?y"],
     ["if ?x* then ?y*",               "?x ?y"],
     ["if ?x* , ?y*",                  "?x ?y"],
     ["?x* , and ?y*",                 "?x ?y"],
     ["find ?x* and ?y*",             ["to_find_1 = ?x", "to_find_2 = ?y"]],
     ["find ?x*",                      "to_find = ?x"],
     ["?x* equals ?y*",                "?x = ?y"],
     ["?x* same as ?y*",               "?x = ?y"],
     ["?x* = ?y*",                     "?x = ?y"],
     ["?x* is equal to ?y*",           "?x = ?y"],
     ["?x* is ?y*",                    "?x = ?y"],
     ["?x* - ?y*",                     "?x - ?y"],
     ["?x* minus ?y*",                 "?x - ?y"],
     ["difference between ?x* and ?y*","?x - ?y"],
     ["difference ?x* and ?y*",        "?x - ?y"],
     ["?x* + ?y*",                     "?x + ?y"],
     ["?x* plus ?y*",                  "?x + ?y"],
     ["sum ?x* and ?y*",               "?x + ?y"],
     ["product ?x* and ?y*",           "?x * ?y"],
     ["?x* * ?y*",                     "?x * ?y"],
     ["?x* times ?y*",                 "?x * ?y"],
     ["?x* / ?y*",                     "?x / ?y"],
     ["?x* per ?y*",                   "?x / ?y"],
     ["?x* divided by ?y*",            "?x / ?y"],
     ["half ?x*",                      "?x / ?y"],
     ["one half ?x*",                  "?x / ?y"],
     ["twice ?x*",                     "2 * ?x"],
     ["square ?x*",                    "?x * ?x"],
     ["?x* % less than ?y*",          ["?y", "*", [["100.0 - ?x"], "/", "100.0"]]],
     ["?x* % more than ?y*",          ["?y", "*", [["100.0 + ?x"], "/", "100.0"]]],
     ["?x* % ?y*",                    ["?x / 100.0", "*", "?y"]]
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

    def create_list_of_equations(exp)
      case 
      when exp.empty?
        []
      when !exp[0].is_a?(Array)
        [exp]
      else
        create_list_of_equations(exp[0]) +
          create_list_of_equations(exp[1..-1])
      end
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

    def list_repr(l)
      case l
      when Array
        "(#{l.map{ |x| list_repr(x) }.join(" ")})"
      else
        l.to_s
      end
    end
    
    def print_equations(header, equations)
      puts header
      equations.each do |eq|
        print "  "
        eq.each do |ee|
          print " #{list_repr(ee)}"
        end
        puts
      end
    end
    
    def solve_equations(equations)
      print_equations("The equations to be solved are: ", equations)
      print_equations("The solution is: ", solve_eq(equations, []))
    end

    def unknown?(exp)
      (exp.is_a?(String) && !(Integer(exp) rescue nil)  && !(Float(exp) rescue nil))
    end

    def no_unknown(exp)
      case 
      when unknown?(exp)
        nil
      when !exp.is_a?(Array) || exp.empty?
        true
      when no_unknown(exp_lhs(exp))
        no_unknown(exp_rhs(exp))
      else
        nil
      end
    end

    def solve_arithmetic(eq)
      [exp_lhs(eq), "=", eval(list_repr(exp_rhs(eq)))]
    end
    
    def one_unknown(exp)
      case
      when unknown?(exp)
        exp
      when !exp.is_a?(Array) || exp.empty?
        nil
      when no_unknown(exp_lhs(exp))
        one_unknown(exp_rhs(exp))
      when no_unknown(exp_rhs(exp))
        one_unknown(exp_lhs(exp))
      else
        nil
      end
    end

    def exp?(exp)
      exp.is_a?(Array) && exp.length == 3
    end
    
    def in_exp(x, exp)
      x == exp ||
        (exp?(exp) && (in_exp(x, exp_lhs(exp)) || in_exp(x, exp_rhs(exp))))
    end
    
    def inverse_op(op)
      { 
        '+' => '-',
        '-' => '+',
        '*'  => '/',
        '/'  => '*',
        '='  => '='
      }[op]
    end
    
    def commutative?(op)
      %w(+ * =).include?(op)
    end
    
    def isolate(e, x)
      case 
      when exp_lhs(e) == x
        e
      when in_exp(x, exp_rhs(e))
        isolate([exp_rhs(e), "=", exp_lhs(e)], x)
      when in_exp(x, exp_lhs(exp_lhs(e)))
        isolate([exp_lhs(exp_lhs(e)), 
                 "=", 
                 [exp_rhs(e), 
                  inverse_op(exp_op(exp_lhs(e))), 
                  exp_rhs(exp_lhs(e))]],x)
      when commutative?(exp_op(exp_lhs(e)))
        isolate([exp_rhs(exp_lhs(e)),
                 "=",
                 [exp_rhs(e),
                  inverse_op(exp_op(exp_lhs(e))),
                 exp_lhs(exp_lhs(e))]],x)
      else
        isolate([exp_rhs(exp_lhs(e)),
                 "=",
                [exp_lhs(exp_lhs(e)),
                 exp_op(exp_lhs(e)),
                 exp_rhs(e)]],x)
      end
    end

    def solve_eq(equations, known)
      equations.some? do |equation|
        x = one_unknown(equation)
        if x
          answer = solve_arithmetic(isolate(equation,x))
          recproc = proc{ |x| x.is_a?(Array) ? x.map(&recproc) : (x==exp_lhs(answer) ? exp_rhs(answer) : x) }
          solve_eq((equations-[equation]).map(&recproc), [answer] + known)
        end
      end ||
        known
    end
  end
end


if __FILE__ == $0
  require 'pp'

  Student.solve_equations([[["3", "+", "4"], "=", [["5", "-", ["2", "+", "x"]],"*","7"]],
                           [[["3", "*", "x"], "+", "y"], "=", "12"]])
  
  Student.solve(%w(If the number of customers Tom gets is twice the square of 20 % of the number of advertisements he runs , and the number of advertisements is 45 , then what is the number of customers Tom gets ?).map{ |w| w.downcase })
end
