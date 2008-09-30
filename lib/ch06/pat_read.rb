
# Allows translation from strings like this:
#  I think that (?is ?n numberp) flurg
# into something like this:
#  ["I", "think", "that", ["?is", "?n", "numberp"], "flurg"]
class Pattern
  def initialize(pattern)
    @pattern = pattern
  end
  
  class << self
    def from_string(str)
      result = []
      str.scan(/(\(\?.*?\))|([^[:space:]]+)/) do |f|
        if f[1]
          result << f[1]
        else
          result << f[0][1..-2].split
        end
      end
      Pattern.new expand(result)
    end

    attr_accessor :expansions

    def match_abbrev(symbol, expansion)
      self.expansions[symbol.to_sym] = expand(expansion)
    end

    def expand(pat)
      if !pat.is_a?(Array)
        if self.expansions[pat.to_sym]
          self.expansions[pat.to_sym]
        else
          pat
        end
      elsif pat.empty?
        pat
      else
        [expand(pat[0])] + expand(pat[1..-1])
      end
    end
  end

  self.expansions = { }
end
