#!/usr/bin/perl -W

use v5.24;

use List::MoreUtils qw(first_index);

my @password = split(//, "abcdefgh");

sub swap {
  my ($i, $j) = @_;
  my $tmp = $password[$i];
  $password[$i] = $password[$j];
  $password[$j] = $tmp;
}

sub rotate {
  my ($direction, $steps) = @_;
  while ($steps > 0) {
    if ($1 eq "left") {
      push @password, (shift @password);
    } else {
      unshift @password, (pop @password);
    }
    $steps--;
  }
}

sub reverse_positions {
  my ($first, $last) = @_;
  while ($first < $last) {
    swap $first, $last;
    $first++;
    $last--;
  }
}

sub move {
  my ($from, $to) = @_;
  my @char = splice @password, $from, 1;
  splice @password, $to, 0, @char
}

foreach my $line (<STDIN>) {
  chomp($line);
  if ($line =~ /swap position (\d+) with position (\d+)/) {
    swap $1, $2;
  } elsif ($line =~ /swap letter (.) with letter (.)/) {
    my $i = first_index {$_ eq $1} @password;
    my $j = first_index {$_ eq $2} @password;
    swap $i, $j;
  } elsif ($line =~ /rotate (left|right) (\d+) steps?/) {
    rotate $1, $2;
  } elsif ($line =~ /rotate based on position of letter (.)/) {
    my $steps = first_index {$_ eq $1} @password;
    $steps++ if $steps >= 4;
    $steps++;
    rotate "right", $steps;
  } elsif ($line =~ /reverse positions (\d+) through (\d+)/) {
    reverse_positions $1, $2;
  } elsif ($line =~ /move position (\d+) to position (\d+)/) {
    move $1, $2;
  } else {
    say "Error: unknown line $line"
  }
}

say join('', @password)
