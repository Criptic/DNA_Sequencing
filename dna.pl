#!/usr/bin/perl
print "\n";
$DNA = "GACTAACGCATGGCTACTTGGGATATCCCCTAAGTTAATTGTTGATGCGCATGACGTAGTTGAGGTAAGTACTTT";
print "\n5'-$DNA-3'";

#Laenge der Sequenz
print "\n\nDie laenge der Nucleinsaeresequenz betraegt:   " ;
print length ($DNA) ;
print "     bp \n\n";

#Start-Codon in RNA markieren
$DNA=~(s/ATG/---START---/);
@sequence =  split(/---START---/,$DNA);

for $c (0..length(@sequence[1])-1) {
        if(($c % 3) eq 0){
                $pack3 = substr(@sequence[1],$c-3,3);
                if($pack3 eq "TAA") {
                        $first = substr @sequence[1], 0, $c -3;
                        $second = substr @sequence[1], $c, length(@sequence[1])-1;
                        $komplett = "$first---STOP---$second";
                        last;
                }
                elsif($pack3 eq "TAG") {
                        $first = substr @sequence[1], 0, $c -3;
                        $second = substr @sequence[1], $c, length(@sequence[1])-1;
                        $komplett = "$first---STOP---$second";
                        last;
                }
                elsif($pack3 eq "TGA") {
                        $first = substr @sequence[1], 0, $c -3;
                        $second = substr @sequence[1] , $c, length(@sequence[1])-1;
                        $komplett = "$first---STOP---$second";
                        last;
                }
        }
}
print"\n\n\n\n\nIm Folgenden wurde die mRNA herausgeschnitten :\n\n\n";
@mRNA = split(/---STOP---/, $komplett);
print "5'-@mRNA[0]-3'\n\n";

#Laenge der Sequenz
print "\n\nDie laenge der mRNA-Sequenz betraegt:   " ;
print length(@mRNA[0]) ;
print "    bp \n\n";

(%Codons)=
( TTT => "F", TTC => "F", TTA => "L", TTG => "L",
  TCT => "S", TCC => "S", TCA => "S", TCG => "S",
  TAT => "Y", TAC => "Y", TGT => "C", TGC => "C",
  TGG => "W", CTT => "L", CTC => "L", CTA => "L",
  CTG => "L", CCT => "P", CCC => "P", CCA => "P",
  CCG => "P", CAT => "H", CAC => "H", CAA => "Q",
  CAG => "Q", CGT => "R", CGC => "R", CGA => "R",
  CGG => "R", ATT => "I", ATC => "I", ATA => "I",
  ATG => "M", ACT => "T", ACC => "T", ACA => "T",
  ACG => "T", AAT => "N", AAC => "N", AAA => "K",
  AAG => "K", AGT => "S", AGC => "S", AGA => "R",
  AGG => "R", GTT => "V", GTC => "V", GTA => "V",
  GTG => "V", GCT => "A", GCC => "A", GCA => "A",
  GCG => "A", GAT => "D", GAC => "D", GAA => "E",
  GAG => "E", GGT => "G", GGC => "G", GGA => "G",
  GGG => "G", TAA => "STOP",
  TAG => "STOP",
  TGA => "STOP",
);

$Protein='';
$codon;
for $j(0..length(@mRNA[0])-1) {
  if(($j % 3) eq 0){
      $codon = substr(@mRNA[0],$j,3);
      $codon =~(s/$codon/$Codons{$codon}/);
      $Protein = "$Protein$codon";
  }
}

print "\n\n\n\nDies ist die Proteinsequenz : \n\n\n";
print "  N-Terlinal-    - $Protein -    -C-Terminal\n\n\n";
print "\n\nDie Laenge der Protein-Sequenz betraegt:   " ;
print length($Protein) ;
print "    AS \n\n";

#Palindromsequenzen heraussuchen
print "\n\n\nFolgende Restriktionsschnittstellen liegen in der Nukleinsaeresequenz fuer : \n\n\n\n ";
  @restri = [];
  $count = 0;
  for  $i (0..length($DNA)-1) {
        if($i < 6){
        next;
        }else{
                $pack6 = substr $DNA, $i-6, 6;
                $first = substr($pack6,0,3);
                $second = substr($pack6,3,3);
                $aaa = reverse $second;
               ($aaa =~tr/ATCG/TAGC/);

                if($first eq $aaa){
                        push(@restri, $i);
                        print "\n";
                        print $count;
                        print " $first";
                        print $second;
                        print"\n\n\n";
                        $count += 1;
                }
        }
}
print "Waehlen Sie eine Nummer eines Restriktionsenzyms aus mit dem Sie die Ausgangssequenz schneiden wollen. " ;
$DNA=~(s/---START---/ATG/);
$number = <STDIN>;
$RE = @restri[$number+1];
print $RE;
$splice1 = substr $DNA, 0, $RE-3;
$splice2 = substr $DNA, $RE-3, length($DNA)-1;
print"\n\n\n\n\n Erster Teil nach Splittung : \n\n\n";
print $splice1;
print "\n\n\n\n Zweiter Teil nach Splittung : \n\n\n";
print $splice2;
print "\n";
exit ;
