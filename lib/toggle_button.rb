# frozen_string_literal: true

require 'ruby2d'

class ToggleButton
  @coords = nil
  @size = nil
  @image_path = nil

  @image = nil
  @filter = nil
  @pressed = false

  # @param {String} image_path
  # @param {Hash{ x:, y: }} coords
  # @param {Hash{ x:, y: }} size
  def initialize(image_path, coords: { x: 0, y: 0}, size: { x: 100, y: 100})
    @coords = coords
    @size = size
    @image_path = image_path

    self.draw
  end

  def mouse_over?(mx, my)
    mx >= @coords[:x] && mx <= @coords[:x] + @size[:x] && my >= @coords[:y] && my <= @coords[:y] + @size[:y]
  end

  def toggle
    @pressed = !@pressed

    if @pressed
      @filter.color.opacity = 0.4
    else
      @filter.color.opacity = 0
    end
  end

  private

  def draw
    return if @image

    @image = Image.new(
      @image_path,
      x: @coords[:x], y: @coords[:y],
      width: @size[:x], height: @size[:y]
    )

    @filter = Rectangle.new(
      x: @coords[:x], y: @coords[:y],
      width: @size[:x], height: @size[:y],
      color: 'green'
    )

    @filter.color.opacity = 0
  end
end
