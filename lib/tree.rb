require_relative 'node'

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
    root
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
      elsif node.right
        node = node.right
      else
        node.right = Node.new(value)
        @array << value
        return
      end
    end
  end

  def delete(value, node = @root)
    return nil if !node || !@array.include?(value)

    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      return node.right unless node.left
      return node.left unless node.right

      next_smallest = node.right
      while next_smallest.left
        next_smallest_value = next_smallest.left.data
        next_smallest = next_smallest.left
      end
      node.data = next_smallest_value
      node.right = delete(next_smallest_value, node.right)
    end
    @array = @array.reject { |n| n === value }
    node
  end

  def find(value, node = @root)
    return nil unless node

    if value <  node.data
      node.left = find(value, node.left)
    elsif value > node.data
      node.right = find(value, node.right)
    else
      node
    end
  end

  def level_order
    cur = @root
    return nil unless cur

    queue = [cur]
    values = []
    while queue.any?
      yield cur if block_given?
      values << cur.data
      queue << cur.left if cur.left
      queue << cur.right if cur.right
      queue.shift
      cur = queue.first
    end
    return values unless block_given?
  end

  def inorder(node = @root, values = [], &block)
    return unless node

    inorder(node.left, values, &block)
    yield node if block_given?
    values << node.data
    inorder(node.right, values, &block)
    return values unless block_given?
  end

  def preorder(node = @root, values = [], &block)
    return unless node

    yield node if block_given?
    values << node.data
    preorder(node.left, values, &block)
    preorder(node.right, values, &block)
    return values unless block_given?
  end

  def postorder(node = @root, values = [], &block)
    return unless node

    postorder(node.left, values, &block)
    postorder(node.right, values, &block)
    yield node if block_given?
    values << node.data
    return values unless block_given?
  end

  def height(node = @root)
    return -1 unless node

    left_height = height(node.left)
    right_height = height(node.right)
    [left_height, right_height].max + 1
  end

  def depth(value, root = @root)
    return -1 unless root

    dist = -1
    if value == root.data ||
       (dist = depth(value, root.left)) > -1 ||
       (dist = depth(value, root.right)) > -1
      return dist + 1
    end

    dist
  end

  def balanced?(root = @root)
    (height(root.left) - height(root.right)).abs < 2
  end

  def rebalance
    array = inorder.uniq.sort { |a, b| a - b }
    @root = build_tree(array, 0, array.length - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end
