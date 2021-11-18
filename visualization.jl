#=
There are three main back ends which concretely implement all abstract rendering
capabilities defined in Makie. One for non-interactive 2D publicationquality
vector graphics: CairoMakie.jl. Another for interactive 2D and 3D plotting
in standalone GLFW.jl windows (also GPU-powered), GLMakie.jl. And the
third one, a WebGL-based interactive 2D and 3D plotting that runs within
browsers, WGLMakie.jl. See Makie’s documentation for more2.
In this book we will only show examples for CairoMakie.jl and GLMakie.jl
=#

