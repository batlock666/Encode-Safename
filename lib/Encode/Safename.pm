package Encode::Safename;

use 5.006;
use strict;
use warnings;
use utf8;

use Parse::Lex;

use base qw(Encode::Encoding);

__PACKAGE__->Define(qw(safename));

=head1 NAME

Encode::Safename - The great new Encode::Safename!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Encode::Safename;

    my $foo = Encode::Safename->new();
    ...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 _process LEXER, STRING

Applies LEXER to STRING.  Returns both the processed and unprocessed parts.

For internal use only!

=cut

sub _process {
    # process arguments
    my ($self, $lexer, $string) = @_;

    # initialize the lexer and the processed buffer
    $lexer->from($string);
    my $processed = '';

    while (1) {
        # infinite loop!

        # get the next token
        my $token = $lexer->next;

        if ($lexer->eoi || (! $token)) {
            # no more tokens; jump out of the loop
            last;
        }
        else {
            # add the token's text to the processed buffer
            $processed .= $token->text;
        }
    }

    # return the both the processed and unprocessed parts
    my $unprocessed = substr $string, $lexer->offset;
    return ($processed, $unprocessed);
}

=head2 decode STRING, CHECK

Decoder for decoding safename.  See module L<Encode::Encoding>.

=cut

sub decode {
}

=head2 encode STRING, CHECK

Encoder for encoding safename.  See module L<Encode::Encoding>.

=cut

# lexer for encoding
my $encode_lexer = Parse::Lex->new(
    # uppercase characters
    E_UPPER => (
        '[A-Z]+',
        sub {
            return '{' . lc $_[1] . '}';
        },
    ),

    # spaces
    E_SPACES => (
        ' +',
        sub {
            my $text = $_[1];
            $text =~ tr/ /_/;
            return $text;
        },
    ),

    # safe characters
    E_SAFE => '[a-z0-9\-+!\$%&\'@~#.,^]+',

    # other characters
    E_OTHER => (
        '.',
        sub {
            return '(' . sprintf('%x', unpack('U', $_[1])) . ')';
        },
    ),
);
$encode_lexer->skip('');

sub encode {
    # process arguments
    my ($self, $string, $check) = @_;

    # apply the lexer for encoding to the string and return the result
    my ($processed, $unprocessed) = $self->_process($encode_lexer, $string);
    $_[1] = $unprocessed if $check;
    return $processed;
}

=head1 AUTHOR

Bert Vanderbauwhede, C<< <batlock666 at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-encode-safename at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Encode-Safename>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Encode::Safename


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Encode-Safename>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Encode-Safename>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Encode-Safename>

=item * Search CPAN

L<http://search.cpan.org/dist/Encode-Safename/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2013 Bert Vanderbauwhede.

This program is free software; you can redistribute it and/or modify it
under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

See http://www.gnu.org/licenses/ for more information.

=cut

1; # End of Encode::Safename
