module AtrialFibr
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
        return split(setPath, "/")[end]
    end
    @test getSetName("a/b") =="b"
    @test getSetName("a/b/c") =="c"

    function downloadAttributeFile(address)
        for extension in ["atr" "ecg"]
            if(success(`wget -Nq $address.$extension`))
                return extension
            end
        end
    end

    function downloadDatFile(address)
        return success(`wget -Nq $address.dat`)
    end

    function downloadHeaderFile(address)
        return success(`wget -Nq $address.hea`)
    end

    function ann2rr(setName, extension)
        command = `ann2rr -r $setName -a $extension`
        setenv(command,["LD_PRELOAD=libcurl.so"])
        stream, process = readsfrom(command)
        return stream
    end

    function heartRateStream(address)
        downloadHeaderFile(address)
        downloadDatFile(address)
        const extension = downloadAttributeFile(address)
        const setName = getSetName(address)
        return ann2rr(setName, extension)
    end

    function heartRateSeries(input)
        const address = "http://www.physionet.org/physiobank/database/" * input
        const stream = heartRateStream(address)
        const lines = readlines(stream)
        return map((x) -> int(strip(x)), lines)[2:]
    end

    export heartRateSeries, markovChainTransitions
end
