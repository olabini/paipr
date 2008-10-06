require 'search'

debug :search
Search.breadth_first(1,
                     proc{|v| Trees.binary(v)}, 
                     &is(12))
