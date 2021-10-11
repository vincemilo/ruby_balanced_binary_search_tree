class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :root, :data

  def initialize(arr)
    @data = arr.uniq.sort
    @root = build_tree(data)
  end

  def build_tree(arr)
    return nil if arr.empty?

    mid = (arr.length - 1) / 2
    root = Node.new(arr[mid])
    root.left = build_tree(arr[0...mid])
    root.right = build_tree(arr[(mid + 1)..-1])
    root
  end

  # visualization method provided by fellow student

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(val, node = root)
    return nil if val == node.data

    if val < node.data
      node.left.nil? ? node.left = Node.new(val) : insert(val, node.left)
    else
      node.right.nil? ? node.right = Node.new(val) : insert(val, node.right)
    end
  end

  def leftmost_leaf(node)
    node = node.left until node.left.nil?
    node
  end

  def delete(val, node = root)
    return node if node.nil?

    if val < node.data
      node.left = delete(val, node.left)
    elsif val > node.data
      node.right = delete(val, node.right)
    else
      # if node has 1 or less children
      return node.right if node.left.nil?
      return node.left if node.right.nil?

      # if node has 2+ children
      leftmost_node = leftmost_leaf(node.right)
      node.data = leftmost_node.data
      node.right = delete(leftmost_node.data, node.right)
    end
    node
  end

  def find(val, node = root)
    return node if node.nil? || node.data == val

    if val < node.data
      find(val, node.left)
    else
      find(val, node.right)
    end
  end

  def level_order(node = root, queue = [], result = [])
    result.push(node.data)
    queue.push(node.left) unless node.left.nil?
    queue.push(node.right) unless node.right.nil?
    if queue.empty?
      puts result.to_s
      return
    end

    level_order(queue.shift, queue, result)
  end
end

arr = [6, 2, 3, 7, 5, 1, 4]
bst = Tree.new(arr)
bst.pretty_print
bst.insert(0)
bst.pretty_print
bst.delete(0)
bst.pretty_print
bst.delete(4)
bst.pretty_print
bst.find(3)
bst.level_order