mol=$1
gff_emap=$2
anno_emap=$3
sam=$4

intersectBed -a ${mol}  -b <(grep -v '#' ${gff_emap}|awk '{print $1"\t"$4"\t"$5"\t1\t"$7"\t"$9}' ) -wb |sort -u >${sam}.hgt.gene
 ../../my_join.pl -F 1 -f 1 -a <( cut -f 10 ${sam}.hgt.gene |cut -d ";" -f 1|sed 's/ID=//') -b  ${anno_emap}>${sam}.hgt.emapper.anno

a=`cat ${sam}.hgt.emapper.anno|wc -l` 
cut -f 8 ${sam}.hgt.emapper.anno |awk 'length($1)==1'|sort |uniq -c |sort -nr|awk -v s=${sam} -v a=$a '{print s"\t"$2"\t"$1"\t"a}' >${sam}.hgt.cog
cut -f 14 ${sam}.hgt.emapper.anno |sed 's/,/\n/g'|sort|uniq -c|sort -nr|grep 'map'|grep -v '-'|awk -v s=${sam} -v a=$a  '{print s"\t"$2"\t"$1"\t"a}' >${sam}.hgt.map

b=`cat ${anno_emap}|wc -l` 
cut -f 7 ${anno_emap}|awk 'length($1)==1'|sort |uniq -c |sort -nr|awk -v s=${sam} -v b=$b  '{print s"\t"$2"\t"$1"\t"b}' >${sam}.all.cog
cut -f 13 ${anno_emap}|sed 's/,/\n/g'|sort|uniq -c|sort -nr|grep 'map'|grep -v '-'|awk -v s=${sam} -v b=$b  '{print s"\t"$2"\t"$1"\t"b}' >${sam}.all.map
