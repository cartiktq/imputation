#!/usr/bin/perl -w

use strict;
use warnings;

use BimFileHandler;

print "TEST::: Instantiating BimFileHandler\n";

my $bfh = BimFileHandler->new();

# 1000 Genes ----> "../imputation/plink/chr7From1000Genes/chr7From1000Genes.bim";
# Metabo Chip ---> "../imputation/plink/CAP838metabochipChr7ForJoe/CAP838metabochipChr7ForJoe.bim"
# Illumina Chip -> "../imputation/plink/CAP300and610Kchr7forJoe/CAP300and610Kchr7forJoe.bim"

print "TEST::: Extracting SNPs From BIM files\n";

my %snpMap1 = $bfh->getSNPsFromBimFile();
my %snpMap2 = $bfh->getSNPsFromBimFile();

my @keys1 = keys %snpMap1;
my @keys2 = keys %snpMap2;

print "TEST::: Finding Difference Between SNP sets\n";

my @diff = $bfh->findDifferenceBetweenSnpSets(\%snpMap1, \%snpMap2);

my @snps1 = keys %snpMap1;
my @snps2 = keys %snpMap2;

print "TEST::: Writing to File\n";

$bfh-> writeFile(\@diff);

print "TEST::: ENDING TEST EXECUTION: $#snps1\t$#snps2\t$#diff\n";
