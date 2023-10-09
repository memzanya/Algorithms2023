include("common.jl")

function task1(robot) # ok
    for side in (Nord, Ost, Sud, West)
        run_along_and_return(robot, side; Mark = true)
    end
end
