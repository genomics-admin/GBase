#######################################################################################
# package perl_sessions;                                                               #
#                                                                                       #
# my $Project name = "Identification of promoter sequence v 0.1";                        #
# my @Team=qw/PRAKRUTHI RAJ ANUSUDAN GOWRI SANDEEP/;                                      #
#                                                                                          #
# my %Steps = ('Fetch Sequence from file' => 'Done',                                        #
#         'Find ATG sequence from right to left' => 'Done',                                  #
#         'Fine all possible combinations of TATA box from right to left' => 'Done',          #
#         'Fine all possible combinations of CAT box from right to left' => 'Done',            #
#         'Display all findings' => 'Done');                                                    #
#                                                                                              #
# sub Ideas_for_future_development{                                                           #
#     our $idea1='Get more combinations of TATA box and CAT box';                            #
#     our $idea2='Highlight the region where CAT,TATA and ATG concentrates';                #
#     our $idea2='Create a better UI to make analysis easier';                             #
#                                                                                         #
#                                                                                        #
#                                                                                       #
#                                                                                      #
# };                                                                                  #
######################################################################################


use strict;
use warnings;
use Data::Dumper; 

## declare all the variables
my $hash="";
my $StringForDisplay="";
my $StringForOutput="";
my $Primekey=0;
my $filename="sequence.txt";
my $OutPutfilename="Output.".$filename;

#ATG box sequence
my $find="ATG";
my $counter1=0;

#TATA box sequence
my @find1=qw/TCACTATATATAG
TATTTAA
TATATA
TATAAA
TAAATA
AATAAA
TTTATA
CATAAA
TATTTA
TACATA
TATATC
TATTAA
TATAAG
GATAAA
CTTAAA
TACTTA
TCTTAA
GATAAG/;

#CAT box sequence
my @find2=qw/ACTGTTC
GCTGTTC
GTCAAAAAAT/;

#declare - End

#Code - Start

#pick the string from the file
open(FH1,$filename) or print "not found";
while(my $hashtag=<FH1>){
   chomp $hashtag;
   #print $hashtag;
   $hash=  $hash . $hashtag;
}
#print $hash, "\n\n\n";
print "Length of the sequence : " . length($hash), "\n\n\n";


#Find ATG Sequence
my $findresult1 = find($hash,$find);
#remove the extra trailing ',1' from the string
$findresult1 =~ s/\,1$//;
#print "Sequence: " . $find . " positions:\n" . $findresult1 . "\n\n";



#Find TATA Box sequence;
foreach(@find1){
  my $findresult2 = find($hash,$_);
  #remove the extra trailing ',1' from the string
  $findresult2 =~ s/\,1$//;
  #print "Sequence: " . $_ . " positions: " . $findresult2 . "\n";
};




#Find CAT box sequence;
foreach(@find2){
  my $findresult3 = find($hash,$_);
  #remove the trailing ',1' from the string
  $findresult3 =~ s/\,1$//;
  #print "Sequence: " . $_ . " positions: " . $findresult3 . "\n";
};

#Populate the highlighted structure and print it in the output file 
display();



#---------------Find the region-------------------------------
sub display
{
#print $StringForDisplay;
my %hash;

my @list1 = split /;/, $StringForDisplay;
foreach my $item(@list1) {
  my ($i,$j)= split(/:/, $item);
  $hash{$i} = $j;
}


#print Dumper \%hash;

my @keys = sort { $a <=> $b } keys %hash;
    foreach my $key ( @keys ) {
		#print "\n-\n|\n".($key-$Primekey)."\n|\n-\n";
        #print $key."---" .$hash{$key};
		$StringForOutput=$StringForOutput."\n-\n|\n".($key-$Primekey)."\n|\n-\n".$key."---" .$hash{$key};
		$Primekey=$key;
    }

#print $StringForOutput;
	
# Use the open() function to create the file.
unless(open FILE, '>'.$OutPutfilename) {
	# Die with error message 
	# if we can't open it.
	die "\nUnable to create $OutPutfilename\n";
}

# Write some text to the file.
print FILE "0";
print FILE $StringForOutput;

# close the file.
close FILE;
}
#--------------------------------------------------------------


#--------------Search Engine-----------------------------------
sub find
{
    #confirm the combination sequence available
    if (my @data = $_[0] =~ m/(.*)($_[1])(.*)/isg){
     #concatenate and return a string of locations with the latest found location.
     #also the line below makes a recursive call to the same function.
     $StringForDisplay=$StringForDisplay.$-[2].":".$_[1]. ";";
	 return $_[3]=$-[2] . "," . find($data[0],$data[1]);
    }
    else{print "\n";}
};
#--------------Search Engine-END----------------------------------
#Code - End