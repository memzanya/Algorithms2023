include("common.jl")

function task7(robot)
    #цикл:
    #проверить сверху, сделать шаг влево, проверить сверху
    #если оба пусты подняться вверх, сделать шаг вправо, continue
    #если хотя бы одна занята - перегородка найдена

    side = West
    while !isborder(robot, Nord)
        move!(robot, side)
        if !isborder(robot, Nord)
            move!(robot, Nord)
            side = inverse(side)
        end
    end

    n = 5
    while true
        for i in 1:n
            move!(robot, side)
            if !isborder(robot, Nord)
                break
            end
        end

        side = inverse(side)

        for i in 1:n
            move!(robot, side)
        end

        for i in 1:n
            move!(robot, side)
            if !isborder(robot, Nord)
                break
            end
        end

        side = inverse(side)

        n += 5
    end
end
