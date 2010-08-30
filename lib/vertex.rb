class Vertex

  attr_reader :label #Attributes that just have the GET action.
  attr_accessor :edges, :degree, :falseconnections #Attributes with the GET and SET action.

  def initialize(label)
    @label = label
    @edges = []
    @falseconnections = []
    @degree = 0
    @visited = false
  end
  
  def connect(vertex)
    unless @edges.include?(vertex.label)
      @edges << vertex.label
      @degree += 1
      vertex.edges << @label
      vertex.degree += 1
      print "\nSuccessfully Connected " + self.label + " --> " + vertex.label + "\n"
      true
    else
      print "\nAlready Connected\n"
      false       
    end   

  end
  
  def disconnect(vertex)
    if @edges.include?(vertex.label)
      vertex.edges.delete(@label)
      vertex.degree -= 1
      @edges.delete(vertex.label)
      @degree -= 1      
      print "\nVertex Disconnected #{@label} -- #{vertex.label}\n"
      true
    else
      print "\nCould not disconnect the Vertex.\n"
      false
    end  
  end 
  
  def falseconnect(vertex)
  	unless @falseconnections.include?(vertex.label)
  		@falseconnections << vertex.label
  		vertex.falseconnections << @label
  		print "False Connected #{@label} - #{vertex.label}\n"
  	end  	
  end
  
  def connected?(vertex)
  	if @edges.member?(vertex.label)
  		:real
 		elsif @falseconnections.member?(vertex.label)
 			:falseconnection
  	end
  end
  
  def turn_visited
    @visited = true
  end
  
  def turn_unvisited
    @visited = false
  end
  
  def visited?
    @visited
  end
  
end
