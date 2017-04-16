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

SPAWN_173 = Vector(1073.8309326172, 1666.5076904297, 229.00595092773)
SPAWN_106 = Vector(2615.4692382813, 4062.5620117188, -372.16552734375)
SPAWN_049 = Vector(4664.01171875, -574.69091796875, -443.28875732422)
SPAWN_457 = Vector(2094.861816, 1733.473389, 0.031250)
--SPAWN_035 = Vector(4137.497070, -176.827774, -443.28875732422)
SPAWN_035 = Vector(5362.450684,-823.380737,0.031250)
SPAWN_682 = Vector(2050,3012,-300) --setpos 2050.540283 3012.019287 -319.968750
SPAWN_966 = Vector(4142.6518554688, 1102.2702636719, 25.03125)
ENTER914 = Vector(1648.743164, -601.740234, 59.760605)
EXIR914 = Vector(1651.584229, -1052.149902, 7.470211)
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
-- Generated 100 spawns, spawngen by Link2006 (private)
SPAWN_OUTSIDE = {
	Vector(-294,9875,645),
	Vector(-422,9875,645),
	Vector(-550,9875,645),
	Vector(-678,9875,645),
	Vector(-806,9875,645),
	Vector(-934,9875,645),
	Vector(-1062,9875,645),
	Vector(-1190,9875,645),
	Vector(-1318,9875,645),
	Vector(-1446,9875,645),
	Vector(-1574,9875,645),
	Vector(-1702,9875,645),
	Vector(-1830,9875,645),
	Vector(-1958,9875,645),
	Vector(-2086,9875,645),
	Vector(-2214,9875,645),
	Vector(-2342,9875,645),
	Vector(-2470,9875,645),
	Vector(-2598,9875,645),
	Vector(-2726,9875,645),
	Vector(-2854,9875,645),
	Vector(-2982,9875,645),
	Vector(-3110,9875,645),
	Vector(-3238,9875,645),
	Vector(-3366,9875,645),
	Vector(-294,9947,645),
	Vector(-422,9947,645),
	Vector(-550,9947,645),
	Vector(-678,9947,645),
	Vector(-806,9947,645),
	Vector(-934,9947,645),
	Vector(-1062,9947,645),
	Vector(-1190,9947,645),
	Vector(-1318,9947,645),
	Vector(-1446,9947,645),
	Vector(-1574,9947,645),
	Vector(-1702,9947,645),
	Vector(-1830,9947,645),
	Vector(-1958,9947,645),
	Vector(-2086,9947,645),
	Vector(-2214,9947,645),
	Vector(-2342,9947,645),
	Vector(-2470,9947,645),
	Vector(-2598,9947,645),
	Vector(-2726,9947,645),
	Vector(-2854,9947,645),
	Vector(-2982,9947,645),
	Vector(-3110,9947,645),
	Vector(-3238,9947,645),
	Vector(-3366,9947,645),
	Vector(-294,10019,645),
	Vector(-422,10019,645),
	Vector(-550,10019,645),
	Vector(-678,10019,645),
	Vector(-806,10019,645),
	Vector(-934,10019,645),
	Vector(-1062,10019,645),
	Vector(-1190,10019,645),
	Vector(-1318,10019,645),
	Vector(-1446,10019,645),
	Vector(-1574,10019,645),
	Vector(-1702,10019,645),
	Vector(-1830,10019,645),
	Vector(-1958,10019,645),
	Vector(-2086,10019,645),
	Vector(-2214,10019,645),
	Vector(-2342,10019,645),
	Vector(-2470,10019,645),
	Vector(-2598,10019,645),
	Vector(-2726,10019,645),
	Vector(-2854,10019,645),
	Vector(-2982,10019,645),
	Vector(-3110,10019,645),
	Vector(-3238,10019,645),
	Vector(-3366,10019,645),
	Vector(-294,10091,645),
	Vector(-422,10091,645),
	Vector(-550,10091,645),
	Vector(-678,10091,645),
	Vector(-806,10091,645),
	Vector(-934,10091,645),
	Vector(-1062,10091,645),
	Vector(-1190,10091,645),
	Vector(-1318,10091,645),
	Vector(-1446,10091,645),
	Vector(-1574,10091,645),
	Vector(-1702,10091,645),
	Vector(-1830,10091,645),
	Vector(-1958,10091,645),
	Vector(-2086,10091,645),
	Vector(-2214,10091,645),
	Vector(-2342,10091,645),
	Vector(-2470,10091,645),
	Vector(-2598,10091,645),
	Vector(-2726,10091,645),
	Vector(-2854,10091,645),
	Vector(-2982,10091,645),
	Vector(-3110,10091,645),
	Vector(-3238,10091,645),
	Vector(-3366,10091,645)
}
--[[
SPAWN_OUTSIDE = {
	Vector(-291.78182983398, 10060.791015625, 660.23193359375),
	Vector(-291.74685668945, 9925.3076171875, 661.03125),
	Vector(-315.75567626953, 9986.2080078125, 661.03125),
	Vector(-409.171875, 10047.573242188, 661.03125),
	Vector(-400.92651367188, 10008.091796875, 661.03125),
	Vector(-406.92053222656, 9948.421875, 661.03125),
	Vector(-471.96343994141, 9937.2119140625, 661.03125),
	Vector(-469.31451416016, 9995.591796875, 661.03125),
	Vector(-488.19232177734, 10051.655273438, 660.80291748047),
	Vector(-586.23132324219, 10038.142578125, 661.03125),
	Vector(-575.80041503906, 9982.2060546875, 661.03125),
	Vector(-596.50042724609, 9931.2919921875, 661.03125),
	Vector(-764.45861816406, 10019.0859375, 661.03125),
	Vector(-762.54089355469, 9970.2841796875, 661.03125),
	Vector(-769.65405273438, 9915.3916015625, 660.74328613281),
	Vector(-667.28637695313, 9905.1552734375, 660.10357666016),
	Vector(-669.05810546875, 9974.1142578125, 661.03125),
	Vector(-672.08660888672, 10045.177734375, 661.03125)
}
]]--
SPAWN_SCIENT = {
	Vector(1467.3052978516, -175.59181213379, 25.03125),
	Vector(2123.7622070313, -1482.6602783203, 25.03125),
	Vector(852.08386230469, -2059.7724609375, 25.03125),
	Vector(1510.4027099609, 1062.0632324219, 25.03125),
	Vector(2919.4792480469, 453.00064086914, 25.03125),
	Vector(2799.5170898438, -1086.4936523438, -6.96875),
	Vector(2262.3317871094, -1876.9774169922, 25.03125),
	Vector(738.89453125, -866.99053955078, 25.03125),
	Vector(182.90354919434, -1298.0979003906, -102.96875762939),
	Vector(308.10504150391, -672.34576416016, 25.03125),
	Vector(889.89367675781, -212.07748413086, 25.03125),
	Vector(-411.10330200195, 1076.9678955078, 25.03125)
}
SPAWN_KEYCARD2 = {
	near205 = {
		Vector(2778.3845214844, -1435.1900634766, 25.03125),
		Vector(2760.4965820313, -1143.2667236328, -6.96875),
		Vector(3116.8916015625, -1135.0565185547, -6.96875),
		Vector(2624.4223632813, -1100.4700927734, -6.9687538146973),
		Vector(2925.3818359375, -1607.7552490234, 25.03125),
		Vector(2175.8291015625, -2173.9172363281, 26.031242370605),
		Vector(1508.6851806641, -2236.5024414063, 26.03125),
	},
	nearclassd = {
		Vector(360.73175048828, -963.72473144531, -102.96875),
		Vector(38.423156738281, -965.86193847656, -102.96875762939),
		Vector(400.73345947266, -1284.494140625, -102.96875),
		Vector(-422.06823730469, -204.9649810791, -230.96875),
		Vector(257.49057006836, -125.0929107666, 25.031242370605),
		Vector(-716.68487548828, 958.01684570313, -38.968753814697)
	},
	nearclassd2 = {
		Vector(-1118.5313720703, -18.828098297119, 283.03125),
		Vector(-1096.6427001953, 1998.1658935547, 153.03125),
		Vector(-687.02569580078, 1762.5706787109, 153.03125),
		Vector(-371.22024536133, 873.34912109375, 61.031242370605),
		Vector(-215.50285339355, 1344.8759765625, 61.031265258789),
		Vector(-381.052734375, 1059.7672119141, 153.03125),
		Vector(-373.75994873047, 1265.1997070313, 61.031234741211),
		Vector(-52.888317108154, 1607.2154541016, 281.03125),
		Vector(-553.48547363281, 1918.1993408203, 25.03125),
	},
	lcz1 = {
		Vector(690.07275390625, 197.72148132324, 25.031253814697),
		Vector(1201.9478759766, -909.84490966797, 25.03125),
		Vector(814.10504150391, -2107.9672851563, 25.03125),
		Vector(1955.8737792969, -1437.3981933594, 25.03125),
		Vector(2157.982421875, -685.93865966797, 25.031234741211),
		Vector(2595.6950683594, -341.37478637695, 25.031242370605),
		Vector(2641.1005859375, 565.61334228516, 25.03125),
	},
	lcz2 = {
		Vector(1888.4963378906, 497.41543579102, 25.03125),
		Vector(1759.7982177734, 494.44863891602, 25.03125),
		Vector(1756.728515625, 394.90365600586, 25.031242370605),
		Vector(1888.9497070313, 400.42904663086, 25.03125),
		Vector(1698.6707763672, 401.80624389648, 25.03125),
		Vector(1704.2760009766, 203.60516357422, 25.03125),
		Vector(1774.3350830078, 688.03015136719, 25.03125),
		Vector(2352.134765625, 834.08093261719, 25.03125),
		Vector(2317.423828125, 1257.0325927734, 25.031257629395),
		Vector(1925.0999755859, 1283.1911621094, 25.03125),
		Vector(2632.5385742188, 1240.9353027344, 25.03125),
	}
}

