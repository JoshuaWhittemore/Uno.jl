


struct GeometricWithoutReplacement
  n::Int
  k::Int
end

mean(d::GeometricWithoutReplacement) = (d.n + 1)/(d.k + 1)

function var(d::GeometricWithoutReplacement)
  n, k = d.n, d.k

  numerator = k * (n - k)*(n + 1)
  denominator = (k + 2)*(k + 1)^2

  return numerator/denominator
end

# The probability of drawing x 'bad' objects from the urn in a row.
# 
function failprob(d::GeometricWithoutReplacement, x)
  # Use BigInt since binomial coefficients can get huge quickly.
  n = BigInt(d.n)
  k = BigInt(d.k)
  x = BigInt.(x)

  return Float64.(binomial.(n .- x, k) ./ binomial(n, k))
end

function pmf(d::GeometricWithoutReplacement, x)
  # The probability that the xth draw will be a success after x-1 previous failures.
  successprob = d.k ./ (d.n .- x .+ 1)

  return failprob(d, x .- 1) .* successprob
end

# P(X <= x)
# The probability
function cdf(d::GeometricWithoutReplacement, x)
  return 1.0 .- failprob(d, x)
end



# d = GeometricWithoutReplacement(111, 36)

# println(pmf(d, 1))

# # what is the probability of drawing 7 or more cards?
# println(1 - cdf(d, 6))


