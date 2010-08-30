require "lib/graph"

graph = Graph.new('MyGraph')

graph.add_vertices(%w(a b c))  #Caso Base. Grafo completo de n = 3.
graph.connect('a', 'b')  ## OR can be graph.connect('a','b','c') and we save 1 line! :D
graph.connect('a','c')
graph.connect('b','c')

# 
#graph.add_vertices(%w(1 2 3 4 5 6 e f))

# Conectamos el primer nodo a, con todos los que le siguen.
#graph.connect('1', '2')
#graph.connect('2', '3')
#graph.connect('3', '4')
#graph.connect('4', '5')
#graph.connect('5', '6')
#graph.connect('4','5')
#graph.connect('e','f')

graph.to_s
graph.hamilton_circuit
graph.euler_circuit

