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

sub close_db{
    $dbh->disconnect();
}

sub insert_record{
    my ($title, $quantity, $location) = @_;

    my $stmt = qq(INSERT INTO ITEMS (TITLE, QUANTITY, LOCATION)
VALUES ('$title', $quantity, '$location'));

    $ret = $dbh->do($stmt) or die $DBI::errstr;
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

sub update_record{
    my $stmt = qq(UPDATE ITEMS set QUANTITY = 10 where TITLE='beer';);
    $ret = $dbh->do($stmt) or die $DBI::errstr;
    if ($ret < 0) {
	print STDERR $DBI::errstr;
    }
    
}

sub remove_record{
    my $stmt = qq(DELETE from ITEMS where TITLE='chair';);
    $ret = $dbh->do($stmt) or die $DBI::errstr;
    if ($ret < 0) {
	print STDERR $DBI::errstr;
    }
}

sub fetch_record{
    my $stmt = qq(SELECT id, title, quantity, location from ITEMS;);
    my $sth = $dbh -> prepare( $stmt );
    my $rv = $sth -> execute() or die $DBI::errstr;
    if ($rv < 0){
	print $DBI::errstr;
    }

    while (my @row = $sth->fetchrow_array()) {
	print "\nID = ".$row[0]."\n";
	print "Item = ".$row[1]."\n";
	print "Quantity = ".$row[2]."\n";
	print "Location is ".$row[3]."\n";
	print "There ";
	if ($row[2] == 1) { print "is " }
	else {print "are "}
	print $row[2]." ".$row[1]."(s) in the ".$row[3].".\n";
    }
}
