require 'simple'

def adj_star
  return [] if rand(2) == 0
  adj + adj_star
end

def pp_star
  return [] if rand(2) == 0
  pp + pp_star
end

def noun_phrase; article + adj_star + noun + pp_star; end
def pp; prep + noun_phrase; end
def adj; one_of %w(big little blue green adiabatic); end
def prep; one_of %w(to in by with on); end

