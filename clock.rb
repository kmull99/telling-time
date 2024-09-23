require 'ruby2d'
require './lib/toggle_button'

COS = 0.866 # Math.cos(30 * Math::PI / 180)
SIN = 0.5   # Math.sin(30 * Math::PI / 180)
CLOCK_X = 400
CLOCK_Y = 240
@rand = Random.new

@score = 0
@starting_lives = 3
@lives = []

@show_minutes = true

@hour_hand = nil
@minute_hand = nil

@hour_buttons = []
@current_hour_button = nil
@minute_buttons = []
@current_minute_button = nil
@check_button = nil

@answer = nil

@sounds = { correct: nil, wrong: nil, button: nil, lose: nil }
@output = { score: nil }

def check_answer
  return unless @current_hour_button && @current_minute_button

  if @answer == [@hour_buttons.index(@current_hour_button) + 1, 5 * (@minute_buttons.index(@current_minute_button) + 1)]
    @sounds[:correct].play
    increment_score
    set_clock
    reset_buttons
  else
    @sounds[:wrong].play
    decrement_lives
  end
end

def decrement_lives
  return game_over if @lives.empty?

  @lives[-1].remove
  @lives.pop
end

def game_over
  @sounds[:lose].play
  sleep(1)
  puts "You read #{@score} clocks correctly.\nYour final grade is (#{@score}/#{@score + 4}), or #{(@score.to_f / (@score + 4)).round(3) * 100}%"
  quit
end

def increment_score
  @score += 1
  @output[:score].text = "Score: #{@score}"
end

def make_buttons
  # Hour buttons
  for i in 1..9
    @hour_buttons << ToggleButton.new("./assets/#{i}.png",
                                                coords: { x: 25, y: 68 + i.pred * 29},
                                                size: { x: 16, y: 24})
  end
  for i in 10..12
    @hour_buttons << ToggleButton.new("./assets/#{i}.png",
                                                coords: { x: 5, y: 68 + i.pred * 29},
                                                size: { x: 36, y: 24})
  end

  # Minute buttons
  for i in 1..1
    @minute_buttons << ToggleButton.new('./assets/05.png',
                                                coords: { x: 60, y: 68 + i.pred * 29},
                                                size: { x: 36, y: 24})
  end
  for i in 2..11
    @minute_buttons << ToggleButton.new("./assets/#{i * 5}.png",
                                                coords: { x: 60, y: 68 + i.pred * 29},
                                                size: { x: 36, y: 24})
  end
  for i in 12..12
    @minute_buttons << ToggleButton.new('./assets/00.png',
                                        coords: { x: 60, y: 68 + i.pred * 29},
                                        size: { x: 36, y: 24})
  end

  # Check button
  @check_button = Text.new(
    'Check',
    x: 2, y: 28,
    size: 36,
    color: 'gray'
  )
end

def make_clock
  ## DRAW CLOCK BODY  ##

  # Find points of triangles
  point = { x: -62, y: -231 }
  points = [[point[:x] + CLOCK_X, point[:y] + CLOCK_Y]]
  11.times do
    xprime = (point[:x] * COS - point[:y] * SIN)
    yprime = (point[:y] * COS + point[:x] * SIN)
    point[:x] = xprime
    point[:y] = yprime
    points << [xprime.truncate + CLOCK_X, yprime.truncate + CLOCK_Y]
  end
  points << points[0]

  # Draw triangles

  colors = %w[red blue]
  for i in 0..11
    Triangle.new(
      x1: CLOCK_X, y1: CLOCK_Y,
      x2: points[i][0], y2: points[i][1],
      x3: points[i+1][0], y3: points[i+1][1],
      color: colors[i % 2]
    )
  end

  ## DRAW CLOCK HANDS ##

  @hour_hand = Line.new(
    x1: CLOCK_X, y1: CLOCK_Y,
    width: 5,
    color: 'silver',
    z: 5
  )
  @minute_hand = Line.new(
    x1: CLOCK_X, y1: CLOCK_Y,
    width: 5,
    color: 'black',
    z: 4
  )

  ##  LABEL CLOCK SEGMENTS  ##

  # Draw hours
  point = { x: 0, y: -200 }
  points = [[point[:x] + CLOCK_X, point[:y] + CLOCK_Y]]
  11.times do
    xprime = point[:x] * COS - point[:y] * SIN
    yprime = point[:y] * COS + point[:x] * SIN
    point[:x] = xprime
    point[:y] = yprime
    points << [xprime.truncate + CLOCK_X, yprime.truncate + CLOCK_Y]
  end
  points << points.shift

  for i in 0..8
    Image.new(
      "assets/#{i+1}.png",
      x: points[i][0] - 8, y: points[i][1] - 12,
      width: 16, height: 24
    )
  end
  for i in 9..11
    Image.new(
      "assets/#{i+1}.png",
      x: points[i][0] - 18, y: points[i][1] - 12,
      width: 36, height: 24
    )
  end

  # Draw minutes
  return unless @show_minutes

  point = { x: 0, y: -160 }
  points = [[point[:x] + CLOCK_X, point[:y] + CLOCK_Y]]
  11.times do
    xprime = point[:x] * COS - point[:y] * SIN
    yprime = point[:y] * COS + point[:x] * SIN
    point[:x] = xprime
    point[:y] = yprime
    points << [xprime.truncate + CLOCK_X, yprime.truncate + CLOCK_Y]
  end

  for i in 0..1
    Image.new(
      "assets/#{i * 5}.png",
      x: points[i][0] - 4, y: points[i][1] - 6,
      width: 8, height: 12
    )
  end
  for i in 2..11
    Image.new(
      "assets/#{i * 5}.png",
      x: points[i][0] - 9, y: points[i][1] - 6,
      width: 18, height: 12
    )
  end
