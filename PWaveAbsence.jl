using Base
using Gaston

function AveragePWave(csvFile)
    A = readcsv(csvFile)
    startPoints = find(x->x==1, A[:,3])
    endPoints = find(x->x==2, A[:,3])
    length = minimum(endPoints - startPoints)

    sumSignal = zeros(length)
    for i = 0:(length-1)
        sumSignal[i+1] = sum(A[startPoints+i,2])
    end

    meanSignal = sumSignal / length
    plot(A[1:length,1]-minimum(A[1:length,1]), meanSignal)
end

AveragePWave("f1y07_P.csv")
