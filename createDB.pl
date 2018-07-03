#!/usr/bin/perl
## This uses the inputs.txt file to create / sync a database.
use DBI;
use strict;

my $driver = "SQLite";
my $db_name = "inventory.db";
my $dbd = "DBI:$driver:dbname=$db_name";

my $username = "";
my $password = "";

# The connection
my $dbh = DBI->connect($dbd, $username, $password, { RaiseError => 1 })
    or die $DBI::errstr;

print STDERR "Database opened successfully.\n";

# Create table

my $stmt = qq(CREATE TABLE IF NOT EXISTS ITEMS
(ID INTEGER PRIMARY KEY AUTOINCREMENT,
TITLE CHAR(50) NOT NULL,
QUANTITY INT NOT NULL,
LOCATION CHAR(50),
IMAGES CHAR(200)););

my $ret = $dbh -> do($stmt);
if ($ret < 0){
    print $DBI::errstr;
} else {
    print "Table created successfully.\n";
}

# Insert record

$stmt = qq(INSERT INTO ITEMS (TITLE, QUANTITY, LOCATION, IMAGES)
VALUES ('deodorant', 2, 'bathroom closet', ''));

$ret = $dbh->do($stmt) or die $DBI::errstr;



$dbh -> disconnect();
