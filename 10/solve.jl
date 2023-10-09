include("C:/Users/Mizan/OneDrive/Рабочий стол/algo23/common.jl")


function chess_mark_square(robot, N::Int)
    i = 0
    side = Ost
    putmarker!(robot)
    for i in 1:(N-1)
        move!(robot, side)
    end

end
function task10helper(robot, N::Int)
    steps_horizontal = 1
    steps_vertical = 1

    side = Ost
    i = 0
    while !isborder(robot, Nord) && (steps_vertical <= N)
        while !isborder(robot, side) && (steps_horizontal < N)
            if i % 2 == 0
                putmarker!(robot)
            end
            if !isborder(robot, side) && (steps_horizontal < N)
                move!(robot, side)
                i += 1
                steps_horizontal += 1
            elseif isborder(robot, side)
                break
            end
        end
        if steps_vertical < N
            move!(robot, Nord)
            side = inverse(side)
            i += 1
        end
        steps_vertical += 1
        steps_horizontal = 1
    end
end

#function task10(robot, N::Int)
##    (steps_south, steps_west) = run_to_south_west_corner(robot)



#    mark_square(robot, N)

#    run_to_south_west_corner(robot)
#    run_from_south_west_corner_to_start(robot, steps_south, steps_west)
#end