use strict;
use warnings;
use LWP::UserAgent;

my $ua = LWP::UserAgent->new(ssl_opts => {
    # this disables SNI
    SSL_hostname => '', 
    # These disable certificate verification, so that we get a connection even
    # if the certificate does not match the requested host or is invalid.
    # Do not use in production code !!!
    SSL_verify_mode => 0,
    verify_hostname => 0,
});

# request some data
# my $res = $ua->get('https://example.com');
my $res = $ua->get('https://o365.umusic.skyfencenet.com');

# show headers
# pseudo header Client-SSL-Cert-Subject gives information about the
# peers certificate
print $res->headers_as_string;

# show response including header
# print $res->as_string;
