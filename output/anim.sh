#!/bin/bash
#
#name='temp'
#name='Hs'
#name='vel'
#name='dye'
#name='temp_vel'
#name='elev_vel'
name='Y1_temp_1994'
#
anim_dir='figs_png_'${name}
echo ${anim_dir}

#cp -r figs_png ${anim_dir}
#rm figs_png/*.png
#echo 'copy fin.'
#
#convert -layers optimize -delay 10 figs_png_${name}/*.png anim/anim_${name}.gif
convert -layers optimize -delay 5 figs_png_${name}/*.png anim/anim_${name}.gif
