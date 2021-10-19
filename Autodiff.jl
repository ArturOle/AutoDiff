# Rules
import Base: +, /, -, *, sqrt, exp, log, sin, cos, convert, promote_rule

# Function-derivative pair
struct DualNumber <: Number
    f::Tuple{Float64, Float64}
end

# Base rules
+(x::DualNumber, y::DualNumber) = DualNumber(x.f .+ y.f)
-(x::DualNumber, y::DualNumber) = DualNumber(x.f .- y.f)
/(x::DualNumber, y::DualNumber) = DualNumber((x.f[1] / y.f[1], (y.f[1]*x.f[2] - x.f[1]*y.f[2])/(y.f[1]^2)))
*(x::DualNumber, y::DualNumber) = DualNumber((x.f[1] * y.f[1], x.f[2]*y.f[1] + x.f[1]*y.f[2]))

# Functions
sin(x::DualNumber) = DualNumber((sin(x.f[1]), x.f[2]*cos(x.f[1])))
cos(x::DualNumber) = DualNumber((cos(x.f[1]), -x.f[2]*sin(x.f[1])))
exp(x::DualNumber) = DualNumber((exp(x.f[1]), x.f[2]*exp(x.f[1])))
log(x::DualNumber) = DualNumber((log(x.f[1]), x.f[2]/x.f[1]))
sqrt(x::DualNumber) = DualNumber((sqrt(x.f[1]), 1/(2*sqrt(x.f[1]))))

# Implement
convert(::Type{DualNumber}, x::Real) = DualNumber((x, zero(x)))
promote_rule(::Type{DualNumber}, ::Type{<:Number}) = DualNumber


global dn = DualNumber((49, 1))

# Example function
example(x) = sqrt(x)*log(x)

# Fast forward differentiation
derivative(func::Function, x::Number, e::Float64) = (func(x + e) - func(x)) / e

function test()
    i = 100000000
    r = 0
    @time(
        while i > 0
            r+=derivative(example, 49, 0.00001)
            i-=1
        end
    )
    println(r)

    i = 100000000
    r = 0
    @time(
        while i > 0
            r+=example(DualNumber((49, 1)))
            i-=1
        end
    )
    println(r)

    println("derivative fast forward: ", derivative(example, 49, 0.00001))
    println("dual number no derivative and derivative: ", example(DualNumber((49, 1))))

    println(abs(0.4208443070079019007293361062061685328052978185116944554941985928-derivative(example, 49, 0.00001)))
    println(abs(0.4208443070079019007293361062061685328052978185116944554941985928-example(DualNumber((49, 1))).f[2]))
end

test()

