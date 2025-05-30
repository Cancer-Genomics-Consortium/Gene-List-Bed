#!/usr/bin/perl

use File::Basename;
use Getopt::Long;

&GetOptions('UniqGene=s','UCSC=s','header=s');
my $ugene = $opt_UniqGene;
my $ucsc = $opt_UCSC;
my $header = $opt_header; #the value for header is YES (file already has a header) or NO (file does not already have a header. Program will skip fields from the file in tabs, and will output a header only for the annotated section appended to the line, it will not try to header a file for you..)
#my ($chr1,$pos1,$chr2,$pos2) = split(",",$numbers);

open(UGENE,"<$ugene") or die "can't open file $ugene!!!!\n\n";
open(UCSC,"<$ucsc") or die "can't open file $ucsc!!!!\n\n";  

#if ($header =~ /YES/){
#  @filelines = `sed 1d $ucsc`;
#}elsif ($header =~ /NO/) {
#  @filelines = `cat $ucsc`;
#}

@uniqg = `cat $ugene`;

foreach my $gene (@uniqg){
  chomp $gene;
  $tranjoin = "";
  $schr = "";
  $sname = "";
  $sdir = "";
  @starts = ();
  @stops = ();
  @trans = ();
#  print "THIS IS A GENE $gene\n";
  @holder = ();
  @holder = `grep -w $gene $ucsc`;
  #print "$gene\n";
  foreach my $item (@holder){
    chomp $item;
    my ($tran, $chr, $dir, $start, $stop, $name) = $item =~ /(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)\t(\S+)/;
    $sdir = $dir;
    $schr = $chr;
    $tranjoin .= "$tran/";
    $sname = $name; 
    push (@starts,$start);
    push (@stops,$stop);
    push (@trans,$tran); 
 #   print "$item\n";
    #print "Tran: $tran\n";
    #print "CHR: $chr\n";
    #print "DIR: $dir \n";
    #print "START $start \n";
    #print "STOP $stop \n";
    #print "NAME $name\n";
  }

  @sstarts = sort {$a <=> $b} @starts;
  @stops = sort {$a <=> $b} @stops;

  $low = shift (@sstarts);
  $high = pop (@stops);
  print "$tranjoin\t$schr\t$sdir\t$low\t$high\t$sname\n";
  #LOW $low HIGH $high\n";
}
  #foreach $thing (@starts){
  #  print "$thing\t";
  #}
  #print "\n";
  #foreach $thing2 (@stops){
  #  print "$thing2\t";
  #}
  #print "\n";
  #foreach $thing3  (@trans){
  #  print "$thing3\n";
  #}
  #print "\n";