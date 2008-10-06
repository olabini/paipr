require 'search'

debug :search
Search.depth_first(1,
                   proc{|v| Trees.binary(v)}, 
                   &is(12))
