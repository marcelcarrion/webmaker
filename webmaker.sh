#!/bin/sh
#script to convert videos to either gifs or webms

#filename as argument
vid=$1
finame=$2

#filename minus the file extension if none is given
[ -z $finame ] && finame=${vid//.*/}

read -p 'gif or webm?1,2:' op
case $op in
1)
#video to gif
read -p 'framerate:' fps
read -p 'scale:' scl
ffmpeg -i "$vid" -vf "fps=$fps,scale=$scl:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 "$finame.gif"
;;
2)
read -p 'bitrate in M:' bitr
#video to webm
read -p 'no audio(empty if you want audio)?' audio
[ -z $audio ] || an=" -an"
read -p 'scale in p(empty if none)' res
[ -z $res ] || res=" -vf scale=-1:"$res
ffmpeg -i "$vid" -c:v libvpx -vb $bitr'M'$an$res "$finame.webm"
;;
*)
echo 'Invalid option!'
;;
esac
