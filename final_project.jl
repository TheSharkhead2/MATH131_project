### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 254b007d-efb5-4993-b43e-418f7bd11332
begin
	using Pkg
	Pkg.add("PythonPlot")
	Pkg.add("PlutoUI")
end

# ╔═╡ 48652398-8ed6-11ee-2526-67021ebf95a0
begin
	using LinearAlgebra
	using Plots; pythonplot()
	using PlutoUI
end

# ╔═╡ b08699bb-6650-4e11-a385-e700fc640120
function plot_contour(x0::Vector{Float64}, metric) 

	f(x,y) = metric(x0, [x,y])

	x = range(-5, 5, length=100)
	y = range(-5, 5, length=100)
	z = @. f(x', y)
	contourf(x, y, z, aspect_ratio=:equal)
end

# ╔═╡ 517707aa-f479-4773-884d-3fa12c360701
md"""
# The Euclidean Metric
"""

# ╔═╡ da3718cd-63f7-40ce-8418-a0b7384e33eb
function euclidean_metric(x::Vector{Float64}, y::Vector{Float64})
	return norm(x - y)
end

# ╔═╡ 6cc6237e-2a64-46c5-bf55-2d00e0e38117
begin
	x_0 = [0.0,0]
	plot_contour(x_0, euclidean_metric)
end

# ╔═╡ 2ce923df-af4a-4f7e-ba93-6428cf06d984
md"""
# Taxicab Metric
$$d_T(p,q) = \sum_{i=1}^n|p_i - q_i|$$

[Wikipedia](https://en.wikipedia.org/wiki/Taxicab_geometry)
"""

# ╔═╡ f7ee6693-8dda-4322-96b3-57062c64c12a
function taxicab_metric(x::Vector{Float64}, y::Vector{Float64})
	# assumes R2 
	return abs(x[1] - y[1]) + abs(x[2] - y[2]) 
end

# ╔═╡ 1eea30a1-3e5a-491a-aae2-75dededfb253
@bind x0_tc_x Slider(-5:0.1:5)

# ╔═╡ fa320223-4c91-4761-aa51-9b9cdafd2096
@bind x0_tc_y Slider(-5:0.1:5)

# ╔═╡ 58dd8e23-f47f-493e-ae96-8ec32958ab6a
x0_tc = [x0_tc_x, x0_tc_y]

# ╔═╡ e5edd24e-675b-4f24-a8bb-6ffb60fe00dc
begin 
	plot_contour(x0_tc, taxicab_metric)
end

# ╔═╡ 427a67e1-a649-4597-8b86-a41bb022c00a
md"""
# The p-norm
$$d_p(x,y) = \left( \sum_{i = 1}^n |x_i - y_i|^p \right)^{\frac{1}{p}}$$

[Wikipedia](https://en.wikipedia.org/wiki/Norm_(mathematics)#p-norm)
"""

# ╔═╡ 57503fea-6a84-41c8-b496-27beed9e71ba
function pnorm(p::Float64, x::Vector{Float64}, y::Vector{Float64})
	# assuming R2
	return (abs(x[1] - y[1])^p + abs(x[2] - y[2])^p)^(1/p)
end

# ╔═╡ 4da3cb63-589a-4b1f-abda-77e44194a209
function pnorm(p::Float64)
	f(x::Vector{Float64}, y::Vector{Float64}) = pnorm(p, x, y)
	return f
end

# ╔═╡ 27a6ca32-1e6e-4c51-b273-9443d617c92c
@bind p_pn Slider(1.0:100)

# ╔═╡ b2b7572f-0a9d-4a63-b82c-1c1d21508a0f
@bind x0_pn_x Slider(-5:0.1:5)

# ╔═╡ f803d10d-04ae-4b74-bf5c-faa2fd29c9b2
@bind x0_pn_y Slider(-5:0.1:5)

# ╔═╡ 6733ecc2-710d-47c9-a990-dd0846cd984a
x0_pn = [x0_pn_x, x0_pn_y]

# ╔═╡ dbc93828-6824-40d2-aa23-e9a22a0ffd0c
p_pn

# ╔═╡ 2483332c-24fa-4137-aa96-5d5471a13e0f
pnorm_metric = pnorm(p_pn)

# ╔═╡ 09d4185c-9748-4667-8efc-debf1f0d4503
plot_contour(x0_pn, pnorm_metric)

# ╔═╡ 0bd7d2e0-5f46-48b6-9e79-9592e77ddc2b
md"""
# Post Office Metric
$$d(x,y) = \begin{cases} \mbox{max}(\|x\|, \|y\|) & x \neq y \\ 0 & x = y \end{cases}$$

[found here](https://mathematica.stackexchange.com/questions/3410/plotting-the-open-ball-for-the-post-office-metric-space)
"""

# ╔═╡ 13d322b7-0c4a-4de6-8a0d-7efa72faefc0
function post_office_metric(x::Vector{Float64}, y::Vector{Float64}) 
	if x[1] == y[1] && x[2] == y[2]
		return 0
	end

	return maximum([euclidean_metric([0.0, 0], x), euclidean_metric([0.0, 0], y)])
end

# ╔═╡ b94a6a18-3ddf-417c-91bb-1e0cd00aecc2
@bind x0_po_x Slider(-5:0.1:5)

# ╔═╡ 3a3d3ba5-e0b3-48ff-aece-fd319946959b
@bind x0_po_y Slider(-5:0.1:5)

# ╔═╡ 8088edde-c7b4-40cc-8996-82c45d6152d0
x0_po = [x0_po_x, x0_po_y]

# ╔═╡ 2b55ceac-0302-4d64-a858-3cc39f12674a
begin
plot_contour(x0_po, post_office_metric)
end

# ╔═╡ d991dbaf-8383-4d71-91b3-d8088922a121
md"""
# Los Angeles Metric

$$\begin{cases}d(x,y) = |x_2| + |x_1 - y_1| + |y_2| &\text{if } x_1 \neq y_1 \\ |x_2 - y_2| &\text{else} \end{cases}$$ 

[may or may not have found this on reddit](https://www.reddit.com/r/math/comments/7x3at2/your_favorite_metric_space_examples/)
"""

# ╔═╡ 402c07ec-7e4e-4358-8a89-333583245430
function los_angeles_metric(x::Vector{Float64}, y::Vector{Float64}) 
	if x[1] - y[1] == 0
		return abs(x[2] - y[2])
	else
		return abs(x[2]) + abs(x[1] - y[1]) + abs(y[2])
	end
end

# ╔═╡ efda48e4-4a71-4aa0-929a-9d2ca4069185
x0_la = [1.0, 1.0]

# ╔═╡ 71bcb6a6-a73b-4a99-b2d6-4b972cead490
plot_contour(x0_la, los_angeles_metric)

# ╔═╡ c8b1f3d1-4082-478f-abff-847e7eb4056f
md"""
# British Rail Metric
$$d(x,y) = \|x \| + \|y\|$$

[also from reddit](https://www.reddit.com/r/math/comments/7x3at2/your_favorite_metric_space_examples/)
"""

# ╔═╡ cda24dbf-2860-454a-8b70-9c8a2a24618e
function british_rail_metric(x::Vector{Float64}, y::Vector{Float64}) 
	return norm(x) + norm(y)
end

# ╔═╡ 22b3df45-3dcd-4379-8fba-7c7d36163c9d
x0_br = [0.0, 2.0]

# ╔═╡ f387de3f-029b-4881-8893-d9c622d838d0
plot_contour(x0_br, british_rail_metric)

# ╔═╡ 643adee4-de1e-4871-bac1-732a68115615
md"""
# I don't know what this one is called (metric)

Though Prof. Kagey told me about it and you can find it as [problem 51 in his collection of open problems.](https://raw.githubusercontent.com/peterkagey/OpenishProblems/master/v2/mainfile.pdf)
(or at least this is a particular instance of that metric)

We calculate distance as the infimum of the lengths between two points where you can only move radially (towards/away from the orign) and along circles around the origin.
"""

# ╔═╡ 5f75b2ce-4936-44f0-b3d8-3c6741b0ae29
function kagey_metric(x::Vector{Float64}, y::Vector{Float64}) 
	# two possibilities: go only through the origin with radial movement, or move to the same radius and then move along that arc

	if norm(x) == 0 && norm(y) == 0 
		return 0
	elseif norm(x) == 0 
		return norm(y)
	elseif norm(y) == 0
		return norm(x)
	end
	
	# go radially to the origin from one point, and then radially to the second point
	distance_through_center_only = euclidean_metric(x, [0.0, 0.0]) + euclidean_metric(y, [0.0, 0.0])

	# get the angle between the two points. 
	dot_product = dot(normalize(x), normalize(y))
	if dot_product <= -1.0
		dot_product = -1.0
	elseif dot_product >= 1.0
		dot_product = 1.0
	end
		
	theta = acos( dot_product )

	arc_and_radial_distance = abs(norm(x) - norm(y)) + theta*min(norm(x), norm(y))

	return min(distance_through_center_only, arc_and_radial_distance)
end

# ╔═╡ 5111b738-091b-4809-bac1-66de7ed22c82
x0_km = [2.0, 0.0]

# ╔═╡ 7391bc2c-8ec2-4009-90d9-e0907a6e1ac8
plot_contour(x0_km, kagey_metric)

# ╔═╡ b3ff914d-6aa9-491f-9ab8-278f0c5cb062
md"""
# Hamming distance
Defined on strings as the number of places where they are different.

I am going to define this on elements of $\mathbb R^2$ as the Hamming distance of the binary representations of the first element plus the same for the second element

[Wikipedia page](https://en.wikipedia.org/wiki/Hamming_distance)
"""

# ╔═╡ 8a23d108-379f-493b-9a10-0d9283d8d2dc
function hamming_metric(x::Float64, y::Float64)
	value = 0.0

	x_bits = bitstring(x)
	y_bits = bitstring(y)
	
	for i in 1:length(x_bits)
		if x_bits[i] != y_bits[i] 
			value += 1
		end
	end
	return value
end

# ╔═╡ d0659baf-487b-4114-8efa-52782e19fde6
function hamming_metric(x::Vector{Float64}, y::Vector{Float64})
	return hamming_metric(x[1], y[1]) + hamming_metric(x[2], y[2])
end

# ╔═╡ 6067853f-eba5-43b4-ad5a-0b39d720f9b8
x0_hm = [0.0, 0]

# ╔═╡ 3acb42ae-db6d-45de-8d84-5ee12e0c1e6b
plot_contour(x0_hm, hamming_metric)

# ╔═╡ 2a65ca99-de61-4347-a5e6-c32ac448d1ca
md"""
# The Circle
A circle is defined geometrically as all points that are equidistant from a single point. 
"""

# ╔═╡ 08a5d229-2f5b-4297-b864-71965ed44797
function point_with_metric_on_circle(d, error::Float64, x::Vector{Float64}, center::Vector{Float64}, radius::Float64) 
	# points that are at this radius within some error
	if abs(d(x, center) - radius) < error
		return true
	end
	
	return false
end

# ╔═╡ b1d2ef3b-a41c-4020-af0d-a3186efc1638
function generate_circle_points(d, error::Float64, xrange, yrange, center::Vector{Float64}, radius::Float64)
	points = []
	for x in collect(xrange)
		for y in collect(yrange)
			if point_with_metric_on_circle(d, error, [x,y], center, radius)
				if length(points) == 0
					points = [x y]
				else
					points = vcat(points, [x y])
				end
			end
		end
	end
	
	points		
end

# ╔═╡ ea769411-62ab-4c1b-97b6-5478013c6e9f
function draw_circle(d, min::Float64, step::Float64, max::Float64, radius::Float64, center::Vector{Float64}) 
	circle_points = generate_circle_points(d, step, min:step:max, min:step:max, center, radius)

	if length(circle_points) != 0
		scatter(
			# get x and y coords
			circle_points[:, 1], 
			circle_points[:, 2],
	
			# aspect ratio and xy lims
			aspect_ratio = :equal,
			xlims = (min, max),
			ylims = (min, max),
	
			# remove outlines on scatter points 
			markerstrokewidth = 0,
	
			# make points smaller to look more like line 
			markersize = 0.7,
			legend=false
		)
	
		scatter!([center[1]], [center[2]], label="center", color=:red)
	end
end

# ╔═╡ 2048bcae-7524-4337-afca-c8f4ac474644
# ╠═╡ disabled = true
#=╠═╡
@bind plotted_circle_radius Slider(0:0.1:5)
  ╠═╡ =#

# ╔═╡ de5d1c1d-ad87-48d1-a19f-f776e160961f
# ╠═╡ disabled = true
#=╠═╡
plotted_circle_radius
  ╠═╡ =#

# ╔═╡ 255b1bd3-5b4f-4d89-83d5-a94f3ae12acc
# ╠═╡ disabled = true
#=╠═╡
@bind plotted_circle_center_x Slider(-5:0.1:5)
  ╠═╡ =#

# ╔═╡ d88e0e37-495f-454c-b497-86efe8b72fa5
# ╠═╡ disabled = true
#=╠═╡
@bind plotted_circle_center_y Slider(-5:0.1:5)
  ╠═╡ =#

# ╔═╡ 1529149d-a943-4b61-8f6e-324ce98c849d
#=╠═╡
plotted_circle_center = [plotted_circle_center_x, plotted_circle_center_y]
  ╠═╡ =#

# ╔═╡ 3c293f7f-eeb8-4f6f-94d3-323d27caa0ae
begin
	plotted_circle_radius = 2.0
	plotted_circle_center = [1.0, 0.5]
end

# ╔═╡ 2af89c4b-a2cf-4737-9497-34e5d1fe82c5
md"""
## Euclidean Metric
"""

# ╔═╡ b25c76d1-4a5e-44cf-8d49-5c2769fca354
draw_circle(euclidean_metric, -5.0, 0.01, 5.0, plotted_circle_radius, plotted_circle_center)

# ╔═╡ d12ab470-be2e-4ea9-80f5-f39ea367b783
md"""
## Taxicab Metric
"""

# ╔═╡ 588d7173-8466-46bc-8a5c-6fc78c53838b
draw_circle(taxicab_metric, -5.0, 0.01, 5.0, plotted_circle_radius, plotted_circle_center)

# ╔═╡ 17ff5413-8788-4413-b8d9-ea2b27381d73
@bind plotted_circle_p Slider(1.0:100)

# ╔═╡ c8073634-ade1-4230-9580-85775cadb6b3
begin 
	plotted_circle_pnorm_metric = pnorm(plotted_circle_p)
	plotted_circle_p
end

# ╔═╡ c4e96572-a8af-44fc-9ca8-a301ee924b2e
md"""
## p-norm with p = $plotted_circle_p
"""

# ╔═╡ 1f1fc9b9-37c3-40a8-b579-a7ac6311f048
draw_circle(plotted_circle_pnorm_metric, -5.0, 0.01, 5.0, plotted_circle_radius, plotted_circle_center)

# ╔═╡ 5fcbacbf-b04d-4aa1-9ba1-047c24280cf5
md"""
## Post-Office Metric
"""

# ╔═╡ 786f7040-a89a-44b6-bd53-04ec17141325
draw_circle(post_office_metric, -5.0, 0.01, 5.0, plotted_circle_radius, plotted_circle_center)

# ╔═╡ 7876951a-176a-40d1-a629-915c3e1238ea
md"""
## Los Angeles Metric
"""

# ╔═╡ de860d23-04a8-4df7-9829-3cbfd2d4c770
draw_circle(los_angeles_metric, -5.0, 0.01, 5.0, plotted_circle_radius, plotted_circle_center)

# ╔═╡ ca7ad9ac-b13c-4065-9ae2-8602aba37622
md"""
## British Rail Metric
"""

# ╔═╡ 4720e6a3-1b1e-44bc-b81b-2cf437cc7043
draw_circle(british_rail_metric, -5.0, 0.01, 5.0, plotted_circle_radius, plotted_circle_center)

# ╔═╡ b6c15256-8a36-4014-8b41-15d899524ea6
md"""
## The nameless metric
"""

# ╔═╡ 2df6d836-1327-4539-9732-5ebbb9ad6b2c
draw_circle(kagey_metric, -5.0, 0.01, 5.0, plotted_circle_radius, plotted_circle_center)

# ╔═╡ fd7c5e74-7226-4f6c-978a-00f683a847d8
md"""
## Hamming distance
"""

# ╔═╡ 8d2c2e87-7668-49e0-9e3a-1f5a1c9d76bd
hamming_distance_radius = 70.0

# ╔═╡ 558d13f4-c934-4123-a5a2-39d535dfc3a8
draw_circle(hamming_metric, -5.0, 0.01, 5.0, hamming_distance_radius, plotted_circle_center)

# ╔═╡ d43819d5-e076-4c37-9c41-0d56e947e935
md"""
# The Ellipse
All points where the sum of the distances to two focus points is constant. 
"""

# ╔═╡ d467d34b-ed2e-4040-a91c-18d4680b7983
function point_with_metric_on_ellipse(d, error::Float64, x::Vector{Float64}, f1::Vector{Float64}, f2::Vector{Float64}, r::Float64)
	if abs( d(x, f1) + d(x, f2) - r ) < error
		return true
	end
	return false
end

# ╔═╡ f5008e70-05c8-4e5a-bd2c-d1e6cdef7b4f
function generate_ellipse_points(d, error::Float64, xrange, yrange, f1::Vector{Float64}, f2::Vector{Float64}, r::Float64)
	points = []
	for x in collect(xrange)
		for y in collect(yrange)
			if point_with_metric_on_ellipse(d, error, [x,y], f1, f2, r)
				if length(points) == 0
					points = [x y]
				else
					points = vcat(points, [x y])
				end
			end
		end
	end
	
	points		
end

# ╔═╡ 2eba8e2b-9913-4a2c-ae2c-f2192496bb45
function draw_ellipse(d, min::Float64, step::Float64, max::Float64, r::Float64, f1::Vector{Float64}, f2::Vector{Float64}) 
	ellipse_points = generate_ellipse_points(d, step, min:step:max, min:step:max, f1, f2, r)

	if length(ellipse_points) != 0
		scatter(
			# get x and y coords
			ellipse_points[:, 1], 
			ellipse_points[:, 2],
	
			# aspect ratio and xy lims
			aspect_ratio = :equal,
			xlims = (min, max),
			ylims = (min, max),
	
			# remove outlines on scatter points 
			markerstrokewidth = 0,
	
			# make points smaller to look more like line 
			markersize = 0.7,
			legend=false
		)
	
		scatter!([f1[1]], [f1[2]], label="focus 1", color=:red)
		scatter!([f2[1]], [f2[2]], label="focus 2", color=:red)
	end
end

# ╔═╡ e5da67b8-88a0-45c0-b8d8-0b4280fa5133
begin 
	plotted_ellipse_distance = 6.0
	plotted_ellipse_focus_1 = [1.0, 3.0]
	plotted_ellipse_focus_2 = [-1.0, 0.0]
end

# ╔═╡ 5b58c8c9-8a62-4a39-9aef-2e6e9a020b88
md"""
## Euclidean Metric
"""

# ╔═╡ 277c9588-a1a6-45c0-aac5-bc8efe59b0a9
draw_ellipse(euclidean_metric, -5.0, 0.01, 5.0, plotted_ellipse_distance, plotted_ellipse_focus_1, plotted_ellipse_focus_2)

# ╔═╡ 121d24cd-500f-4cff-9882-cf080e225ab7
md"""
## Taxicab Metric
"""

# ╔═╡ a4c7b55f-6789-4b27-9625-f326b1ebff99
draw_ellipse(taxicab_metric, -5.0, 0.01, 5.0, plotted_ellipse_distance, plotted_ellipse_focus_1, plotted_ellipse_focus_2)

# ╔═╡ 37cecf9b-9706-4318-a4db-41eb07a772e4
@bind plotted_ellipse_p Slider(1.0:100) 

# ╔═╡ 690ef391-9165-4632-95af-49413766fd28
begin 
	plotted_ellipse_pnorm_metric = pnorm(plotted_ellipse_p)
	plotted_ellipse_p
end

# ╔═╡ 343da7de-8f1d-4c4f-8d0c-71682349ec97
md"""
## p-norm with p = $plotted_ellipse_p
"""

# ╔═╡ 27e5455a-f6aa-4cfa-9bf9-08be902721d4
draw_ellipse(plotted_ellipse_pnorm_metric, -5.0, 0.01, 5.0, plotted_ellipse_distance, plotted_ellipse_focus_1, plotted_ellipse_focus_2)

# ╔═╡ 452dd447-3aef-4e4a-804e-f827efe255ad
md"""
## Post-Office Metric
"""

# ╔═╡ 242fb4d9-24d3-464d-9b2d-19c099e883ac
draw_ellipse(post_office_metric, -5.0, 0.01, 5.0, plotted_ellipse_distance, plotted_ellipse_focus_1, plotted_ellipse_focus_2)

# ╔═╡ 7e4d6009-080c-4810-b175-47ad8553881d
md"""
## Los Angeles Metric
"""

# ╔═╡ 339c9547-a686-4e3d-8272-ba2ff5bc13d8
draw_ellipse(los_angeles_metric, -5.0, 0.01, 5.0, plotted_ellipse_distance, plotted_ellipse_focus_1, plotted_ellipse_focus_2)

# ╔═╡ a4ea467f-435e-4ef4-8f08-038f66f83ce3
md"""
## British Rail Metric
"""

# ╔═╡ 4c6a3847-2b4f-43a5-afcf-1ffd9803ab85
draw_ellipse(british_rail_metric, -5.0, 0.01, 5.0, plotted_ellipse_distance, plotted_ellipse_focus_1, plotted_ellipse_focus_2)

# ╔═╡ d54bc396-25c7-40c1-ba13-451480994085
md"""
## The Nameless Metric
"""

# ╔═╡ 53a5d109-76cc-4c69-8b4d-152d14ea9e2f
draw_ellipse(kagey_metric, -5.0, 0.01, 5.0, plotted_ellipse_distance, plotted_ellipse_focus_1, plotted_ellipse_focus_2)

# ╔═╡ 96bf0e0f-1e3e-41d9-8440-513148e7acc2
md""" 
## Hamming Distance
"""

# ╔═╡ 6542b64c-dfb5-4508-9e7b-1064dae63490
hamming_distance_distance = 70.0

# ╔═╡ b84742de-a620-483e-8a90-43aaa006e438
draw_ellipse(hamming_metric, -5.0, 0.01, 5.0, hamming_distance_distance, plotted_ellipse_focus_1, plotted_ellipse_focus_2)

# ╔═╡ a8ddfe06-66c8-4c4a-80d6-d8b5fa690442
md"""
# The parabola
Given a point (the focus) and a line (the directx), the parabola is the set of all points equidistant from the focus and the directx.
"""

# ╔═╡ 67988dd0-0ed6-4143-a5ea-71990d7128a6
function point_with_metric_on_parabola(d, error::Float64, x::Vector{Float64}, focus::Vector{Float64}, line::Vector{Float64})
	# line is of form (slope, (y) intercept)
	distance_to_focus = d(focus, x)

	# THIS IS REALLY SLOW
	# get shortest distance to line 
	# METHOD: generate circles until we get a point on the line
	distance_to_line = 0.0
	found_distance = false
	# for the maximum radius to search to, we know (0, y-intercept) will be a point
	max_radius = d(x, [0.0, line[2]])

	# radius is too small 
	if max_radius - distance_to_focus + error < 0
		return false
	end
	
	for r in 0.0:(error*10):max_radius
		if found_distance 
			break
		end
		# radius too big
		if r - distance_to_focus - error > 0
			return false 
		end
		
		minx = x[1]-r 
		maxx = x[1]+r
		miny = x[2]-r
		maxy = x[2]+r
		temp_circle_points = generate_circle_points(d, error, minx:error:maxx, miny:error:maxy, x, r)

		for i in 1:(size(temp_circle_points)[1])
			if temp_circle_points[i, 2] == line[1]*temp_circle_points[i, 1] + line[1]
				distance_to_line = r
				found_distance = true 
			end
		end
	end
	
	if abs(distance_to_focus - distance_to_line) < error
		return true
	end
		
	return false
end

# ╔═╡ 733d82d6-555f-472e-bd57-84a72aa1ef59
function generate_parabola_points(d, error::Float64, xrange, yrange, focus::Vector{Float64}, line::Vector{Float64})
	points = []
	for x in collect(xrange)
		for y in collect(yrange)
			if point_with_metric_on_parabola(d, error, [x,y], focus, line)
				if length(points) == 0
					points = [x y]
				else
					points = vcat(points, [x y])
				end
			end
		end
	end
	
	points		
end

# ╔═╡ 82c46cbc-b707-443c-a49e-3fd4770d5a98
function draw_parabola(d, min::Float64, step::Float64, max::Float64, focus::Vector{Float64}, line::Vector{Float64}) 
	parabola_points = generate_parabola_points(d, step, min:step:max, min:step:max, focus, line)

	if length(parabola_points) != 0
		scatter(
			# get x and y coords
			parabola_points[:, 1], 
			parabola_points[:, 2],
	
			# aspect ratio and xy lims
			aspect_ratio = :equal,
			xlims = (min, max),
			ylims = (min, max),
	
			# remove outlines on scatter points 
			markerstrokewidth = 0,
	
			# make points smaller to look more like line 
			markersize = 0.7,
			legend=false
		)
	
		scatter!([f1[1]], [f1[2]], label="focus", color=:red)

		linef(x) = line[1]*x + line[2] 
		plot!(linef, color=:red)
	end
end

# ╔═╡ d06a617a-498d-4dd3-9d23-a26982901aa6
begin
	plotted_parabola_focus = [0.0, 1.0]
	plotted_parabola_line = [0.0, 0.0]
end

# ╔═╡ 1e88fb83-5a7a-42db-8a04-d460059334f6
md"""
## Euclidean Metric
"""

# ╔═╡ 12972266-9e2d-44d5-9d4d-f5485c07361b
# ╠═╡ disabled = true
#=╠═╡
draw_parabola(euclidean_metric, -5.0, 0.01, 5.0, plotted_parabola_focus, plotted_parabola_line)
  ╠═╡ =#

# ╔═╡ Cell order:
# ╠═254b007d-efb5-4993-b43e-418f7bd11332
# ╠═48652398-8ed6-11ee-2526-67021ebf95a0
# ╠═b08699bb-6650-4e11-a385-e700fc640120
# ╠═517707aa-f479-4773-884d-3fa12c360701
# ╠═da3718cd-63f7-40ce-8418-a0b7384e33eb
# ╠═6cc6237e-2a64-46c5-bf55-2d00e0e38117
# ╠═2ce923df-af4a-4f7e-ba93-6428cf06d984
# ╠═f7ee6693-8dda-4322-96b3-57062c64c12a
# ╠═1eea30a1-3e5a-491a-aae2-75dededfb253
# ╠═fa320223-4c91-4761-aa51-9b9cdafd2096
# ╠═58dd8e23-f47f-493e-ae96-8ec32958ab6a
# ╠═e5edd24e-675b-4f24-a8bb-6ffb60fe00dc
# ╟─427a67e1-a649-4597-8b86-a41bb022c00a
# ╠═57503fea-6a84-41c8-b496-27beed9e71ba
# ╠═4da3cb63-589a-4b1f-abda-77e44194a209
# ╠═27a6ca32-1e6e-4c51-b273-9443d617c92c
# ╠═b2b7572f-0a9d-4a63-b82c-1c1d21508a0f
# ╠═f803d10d-04ae-4b74-bf5c-faa2fd29c9b2
# ╠═6733ecc2-710d-47c9-a990-dd0846cd984a
# ╠═dbc93828-6824-40d2-aa23-e9a22a0ffd0c
# ╠═2483332c-24fa-4137-aa96-5d5471a13e0f
# ╠═09d4185c-9748-4667-8efc-debf1f0d4503
# ╟─0bd7d2e0-5f46-48b6-9e79-9592e77ddc2b
# ╠═13d322b7-0c4a-4de6-8a0d-7efa72faefc0
# ╠═b94a6a18-3ddf-417c-91bb-1e0cd00aecc2
# ╠═3a3d3ba5-e0b3-48ff-aece-fd319946959b
# ╠═8088edde-c7b4-40cc-8996-82c45d6152d0
# ╠═2b55ceac-0302-4d64-a858-3cc39f12674a
# ╟─d991dbaf-8383-4d71-91b3-d8088922a121
# ╠═402c07ec-7e4e-4358-8a89-333583245430
# ╠═efda48e4-4a71-4aa0-929a-9d2ca4069185
# ╠═71bcb6a6-a73b-4a99-b2d6-4b972cead490
# ╟─c8b1f3d1-4082-478f-abff-847e7eb4056f
# ╠═cda24dbf-2860-454a-8b70-9c8a2a24618e
# ╠═22b3df45-3dcd-4379-8fba-7c7d36163c9d
# ╠═f387de3f-029b-4881-8893-d9c622d838d0
# ╟─643adee4-de1e-4871-bac1-732a68115615
# ╠═5f75b2ce-4936-44f0-b3d8-3c6741b0ae29
# ╠═5111b738-091b-4809-bac1-66de7ed22c82
# ╠═7391bc2c-8ec2-4009-90d9-e0907a6e1ac8
# ╟─b3ff914d-6aa9-491f-9ab8-278f0c5cb062
# ╠═8a23d108-379f-493b-9a10-0d9283d8d2dc
# ╠═d0659baf-487b-4114-8efa-52782e19fde6
# ╠═6067853f-eba5-43b4-ad5a-0b39d720f9b8
# ╠═3acb42ae-db6d-45de-8d84-5ee12e0c1e6b
# ╟─2a65ca99-de61-4347-a5e6-c32ac448d1ca
# ╠═08a5d229-2f5b-4297-b864-71965ed44797
# ╠═b1d2ef3b-a41c-4020-af0d-a3186efc1638
# ╠═ea769411-62ab-4c1b-97b6-5478013c6e9f
# ╠═2048bcae-7524-4337-afca-c8f4ac474644
# ╠═de5d1c1d-ad87-48d1-a19f-f776e160961f
# ╠═255b1bd3-5b4f-4d89-83d5-a94f3ae12acc
# ╠═d88e0e37-495f-454c-b497-86efe8b72fa5
# ╠═1529149d-a943-4b61-8f6e-324ce98c849d
# ╠═3c293f7f-eeb8-4f6f-94d3-323d27caa0ae
# ╟─2af89c4b-a2cf-4737-9497-34e5d1fe82c5
# ╟─b25c76d1-4a5e-44cf-8d49-5c2769fca354
# ╟─d12ab470-be2e-4ea9-80f5-f39ea367b783
# ╟─588d7173-8466-46bc-8a5c-6fc78c53838b
# ╟─17ff5413-8788-4413-b8d9-ea2b27381d73
# ╟─c8073634-ade1-4230-9580-85775cadb6b3
# ╟─c4e96572-a8af-44fc-9ca8-a301ee924b2e
# ╟─1f1fc9b9-37c3-40a8-b579-a7ac6311f048
# ╟─5fcbacbf-b04d-4aa1-9ba1-047c24280cf5
# ╟─786f7040-a89a-44b6-bd53-04ec17141325
# ╟─7876951a-176a-40d1-a629-915c3e1238ea
# ╟─de860d23-04a8-4df7-9829-3cbfd2d4c770
# ╟─ca7ad9ac-b13c-4065-9ae2-8602aba37622
# ╟─4720e6a3-1b1e-44bc-b81b-2cf437cc7043
# ╟─b6c15256-8a36-4014-8b41-15d899524ea6
# ╟─2df6d836-1327-4539-9732-5ebbb9ad6b2c
# ╟─fd7c5e74-7226-4f6c-978a-00f683a847d8
# ╠═8d2c2e87-7668-49e0-9e3a-1f5a1c9d76bd
# ╟─558d13f4-c934-4123-a5a2-39d535dfc3a8
# ╟─d43819d5-e076-4c37-9c41-0d56e947e935
# ╠═d467d34b-ed2e-4040-a91c-18d4680b7983
# ╠═f5008e70-05c8-4e5a-bd2c-d1e6cdef7b4f
# ╠═2eba8e2b-9913-4a2c-ae2c-f2192496bb45
# ╠═e5da67b8-88a0-45c0-b8d8-0b4280fa5133
# ╟─5b58c8c9-8a62-4a39-9aef-2e6e9a020b88
# ╟─277c9588-a1a6-45c0-aac5-bc8efe59b0a9
# ╟─121d24cd-500f-4cff-9882-cf080e225ab7
# ╟─a4c7b55f-6789-4b27-9625-f326b1ebff99
# ╟─37cecf9b-9706-4318-a4db-41eb07a772e4
# ╟─690ef391-9165-4632-95af-49413766fd28
# ╟─343da7de-8f1d-4c4f-8d0c-71682349ec97
# ╟─27e5455a-f6aa-4cfa-9bf9-08be902721d4
# ╟─452dd447-3aef-4e4a-804e-f827efe255ad
# ╟─242fb4d9-24d3-464d-9b2d-19c099e883ac
# ╟─7e4d6009-080c-4810-b175-47ad8553881d
# ╟─339c9547-a686-4e3d-8272-ba2ff5bc13d8
# ╟─a4ea467f-435e-4ef4-8f08-038f66f83ce3
# ╟─4c6a3847-2b4f-43a5-afcf-1ffd9803ab85
# ╟─d54bc396-25c7-40c1-ba13-451480994085
# ╟─53a5d109-76cc-4c69-8b4d-152d14ea9e2f
# ╟─96bf0e0f-1e3e-41d9-8440-513148e7acc2
# ╠═6542b64c-dfb5-4508-9e7b-1064dae63490
# ╟─b84742de-a620-483e-8a90-43aaa006e438
# ╟─a8ddfe06-66c8-4c4a-80d6-d8b5fa690442
# ╠═67988dd0-0ed6-4143-a5ea-71990d7128a6
# ╠═733d82d6-555f-472e-bd57-84a72aa1ef59
# ╠═82c46cbc-b707-443c-a49e-3fd4770d5a98
# ╠═d06a617a-498d-4dd3-9d23-a26982901aa6
# ╟─1e88fb83-5a7a-42db-8a04-d460059334f6
# ╠═12972266-9e2d-44d5-9d4d-f5485c07361b
