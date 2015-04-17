require 'stuff-classifier'

class Brain
  def initialize
    @my_name = "Amos"
    @user_name = "Eric"
    @path_regexp = /(.(\/[a-z]+)+)|(\.\/)|(\.\.)/
    @unknowns = [
      "Great question. I’m just not familiar enough with it to hazard a guess."
    ]
    @classifier =
      StuffClassifier::TfIdf.new "brain", :storage => get_storage('brain')
    @cmd_classifiers = {}
    train
  end

  def get_storage (file_name)
    StuffClassifier::FileStorage.new(
      File.expand_path File.dirname(__FILE__) + "/resources/.#{file_name}")
  end

  def trainning (classifier, file_name)
    path = File.expand_path File.dirname(__FILE__) +
      "/resources/#{file_name}"

    File.open(path).each_line { |line|
      split = line.split ','
      #the first is the type, second is the data
      classifier.train(
        :"#{split[0].chomp}", split[1].chomp) unless line.chomp.empty?
    }

    classifier.save_state
  end

  def train
    trainning @classifier, 'trainning_data.csv'

    @cmd_classifiers['file'] =
      StuffClassifier::TfIdf.new 'file', :storage => get_storage('file')
    #touch,cp,mv,rm,cat,less,ln,wc,grep,diff

    @cmd_classifiers['directory'] =
      StuffClassifier::TfIdf.new 'directory', :storage => get_storage('dir')
    #cp,mv,cd,ls,mkdir,rmdir,ln,find

    @cmd_classifiers['display'] =
      StuffClassifier::TfIdf.new 'display', :storage => get_storage('display')
    #pwd,whoami,clear,echo,man,history

    @cmd_classifiers['command'] =
      StuffClassifier::TfIdf.new 'command', :storage => get_storage('command')
    #repeat,exec

    @cmd_classifiers['process'] =
      StuffClassifier::TfIdf.new 'process', :storage => get_storage('process')

    @cmd_classifiers.map{ |context, classifier|
      trainning classifier, "trainning_#{context}.csv" }
  end

  def make_descision (phrase, keywords, commands)
    if phrase.to_s.chomp.downcase.eql? "thank you"
      format_response "You are very welcome, #{@user_name}!"
    else
      classification = @classifier.classify phrase.to_s
      if classification.nil?
        reinforce({:type => "unknown",
          :phrase => phrase,
          :keywords => keywords,
          :cmds => commands})
      else
        cmd = @cmd_classifiers["#{classification}"].classify phrase.to_s
        format_response formulat_response(
          commands['Commands'].select{ |command, info|
            command == cmd.to_s }.first(), keywords, phrase.to_s)
      end
    end
  end

  def match_commands (keys, classification, commands)
    relevence = {}
    ## filter out the commands which are not of the class type
    puts "#{classification}"
    relevence = commands['Commands'].select { |cmd, info| info['context']
      .include? "#{classification}" }

    relevence.map { |cmd, info| puts cmd }
  end

  def store_descision (descision)
    ## used to train, maybe?
  end

  def add_to_trainning (descision)
    ##tell them unknown
    puts
    puts @unknowns.sample
    puts
    format_response "What command are you looking to execute?"
    ##ask what command they are looking for
    command = gets.chomp

    while( (command = gets.chomp).nil? )
    end if command.nil?

    command = descision[:cmds]['Commands'].select {|cmd, info| cmd == command}
    ##put it in the data file and the corresponding class file
    puts command.first
    context = command.first()[1]['context'].first # file, directory, display ...
    phrase = descision[:phrase].to_s              # the phrase that was input

    path = File.expand_path File.dirname(__FILE__) +
      "/resources/trainning_#{context}.csv"

    File.open(path, 'a').puts "#{command.first()[0]},#{phrase.to_s}"

    path = File.expand_path File.dirname(__FILE__) +
      "/resources/trainning_data.csv"

    File.open(path, 'a').puts "#{context},#{phrase.to_s}"

    train # I may change this, but for now the files are small enough that it
          # won't impact the performance

    puts
    format_response "Thank you, I should know what that means next time."
  end

  def reinforce (descision)
    ## ask user if I selected the correct operation
    case descision[:type]
      when 'question'
        format_response "Are you tring to ask me a question? \n\n"
      when 'unknown'
        puts
        format_response "Would you like me to try at learn : "+
          "'#{descision[:phrase].to_s}' ?"
        add_to_trainning(descision) if gets.chomp.downcase.eql? 'yes'
    end
  end

  def format_response (string)
    puts
    #sprintf("%#{string.length}s", " ")
    puts string
    #sprintf("%#{string.length}s", " ")
    puts
  end

  def whats_my_name?
    "I am called #{@my_name}."
  end

  def whats_your_name?
    "You are called #{@user_name}."
  end

  def execute_command (command)

  end

  def formulat_response (descision, keywords, phrase)
    # descision is of the form ['name', {info}]
    puts "#{keywords}"
    context = descision[1]['context'].first
    response = descision[1]['response']
    toreplace = response.scan /<[a-z]+>/

    string_replace = lambda { |str, resp, replacement|
      newstr = ""
      case str
        when 'file'
          newstr = replace_files resp, get_file_path(phrase)
        when 'files'
          newstr = replace_files resp, get_file_path(phrase)
        when 'command'
          newstr = replace_command resp, replacement.call()
        when 'process'
          newstr = replace_process resp, replacement.call()
        when 'name'
          newstr = replace_name resp
        when 'directory'
          newstr = replace_dirs resp, get_file_path(phrase)
        when 'matching'
          newstr =
            replace_matching resp, get_matching_keyword(keywords, descision)
        when 'random'
          newstr = replace_random resp, get_random_keyword(descision)
        when 'type'
          newstr = replace_type resp, get_type_from_text(phrase)
        when 'content'
          newstr = replace_content resp, phrase
        when 'number'
          newstr = replace_number resp, replacement.call()
      end

      newstr
    }

    resp = response

    toreplace.map {|str| str[1, str.length - 2] }.map {|str|
      resp = string_replace.call(str, resp, lambda{ "Eric" })
    }
    ## response to interaction
    ## response to unknown
    resp
  end

  def get_type_from_text (phrase)
    #one of lines, chars
    if phrase.downcase.include? "character"
      return "characters"
    elsif phrase.downcase.include? "line"
      return "lines"
    end
    "lines"
  end

  def get_file_path (phrase)
    puts phrase
    results = phrase.delete(' ').scan( @path_regexp )
    return results.first.first unless results.empty?
    "" #maybe the current directory?
  end

  def get_random_keyword (command)
    command[1]['keywords'].sample
  end

  def get_matching_keyword (keywords, command)
    keywords.select {|keyword| command[1]['keywords'].include? keyword}.first
  end

  def compare_to_description (keywords, commands)
    count = 0
    relevence = {}
    for command in commands do
      for word in keywords do
        count += 1 if command['cmd'][1]['description'].include? word
      end
      relevence[command] = count
    end
    relevence
  end

  def replace (string, match, replace)
    string.gsub /<#{match}>/, replace
  end

  def replace_process (response, process)
    ## replace '<process>' in response with something
    replace response, "process", process
  end

  def replace_files (response, files)
    ## replace '<file|files>' in response with something
    replace response, "file>|<files", files
  end

  def replace_dirs (response, directory)
    ## replace '<directory>' in response with something
    replace response, "directory", directory
  end

  def replace_number (response, number)
    ## replace '<directory>' in response with something
    replace response, "number", number
  end

  def replace_name (response)
    ## replace '<name>' in response with something
    replace response, "name", @user_name
  end

  def replace_content (response, content)
    ## replace '<content>' in response with something
    replace response, "content", content
  end

  def replace_command (response, command)
      ## replace '<command>' in response with something
      replace response, "command", command
  end

  def replace_type (response, type)
    ## replace '<type>' in response with something
    replace response, "type", type
  end

  def replace_random (response, random)
      ## replace '<random>' in response with a random keyword
      replace response, "random", random
  end

  def replace_matching (response, matching)
    ## replace '<matching>' in response with a matching keyword
    replace response, "matching", matching
  end
end
