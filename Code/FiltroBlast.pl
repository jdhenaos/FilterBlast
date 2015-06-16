#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;

open my $IN, "< $ARGV[0]";
open my $OUT1, "> ../Results/SignificativeFilter.out";
open my $OUT2, "> ../Results/StudentPropose.out";

# CODIGO PRINCIPAL.

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

# CODIGO PARA FILTRAR DE ACUERDO A LO REQUERIDO POR EL PARCIAL.

print $OUT1 "Hits Significativos:\n\n";
foreach my $val (@s_hits) {
  print $OUT1 $val."\t".$align{$hits[0]}."\n\t".$align{$val}."\n\n";
}

print $OUT1 "Hits NO Significativos:\n\n";
foreach my $val (@ns_hits) {
  print $OUT1 $val."\t".$align{$hits[0]}."\n\t".$align{$val}."\n\n";
}

# CODIGO PARA FILTRAR SEGUN LO PLANTEADO POR EL ESTUDIANTE.

my @gap;
my @no_gap;

foreach my $key (keys %align) {
  if ($key !~ /Query/) {
    if ($align{$key} =~ /-/) {
      push @gap, $key;
    } else {
      push @no_gap, $key;
    }
  }
}

print $OUT2 "PRIMER FILTRO\n\n";
print $OUT2 "Hits CON Gaps en el alineamiento:\n\n";
foreach my $num (@gap) {
  print $OUT2 $num."\t".$align{$hits[0]}."\n\t".$align{$num}."\n\n";
}

print $OUT2 "Hits SIN Gaps en el alineamiento:\n\n";
foreach my $num (@no_gap) {
  print $OUT2 $num."\t".$align{$hits[0]}."\n\t".$align{$num}."\n\n";
}

my $exclusion = "-" x 10;

my @little;
my @much;

foreach my $each (keys %align) {
  if ($each !~ /Query/) {
    if ($align{$each} =~ $exclusion) {
      push @much, $each;
    } else {
      push @little, $each;
    }
  }
}

print $OUT2 "SEGUNDO FILTRO\n\n";
print $OUT2 "Hits con MAS de 10 gaps consecutivos:\n\n";
foreach my $locate (@much) {
  print $OUT2 $locate."\t".$align{$hits[0]}."\n\t".$align{$locate}."\n\n";
}
print $OUT2 "Hits con MENOS de 10 gaps consecutivos:\n\n";
foreach my $locate (@little) {
  print $OUT2 $locate."\t".$align{$hits[0]}."\n\t".$align{$locate}."\n\n";
}

close $IN;
close $OUT1;

#SUBRUTINAS.

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
