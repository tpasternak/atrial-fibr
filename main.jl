importall Base.Test

function classify(x, separators)
    for i = 1:length(separators)
        if x < separators[i]
           return i
        end
    end
    return length(separators)+1
end
@test classify(1, [7 12]) == 1
@test classify(8, [7 12]) == 2
@test classify(15, [7 12]) == 3

function normalizeMatrix(matrix)
    return matrix/sum(matrix)
end
@test normalizeMatrix([5]) == [1]
@test_approx_eq normalizeMatrix([5 2; 1 2]) [0.5 0.2; 0.1 0.2]

function countTransitions(series)
    classified=zeros(Float64,3,3)
    for i=1:(length(series)-1)
        classified[series[i],series[i+1]] +=1
    end
    return classified
end
@test_approx_eq countTransitions([1 2 1]) [0 1 0; 1 0 0; 0 0 0]
@test_approx_eq countTransitions([1 2 3 2 3]) [0 1 0; 0 0 2; 0 1 0]

function markovChainTransitions(X)
    binned = evalIntervalNumbers(X)
    transitions = countTransitions(binned)
    return normalizeMatrix(transitions)
end

function evalIntervalNumbers(X)
    const m = mean(X)
    return map((x) -> classify(x,[m*0.85 m*1.15]), X)
end

function main()
    datalength= 7000
    file = open("00735.rr1.txt", "r")
    X=zeros(Float64,datalength)
    readline(file)
    for i = 1:datalength
        X[i] = float(readline(file))
    end
    markovTransitions = markovChainTransitions(X)
end

main()
