# make-nxm.sh:

* Create a composed n x m image from a single image
* use the average border color as inter-image (gutter) color 
* create both a full and a resolution-reduced image

purpose: facilitate flyer production from a sharepicture, for example from https://fahrradtermine.berlin
 
* bash script
* only requirement: imagemagick (aka magick; convert)

Presented at Berlin Hack'n'Tell #98 (BHNT #98) at c-base Berlin 27.08.2024

Input:
![](https://raw.githubusercontent.com/Wikinaut/make-nxm/main/examples/20240828_Thielallee.jpg)

`make-nxm input 2 2`

Output:
![](https://raw.githubusercontent.com/Wikinaut/make-nxm/main/examples/20240828_Thielallee_2x2-20_reduced.jpg)
