#!/usr/bin/perl;

use BimFileHandler;

$bfh = BimFileHandler->new();

#"../imputation/plink/chr7From1000Genes/chr7From1000Genes.bim";

%snpMap = $bfh->getSNPsFromBimFile();

@snps = keys %snpMap;

print "$#snps\n";