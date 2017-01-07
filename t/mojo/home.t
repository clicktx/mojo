use Mojo::Base -strict;

BEGIN { $ENV{MOJO_REACTOR} = 'Mojo::Reactor::Poll' }

use Test::More;
use FindBin;
use Mojo::File 'path';
use Mojo::HelloWorld;
use Mojo::Home;

# ENV detection
my $cwd = path->to_abs;
{
  local $ENV{MOJO_HOME} = '.';
  my $home = Mojo::Home->new->detect;
  is_deeply path($home->to_string)->to_abs->to_array, $cwd->to_array,
    'right path detected';
}

# Specific class detection
{
  local $INC{'MyClass.pm'} = 'MyClass.pm';
  my $home = Mojo::Home->new->detect('MyClass');
  is_deeply path($home->to_string)->to_abs->to_array, $cwd->to_array,
    'right path detected';
}

# Current working directory
my $home = Mojo::Home->new->detect;
is_deeply path($home->to_string)->to_array, $cwd->to_array,
  'right path detected';

# Path generation
$home = Mojo::Home->new($FindBin::Bin);
my $path = path($FindBin::Bin);
is $home->lib_dir, $path->child('lib'), 'right path';
is $home->rel_file('foo.txt'), $path->child('foo.txt'), 'right path';
is $home->rel_file('foo/bar.txt'), $path->child('foo', 'bar.txt'), 'right path';

done_testing();
