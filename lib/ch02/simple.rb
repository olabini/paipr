require 'common'

def sentence; noun_phrase + verb_phrase; end
def noun_phrase; article + noun; end
def verb_phrase; verb + noun_phrase; end
def article; one_of %w(the a); end
def noun; one_of %w(man ball woman table); end
def verb; one_of %w(hit took saw liked); end
