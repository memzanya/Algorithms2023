include("common.jl")

function task12(robot)::Int # ok
    (steps_south, steps_west) = run_to_south_west_corner(robot; by_side_first = West)

    n::Int = 0
    y::Int = 1
    x::Int = 1
    #x_last::Int = -100
    steps_between = 0
    was_partition = false

    (xmax, ymax) = robot.situation.frame_size
    
    side = Ost

    while y != ymax
        while !isborder(robot, side)
            move!(robot, side)
            if was_partition
                steps_between += 1
            end
            if isborder(robot, Nord)
                while isborder(robot, Nord)
                    move!(robot, side)
                end
                if was_partition
                    if steps_between > 1
                        n += 1
                    end
                    steps_between = 0
                else
                    was_partition = true
                    n += 1
                end
            end
        end
        move!(robot, Nord)
        y += 1
        side = inverse(side)
        steps_between = 0
        was_partition = false
    end

    run_to_south_west_corner(robot; by_side_first = West)
    run_from_south_west_corner_to_start(robot, steps_south, steps_west; by_side_first = Nord)

    return n
end
