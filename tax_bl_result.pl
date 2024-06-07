#!/usr/bin/perl
#$file=shift;
#$level=shift;

#open (F1,$file);
#while($line=<F1>){
while($line=<>){
	%t1=();%t2=();
	chomp($line);
	@items=split("\t",$line);
	if($items[13] ne "" and $items[15] ne ""){
	@tax1=split(/\|/,$items[13]);
	for $tax(@tax1){
		if ($tax =~ /d__/){
			$t1{"d"}=$tax;
		#	print "$tax\td\t".$t1{"d"}."\n";
		}elsif($tax =~ /^p__/){
			$t1{"p"}=$tax;
		}elsif($tax =~ /^c__/){
			$t1{"c"}=$tax;
		}elsif($tax =~ /o__/){
			$t1{"o"}=$tax;
		}elsif($tax =~ /f__/){
			$t1{"f"}=$tax;
		}elsif($tax =~ /g__/){
			$t1{"g"}=$tax;
		}elsif($tax =~ /s__/){
			$t1{"s"}=$tax;
		}
	}
	
	@tax2=split(/\|/,$items[15]);
	for $tax(@tax2){
		if ($tax =~ /d__/){
			$t2{"d"}=$tax;
		}elsif($tax =~ /p__/){
			$t2{"p"}=$tax;
		}elsif($tax =~ /c__/){
			$t2{"c"}=$tax;
		}elsif($tax =~ /o__/){
			$t2{"o"}=$tax;
		}elsif($tax =~ /f__/){
			$t2{"f"}=$tax;
		}elsif($tax =~ /g__/){
			$t2{"g"}=$tax;
		}elsif($tax =~ /s__/){
			$t2{"s"}=$tax;
		}
	}
	
	@levels=qw(d p c o f g s);
	$dis=0;
	for $l (@levels){	
	#	print "$l\t".$t1{$l}."\t".$t2{$l}."\n";
		if (exists $t1{$l} and exists $t2{$l} and $t1{$l} ne $t2{$l}){
			$dis ++;
			$dis_l=$l;
			
		}
	}

	if($dis >0){
		print "$line\t$dis\n";
	}
	
	}
}
