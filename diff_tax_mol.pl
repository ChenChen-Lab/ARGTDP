#!/usr/bin/perl
use List::Util qw/max min/;
$mol=0;
%mo=();
$file_in=shift;
$file_out=shift;

sub overlap {
($r1,$r2)=@_;
($c1,$st1,$en1)=split("\t",$r1);
($c2,$st2,$en2)=split("\t",$r2);
$ov_s=max($st1,$st2);
$ov_e=min($en1,$en2);
$len1=$en1-$st1;
$len2=$en2-$st2;
$len_m=min($len1,$len2);
$ov_r=($ov_e-$ov_s)/$len_m;
return($ov_r);
}

open (F1,$file_in);
while(<F1>){
	chomp;
	@items=split;
	$s1=min ($items[6],$items[7]);
	$e1=max ($items[6],$items[7]);
	$s2=min ($items[8],$items[9]);
	$e2=max ($items[8],$items[9]);
	
	$region1=$items[0]."\t".$s1."\t".$e1;
	$region2=$items[1]."\t".$s2."\t".$e2;
#	print "$region1\t$region2\n";	
	if(not exists $mo{$region1} and exists $mo{$region2}){
		$mo{$region1}=$mo{$region2};
		push @{$region{$items[0]}},$region1;
	}elsif(exists $mo{$region1} and not exists $mo{$region2}){
		$mo{$region2}=$mo{$region1};
		push @{$region{$items[1]}},$region2;
	}elsif(not exists $mo{$region1} and not exists $mo{$region2}){
		$c_o=0;
		if (exists $region{$items[0]}){
		for $region_d(@{$region{$items[0]}}){
			$over_rate=overlap($region1,$region_d);
			if($over_rate > 0.5){
				$mo{$region1}=$mo{$region_d};
				$mo{$region2}=$mo{$region1};
				$c_o++;
			}
		}
		}elsif(exists $region{$items[1]}){
		for $region_d(@{$region{$items[1]}}){
			$over_rate=overlap($region2,$region_d);
			if($over_rate > 0.5){
				$mo{$region2}=$mo{$region_d};
				$mo{$region1}=$mo{$region2};
				$c_o++;
			}
		}
		}
		if($c_o==0){
			$mol++;
			$mo{$region1}=$mol;
			$mo{$region2}=$mol;
		}
			push @{$region{$items[0]}},$region1;
			push @{$region{$items[1]}},$region2;
		
	}
	$file_out_f=$file_out.".".$mo{$region1}.".m8";
	print "$file_out_f\n";
	open (F2,">>$file_out_f");
	print F2 join("\t",@items);
	print F2 "\n";
	close F2;
#	print "$region1\t$mo{$region1}\n$region2\t$mo{$region2}\n";

}
close F1;

for $contig (sort {$mo{$a} <=> $mo{$b}} keys %mo){
	print "$contig\t$mo{$contig}\n";
}
