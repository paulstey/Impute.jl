@auto_hash_equals struct NOCB <: Imputor
    vardim::Int
    context::AbstractContext
end

"""
    NOCB(; vardim=2, context=Context())

Next observation carried backward (NOCB) iterates backwards through the `data` and fills
missing data with the next existing observation.

See also:
- [LOCF](@ref): Last Observation Carried Forward

WARNING: missing elements at the tail of the array may not be imputed if there is no
existing observation to carry backward. As a result, this method does not guarantee
that all missing values will be imputed.

# Keyword Arguments
* `vardim=2::Int`: Specify the dimension for variables in matrix input data
* `context::AbstractContext`: A context which keeps track of missing data
  summary information

# Example
```jldoctest
julia> using Impute: NOCB, Context, impute

julia> M = [1.0 2.0 missing missing 5.0; 1.1 2.2 3.3 missing 5.5]
2×5 Array{Union{Missing, Float64},2}:
 1.0  2.0   missing  missing  5.0
 1.1  2.2  3.3       missing  5.5

julia> impute(M, NOCB(; vardim=1, context=Context(; limit=1.0)))
2×5 Array{Union{Missing, Float64},2}:
 1.0  2.0  5.0  5.0  5.0
 1.1  2.2  3.3  5.5  5.5
```
"""
NOCB(; vardim=2, context=Context()) = NOCB(vardim, context)

function impute!(data::AbstractVector, imp::NOCB)
    imp.context() do c
        end_idx = findlast(c, data) - 1
        for i in end_idx:-1:firstindex(data)
            if ismissing(c, data[i])
                data[i] = data[i+1]
            end
        end

        return data
    end
end
