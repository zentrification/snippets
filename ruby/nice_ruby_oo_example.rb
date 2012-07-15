class TodoList
    def self.load(file)
        # read the file, create a list, create items, add them to the list, return the list
        list = TodoList.new
        File.read(file).each_line do |line|
            list.add TodoItem.new(line.rstrip)
        end

        list
    end

    def initialize
        @list = []
    end

    def add(item)
        @list << item
    end

    def write(file)
        # write the file, only write the undone items
        File.open(file, 'w') do |f|
            f.write(@list.reject {|item| item.done?}.join("\n"))
        end
    end

    def [](id)
        @list[id]
    end
end

class TodoItem
    # provide reader and setter for name and state
    attr_accessor :name, :done
    alias_method :done?, :done

    def initialize(name)
        # store name
        # set state to undone
        @name = name
        @done = false
    end
end

# ---
# the library will be used like this:
# list = TodoList.load("todo.td")
# list[0].done = true
# list.add TodoItem.new("another cool item")
# list.write("todo.td")
#

list = TodoList.load("todo.td")
list[0].done = true

list.add TodoItem.new("Grow long hair for pro multitasking capabilities")
list.write("todo.td")
