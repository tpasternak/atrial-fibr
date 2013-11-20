module Algebra
using Base.Test

function normalize(matrix)
    return matrix/sum(matrix)
end
@test normalize([5]) == [1]
@test_approx_eq normalize([5 2; 1 2]) [0.5 0.2; 0.1 0.2]

function entropy(A)
    @assert size(A)[1] == size(A)[2]
    const n = size(A)[1]
    H=zeros(n)
    for i = 1:n
        H[i] = map(x-> x*log(2,x), A[i,1:n]) |> sum |> -
    end

    P = zeros(n)
    for j = 1:n
        P[j] = sum(A[1:n,j])
    end

    return dot(P,H)
end
@test entropy(normalize([1 1 1; 1 1 1; 1 1 1])) >= 1
@test entropy(normalize([1 1 1; 1 1 1; 1 1 1])) <= 1.06
@test entropy(normalize([1 1 1; 1 1e5 1; 1 1 1])) <= 0.01

function divergence(A,B)
    return map( (x,y) -> x*log(10,x)/log(10,y), A, B) |> sum
end

export normalize

end