end

def mouse_over_check_button?(mx, my)
  mx >= 2 && mx <= 102 && my >= 28 && my <= 64
end

def quit
  close
end

def reset_buttons
  @current_hour_button.toggle
  @current_hour_button = nil

  @current_minute_button.toggle
  @current_minute_button = nil

  @check_button.color = 'gray'
end

def set_clock
  ##  POINT TO A RANDOM TIME  ##

  hours = rand(12)
  @hour_hand.x2 = 100 * Math.sin((12 - hours) * 30 * Math::PI / 180) + CLOCK_X
  @hour_hand.y2 = -100 * Math.cos((12 - hours) * 30 * Math::PI / 180) + CLOCK_Y

  minutes = rand(12)
  @minute_hand.x2 = 150 * Math.sin((12 - minutes) * 30 * Math::PI / 180) + CLOCK_X
  @minute_hand.y2 = -150 * Math.cos((12 - minutes) * 30 * Math::PI / 180) + CLOCK_Y

  @answer = [12 - hours, (12 - minutes) * 5]
end

def set_lives
  heart_size = 32
  @starting_lives.times do |i|
    @lives << Image.new(
      './assets/heart.png',
      x: 7 + i * (5 + heart_size), y: 2,
      width: heart_size, height: heart_size
    )
  end
end

def set_score
  @output[:score] = Text.new(
    "Score: #{@score}",
    x: 0, y: 444,
    size: 36,
    color: 'blue'
  )
end

def main
  set title: 'Telling Time',
      background: 'gray',
      width: 640,
      height: 480,
      resizable: false

  make_clock
  set_clock
  make_buttons
  set_score
  set_lives

  @sounds[:correct] = Sound.new('assets/sounds/duolingo-correct.mp3')
  @sounds[:wrong] = Sound.new('assets/sounds/duolingo-wrong.mp3')
  @sounds[:button] = Sound.new('assets/sounds/minecraft-click.mp3')
  @sounds[:lose] = Sound.new('assets/sounds/error.mp3')

  on :key_down do |event|
    key = event.key

    quit if key == 'escape'
    set_clock if key == 't'
  end

  on :mouse_down do |event|
    @hour_buttons.each do |button|
      if button.mouse_over?(event.x, event.y)
        @current_hour_button.toggle if @current_hour_button
        @current_hour_button = button
        @current_hour_button.toggle
        @sounds[:button].play

        @check_button.color = 'black' if @current_hour_button && @current_minute_button
      end
    end

    @minute_buttons.each do |button|
      if button.mouse_over?(event.x, event.y)
        @current_minute_button.toggle if @current_minute_button
        @current_minute_button = button
        @current_minute_button.toggle
        @sounds[:button].play

        @check_button.color = 'black' if @current_hour_button && @current_minute_button
      end
    end

    check_answer if mouse_over_check_button?(event.x, event.y)
  end

  show
end

main
