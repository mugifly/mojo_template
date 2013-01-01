#!/usr/bin/env perl
use File::Find;
use Cwd;
our $DEFAULT_APP_NAME = 'Example';
our $TARGET_DIR_PATH = Cwd::getcwd();
my $new_name;
while(1){
	print "Please enter your new app name (Must use Camelcase. ex: 'Foo'): ";
	$new_name  = <STDIN>;
	chomp($new_name);
	
	if($new_name eq ""){
		print "\nCancel.\n";
		exit;
	}
	print "Will this do initialize by this app name ('$new_name')? [y/n]: ";
	my $ans = <STDIN>;
	chomp($ans);
	if($ans eq "y" || $ans eq "Y"){
		last;
	}
}
renameFiles($TARGET_DIR_PATH, $DEFAULT_APP_NAME, $new_name);
print "\nComplete. let's enjoy!\n";
exit;

sub renameFiles {
	my ($target_dir, $old_name, $new_name) = @_;
	my $old_name_lc = lc($old_name);
	my $new_name_lc = lc($new_name);
	print "\nRename files ($old_name ->  $new_name) ...\n";
	File::Find::find(sub{
		my $fname = $_;
		my $fpath = $File::Find::name;
		my $fdir = $File::Find::dir;
		my $is_dir = 0;
		eval{
			if($fname =~ /README\.md/ || $fname =~ /LICENSE_.+/){
				return;
			}
			if($fpath =~ /\.git\/.*/i){
				return;
			}
			if(-d $fpath){
				$is_dir = 1;
			}
			if($is_dir eq 0) {
				# Content
				my $data;		
				open (my $fh, '<', $fpath) or die "Can't open $fpath - $!";	
				{
					local $/ = undef;
					$data = readline($fh);
				}
				if($data =~ /$old_name/gi){
					print "  * Replace: $fpath\n";
					$data =~ s/$old_name/$new_name/g;
					$data =~ s/$old_name_lc/$new_name_lc/g;
					open (my $fh_, '>', $fpath) or die "Can't open $fpath - $!";
					print $fh_, $data;
					close $fh_;
				}
				close $fh;
			}
			# File name
			if($fname =~ /.*$old_name.*/gi){
				my $new_fname = $fname;
				$new_fname =~ s/$old_name/$new_name/g;
				$new_fname =~ s/$old_name_lc/$new_name_lc/g;
				print "  * Rename: $fpath -> $new_fname\n";
				rename($fpath, $new_fname);
			}
		};
		if($@){
			print "  [Error!]: $fpath - $@";
			return;
		}
	}, ($target_dir));
	print "Rename Complete.\n";
}

