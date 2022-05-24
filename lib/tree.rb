require_relative 'node.rb'

class Tree
  attr_accessor :root

  def initialize(array)
    @array = array.uniq.sort { |a, b| a - b }
    @root = build_tree(@array, 0, @array.length - 1)
  end

  def build_tree(array, start, last)
    return nil if start > last
    mid = (start + last) / 2
    root = Node.new(array[mid])
    root.left_child = build_tree(array, start, mid - 1)
    root.right_child = build_tree(array, mid + 1, last)
    return root
  end

  def insert(value)
    return if @array.include?(value)
    node = @root
    while node
      if value < node.data
        if node.left_child
          node = node.left_child
        else
          node.left_child = Node.new(value)
          @array << value
          return
        end
      else
        if
          node.right_child
          node = node.right_child
        else
          node.right_child = Node.new(value)
          @array << value
          return
        end
      end
    end
  end
end

t = Tree.new([9,8,7,6,5,4,3,2,1])
t.insert(0)
p t.root.left_child.left_child.left_child.data
