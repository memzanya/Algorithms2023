include("C:/Users/Mizan/OneDrive/Рабочий стол/algo23/common.jl")

function task2(robot) # ok
    steps_south = run_along(robot, Sud; Mark = false)
    steps_west = run_along(robot, West, Mark = false)
    for side in (Nord, Ost, Sud, West)
        run_along(robot, side, Mark = true)
    end
    run_nsteps(robot, Nord, steps_south)
    run_nsteps(robot, Ost, steps_west)
end