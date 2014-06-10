#!/usr/bin/perl

#use strict;
#use warnings;

# (1) quit unless we have the correct number of cmd-line arguments

$num_args = $#ARGV + 1;
if($num_args != 2){
	print "\n Usage: read-bim-file.pl filename1 filename2\n";
	exit;
}

# (2) If there is one command line argument, that is the file name

$filename1 = $ARGV[0];
$filename2 = $ARGV[1];
$outfile = "../imputation/plink/Afr_Amr_SNPs.bim";

# (3) Open file

chomp($filename1);
chomp($filename2);	

@diff = ();
$found = 0;


%snpSet1 = getSNPsFromBimFile($filename1);
@keys1 = keys %snpSet1;
print "($#keys1 + 1) SNPs found in $filename1\n";
%snpSet2 = getSNPsFromBimFile($filename2);
@keys2 = keys %snpSet2;
print "($#keys2 + 1) SNPs found in $filename2\n";

@diff = findDifferenceBetweenSnpSets(\%snpSet1, \%snpSet2);

writeFile($outfile, @diff);

# This subroutine parses a BIM files and returns the set of SNPs that lie
# between two limiting positions on the chromosome
# The limiting positions are 50 MB on either side of a SNP of interest
# INVOKE: getDifferentSNPsFromBimFiles($filename);
# ARG1 -> $filename: The name of the BIM file

sub getSNPsFromBimFile{

	my %snpMap = ();
	
	$snp_count = 0;
	$total_snp_count = 0;
	
	($filename, $pos) = @_;
	
	use constant START_POSITION => 49366316; #50 MB to left of SNP of interest
	use constant END_POSITION => 149366316;	#50 MB to the right of SNP of interest
	
	open INPUT, $filename or die "Unable to open $filename. Exiting\n";

	foreach $line (<INPUT>){
 		chomp;
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
	@dif = ();
	
	my (%list1) = %{$_[0]};
	my (%list2) = %{$_[1]};
	
	@keys1 = keys %list1;
	@keys2 = keys %list2;
	
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
	
	$diff_ct = 0;
	my($file, @dif) = @_;
	
	open(OUTFILE, ">$file");
	
	foreach $line (@dif){
		++$diff_ct;
		print OUTFILE $line;
	}

	close OUTFILE;
	
	print "$diff_ct\n";
	
}

