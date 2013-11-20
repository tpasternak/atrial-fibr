module DataDownloader
    using Base.Test

    function getSetName(setPath)
        return split(setPath, "/")[end]
    end
    @test getSetName("a/b") =="b"
    @test getSetName("a/b/c") =="c"

    function downloadAttributeFile(address)
        for extension in ["atr" "ecg" "qrs"]
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

    export heartRateSeries
end
