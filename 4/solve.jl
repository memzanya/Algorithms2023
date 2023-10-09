include("C:/Users/Mizan/OneDrive/Рабочий стол/algo23/common.jl")

function task4(robot) # ok
    putmarker!(robot)
    for s in ((Nord, Ost), (Ost, Sud), (Sud, West), (West, Nord))
        (side1, side2) = s
        steps = 0
        while !isborder(robot, side1) && !isborder(robot, side2)
            move!(robot, side1)
            move!(robot, side2)
            steps += 1
            putmarker!(robot)
        end
        for i in 1:steps
            move!(robot, inverse(side2))
            move!(robot, inverse(side1))
        end
    end
end