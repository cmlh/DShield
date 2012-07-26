#!/usr/bin/env perl
# The above shebang is for "perlbrew", otherwise use /usr/bin/perl or the file path quoted for "which perl"
#
# Please refer to the Plain Old Documentation (POD) at the end of this Perl Script for further information

use strict;

# use warnings;
use Carp;
use Pod::Usage;
use XML::Simple;
use WWW::Mechanize;
use Getopt::Long;
use Data::Dumper;

# #CONFIGURATION Remove "#" for Smart::Comments
# use Smart::Comments;

my $VERSION = "0.0.1"; # May be required to upload script to CPAN i.e. http://www.cpan.org/scripts/submitting.html

# Command line arguements

my $ipaddr;

# Command line meta-options
my $usage;
my $man;
my $update;

# TODO Display -usage if command line argument(s) are incorrect
GetOptions(
    "ip=s" => \$ipaddr,

# Command line meta-options
# -version is excluded as it is printed prior to processing the command line arguments
# TODO -verbose
    "usage"  => \$usage,
    "man"    => \$man,
    "update" => \$update
);

if ( ( $usage eq 1 ) or ( $man eq 1 ) ) {
    pod2usage( -verbose => 2 );
    die();
}

if ( $update eq 1 ) {
    print
"Please execute \"git fetch origin :remotes/origin/master\" from the command line\n";
    exit();
}

print "\n\"DShield\" Alpha v$VERSION\n";
print "\n";
print "Copyright 2012 Christian Heinrich\n";
print "Licensed under the Apache License, Version 2.0\n\n";

chomp($ipaddr);

# Create a new dshield JSON request
my $dshield_ip_xml_url = "http://dshield.org/api/ip/$ipaddr?xml";

# "###" is for Smart::Comments CPAN Module
### \$dshield_ip_xml_url is: $dshield_ip_xml_url

# TODO Replace WWW::Mechanize with HTTP::Tiny CPAN Module
# TODO Replace WWW::Mechanize with libwhisker
# TODO Replace WWW::Mechanize with LWP::UserAgent
my $http_request = WWW::Mechanize->new;

# TODO Availability of $dshield_ip_xml_url i.e. is "up" and resulting HTTP Status Code
my $http_response_ref =
  $http_request->get("$dshield_ip_xml_url")->decoded_content;
my $http_response = $http_response_ref;

my $xml_parser  = new XML::Simple;
my $dshield_xml = $xml_parser->XMLin($http_response);
print "Network:       $dshield_xml->{network}\n";
print "Geolocation:   $dshield_xml->{country}\n";
print "AS Name:       $dshield_xml->{asname}\n";

# Need to remove one space char due to the escape of \@
print "abuse\@domain:   $dshield_xml->{abusecontact}\n";
print "\n\n";

# #CONFIGURATION
# print Dumper($dshield_xml);
# print "\n\n";

=head1 NAME

dshield.pl - "DShield"

=head1 VERSION

This documentation refers to DShield $VERSION

=head1 CONFIGURATION

Set the value(s) marked as #CONFIGURATION above this POD
    
=head1 USAGE

dshield.pl -ip [IP Address]

=head1 REQUIRED ARGUEMENTS

-ip IPv4 Address
                
=head1 OPTIONAL ARGUEMENTS

-man       Displays POD and exits.
-usage     Displays POD and exits.
-update    Displays the command line to retrieve the latest "stable" release

=head1 DESCRIPTION

"DShield" leverages the http://dshield.org/api/ to display the Network, Geolocation, AS Name and Abuse Contact.

=head1 DEPENDENCIES

=head1 PREREQUISITES

Simple::XML CPAN Module
WWW::Mechanize CPAN Module

=head1 COREQUISITES

=head1 INSTALLATION

=head1 OSNAMES

osx

=head1 SCRIPT CATEGORIES

Web

=head1 INCOMPATIBILITIES

=head1 BUGS AND LIMITATIONS

Please refer to the comments beginning with "TODO" in the Perl Code.

=head1 AUTHOR

Christian Heinrich

=head1 CONTACT INFORMATION

http://cmlh.id.au/contact

=head1 MAILING LIST

=head1 REPOSITORY

http://github.com/cmlh/dshield

=head1 FURTHER INFORMATION AND UPDATES

http://del.icio.us/cmlh/dshield

=head1 LICENSE AND COPYRIGHT

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License. 

Copyright 2012 Christian Heinrich
