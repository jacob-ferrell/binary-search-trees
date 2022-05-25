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
    root.left = build_tree(array, start, mid - 1)
    root.right = build_tree(array, mid + 1, last)
    return root
  end

  def insert(value)
    return if @array.include?(value)
    node = @root
    while node
      if value < node.data
        if node.left
          node = node.left
        else
          node.left = Node.new(value)
          @array << value
          return
        end
      else
        if
          node.right
          node = node.right
        else
          node.right = Node.new(value)
          @array << value
          return
        end
      end
    end
  end

  def delete(value, node=@root)
    return nil if !node || !@array.include?(value)
    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      return node.right if !node.left 
      return node.left if !node.right 
      next_smallest = node.right
      while next_smallest.left
        next_smallest_value = next_smallest.left.data
        next_smallest = next_smallest.left
      end
        node.data = next_smallest_value
        node.right = delete(next_smallest_value, node.right)
    end
    @array = @array.reject { |n| n === value }
    return node
  end

  def find(value, node=@root)
    return nil if !node
    if value <  node.data
      node.left = find(value, node.left)
    elsif value > node.data
      node.right = find(value, node.right)
    else
      return node
    end
  end

  def level_order
    return nil if !block_given?
    cur = @root
    return nil if !cur
    queue = [cur]
    while queue.any?
      yield cur  
      queue << cur.left if cur.left
      queue << cur.right if cur.right
      queue.shift
      cur = queue.first  
    end
  end

  def inorder(node=@root, values=[], &block)
    return if !node
    inorder(node.left, values, &block)
    yield node if block_given?
    values << node.data
    inorder(node.right, values, &block)
    return values if !block_given?
  end

  def preorder(node=@root, values=[], &block)
    return if !node
    yield node if block_given?
    values << node.data
    preorder(node.left, values, &block)
    preorder(node.right, values, &block)
    return values if !block_given?
  end
end

t = Tree.new([9,8,7,6,5,4,3,2,1])
t.preorder { |node| p node.data}

