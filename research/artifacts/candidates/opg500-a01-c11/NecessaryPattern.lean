-- Candidate only; generated proof term has NOT been elaborated.
-- Input certificate SHA-256: b7f6bb1aaa032313232be769f83f0a8e3862b852095e868f25ff82506b2d73be
import Init

namespace OPG500C11

theorem noNecessaryPattern (p1 p2 p3 p4 p5 p6 p7 p8 p9 p10 p11 p12 p13 p14 p15 p16 p17 p18 : Prop)
    (h0 : (p1 ∨ p2))
    (h1 : (p1 ∨ p3))
    (h2 : (p1 ∨ p4))
    (h3 : (p1 ∨ p5))
    (h4 : (p1 ∨ p6))
    (h5 : (p1 ∨ p7))
    (h6 : (p1 ∨ p8))
    (h7 : (p1 ∨ p9))
    (h8 : (p1 ∨ p10))
    (h9 : (p1 ∨ p11))
    (h10 : (p1 ∨ p12))
    (h11 : (p2 ∨ p3))
    (h12 : (p2 ∨ p4))
    (h13 : (p2 ∨ p5))
    (h14 : (p2 ∨ p6))
    (h15 : (p2 ∨ p7))
    (h16 : (p2 ∨ p8))
    (h17 : (p2 ∨ p9))
    (h18 : (p2 ∨ p10))
    (h19 : (p2 ∨ p11))
    (h20 : (p2 ∨ p12))
    (h21 : (p3 ∨ p4))
    (h22 : (p3 ∨ p5))
    (h23 : (p3 ∨ p6))
    (h24 : (p3 ∨ p7))
    (h25 : (p3 ∨ p8))
    (h26 : (p3 ∨ p9))
    (h27 : (p3 ∨ p10))
    (h28 : (p3 ∨ p11))
    (h29 : (p3 ∨ p12))
    (h30 : (p4 ∨ p5))
    (h31 : (p4 ∨ p6))
    (h32 : (p4 ∨ p7))
    (h33 : (p4 ∨ p8))
    (h34 : (p4 ∨ p9))
    (h35 : (p4 ∨ p10))
    (h36 : (p4 ∨ p11))
    (h37 : (p4 ∨ p12))
    (h38 : (p5 ∨ p6))
    (h39 : (p5 ∨ p7))
    (h40 : (p5 ∨ p8))
    (h41 : (p5 ∨ p9))
    (h42 : (p5 ∨ p10))
    (h43 : (p5 ∨ p11))
    (h44 : (p5 ∨ p12))
    (h45 : (p6 ∨ p7))
    (h46 : (p6 ∨ p8))
    (h47 : (p6 ∨ p9))
    (h48 : (p6 ∨ p10))
    (h49 : (p6 ∨ p11))
    (h50 : (p6 ∨ p12))
    (h51 : (p7 ∨ p8))
    (h52 : (p7 ∨ p9))
    (h53 : (p7 ∨ p10))
    (h54 : (p7 ∨ p11))
    (h55 : (p7 ∨ p12))
    (h56 : (p8 ∨ p9))
    (h57 : (p8 ∨ p10))
    (h58 : (p8 ∨ p11))
    (h59 : (p8 ∨ p12))
    (h60 : (p9 ∨ p10))
    (h61 : (p9 ∨ p11))
    (h62 : (p9 ∨ p12))
    (h63 : (p10 ∨ p11))
    (h64 : (p10 ∨ p12))
    (h65 : (p11 ∨ p12))
    (h66 : ((p1 → False) ∨ ((p2 → False) ∨ p13)))
    (h67 : ((p3 → False) ∨ ((p4 → False) ∨ p14)))
    (h68 : ((p5 → False) ∨ ((p6 → False) ∨ p15)))
    (h69 : ((p7 → False) ∨ ((p8 → False) ∨ p16)))
    (h70 : ((p9 → False) ∨ ((p10 → False) ∨ p17)))
    (h71 : ((p11 → False) ∨ ((p12 → False) ∨ p18)))
    (h72 : ((p13 → False) ∨ ((p14 → False) ∨ (p16 → False))))
    (h73 : ((p13 → False) ∨ ((p15 → False) ∨ (p17 → False))))
    (h74 : ((p14 → False) ∨ ((p15 → False) ∨ (p18 → False))))
    (h75 : ((p16 → False) ∨ ((p17 → False) ∨ (p18 → False)))) : False :=
  (Or.elim (Classical.em p1)
  (fun (yes1 : p1) =>
  (Or.elim (Classical.em p2)
  (fun (yes3 : p2) =>
  let u5 : p13 := (Or.elim h66 (fun (l6 : (p1 → False)) => (False.elim (l6 yes1))) (fun r7 => (Or.elim r7 (fun (l8 : (p2 → False)) => (False.elim (l8 yes3))) (fun r9 => r9))));
  (Or.elim (Classical.em p3)
  (fun (yes10 : p3) =>
  (Or.elim (Classical.em p4)
  (fun (yes12 : p4) =>
  let u14 : p14 := (Or.elim h67 (fun (l15 : (p3 → False)) => (False.elim (l15 yes10))) (fun r16 => (Or.elim r16 (fun (l17 : (p4 → False)) => (False.elim (l17 yes12))) (fun r18 => r18))));
  let u19 : (p16 → False) := (Or.elim h72 (fun (l20 : (p13 → False)) => (False.elim (l20 u5))) (fun r21 => (Or.elim r21 (fun (l22 : (p14 → False)) => (False.elim (l22 u14))) (fun r23 => r23))));
  (Or.elim (Classical.em p5)
  (fun (yes24 : p5) =>
  (Or.elim (Classical.em p6)
  (fun (yes26 : p6) =>
  let u28 : p15 := (Or.elim h68 (fun (l29 : (p5 → False)) => (False.elim (l29 yes24))) (fun r30 => (Or.elim r30 (fun (l31 : (p6 → False)) => (False.elim (l31 yes26))) (fun r32 => r32))));
  let u33 : (p17 → False) := (Or.elim h73 (fun (l34 : (p13 → False)) => (False.elim (l34 u5))) (fun r35 => (Or.elim r35 (fun (l36 : (p15 → False)) => (False.elim (l36 u28))) (fun r37 => r37))));
  let u38 : (p18 → False) := (Or.elim h74 (fun (l39 : (p14 → False)) => (False.elim (l39 u14))) (fun r40 => (Or.elim r40 (fun (l41 : (p15 → False)) => (False.elim (l41 u28))) (fun r42 => r42))));
  (Or.elim (Classical.em p7)
  (fun (yes43 : p7) =>
  let u45 : (p8 → False) := (Or.elim h69 (fun (l46 : (p7 → False)) => (False.elim (l46 yes43))) (fun r47 => (Or.elim r47 (fun (l48 : (p8 → False)) => l48) (fun r49 => (False.elim (u19 r49))))));
  let u50 : p9 := (Or.elim h56 (fun (l51 : p8) => (False.elim (u45 l51))) (fun r52 => r52));
  let u53 : p10 := (Or.elim h57 (fun (l54 : p8) => (False.elim (u45 l54))) (fun r55 => r55));
  let u56 : p11 := (Or.elim h58 (fun (l57 : p8) => (False.elim (u45 l57))) (fun r58 => r58));
  let u59 : p12 := (Or.elim h59 (fun (l60 : p8) => (False.elim (u45 l60))) (fun r61 => r61));
  (Or.elim h70 (fun (l62 : (p9 → False)) => (l62 u50)) (fun r63 => (Or.elim r63 (fun (l64 : (p10 → False)) => (l64 u53)) (fun r65 => (u33 r65))))))
  (fun (no44 : p7 → False) =>
  let u66 : p8 := (Or.elim h51 (fun (l67 : p7) => (False.elim (no44 l67))) (fun r68 => r68));
  let u69 : p9 := (Or.elim h52 (fun (l70 : p7) => (False.elim (no44 l70))) (fun r71 => r71));
  let u72 : p10 := (Or.elim h53 (fun (l73 : p7) => (False.elim (no44 l73))) (fun r74 => r74));
  let u75 : p11 := (Or.elim h54 (fun (l76 : p7) => (False.elim (no44 l76))) (fun r77 => r77));
  let u78 : p12 := (Or.elim h55 (fun (l79 : p7) => (False.elim (no44 l79))) (fun r80 => r80));
  (Or.elim h70 (fun (l81 : (p9 → False)) => (l81 u69)) (fun r82 => (Or.elim r82 (fun (l83 : (p10 → False)) => (l83 u72)) (fun r84 => (u33 r84))))))))
  (fun (no27 : p6 → False) =>
  let u85 : p7 := (Or.elim h45 (fun (l86 : p6) => (False.elim (no27 l86))) (fun r87 => r87));
  let u88 : p8 := (Or.elim h46 (fun (l89 : p6) => (False.elim (no27 l89))) (fun r90 => r90));
  let u91 : p9 := (Or.elim h47 (fun (l92 : p6) => (False.elim (no27 l92))) (fun r93 => r93));
  let u94 : p10 := (Or.elim h48 (fun (l95 : p6) => (False.elim (no27 l95))) (fun r96 => r96));
  let u97 : p11 := (Or.elim h49 (fun (l98 : p6) => (False.elim (no27 l98))) (fun r99 => r99));
  let u100 : p12 := (Or.elim h50 (fun (l101 : p6) => (False.elim (no27 l101))) (fun r102 => r102));
  (Or.elim h69 (fun (l103 : (p7 → False)) => (l103 u85)) (fun r104 => (Or.elim r104 (fun (l105 : (p8 → False)) => (l105 u88)) (fun r106 => (u19 r106))))))))
  (fun (no25 : p5 → False) =>
  let u107 : p6 := (Or.elim h38 (fun (l108 : p5) => (False.elim (no25 l108))) (fun r109 => r109));
  let u110 : p7 := (Or.elim h39 (fun (l111 : p5) => (False.elim (no25 l111))) (fun r112 => r112));
  let u113 : p8 := (Or.elim h40 (fun (l114 : p5) => (False.elim (no25 l114))) (fun r115 => r115));
  let u116 : p9 := (Or.elim h41 (fun (l117 : p5) => (False.elim (no25 l117))) (fun r118 => r118));
  let u119 : p10 := (Or.elim h42 (fun (l120 : p5) => (False.elim (no25 l120))) (fun r121 => r121));
  let u122 : p11 := (Or.elim h43 (fun (l123 : p5) => (False.elim (no25 l123))) (fun r124 => r124));
  let u125 : p12 := (Or.elim h44 (fun (l126 : p5) => (False.elim (no25 l126))) (fun r127 => r127));
  (Or.elim h69 (fun (l128 : (p7 → False)) => (l128 u110)) (fun r129 => (Or.elim r129 (fun (l130 : (p8 → False)) => (l130 u113)) (fun r131 => (u19 r131))))))))
  (fun (no13 : p4 → False) =>
  let u132 : p5 := (Or.elim h30 (fun (l133 : p4) => (False.elim (no13 l133))) (fun r134 => r134));
  let u135 : p6 := (Or.elim h31 (fun (l136 : p4) => (False.elim (no13 l136))) (fun r137 => r137));
  let u138 : p7 := (Or.elim h32 (fun (l139 : p4) => (False.elim (no13 l139))) (fun r140 => r140));
  let u141 : p8 := (Or.elim h33 (fun (l142 : p4) => (False.elim (no13 l142))) (fun r143 => r143));
  let u144 : p9 := (Or.elim h34 (fun (l145 : p4) => (False.elim (no13 l145))) (fun r146 => r146));
  let u147 : p10 := (Or.elim h35 (fun (l148 : p4) => (False.elim (no13 l148))) (fun r149 => r149));
  let u150 : p11 := (Or.elim h36 (fun (l151 : p4) => (False.elim (no13 l151))) (fun r152 => r152));
  let u153 : p12 := (Or.elim h37 (fun (l154 : p4) => (False.elim (no13 l154))) (fun r155 => r155));
  let u156 : p15 := (Or.elim h68 (fun (l157 : (p5 → False)) => (False.elim (l157 u132))) (fun r158 => (Or.elim r158 (fun (l159 : (p6 → False)) => (False.elim (l159 u135))) (fun r160 => r160))));
  let u161 : p16 := (Or.elim h69 (fun (l162 : (p7 → False)) => (False.elim (l162 u138))) (fun r163 => (Or.elim r163 (fun (l164 : (p8 → False)) => (False.elim (l164 u141))) (fun r165 => r165))));
  let u166 : p17 := (Or.elim h70 (fun (l167 : (p9 → False)) => (False.elim (l167 u144))) (fun r168 => (Or.elim r168 (fun (l169 : (p10 → False)) => (False.elim (l169 u147))) (fun r170 => r170))));
  let u171 : p18 := (Or.elim h71 (fun (l172 : (p11 → False)) => (False.elim (l172 u150))) (fun r173 => (Or.elim r173 (fun (l174 : (p12 → False)) => (False.elim (l174 u153))) (fun r175 => r175))));
  let u176 : (p14 → False) := (Or.elim h72 (fun (l177 : (p13 → False)) => (False.elim (l177 u5))) (fun r178 => (Or.elim r178 (fun (l179 : (p14 → False)) => l179) (fun r180 => (False.elim (r180 u161))))));
  (Or.elim h73 (fun (l181 : (p13 → False)) => (l181 u5)) (fun r182 => (Or.elim r182 (fun (l183 : (p15 → False)) => (l183 u156)) (fun r184 => (r184 u166))))))))
  (fun (no11 : p3 → False) =>
  let u185 : p4 := (Or.elim h21 (fun (l186 : p3) => (False.elim (no11 l186))) (fun r187 => r187));
  let u188 : p5 := (Or.elim h22 (fun (l189 : p3) => (False.elim (no11 l189))) (fun r190 => r190));
  let u191 : p6 := (Or.elim h23 (fun (l192 : p3) => (False.elim (no11 l192))) (fun r193 => r193));
  let u194 : p7 := (Or.elim h24 (fun (l195 : p3) => (False.elim (no11 l195))) (fun r196 => r196));
  let u197 : p8 := (Or.elim h25 (fun (l198 : p3) => (False.elim (no11 l198))) (fun r199 => r199));
  let u200 : p9 := (Or.elim h26 (fun (l201 : p3) => (False.elim (no11 l201))) (fun r202 => r202));
  let u203 : p10 := (Or.elim h27 (fun (l204 : p3) => (False.elim (no11 l204))) (fun r205 => r205));
  let u206 : p11 := (Or.elim h28 (fun (l207 : p3) => (False.elim (no11 l207))) (fun r208 => r208));
  let u209 : p12 := (Or.elim h29 (fun (l210 : p3) => (False.elim (no11 l210))) (fun r211 => r211));
  let u212 : p15 := (Or.elim h68 (fun (l213 : (p5 → False)) => (False.elim (l213 u188))) (fun r214 => (Or.elim r214 (fun (l215 : (p6 → False)) => (False.elim (l215 u191))) (fun r216 => r216))));
  let u217 : p16 := (Or.elim h69 (fun (l218 : (p7 → False)) => (False.elim (l218 u194))) (fun r219 => (Or.elim r219 (fun (l220 : (p8 → False)) => (False.elim (l220 u197))) (fun r221 => r221))));
  let u222 : p17 := (Or.elim h70 (fun (l223 : (p9 → False)) => (False.elim (l223 u200))) (fun r224 => (Or.elim r224 (fun (l225 : (p10 → False)) => (False.elim (l225 u203))) (fun r226 => r226))));
  let u227 : p18 := (Or.elim h71 (fun (l228 : (p11 → False)) => (False.elim (l228 u206))) (fun r229 => (Or.elim r229 (fun (l230 : (p12 → False)) => (False.elim (l230 u209))) (fun r231 => r231))));
  let u232 : (p14 → False) := (Or.elim h72 (fun (l233 : (p13 → False)) => (False.elim (l233 u5))) (fun r234 => (Or.elim r234 (fun (l235 : (p14 → False)) => l235) (fun r236 => (False.elim (r236 u217))))));
  (Or.elim h73 (fun (l237 : (p13 → False)) => (l237 u5)) (fun r238 => (Or.elim r238 (fun (l239 : (p15 → False)) => (l239 u212)) (fun r240 => (r240 u222))))))))
  (fun (no4 : p2 → False) =>
  let u241 : p3 := (Or.elim h11 (fun (l242 : p2) => (False.elim (no4 l242))) (fun r243 => r243));
  let u244 : p4 := (Or.elim h12 (fun (l245 : p2) => (False.elim (no4 l245))) (fun r246 => r246));
  let u247 : p5 := (Or.elim h13 (fun (l248 : p2) => (False.elim (no4 l248))) (fun r249 => r249));
  let u250 : p6 := (Or.elim h14 (fun (l251 : p2) => (False.elim (no4 l251))) (fun r252 => r252));
  let u253 : p7 := (Or.elim h15 (fun (l254 : p2) => (False.elim (no4 l254))) (fun r255 => r255));
  let u256 : p8 := (Or.elim h16 (fun (l257 : p2) => (False.elim (no4 l257))) (fun r258 => r258));
  let u259 : p9 := (Or.elim h17 (fun (l260 : p2) => (False.elim (no4 l260))) (fun r261 => r261));
  let u262 : p10 := (Or.elim h18 (fun (l263 : p2) => (False.elim (no4 l263))) (fun r264 => r264));
  let u265 : p11 := (Or.elim h19 (fun (l266 : p2) => (False.elim (no4 l266))) (fun r267 => r267));
  let u268 : p12 := (Or.elim h20 (fun (l269 : p2) => (False.elim (no4 l269))) (fun r270 => r270));
  let u271 : p14 := (Or.elim h67 (fun (l272 : (p3 → False)) => (False.elim (l272 u241))) (fun r273 => (Or.elim r273 (fun (l274 : (p4 → False)) => (False.elim (l274 u244))) (fun r275 => r275))));
  let u276 : p15 := (Or.elim h68 (fun (l277 : (p5 → False)) => (False.elim (l277 u247))) (fun r278 => (Or.elim r278 (fun (l279 : (p6 → False)) => (False.elim (l279 u250))) (fun r280 => r280))));
  let u281 : p16 := (Or.elim h69 (fun (l282 : (p7 → False)) => (False.elim (l282 u253))) (fun r283 => (Or.elim r283 (fun (l284 : (p8 → False)) => (False.elim (l284 u256))) (fun r285 => r285))));
  let u286 : p17 := (Or.elim h70 (fun (l287 : (p9 → False)) => (False.elim (l287 u259))) (fun r288 => (Or.elim r288 (fun (l289 : (p10 → False)) => (False.elim (l289 u262))) (fun r290 => r290))));
  let u291 : p18 := (Or.elim h71 (fun (l292 : (p11 → False)) => (False.elim (l292 u265))) (fun r293 => (Or.elim r293 (fun (l294 : (p12 → False)) => (False.elim (l294 u268))) (fun r295 => r295))));
  let u296 : (p13 → False) := (Or.elim h72 (fun (l297 : (p13 → False)) => l297) (fun r298 => (Or.elim r298 (fun (l299 : (p14 → False)) => (False.elim (l299 u271))) (fun r300 => (False.elim (r300 u281))))));
  (Or.elim h74 (fun (l301 : (p14 → False)) => (l301 u271)) (fun r302 => (Or.elim r302 (fun (l303 : (p15 → False)) => (l303 u276)) (fun r304 => (r304 u291))))))))
  (fun (no2 : p1 → False) =>
  let u305 : p2 := (Or.elim h0 (fun (l306 : p1) => (False.elim (no2 l306))) (fun r307 => r307));
  let u308 : p3 := (Or.elim h1 (fun (l309 : p1) => (False.elim (no2 l309))) (fun r310 => r310));
  let u311 : p4 := (Or.elim h2 (fun (l312 : p1) => (False.elim (no2 l312))) (fun r313 => r313));
  let u314 : p5 := (Or.elim h3 (fun (l315 : p1) => (False.elim (no2 l315))) (fun r316 => r316));
  let u317 : p6 := (Or.elim h4 (fun (l318 : p1) => (False.elim (no2 l318))) (fun r319 => r319));
  let u320 : p7 := (Or.elim h5 (fun (l321 : p1) => (False.elim (no2 l321))) (fun r322 => r322));
  let u323 : p8 := (Or.elim h6 (fun (l324 : p1) => (False.elim (no2 l324))) (fun r325 => r325));
  let u326 : p9 := (Or.elim h7 (fun (l327 : p1) => (False.elim (no2 l327))) (fun r328 => r328));
  let u329 : p10 := (Or.elim h8 (fun (l330 : p1) => (False.elim (no2 l330))) (fun r331 => r331));
  let u332 : p11 := (Or.elim h9 (fun (l333 : p1) => (False.elim (no2 l333))) (fun r334 => r334));
  let u335 : p12 := (Or.elim h10 (fun (l336 : p1) => (False.elim (no2 l336))) (fun r337 => r337));
  let u338 : p14 := (Or.elim h67 (fun (l339 : (p3 → False)) => (False.elim (l339 u308))) (fun r340 => (Or.elim r340 (fun (l341 : (p4 → False)) => (False.elim (l341 u311))) (fun r342 => r342))));
  let u343 : p15 := (Or.elim h68 (fun (l344 : (p5 → False)) => (False.elim (l344 u314))) (fun r345 => (Or.elim r345 (fun (l346 : (p6 → False)) => (False.elim (l346 u317))) (fun r347 => r347))));
  let u348 : p16 := (Or.elim h69 (fun (l349 : (p7 → False)) => (False.elim (l349 u320))) (fun r350 => (Or.elim r350 (fun (l351 : (p8 → False)) => (False.elim (l351 u323))) (fun r352 => r352))));
  let u353 : p17 := (Or.elim h70 (fun (l354 : (p9 → False)) => (False.elim (l354 u326))) (fun r355 => (Or.elim r355 (fun (l356 : (p10 → False)) => (False.elim (l356 u329))) (fun r357 => r357))));
  let u358 : p18 := (Or.elim h71 (fun (l359 : (p11 → False)) => (False.elim (l359 u332))) (fun r360 => (Or.elim r360 (fun (l361 : (p12 → False)) => (False.elim (l361 u335))) (fun r362 => r362))));
  let u363 : (p13 → False) := (Or.elim h72 (fun (l364 : (p13 → False)) => l364) (fun r365 => (Or.elim r365 (fun (l366 : (p14 → False)) => (False.elim (l366 u338))) (fun r367 => (False.elim (r367 u348))))));
  (Or.elim h74 (fun (l368 : (p14 → False)) => (l368 u338)) (fun r369 => (Or.elim r369 (fun (l370 : (p15 → False)) => (l370 u343)) (fun r371 => (r371 u358)))))))

end OPG500C11

#print axioms OPG500C11.noNecessaryPattern
