

using HorizonSideRobots

function inverse(side)
    if side == Nord
        return Sud
    elseif side == Ost
        return West
    elseif side == Sud
        return Nord
    else
        return Ost
    end
end

#function run_to_south_west_corner(robot)
#    steps_south = run_along(robot, Sud)
#    steps_west = run_along(robot, West)
#    return (steps_south, steps_west)
#end

function run_to_south_west_corner(robot; by_side_first = Sud)
    if by_side_first == Sud
        steps_south = run_along(robot, Sud)
        steps_west = run_along(robot, West)
    elseif  by_side_first == West
        steps_west = run_along(robot, West)
        steps_south = run_along(robot, Sud)
    else
        error("Obvious logical error, choose Sud or West")
    end
        return (steps_south, steps_west)
end

function run_from_south_west_corner_to_start(robot, steps_south, steps_west; by_side_first = Nord)
    if by_side_first == Nord
        run_nsteps(robot, Nord, steps_south)
        run_nsteps(robot, Ost, steps_west)
    elseif by_side_first == Ost
        run_nsteps(robot, Ost, steps_west)
        run_nsteps(robot, Nord, steps_south)
    else
        error("Obvious logical error, choose Nord or West")
    end
end

function run_along(robot, side; Mark::Bool = false)::Int
    steps = 0
    if Mark == true
        putmarker!(robot)
    end
    while !isborder(robot, side)
        move!(robot, side)
        steps += 1
        if Mark == true
            putmarker!(robot)
        end
    end
    return steps
end

function run_along_and_return(robot, side; Mark::Bool = false)::Int
    steps = run_along(robot, side; Mark)
    run_nsteps(robot, inverse(side), steps)
    return steps
end

function run_nsteps(robot, side, n::Int; Mark::Bool = false)
    if Mark == true
        putmarker!(robot)
    end
    for i in 1:n
        move!(robot, side)
        if Mark == true
            putmarker!(robot)
        end
    end
end

function run_nsteps_and_return(robot, side, n::Int; Mark::Bool = false)
    run_nsteps(robot, side, n; Mark)
    run_nsteps(robot, inverse(side), n)
end

function run_along_and_calc_temp(robot, side)
    count = 0
    sum = 0
    
    if ismarker(robot)
        count += 1
        sum += temperature(robot)
    end
    
    while !isborder(robot, side)
        move!(robot, side)
        if ismarker(robot)
            count += 1
            sum += temperature(robot)
        end

    end

    return (count, sum)
end

function clockwise_side(side)
    if side == Nord
        return Ost
    elseif side == Ost
        return Sud
    elseif side == Sud
        return West
    else
        return Nord
    end
end

function counter_clockwise_side(side)
    if side == Nord
        return West
    elseif side == West
        return Sud
    elseif side == Sud
        return Ost
    else
        return Nord
    end
end

function get_around_isolated_box_by_clockwise(robot, side; Mark::Bool = false) # работает, когда в направлении side робот упирается в изолированную прямоугольную коробку
    steps_side = 0
    steps_aside = 0

    # пойти в направлении counter_clockwise_side(side), дойти до клетки, где исчезает прикосновение к коробке, далее повернуться в направлении clockwise_side(side),
    # пройти до упора, пока не исчезнет прикосновение к коробке, далее повернуться в направлении clockwise_side(side) и пройти steps_aside шагов
    if Mark
        putmarker!(robot)
    end

    while isborder(robot, side)
        move!(robot, counter_clockwise_side(side))
        if Mark
            putmarker!(robot)
        end
        steps_aside += 1
    end

    move!(robot, side)
    if Mark
        putmarker!(robot)
    end
    
    while isborder(robot, clockwise_side(side))
        move!(robot, side)
        if Mark
            putmarker!(robot)
        end
        steps_side += 1
    end

    #run_nsteps(robot, clockwise_side(side), steps_aside; Mark = Mark)

    for i in 1:steps_aside
        move!(robot, clockwise_side(side))
        if Mark
            putmarker!(robot)
        end
    end
end

