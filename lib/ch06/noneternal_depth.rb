require 'search'

debug :search
Search.depth_first(1,
                   Trees.finite_binary(15), 
                   &is(12))
