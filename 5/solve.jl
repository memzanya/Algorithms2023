include("C:/Users/Mizan/OneDrive/Рабочий стол/algo23/common.jl")

function task5(robot) # ok
    steps_south1 = run_along(robot, Sud)
    steps_west = run_along(robot, West)
    steps_south2 = run_along(robot, Sud)

    for s in (Nord, Ost, Sud, West)
        run_along(robot, s; Mark = true)
    end

    side = Ost
    
    while !isborder(robot, Nord)
        if !isborder(robot, side)
            move!(robot, side)
        else
            move!(robot, Nord)
            side = inverse(side)
        end
    end

    get_around_isolated_box_by_clockwise(robot, Nord; Mark = true)
    get_around_isolated_box_by_clockwise(robot, Sud; Mark = true)

    run_to_south_west_corner(robot; by_side_first = West)

    run_nsteps(robot, Nord, steps_south1)
    run_nsteps(robot, Ost, steps_west)
    run_nsteps(robot, Nord, steps_south2)
end