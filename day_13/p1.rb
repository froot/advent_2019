require 'pry'

class Amp
  attr_reader :waiting
  attr_reader :current_index
  attr_reader :program

  INSTRUCTIONS = {
    1=> { steps: 4, method: :execute_1 },
    2=> { steps: 4, method: :execute_2 },
    3=> { steps: 2, method: :execute_3 },
    4=> { steps: 2, method: :execute_4 },
    5=> { steps: 3, method: :execute_5 },
    6=> { steps: 3, method: :execute_6 },
    7=> { steps: 4, method: :execute_7 },
    8=> { steps: 4, method: :execute_8 },
    9=> { steps: 2, method: :execute_9 },
  }

  def initialize
    @program = File.read('input1.txt').chomp.split(',').map(&:to_i)
    @current_index = 0
    @waiting = true
    @relative_base = 0
    @output = []
    #@input = nil
  end

  def run_program
    @waiting = false
    #@input = current_color
    while(@program[@current_index] != 99 && !@waiting) do
      first_value = @program[@current_index]
      deconstructed_array = deconstruct_first_value(first_value)
      opt_code = deconstructed_array.first
      instruction = @program[@current_index..@current_index+INSTRUCTIONS[opt_code][:steps]-1]
      params = evaluate_params(instruction, deconstructed_array)

      new_index = method(INSTRUCTIONS[opt_code][:method]).call(params)
      @current_index = new_index
    end
    
    @output
  end

  private

  def execute_1(params)
    @program[position_of_param(params.last)] = value_of_param(params.first) +
      value_of_param(params.fetch(1))
    @current_index + INSTRUCTIONS[1][:steps]
  end

  def execute_2(params)
    @program[position_of_param(params.last)] = value_of_param(params.first) *
      value_of_param(params.fetch(1))
    @current_index + INSTRUCTIONS[2][:steps]
  end

  def execute_3(params)
    #input = if @input
      #temp = @input
      #@input = nil
      #temp
    #end

    if input
      @program[position_of_param(params.last)] = input
      @current_index + INSTRUCTIONS[3][:steps]
    else
      @waiting = true
      @current_index
    end
  end

  def execute_4(params)
    @output << value_of_param(params.last)
    @current_index + INSTRUCTIONS[4][:steps]
  end

  def execute_5(params)
    if value_of_param(params.first) != 0
      return value_of_param(params.last)
    end
    @current_index + INSTRUCTIONS[5][:steps]
  end

  def execute_6(params)
    if value_of_param(params.first) == 0
      return value_of_param(params.last)
    end
    @current_index + INSTRUCTIONS[6][:steps]
  end

  def execute_7(params)
    @program[position_of_param(params.last)] =
      if value_of_param(params.first) <
        value_of_param(params.fetch(1))
        1
      else
        0
      end

    @current_index + INSTRUCTIONS[7][:steps]
  end

  def execute_8(params)
    @program[position_of_param(params.last)] =
      if value_of_param(params.first) == value_of_param(params.fetch(1))
        1
      else
        0
      end

    @current_index + INSTRUCTIONS[8][:steps]
  end

  def execute_9(params)
    @relative_base += value_of_param(params.first)

    @current_index + INSTRUCTIONS[9][:steps]
  end

  def deconstruct_first_value(value)
    digits = value.digits.reverse
    return_value = []

    return_value << digits.last(2).join.to_i
    digits.pop
    digits.pop

    while(!digits.empty?) do
      return_value << digits.pop
    end

    return_value
  end

  def evaluate_params(instruction, deconstructed_array)
    instruction.shift

    params = []
    instruction.each_with_index do |param, i|
      mode = deconstructed_array[i+1] ? deconstructed_array[i+1] : 0
      params << { param: param, mode: mode }
    end

    params
  end

  # used for writing to
  def position_of_param(param)
    case param[:mode]
    when 0
      param[:param]
    when 2
      @relative_base + param[:param]
    end
  end

  # used for reading from
  def value_of_param(param)
    value = case param[:mode]
    when 0 # position mode
      @program[param[:param]]
    when 1 # literal mode
      param[:param]
    when 2 # relative mode
      @program[@relative_base + param[:param]]
    end

    value ||= 0
  end
end

tiles = Amp.new.run_program
tile_ids = tiles.each_slice(3).map(&:last)
puts tile_ids.select { |id| id == 2 }.length
