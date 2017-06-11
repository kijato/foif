#!/usr/bin/perl

use strict;
use locale; # Ez kell az ABC szerinti helyes rendezéshez.
use Data::Dumper;

my $metaData={};
my $datas=[];
my $oneData={};
my $antenna="";

open FH,$ARGV[0];
while(<FH>) {
	
	chomp;

	if ( /^--(FOIF FieldGenius.*)$/ ) {
		$metaData->{'THE FIRST LINE'}=$1;
	}
	
	if ( /^--(Instrument Selected):\s*(.*)$/ or
		 /^(JB|MO|CS|VA),(.*)$/ )
	{
	  $metaData->{$1}=$2;
	}

	if ( /^--GNSS (Profile Tolerance RT):\s*(.*)$/ or
		 /^--GNSS (Profile Tolerance PP):\s*(.*)$/ or
		 /^--GNSS (Statistics RT):\s*(.*)$/ or
		 /^--GNSS (Statistics PP):\s*(.*)$/ or
		 /^--(PP Time):\s*(.*)$/ or
		 /^(AH|EP|BL|CV|GS),(.*)$/ )
	{
	  $oneData->{$1}=$2;
	}

	if(/^--(Antenna):\s*(.*)$/) {
		$antenna = $2;
	}
	
	if ( /^GS,.*$/ ) {
		$oneData->{'Antenna'}=$antenna;
		push @{$datas},$oneData;
		$oneData={};
	}

}
close FH;

print "\n²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²\n\n";
print Dumper $metaData;
print "\n°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\n\n";
print Dumper $datas;
print "\n°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\n\n";

PrintRow($datas,'BL');
PrintRow($datas,'EP');

print "\n°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°°\n\n";

ParseRecord($metaData);
ParseRow($datas);

print Dumper $metaData;
print Dumper $datas;

print "\n²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²²\n\n\n";

exit;

### Functions: ###

sub PrintRow() {
	my $dataref = shift;
	my $type = shift;
	foreach my $r (@{$dataref}) {
		foreach my $d ( split(/,/,$r->{$type}) ) {
			$d =~ /(\D{2})(.*)/;
			print $1.": ".$2."\t";
		}
		print "\n";
	}
	print "\n";
}

sub ParseRecord() {
	my $r = shift;
	foreach my $type ( keys %$r ) {
		my $oneData={};
		foreach my $d ( split(/,/,$r->{$type}) ) {
			if ( $d =~ /(\w+)=(\w*)/ ) {
			$oneData->{$1}=$2;
			} elsif ( $d =~ /(Not Active)/ ) {
			$oneData->{$1}=$2;
			} elsif ( $d =~ /(\D{2})(.*)/ ){
			$oneData->{$1}=$2;
			} else {
			print "\n\nEZMIEZ???\n\n";
			}
		}
		$r->{$type}=$oneData;
	}
}

sub ParseRow() {
	my $dataref = shift;
	foreach my $r (@{$dataref}) {
		&ParseRecord($r);
	}
}

#foreach(@sor){
#  /(\D{2})(.*)/;
#  if($1 eq $tipus){ next; }
#  $oneData->{$tipus}->{$1}=$2;
#}
#  push @$adatok,$oneData;

# %hash = (key => "Hello");
# $hash{key} = $val;	
# %third = (%first, %second)
# delete $hash{$key}; # This is safe
# @first{keys %second} = values %second
# $hash -> {key} = $val;
