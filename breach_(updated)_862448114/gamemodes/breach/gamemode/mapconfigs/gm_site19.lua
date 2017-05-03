--Version 2.1 of gm_site19 config by Link2006

------------------------------------------------------------------------------
--Changlog:																	--
--	2.2																		--
--	*Stopped updating changelog, re-forked from workshop (4/15/2017)		--
--	2.1																		--
--	*Moved SCP-035's Spawn 													--
--	*Changed how some doors works, unlocking them in the process			--
--	2.0																		--
--	*Forked current version of mapconfig from workshop as of 27th february	--
--	*Puts back MTF in medbay BECAUSE LOL NO >_>...							--
--	*Fixes Gate A															--
------------------------------------------------------------------------------
function Link2006_DoorCheck(ply,ent)
	if preparing then
		--ent:Fire("lock")
		return false
	else
		if ent:GetSaveTable( ).m_bLocked then --The door is locked! Unlock it!
			print("Forcing door unlock!")
			ent:Fire("unlock")
			ent:Fire("use") --Open it now so the user doesnt have to press it again :)
		end
		return true
	end

end
-- Serverside map config file, if you want to use a diffrent map change these variables
CAMERAS = {
	{
	 name = "OUTSIDE",
	 pos = Vector(-175.584122, 6703.034180, 1725.708130),
	 ang = Angle(0.000, 146.079, 0.000)
	},
	{
	 name = "GATE_A",
	 pos = Vector(-697.264893, 5349.814941, 226.462402),
	 ang = Angle(0.000, -12.395, 0.000)
	},
	{
	 name = "GATE_B",
	 pos = Vector(-3950.994873, 2414.622559, 190.495819),
	 ang = Angle(0.000, -48.519, 0.000)
	},
	{
	 name = "CAFETERIA",
	 pos = Vector(53.675919, 3155.835693, 140.282364),
	 ang = Angle(0.000, 88.400, 0.000)
	},
	{
	 name = "HCZ_TESLA",
	 pos = Vector(4210.521484, 2002.322388, 149.438217),
	 ang = Angle(0.000, -101.296, 0.000)
	},
	{
	 name = "HCZ_1",
	 pos = Vector(3171.853516, 2657.589111, 50.352276),
	 ang = Angle(0.000, -153.835, 0.000)
	},
	{
	 name = "SCP_173",
	 pos = Vector(816.530701, 1170.705566, 337.440979),
	 ang = Angle(0.000, 134.616, 0.000)
	},
	{
	 name = "SCP_106",
	 pos = Vector(2868.708252, 4928.124023, 166.737183),
	 ang = Angle(0.000, -134.537, 0.000)
	},
	{
	 name = "LCZ_MAIN",
	 pos = Vector(718.819336, -58.217102, 181.064407),
	 ang = Angle(0.000, -56.380, 0.000)
	},
	{
	 name = "LCZ_DCELLS",
	 pos = Vector(-659.140808, 1138.599976, 350.122894),
	 ang = Angle(0.000, -173.823, 0.000)
	},
}

