package App::Cmd::ArgProcessor;

=head1 NAME

App::Cmd::ArgProcessor - App::Cmd-specific wrapper for Getopt::Long::Descriptive

=head1 VERSION

 $Id: /my/cs/projects/app-cmd/trunk/lib/App/Cmd/ArgProcessor.pm 25148 2006-08-25T23:00:16.455519Z rjbs  $

=cut

use strict;
use warnings;

sub _process_args {
  my ($class, $args, @params) = @_;
  local @ARGV = @$args;

  require Getopt::Long::Descriptive;

  my ($opt, $usage) = Getopt::Long::Descriptive::describe_options(@params);

  return (
    $opt,
    [ @ARGV ], # whatever remained
    usage => $usage,
  );
}

1;
