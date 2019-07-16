## nofilter(TidyAll::Plugin::OTRS::Perl::Time)

package Kernel::System::Log::Screen;

use strict;
use warnings;

use Term::ANSIColor;

our @ObjectDependencies = ();

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {};
    bless( $Self, $Type );

    # colorize output
    $Self->{Colorize} ||= -t STDOUT ? 1 : 0;

    # Enable autoflush, otherwise color will not be reset properly.
    # More see https://rt.cpan.org/Public/Bug/Display.html?id=121974
    if ( $Self->{Colorize} ) {
        $|++;
    }

    # default colors
    $Self->{Color} = {
        info    => 'bold white',
        notice  => 'bold cyan',
        error   => 'bold red',
    };
    
    return $Self;
}

sub Log {
    my ( $Self, %Param ) = @_;

    my $Color = $Self->{Color}{ $Param{Priority} };
    if ( $Self->{Colorize} && $Color ) {
        print color($Color);
    }

    print '[' . localtime() . ']';    ## no critic

    if ( lc $Param{Priority} eq 'debug' ) {
        print "[Debug][$Param{Module}][$Param{Line}] $Param{Message}\n";
    }
    elsif ( lc $Param{Priority} eq 'info' ) {
        print "[Info][$Param{Module}] $Param{Message}\n";
    }
    elsif ( lc $Param{Priority} eq 'notice' ) {
        print "[Notice][$Param{Module}] $Param{Message}\n";
    }
    elsif ( lc $Param{Priority} eq 'error' ) {
        print "[Error][$Param{Module}][$Param{Line}] $Param{Message}\n";
    }
    else {
        # print error messages to STDERR
        print STDERR
            "[Error][$Param{Module}] Priority: '$Param{Priority}' not defined! Message: $Param{Message}\n";
    }

    if ( $Self->{Colorize} && $Color ) {
        print color('reset');
    }
    
    return 1;
}

1;
