#!/bin/bash
f=$1
#formatdb -p F -i ../gene_prediction/Result/$f.fna
#blastall -p blastn -d ../gene_prediction/Result/$f.fna -i ../gene_prediction/Result/$f.fna -m 8 >$f.m8

awk '$1!=$2&&$3>99&&$4>500' $f.m8 >$f.selected.m8
../../my_join.pl -F 1 -f 1 -a $f.selected.m8 -b ../Kraken/$f.labels |../../my_join.pl -F 2 -f 1 -a - -b ../Kraken/$f.labels >$f.selected.labels
../../tax_bl_result.pl $f.selected.labels >$f.diff_tax
../../diff_tax_mol.pl $f.diff_tax >$f.mol 
../../my_join.pl -F 1 -f 1 -a $f.mol -b ../Kraken/$f.labels >$f.mol.labels
