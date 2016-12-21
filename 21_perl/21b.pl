#!/usr/bin/perl

use v5.24;
use strict;
use warnings;
use List::MoreUtils qw(first_index);

my @password = split(//, "fbgdceah");

sub swap {
  my ($i, $j) = @_;
  my $tmp = $password[$i];
  $password[$i] = $password[$j];
  $password[$j] = $tmp;
}

sub rotate {
  my ($direction, $steps) = @_;
  while ($steps > 0) {
    if ($direction eq "left") {
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

my @lines = reverse <STDIN>;

foreach my $line (@lines) {
  chomp($line);
  if ($line =~ /swap position (\d+) with position (\d+)/) {
    swap $1, $2;
  } elsif ($line =~ /swap letter (.) with letter (.)/) {
    my $i = first_index {$_ eq $1} @password;
    my $j = first_index {$_ eq $2} @password;
    swap $i, $j;
  } elsif ($line =~ /rotate (left|right) (\d+) steps?/) {
    my $direction = $1 eq "left" ? "right" : "left";
    rotate $direction, $2;
  } elsif ($line =~ /rotate based on position of letter (.)/) {
    my $pos = first_index {$_ eq $1} @password;
    my $steps;
    if ($pos == 0) {
      $steps = 9;
    } elsif ($pos % 2 == 0) {
      $steps = 5 + $pos / 2;
    } else {
      $steps = ($pos + 1) / 2;
    }
    rotate "left", $steps;
  } elsif ($line =~ /reverse positions (\d+) through (\d+)/) {
    reverse_positions $1, $2;
  } elsif ($line =~ /move position (\d+) to position (\d+)/) {
    move $2, $1;
  } else {
    say "Error: unknown line $line";
  }
}

say @password
