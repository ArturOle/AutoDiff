import Base: +, /, -, *, ^, convert, promote_rule
using Printf


# Function-derivative pair
struct DoubleNumber <: Number
    f::Tuple{Float64, Float64}
end

# Rules
+(x::DoubleNumber, y::DoubleNumber) = DoubleNumber(x.f .+ y.f)
-(x::DoubleNumber, y::DoubleNumber) = DoubleNumber(x.f .- y.f)
/(x::DoubleNumber, y::DoubleNumber) = DoubleNumber((x.f[1] / y.f[1], (y.f[1]*x.f[2] - x.f[1]*y.f[2])/(y.f[1]^2)))
*(x::DoubleNumber, y::DoubleNumber) = DoubleNumber((x.f[1] * y.f[1], x.f[2]*y.f[1] + x.f[1]*y.f[2]))
^(x::DoubleNumber, y::Int) = DoubleNumber((x.f[1]^y, x.f[2]^y))
convert(::Type{DoubleNumber}, x::Real) = DoubleNumber((x, zero(x)))
promote_rule(::Type{DoubleNumber}, ::Type{<:Number}) = DoubleNumber


# Babilonian square root function
function BSR(x, Iterations=10)
    value = (x + 1)/2
    
    for i = 2:Iterations
        value = (value + x/value)/2
    end

    return value
end

# fast forward differentiation
derivative(func, x, e) = (func(x + e) - func(x)) / e

function example()
    der_sqr = BSR(DoubleNumber((49, 1)))
    println("Square Root derivative with dual number and forward differentiation:\n")
    @printf("Dual Number:\nSquare root of 49: %i\nDerivative of this square root: %f\n", der_sqr.f[1], der_sqr.f[2])
    println("And this only took about 3 microseconds to compute both of the values")
    println("When we compare it with the result of wolfram alpha we can")
    println("say that the values are exact: ", "|0.07142857142857142 - ", der_sqr.f[2], "| = ", 0.07142857142857142 -der_sqr.f[2])
end

example()

