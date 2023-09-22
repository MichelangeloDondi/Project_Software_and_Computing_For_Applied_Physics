#=
main:
- Julia version: 
- Author: mdond
- Date: 2023-09-22
=#

# Inizialmente assumiamo solo resistenze

# Definiamo il numero N_n di nodi esistenti e gli assegnamo il nome di default n1, n2, ..., n'N_n'

# Costruiamo la lista degli N_a archi esistenti e gli assegnamo il nome di default a1, a2, ..., a'N_a'
# L'arco a'i' ha in parallelo N_'i'_p componenti e gli assegnamo il nome di default c1, c2, ..., c'N_'i'_p'

# Ogni componente ha una tipologia (resistenza, batteria, etc) decisa dall'utente,
# (inizialmente a scelta tra quelle predefinite del programma, poi quando verrà implementato
# il punto 5 potranno essere anche definite nuove tipologie dall'utente

# Ogni tipologia ha un suo simbolo/immagine e un parametri numerici con le eventuali unità di misura

#??? Accetto anche nodi con un solo arco?

###########################################################

# using Pkg
# Pkg.add("Subscripts")
# using Subscripts

#################################
# File utilizzati
#################################

using Luxor

include("DrawCircuit.jl")

####################################################
# Hardcode di un grafo con R1 ed R2 in parallelo tra loro e in serie con R3 ed R4
####################################################

# Number of nodes
N_n = 5

# Number of archs
N_a = 2

# Radius of the cicle circumscribed to polygon
polygon_radius = 300
# x offset of the graph respectto
x_offset = - 400

# Manually specify node positions in a circular layout
node_positions =  [(polygon_radius * sin(2* pi * (i-1) / N_n) + x_offset, - polygon_radius * cos(2 * pi * (i-1) / N_n)) for i in 1:N_n]

println(node_positions) #
"""
# Arco a1
R1 = "R1 = " * string(20) * " [Ω]"
R2 = "R2 = " * string(3) * " [Ω]"
a1_components = [R1, R2]
a1_components_string = string(a1_components[1]) * ", " * string(a1_components[2])
a1 = [1, 2, a1_components_string]

# Arco a2
R3 = "R3 = " * string(25) * " [Ω]"
a2_components = [R3]
a2_components_string = string(a2_components[1])
a2 = [2, 4, a2_components_string]

# Arco a3
R4 = "R4 = " * string(10) * " [Ω]" # [Ω]
a3_components = [R4]
a3_components_string = string(a3_components[1])
a3 = [4, 1, a3_components_string]
"""

struct Component
    name::String
    type::String
    magnitude::String
end

struct Arc
    name::String
    node_in::Int
    node_out::Int
    components::Vector{Component}
end

# Function to append components to an existing Arco
append_components!(arc::Arc, new_components::Vector{Component}) = push!(arc.components, new_components...)


"""
my_arc = Arc("my_arc",5,1)
my_components = ["R1 = 5 [Ω]", "R2 = 2 [Ω]"]
append_components!(my_arc, my_components)
print(my_arc)
"""
archs = Vector{Arc}()

for i in 1:N_a
    println("Enter arc initial node: ")
    node_in = parse(Int,readline())
    println("Enter arc end node: ")
    node_out = parse(Int,readline())
    arc = Arc("a"*string(i),node_in,node_out, [])
    println("Enter components: ")

    while true
        println("Enter component name: ")
        name = readline()
        println("Enter type: ")
        type = readline()
        println("Enter magnitude: ")
        magnitude = readline()
        component = Component(name,type,magnitude)
        push!(arc.components,component)
        println("More Arc Components? [Y/N]")
        is_finished = readline()
        if is_finished == "N"
            break
        end
    end
    push!(archs,arc)
end

for i in 1:N_a
    println(archs[i])
end
# Arradius degli archi
#archs = [a1, a2, a3]

#############################################
# disegno del grafo verde su sfondo nero
############################################

