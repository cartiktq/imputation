#!/usr/bin/perl -w

use strict;
use warnings;

use GenFileHandler;

print "TEST::: Instantiating GenFileHandler\n";

my $gfh = GenFileHandler->new();

# Metabo Chip ---> "../imputation/plink/CAP838metabochipChr7ForJoe/CAP838metabochipChr7ForJoe.gen"
# Illumina Chip -> "../imputation/plink/CAP300and610Kchr7forJoe/CAP300and610Kchr7forJoe.gen"

print "TEST::: Extracting SNPs From GEN file\n";

$gfh->selectSNPsFromGenFile();

print "TEST::: FINISHED!!!\n";

