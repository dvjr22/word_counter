#!/usr/bin/perl
#word_count

use File::Find;
use File::Copy;
use warnings;
use strict;

#--- Directory recursion path 
my $base_path = "/directory/path";
my %count;
my $log_file = "/directory/path/wordcount.txt";


open LOG, ">> $log_file" or die "Can't write on file $log_file: $!\n";

#process files
ProcessFiles ($base_path);

foreach my $str (sort keys %count) {
    printf "%-31s %s\n", $str, $count{$str};
	print LOG $str."\t\t".$count{$str}."\n";
}


#############################################################################################
################		Begin Sub Routines		#############################
#############################################################################################

#////////////////////////////////////////////////////////////////////////////////////////////

=head1 ProcessFiles

Parameters	:	
Returns		:
Description	:

=cut

sub ProcessFiles {

    	#my $path = shift;
	my $path = $_[0];
	my @array;

   	#open directory
    	opendir(DIR, $path) or die "Unable to open $path: $!";

	#read in files
	#grep to eliminate '.', '..' files
    	my @files = grep { !/^\.{1,2}$/ } readdir (DIR);

    	#close directory.
    	closedir (DIR);

	#place file names into map to attach full path
    	@files = map { $path . '/' . $_ } @files;

	#
    	for (@files) {
        	#if file is a directory
		if (-d $_) {
		#recursive call w/ new directory
		ProcessFiles ($_);

		#process file
		} else { 

			#open file
			open IN, $_ or die "Can't read source file $_: $!\n";
			print "Counting file: $_\n";
			
			while (<IN>) {
				#chomp each line. will remove \n from each string
				chomp $_;
				@array = split ' ', $_;
			
				foreach my $titles ($array[0]){
					$count{$titles}++;
				}

			}#close while loop
			close IN;

        }#close if statement

    }#close for loop

}

