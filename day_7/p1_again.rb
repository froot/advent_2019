require 'pry'

class Amp
  attr_accessor :output
  attr_writer :parent_amp
  attr_writer :child_amp
  attr_reader :waiting

  # debugging
  attr_reader :phase_setting
  attr_reader :current_index

  INSTRUCTIONS = {
    1=> { steps: 4, method: :execute_1 },
    2=> { steps: 4, method: :execute_2 },
    3=> { steps: 2, method: :execute_3 },
    4=> { steps: 2, method: :execute_4 },
    5=> { steps: 3, method: :execute_5 },
    6=> { steps: 3, method: :execute_6 },
    7=> { steps: 4, method: :execute_7 },
    8=> { steps: 4, method: :execute_8 },
  }

  def initialize(phase_setting:, parent_amp:nil,input:nil)
    @phase_setting = phase_setting
    @parent_amp = parent_amp
    @child_amp = nil
    @program = File.read('test_input1.txt').chomp.split(',').map(&:to_i)

    @canned_input = input
    @output = nil
    @first_input = true

    @current_index = 0
    @waiting = true
  end

  def run_program
    @waiting = false
    while(@program[@current_index] != 99 && !@waiting) do
      #puts "Amp #{@phase_setting} current index: #{@current_index}"
      first_value = @program[@current_index]
      deconstructed_array = deconstruct_first_value(first_value)
      opt_code = deconstructed_array.first
      instruction = @program[@current_index..@current_index+INSTRUCTIONS[opt_code][:steps]-1]
      params = evaluate_params(instruction, deconstructed_array)

      new_index = method(INSTRUCTIONS[opt_code][:method]).call(params)
      @current_index = new_index
    end

    if @child_amp&.waiting
      @child_amp.run_program
    end
  end

  private

  def execute_1(params)
    @program[params.last[:param]] = value_of_param(params.first) +
      value_of_param(params.fetch(1))
    @current_index + INSTRUCTIONS[1][:steps]
  end

  def execute_2(params)
    @program[params.last[:param]] = value_of_param(params.first) *
      value_of_param(params.fetch(1))
    @current_index + INSTRUCTIONS[2][:steps]
  end

  def execute_3(params)
    input = if @first_input
      @first_input = false
      @phase_setting 
    end

    input ||= if @canned_input
      temp = @canned_input
      @canned_input = nil
      temp
    end

    input ||= if @parent_amp.output
      temp = @parent_amp.output
      @parent_amp.output = nil
      temp
    end
    #puts "input is #{input}"
    
    if input
      @program[params.last[:param]] = input
      @current_index + INSTRUCTIONS[3][:steps]
    else
      @waiting = true
      @current_index
    end
  end

  def execute_4(params)
    @output = @program[params.last[:param]]
    puts "output is #{@output}"
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
    @program[params.last[:param]] =
      if value_of_param(params.first) <
        value_of_param(params.fetch(1))
        1
      else
        0
      end

    @current_index + INSTRUCTIONS[7][:steps]
  end

  def execute_8(params)
    @program[params.last[:param]] =
      if value_of_param(params.first) == value_of_param(params.fetch(1))
        1
      else
        0
      end

    @current_index + INSTRUCTIONS[8][:steps]
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

  def value_of_param(param)
    return @program[param[:param]] if param[:mode] == 0
    param[:param]
  end
end

results = []

[0,1,2,3,4].permutation.to_a.each do |permutation|
  amp1 = Amp.new(phase_setting: permutation.first, input: 0)
  amp2 = Amp.new(phase_setting: permutation.fetch(1), parent_amp: amp1)
  amp3 = Amp.new(phase_setting: permutation.fetch(2), parent_amp: amp2)
  amp4 = Amp.new(phase_setting: permutation.fetch(3), parent_amp: amp3)
  amp5 = Amp.new(phase_setting: permutation.fetch(4), parent_amp: amp4)

  #set child relationships
  amp1.child_amp = amp2
  amp2.child_amp = amp3
  amp3.child_amp = amp4
  amp4.child_amp = amp5

  amp1.run_program

  results << amp5.output
end

puts results.max
