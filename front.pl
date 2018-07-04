#!/usr/bin/perl

use DBI;
use strict;
use warnings;
use Inv;

Inv::load_db();
Inv::create_db();

my $print_out = qq(\nPlease select an option: \n a\) add record\n d\) delete record \n e\) edit record\n s\) select records \n q\) quit\n);

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
	Inv::fetch_record();
    } elsif ($char eq "d"){
	Inv::remove_record();
    } elsif ($char eq "e"){
	Inv::update_record();
    }
    
    print $print_out;
    chomp($char = <STDIN>);
}

Inv::close_db();
