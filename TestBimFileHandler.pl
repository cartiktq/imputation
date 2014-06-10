#!/usr/bin/perl;

use BimFileHandler;


$bfh = BimFileHandler->new();

print "opening bim file\n";

%snpMap = $bfh->getSNPsFromBimFile("../imputation/plink/chr7From1000Genes/chr7From1000Genes.bim");

@snps = keys %snpMap;

print "$#snps\n";