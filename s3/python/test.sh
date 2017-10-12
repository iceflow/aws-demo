#!/bin/bash

# 1 week pre-signed_url
#./s3_demo.py generate_presigned_url default leoaws public/devops_decks.bz2 604800


L="htsc-ebc/DavidPellerin_EBC250+How+to+Cultivate+an+Innovation-Driven+Culture.pptx"
L="htsc-ebc/DevOps_ProServe_HuataiSecuritiesFINAL.pptx $L"
L="htsc-ebc/EricWazorko_Finra_Huatai+Briefing.pptx $L"
L="htsc-ebc/PeterWilliams_AWS+FSI+-+Huatai+Securities.pptx $L"
L="$L"

#
arr[0]="htsc-ebc/DavidPellerin_EBC250 How to Cultivate an Innovation-Driven Culture.pptx"
arr[1]="htsc-ebc/DevOps_ProServe_HuataiSecuritiesFINAL.pptx"
arr[2]="htsc-ebc/EricWazorko_Finra_Huatai Briefing.pptx"
arr[3]="htsc-ebc/PeterWilliams_AWS FSI - Huatai Securities.pptx"

L="htsc-ebc/DavidPellerin_EBC250 How to Cultivate an Innovation-Driven Culture.pptx"


P=default
B=leoaws
E=604800


for item in ${arr[*]}; do
	echo "Processing $item ....."
#	eval './s3_demo.py generate_presigned_url $P $B "$item" $E'
done

exit 0
