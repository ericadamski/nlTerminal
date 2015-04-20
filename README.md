# Natural Language Terminal

A natural language terminal application written in Ruby, parses and executes UNIX commands given english sentences.

A paper describing the project is included in the [Paper](https://github.com/ericadamski/nlTerminal/blob/master/paper/A_Natural_Language_Terminal.pdf) directory.

Supported commands are as follows :

>Note: the program, as is, will only output the command which it choses to execute, the actual command is not executed.

- touch
- cp
- mv
- rm
- cat
- less
- cd
- pwd
- whoami ( not well supported )
- ls
- mkdir
- rmdir
- ln
- clear
- echo
- repeat
- man
- history
- wc
- kill
- exec
- grep
- find
- diff

#### To Run

> The latest version of ruby must be installed. As well as the latest Stanford NLP release.

To run, start the terminal with `/path/to/file/nlTerminal.rb -s` or `--start`
- there some other basic options available with the `-h | --help` flag

To exit the terminal simply type `exit`, when propted.

#### License

The MIT License (MIT)

Copyright (c) 2015 Eric Adamski

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
