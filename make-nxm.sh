#! /bin/bash
#
# Create a composed n x m image from a single image and
# use the (average) border color as inter-image (gutter) color
 
# LINUX convert \( aa.png aa.png aa.png aa.png aa.png  +append \)  \( aa.png aa.png aa.png aa.png aa.png +append \) -append -gaussian-blur 0.5x0.5 x.png

# call make-nxm <image-filename> rows columms [postfilter-command]

# Location of Imagemagick convert/magick:
convert=/opt/magick

POSTFILTER="-gaussian-blur 0.5x0.5"
MARGIN=20

if [ $# -lt 3 ] ; then

 echo
 echo "Create a composed n x m image from a single image and"
 echo "use the (average) border color as inter-image (gutter) color"
 echo
 echo "Usage:    make-nxm image-filename rows colums [innermargin] [postfilter-command]"
 echo "          default gap between images: ${MARGIN}"
 echo "          default postfilter: ${POSTFILTER}"
 echo
 echo "Examples: make-nxm img.png 2 4"
 echo "          make-nxm img.png 2 4 ${MARGIN}"
 echo "          make-nxm img.png 2 4 ${MARGIN} ${POSTFILTER}"
 echo
 echo "          create output image 2x4_img.png"
 echo "          composed of 2 rows and 4 columns of img.png"
 echo "          with a gap of ${MARGIN} pixels between the images"
 echo "          with gaussian blur filter 0.5x0.5 (default filter)"
 echo

 exit

fi


if [[ $4 == ?(-)+([[:digit:]]) ]] ; then

	MARGIN=$4

	if [ $# -gt 4 ] ; then

  		POSTFILTER="$5 $6 $7 $8 $9"

	fi

else

	if [ $# -gt 3 ] ; then

  		POSTFILTER="$4 $5 $6 $7 $8"

	fi

fi

FILENAME=$1
ROWS=$2
COLUMNS=$3
OUTFILENAME=${FILENAME%.*}_${ROWS}x${COLUMNS}-${MARGIN}.${FILENAME##*.}

# default
# INNERMARGIN="+append"


GUTTERCOLOR=`$convert ${FILENAME} -set option:ww %w -set option:hh %h \( +clone -fuzz 15% -trim -alpha set -channel rgba -evaluate set 0% -format "excess width=%[fx:ww-w],excess height=%[fx:hh-h]\n" \) -compose copy -flatten -scale 1x1! -alpha off -format "border color=%[pixel:u.p{0,0}]\n" info: | sed -e "s/border color=s//" -`
# GUTTERCOLOR="magenta"


GUTTERWIDTH="-background ${GUTTERCOLOR} -splice ${MARGIN}x${MARGIN}+0+0 +append -chop ${MARGIN}x0+0+0"

echo "${ROWS} rows and ${COLUMNS} columns"
echo "margin (gutter width) between images: ${MARGIN}px"
echo "gutter color: ${GUTTERCOLOR}"
echo "postfilter: ${POSTFILTER}"


y=""
col=1; while [ $col -le $COLUMNS ]; do y="$y $FILENAME "; col=$[$col+1]; done
row=1; while [ $row -le $ROWS ]; do z="$z ( $y $GUTTERWIDTH ) "; row=$[$row+1]; done

$convert $z -append -chop 0x${MARGIN}+0+0 $POSTFILTER ${OUTFILENAME}
$convert ${OUTFILENAME} -resize 3000 ${OUTFILENAME%.*}_reduced.${OUTFILENAME##*.}