function get_around_isolated_box(robot, side)
    steps_aside = 0
    steps_ahead = 0

    if side == Nord || side == Sud
        if !isborder(robot, West)
            side_aside = West
        elseif !isborder(robot, Ost)
            side_aside = Ost
        else
            error("can't get_around_isolated_box because of walls")
        end
    else
        if !isborder(robot, Sud)
            side_aside = Sud
        elseif !isborder(robot, Nord)
            side_aside = Nord
        else
            error("can't get_around_isolated_box because of walls")
        end
    end
    
    

    while isborder(robot, side) && !isborder(robot, side_aside)
        move!(robot, side_aside)
        steps_aside += 1
    end

    if isborder(robot, side)
        error("can't get_around_isolated_box")
    end

    side = clockwise_side(side_aside)
    side_aside = clockwise_side(side_aside)
    
    move!(robot, side)
    steps_ahead += 1
    
    while isborder(robot, side) && !isborder(robot, side_aside)
        move!(robot, side)
        steps_ahead += 1
    end

    if isborder(robot, inverse(side_aside))
        error("can't get_around_isolated_box because it's more complex than box or it's not isolated")
    end

    for i in 1:steps_aside
        move!(robot, inverse(side_aside))
    end

end

#function mark_line_and_return(robot, side)
#    putmarker!(robot)
#    steps = 0
#    while ! isborder(robot, side)
#        steps += 1
#        move!(robot, side)
#        putmarker!(robot)
#    end
#    for i in 1:steps
#        move!(robot, inverse(side))
#    end
#end

function task1(robot) # ok
    for side in (Nord, Ost, Sud, West)
        run_along_and_return(robot, side; Mark = true)
    end
end

#r = Robot("infile1.sit" ;animate = true)

#task1(r)

function task1a(robot)
    for side in (Nord, Ost, Sud, West)
        n = run_along(robot, side; Mark = false)
        run_nsteps(robot, inverse(side), n)
    end
end

function task2(robot) # ok
    steps_south = run_along(robot, Sud; Mark = false)
    steps_west = run_along(robot, West, Mark = false)
    for side in (Nord, Ost, Sud, West)
        run_along(robot, side, Mark = true)
    end
    run_nsteps(robot, Nord, steps_south)
    run_nsteps(robot, Ost, steps_west)
end

#r = Robot(5,5; animate = true)
#task2(r)

function task3old(robot)
    steps_south = run_along(robot, Sud; Mark = false)
    steps_west = run_along(robot, West, Mark = false)
    side = Ost
    while !isborder(robot, Nord)
        run_along(robot, side, Mark = true)
        move!(robot, Nord)
        side = inverse(side)
    end
    run_along(robot, side, Mark = true)
    run_along(robot, Sud)
    run_along(robot, West)
    run_nsteps(robot, Nord, steps_south)
    run_nsteps(robot, Ost, steps_west)
end

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

function task4old(robot)
    (steps_south, steps_west) = run_to_south_west_corner(robot)
    
    steps_ost = run_along_and_return(robot, Ost; Mark = true)
    i = 1
    while !isborder(robot, Nord)
        move!(robot, Nord)
        run_nsteps_and_return(robot, Ost, steps_ost - i; Mark = true)
        i += 1
    end
    run_to_south_west_corner(robot)
    run_from_south_west_corner_to_start(robot, steps_south, steps_west)
end

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

function task5(robot) # ok
    #(steps_south, steps_west) = run_to_south_west_corner(robot; by_side_first = West)
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

    #putmarker!(robot)
    get_around_isolated_box_by_clockwise(robot, Nord; Mark = true)
    get_around_isolated_box_by_clockwise(robot, Sud; Mark = true)
    #(x, y) = robot.situation.frame_size
    
    #side = Ost

    #for i in 1:y
    #    for j in 1:x
    #        if !isborder(robot, side)
    #            move!(robot, side)
    #        elseif j != x
    #           # найдена перегородка
    #           print(i)
    #           print(j)
    #           break
    #        end
    #    end
    #    if !isborder(robot, Nord)
    #        move!(robot, Nord)
    #    end
    #    side = inverse(side)
    #end
    
    #run_along(robot, side)

    run_to_south_west_corner(robot; by_side_first = West)

    run_nsteps(robot, Nord, steps_south1)
    run_nsteps(robot, Ost, steps_west)
    run_nsteps(robot, Nord, steps_south2)
    
    #for i in 1:steps_south1
    #    move!(robot, Nord)
    #end
    #for i in 1:steps_west
    #    move!(robot, Ost)
    #end
    #for i in 1:steps_south2
    #    move!(robot, Nord)
    #end
