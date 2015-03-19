require 'treat'
require 'json'
require_relative 'brain'
include Treat::Core::DSL

class Interpret

  def initialize
    load_commands
    load_english_stopwords
    @brain = Brain.new
  end

  def run
    while true
      print "Computer, "
      interpret_garble gets
    end
  end

  def interpret_garble (string)
    if string.chomp.include? 'exit'
      exit
    end
    if is_word? string.chomp
      puts `#{string.chomp}`
    else
      @current_input = phrase string
      @current_input.tokenize
      #puts @current_input
      @current_input.apply(:segment,
        :parse,
        :category).print_tree
      keywords = remove_stopwords @current_input
      #puts "Keywords : #{keywords}" unless keywords.empty?
      @brain.make_descision @current_input, keywords, @commands
      #puts is_verb_phrase? @current_input
      #puts is_noun_phrase? @current_input
    end
  end

  def is_word? (word)
    return word.split(' ').length == 1
  end

  def remove_stopwords (phrase)
    nonstop = []
    @current_input.each_word do |word|
      nonstop.push word.to_s unless @stopwords['stopwords'].include? word.to_s
    end
    return nonstop
  end

  def is_verb_phrase? (phrase)
    ## if the fist part of the phrase given is a verb phrase
    ## then this is part of a command.
    count = 0
    for vp in phrase do
      return true if count < 1 and vp.tag == "VP"
    end
    return false
  end

  def is_noun_phrase? (phrase)
    ## there will be some cases where commands start with nouns
    count = 0
    for np in phrase do
      return true if count < 1 and np.tag == "NP"
    end
    return false
  end

  def load_commands
    File.expand_path File.dirname(__FILE__)
    @commands = JSON.parse! File.read(File.dirname(__FILE__) +
      '/resources/basic-commands.json')
  end

  def load_english_stopwords
    @stopwords = JSON.parse! File.read(File.dirname(__FILE__) +
      '/resources/stopwords.json')
  end
end
