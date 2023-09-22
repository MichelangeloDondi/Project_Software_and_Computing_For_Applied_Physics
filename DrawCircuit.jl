"""
    DrawCircuit()

- Julia version: 
- Author: mdond
- Date: 2023-09-22

# Arguments

# Examples

```jldoctest
julia>
```
"""


function DrawCircuit()
   # Create the graph
g = SimpleGraph(num_vertices)

# Add edges to the graph
for (src, dst) in edges
    add_edge!(g, src, dst)
end

# Create the plot
plot = gplot(g, nodefillc="lightblue", nodelabel=1:num_vertices, nodefontsize=10)

# Display the plot on screen
savefig("graph_plot.png", plot)

println(pwd())
end