end

function task6(robot)
    steps_south1 = run_along(robot, Sud)
    steps_west = run_along(robot, West)
    steps_south2 = run_along(robot, Sud)

    side = Ost
    while !isborder(robot, Ot)
        move!(robot, side)
        
    end
#найти внутреннюю перегородку полным перебором
#обойти её, промаркировав по периметру
end

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
        #if !isborder(robot, Nord)
    #    move!(robot, West)
    #    if isborder(robot, Nord)
    #        #найдено
    #    else
    #        #не найдено, дальше вверх
    #    end
    #else
    #        #найдено
    #end
end

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

    #while y != ymax
    #    while !isborder(robot, side)
    #        move!(robot, side)
    #        x += (side == Ost ? 1 : -1)
    #        if isborder(robot, Nord)
    #            while isborder(robot, Nord)
    #                move!(robot, side)
    #                x += (side == Ost ? 1 : -1)
    #            end
    #            if abs(x - x_last) > 3
    #                n += 1
    #            end
    #            x_last = x - (side == Ost ? 1 : -1)
    #        end
    #    end
    #    move!(robot, Nord)
    #    y += 1
    #    x_last = -100
    #    side = inverse(side)
    #end

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

function task10helper(robot, N::Int)
    steps_horizontal = 1
    steps_vertical = 1

    side = Ost
    i = 0
    while !isborder(robot, Nord) && steps_vertical < N
        while !isborder(robot, side) && steps_horizontal < N
            if i % 2 == 0
                putmarker!(robot)
            end
            if !isborder(robot, side)
                move!(robot, side)
                steps_horizontal += 1
            else
                move!(robot, Nord)
                side = inverse(side)
            end
            i += 1
        end
    end
end

function task10(robot, N::Int)
    (steps_south, steps_west) = run_to_south_west_corner(robot)



    run_to_south_west_corner(robot)
    run_from_south_west_corner_to_start(robot, steps_south, steps_west)
end

#sitedit!(r, "untitled.sit")
#task11(r)
#k = task12(r)
#print(k)
#print('-')

#sitedit!(r, "untitled.sit")
#for i in 1:3
#    move!(r, Sud)
#    move!(r, West)
#end
#task7old(r)

function task19(robot, side)
    if !isborder(robot, side)
        move!(robot, side)
        task19(robot, side)
    else
        return
    end
end

#task19(r, Ost)

function task28a(n::Integer)

end

function task28b(n::Integer)::Integer
    if n == 0 || n == 1
        return 1
    else
        return task28b(n - 1) + task28b(n - 2)
    end
end

function task28c(n::Integer)::Integer
    
end

#print(task28b(4))

function task10old(robot)
    n = 0
    sum = 0
    side = Ost

    while !isborder(robot, Nord)
        (locn, locsum) = run_along_and_calc_temp(robot, side)
        n += locn
        sum += locsum
        move!(robot, Nord)
        side = inverse(side)
    end

    (locn, locsum) = run_along_and_calc_temp(robot, side)
    n += locn
    sum += locsum

    if n == 0
        print("Маркеров нет")
    else
        print(sum / n)
    end
end

function mark_cross_nn()

end

function mark_chess_nn()

end

function task12(robot, n)
    (steps_south, steps_west) = run_to_south_west_corner(robot)



    run_to_south_west_corner(robot)
    run_from_south_west_corner_to_start(robot, steps_south, steps_west)
end


function task13old(robot)
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

#function task14(robot)
#    for side in (Nord, Ost, Sud, West)
#        ######################################################################################################################################
#    end
#end

#putmarker!(r)
#sitcreate(11,12;newfile="infile1.sit")
#save(r, "435.sit")
#sitedit("infile1.sit")
#task10(r)

#for i in 1:4
#    move!(r, Nord)
#    move!(r, Ost)

#end


#function task20(robot)
#    count = 0
#    run_along(robot, West; Mark = false)
#end





#move!(r, Ost)
#while !isborder(r, Nord)
#    move!(r, Nord)
#end
#task13(r)

#sitedit!(r, "untitled.sit")
#move!(r, Ost)
#while !isborder(r, Nord)
#    move!(r, Nord)
#end
#get_around_isolated_box(r, Nord)

