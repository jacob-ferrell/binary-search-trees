require_relative 'tree.rb'

tree = Tree.new(Array.new(15) { rand(1..100) })
tree.balanced?
tree.pretty_print
puts "Level Order: #{tree.level_order}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "In Order: #{tree.inorder}"
for i in (1..5).to_a do 
  tree.insert(i + 100) 
end
tree.pretty_print
tree.balanced?
tree.rebalance
tree.balanced?
tree.pretty_print
puts "Level Order: #{tree.level_order}"
puts "Preorder: #{tree.preorder}"
puts "Postorder: #{tree.postorder}"
puts "In Order: #{tree.inorder}"
