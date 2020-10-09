function [testClass] = nn_classify(matchingCostVector, trainClasses, k)

    [~, sorted_idx] = sort(matchingCostVector);

    counter = 0;
    class_frequency = zeros(3,1);

    for i=sorted_idx
        counter = counter + 1;
        if strcmpi(trainClasses(i),'Fork')
            class_frequency(1) = class_frequency(1)+1;
        elseif strcmpi(trainClasses(i),'Heart')
            class_frequency(2) = class_frequency(2)+1;
        elseif strcmpi(trainClasses(i),'Watch')
            class_frequency(3) = class_frequency(3)+1;
        end
        if counter == k
            break;
        end
    end

    [~, winner] = max(class_frequency);

    if winner==1
       testClass = 'Fork';
    elseif winner==2
       testClass = 'Heart';
    elseif winner==3
       testClass = 'Watch';
    end

end