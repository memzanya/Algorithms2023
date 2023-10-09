include("common.jl")

function task11(robot)::Int # ok
    (steps_south, steps_west) = run_to_south_west_corner(robot; by_side_first = West)

    n::Int = 0
    y::Int = 1

    (xmax, ymax) = robot.situation.frame_size
    
    side = Ost

    while y != ymax
        while !isborder(robot, side)
            move!(robot, side)
            if isborder(robot, Nord)
                while isborder(robot, Nord)
                    move!(robot, side)
                end
                n += 1
            end
        end
        move!(robot, Nord)
        y += 1
        side = inverse(side)
    end

    run_to_south_west_corner(robot; by_side_first = West)
    run_from_south_west_corner_to_start(robot, steps_south, steps_west; by_side_first = Nord)

    return n
end