@png begin

    background("black") # background color

    #################################
    # Disegno degli archi
    #################################

    setline(3) # linewidth
    setcolor("green") # line color

    for i in 1:N_a

        line( # drawing arch a_i
        Point(node_positions[archs[i].node_out]), # outcoming node
        Point(node_positions[archs[i].node_in]) #incoming node
        )

    end

    strokepath() # disegna le linee precedentemente definite

    #################################
    # Descrizione degli archi nella legenda
    #################################

    sethue("skyblue")
    fontsize(34)

    posizione_inizio_legenda = Point(- polygon_radius - x_offset, -400)

    for i in 1:N_a
        all_components_string = ""
        for comp in archs[i].components
            all_components_string *= comp.name*" = "*comp.magnitude*"\\n"
        end
        text(
            "a"*string(i)*") N"*string(archs[i].node_out)*"->N"*string(archs[i].node_in)*": "*all_components_string,
            posizione_inizio_legenda + i .* (0, 50)
            )

    end

    #################################
    # Disegno dei nodi
    #################################

    sethue("red")
    fontsize(28)

    for i in 1:N_n

        text(
            "N" * string(i),
            1.1 .* (Point(node_positions[i]) - (x_offset,0)) + (x_offset,0),
            halign = :center,
            valign = :middle
            )

    end

    #################################
    # Aggiunge descrizione del grafo
    #################################

    sethue("white")
    fontsize(40)

    text("Questo è un grafo con archi verdi e nodi rossi che rappresenta un circuito elettrico chiuso", Point(0, 400), halign=:center)

end 1618 1000 "grafo1.png"


























#=

# Define the vert
ices
num_vertices = 3
vertices = 1:num_vertices

# Define the edges
edges = [(1, 2), (2, 3)]

# Create the graph
g = SimpleGraph(num_vertices)

# Add edges to the graph
for (src, dst) in edges
    add_edge!(g, src, dst)
end

# Manually specify node positions in a circular layout
#theta = range(0, stop=2π, length=num_vertices)
#radius = 1.0
#x_positions = radius .* cos.(theta)
#y_positions = radius .* sin.(theta)
#node_positions = [(x_positions[i], y_positions[i]) for i in 1:num_vertices]
g_graph = Graph(g)

function my_spring_layout(g::SimpleGraph{Int64},
                       locs_x=2*rand(nv(g)).-1.0,
                       locs_y=2*rand(nv(g)).-1.0;
                       C=2.0,
                       MAXITER=100,
                       INITTEMP=2.0)

    nvg = nv(g)
    adj_matrix = adjacency_matrix(g)

    # The optimal distance bewteen vertices
    k = C * sqrt(4.0 / nvg)
    k² = k * k

    # Store forces and apply at end of iteration all at once
    force_x = zeros(nvg)
    force_y = zeros(nvg)

    # Iterate MAXITER times
    @inbounds for iter = 1:MAXITER
        # Calculate forces
        for i = 1:nvg
            force_vec_x = 0.0
            force_vec_y = 0.0
            for j = 1:nvg
                i == j && continue
                d_x = locs_x[j] - locs_x[i]
                d_y = locs_y[j] - locs_y[i]
                dist²  = (d_x * d_x) + (d_y * d_y)
                dist = sqrt(dist²)

                if !( iszero(adj_matrix[i,j]) && iszero(adj_matrix[j,i]) )
                    # Attractive + repulsive force
                    # F_d = dist² / k - k² / dist # original FR algorithm
                    F_d = dist / k - k² / dist²
                else
                    # Just repulsive
                    # F_d = -k² / dist  # original FR algorithm
                    F_d = -k² / dist²
                end
                force_vec_x += F_d*d_x
                force_vec_y += F_d*d_y
            end
            force_x[i] = force_vec_x
            force_y[i] = force_vec_y
        end
        # Cool down
        temp = INITTEMP / iter
        # Now apply them, but limit to temperature
        for i = 1:nvg
            fx = force_x[i]
            fy = force_y[i]
            force_mag  = sqrt((fx * fx) + (fy * fy))
            scale      = min(force_mag, temp) / force_mag
            locs_x[i] += force_x[i] * scale
            locs_y[i] += force_y[i] * scale
        end
    end

    # Scale to unit square
    min_x, max_x = minimum(locs_x), maximum(locs_x)
    min_y, max_y = minimum(locs_y), maximum(locs_y)
    function scaler(z, a, b)
        2.0*((z - a)/(b - a)) - 1.0
    end
    map!(z -> scaler(z, min_x, max_x), locs_x, locs_x)
    map!(z -> scaler(z, min_y, max_y), locs_y, locs_y)

    return locs_x, locs_y
end

# Create the plot with specified node positions
plot = gplot(g_graph, nodelayout=my_spring_layout(g), nodefillc="lightblue", nodelabel=1:num_vertices, nodefontsize=10)

# Display the plot on screen
display(plot)

=#





#DrawCircuit()

