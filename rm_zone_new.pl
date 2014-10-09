#!/usr/bin/perl
# Use to remove specific domains from BIND conf file
# Pass in one domain at a time to the script

use strict;
use warnings;
use Getopt::Std;

my %args=();
getopts('hf:d:l:', \%args);


sub usage() {
    print STDERR << "EOF";

This script is used to remove one or more zone entries from the BIND config files.

Usage: $0 [-f file] [-d domain] [-l domain-list]

    -f    : BIND zone configuration file location
    -d    : Single domain to remove zone for
    -l    : File containing newline seperated list of domains to remove zones for
    -h    : Help (this message)

example: $0 -f /etc/bind/conf/external.conf -d domain.com

EOF
    exit;
}



if (defined $args{h}) {
    &usage;
}
if (! defined $args{f}) {
    print STDERR "No conf file specified\n";
    &usage;
}
elsif (! defined $args{d} && ! defined $args{l}) {
    print STDERR "No domain or list specified\n";
    &usage;
}
elsif (defined $args{d} && defined $args{l}) {
    print STDERR "Must only specify -d <domain> OR -l <domain_list>";
    &usage;
}

unless ( -e $args{f} ) {
    print STDERR "No file found\n";
    exit 1;
}
if (defined $args{l}) {
    unless ( -e $args{l} ) {
        print STDERR "No file found\n";
        exit 1;
    }
}


# Handle domain input from file
if (defined $args{l}) {
    my $filename = "<$args{l}>";
    print $filename;
    open(my $fh, '<:encoding(UTF-8)', $filename)
        or die "Could not open file '$filename' $!";

    while (my $domain = <$fh>) {
        chomp $domain;
        open INFILE, "<$args{f}";
        open OUTFILE, ">$args{f}.mod";
        while(<INFILE>) {
            if(/zone "$args{d}"/) {
                    print "Removing $args{d}\n";
                while(<INFILE>) {
                    if(/^};/) {
                        print "Done with zone removal\n";
                        last;
                    }
                }
            } else {
                print OUTFILE;
            }
        }
        close INFILE;
        close OUTFILE;
        rename("$args{f}.mod", "$args{f}");
    }
    print "All done!\n";
}
# Handle domain input from stdin
elsif (defined $args{d}) {
    open INFILE, "<$args{f}";
    open OUTFILE, ">$args{f}.mod";
    while(<INFILE>) {
        if(/zone "$args{d}"/) {
                print "Removing $args{d}\n";
            while(<INFILE>) {
                if(/^};/) {
                    print "Done with zone removal\n";
                    last;
                }
            }
        } else {
            print OUTFILE;
        }
    }
    close INFILE;
    close OUTFILE;
    rename("$args{f}.mod", "$args{f}");
    print "All done!\n";
}
