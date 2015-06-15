#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open my $IN, "< $ARGV[0]";

my @hits;
my @seq;

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
  }
}

hash_seq(@hits,@seq);

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
  foreach my $key (keys %hash) {
    print $key."\t".$hash{$key}."\n";
  }

}

sub long {
  my @lon=@_;
  my $length=@lon;
  return $length;
}
