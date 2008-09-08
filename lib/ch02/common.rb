require 'pp'

def one_of(set)
  [set.random_elt]
end

class Array
  def random_elt
    self[rand(self.length)]
  end
end
