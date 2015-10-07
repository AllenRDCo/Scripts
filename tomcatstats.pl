#!/usr/bin/perl
#
# Tim Denike 1/4/07 - Please excuse this horriblie sloppy code...
#
# Updated by Paul Allen - paul@inetz.com 10/7/2015
#

use strict;
use XML::Simple;
use LWP::Simple;
use Data::Dumper;

MAIN:
{
    my $host = shift;
    my $username = shift;
    my $password = shift or &usage;
    my $url = "http://$username:$password"."\@$host/manager/status?XML=true";

#    print "Host: ".$host."\n";
#    print "Username: ".$username."\n";
#    print "Password: ".$password."\n";
#    print "URL: ".$url."\n";

    my $xml = get($url);
    die "Couldn't get $url\n" unless defined $xml;

#    print "\nXML: ".$xml."\n\n\n";

    my $status = XMLin($xml);

#    print Dumper($status);

    print "jvm_memory_free:$status->{jvm}->{memory}->{free} ";
    print "jvm_memory_max:$status->{jvm}->{memory}->{max} ";
    print "jvm_memory_total:$status->{jvm}->{memory}->{total} ";
    print "connector_max_time:$status->{connector}->{requestInfo}->{maxTime} ";
    print "connector_error_count:$status->{connector}->{requestInfo}->{errorCount} ";
    print "connector_bytes_sent:$status->{connector}->{requestInfo}->{bytesSent} ";
    print "connector_processing_time:$status->{connector}->{requestInfo}->{processingTime} ";
    print "connector_request_count:$status->{connector}->{requestInfo}->{requestCount} ";
    print "connector_bytes_received:$status->{connector}->{requestInfo}->{bytesReceived} ";
    print "connector_current_thread_count:$status->{connector}->{threadInfo}->{currentThreadCount} ";
    print "connector_min_spare_threads:$status->{connector}->{threadInfo}->{minSpareThreads} ";
    print "connector_max_threads:$status->{connector}->{threadInfo}->{maxThreads} ";
    print "connector_max_spare_threads:$status->{connector}->{threadInfo}->{maxSpareThreads} ";
    print "connector_current_threads_busy:$status->{connector}->{threadInfo}->{currentThreadsBusy} ";
}

sub usage ()
{
   print "$0 [host:port] [username] [password]\n";
   print "   IE:  $0 app1:8081 admin password\n";
   exit 1;
}
