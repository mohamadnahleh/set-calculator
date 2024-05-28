# Mohamad Nahleh

# Definition of class Node
# representing a node in a binary search tree.
class Node
  attr_accessor :value, :left, :right

  # Initialize a new node with a given value.
  def initialize(value)
    @value = value
    @left = nil
    @right = nil
  end
end

# Definition of class SetBST
# representing a binary search tree for set operations.
class SetBST
  attr_accessor :root

  # Initialize an empty binary search tree.
  def initialize
    @root = nil
  end

  # Insert a value into the binary search tree.
  def insert(value)
    @root = insert_recursive(@root, value)
  end

  # Perform an inorder traversal of the binary search tree.
  def inorder_traversal(node = @root)
    return if node.nil?

    inorder_traversal(node.left)
    print "#{node.value} "
    inorder_traversal(node.right)
  end

  private

  # Recursively insert a value into the binary search tree.
  def insert_recursive(node, value)
    return Node.new(value) if node.nil?

    if value < node.value
      node.left = insert_recursive(node.left, value)
    elsif value > node.value
      node.right = insert_recursive(node.right, value)
    end

    node
  end
end

# Definition of class SetCalculator
# performing set of operations using binary search trees.
class SetCalculator
  # Initialize a set calculator with three empty binary search trees labeled X, Y, and Z.
  def initialize
    @sets = { 'X' => SetBST.new, 'Y' => SetBST.new, 'Z' => SetBST.new }
  end

  # main loop for the set calculator.
  def run
    loop do
      print_sets
      print('Enter command>')
      input = gets.chomp.downcase
      puts
      execute_command(input)
    end
  end

  private

  # Print the contents of each set represented by their inorder traversal.
  def print_sets
    @sets.each do |name, set|
      print "#{name}: "
      set.inorder_traversal
      puts
    end
  end

  # Execute a command entered by the user.
  def execute_command(input)
    command, *args = input.split

    case command
    when 'x', 'y', 'z'
      set_name = command.upcase
      values = args[0].split(',').map(&:to_i)
      @sets[set_name] = build_set(values)
    when 'a'
      value = args[0].to_i
      @sets['X'].insert(value)
    when 'r'
      rotate_sets
    when 's'
      switch_sets
    when 'u'
      @sets['X'] = union(@sets['X'], @sets['Y'])
    when 'i'
      @sets['X'] = intersection(@sets['X'], @sets['Y'])
    when 'c'
      @sets['Y'] = deep_copy(@sets['X'])
    when 'l'
      expression = input[2..-1]
      apply_lambda(expression)
      puts
    when 'q'
      exit
    else
      puts "Invalid command... Try again."
    end
  end

  # Build a binary search tree from a given list of values.
  def build_set(values)
    set = SetBST.new
    values.each { |value| set.insert(value) }
    set
  end

  # Rotate the sets X, Y, and Z in a cyclic manner.
  def rotate_sets
    temp = @sets['X']
    @sets['X'] = @sets['Z']
    @sets['Z'] = @sets['Y']
    @sets['Y'] = temp
  end

  # Switch the sets X and Y.
  def switch_sets
    temp = @sets['X']
    @sets['X'] = @sets['Y']
    @sets['Y'] = temp
  end

  # Perform the union operation on two sets.
  def union(set1, set2)
    result = SetBST.new
    union_helper(set1.root, result)
    union_helper(set2.root, result)
    result
  end

  # Helper method for union operation.
  def union_helper(node, result)
    return if node.nil?

    union_helper(node.left, result)
    result.insert(node.value)
    union_helper(node.right, result)
  end

  # Perform the intersection operation on two sets.
  def intersection(set1, set2)
    result = SetBST.new
    intersection_helper(set1.root, set2, result)
    result
  end

  # Helper method for intersection operation.
  def intersection_helper(node, set, result)
    return if node.nil?

    intersection_helper(node.left, set, result)
    result.insert(node.value) if set_contains_value(set, node.value)
    intersection_helper(node.right, set, result)
  end

  # Check if a set contains a specific value.
  def set_contains_value(set, value)
    current = set.root
    while current
      return true if current.value == value

      if value < current.value
        current = current.left
      else
        current = current.right
      end
    end
    false
  end

  # Create a deep copy of a binary search tree.
  def deep_copy(set)
    result = SetBST.new
    deep_copy_helper(set.root, result)
    result
  end

  # Helper method for deep copy operation.
  def deep_copy_helper(node, result)
    return if node.nil?

    deep_copy_helper(node.left, result)
    result.insert(node.value)
    deep_copy_helper(node.right, result)
  end

  # Apply a lambda function to the values in set X.
  def apply_lambda(string)
    lambda_function = eval(string)
    new_value = []
    get_values(@sets['X'].root, new_value)
    new_value.map! { |value| lambda_function.call(value) }
    print("Lambda: " + new_value.join(' '))
  end

  # Get the values of a binary search tree in an array.
  def get_values(node, values)
    return if node.nil?

    get_values(node.left, values)
    values << node.value
    get_values(node.right, values)
  end
end

# Instantiate a SetCalculator object and start the calculator.
calculator = SetCalculator.new
calculator.run
