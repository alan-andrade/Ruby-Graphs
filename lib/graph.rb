require 'lib/vertex'

class Graph

def initialize(name) #Graph Constructor.
	@name = name
	@vertices = []
	@edges = 0
end

def add_vertices(vertices)
	for vertex in vertices
		@vertices << Vertex.new(vertex)
	end			
end

def connect(vertex1, *vertex2) #Connect to two vertices from the graph. We give the LABEL of the Vertex.
	v1 = find(vertex1)
	for vertex in vertex2 		
		if v1.connect(find(vertex))
			@edges += 1
		end
	end
end

def find(vertex_label) #We find a vertex with a label given.
	for vertex in @vertices
		if vertex.label == vertex_label
			return vertex 
			break
		end
	end
end

def has_euler_circuit? # We ask if it has an euler circuit! Returns True or False.
	odd_vertices = count_odd_vertices
	if odd_vertices == 0
		print "\nThere is an Euler Circuit! =D\n"
		true
	else
		print "\nThere is not an Euler Circuit! =(\n"
		false
	end		
end

def euler_circuit		
	if has_euler_circuit?
		print "\n..:: Calculatin Euler Circuit ::..\n"
		# Calculating  the Euler Circuit.			
		circuit = [] # An array where the circuit will be stored.
		starting_vertex = random_vertex # We start from a random Vertex.
		edge_counter = 0 # We count the Edges as we walk throught them.			
		while edge_counter != @edges do
			circuit << starting_vertex.label 
			next_edge = select_next_edge(starting_vertex)
			edge_counter += 1
			starting_vertex = next_edge
		end
		circuit << starting_vertex.label  ## We add the first vertex just to close the circtui.
		
		print "\n\n####::::::.........  Euler Circuit .........:::::::::######### \n\n"
		print "\t\t"
		print circuit.inspect + "\n"
		print "\n\n"	
		end
end

def hamilton_circuit
		for vertex in @vertices
			if vertex.degree ==1 
				print "VERTEX WITH DEGREE ONE. NO HAMILTON CIRCUIT\n"
				exit
			end
		end
    print "\nCalculating the Hamilton Circuit\n"        
	  # ore_theorem Algoritmo que se seguira para hacer el camino hamiltoniano.
	  # Create false connections.
	  make_false_connections
	  hamilton = [] # Vertices into hamilton array to manipulate them
	  array_of_connections=[]
	  for vertex in @vertices; 	hamilton << vertex;	  end	  
	  update_array_of_connections(hamilton, array_of_connections)  	  		
		maxheaps = array_of_connections.size-3		
		#for a in 1..10
		while array_of_connections.member?(0)
			print "\n\nNew loop\n"
		  print hamilton.map{|a| a.label}
		  puts
  		print array_of_connections
  		puts
  		
			for index in 2..maxheaps+1
			print "INDEX: #{index}\n"
				if hamilton[0].connected?(hamilton[index]) == :real	
					if index == 2 
						puts "Normal"
						temp = hamilton[index-1]
						hamilton[1] = hamilton[index]
						hamilton[index] = temp
					else
						hamiltoncopy = hamilton.map{|a| a}
						hamilton[1] = hamilton[index]
						hamilton[2] = hamilton[index-1]
						hamilton[3] = hamilton[index+1]			
						for a in 1..index-2
							hamilton[a*(-1)] = hamiltoncopy[a]
						end
						### More Action
					end # end if index == maxheaps
					update_array_of_connections(hamilton,array_of_connections)										
				end #end if hamilton connected?								
			end #end FOR
			if array_of_connections.member?(0)														
					puts "Shift one"
					temp = hamilton[0]
					hamilton.each_index do |newindex|
						hamilton[newindex] = (hamilton[newindex+1] || temp)
					end
					update_array_of_connections(hamilton,array_of_connections)	
			end
		end # End While
		
		print "\n\n####::::::.........  Hamilton Circuit .........:::::::::######### \n\n"
		print "\t\t"
		print hamilton.map{|vertex| vertex.label}
		print "\n\n\n"
