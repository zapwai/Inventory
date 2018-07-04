#!/usr/bin/perl
package Inv;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(insert_record create_db update_record remove_record load_db);

sub load_db{
    my $driver = "SQLite";
    my $db_name = "inventory.db";
    my $dbd = "DBI:$driver:dbname=$db_name";

    my $username = "";
    my $password = "";

    # The connection
    our $dbh = DBI->connect($dbd, $username, $password, { RaiseError => 1 })
	or die $DBI::errstr;

    print STDERR "Database opened successfully.\n";
}

sub create_db{
    my $stmt = qq(CREATE TABLE IF NOT EXISTS ITEMS
(ID INTEGER PRIMARY KEY AUTOINCREMENT,
TITLE CHAR(50) NOT NULL,
QUANTITY INT NOT NULL,
LOCATION CHAR(50)););

    my $ret = $dbh -> do($stmt);
    if ($ret < 0) {
	print $DBI::errstr;
    } else {
	print "Table created successfully.\n";
    }
}

sub close_db{
    $dbh->disconnect();
}

sub insert_record{
    my ($title, $quantity, $location) = @_;

    my $stmt = qq(INSERT INTO ITEMS (TITLE, QUANTITY, LOCATION)
VALUES ('$title', $quantity, '$location'));

    $ret = $dbh->do($stmt) or die $DBI::errstr;
}

sub update_record{
    my ($title, $quantity, $location) = @_;
    my $stmt = qq(UPDATE ITEMS SET QUANTITY = $quantity, LOCATION = '$location' where TITLE='$title';);
    $ret = $dbh->do($stmt) or die $DBI::errstr;
    if ($ret < 0) {
	print STDERR $DBI::errstr;
    }
}

sub remove_record{
    my $title = $_[0];
    my $stmt = qq(DELETE from ITEMS where TITLE='$title';);
    $ret = $dbh->do($stmt) or die $DBI::errstr;
    if ($ret < 0) {
	print STDERR $DBI::errstr;
    }
}

sub filter_records{
    my ($title, $location) = @_;
    my $stmt;
    if ($title){
	$stmt = qq(SELECT id, title, quantity, location from ITEMS where TITLE = '$title';);
    }
    if ($title eq "") {
	$stmt = qq(SELECT id, title, quantity, location from ITEMS where LOCATION GLOB '*$location*';);
    }

    my $sth = $dbh -> prepare( $stmt );
    my $rv = $sth -> execute() or die $DBI::errstr;
    if ($rv < 0) {
	print $DBI::errstr;
    }

    while (my @row = $sth->fetchrow_array()) {
	#	print "\n\t\tID = ".$row[0]."\n";
	print "\t\tItem: ".$row[1]."\n";
	print "\t\tQuantity: ".$row[2]."\n";
	print "\t\tLocation: ".$row[3]."\n";
	print "\tThere ";
	if ($row[2] == 1) {
	    print "is ";
	} else {
	    print "are ";
	}
	print $row[2]." ".$row[1]."(s) in the ".$row[3].".\n";
    }
    
}

sub showall_records{
    my $stmt = qq(SELECT id, title, quantity, location from ITEMS;);
    my $sth = $dbh -> prepare( $stmt );
    my $rv = $sth -> execute() or die $DBI::errstr;
    if ($rv < 0) {
	print $DBI::errstr;
    }

    while (my @row = $sth->fetchrow_array()) {
	#	print "\n\t\tID = ".$row[0]."\n";
	print "\t\tItem: ".$row[1]."\n";
	print "\t\tQuantity: ".$row[2]."\n";
	print "\t\tLocation: ".$row[3]."\n";
	print "\tThere ";
	if ($row[2] == 1) {
	    print "is ";
	} else {
	    print "are ";
	}
	print $row[2]." ".$row[1]."(s) in the ".$row[3].".\n";
    }
}

