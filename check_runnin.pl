use strict;
use warnings;
my $oratab = '/etc/oratab';
open my $handle, '<', $oratab;
chomp(my @oratab_instances = <$handle>);
close $handle;
my @oratab_asm_id  = grep(/\+ASM/, @oratab_instances);
my @adm_id_arr = split(/\:/,join("",@oratab_asm_id));
my $asm_id= substr($adm_id_arr[-3],4,5);
@oratab_instances = grep(/$asm_id\:/, grep(!/\+ASM/, @oratab_instances));
foreach (@oratab_instances)
{
	my @tab = split(/\:/, $_);
	my $instance = $tab[-3]; 
	my $process_count = `ps -edf | grep -i ora_pmon_$instance | grep -v grep | wc -l`;
	if ( $process_count == 0 )
	{ printf "%-10s is NOT running!\n", $instance; }
	else
	{ printf "%-10s is running.\n", $instance;}
}
