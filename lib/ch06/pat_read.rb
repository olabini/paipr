
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
      result
    end
  end
end

