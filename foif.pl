
use lib '.';
use Foif;
use strict;
use locale;
use Data::Dumper;
# https://stackoverflow.com/questions/9688096/perl-hash-datadumper
$Data::Dumper::Indent = 1; # ... makes the output more compact and much more readable when your data structure is several levels deep.
$Data::Dumper::Sortkeys = 1; # ... makes it easier to scan the output and quickly find the keys you are most interested in.
$Data::Dumper::Useqq = 1; # If the data structure contains binary data or embedded tabs/newlines, also consider ... which will output a suitable readable representation for that data.

# http://szit.hu/doku.php?id=oktatas:programoz%C3%A1s:perl:per_objektum_orient%C3%A1ltan

my $job = Foif->New($ARGV[0]);

if( $job ) {
	print STDERR Dumper ( $job->{'filename'}, $job->{'datas'} ) ;
	$job->PrintPoints();
}

#print "\n\nPress <ENTER> to continue!";<STDIN>;

__END__
