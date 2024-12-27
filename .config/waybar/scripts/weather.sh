#!/bin/sh

TEMPERATURE=$(curl "wttr.in/?format=j1" | grep "FeelsLikeF" | awk 'NR==1{print $2}' | sed -e 's/^"//' -e 's/",//')

WEATHER_CODE=$(curl "wttr.in/?format=j1" | grep "weatherCode" | awk 'NR==1{print $2}' | sed -e 's/^"//' -e 's/",//')

weather_info() {
  echo $1 " " $TEMPERATURE°F
}

case $WEATHER_CODE in
113)
  weather_info '󰖨 '
  ;;
116)
  weather_info ' '
  ;;
119)
  weather_info ' '
  ;;
122)
  weather_info ' '
  ;;
143)
  weather_info ' '
  ;;
176)
  weather_info ' '
  ;;
179)
  weather_info ' '
  ;;
182)
  weather_info ' '
  ;;
185)
  weather_info ' '
  ;;
200)
  weather_info ' '
  ;;
227)
  weather_info ' '
  ;;
230)
  weather_info ' '
  ;;
248)
  weather_info ' '
  ;;
260)
  weather_info ' '
  ;;
263)
  weather_info ' '
  ;;
266)
  weather_info ' '
  ;;
281)
  weather_info ' '
  ;;
284)
  weather_info ' '
  ;;
293)
  weather_info ' '
  ;;
296)
  weather_info ' '
  ;;
299)
  weather_info ' '
  ;;
302)
  weather_info ' '
  ;;
305)
  weather_info ' '
  ;;
308)
  weather_info ' '
  ;;
311)
  weather_info ' '
  ;;
314)
  weather_info ' '
  ;;
317)
  weather_info ' '
  ;;
320)
  weather_info ' '
  ;;
323)
  weather_info ' '
  ;;
326)
  weather_info ' '
  ;;
329)
  weather_info ' '
  ;;
332)
  weather_info ' '
  ;;
335)
  weather_info ' '
  ;;
338)
  weather_info ' '
  ;;
350)
  weather_info ' '
  ;;
353)
  weather_info ' '
  ;;
356)
  weather_info ' '
  ;;
359)
  weather_info ' '
  ;;
362)
  weather_info ' '
  ;;
365)
  weather_info ' '
  ;;
368)
  weather_info ' '
  ;;
371)
  weather_info ' '
  ;;
374)
  weather_info ' '
  ;;
377)
  weather_info ' '
  ;;
386)
  weather_info ' '
  ;;
389)
  weather_info ' '
  ;;
392)
  weather_info ' '
  ;;
395)
  weather_info ' '
  ;;
*)
  weather_info '󰖨 '
  ;;
esac
