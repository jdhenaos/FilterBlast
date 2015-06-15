#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open my $IN, "< $ARGV[0]";

my @hits;
my @seq;
my @ns_hits;
my @s_hits;

while (my @file = <$IN>) {
  for (my $var = 0; $var <= $#file; $var++) {
    if ($file[$var] =~ /\|/) {
      push @hits, $file[$var];
    }
    for (my $n = 0; $n <= long(@hits); $n++) {
      if ($file[$var] =~ /^$n/) {
        push @seq, $file[$var];
      }
    }
    if ($file[$var] =~ /\|/ and $file[$var] !~ /Query/) {
      my @info_hit = split (/\s/,$file[$var]);
      my $e_value = $info_hit[-1];
      if ($e_value <= 1E-06) {
        push @s_hits, $file[$var];
      } else {
        push @ns_hits, $file[$var];
      }
    }
  }
}

my %align=hash_seq(@hits,@seq);

print "Hits Significativos:\n\n";
foreach my $val (@s_hits) {
  print $val."\t".$align{$hits[0]}."\n\t".$align{$val}."\n\n";
}

print "Hits NO Significativos:\n\n";
foreach my $val (@ns_hits) {
  print $val."\t".$align{$hits[0]}."\n\t".$align{$val}."\n\n";
}

sub hash_seq {
  my (@init_hash)=@_;
  my $number = @hits;
  my %hash;
  my @new_seq;
  for (my $x = $number; $x <= $#init_hash; $x++) {
    my @div_alig = split (/\s/,$init_hash[$x]);
    push @new_seq, $div_alig[-2];
  }
  for (my $i = 0; $i < $number; $i++) {
    for (my $j = $i; $j < $number; $j+=$number) {
       $hash{$init_hash[$i]}=$new_seq[$j].$new_seq[($j + $number)];
    }
  }
  return %hash;
}

sub long {
  my @lon=@_;
  my $length=@lon;
  return $length;
}
