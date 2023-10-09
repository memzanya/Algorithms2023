
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

function run_test_for_the_task()

end
