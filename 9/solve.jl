include("common.jl")

function task9(robot) # ok 
    (steps_south, steps_west) = run_to_south_west_corner(robot)
    
    side = Ost
    i = ((steps_south + 1) + (steps_west + 1)) % 2
    while !isborder(robot, Nord)
        if i % 2 == 0
            putmarker!(robot)
        end
        if !isborder(robot, side)
            move!(robot, side)
        else
            move!(robot, Nord)
            side = inverse(side)
        end
        i += 1
    end
    
    while !isborder(robot, side)
        if i % 2 == 0
            putmarker!(robot)
        end
        if !isborder(robot, side)
            move!(robot, side)
        end
        i += 1
    end    

    if i % 2 == 0
        putmarker!(robot)
    end
    
    run_to_south_west_corner(robot)
    run_from_south_west_corner_to_start(robot, steps_south, steps_west)
end
