require 'rule_based'

$bigger_grammar = { 
  :sentence => [[:noun_phrase, :verb_phrase]],
  :noun_phrase => [[:Article, :'Adj*', :Noun, :'PP*'], [:Name], [:Pronoun]],
  :verb_phrase => [[:Verb, :noun_phrase, :'PP*']],
  :'PP*' => [[], [:PP, :'PP*']],
  :'Adj*' => [[], [:Adj, :'Adj*']],
  :PP => [[:Prep, :noun_phrase]],
  :Prep => %w(to in by with on),
  :Adj => %w(big little blue green adiabatic),
  :Article => %w(the a),
  :Name => %w(Pat Kim Lee Terry Robin),
  :Noun => %w(man ball woman table),
  :Verb => %w(hit took saw liked),
  :Pronoun => %w(he she it these those that)}

$grammar = $bigger_grammar