SPAWN_173 = Vector(1170.1145019531, 1646.2163085938, 153.03125)
SPAWN_106 = Vector(2216.1745605469, 4706.0395507813, -422.96875)
SPAWN_049 = Vector(4718.4541015625, -2004.3891601563, 41.03125)
SPAWN_457 = Vector(2113.2243652344, 1783.6844482422, 25.03125)
--SPAWN_035 = Vector(4137.497070, -176.827774, -443.28875732422)
SPAWN_035 = Vector(5362.450684,-823.380737,0.031250)
SPAWN_966 = Vector(4380.3989257813, 2345.3510742188, 25.031242370605)
SPAWN_939 = Vector(1141.1956787109, -782.48986816406, -742.96875)
SPAWN_682 = Vector(2053.1604003906, 3009.12109375, -358.96875)
ENTER914 = Vector(1648.743164, -601.740234, 59.760605)
EXIR914 = Vector(1651.584229, -1052.149902, 7.470211)
POS_914BUTTON = Vector(1567.000000, -832.000000, 46.000000)
POS_914B_BUTTON = Vector(1563.000000, -832.000000, 62.000000)
OUTSIDESOUNDS = Vector(-94.663620, 5188.103027, 860.134155)
SPAWN_CLASSD = {
	Vector(-702.85070800781, 64.80500793457, 249.03125),
	Vector(-838.67333984375, 64.867546081543, 249.03125),
	Vector(-961.22979736328, 67.616470336914, 249.03125),
	Vector(-1086.9588623047, 56.918472290039, 249.03125),
	Vector(-1218.3486328125, 61.219841003418, 249.03125),
	Vector(-1345.4516601563, 61.90779876709, 249.03125),
	Vector(-1471.0550537109, 66.60604095459, 249.03125),
	Vector(-1603.1489257813, 63.129245758057, 249.03125),
	Vector(-1730.8079833984, 64.790786743164, 249.03125),
	Vector(-707.50115966797, 1662.7468261719, 153.03125),
	Vector(-837.79919433594, 1659.5744628906, 153.03125),
	Vector(-967.89178466797, 1663.169921875, 153.03125),
	Vector(-1098.1320800781, 1664.2813720703, 153.03125),
	Vector(-1608.6940917969, 1659.3273925781, 153.03125),
	Vector(-1731.6309814453, 1663.1774902344, 153.03125),
	Vector(-1860.6899414063, 1663.4801025391, 153.03125),
	Vector(-1853.1529541016, 1923.0112304688, 153.03125),
	Vector(-1725.9998779297, 1917.1000976563, 153.03125),
	Vector(-1593.8201904297, 1919.8090820313, 153.03125),
	Vector(-707.84350585938, 1921.794921875, 153.03125),
	Vector(-836.06774902344, 1917.1502685547, 153.03125),
	Vector(-964.8095703125, 1916.5043945313, 153.03125),
	Vector(-1095.4549560547, 1910.9403076172, 153.03125),
	Vector(-1933.7625732422, 1809.9555664063, 153.03125),
	Vector(-1835.7076416016, 1774.4565429688, 153.03125),
	Vector(-1751.9880371094, 1823.6674804688, 153.03125),
	Vector(-1655.0698242188, 1773.8054199219, 153.03125),
	Vector(-1544.4388427734, 1827.6722412109, 153.03125),
	Vector(-1400.1765136719, 1751.2944335938, 153.03125),
	Vector(-1350.4924316406, 1856.6402587891, 153.03125),
	Vector(-1233.1610107422, 1772.3951416016, 153.03125),
	Vector(-1080.2213134766, 1823.7796630859, 153.03125),
	Vector(-949.23388671875, 1763.1489257813, 153.03125),
	Vector(-791.66558837891, 1809.8173828125, 153.03125),
	Vector(-2073.2976074219, 1750.6928710938, 153.03125),
	Vector(-2093.9233398438, 1856.1706542969, 153.03125),
	Vector(-2164.7727050781, 136.39616394043, 249.03125),
	Vector(-2023.1119384766, 179.23406982422, 249.03125),
	Vector(-1911.7860107422, 172.16578674316, 249.03125),
	Vector(-1831.1555175781, 232.30458068848, 249.03125),
	Vector(-1735.6828613281, 168.19203186035, 249.03125),
	Vector(-1650.7102050781, 218.29597473145, 249.03125),
	Vector(-1578.3649902344, 171.33364868164, 249.03125),
	Vector(-1447.8361816406, 223.24230957031, 249.03125),
	Vector(-1307.7791748047, 170.0341796875, 249.03125),
	Vector(-1169.4654541016, 220.54293823242, 249.03125),
	Vector(-995.85827636719, 158.083984375, 249.03125),
	Vector(-812.9267578125, 220.68112182617, 249.03125),
	Vector(-926.74584960938, 213.29931640625, 249.03125),
	Vector(-1098.1022949219, 168.22138977051, 249.03125),
	Vector(-746.90692138672, 172.3929901123, 249.03125)
}
--[[
SPAWN_GUARD = {
	Vector(-2637.5424804688, 2981.3862304688, 25.031242370605),
	Vector(-2622.9819335938, 3047.337890625, 25.03125),
	Vector(-2549.7307128906, 2982.3903808594, 25.031242370605),
	Vector(-2542.0732421875, 3035.7126464844, 25.031242370605),
	Vector(-2459.6274414063, 2989.0141601563, 25.031257629395),
	Vector(-2448.4230957031, 3051.5207519531, 25.031257629395),
	Vector(-2405.1989746094, 2791.6044921875, 25.03125),
	Vector(-2337.0092773438, 2849.8659667969, 25.031242370605),
	Vector(-2384.4353027344, 2926.015625, 25.03125),
	Vector(-2307.8696289063, 2948.6916503906, 25.03125),
	Vector(-2263.2790527344, 2992.5393066406, 25.03125),
	Vector(-2265.9221191406, 3073.4172363281, 25.031242370605),
	Vector(-2334.2490234375, 3017.7644042969, 25.031242370605),
	Vector(-2395.6357421875, 3007.9411621094, 25.03125),
	Vector(-2373.9528808594, 3095.453125, 25.03125),
	Vector(-2325.7509765625, 3158.4167480469, 25.03125),
	Vector(-2393.5139160156, 3173.3645019531, 25.03125),
	Vector(-2342.0712890625, 3239.8225097656, 25.03125),
	Vector(-2401.5490722656, 3256.095703125, 25.031257629395),
	Vector(-2213.4887695313, 3651.46484375, 25.03125),
	Vector(-2329.5437011719, 3672.24609375, 25.031257629395),
	Vector(-2415.8010253906, 3675.138671875, 25.03125),
	Vector(-2301.927734375, 3600.0405273438, 25.03125),
	Vector(-2398.8254394531, 3452.1293945313, 25.03125),
	Vector(-2338.0563964844, 3450.7221679688, 25.031257629395),
	Vector(-2379.6650390625, 3576.435546875, 25.03125),
	Vector(-2325.5715332031, 3532.2687988281, 25.03125),
	Vector(-2143.3798828125, 3613.2214355469, 25.03125),
	Vector(-1610.5246582031, 3632.3798828125, 25.03125),
	Vector(-1638.2263183594, 3685.2038574219, 25.03125),
	Vector(-1776.7841796875, 3645.6342773438, 25.031257629395),
	Vector(-1800.4613037109, 3679.9221191406, 25.031242370605),
	Vector(-1888.828125, 3637.56640625, 25.03125),
	Vector(-1912.1921386719, 3677.4951171875, 25.031242370605),
	Vector(-2338.2319335938, 3729.7436523438, 25.03125),
	Vector(-2431.9304199219, 2333.9929199219, 25.031246185303),
	Vector(-2313.6264648438, 2353.4145507813, 25.031253814697),
	Vector(-2172.0400390625, 2364.1860351563, 25.03125),
	Vector(-2222.0012207031, 2410.5261230469, 25.03125),
	Vector(-2305.4428710938, 2402.1826171875, 25.03125),
	Vector(-2385.2253417969, 2409.7795410156, 25.031257629395),
	Vector(-2397.6740722656, 2500.4743652344, 25.03125),
	Vector(-2331.3569335938, 2567.0270996094, 25.03125),
	Vector(-2381.5053710938, 2589.2827148438, 25.03125),
}
--]]
SPAWN_GUARD = {
	--FIXED BY LINK2006 OK THX HAVE FUN NOW PLEASE DONT BOTHER ME ANYMORE :(
	--I generated these, not manually picked, SHOULD STILL WORK
	--If it doesnt then uh ill fix it again ok thx

	Vector(-1451,3436,10),
	Vector(-1451,3372,10),
	Vector(-1451,3308,10),
	Vector(-1515,3500,10),
	Vector(-1515,3436,10),
	Vector(-1515,3372,10),
	Vector(-1515,3308,10),
	Vector(-1579,3500,10),
	Vector(-1579,3436,10),
	Vector(-1579,3372,10),
	Vector(-1579,3308,10),
	Vector(-1643,3500,10),
	Vector(-1643,3436,10),
	Vector(-1643,3372,10),
	Vector(-1643,3308,10),
	Vector(-1707,3500,10),
	Vector(-1707,3436,10),
	Vector(-1707,3372,10),
	Vector(-1707,3308,10),
	Vector(-1771,3500,10),
	Vector(-1771,3436,10),
	Vector(-1771,3372,10),
	Vector(-1771,3308,10),
	Vector(-1835,3500,10),
	Vector(-1835,3436,10),
	Vector(-1835,3372,10),
	Vector(-1835,3308,10),
	Vector(-1961,3302,10),
	Vector(-1960,3383,10)

}

--Parsee's Map Gen, Generated at 22:33:37
SPAWN_OUTSIDE = {
	Vector(-118,6885,1700),
	Vector(-193,6885,1700),
	Vector(-268,6885,1700),
	Vector(-343,6885,1700),
	Vector(-418,6885,1700),
	Vector(-493,6885,1700),
	Vector(-568,6885,1700),
	Vector(-643,6885,1700),
	Vector(-718,6885,1700),
	Vector(-793,6885,1700),
	Vector(-868,6885,1700),
	Vector(-943,6885,1700),
	Vector(-1018,6885,1700),
	Vector(-1093,6885,1700),
	Vector(-1168,6885,1700),
	Vector(-1243,6885,1700),
	Vector(-1318,6885,1700),
	Vector(-1393,6885,1700),
	Vector(-1468,6885,1700),
	Vector(-1543,6885,1700),
	Vector(-1618,6885,1700),
	Vector(-1693,6885,1700),
	Vector(-1768,6885,1700),
	Vector(-1843,6885,1700),
	Vector(-1918,6885,1700),
	Vector(-118,6960,1700),
	Vector(-193,6960,1700),
	Vector(-268,6960,1700),
	Vector(-343,6960,1700),
	Vector(-418,6960,1700),
	Vector(-493,6960,1700),
	Vector(-568,6960,1700),
	Vector(-643,6960,1700),
	Vector(-718,6960,1700),
	Vector(-793,6960,1700),
	Vector(-868,6960,1700),
	Vector(-943,6960,1700),
	Vector(-1018,6960,1700),
	Vector(-1093,6960,1700),
	Vector(-1168,6960,1700),
	Vector(-1243,6960,1700),
	Vector(-1318,6960,1700),
	Vector(-1393,6960,1700),
	Vector(-1468,6960,1700),
	Vector(-1543,6960,1700),
	Vector(-1618,6960,1700),
	Vector(-1693,6960,1700),
	Vector(-1768,6960,1700),
	Vector(-1843,6960,1700),
	Vector(-1918,6960,1700),
	Vector(-118,7035,1700),
	Vector(-193,7035,1700),
	Vector(-268,7035,1700),
	Vector(-343,7035,1700),
	Vector(-418,7035,1700),
	Vector(-493,7035,1700),
	Vector(-568,7035,1700),
	Vector(-643,7035,1700),
	Vector(-718,7035,1700),
	Vector(-793,7035,1700),
	Vector(-868,7035,1700),
	Vector(-943,7035,1700),
	Vector(-1018,7035,1700),
	Vector(-1093,7035,1700),
	Vector(-1168,7035,1700),
	Vector(-1243,7035,1700),
	Vector(-1318,7035,1700),
	Vector(-1393,7035,1700),
	Vector(-1468,7035,1700),
	Vector(-1543,7035,1700),
	Vector(-1618,7035,1700),
	Vector(-1693,7035,1700),
	Vector(-1768,7035,1700),
	Vector(-1843,7035,1700),
	Vector(-1918,7035,1700),
	Vector(-118,7110,1700),
	Vector(-193,7110,1700),
	Vector(-268,7110,1700),
	Vector(-343,7110,1700),
	Vector(-418,7110,1700),
	Vector(-493,7110,1700),
	Vector(-568,7110,1700),
	Vector(-643,7110,1700),
	Vector(-718,7110,1700),
	Vector(-793,7110,1700),
	Vector(-868,7110,1700),
	Vector(-943,7110,1700),
	Vector(-1018,7110,1700),
	Vector(-1093,7110,1700),
	Vector(-1168,7110,1700),
	Vector(-1243,7110,1700),
	Vector(-1318,7110,1700),
	Vector(-1393,7110,1700),
	Vector(-1468,7110,1700),
	Vector(-1543,7110,1700),
	Vector(-1618,7110,1700),
	Vector(-1693,7110,1700),
	Vector(-1768,7110,1700),
	Vector(-1843,7110,1700),
	Vector(-1918,7110,1700),
}

--[[
SPAWN_OUTSIDE = {
	Vector(579.63977050781, 7103.6142578125, 1537.4864501953),
	Vector(568.88232421875, 7025.8452148438, 1537.03125),
	Vector(577.2490234375, 6944.6201171875, 1537.1876220703),
	Vector(567.37609863281, 6868.9775390625, 1537.03125),
	Vector(523.37628173828, 6720.5170898438, 1689.03125),
	Vector(442.57070922852, 6711.2465820313, 1689.03125),
	Vector(364.69982910156, 6714.5688476563, 1689.03125),
	Vector(261.11761474609, 6719.2880859375, 1689.03125),
	Vector(149.99046325684, 6725.8676757813, 1689.03125),
	Vector(-12.66552734375, 6729.7016601563, 1689.03125),
}
]]--
SPAWN_SCIENT = {
	Vector(1995.9304199219, -1485.0512695313, 25.03125),
	Vector(807.32543945313, -730.02093505859, 25.031265258789),
	Vector(-212.22616577148, 1083.9949951172, 25.03125),
	Vector(124.10859680176, 1049.1551513672, 153.03125),
	Vector(2230.8051757813, 1092.9071044922, 25.03125),
	Vector(2997.8173828125, -1296.0461425781, -6.9687385559082),
	Vector(1502.5690917969, -2131.0397949219, 26.031246185303),
	Vector(882.10412597656, -2033.3894042969, 25.03125),
	Vector(2119.5578613281, -661.15130615234, 25.03125),
	Vector(2264.6882324219, -199.16720581055, 25.03125),
	Vector(2622.7255859375, -248.55999755859, 25.03125),
}
SPAWN_KEYCARD2 = {
	lczaround1 = {
		Vector(1887.6312255859, 399.236328125, 25.03125),
		Vector(1824.4675292969, 396.38125610352, 25.031257629395),
		Vector(1761.1815185547, 396.84323120117, 25.031242370605),
		Vector(1696.2419433594, 397.51885986328, 25.03125),
		Vector(1694.6402587891, 495.98379516602, 25.03125),
		Vector(1761.8922119141, 499.29299926758, 25.03125),
		Vector(1823.6177978516, 497.40637207031, 25.031257629395),
		Vector(1890.5753173828, 496.13067626953, 25.03125),
		Vector(1757.935546875, 669.06896972656, 25.03125),
		Vector(1794.2694091797, 216.38833618164, 25.03125),
		Vector(2620.4216308594, 558.80389404297, 25.03125),
		Vector(-430.46026611328, -183.53916931152, -230.96875),
		Vector(-12.651611328125, -1056.9056396484, -102.96875),
		Vector(-974.37542724609, 67.640411376953, 249.03125),
	},
	lczaround2 = {
		Vector(-380.48553466797, 1268.8239746094, 61.031242370605),
		Vector(-326.81188964844, 1342.9997558594, 61.03125),
		Vector(-165.37107849121, 1339.5402832031, 61.031242370605),
		Vector(-374.80639648438, 893.68597412109, 61.03125),
		Vector(-124.70316314697, 865.77581787109, 25.03125),
		Vector(-551.49169921875, 1936.2393798828, 25.03125),
		Vector(100.75199890137, 1945.6391601563, 281.03125),
		Vector(51.891372680664, 958.77886962891, 153.03125),
	},
}
SPAWN_KEYCARD3 = {
	lcz1 = {
		Vector(252.04986572266, -268.36831665039, 25.031242370605),
		Vector(1178.8115234375, 483.99725341797, 25.03125),
		Vector(1690.0988769531, 887.92370605469, 25.03125),
		Vector(2290.9619140625, 882.66888427734, 25.03125),
		Vector(2296.5632324219, 1294.0756835938, 25.03125),
		Vector(1913.0944824219, 1299.4796142578, 25.031246185303),
		Vector(577.58575439453, -1661.7059326172, 26.03125),
		Vector(2176.7341308594, -2184.7875976563, 26.03125),
		Vector(-1425.9385986328, -776.90399169922, 26.03125),
		Vector(1172.5024414063, 1575.5208740234, 153.03125),
	},
}
SPAWN_KEYCARD4 = {
	hcz1 = {
		Vector(4040.4565429688, 476.07879638672, -358.96875),
		Vector(5486.19140625, 1085.0155029297, -486.96875),
		Vector(5574.3549804688, -901.83563232422, 25.03125),
		Vector(7248.1860351563, 4701.0512695313, -1124.6066894531),
		Vector(5081.1430664063, 3711.32421875, 25.03125),
	},
	hcz2 = {
		Vector(5010.1948242188, 2369.1730957031, 25.031246185303),
		Vector(-1152.4465332031, 2534.8041992188, 25.03125),
		Vector(-986.68151855469, 2596.1647949219, 25.031265258789),
		Vector(-734.42797851563, 2957.5979003906, 25.03125),
		Vector(-1923.3026123047, 2529.1867675781, -102.96875),
		Vector(1580.5499267578, 3979.6494140625, 25.03125),
		Vector(1003.4965209961, -1023.8135986328, -742.96875),
		Vector(932.18872070313, -334.18151855469, -742.96875),
		Vector(1467.6193847656, -1958.6475830078, -742.96875),
	},
}
SPAWN_MEDKITS = {
	Vector(-1498.2027587891, 3482.6940917969, 25.03125),
	Vector(-60.792743682861, 3149.59765625, -102.96875),
	Vector(474.02795410156, 2488.3110351563, 61.03125),
	Vector(1895.6101074219, 3503.5322265625, -230.96875),
}
SPAWN_MISCITEMS = {
	Vector(2750.3227539063, -1148.0911865234, -6.96875),
	Vector(136.375, -673.91833496094, 25.03125),
	Vector(261.33114624023, 3815.8701171875, -62.96875),
	Vector(1435.9907226563, 3064.5197753906, 89.03125),
	Vector(1426.5910644531, 1951.9095458984, 61.03125),
	Vector(445.50457763672, 3501.6372070313, -62.96875),
	Vector(5511.9252929688, -256.80694580078, 26.03125),
	Vector(4793.91796875, -2726.2077636719, 41.031265258789),
}
SPAWN_MELEEWEPS = {
	Vector(2750.3227539063, -1148.0911865234, -6.96875),
	Vector(136.375, -673.91833496094, 25.03125),
	Vector(261.33114624023, 3815.8701171875, -62.96875),
	Vector(1435.9907226563, 3064.5197753906, 89.03125),
	Vector(-1520.3510742188, 2550.8671875, -102.96873474121),
	Vector(-48.573299407959, 2270.046875, 25.031248092651),
	Vector(1784.5053710938, 3487.2453613281, 25.03125),
	Vector(3999.53515625, 3875.9763183594, 25.03125),
}
SPAWN_AMMO_RIFLE = {
	/*
	// -25
	Vector(2391.1572265625, 2578.5590820313, 50.031257629395),
	Vector(2350.8493652344, 2577.8688964844, 50.03125),
	Vector(2313.0402832031, 2579.9675292969, 50.03125),
	Vector(2269.5856933594, 2581.1691894531, 50.031234741211),
	Vector(2220.2348632813, 2581.1796875, 50.03125),
	Vector(2155.7709960938, 2581.4853515625, 50.031265258789),
	*/
	// 0
	Vector(2391.1572265625, 2578.5590820313, 25.031257629395),
	Vector(2350.8493652344, 2577.8688964844, 25.03125),
	Vector(2313.0402832031, 2579.9675292969, 25.03125),
	Vector(2269.5856933594, 2581.1691894531, 25.031234741211),
	Vector(2220.2348632813, 2581.1796875, 25.03125),
	Vector(2155.7709960938, 2581.4853515625, 25.031265258789),
	/*
	// 15
	Vector(2391.1572265625, 2578.5590820313, 10.031257629395),
	Vector(2350.8493652344, 2577.8688964844, 10.03125),
	Vector(2313.0402832031, 2579.9675292969, 10.03125),
	Vector(2269.5856933594, 2581.1691894531, 10.031234741211),
	Vector(2220.2348632813, 2581.1796875, 10.03125),
	Vector(2155.7709960938, 2581.4853515625, 10.031265258789),
	*/
}
SPAWN_AMMO_SMG = {
	/*
	// -25
	Vector(2386.9731445313, 2511.6652832031, 50.03125),
	Vector(2338.5004882813, 2510.6872558594, 50.03125),
	Vector(2292.9138183594, 2511.2185058594, 50.031242370605),
	Vector(2249.265625, 2511.1567382813, 50.03125),
	Vector(2211.2785644531, 2511.9333496094, 50.031242370605),
	Vector(2151.271484375, 2511.6572265625, 50.031242370605),
	*/
	// 0
	Vector(2386.9731445313, 2511.6652832031, 25.03125),
	Vector(2338.5004882813, 2510.6872558594, 25.03125),
	Vector(2292.9138183594, 2511.2185058594, 25.031242370605),
	Vector(2249.265625, 2511.1567382813, 25.03125),
	Vector(2211.2785644531, 2511.9333496094, 25.031242370605),
	Vector(2151.271484375, 2511.6572265625, 25.031242370605),
	/*
	// 15
	Vector(2386.9731445313, 2511.6652832031, 10.03125),
	Vector(2338.5004882813, 2510.6872558594, 10.03125),
	Vector(2292.9138183594, 2511.2185058594, 10.031242370605),
	Vector(2249.265625, 2511.1567382813, 10.03125),
	Vector(2211.2785644531, 2511.9333496094, 10.031242370605),
	Vector(2151.271484375, 2511.6572265625, 10.031242370605),
	*/
}
SPAWN_AMMO_PISTOL = {
	// -25
	Vector(1290.6429443359, -1637.1260986328, 50.03125),
	Vector(1345.4158935547, -1644.6148681641, 50.03125),
	Vector(1397.8614501953, -1637.9936523438, 50.031242370605),
	Vector(1450.0047607422, -1629.9807128906, 50.03125),
	Vector(1505.3006591797, -1630.8707275391, 50.03125),
	/*
	// 0
	Vector(1290.6429443359, -1637.1260986328, 25.03125),
	Vector(1345.4158935547, -1644.6148681641, 25.03125),
	Vector(1397.8614501953, -1637.9936523438, 25.031242370605),
	Vector(1450.0047607422, -1629.9807128906, 25.03125),
	Vector(1505.3006591797, -1630.8707275391, 25.03125),
	// 15
	Vector(1290.6429443359, -1637.1260986328, 10.03125),
	Vector(1345.4158935547, -1644.6148681641, 10.03125),
	Vector(1397.8614501953, -1637.9936523438, 10.031242370605),
	Vector(1450.0047607422, -1629.9807128906, 10.03125),
	Vector(1505.3006591797, -1630.8707275391, 10.03125),
	*/
}
SPAWN_PISTOLS = {
	Vector(1306.6872558594, -1539.5855712891, 25.03125),
	Vector(1362.4619140625, -1472.6813964844, 25.03125),
	Vector(1387.7770996094, -1564.5247802734, 25.031257629395),
	Vector(5027.13671875, 2145.2348632813, 25.03125),
}
SPAWN_SMGS = {
	Vector(3907.4184570313, -950.953125, -102.96874237061),
	Vector(2112.7260742188, -1783.591796875, -742.96875),
	Vector(2365.2807617188, 2168.3273925781, 25.031242370605),
	Vector(2303.095703125, 2163.4182128906, 25.03125),
	Vector(2229.4418945313, 2164.8308105469, 25.031257629395),
	Vector(2874.5942382813, 3174.7854003906, -357.96875),
}
SPAWN_RIFLES = {
	Vector(2372.6345214844, 2263.8930664063, 25.03125),
	Vector(2305.3864746094, 2267.7570800781, 25.031257629395),
	Vector(2232.0844726563, 2277.7563476563, 25.03125),
	Vector(2157.0791015625, 2271.2629394531, 25.03125),
	Vector(2365.5954589844, 2420.1538085938, 25.03125),
	Vector(2375.4252929688, 2349.3283691406, 25.03125),
	Vector(-26.028911590576, 6464.5141601563, 2617.03125),
}
SPAWN_ZOMBIES = {
	Vector(3445.1667480469, 2278.5283203125, 25.031257629395),
	Vector(2918.9267578125, 3126.3176269531, -357.96875),
	--Vector(4200.666015625, 2388.2761230469, 25.03125), --Makes player stuck inside a room.
	Vector(5222, 504, 25), --Upstairs coffin room
	Vector(5440, 1087, -420), --Downstairs coffin room
	Vector(4232.0258789063, 1082.2418212891, 26.03125),
	--Vector(4356.6499023438, 211.40533447266, -358.96875), --Requires Elevator
	--Vector(4140.6127929688, -638.91772460938, -485.96875), -- ^
	--Vector(4920.4853515625, -833.63983154297, -486.96875), -- ^
	Vector(2094.861816, 1800.473389, 0.031250), --Modified SCP-457's Spawn (!)
	Vector(2087.845703,1539.071045,25), --SCP-008 Room (assume infected mtf)
	Vector(3010,2369,25), --Some place near SCP-008
	Vector(3937.2629394531, -1322.8986816406, -102.96875762939),
	Vector(2492.5637207031, 1557.6303710938, 25.03125),
	Vector(2963.2214355469, 2275.380859375, 25.03125),
	Vector(2186.3120117188, 3662.9375, 26.03125),
	Vector(5399.9243164063, -130.13702392578, 26.031242370605),
	Vector(3721.201171875, -180.34083557129, 25.031242370605)
}
SPAWN_ARMORS = {
	/*
	// 0
	Vector(4045.8205566406, 219.45477294922, -358.96875),
	Vector(1578.0693359375, -1605.9057617188, 25.031242370605),
	Vector(5201.1669921875, -1010.1879882813, 25.031257629395),
	Vector(1852.3223876953, 5119.8525390625, -230.96875),
	*/
	// 15
	Vector(4045.8205566406, 219.45477294922, -373.96875),
	Vector(1578.0693359375, -1605.9057617188, 10.031242370605),
	Vector(5201.1669921875, -1010.1879882813, 10.031257629395),
	Vector(1852.3223876953, 5119.8525390625, -245.96875),
}
SPAWN_FIREPROOFARMOR = {
	Vector(2030.6306152344, 1535.6925048828, 5.03125),
	Vector(-2967.7331542969, 3819.6489257813, 261.03125),
	Vector(575.81390380859, -1244.8992919922, 5.031257629395),
	Vector(434.46051025391, 3265.0153808594, -82.96874237061),
}

BUTTONS = {
	{
		name = "173 Control Room Doors",
		pos = Vector(193.000000, 1768.000000, 309.000000),
		canactivate = function(pl, ent) return !preparing end,
		clevel = 3
	},
	{
		name = "173 Doors",
		pos = Vector(393.000000, 1288.000000, 181.000000),
		canactivate = function(pl, ent) return !preparing end
	},
	{
		name = "106 Doors",
		pos = Vector(2280.000000, 3959.000000, 53.000000),
		canactivate = function(pl, ent) return !preparing end
	},
	{
		name = "457 Doors",
		pos = Vector(2441.000000, 1896.000000, 53.000000),
		canactivate = function(pl, ent) return !preparing end
	},
	{
		name = "096 Doors",
		pos = Vector(4993.000000, 3432.000000, 53.000000),
		canactivate = function(pl, ent) return !preparing end
	},
	{
		name = "HCZ Main Doors",
		pos = Vector(1545.000000, 3752.000000, 53.000000),
		usesounds = true,
		clevel = 3
	},
	{
		name = "HCZ2 Main Doors",
		pos = Vector(2825.000000, 1192.000000, 53.000000),
		usesounds = true,
		clevel = 3
	},
	{
		name = "HCZ3 Main Doors",
		pos = Vector(2825.000000, -88.000000, 53.000000),
		usesounds = true,
		clevel = 3
	},
	{	--Fixed by Link2006
		name = "Control room",
		pos = Vector(-2328, 3775, 53),
		clevel = 4
	},
	{	--Fixed by Link2006
		name = "Remote Door Control",
		pos = Vector(-2452, 3876, 309.85998535156),
		clevel = 3,
		enabled = true
	},
	{
		--New Spawn is at MedBay
		--FIXED BY LINK2006
		name = "MTF Spawn Doors",
		pos = Vector(-1928.000000, 3551.000000, 53.000000),
		customdenymsg = "Wait for the round to start",
		canactivate = function(pl, ent)
			if roundtype then
				if roundtype.mtfandscpdelay == false then
					return true
				end
			end
			if preparing then
				//pl:PrintMessage(HUD_PRINTCENTER, "Wait for the round to start")
				return false
			else
				return true
			end
		end
	},
	{
		name = "Gate A",
		pos = Vector(-321.000000, 4784.000000, 53.000000),
		clevel = 4
	},
	{
		name = "Gate B",
		pos = Vector(-3790.500000, 2472.500000, 53.000000),
		clevel = 4
	},
	{
		name = "Armory room",
		pos = Vector(1801.000000, -1432.000000, 53.000000),
		usesounds = true,
		clevel = 4
	},
	{	--Fixed by Link2006
		name = "Cells Control Room",
		pos = Vector(-2239.000000, 1832.000000, 181.000000),
		clevel = 4
	},
	{
		name = "SCP 372",
		pos = Vector(-944.000000, -705.500000, 53.000000),
		usesounds = true,
		clevel = 2
	},
	{
		name = "Room 13",
		pos = Vector(1393.000000, 728.000000, 53.000000),
		clevel = 2
	},
	{
		name = "SCP 860, 1025",
		pos = Vector(2072.000000, 1185.000000, 53.000000),
		clevel = 2
	},
	{
		name = "SCP 178",
		pos = Vector(393.000000, -152.000000, 53.000000),
		clevel = 2
	},
	{
		name = "SCP 1123",
		pos = Vector(737.000000, -1240.000000, 53.000000),
		clevel = 2
	},
	{
		name = "SCP 914",
		pos = Vector(1264.000000, -958.500000, 53.000000),
		clevel = 3
	},
	{
		name = "914 Button",
		pos = POS_914BUTTON,
		customdenymsg = "",
		canactivate = function(pl, ent)
			Use914(ent)
			return false
		end
	},
	{
		name = "914 Button 2",
		pos = POS_914B_BUTTON,
		customdenymsg = "",
		canactivate = function(pl, ent)
			Use914B(pl, ent)
			return false
		end
	},
	{
		name = "SCP 1162",
		pos = Vector(1569.000000, 892.000000, 53.000000),
		clevel = 2
	},
	{
		name = "Checkpoint 1",
		pos = Vector(2968.000000, 273.000000, 53.000000),
		usesounds = true,
		clevel = 3
	},
	{
		name = "Checkpoint 2",
		pos = Vector(2616.000000, 641.000000, 53.000000),
		usesounds = true,
		clevel = 3
	},
	{
		name = "Checkpoint 3",
		pos = Vector(792.000000, 3977.000000, 53.000000),
		usesounds = true,
		clevel = 3
	},
	{
		name = "Armory room 2",
		pos = Vector(1289.000000, 2055.989990, 53.000000),
		usesounds = true,
		clevel = 5
	},
	{
		name = "Portal",
		pos = Vector(1289.000000, 2216.000000, 53.000000),
		usesounds = true,
		clevel = 5
	},
	{
		name = "Melon room",
		pos = Vector(3664.000000, 2156.000000, 59.000000),
		usesounds = true,
		clevel = 5
	},
	{
		name = "SCP 035",
		pos = Vector(5480.000000,-521.000000,53.000000),
		canactivate = function(pl, ent) return Link2006_DoorCheck(pl,ent) end --You can't open the door yet.
	},
	{
		name = "HCZ Elevators", --What can i do to force this entity to always open :c?
		pos = Vector(4809.000000,-152.000000,53.000000),
		canactivate = function(pl, ent) return Link2006_DoorCheck(pl,ent) end
	}

}

POS_GATEA = Vector(-6563.0942382813, -704.70709228516, 1803.7766113281)
POS_ESCORT = Vector(-2878.6206054688, 1741.7536621094, 1809.03125)
--POS_GATEABUTTON = Vector(-1316.000000, 3564.000000, 309.859985)
--Fixed by Link2006
--Changed escape to outside the facility (outside gate A and B)
--[[
POS_ESCAPEBOXMIN = Vector(-4092.824463,8832.515625,644.004456)
POS_ESCAPEBOXMAX = Vector(845.717041,12647.585938,1473.660400)
]]--
POS_ESCAPEBOXMIN = Vector(-5523.528320, 2814.606689, 2082.044434)
POS_ESCAPEBOXMAX = Vector(-7407.968750, 2192.031250, 2574.578369)
--END OF NEW TOWN
POS_GATEABUTTON = Vector(-321.000000, 4784.000000, 53.000000)
POS_173DOORS = Vector(362.000000, 1592.000000, 294.000000)
POS_106DOORS = Vector(1728.000000, 4103.000000, 46.000000)
POS_049BUTTON = Vector(5040.000000, -952.000000, -474.000000)
POS_173BUTTON = Vector(362.000000, 1592.000000, 294.000000)
POS_966BUTTON = Vector(4229.172852, 2246.827393, 122.439560)
POS_096BUTTON = Vector(4993.000000, 3592.000000, 53.000000)
POS_682BUTTON = Vector(2288.000000, 3396.010010, -201.139999)
POS_966BUTTON = Vector(4216.000000, 2256.000000, 38.000000)
POS_POCKETD = {
	Vector(2421.7827148438, 4650.9155273438, 537.03125),
	Vector(2378.9016113281, 4566.8305664063, 537.03125),
	Vector(2273.0007324219, 4526.1396484375, 537.03125),
	Vector(2203.7729492188, 4572.9760742188, 537.03125),
	Vector(2165.5126953125, 4657.6489257813, 537.03125),
	Vector(2233.5170898438, 4717.2373046875, 537.03125),
	Vector(2308.3076171875, 4728.3671875, 537.03125),
	Vector(2357.279296875, 4665.8432617188, 537.03125),
	Vector(2335.2951660156, 4590.3525390625, 537.03125),
	Vector(2279.5068359375, 4589.185546875, 537.03125),
	Vector(2300.6682128906, 4651.541015625, 537.03125),
	Vector(2246.9846191406, 4668.0068359375, 537.03125),
	Vector(2232.6259765625, 4620.3232421875, 537.03125)
}
