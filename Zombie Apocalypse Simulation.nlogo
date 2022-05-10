breed [humans person]                                           ; this creates inhabitants of humans.
breed [zombies zombie]                                          ; this creates inhabitants of zombies.
globals [convert_probability student_id student_username]       ; this creates golobal variabls called student_id,student_username and convert probability.

patches-own [solid]                                             ; this creates a variable for patches to see if they should be percived as solid.

zombies-own [ ]                                                 ; N/A
humans-own [vision_radius vision_angle]                         ; this stores the variable vision_radius and vision_angle.


to setup_world                                                  ; this creates a function called setup_world.
  clear-all                                                     ; this clears the world of any previouse activities.
  reset-ticks                                                   ; this resets the tick counter.

  draw_buildings                                                ; this calls the draw_building function.

  set convert_probability convert_probability_percentage        ; this links convert_probability global with conver_probability_percentage slider.
  set student_id "19011398"                                     ; this stores my student_id.
  set student_username "aa19aiy"                                ; this stores my student_username.

  let vis_rad 15                                                ; this creates 1 random variable and sets the vision_radius to 15 patches.

  create-zombies 5 [                                            ; this creates the number of zombies that your global variable states.
    setxy random-xcor random-ycor                               ; this sets the starting position of zombies to a random place in the world.
    set color red                                               ; this sets the color of the zombies to red.
    set size 4                                                  ; this sets the size of the zombies to 4.
    set shape "person"                                          ; this sets the shape of the zombies to person.
    move-to one-of patches  with [pcolor = green]               ; this spawns zombies on green patches.
  ]

  create-humans 15 [                                            ; this creates the number of humans that your global variable states.
    setxy random-xcor random-ycor                               ; this sets the starting position of zombies to a random place in the world.
    set color blue                                              ; this sets the color of the zombies to blue.
    set size 5                                                  ; this sets the size of the humans to 5.
    set shape "person"                                          ; this sets the shape of the humans to person.
    set vision_angle 90                                         ; this sets the vision_angle of the humans to 90 degrees. (set here or vision_cone color keeps resting.)
    set vision_radius vis_rad                                   ; this sets the vision_radius from 10 to 20 patches.
    move-to one-of patches  with [pcolor = green]               ; this spawns humans on green patches.
  ]

  ask zombies [                                                 ; this ask zombies to do what is in the brackets.
      ask patches in-radius 5 [                                 ; this ask patches in radius 5...
      if solid = false[
      set pcolor white                                          ; to set there color to white to insure zombies and humans do not spawn within 5 patches of each other.
      ]
    ]
  ]

  ask humans [
    move-to one-of patches with [pcolor = green]
  ]

  reset_patch_colour
end

to draw_buildings                                              ; this creates a draw building function.
  ask patches [                                                ; this asks patches to do whats in brackets...
    set pcolor green                                           ; this sets patch color to green.
    set solid false                                            ; and sets solid to false.
  ]

  ask n-of 100 patches [                                       ; this asks 100 patches to do whts in brackets...
    set pcolor brown                                           ; this sets patch color to brown.
    set solid true                                             ; and sets solid to true.
  ]

end

to detect_wall                                                 ; this creates a function called detect_wall.
  if [solid] of patch-ahead 1 = true [                         ; if patch variable of 2 patches ahead is true then...
    right 180                                                  ; turn around 180 degrees to opposite direction to avoid.
  ]
end

to detect_human                                                ; this creates a function to smell the humans within a radius of 10.
  if any? humans in-radius 10 [                                ; smell function for zombies to go to humans in radius 10.
      let human one-of humans in-radius 10
      set heading towards one-of humans in-radius 10           ; this sets the heading of zombies towards human smelt.
   ]
end

to fight                                                          ; this creates a fight function to convert human or die/get killed.
  if any? humans in-radius 2 [                                    ; if any humans inside the collision (conversion) radius of 3 patches then.
      let human one-of humans in-radius 2
      set heading towards human                                   ; go to human and fight...

  ifelse ( convert_probability_percentage  ) <= random 100
  [
    ask human [                                                   ; this asks human to convert to zombie.
      set breed zombies                                           ; this sets the breed,color,size and shape of human to zombie...
      set color red
      set size 4
      set shape "person"
   ]
  ]
    [die]                                                         ; or kills the zombie.
]
end

to reset_patch_colour                                          ; this creates a reset_patch function.
  ask patches with [pcolor = orange][                          ; this asks patches with pcolor orange from the vis_cone to do what is in the brackets...
    if solid = false[                                          ; if the patch is not solid then...
    set pcolor green                                           ; set pcolor back to green.
    ]
  ]

  ask patches with [pcolor = white][
    if solid = false[
      set pcolor green
    ]
  ]
end

to make_zombies_move                                           ; this creates a make_zombies_move function.
  ask zombies [                                                ; this ask zombies to do whatever is in the brackets...
    set color red                                              ; this sets the color of the zombies to red.
    detect_wall                                                ; this calls the detect_wall function.
    detect_human                                               ; this calls the detect_human function to smell humans in radius.
    fight                                                      ; this calls the fight function to try and convert human or be killed by human.
    right random 45                                            ; this makes the zombies wonder randomly limited within 90 degrees, 45 degrees to the right.
    left random 45                                             ; this makes the zombies wonder randomly limited within 90 degrees, 45 degrees to the left.
    forward 0.5                                                ; this sets the speed of which zombies move to 0.5.


   ;if draw-traces? = true [pen-down]                          ; this draws traces if slider is on but i have included this in the run_model function.

    if smell_radius = true [                                   ; if smell_radius slider is on.
      ask patches in-radius 10 with [pcolor = green][          ; ask patches to...
        set pcolor white                                       ; set patches of radius 10 around agent to white, for us to be able to see their smell radius.
      ]
    ]
  ]
