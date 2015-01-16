require 'treat'
require_relative 'command'
include Treat::Core::DSL

class Interpret
  def initialize
  end

  def run
    while true
      interpret_garble gets
    end
  end

  def interpret_garble (string)
    if string.chomp.include? 'exit'
      exit
    end
    @current_input = sentence string
    @current_input.tokenize
    @current_input.apply(:name_tag, :parse, :topics, :keywords).print_tree
  end
end
