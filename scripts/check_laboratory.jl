# Run the complete, ordered Julia examples and their analytical assertions.
# The source chapter is trusted project code, executed just as a Julia script.
const chapter_path=normpath(joinpath(@__DIR__,"..","15-computational-laboratory.qmd"))
function check_laboratory()
fence=repeat(string(Char(0x60)),3)
blocks=String[]
current=String[]
in_julia=false
for textline in eachline(chapter_path)
    if !in_julia && (startswith(textline,fence*"julia") || startswith(textline,fence*"{julia"))
        in_julia=true
        empty!(current)
    elseif in_julia && startswith(textline,fence)
        push!(blocks,join(current,"\n"))
        in_julia=false
    elseif in_julia
        push!(current,textline)
    end
end
@assert !in_julia "Unclosed Julia code block"
@assert length(blocks)==9 "Expected the nine complete laboratory examples"
include_string(Main,join(blocks,"\n\n"),chapter_path)
println("All nine laboratory examples and analytical assertions passed.")
end
check_laboratory()
