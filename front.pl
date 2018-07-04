#!/usr/bin/perl

use DBI;
use strict;
use warnings;
use Inv;

Inv::load_db();
Inv::create_db();

my $print_out = qq(\nPlease enter a key to select an option: \n \(a\)dd record, \(d\)elete record, \(e\)dit record, \(f\)ilter to see *some* records, \(s\)how all records, \(q\)uit\n);

my $char="";
while ($char ne "q"){
    if ($char eq "a"){
	print "Please enter the following information (separating multiple answers with commas if necessary):\n";
	print "Name of item in inventory: ";
	chomp (my $title = <STDIN>);
	print "Quantity of item: ";
	chomp (my $quantity = <STDIN>);
	print "Location of item: ";
	chomp (my $location = <STDIN>);
	Inv::insert_record($title, $quantity, $location);
    } elsif ($char eq "s"){
	Inv::showall_records();
    } elsif ($char eq "f"){
	print "Leave blank to ignore a field.\n";
	print "Name of item: ";
 	chomp (my $title = <STDIN>);
	if (length $title == 0) {$title = ""};
	print "Location of items: ";
	chomp (my $location = <STDIN>);
	if (length $location == 0) {$location = ""};
	Inv::filter_records($title, $location);
    }

    elsif ($char eq "d"){
	print "Name of item to be removed: ";
	chomp (my $title = <STDIN>);
	Inv::remove_record($title);
    } elsif ($char eq "e"){
	print "Name of item to be updated: ";
	chomp (my $title = <STDIN>);
 	print "Quantity of item: ";
	chomp (my $quantity = <STDIN>);
	$quantity = 0 if ( length $quantity == 0 );
	print "Location of item: ";
	chomp (my $location = <STDIN>);	
	Inv::update_record($title, $quantity, $location);
    } 
    
    print $print_out;
    chomp($char = <STDIN>);
}

Inv::close_db();
