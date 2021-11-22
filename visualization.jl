#=
note that every plotting function like scatterlines creates and returns a
new Figure, Axis and plot object in a collection called FigureAxisPlot. These are
known as the non−mutating methods. On the other hand, the mutating methods
(e.g. scatterlines!, note the !) just return a plot object which can be appended
into a given axis or the current_figure().

https://makie.juliaplots.org/v0.15.1/tutorials/basic-tutorial/
=#

using CairoMakie

function simple_sine_plot()
    x = range(0, 10, length=100)
    y = sin.(x)
    fig = lines(x, y)
    display(fig)
end

simple_sine_plot()

function simple_scatter_plot()
    x = range(0, 10, length=100)
    y = sin.(x)
    fig = scatter(x, y)
    display(fig)
end

simple_scatter_plot()

#=
Every plotting function has a version with and one without !. 
For example, there's scatter and scatter!, lines and lines!, etc. 
The functions without a ! always create a new axis with a plot inside, 
while the functions with ! plot into an already existing axis.

Here's how you could plot two lines on top of each other.
=#

x = range(0, 10, length=100)
y1 = sin.(x)
y2 = cos.(x)
lines(x, y1)
lines!(x, y2)
current_figure()

using CairoMakie

x = range(0, 10, length=100)
y1 = sin.(x)
y2 = cos.(x)
scatter(x, y1, color=:red, markersize = 10)
scatter!(x, y2, color = :blue, markersize = 20)
current_figure()

using CairoMakie
x = range(0, 10, length=100)
y1 = sin.(x)
y2 = cos.(x)
scatter(x, y1, color=:red, markersize = range(5, 15, length=100))
scatter!(x, y2, color = range(0, 1, length=100), colormap = :thermal)
current_figure()

using CairoMakie
x = range(0, 10, length=100)
y = sin.(x)
colors = repeat([:crimson, :dodgerblue, :slateblue1, :sienna1, :orchid1], 20)
scatter(x, y, color=colors, markersize=20)
current_figure()

# Simple Legend
using CairoMakie
x = range(0, 10, length=100)
y1 = sin.(x)
y2 = cos.(x)
lines(x, y1, color = :red, label = "sin")
lines!(x, y2, color = :blue, label = "cos")
axislegend()
current_figure()

# Subplots
using CairoMakie
x = LinRange(0, 10, 100)
y = sin.(x)

fig = Figure()
lines(fig[1, 1], x, y, color = :red)
lines(fig[1, 2], x, y, color = :blue) # note each lines creates new axis which is why lines! not used here
lines(fig[2, 1:2], x, y, color = :green)
fig

# Constructing Axes manually
using CairoMakie
fig = Figure()
ax1 = Axis(fig[1, 1])
ax2 = Axis(fig[1, 2])
ax3 = Axis(fig[2, 1:2])
fig

lines!(ax1, 0..10, sin)
lines!(ax2, 0..10, cos)
lines!(ax3, 0..10, sqrt)
fig

ax1.title = "sin" #Axis attribute
ax2.title = "cos"
ax3.title = "sqrt"
ax1.ylabel = "amplitude"
ax3.ylabel = "amplitude"
ax3.xlabel = "time"
fig


# Legend and Colorbar
using CairoMakie
fig = Figure()
ax1, l1 = lines(fig[1, 1], 0..10, sin, color = :red)
ax2, l2 = lines(fig[2, 1], 0..10, cos, color = :blue)
Legend(fig[1:2, 2], [l1, l2], ["sin", "cos"]) # create Legends by passing vector of plot objects and vector of label strings
fig

fig, ax, hm = heatmap(randn(20, 20))
Colorbar(fig[1, 2], hm) # similar to Legend, pass position in the figure and plot object (hm)
fig

# equivalent of the above
using CairoMakie
fig = Figure()
ax = Axis(fig[1, 1])
hm = heatmap!(ax, randn(20, 20))
Colorbar(fig[2, 1], hm; vertical=false) 
fig


#= You can pass axis attributes under the keyword axis and 
figure attributes under the keyword figure
=#
using CairoMakie
heatmap(randn(20, 20),
    figure = (backgroundcolor = :pink,), #note trailing comma if setting one attribute 
    axis = (aspect = 1, xlabel ="x axis", ylabel = "y axis")
)



