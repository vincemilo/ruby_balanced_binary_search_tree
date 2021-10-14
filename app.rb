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

  def inorder(node = root)
    # left root right
    return if node.nil?

    inorder(node.left)
    print "#{node.data} "
    inorder(node.right)
  end

  def preorder(node = root)
    # root left right
    return if node.nil?

    print "#{node.data} "
    preorder(node.left)
    preorder(node.right)
  end

  def postorder(node = root)
    # left right root
    return if node.nil?

    postorder(node.left)
    postorder(node.right)
    print "#{node.data} "
  end

  # height: number of edges from node to lowest leaf of its subtree

  def height(node = root)
    unless node.nil? || node == root
      node = (node.instance_of?(Node) ? find(node.data) : find(node))
    end
    return -1 if node.nil?

    [height(node.left), height(node.right)].max + 1
  end

  # depth: number of edges from root to given node

  def depth(node = root, parent = root, edges = 0)
    return 0 if node == parent
    return -1 if node.nil?

    if node < parent.data
      edges += 1
      depth(node, parent.left, edges)
    elsif node > parent.data
      edges += 1
      depth(node, parent.right, edges)
    else
      edges
    end
  end

  # balanced?: difference between height of left and right subtree not > 1

  def balanced?(node = root)
    return true if node.nil?

    left_height = height(node.left)
    right_height = height(node.right)

    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

    false
  end

  def rebalance
    @data = ordered_array
    @root = build_tree(data)
  end

  def ordered_array(node = root, arr = [])
    unless node.nil?
      ordered_array(node.left, arr)
      arr.push(node.data)
      ordered_array(node.right, arr)
    end
    arr
  end
end

arr = Array.new(15) { rand(1..100) }
bst = Tree.new(arr)
bst.pretty_print
bst.insert(101)
bst.insert(3000)
bst.insert(9999)
bst.pretty_print
puts 'Is the tree balanced?'
p bst.balanced?
puts 'Rebalancing...'
bst.rebalance
puts 'Is the tree balanced?'
p bst.balanced?
bst.pretty_print
puts 'Preorder'
puts bst.preorder
puts 'Inorder'
puts bst.inorder
puts 'Postorder'
puts bst.postorder
