#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open my $IN, "< $ARGV[0]";

#CODIGO PARA RESOLVER LOS NUMERALES A Y B DEL PRIMER PUNTO,

my @hit2;
my @hit3;
my @seq;

while (my @file = <$IN>) {
  for (my $var = 0; $var <= $#file; $var++) {
    if ($file[$var] =~ /\|/ and $file[$var] !~ /Query/) {
      my @hit = split (/\s/,$file[$var]);
      if ($hit[-1]<=1E-6) {
        push @hit2, $file[$var];
      } else {
        push @hit3, $file[$var];
      }
    }
    for (my $i = 0; $i <= total_hits(@hit2, @hit3) ; $i++) {
      if ($file[$var]=~/^$i/) {
        push @seq, $file[$var];
      }
    }
  }
}

foreach my $x (@seq) {
  my @new_seq = split (/\s/,$x);
  print $new_seq[-2]."\n";
}


print "Hits Significativos:\n";
print $_ foreach (@hit2);

print "\nHits NO Significativos:\n";
print $_ foreach (@hit3);

sub total_hits {
  my (@values) = @_;
  return ($#values);
}
