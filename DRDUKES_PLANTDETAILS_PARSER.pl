#FILENAME: 	PLANTDETAILS_PARSER.pl
#Objective: 	Obtains HTML reports of each plant in Dr.Dukes Phytochemical and Ethnobotanical Database -> Converts them to text format while conserving the tree structure -> Pipes it to a file or a set of files, one for each plantID -> Parses Scientific Name, Common Name(s),Family Name -> Prints parsed data together with corresponding plant ID in .tsv format to STDOUT
#EXECUTION: 	$ perl PLANTDETAILS_PARSER.pl 
#		$ perl PLANTDETAILS_PARSER.pl > DrDukes_PlantID_Name_Family.tsv
###############################################################################


#!/usr/bin/perl
use strict;
use warnings;
use feature qw(say);
use LWP::Simple; #To Get data as HTML report from the URL
use HTML::TreeBuilder; #Builds a HTML tree
use HTML::FormatText; #Converts tree to text

my $plantID = 1; #PlantIDs start from 1
say join ("\t","Plant ID", "Scientific Name", "Common Name", "Family Name"); #Header of outfile
while ($plantID <= 10) { #Retrieves data for only the first 10 plants. Change as needed
	my $baseURL = "https://phytochem.nal.usda.gov/phytochem/plants/show/$plantID?part=&_ubiq=&ubiq=on";

#Get HTML & Convert it to text conserving the tree format
	my $HTML = get($baseURL);
	my $format = HTML::FormatText->new;
	my $tree = HTML::TreeBuilder->new;
	$tree->parse($HTML);
	my $parsed = $format->format($tree);
	#say $parsed;

#Pipes the tree text to a file (Conserves space on local disk)
#Or custom files, each with a report on one plant placed in the created Directory (More information, Comes at the cost of disk space)
	my $dirName = '/Users/swatz_bachoo/AyurPhyta/DrDukes_PlantData'; #Path/New Directory Name
	unless (-e $dirName) { #unless this directory -e exists, create a new user directory
        	`mkdir -p $dirName`; #Creates a parent directory for holding other child directories
	}	
	my $fileName = $dirName.'/plantID.txt'; #If you want separate records for each plant ID, then
	#my $fileName = $dirName.'/plantID.'.$plantID.'.txt'; 
	#See sample file, plantID.1.txt
	say STDERR "Retrieving plant ID: $plantID";
	my $outFH;
	open ($outFH, ">", $fileName) or die $!; 
	binmode($outFH, ":utf8"); #To avoid "Wide Character in Print" error
	print $outFH $parsed;
	close $outFH;

#Open file for reading and parsing
	my $inFH;
	my @scientificName;
	my @familyName;
	my @commonName;
	unless (open ($inFH, "<", $fileName)) {
        	die "Cannot open $fileName for reading", $!;
	}
	while (<$inFH>) {
        	chomp $_;
		if (($. == 16) && ($_ =~ /^\s+P\s+(\w+\s+\w+)\s+\((.+)\)\s+PDF/)) { #Data present in Line 16 in the RegEx pattern
			$scientificName[$plantID] = $1;
			$familyName[$plantID] = $2;
		}	
		if (($. == 25) && ($_ =~ /\s+(.+)/))  { #Data present in Line 25 in the RegEx pattern
			$commonName[$plantID] = $1;
		}	
	}
	close $inFH;
	say join ("\t", $plantID, $scientificName[$plantID], $commonName[$plantID], $familyName[$plantID]);
	#Prints the captured data in a tab separated format
	sleep(2); #Ensuring that the database which so graciously provided open access to data is not made a sitting duck
	
	#Increment plantID and Iterate	
	$plantID = $plantID + 1;
}


