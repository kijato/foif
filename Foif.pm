package Foif;

# use strict;
# use locale; # Ez kell az ABC szerinti helyes rendezéshez.
# use encoding "LATIN1";
# use encoding "LATIN2";
# use encoding "UTF8";
# use Data::Dumper;

sub New {
	my $type = shift;
	my $self = {
		'filename'=>shift,
		'datas'=>[]
	};
	bless $self, $type;
	$self->Init();
	return $self;
}

sub Init() {

	my ($self) = @_;
	my $software = "";
	my $antenna = "";
	my $oneData = {};

	open FH,$self->{'filename'}||die"$!\n";
	while(<FH>) {
		chomp;

		if ( /^--(FieldGenius.*)$/ ) {
		  $software = '  '.$1;
		}

		if(/^--(Antenna):\s*(.*)$/) {
			$antenna = $2;
		}

		if ( /^--GNSS (Profile Tolerance RT):\s*(.*)$/ or
			 /^--GNSS (Profile Tolerance PP):\s*(.*)$/ or
			 /^--GNSS (Statistics RT):\s*(.*)$/ or
			 /^--GNSS (Statistics PP):\s*(.*)$/ or
			 /^--(PP Time):\s*(.*)$/ or
			 /^(AH|EP|BL|CV|GS),(.*)$/
			 or
			 /^--(Instrument Selected):\s*(.*)$/ or
			 /^(JB|MO|CS|VA),(.*)$/ )
		{
		  $oneData->{$1}=$2;
		}

		if ( /^GS,.*$/ ) {
			$oneData->{'Software'}=$software;
			$oneData->{'Antenna'}=$antenna;
			push @{ $self->{'datas'} },$oneData;
			$oneData={};
		}

	}
	close FH;	
		
	ParseRecord($self->{'metaData'});
	ParseRow($self->{'datas'});

}


##############
# Functions: #
##############

sub ParseRecord() {
	my $r = shift;
	foreach my $type ( keys %$r ) {
		my $oneData={};
		foreach my $d ( split(/,/,$r->{$type}) ) {
			#if ( $d =~ /(\w+)=([\w °'."]*)/ ) {
			if ( $d =~ /(\w+)=(.*)/ ) {
			$oneData->{$1}=$2;
			} elsif ( $d =~ /(Not Active)/ ) {
			$oneData->{$1}=$2;
			} elsif ( $d =~ /(\D{2})(.*)/ ){
			$oneData->{$1}=$2;
			} else {
			print "\n\nUnknown data?\n\n";
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

###########
# Methods #
###########

sub PrintPoints() {
	my $s = shift;
	foreach my $r (@{$s->{'datas'}}) {
			print $r->{'JB'}->{'NM'}.";".
				  $r->{'JB'}->{'DT'}." ".
				  $r->{'JB'}->{'TM'}.";".
				  $r->{'Statistics RT'}->{'RefLon'}.";".
				  $r->{'Statistics RT'}->{'RefLat'}.";".
				  $r->{'Statistics RT'}->{'RefHgt'}.";".
				  $r->{'GS'}->{'PN'}.";".
			      $r->{'GS'}->{'--'}.";".
			      $r->{'GS'}->{'E '}." [".
			      $r->{'EP'}->{'RE'}."];".
			      $r->{'GS'}->{'N '}." [".
			      $r->{'EP'}->{'RN'}."];".
			      $r->{'GS'}->{'EL'}." [".
			      $r->{'EP'}->{'RV'}."];".
			      "\n";
		}
}

sub PrintRow() {
	print my $dataref = shift;
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

1;

__END__

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