SPAWN_KEYCARD3 = {
	lcz1 = {
		Vector(147.378265, -189.243073, 106.375061),
		Vector(1253.3010253906, 481.80120849609, 25.03125),
		Vector(1281.4185791016, 297.08367919922, 26.03125),
		Vector(1731.9085693359, 807.60485839844, 61.03125),
	},
	scp1123 = {
		Vector(577.88714599609, -1684.9061279297, 26.031242370605),
		Vector(644.41900634766, -1186.9499511719, 61.03125),
		Vector(555.92492675781, -1381.3018798828, 25.03125),
		Vector(683.50408935547, -1688.6999511719, 25.03125),
		Vector(1269.9512939453, 1787.2283935547, 153.03125), -- in 173
	},
	scp372 = {
		Vector(-1098.166015625, -590.10766601563, 25.03125),
		Vector(-1106.4323730469, -990.53283691406, 25.03125),
		Vector(-1579.09375, -1111.6533203125, 25.03125),
		Vector(-1590.6790771484, -910.8291015625, 25.03125),
		Vector(-1644.0833740234, -583.66729736328, 50.84147644043),
		Vector(-1459.9968261719, -968.22058105469, 26.031242370605),
		Vector(-1460.0568847656, -770.02301025391, 26.03125),
		Vector(-1265.7955322266, -768.79840087891, 229.03123474121),
	}
}
SPAWN_KEYCARD4 = {
	entrance = {
		Vector(-1260.4367675781, 2626.712890625, 25.03125),
		Vector(-1334.4855957031, 2487.2663574219, 61.03125),
		Vector(-802.08447265625, 2603.125, 61.03125),
		Vector(-1053.0113525391, 2596.9047851563, 61.031253814697),
		Vector(-884.96221923828, 2624.8762207031, 25.03125),
		Vector(-1678.0030517578, 3504.5229492188, 25.031246185303),
		Vector(-1946.0482177734, 2521.3989257813, -102.96875),
		Vector(-1531.8389892578, 2533.69921875, -102.96875),
		Vector(-985.68615722656, 3778.2365722656, -2.9687576293945),
		Vector(-1191.1276855469, 3907.9191894531, -2.9687461853027),
		Vector(-1186.7037353516, 3771.1638183594, -2.96875),
		Vector(-573.61218261719, 4265.798828125, -2.9687461853027),
		Vector(-572.66076660156, 4441.556640625, -2.96875),
		Vector(-8.5318069458008, 3256.2211914063, -66.96875),
		Vector(440.02575683594, 3141.5815429688, -78.96875),
		Vector(264.63513183594, 3465.4855957031, -78.96875),
		Vector(-526.86291503906, 2251.7263183594, 25.031246185303),
		Vector(-1065.2320556641, 2253.7209472656, 25.03125),
		Vector(-1847.0545654297, 2800.9899902344, -102.96875),
		Vector(-2248.7553710938, 2919.5358886719, 25.03125),
		Vector(-2470.3305664063, 2386.5065917969, 25.03125),
		Vector(-371.60983276367, 4675.3930664063, 25.03125),
		Vector(847.50250244141, 4515.3251953125, 25.03125),
		Vector(1305.251953125, 3960.7922363281, 25.03125),
		Vector(1573.4643554688, 2360.5791015625, 25.03125),
		Vector(1560.38671875, 2073.7919921875, 61.03125),
		Vector(160.56605529785, 2557.2668457031, 61.03125),
		Vector(472.8879699707, 2495.6879882813, 61.03125),
		Vector(166.0440826416, 2267.51171875, 61.031246185303),
		Vector(9.2228031158447, 2262.8166503906, 61.031253814697),
		Vector(-736.23114013672, 2959.1259765625, 25.03125),
		Vector(-795.27899169922, 3059.4426269531, 25.03125),
		Vector(-669.40313720703, 3060.9846191406, 25.031242370605),
		Vector(-821.63708496094, 3254.9665527344, 25.03125),
		Vector(1404.7670898438, 3167.11328125, 125.03125),
		Vector(1478.6342773438, 2850.6362304688, 125.03125),
	},
	hcz = {
		Vector(2078.8088378906, 5027.1352539063, -194.96875),
		Vector(1868.9197998047, 3468.677734375, -230.96875),
		Vector(2927.9130859375, 2181.6840820313, -358.96875),
		Vector(5443.5063476563, 1095.4060058594, -486.96875),
		Vector(4164.4057617188, 216.02502441406, -358.96875),
		Vector(5449.0122070313, -962.10729980469, 61.03125),
		Vector(4391.7368164063, 1125.4187011719, 25.03125),
		Vector(3874.9221191406, -1262.1491699219, -102.96875),
		Vector(4405.9067382813, 2488.1328125, 25.031242370605),
		Vector(5211.0825195313, 499.18725585938, 25.03125),
		Vector(2166.6887207031, 1605.3664550781, 61.03125),
		Vector(4174.7919921875, 2604.0124511719, 25.031246185303),
		Vector(7569.1713867188, 4104.7866210938, 33.203308105469),
		Vector(8338.7177734375, 3792.2453613281, 30.902160644531),
		Vector(5458.2006835938, 4175.46484375, 26.715118408203),
		Vector(5574.83984375, 3921.0988769531, 54.240364074707),
	},
	controlroom = {
		Vector(-2474.9226074219, 1557.4172363281, 189.03125),
		Vector(-2504.2248535156, 1687.3321533203, 153.03125),
		Vector(-2353.544921875, 2130.2907714844, 153.03125),
		Vector(-2434.0520019531, 2044.1354980469, 189.03125),
		Vector(-2362.9807128906, 1923.3223876953, 153.03125),
		Vector(-2375.9113769531, 1926.1774902344, 168.96273803711),
		Vector(-2356.4309082031, 1631.1171875, 153.03125),
	}
}
SPAWN_MEDKITS = {
	Vector(-1515.3021240234, 3470.7368164063, 25.03125),
	Vector(-1829.0373535156, 3355.7231445313, 25.03125),
	Vector(-804.42553710938, 2777.8884277344, 25.03125),
	Vector(440.4108581543, 3344.9145507813, -62.968757629395),
	Vector(3057.1743164063, 155.70297241211, 25.03125),
}
SPAWN_MISCITEMS = {
	Vector(231.86305236816, -674.42749023438, 25.031242370605),
	Vector(-1606.6912841797, -808.78192138672, 25.03125),
	Vector(-858.42193603516, 806.22351074219, -102.96875),
	Vector(298.86450195313, 1932.1087646484, 281.03125),
	Vector(1411.6623535156, -1057.3033447266, 25.03125),
	Vector(1713.3585205078, 926.07879638672, 25.03125),
	Vector(4801.5498046875, -1286.2266845703, -486.96875),
	Vector(1715.5294189453, 3950.9377441406, 61.031246185303),
	Vector(-789.20654296875, 3197.7761230469, 25.03125),
	Vector(2203.7214355469, 3489.5537109375, -230.96875),
}
SPAWN_MELEEWEPS = {
	Vector(2919.3369140625, 3676.9177246094, 25.031257629395),
	Vector(3025.2163085938, -364.45196533203, 25.03125),
	Vector(-1478.6712646484, 2779.9006347656, -102.96873474121),
	Vector(4156.6494140625, 904.87817382813, 25.03125),
}
SPAWN_AMMO_RIFLE = {
	Vector(2387.65625, 2187.5720214844, 25.03125),
	Vector(2342.0046386719, 2185.037109375, 25.03125),
	Vector(2287.8991699219, 2186.947265625, 25.03125),
	Vector(2240.984375, 2188.744140625, 25.03125),
	Vector(2191.9877929688, 2192.5964355469, 25.03125)
}
SPAWN_AMMO_SMG = {
	Vector(686.45098876953, 363.41900634766, 25.031257629395),
	Vector(686.31567382813, 425.2532043457, 25.031257629395),
	Vector(692.47869873047, 641.92974853516, 25.03125),
	Vector(765.5400390625, 644.30493164063, 25.03125),
	Vector(835.29254150391, 645.85809326172, 25.03125),
	Vector(682.06781005859, 492.13708496094, 25.03125),
	Vector(2147.2294921875, 2567.458984375, 25.03125),
	Vector(2205.1669921875, 2574.0163574219, 25.03125),
	Vector(2256.6218261719, 2570.9245605469, 25.03125),
	Vector(2320.4196777344, 2574.0776367188, 25.03125),
	Vector(2380.6379394531, 2565.5126953125, 25.031234741211),
	Vector(5191.8388671875, -1015.6797485352, 25.03125),
}
SPAWN_AMMO_PISTOL = {
	Vector(897.22467041016, 522.17083740234, 73.03125),
	Vector(896.57379150391, 462.39865112305, 73.03125),
	Vector(894.71447753906, 393.5309753418, 73.03125),
	Vector(893.68737792969, 589.84039306641, 73.03125),
	Vector(-1685.076171875, 3015.2290039063, 281.03125),
	Vector(-1683.8618164063, 3071.6684570313, 281.03125),
	Vector(-1680.4187011719, 3115.9096679688, 281.03125)
}
SPAWN_PISTOLS = {
	Vector(-1456.396484375, 3179.9714355469, 306.84194946289),
	Vector(609.42144775391, 368.1237487793, 73.03125)
}
SPAWN_SMGS = {
	Vector(5205.3422851563, -1091.7041015625, 25.03125),
	Vector(665.65991210938, 582.52844238281, 25.03125),
	Vector(737.10485839844, 578.06451416016, 25.03125),
	Vector(828.96624755859, 589.53991699219, 25.03125),
	Vector(2136.7351074219, 2165.9052734375, 25.03125),
	Vector(2139.0212402344, 2237.5754394531, 25.03125),
	Vector(3925.5595703125, -880.93127441406, -102.96875),
	Vector(2497.2380371094, 2881.7265625, -358.96875),
}
SPAWN_RIFLES = {
	Vector(2229.2341308594, 2167.9050292969, 25.03125),
	Vector(2310.7258300781, 2166.7707519531, 25.03125),
	Vector(2382.6296386719, 2176.6872558594, 25.03125),
	Vector(-2446.1599121094, 6576.9184570313, 1593.03125),
	Vector(6341.4379882813, 3999.2419433594, 65.930503845215),
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
	Vector(5386.0063476563, -1074.9949951172, 13.031242370605),
	Vector(831.67425537109, 464.23361206055, 13.031257629395),
	Vector(4039.841796875, 214.51298522949, -370.96875),
	Vector(2370.9562988281, 2459.9973144531, 13.03125),
	Vector(2367.3310546875, 2401.5241699219, 13.031257629395),
	Vector(2367.921875, 2346.2109375, 13.03125),
}
SPAWN_FIREPROOFARMOR = {
	Vector(3025.97265625, 714.64575195313, 0.03125),
	Vector(-183.2326965332, -7.5728015899658, -255.96875),
	Vector(2844.7390136719, 3226.7712402344, -382.96875),
	Vector(2016.5812988281, 1535.4387207031, 0.03125),
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
		pos = Vector(792.000000, 297.000000, 53.000000),
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
		pos = Vector(1567.000000, -832.000000, 46.000000),
		customdenymsg = "",
		canactivate = function(pl, ent)
			Use914(ent)
			return false
		end
	},
	{
		name = "914 Button 2",
		pos = Vector(1563.000000, -832.000000, 62.000000),
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

POS_GATEA = Vector(-3520.6567382813, 8503.6875, 730.47564697266)
POS_ESCORT = Vector(-1792.183350, 8190.317383, 965.235657)
--POS_GATEABUTTON = Vector(-1316.000000, 3564.000000, 309.859985)
--Fixed by Link2006
POS_GATEABUTTON = Vector(-2452, 3876, 309.85998535156)
POS_173DOORS = Vector(362.000000, 1592.000000, 294.000000)
POS_106DOORS = Vector(1728.000000, 4103.000000, 46.000000)
POS_049BUTTON = Vector(5040.000000, -952.000000, -474.000000)
POS_173BUTTON = Vector(362.000000, 1592.000000, 294.000000)
POS_682BUTTON = Vector(2288.000000, 3396.010010, -201.139999)

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
