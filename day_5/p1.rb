require 'pry'

input = File.read('input1.txt').chomp

program = input.split(',').map(&:to_i)

INSTRUCTIONS = {
  1=> { steps: 4, method: :execute_1 },
  2=> { steps: 4, method: :execute_2 },
  3=> { steps: 2, method: :execute_3 },
  4=> { steps: 2, method: :execute_4 },
}

def execute_1(program, params)
  program[params.last[:param]] = value_of_param(params.first, program) +
    value_of_param(params.fetch(1), program)
end

def execute_2(program, params)
  program[params.last[:param]] = value_of_param(params.first, program) *
    value_of_param(params.fetch(1), program)
end

def execute_3(program, params)
  program[params.last[:param]] = 1
end

def execute_4(program, params)
  puts program[params.last[:param]]
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

def value_of_param(param, program)
  return program[param[:param]] if param[:mode] == 0
  param[:param]
end

def run_program(program)
  current_index = 0
  while(program[current_index] != 99) do
    first_value = program[current_index]
    deconstructed_array = deconstruct_first_value(first_value)
    opt_code = deconstructed_array.first
    instruction = program[current_index..current_index+INSTRUCTIONS[opt_code][:steps]-1]
    params = evaluate_params(instruction, deconstructed_array)

    method(INSTRUCTIONS[opt_code][:method]).call(program, params)
    current_index+=INSTRUCTIONS[opt_code][:steps]
  end
end

run_program(program)
