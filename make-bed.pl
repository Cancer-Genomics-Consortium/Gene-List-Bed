#!/usr/bin/perl

while (my $line = <STDIN>){
  chomp $line;
  @entry = split (/\t+/, $line);
  $chr = $entry[10];
  $dir = $entry[11];
  $start = $entry[12];
  $stop = $entry[13];
  $name = $entry[14];
  $name2 = $entry[0]; 
  $sig = $entry[1];
  $sig =~s/ /_/g;
  $cyto = $entry[2];
  $cyto =~s/ /_/g; 
  $sub = $entry[3]; 
  $sub =~s/ /_/g;
  $mol = $entry[4]; 
  $mol =~s/ /_/g;
  $funct = $entry[5]; 
  $funct =~s/ /_/g;
  $germ = $entry[6];
  $germ =~s/ /_/g;
  $pmid = $entry[7]; 
  $pmid =~s/ /_/g;
  $comments = $entry[8]; 
  $comments =~s/ /_/g;
  chomp $comments;
  $trans = $entry[9]; 
  $namej = "$name*$sig*$sub*$mol*$funct";
  print "$chr\t$start\t$stop\t$namej\n";
}
