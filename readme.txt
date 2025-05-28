This is a game I created to teach my cousin how to read a clock.
The game displays a clock showing a randomly generated time.
Enter the displayed time using the numbers on the left side. The
check button will not show until you've selected the hours & 
minutes. Your final score is printed to the console.

Controls:
  - Mouse:  Click buttons
  - t:      Change time
  - m:      Show/hide minutes
  - esc:    quit (does not print final score)

Enable/disable optional features by editing instance variables in telling_time.rb
  - @starting_lives
    - Can be set to any non-negative integer
  - @show_minutes
    - Set to true to print minutes (0-60) around the clock
  - @block_hours
    - false: The hour hand moves with the minute hand, like a real clock.
    - true: The hour hand points directly to the current hour.

Setup:
  - Install ruby for your system
  - Install ruby2d & it's dependencies
    - https://www.ruby2d.com/learn/get-started/
  - Run bundle to install other dependencies
  - Start the game by running telling_time.rb in the console
    - ruby telling_time.rb


TODO:
  - Improve difficulty select
  - Improve final score display
  - Play again
  - Custom difficulty
  - High score

This game was developed in Ruby 3.2.5. Other version may or may not work.
