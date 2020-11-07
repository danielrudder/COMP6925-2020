using JuMP
using Clp

DEMANDS = [10011.22115007576, 9993.540857825825, 10029.493305561082, 9995.513032624265, 10040.407110819071, 10054.429367942921, 10059.76519849408, 9987.000868933652, 10035.54111237392, 9979.076532648018, 9973.268512810797, 10001.801162849199, 9977.013028384847, 10043.66957251199, 10052.449661342594, 9967.208355572673, 10000.69477091062, 10030.05030028466, 10004.993099108486, 9990.907712391863, 10048.51255532599, 10006.528026036742, 9995.689091324659, 9990.868630720339, 9997.195144776251, 9971.848670139489, 9945.536501292985, 9948.336004602528, 9997.577323187325, 9970.52023558712, 10069.401333593078, 10043.51650796613, 10047.132683479025, 10072.330774070775, 10031.89101682498, 10020.955889705769, 9934.338643331117, 10014.21570856934, 10000.845689612031, 10002.553802750448, 10029.850884936972, 9948.279191163045, 9971.233600233412, 9921.28110096277, 9969.291956593264, 9941.660187262343, 9970.955683172295, 10121.63150429881, 9890.3148430648, 10055.434949187049]

EXCESS = [134.0672034620664, 203.49627885971134, 96.43278005676987, 56.310493164142194, 154.9738583914022, 86.15470417280527, 117.69532653453007, 96.079337129117, 80.09657703013598, 117.97481950144807, 135.45359712891494, 65.27592949697987, 121.62387433789331, 157.90317403219916, 187.51502838324893, 103.1393924213361, 113.51034741649168, 105.15682758218587, 163.91306977364417, 65.01642785560641, 72.10332926270281, 81.75303696379427, 147.46261777711115, 77.89845314924122, 64.6561686497572, 80.49388427763157, 182.2693698869101, 94.51902772701776, 60.05765018100699, 51.46488274992752, -17.07572112519928, 75.18699384839144, 163.2718530661902, 66.34957681334164, 150.3327454747236, 150.0511683583951, -16.67698984690456, 85.29601994736976, 79.64475904526007, 80.45047329523308, 113.81449976770446, 63.197399827089825, 135.67184934757358, 129.7333200152908, 126.09844654360617, 160.93650810687356, 92.68178139134406, 34.91209124379864, 74.0219868656372, 83.61296247511396]

NUC_COST = 4500
COAL_COST = 2500
T = length(DEMANDS)

m = Model(Clp.Optimizer)
@variable(m, coal[1:T] >= 0)
@variable(m, nuc[1:T] >= 0)
@objective(m, Min, sum(NUC_COST * nuc[i] + COAL_COST * coal[i] for i = 1:T))

@expression(m, W, [sum(coal[t:-1:max(1, t-19)]) for t=1:T])
@expression(m, Z, [sum(nuc[t:-1:max(1, t-14)]) for t=1:T])
@constraint(m, W + Z .≥ DEMANDS - EXCESS)
@constraint(m, 0.8 * Z - 0.2 * W .≤ 0.2 * EXCESS)

#println(m)

optimize!(m)

# status = termination_status(m)
#
# println("Solution status: ", status)
#
# println("Objective value: ", objective_value(m))
println("x1 = ", value.(coal))
println("x2 = ", value.(nuc))
