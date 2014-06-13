#!/usr/bin/perl -w

package GenFileHandler;

use strict;
use warnings;

use Cwd;

#Constructor
sub new{
	my $self = {};
	bless($self, "GenFileHandler");
	return $self;
}

1; 

# This method parses an input GEN file and outputs a set of
# SNPs within a required stretch of the chromosome. The extracted 
# lines from the GEN file are written into a new GEN file with an
# appropriately named ("Old File Name Hypen Selected SNPs.GEN")
# file
# INVOCATION: selectSNPsFromGenFile(); 

sub selectSNPsFromGenFile{

	my ($startpos, $endpos) = getStartAndEndPositions();
 
 	my $i = 0; #this is used to generate SNP IDs for the output GEN file
	my $t = 0;
 	my $line;
	my $pos;
	my $snpID;
	my $rsID;
	my @elements;
 
	print "Enter the name of the GEN file:";
	my $filename = <STDIN>;
	chomp($filename);
	
	my $outputfilename = generateOutputFilename($filename);
	
	open (INPUT, "$filename") or die "Unable to open $filename. Exiting\n";
	open (OUTPUT, ">$outputfilename");
	
	foreach $line (<INPUT>){
 		chomp($line);
		++$t;
		@elements = split(/\s/, $line);
			
		$pos = $elements[2];
		$rsID = $elements[1];
		
		if($pos <= $endpos && $pos >= $startpos && $rsID =~ /rs[0-9]+/){
			++$i;
			$snpID = "SNP_" . $i;
			$elements[0] = $snpID;
			$line = join(" ", @elements);
			print OUTPUT "$line\n";
		}
	}	
	
	print "$i SNPs were selected out of $t and were written to file\n";
	
	close OUTPUT;
	close INPUT;
}

sub getStartAndEndPositions{
	
	my $startpos;
	my $endpos;
	my $position;
	
	print "Enter the position of the SNP of interest: ";

	$position = <STDIN>;
	chomp($position);

	while($position !~ /[\d]+/){
			print "Illegal Value Entered for Position. Enter the position of the SNP of interest: ";
			$position = <STDIN>;
			chomp($position);
	}
	
	$startpos = $position - 50000000;
	
	if($startpos < 0){
		$startpos = 0;
	}
	
	$endpos = $position + 50000000;
	
	return ($startpos, $endpos);
}

sub generateOutputFilename{
	
	my ($infilename) = @_;
	
	my @inputfilenameparts = split(/\//, $infilename);
	my @fileNameAndExtension = split(/\./, $inputfilenameparts[-1]);
	
	my $outputfilename = $fileNameAndExtension[0]."-selectSNPs.".$fileNameAndExtension[1];

	return $outputfilename;
}