end

to make_humans_move                                            ; this creates a function called make_humans_move.
  ask humans [                                                 ; this asks humans in the population to do whatever is in the brackets.
   set color blue                                              ; this sets the color of each human to blue.
   let seen_zombie [false]                                     ; this sets zombies_seen to false.
   detect_wall                                                 ; this calls the detect_wall function to detect solid walls.
   right random 45                                             ; this allows humans to wonder randomly 45 degrees to the right..
   left random 45                                              ; this allows humans to wonder randomly 45 degrees to the left..
   forward 1 + random-float 0.1                                ; humans speed.

 ;if draw-traces? = true [pen-down]                            ; this draws traces if slider is on but i have included this in the run_model function.

  ask zombies in-cone vision_radius vision_angle [             ; this ask zombies seen in the visiual cone to...
   ;set color white                                            ; set there color to white if they are seen.
     set seen_zombie true                                      ; and set seen to true.
    ]

  if show_vision_cone = true [                                                           ; if show_vision_cone is turned on.
      ask patches in-cone vision_radius vision_angle ;with [pcolor = green]              ; ask patches in vision_radius and vision_angle with pcolor green.
        [if solid = false[
          set pcolor orange                                                              ; set pcolor to orange.
          ]
      ]
    ]

    if seen_zombie = true [                                    ; if seen is true....
     ;set color yellow                                         ; sets color of human breifly to yellow to indicate it has seen a zombie.
      right 180                                                ; then turn 180 degrees to avoid the zombies.
    ]
  ]
end

to run_model                                                   ; this creates a function called run_model.
  make_zombies_move                                            ; this calls the make_humans_move function.
  make_humans_move                                             ; this calls the make_zombies_move function.
  tick                                                         ; this adds 1 to the tick counter.
  reset_patch_colour                                           ; this calls the reset_patch_colour function.

  if not any? humans [                                         ; if there's no humans left...
  user-message (word " ALL Humans have been INFECTED!")        ; display user message.
  stop                                                         ; and stop the simulation.
  ]

  if not any? zombies [                                        ; if there's no zombies left....
  user-message (word " ALL Zombies have been KILLED!")         ; display user message.
  stop                                                         ; and stop the simulation.
  ]

  if ticks = stop-ticks [stop]                                 ; if ticks hit stop-ticks from global variable slider stop the simulation.
  ask turtles [ifelse draw-traces? [pd][pu]                    ; if draw traces is on draw traces.
  ]
end

;to wiggle [angle]
  ;rt random-float angle
  ;lt random-float angle
;end
@#$#@#$#@
GRAPHICS-WINDOW
330
16
843
530
-1
-1
5.0
1
10
1
1
1
0
1
1
1
-50
50
-50
50
1
1
1
ticks
30.0

BUTTON
0
34
103
67
NIL
setup_world
NIL
1
T
OBSERVER
NIL
S
NIL
NIL
1

BUTTON
112
35
207
68
run_model
run_model
T
1
T
OBSERVER
NIL
G
NIL
NIL
1

BUTTON
0
75
207
109
run once
run_model
NIL
1
T
OBSERVER
NIL
D
NIL
NIL
1

PLOT
953
19
1295
477
Population
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Zombies" 1.0 0 -5298144 true "" "plot count zombies"
"Total Population" 1.0 0 -16777216 true "" "plot count turtles"
"Humans" 1.0 0 -13345367 true "" "plot count humans"

SWITCH
0
227
171
260
draw-traces?
draw-traces?
1
1
-1000

SLIDER
0
115
206
148
convert_probability_percentage
convert_probability_percentage
0
100
80.0
10
1
NIL
HORIZONTAL

SLIDER
0
266
172
299
stop-ticks
stop-ticks
0
20000
20000.0
1
1
NIL
HORIZONTAL

MONITOR
953
494
1117
539
Humans
count humans
17
1
11

MONITOR
1138
494
1295
539
Zombies
count zombies
17
1
11

SWITCH
1
152
172
185
show_vision_cone
show_vision_cone
0
1
-1000

SWITCH
1
189
172
222
smell_radius
smell_radius
1
1
-1000

@#$#@#$#@
## WHAT IS IT?

(a general understanding of what the model is trying to show or explain)

## HOW IT WORKS

(what rules the agents use to create the overall behavior of the model)

## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)

## THINGS TO NOTICE

(suggested things for the user to notice while running the model)

## THINGS TO TRY

(suggested things for the user to try to do (move sliders, switches, etc.) with the model)

## EXTENDING THE MODEL

(suggested things to add or change in the Code tab to make the model more complicated, detailed, accurate, etc.)

## NETLOGO FEATURES

(interesting or unusual features of NetLogo that the model uses, particularly in the Code tab; or where workarounds were needed for missing features)

## RELATED MODELS

(models in the NetLogo Models Library and elsewhere which are of related interest)

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
