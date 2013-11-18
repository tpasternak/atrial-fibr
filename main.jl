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

function getSetName(setPath)

end

function downloadAllFiles(input)
    const root = "http://www.physionet.org/physiobank/database/"
    address = root * input
    command = `wget -Nq $address.dat`
    success(command)
    command = `wget -Nq $address.atr`
    success(command)
    command = `wget -Nq $address.hea`
    success(command)

    command = `ann2rr -r e0103 -a atr`

    stream, process = readsfrom(command)
    return stream
end



function main()
    stream = downloadAllFiles("edb/e0103")
    lines = readlines(stream)
    distances = map ((x) -> int(strip(x)), lines)[2:]
    markovTransitions = markovChainTransitions(distances)
end

main()
