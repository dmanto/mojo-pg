use Mojo::Base -strict;

use Test::More;
use Mojo::Pg;

# Defaults
my $pg = Mojo::Pg->new;
is $pg->dsn,      'dbi:Pg:', 'right data source';
is $pg->username, '',        'no username';
is $pg->password, '',        'no password';
my $options = {
  AutoCommit          => 1,
  AutoInactiveDestroy => 1,
  PrintError          => 0,
  RaiseError          => 1,
  pg_server_prepare   => 0
};
is_deeply $pg->options, $options, 'right options';

# Minimal connection string with database
$pg = Mojo::Pg->new('postgresql:///test1');
is $pg->dsn,      'dbi:Pg:dbname=test1', 'right data source';
is $pg->username, '',                    'no username';
is $pg->password, '',                    'no password';
$options = {
  AutoCommit          => 1,
  AutoInactiveDestroy => 1,
  PrintError          => 0,
  RaiseError          => 1,
  pg_server_prepare   => 0
};
is_deeply $pg->options, $options, 'right options';

# Minimal connection string with service and option
$pg = Mojo::Pg->new('postgresql://?service=foo&PrintError=1');
is $pg->dsn,      'dbi:Pg:service=foo', 'right data source';
is $pg->username, '',                   'no username';
is $pg->password, '',                   'no password';
$options = {
  AutoCommit          => 1,
  AutoInactiveDestroy => 1,
  PrintError          => 1,
  RaiseError          => 1,
  pg_server_prepare   => 0
};
is_deeply $pg->options, $options, 'right options';

# Connection string with host and port
$pg = Mojo::Pg->new('postgresql://127.0.0.1:8080/test2');
is $pg->dsn, 'dbi:Pg:dbname=test2;host=127.0.0.1;port=8080',
  'right data source';
is $pg->username, '', 'no username';
is $pg->password, '', 'no password';
$options = {
  AutoCommit          => 1,
  AutoInactiveDestroy => 1,
  PrintError          => 0,
  RaiseError          => 1,
  pg_server_prepare   => 0
};
is_deeply $pg->options, $options, 'right options';

# Connection string username but without host
$pg = Mojo::Pg->new('postgresql://postgres@/test3');
is $pg->dsn,      'dbi:Pg:dbname=test3', 'right data source';
is $pg->username, 'postgres',            'right username';
is $pg->password, '',                    'no password';
$options = {
  AutoCommit          => 1,
  AutoInactiveDestroy => 1,
  PrintError          => 0,
  RaiseError          => 1,
  pg_server_prepare   => 0
};
is_deeply $pg->options, $options, 'right options';

# Connection string with unix domain socket and options
$pg = Mojo::Pg->new(
  'postgresql://x1:y2@%2ftmp%2fpg.sock/test4?PrintError=1&RaiseError=0');
is $pg->dsn,      'dbi:Pg:dbname=test4;host=/tmp/pg.sock', 'right data source';
is $pg->username, 'x1',                                    'right username';
is $pg->password, 'y2',                                    'right password';
$options = {
  AutoCommit          => 1,
  AutoInactiveDestroy => 1,
  PrintError          => 1,
  RaiseError          => 0,
  pg_server_prepare   => 0
};
is_deeply $pg->options, $options, 'right options';

# Connection string with lots of zeros
$pg = Mojo::Pg->new('postgresql://0:0@/0?RaiseError=0');
is $pg->dsn,      'dbi:Pg:dbname=0', 'right data source';
is $pg->username, '0',               'right username';
is $pg->password, '0',               'right password';
$options = {
  AutoCommit          => 1,
  AutoInactiveDestroy => 1,
  PrintError          => 0,
  RaiseError          => 0,
  pg_server_prepare   => 0
};
is_deeply $pg->options, $options, 'right options';

# Invalid connection string
eval { Mojo::Pg->new('http://localhost:3000/test') };
like $@, qr/Invalid PostgreSQL connection string/, 'right error';

done_testing();