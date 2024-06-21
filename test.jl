begin
	using PlutoUI
	using Colors  # working with colors later
	using Dates # and with dates
	using Plots
	using GLM
	using DataFrames
end

println("Hello World !\n")

print("A")

print("B")

print("C")

2+2


# 1 Predict a continuous variable with a continuous variable : 

#Generate data : 
y,x = rand(100),rand(100)

# Check the data :
typeof(x)
length(x)
ndims(x)
size(x)

# Adding 2 to all values of y
y .+= 2

# Computing the OLS estimator for a simple linear model
x\y
y/x

print(x\y)

plot(
	scatter(x,y),
	smooth = :true,
)

# Does not work : 
# savefig(a, "1_plot_test.png") 
# png(a, "1_plot_test.png")

plot(
	scatter(x,y),
	title = "Attempt to Linear Regression",
	ylabel = "Random variable + 2",
	xlabel = "Random variable",
)

Plots.abline!(1,2)
# Plots.abline! works such that : 
# abline!([plot,] a, b; kwargs...)
# Adds ax+b... straight line over the current plot, without changing the axis limits
# Basically, I added a line f(x)=x+2

# Using GLM 
x
y
@time model = lm(@formula(y ~ x), (;x, y))
# We can extract the coefficients in several ways with GLM.lm :
GLM.coeftable(model)
model
# The lm() function requires a data object.
# Here, it is (;x,y), which is : 
a = (;x, y)
typeof(a)

# Now, let's try to plot the line : 
coefs = GLM.coef(model)
plot!((x) -> coefs[1] + coefs[2] * x, 0, 1, label="fit_exact")

x\y
# We could also construct the big X matrix : 
vec_1 = ones(length(x))
X = transpose([transpose(vec_1);transpose(x)])
X
(X\y)
coefs

# We see that (X\y) yields the same results as lm(...) + GLM.coef(model)

# 2 Predicting one continuous variable with several continuous variables : 
# this is a multiple linear regression

w,y,x,z = (rand(100) for _ in 1:5)

plot(scatter(x, y, z, marker_z = w),
	label = ["x" "y" "z" "w"])

# We want to explain y by w,x,z. 
# Using GLM : 
@time begin 
	model = lm(@formula(y ~ w + x + z), (;w, x, y, z))
	coefs = GLM.coef(model)
end
# Using matrix computations :
X = transpose([transpose(ones(length(x))); transpose(x); transpose(z); transpose(w)])
@time begin
	X\y
end
# coefs are the same as X\y

# Now, let's try to plot the model : 

plot!((w) -> coefs[1] + coefs[2] * w, 0,1, label = "fit")
plot!((x) -> coefs[1] + coefs[3] * x, 0,1, label = "fit")
plot!((z) -> coefs[1] + coefs[4] * z, 0,1, label = "fit")

plot!((x) -> coefs[1] + coefs[2] * x, 0, 1, label="fit_exact")


# To measure performance, we use @time before the code, and we should wrap the code in a function.
# A priori, the matrix computations method seems faster than using the GLM method.

# But how does the matrix computations method work ? 

using PlotlyJS

f(x,y) = 60 * cos(2 * atan(y/x) + 0.544331*sqrt(x^2+y^2)) / (20+sqrt(x^2+y^2))
x = LinRange(-45, 45, 200)
z = [f(u, v) for u in x, v in x]
waves = PlotlyJS.surface(
            z=z, 
            x=x,  
            y=x,  
            colorscale=colors.viridis,
            showscale=false)
Plot(waves, Layout(width=600, height=600, 
                   scene= attr(aspectmode="data",
                               camera_eye=attr(x=2.55, y=2.55, z=1.4))))


# Trying with my data : 

mydata = PlotlyJS.surface(
            z=z, 
            x=x,  
            y=x,  
            colorscale=w,
            showscale=true)

Plot(mydata, Layout(width=600, height=600, 
                   scene= attr(aspectmode="data",
                               camera_eye=attr(x=2.55, y=2.55, z=1.4))))


using Plots
plotlyjs()
plot(scatter(x, y, z;
		marker_z = w,
		marker_size = 0.5))

size(x)
size(y)