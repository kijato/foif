#BEGIN{push @INC, '.';}
use lib '.';
use foif;
#use strict;
use locale;
use Data::Dumper;

print "¤\n";
my $job = foif->New($ARGV[0]);
print "¤\n";
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
	  print Dumper $job->{'fajlnev'};
	  $job->Init();
	  print Dumper $job->{'metaData'};
	  print Dumper $job->{'datas'};
  print "×\n";
  #}
#}
