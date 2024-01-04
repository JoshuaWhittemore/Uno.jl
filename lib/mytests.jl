using Test

include("geometric_without_replacement.jl")


d = GeometricWithoutReplacement(10, 3)
xrange = 1:10

@testset "mean" begin
  # If there are 7 'bad' objects, the maximum number of draws before a 'good' object
  # can be obtained is 8.  Also, E(X) = Σ x*p(x).
  expectedmean = mapreduce(+, xrange) do x
                   x * pmf(d, x)
                 end

  @test mean(d) ≈ expectedmean atol=1e-5
end

@testset "variance" begin
  expectedmeansquared = mapreduce(+, xrange) do x
    x^2 * pmf(d, x)
  end

  # VAR(X) = E(X^2) - μ²
  expectedvar = expectedmeansquared - mean(d)^2

  @test var(d) ≈ expectedvar atol=1e-5
end

@testset "pmf" begin
  @test pmf(d, 1) ≈ 0.3 atol=1e-5

  expectedprob = (7/10) * (3/9)
  @test pmf(d, 2) ≈ expectedprob atol=1e-5
end

@testset "cdf" begin
  @test cdf(d, 1) ≈ (3/10) atol=1e-5

  # The probability that it will take 2 or fewer trials is the complement of the probability
  # that the first two trials both fail.
  expectedcdf = 1 - (7/10) * (6/9)
  @test cdf(d, 2) ≈ expectedcdf atol=1e-5
end
