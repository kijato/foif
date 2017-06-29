#BEGIN{push @INC, '.';}
use lib '.';
use Foif;
#use strict;
#use locale;
use Data::Dumper;
# use Data::Dumper::Perltidy;
# https://stackoverflow.com/questions/9688096/perl-hash-datadumper
$Data::Dumper::Indent = 1; # ... makes the output more compact and much more readable when your data structure is several levels deep.
$Data::Dumper::Sortkeys = 1; # ... makes it easier to scan the output and quickly find the keys you are most interested in.
$Data::Dumper::Useqq = 1; # If the data structure contains binary data or embedded tabs/newlines, also consider ... which will output a suitable readable representation for that data.

# http://szit.hu/doku.php?id=oktatas:programoz%C3%A1s:perl:per_objektum_orient%C3%A1ltan
print "¤\n";
my $job = Foif->New($ARGV[0]);

#if( $job ) {
	#while(1) {
		#print "\nName: ";
		#$name = <STDIN>;
		#chop($name);
		#exit if $name eq "";
		#$Aref = $job->LookupByName( $name );
		#if( $Aref ) {
		#	foreach $number ( @{$Aref} ) { 
		#		print "$name  $number\n"; 
		#	}
		#} else {
		#	print "$name not found\n";
		#}
  print "×\n";
	print Dumper ( $job->{'fajlnev'}, $job->{'datas'} ) ;
  print "×\n";
	# $job->PrintRow($job->{'datas'},'BL');
	$job->PrintPoints();

  #}
#}
print "¤\n";
#print "\n\nPress <ENTER> to continue!";<STDIN>;
