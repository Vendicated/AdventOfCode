#!/usr/bin/perl

use warnings;
use strict;

sub run {
  my $file = $_[0];
  my $isPart2 = $_[1];

  open(my $FH, "<", "$file") or die "$file: $!";

  my @stack = ();

  while (<$FH>) {
    my $i = 0;
    while (/( {3}|\[(\w)\])( |$)/g) {
      if ($1 ne "   ") {
        if (not defined $stack[$i]) {
          my @stackList = ();
          push @{ $stack[$i] }, @stackList
        }
        push @{ $stack[$i] }, $2;
      }
      $i++
    }

    if (my ($count, $origin, $destination) = /move (\d+) from (\d+) to (\d+)/) {
      if ($isPart2) {
        my @elements = splice @{ $stack[$origin - 1] }, 0, $count + 0;
        splice @{ $stack[$destination - 1] }, 0, 0, @elements;
      } else {
        for (my $i = 0; $i < $count; $i++) {
          my $v = shift @{ $stack[$origin - 1] };
          unshift @{ $stack[$destination - 1] }, $v;
        }
      }
    }
  }

  print "$file\n";
  foreach my $row (@stack) {
    print @{ $row }[0];
  }
  print "\n";
  
  close($FH);
}

foreach my $file (@ARGV) {
  run $file, 0;
  run $file, 1;
}
