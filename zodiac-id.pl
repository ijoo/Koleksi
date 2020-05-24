#!/usr/bin/env perl
use strict;
use LWP::Simple;
if ($#ARGV == -1)
{
    print "Usage: perl zodiac-id.pl <sign>";
    exit(-1);
}

my $bintang = $ARGV[0];
my $kapital = uc $bintang;
my $url = 'https://www.fimela.com/zodiak/'.$bintang;
my $ua = LWP::UserAgent->new;
 $ua->timeout(6);
 $ua->env_proxy;

my $response = $ua->get($url);
if ($response->is_success) {
        my ($umum) = $response->decoded_content =~ m{Umum</h5></div><div class="zodiac__readpage__content"><p>(.*?)</p></div></div>}gism;
        #my ($single) = $response->decoded_content =~ m{<p>Single: (.*?)\n}gism;
        my ($couple) = $response->decoded_content =~ m{<br>Couple: (.*?)</p>}gism;
        my ($karir) = $response->decoded_content =~ m{Keuangan</h5></div><div class="zodiac__readpage__content"><p>(.*?)</p></div>}gism;
        print "[$kapital] ";
        $umum =~ tr/a-zA-Z, //dc;
        print "UMUM: $umum - ";
        $couple =~ tr/a-zA-Z, //dc;
        print "Asmara: $couple - ";
        $karir =~ tr/a-zA-Z, //dc;
        print "Keuangan: $karir \n";
}
 else {
     print "ERROR!! Bintang yang diminta tidak ada atau koneksi terputus.. \n";
 }
