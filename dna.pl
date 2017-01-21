#!/usr/bin/perl


print "Welche Datei wollen Sie oeffnen ? Geben Sie den Dateinamen ein! \n\n "  ;

$DNA = <STDIN>  ;
chomp   $DNA ;
open (FILE, $DNA) ;
@DNA = <FILE> ;
shift@DNA;
$DNA = join('',@DNA);
print "\n\n5'-$DNA-3'";

#Laenge der Sequenz

print "\n\nDie laenge der Nucleinsaeresequenz betraegt:   " ;
print (length($DNA)-4) ;
print "     bp \n\n";

#Start-Codon in RNA markieren

$Start_Codon =($DNA=~(s/ATG/---START---/));
@sequence =  split(/---START---/, $DNA);

$findStop = @sequence[1];
for $c (0..length($findStop)-1) {
        if(($i % 3) == 0){
                $block3 = substr($findStop,$c-3,3);
                if($block3 eq "TAA") {
                        $first = substr $findStop, 0, $c -3;
                        $second = substr $findStop, $c, length($findStop)-1;
                        $complete = "$first---STOP---$second";
                        @sequence[1] = $complete;
                        print "$complete\n";
                        last;
                }
                elsif($block3 eq "TAG") {
                        $first = substr $findStop, 0, $c -3;
                        $second = substr $findStop, $c, length($findStop)-1;
                        $complete = "$first---STOP---$second";
                        @sequence[1] = $complete;
                        print "$complete\n";
                        last;
                }
                elsif($block3 eq "TGA") {
                        $first = substr $findStop, 0, $c -3;
                        $second = substr $findStop , $c, length($findStop)-1;
                        $complete = "$first---STOP---$second";
                        @sequence[1] = $complete;
                        print "$complete\n";
                        last;
                }
        }
}

print"\n\n\n\n\nIm Folgenden wurde die mRNA herausgeschnitten :\n\n\n";
@sequence1 = split(/---STOP---/, @sequence[1]);
print "5'-@sequence1[0]-3'\n\n";

#Laenge der Sequenz

print "\n\nDie laenge der mRNA-Sequenz betraegt:   " ;
print (length(@sequence1[0])-4) ;
print "    bp \n\n";


%Codons =(
TTT => "F", TTC => "F", TTA => "L", TTG => "L",
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

$Protein = @sequence1[0];
for $keys (keys %Codons) {
        $Protein =~(s/$keys/$Codons{$keys}/g);
}
print "\n\n\n\n Dies ist die Proteinsequenz : \n\n\n";
print "N-Terlinal---$Protein---C-Terminal\n\n\n";

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
                $current = substr $DNA, $i-6, 6;
                $first = substr($current,0,3);
                $second = substr($current,3,3);
                $aaa = reverse $second;
                ($aaa =~tr/ATCG/TAGC/);

                if($first eq $aaa){
                        print $i;
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


#mit einem ausgewaehlten RE die Sequenz schneiden

print "Waehlen Sie eine Nummer eines Restriktionsenzyms aus mit dem Sie die Ausgangssequenz schneiden wollen. " ;
$number = <STDIN>;
$sub = @restri[$number + 1];
print $sub;
$splice1 = substr $DNA, 0, $sub-3;
$splice2 = substr $DNA, $sub-3, length($DNA)-1;
print"\n\n\n\n\n Erster Teil nach splittung : \n\n\n";
print $splice1;
print "\n\n\n\n Zweiter Teil nach splittung : \n\n\n";
print $splice2;
print "\n";

exit ;
