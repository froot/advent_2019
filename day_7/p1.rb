require 'pry'

input = File.read('test_input1.txt').chomp

program = input.split(',').map(&:to_i)

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

def execute_1(program, params, current_index,_,_)
  program[params.last[:param]] = value_of_param(params.first, program) +
    value_of_param(params.fetch(1), program)
    current_index + INSTRUCTIONS[1][:steps]
end

def execute_2(program, params, current_index,_,_)
  program[params.last[:param]] = value_of_param(params.first, program) *
    value_of_param(params.fetch(1), program)
    current_index + INSTRUCTIONS[2][:steps]
end

def execute_3(program, params, current_index, inputs,_)
  program[params.last[:param]] = inputs.shift
  current_index + INSTRUCTIONS[3][:steps]
end

def execute_4(program, params, current_index,_,outputs)
  outputs << program[params.last[:param]]
  current_index + INSTRUCTIONS[4][:steps]
end

def execute_5(program, params, current_index,_,_)
  if value_of_param(params.first, program) != 0
    return value_of_param(params.last, program)
  end
  current_index + INSTRUCTIONS[5][:steps]
end

def execute_6(program, params, current_index,_,_)
  if value_of_param(params.first, program) == 0
    return value_of_param(params.last, program)
  end
  current_index + INSTRUCTIONS[6][:steps]
end

def execute_7(program, params, current_index,_,_)
  program[params.last[:param]] =
    if value_of_param(params.first, program) <
      value_of_param(params.fetch(1), program)
      1
    else
      0
    end

  current_index + INSTRUCTIONS[7][:steps]
end

def execute_8(program, params, current_index,_,_)
  program[params.last[:param]] =
    if value_of_param(params.first, program) ==
      value_of_param(params.fetch(1), program)
      1
    else
      0
    end

  current_index + INSTRUCTIONS[8][:steps]
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

def run_program(program, inputs)
  current_index = 0
  outputs = []
  while(program[current_index] != 99) do
    first_value = program[current_index]
    deconstructed_array = deconstruct_first_value(first_value)
    opt_code = deconstructed_array.first
    instruction = program[current_index..current_index+INSTRUCTIONS[opt_code][:steps]-1]
    params = evaluate_params(instruction, deconstructed_array)

    new_index = method(INSTRUCTIONS[opt_code][:method]).call(program, params, current_index, inputs, outputs)
    current_index = new_index
  end

  outputs
end

results = []

[0,1,2,3,4].permutation.to_a.each do |permutation|
  program_1 = program.dup
  program_2 = program.dup
  program_3 = program.dup
  program_4 = program.dup
  program_5 = program.dup

  output1 = run_program(program_1, [permutation.first,0])
  output2 = run_program(program_2, [permutation.fetch(1),output1.first])
  output3 = run_program(program_3, [permutation.fetch(2),output2.first])
  output4 = run_program(program_4, [permutation.fetch(3),output3.first])
  output5 = run_program(program_5, [permutation.fetch(4),output4.first])
  results << output5.first
end

puts results.max
