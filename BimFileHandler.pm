#!/usr/bin/perl -w

package BimFileHandler;

use strict;
use warnings;

use Cwd;

#Constructor
sub new{
	my $self = {};
	bless($self, "BimFileHandler");
	return $self;
}

1; 

# This subroutine parses a BIM files and returns the set of SNPs that lie
# between two limiting positions on the chromosome. It also writes the
# selected SNPs into a new file.
# The limiting positions are 50 MB on either side of a SNP of interest
# INVOKE: getDifferentSNPsFromBimFiles();

sub getSNPsFromBimFile{

	use constant START_POSITION => 49366316; #50 MB to left of SNP of interest
	use constant END_POSITION => 149366316;	#50 MB to the right of SNP of interest

	my %snpMap = ();
	
	print "Enter the name of the BIM file:";
	my $filename = <STDIN>;
	chomp($filename);

	my $line;
	my $snpID;
	my $pos;
	my @elements;
	
	my @inputfilenameparts = split(/\//, $filename);
	my @fileNameAndExtension = split(/\./, $inputfilenameparts[-1]);
	
	my $outputfilename = $fileNameAndExtension[0]."-selectSNPs.".$fileNameAndExtension[1];
	
	open (INPUT, "$filename") or die "Unable to open $filename. Exiting\n";
	open (OUTPUT, ">$outputfilename");
	
	foreach $line (<INPUT>){
 		chomp($line);
		@elements = split(/\t/, $line);
			
		$snpID = $elements[1];
		$pos = $elements[3];
		
		if($pos <= END_POSITION && $pos >= START_POSITION){
			$snpMap{$snpID} = $line;				
			print OUTPUT "$line\n";
		}
	}	
	
	close OUTPUT;
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
	
	my (%map1) = %{$_[1]}; # $_[0] gives the name of the method as a ref!!! 
	my @keys1 = keys %map1;
	
	my (%map2) = %{$_[2]};
	my @keys2 = keys %map2;
	
	my $i;
	my $j;
	my $found = 0;
	
	for($i = 0; $i <= $#keys1; $i++){
		for($j = 0; $j <= $#keys2; $j++){
			if($keys1[$i] eq $keys2[$j]){
				$found = 1;
				last;
			}
		}
		if($found eq 0 && $keys1[$i] !~ /cnvi/){
			push(@dif, "$map1{$keys1[$i]}");
		}
	}
	
	return @dif;
}

# A method for writing lines from an array into a file
# INVOKE: writeFile(@array)

sub writeFile{
	
	print "Enter the name of the output BIM file:";
	my $filename = <STDIN>;
	chomp($filename);
	
	my (@dif) = @{$_[1]};
	
	my $line;
	
	open(OUTFILE, ">$filename");
	
	foreach $line (@dif){
		print OUTFILE "$line\n";
	}

	close OUTFILE;
}