end # end def

def update_array_of_connections(hamilton, array_of_connections)
		hamilton.each_index do |index|
  	if hamilton[index].connected?(hamilton[index+1] || hamilton[0]) == :real
  		array_of_connections[index] = 1
  	elsif hamilton[index].connected?(hamilton[index+1] || hamilton[0]) == :falseconnection
  		array_of_connections[index] = 0
  	else
  		array_of_connections[index] = 0
  	end
  end
end

def make_false_connections
	for vertex in @vertices	
	  	if !vertex.visited?
	  	nonadjacent = non_adjacent_vertices(vertex)
	  		for vertexnonadjacent in nonadjacent
					vertex.falseconnect(vertexnonadjacent)
	  		end
	  	end
	  end
end

def dirac_theorem
	# If G is a simple graph with n vertices with n>= 3 such that the degree of every vertex
	# in G is at least n/2 then G has a hamilton circuit.
	vertices_with_condition = []
	n2 = @vertices.size/2
	puts n2
	@vertices.each do |vertex|
		puts vertex.degree
		if vertex.degree >= n2
			vertices_with_condition << vertex
		end
	end
	
	if vertices_with_condition.size == @vertices.size
		return true
	else
		return false
	end	
end

def ore_theorem
	# If G is  a simple graph with n vertices with n>=3 such that degree(u) + degree(v) >= n for every
	# pair of non-adjacent vertices u and v in G. then G has Hamilton Circuit.
	v = random_vertex; v.turn_visited
	u = first_non_adjacent(v); u.turn_visited
	unless u.degree + v.degree >= @vertices.size
		
	end 
end

def non_adjacent_vertices(vertex)
	vertexedges = vertex.edges  ## Just the label
	vertexedges << vertex.label
	graphs_vertices =  @vertices.map{|vertex| vertex.label } #Just the Label
	nonadjacentlabels = graphs_vertices - vertexedges
	nonadjacentvertices = []
	for vertexlabel in nonadjacentlabels
		vertextoadd = find(vertexlabel)		
		# Verify the degree of both.
		unless (vertex.degree + vertextoadd.degree) >= @vertices.size
			nonadjacentvertices << vertextoadd unless vertextoadd.visited?
		end
	end	
	nonadjacentlabels = nil
	nonadjacentvertices
end
	
def select_next_edge(given_vertex)			
	if given_vertex.degree == 1  ## If is the only path. Return it!			
		edge_v = find(given_vertex.edges.first)
		given_vertex.disconnect(edge_v)
		edge_v
	else		## If not. Do some Magic Man!		
		# @vertex = nil   @@ May be not necesary.
		for vertex_label in given_vertex.edges
			vertex = find(vertex_label)
			given_vertex.disconnect(vertex)
			if still_connected?(given_vertex, vertex)
				return vertex
				break
			else
				given_vertex.connect(vertex)
			end			
		end
		
	end
end

def still_connected?(v1,v2)
	visit(v1)		
	if v1.visited? and v2.visited?
		unvisit_all_vertices
		true
	else
		unvisit_all_vertices
		false				
	end
	
end

def visit(vertex)
	## Recursion to check that every vertex still connected with each other.
	vertex.turn_visited		
	for vertex_edge in vertex.edges
		v = find(vertex_edge)
		unless v.visited?
			visit(v)
		end			
	end			
end

def unvisit_all_vertices
	for vertex in @vertices
		vertex.turn_unvisited
	end
	
end	

def count_odd_vertices
	odd_vertices = 0
	for vertex in @vertices
		if (vertex.degree % 2 != 0)
			odd_vertices += 1
		end
	end
	odd_vertices
end

def random_vertex
	@vertices.at(rand(@vertices.size))
end


def to_s # Just to print the Graph Nicely. =D
	print "\n Grapho's Name: " + @name + " \n"
	for vertex in @vertices
		print vertex.label + "--> "
		print vertex.edges.inspect + "\n"
	end
end

end

