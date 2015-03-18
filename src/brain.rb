require 'stuff-classifier'

class Brain
  def initialize
    @my_name = "Amos"
    @user_name = "sulien"
    @unknowns = [
      "Great question. I’m just not familiar enough with it to hazard a guess."
    ]
    store = StuffClassifier::FileStorage.new(
      File.expand_path File.dirname(__FILE__) + '/resources/.brain' )
    @classifier = StuffClassifier::TfIdf.new "brain", :storage => store
    train
  end

  def train
    @classifier.train(:file, "Create a file.")
    @classifier.train(:file, "Create some more files.")
    @classifier.train(:file, "Concat some files.")
    @classifier.train(:file, "Show me a few files.")
    @classifier.train(:file, "Show me the contense of a file.")
    @classifier.train(:file, "Copy four of the files.")
    @classifier.train(:file, "Move all of the files to a difference location.")
    @classifier.train(:file, "Show me less of that file.")
    @classifier.train(:file, "Remove a file called blue")
    @classifier.train(:file, "Remove some more files.")
    @classifier.train(:file, "Create ten files.")
    @classifier.train(:file, "Show me only some of that file.")
    @classifier.train(:file, "Link a file to this other file.")
    @classifier.train(:file, "Link this file to another file.")
    @classifier.train(:process, "Kill that process.")
    @classifier.train(:process, "Kill a process called.")
    @classifier.train(:process, "Stop a process called.")
    @classifier.train(:process, "Repeat this process 20 times.")
    @classifier.train(:process, "Stop the process number 9082.")
    @classifier.train(:directory, "List all the files in the current directory.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Show me all the files.")
    @classifier.train(:directory, "Is there a file called blue?")
    @classifier.train(:directory, "Copy all the files.")
    @classifier.train(:directory, "Move all the files.")
    @classifier.train(:directory, "Copy this directory to here.")
    @classifier.train(:directory, "Move this directory.")
    @classifier.train(:directory, "Remove this directory.")
    @classifier.train(:directory, "Delete the directory called .")
    @classifier.train(:directory, "Find me a file called this.")
    @classifier.train(:directory, "Is there a file called?")
    @classifier.train(:directory, "Can you find the file called.")
    @classifier.train(:directory, "Find a file called this.")
    @classifier.train(:directory, "Search for a file called jim.")
    @classifier.train(:directory, "What directory am I in?")
    @classifier.train(:directory, "Where am I?")
    @classifier.train(:directory, "show me the contense of this directory")
    @classifier.train(:directory, "Change my location to here.")
    @classifier.train(:display, "Display this string here.")
    @classifier.train(:display, "Clear the screen.")
    @classifier.train(:display, "Clear.")
    @classifier.train(:display, "Clean the display.")
    @classifier.train(:display, "How do I look at all the files?")
    @classifier.train(:display, "Can you show me the manuel pages for 'ls'.")
    @classifier.train(:display, "How do I change the directory I am in?")
    @classifier.train(:file, "Count the number of lines in this file.")
    @classifier.train(:file, "Count the number of characters in the file.")
    @classifier.train(:file, "Search the file for 'this'.")
    @classifier.train(:file,
      "Search a file for all strings that match 'hello'.")
    @classifier.train(:file,
      "What is the difference between file one and file two?")
    @classifier.train(:file, "Is there difference between these two files?")
    @classifier.train(:file, "Delete the file called.")
    @classifier.train(:file, "Add a file called Assignmen 2.")
    @classifier.train(:file, "Delete a file called blue.")
    @classifier.train(:file, "What is inside the file?")
    @classifier.train(:file, "Show me the conetense of a file.")
    @classifier.train(:file, "Please copy the file over here")
    @classifier.train(:file, "Move a file over.")
    @classifier.train(:file, "Link this file to here.")
    @classifier.train(:file, "How many lines are in this file?")
    @classifier.train(:file, "Count the number of lines please.")
    @classifier.train(:command, "Execute this please.")
    @classifier.train(:command, "Run a program.")
    @classifier.train(:command, "Start this program.")
    @classifier.train(:command, "Run the program please.")
    @classifier.train(:command, "Start this program.")
    @classifier.train(:command, "Execute list.")
    @classifier.train(:command, "Run the program.")
    @classifier.save_state
  end

  def make_descision (phrase, keywords, commands)
    classification = @classifier.classify phrase.to_s
    classification.nil? ? formulat_response( "unknown" )
      : match_commands( keywords, classification, commands )
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

  def re_inforce (descision)
    ## ask user if I selected the correct operation
    case descision
      when 'question'
        print "Are you tring to ask me a question? \n\n"
      else
        print "Are you asking me to #{descision[1]['cmd'][1]['description']}? "
    end
    gets.chomp.downcase.eql? 'yes' ? true : false
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
