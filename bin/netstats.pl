#!/usr/bin/env perl

use strict;
use warnings;

use Time::HiRes qw(usleep nanosleep time);
use POSIX qw(strftime);
use Data::Dumper;
use IO::Handle;

sub sample {
  my $f = "/proc/net/snmp";
  open(my $fh,'<',$f) or die "Could not open $f : $!";
  my @lines = <$fh>;
  close $fh; 
  my $first = 1;
  my $type = undef;
  my @keys;
  my @vals;
  my $sample = {};
  my $samples = {};
  foreach my $line (@lines) {
    chomp $line;
    if ($line =~ m/([^:]+)/) {
      $type = $1;
      if ($first) {
        @keys = split ('\s',$line);
        $first = 0;
      } else {
        @vals = split ('\s',$line);
        for (my $i = 1 ; $i < scalar @keys; $i++) {
          $sample->{$keys[$i]} = $vals[$i];
        }
        $samples->{$type} = $sample;
        $first = 1;
        $type = undef;
        $sample = {}
      }
    }
  }
  return $samples;
}
    
my $first = sample();

my $keys = {};
foreach my $t ("Ip","Udp") {
  my @s = sort keys %{$first->{$t}};
  $keys->{$t} = \@s;
}

my @headers = ("timestamp");
foreach my $t ("Ip","Udp") {
  foreach my $k (@{$keys->{$t}}) {
    push @headers, "$t:$k";
  }
}
my $header = join("\t",@headers)."\n";
my $prefix = "netstats";
my $count = 0;
my $sample_interval_millis = 100;
my $rotate_interval = int (10*60*1000 / $sample_interval_millis);
my $log = open_log();

while (1) {
  usleep 1000*$sample_interval_millis;
  my $second = sample();

  my $t = time;
  my $date = strftime "%Y/%m/%d-%H:%M:%S", localtime $t;
  $date .= sprintf ".%03d", ($t-int($t))*1000;

  my @vals;
  foreach my $t ("Ip","Udp") {
    foreach my $k (@{$keys->{$t}}) {
      push @vals, ($second->{$t}{$k} - $first->{$t}{$k});
    }
  }
  my $out = $date."\t".join("\t",@vals)."\n";
  $log = print_to_log ($log, $out);
  $first = $second;
}

sub open_log {
  $count = 0;
  open (my $fh, ">", "$prefix.log") or die "can't open file : $!";
  $fh->autoflush;
  print $fh $header;
  return $fh;
}

sub print_to_log {
  my ($fh, $line) = @_;
  $count++;
  print $fh $line;
  if ($count >= $rotate_interval) {
    close_log ($fh);
    $fh = open_log ();
  }
  return $fh;
}

sub close_log {
  my ($fh) = @_;
  close $fh;
  my $t = time;
  my $date = strftime "%Y%m%d%H%M%S", localtime $t;
  rename "$prefix.log", "$prefix.$date.log";
}
0;
