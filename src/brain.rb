require 'stuff-classifier'

class Brain
  def initialize
    @my_name = "Amos"
    @user_name = "Eric"
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
        :"#{split[0].chomp}", split[1].chomp)unless line.chomp.empty?
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
      puts "You are very welcome, #{@user_name}!"
    else
      classification = @classifier.classify phrase.to_s
      if classification.nil?
        reinforce({:type => "unknown",
          :phrase => phrase,
          :keywords => keywords,
          :cmds => commands})
      else
        puts @cmd_classifiers["#{classification}"].classify phrase.to_s
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
    puts "I am unsure what you are asking me to do."
    puts
    puts "What command are you looking to execute?"
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

    File.open(path, 'a').puts "#{command.first()[0]},#{phrase}"

    path = File.expand_path File.dirname(__FILE__) +
      "/resources/trainning_data.csv"

    File.open(path, 'a').puts "#{context},#{phrase}"

    train # I may change this, but for now the files are small enough that it
          # won't impact the performance

    puts
    puts "Thank you, I should know what that means next time."
  end

  def reinforce (descision)
    ## ask user if I selected the correct operation
    case descision[:type]
      when 'question'
        print "Are you tring to ask me a question? \n\n"
      when 'unknown'
        add_to_trainning descision
    end
  end

  def whats_my_name?
    "I am called #{@my_name}."
  end

  def whats_your_name?
    "You are called #{@user_name}."
  end

  def execute_command (command)

  end

  def formulat_response (descision)
    puts "#{descision}"
    ## response to file operation
    ## response to dir operation
    ## response to interaction
    ## response to unknown
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
