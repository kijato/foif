package foif;

# use strict;
use locale; # Ez kell az ABC szerinti helyes rendezéshez.
# use Data::Dumper;

sub New {
	my $type = shift;
	my $self = {
		'fajlnev'=>shift,
		'metaData'=>{},
		'datas'=>[]
	};
	bless $self, $type;
	return $self;
}

sub Init() {

	my ($self) = @_;
	my $oneData={};
	my $antenna="";
	
	open FH,$self->{'fajlnev'}||die"$!\n";
	while(<FH>) {
		
		chomp;
	
		if ( /^--(FOIF FieldGenius.*)$/ ) {
			$metaData->{'THE FIRST LINE'}=$1;
		}
		
		if ( /^--(Instrument Selected):\s*(.*)$/ or
			 /^(JB|MO|CS|VA),(.*)$/ )
		{
		  $self->{'metaData'}->{$1}=$2;
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
			push @{ $self->{'datas'} },$oneData;
			$oneData={};
		}
	
	}
	close FH;	
		
	ParseRecord($self->{'metaData'});
	ParseRow($self->{'datas'});
	
	# return ( $self->{'metaData'}, $self->{'datas'} );
	return ( $self->{'metaData'} );
	
}


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


#
# Telefonkönyv (minat)
#

sub New_old {
	my $type = shift;
	my $self = {};
	bless $self, $type;
	my $status = $self->Init( @_ );
	print "$status\n", return ""  if $status;
	return $self;
}

sub Init_old() {
	my ($self, $file) = @_;
	my ($name, $number);
	open(BOOK, $file) or return "Init() failed: can not open $file\n";
	while( <BOOK> ) {
		chop;
		($name, $number) = split /\t/;
		$self->AddEntry($name, $number);
	}
	close BOOK;
	return "";
}

sub AddEntry() {
	my ($self, $name, $number) = @_;
	if($self{$name}) {
		push @{$self{$name}}, $number;
	} else {
		$self{$name} = [ $number ];
	}
}

sub LookupByName {
	my ($self, $name) = @_;
	return $self{$name};
}

1;
