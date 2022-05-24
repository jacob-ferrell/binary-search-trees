require_relative 'node.rb'

class Tree
  attr_accessor :root

  def initialize(array)
    p array
    @array = array.uniq.sort { |a, b| a - b }
    p @array
    @root = build_tree(@array, 0, @array.length - 1)
  end

  def build_tree(array, start, last)
    return if start > last
    mid = (start + last) / 2
    root = Node.new(array[mid])
    root.left_child = build_tree(array, start, mid - 1)
    root.right_child = build_tree(array, mid + 1, last)
    return root
  end
end

print Tree.new([9,8,7,6,5,4,3,2,1]).root.right_child.data