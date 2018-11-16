#!/bin/bash
# INPUT 1: Path of mask file to check (i.e., mask used for neurosynth)
# INPUT 2: text file with four columns (name of standard brain used [e.g., MNI152_T1_2mm or MNI152_T1_1mm, but any image found in $FSLDIR/data/standard will work], x, y, and z coordinate in mm). Make sure you hit return at the end of the list, or the last line will get clipped
# INPUT 3: name of output file, e.g., ~/Desktop/myoutput.txt. This WILL get overwritten
# OUTPUT: Input text file plus a fifth column indicating whether the coordinate falls in the mask

MASK=$1
INPUT_TXT=$2
OUTPUT=$3

rm $OUTPUT

while read -r line; do
	inputarray=($line)
    template_used=${inputarray[0]}
    echo ${inputarray[1]} ${inputarray[2]} ${inputarray[3]}	> tmpcoord.txt
    voxcoords=`std2imgcoord -img ${FSLDIR}/data/standard/${template_used} -std ${FSLDIR}/data/standard/${template_used} tmpcoord.txt -vox`
    voxarray=($voxcoords)
    fslmaths ${FSLDIR}/data/standard/${template_used} -roi ${voxarray[0]} 1 ${voxarray[1]} 1 ${voxarray[2]} 1 0 1 -bin tmproi
    fslmaths tmproi -mas $MASK -bin tmproi2
    result=`fslstats tmproi2 -M`
    if [ "${result::1}" -eq "1" ]; then
    	echo $template_used ${inputarray[1]} ${inputarray[2]} ${inputarray[3]} yes >> $OUTPUT
    else
    	echo $template_used ${inputarray[1]} ${inputarray[2]} ${inputarray[3]} no >> $OUTPUT
    fi
done < "$INPUT_TXT"

#rm tmpcoord.txt
#rm tmproi.nii.gz
#rm tmproi2.nii.gz
