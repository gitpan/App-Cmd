package App::Cmd::Command::commands;

=head1 NAME

App::Cmd::Command::commands - list the application's commands

=head1 VERSION

 $Id: /my/cs/projects/app-cmd/trunk/lib/App/Cmd/Command/commands.pm 28012 2006-11-14T22:31:48.667796Z rjbs  $

=head1 DESCRIPTION

This command plugin implements a "commands" command.  This command will list
all of an App::Cmd's commands and their abstracts.

=head1 METHODS

=cut

use strict;
use warnings;

use base qw(App::Cmd::Command);

=head2 C<run>

This is the command's primary method and raison d'etre.  It prints the
application's usage text (if any) followed by a sorted listing of the
application's commands and their abstracts.

The commands are printed in sorted groups (created by C<sort_commands>); each
group is set off by blank lines.

=cut

sub run {
  my ($self) = @_;

  local $@;
  eval { print $self->app->_usage_text . "\n" };

  print "Available commands:\n\n";

  my @primary_commands =
    map { ($_->command_names)[0] } 
    $self->app->command_plugins;

  my @cmd_groups = $self->sort_commands(@primary_commands);

  my $fmt_width = 0;
  for (@primary_commands) { $fmt_width = length if length > $fmt_width }
  $fmt_width += 2; # pretty

  foreach my $cmd_set (@cmd_groups) {
    for my $command (@$cmd_set) {
      my $abstract = $self->app->plugin_for($command)->abstract;
      printf "%${fmt_width}s: %s\n", $command, $abstract;
    }
    print "\n";
  }
}

=head2 C<sort_commands>

  my @sorted = $cmd->sort_commands(@unsorted);

This method orders the list of commands into sets which it returns as a list of
arrayrefs.

By default, the first group is for the "help" and "commands" commands, and all
other commands are in the second group.

=cut

sub sort_commands {
  my ($self, @commands) = @_;

  my $float = qr/^(?:help|commands)$/;

  my @head = sort grep { $_ =~ $float } @commands;
  my @tail = sort grep { $_ !~ $float } @commands;

  return (\@head, \@tail);
}

1;
