include("common.jl")

function task8(robot) # ok
    if ismarker(robot)
        return
    end

    n = 0
    side = Nord
    while true
        for i in 1:2
            for k in 1:n
                move!(robot, side)
                if ismarker(robot)
                    return
                end
            end
            side = counter_clockwise_side(side)
        end
        n += 1
    end
end
