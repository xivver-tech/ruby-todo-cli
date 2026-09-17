#!/usr/bin/env ruby
# Simple Todo CLI in Ruby

require 'json'

TODO_FILE = 'todos.json'

def load_todos
  return [] unless File.exist?(TODO_FILE)
  JSON.parse(File.read(TODO_FILE))
end

def save_todos(todos)
  File.write(TODO_FILE, JSON.pretty_generate(todos))
end

def show(todos)
  if todos.empty?
    puts "  (no todos)"
  else
    todos.each_with_index do |t, i|
      status = t['done'] ? '[x]' : '[ ]'
      puts "  #{i + 1}. #{status} #{t['text']}"
    end
  end
end

puts "=== Ruby Todo CLI ==="
puts "Commands: add <text> | done <n> | delete <n> | list | quit\n"

todos = load_todos

loop do
  print "> "
  input = gets&.strip
  break if input.nil? || input.empty?

  parts = input.split(' ', 2)
  cmd = parts[0].downcase

  case cmd
  when 'quit', 'exit', 'q'
    puts "Bye!"
    break
  when 'list', 'ls'
    show(todos)
  when 'add'
    if parts[1]
      todos << { 'text' => parts[1], 'done' => false }
      save_todos(todos)
      puts "Added: #{parts[1]}"
    else
      puts "Usage: add <text>"
    end
  when 'done'
    idx = parts[1].to_i - 1
    if idx.between?(0, todos.length - 1)
      todos[idx]['done'] = true
      save_todos(todos)
      puts "Done: #{todos[idx]['text']}"
    else
      puts "Invalid number"
    end
  when 'delete'
    idx = parts[1].to_i - 1
    if idx.between?(0, todos.length - 1)
      removed = todos.delete_at(idx)
      save_todos(todos)
      puts "Deleted: #{removed['text']}"
    else
      puts "Invalid number"
    end
  else
    puts "Unknown command"
  end
end
