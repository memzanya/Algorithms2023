include("common.jl")

function task3(robot) # ok
    (steps_south, steps_west) = run_to_south_west_corner(r)
    
    side = Ost
    while !isborder(robot, Nord)
        run_along(robot, side; Mark = true)
        move!(robot, Nord)
        side = inverse(side)
    end

    run_along(robot, side; Mark = true)

    run_to_south_west_corner(robot)
    run_from_south_west_corner_to_start(robot, steps_south, steps_west)
end
