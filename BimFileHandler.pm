#!/usr/bin/perl

package BimFileHandler;

use strict;
use warnings;

#Constructor
sub new{
	my $self = {};
	bless($self, "BimFileHandler");
	return $self;
}

1; 

# This subroutine parses a BIM files and returns the set of SNPs that lie
# between two limiting positions on the chromosome
# The limiting positions are 50 MB on either side of a SNP of interest
# INVOKE: getDifferentSNPsFromBimFiles();

sub getSNPsFromBimFile{

	my %snpMap = ();
	
	my $snp_count = 0;
	my $total_snp_count = 0;
	
	my $filename = "../imputation/plink/chr7From1000Genes/chr7From1000Genes.bim";
	my $line;
	my $snpID;
	my $pos;
	my @elements;
	
	use constant START_POSITION => 49366316; #50 MB to left of SNP of interest
	use constant END_POSITION => 149366316;	#50 MB to the right of SNP of interest
	
	open INPUT, $filename or die "Unable to open $filename. Exiting\n";

	foreach $line (<INPUT>){
 		chomp($line);
		@elements = split(/\t/, $line);
			
		$snpID = $elements[1];
		$pos = $elements[3];
		
		if($pos <= END_POSITION && $pos >= START_POSITION){
			$snpMap{$snpID} = $line;
			++$snp_count;		
		}
		++$total_snp_count;	
	}
	close INPUT;
		
	return %snpMap;
}

# Given two hashmaps, this function finds the key-value pairs that are found in the first map
# AND are not found in the second map. I.E. The K-V pairs that are unique to the first map.
# The assumption is that the second map is a subset of the first. This is not a generic method
# for determining the proper difference between two hashmaps.
# INVOKE: findDifferenceBetweenSnpSets(\%Map1, \%Map2). Note map arguments are passed by reference

sub findDifferenceBetweenSnpSets{
	my @dif = ();
	
	my (%list1) = %{$_[0]};
	my (%list2) = %{$_[1]};
	
	my @keys1 = keys %list1;
	my @keys2 = keys %list2;
	
	my $i;
	my $j;
	my $found;
	
	for($i = 0; $i < $#keys1; $i++){
		for($j = 0; $j < $#keys2; $j++){
			if($keys1[$i] eq $keys2[$j]){
				$found = 1;
				last;
			}
		}
		if($found eq 0 && $keys1[$i] !~ /cnvi/){
			push(@dif, "$list1{$keys1[$i]}");
		}
	}
	
	return @dif;
}

# A method for writing lines from an array into a file
# INVOKE: writeFile($file, @array)

sub writeFile{
	
	my $diff_ct = 0;
	my($file, @dif) = @_;
	
	my $line;
	
	open(OUTFILE, ">$file");
	
	foreach $line (@dif){
		++$diff_ct;
		print OUTFILE $line;
	}

	close OUTFILE;
	
	print "$diff_ct\n";
	
}

