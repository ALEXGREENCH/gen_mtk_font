#!/usr/bin/perl

use File::Copy;
use File::Find;
use File::Spec;
use File::Path;

sub recursive(&@) {
    my ($code, $src, $dst) = @_;
    my @src = File::Spec->splitdir($src);
    pop @src unless defined $src[$#src] and $src[$#src] ne '';
    my $src_level = @src;
    find({ wanted => sub {
               my @src = File::Spec->splitdir($File::Find::name);
               my $from = File::Spec->catfile($src, @src[$src_level .. $#src]);
               my $to = File::Spec->catfile($dst, @src[$src_level .. $#src]);
               $code->($from, $to);
           },
           no_chdir => 1,
         },
         $src,
        );
}

sub mirror {
    recursive { -d $_[0] ? do { mkdir($_[1]) unless -d $_[1] } : copy(@_) } @_;
}

sub deldir { 

my($del_dir)=$_[0]; 
my(@direct); 
my(@files); 
opendir (DIR2,"$del_dir"); 
my(@allfile)=readdir(DIR2); 
close (DIR2); 
foreach (@allfile){ 
if (-d "$del_dir/$_"){ 
push(@direct,"$_"); 
} 
else { 
push(@files,"$_"); 
} 
} 

$files=@files; 
$direct=@direct; 
if ($files ne "0"){ 
foreach (@files){ 
unlink("$del_dir/$_"); 
} 
} 
if ($direct ne "0"){ 
foreach (@direct){ 
	if($_ ne "." && $_ ne "..")
	{
		&deldir("$del_dir/$_")   ; 
		
	}

} 
} 

rmdir ("$del_dir");
print $del_dir, "\n";
 
} 

sub replace_mtk_type(@) 
{ 
	my ($cwd,$font) = @_; 
	my @dirs = ($cwd.'/'); 


	my ($dir, $file); 
	while ($dir = pop(@dirs)) 
	{ 
		local *DH; 
		if (!opendir(DH, $dir)) 
		{ 
			warn "Cannot opendir $dir: $! $^E"; 
			next; 
		} 
		foreach (readdir(DH)) 
		{ 
			if ($_ eq '.' || $_ eq '..') 
			{ 
				next; 
			} 
			
			$file = $dir.$_; 
			if (!-l $file && -d _) 
			{ 
				if ($_ eq ".svn")
				{
					#print $file, "\n"; 
					#rmtree "$dir/.svn";
					#rename("$file","$dir/svn");
				}
				else
				{			
					$file .= '/'; 
					push(@dirs, $file); 
				}
	
			}
			else
			{
			    print $file . "\r\n";
			    if ($file =~ m/.*\/L_.*\.h$/g)
			    {
                    open (inf,$file) || die ("$file!!!");
                    my @file2_all = <inf>;
                    close (inf);
                    
                    unlink($file);
                    $file =~ s/\/(L_.*)\.h/\/bfc_$1_$font\.h/g;
                    open (inf,">$file") || die ("$file!!!");
                    foreach $myline (@file2_all)
                    {
                        #print $myline;
                        $string = "#if";
                        $replace = "#if 1 //";

                        $myline =~ s/$string/$replace/g;
                        #print $myline;
                        $string = "U8";
                        $replace = "duint8";
                        $myline =~ s/$string/$replace/g; 
                        #print $myline;

                        $string = "U16";
                        $replace = "duint16";
                        $myline =~ s/$string/$replace/g; 
                        #print $myline;

                        
                        print inf $myline;
                    }
                    close (inf);
                }

			} 
			
			#process($file, $dir); 
		} 
		
	closedir(DH); 
	} 
} 

sub merger_file(@)
{
	my ($cwd,$font) = @_; 
	my @dirs = ($cwd.'/'); 
	my @out_files = ("bfc_L_English_small_$font.h","bfc_L_English_medium_$font.h","bfc_L_English_dialling_$font.h","bfc_L_Chinesec_small_$font.h");
    my $index = 0;

    $dir = $dirs[0];
    $dir =~ s/\\/\//g;
	my $file = $dir. "FontData.c";

    
    print $file . "\r\n";
    open (inf,$file) || die ("$file!!!");
    my @file_all = <inf>;
    close (inf);

    my $data = "";
    my $is_start = 0;
    my $file_cnt = @out_files;
    foreach $myline (@file_all)
    {
        if ($myline =~ m/.*{.*/g )
        {
            $data = $myline;
            $is_start = 1;
        }
        elsif ($myline =~ m/.*}.*/g )
        {
            $data = $data . $myline;
            $file = $dir . $out_files[$index];
            $index = $index + 1;
            
            open (inf,"$file") || die ("$file!!!");
            my @file2_all = <inf>;
            close (inf);
            
            open (inf,">$file") || die ("$file!!!");
            print inf $data;
            print inf $_ for @file2_all;
            close (inf);
            
            $is_start = 0;

            if ($index >= $file_cnt)
            {
                last;
            }
        }
        elsif ($is_start > 0)
        {
            $data = $data . $myline;
        }
    }

}

sub copy_result_file(@)
{
	my ($dir,$font,$dst) = @_; 
    #$dst = "E:\\C675_YAX_E4000X6\\MS_Code\\MS_MMI\\source\\mmi_spml\\include";
    $dst =~ s/\\/\//g;

    my @out_files = ("bfc_compress_dict_$font.h","bfc_L_English_small_$font.h","bfc_L_English_medium_$font.h","bfc_L_English_dialling_$font.h","bfc_L_Chinesec_small_$font.h");
    $dir = $dir . "/";
    
    $dir =~ s/\\/\//g;

    foreach $src_file (@out_files)
    {
        $src_file = $dir . $src_file;
        copy ($src_file ,$dst);
    }
}

sub replace_lv_table(@)
{
	my ($cwd,$font,$dst) = @_; 
    #"E:\\C675_YAX_E4000X6\\MS_Code\\MS_MMI\\source\\mmi_spml\\include";

	my @dirs = ($cwd.'/'); 

    $dir = $dirs[0];
    $dir =~ s/\\/\//g;
	my $file = $dir. "FontRes.c";
    
    print $file . "\r\n";
    open (inf,$file) || die ("$file!!!");
    my @file_all = <inf>;
    close (inf);

    my $lv1_data = "";
    my $lv2_data = "";
    my $is_lv1 = 0;
    my $is_lv2 = 0;
    my $str_lv1 = "g_hw_compression_lv1_table";
    my $str_lv2 = "g_hw_compression_lv2_table";
    foreach $myline (@file_all)
    {
        if ($myline =~ m/.*$str_lv1.*/g)
        {
            $is_lv1 = 1;
        }
        elsif ($myline =~ m/.*$str_lv2.*/g)
        {
            $is_lv2 = 1;
        }
        elsif ($myline =~ m/.*}.*/g)
        {
            if ($is_lv1 > 0)
            {
               $lv1_data = $lv1_data .  $myline;
               $is_lv1 = 0;
            }
            elsif ($is_lv2 > 0)
            {
               $lv2_data = $lv2_data .  $myline;
               $is_lv2 = 0;
            }
        }
        elsif ($is_lv1 > 0)
        {
               $lv1_data = $lv1_data .  $myline;
        }
        elsif ($is_lv2 > 0)
        {
               $lv2_data = $lv2_data .  $myline;
        }
    }

    $dst =~ s/\\/\//g;
    $dst = $dst . "/bfc_compress_dict_$font.h";

	$file = $dir. "bfc_compress_dict_$font.h";
    copy ($dst, $dir);
    
    print $file . "\r\n";
    open (inf,$file) || die ("$file!!!");
    my @file_all = <inf>;
    close (inf);

    open (inf,">$file") || die ("$file!!!");

    foreach $myline (@file_all)
    {
        if ($myline =~ m/.*g_hw_compression_lv1_table.*/g)
        {
            $is_lv1 = 1;
            print inf $myline;

        }
        elsif ($myline =~ m/.*g_hw_compression_lv2_table.*/g)
        {
            $is_lv2 = 1;
            print inf $myline;

        }
        elsif ($myline =~ m/.*}.*/g)
        {
            if ($is_lv1 > 0)
            {
               print inf $lv1_data;
               $is_lv1 = 0;
            }
            elsif ($is_lv2 > 0)
            {
               print inf $lv2_data;
               $is_lv2 = 0;
            }
            else
            {
                print inf $myline;
            }
        }
        elsif ($is_lv1 > 0)
        {
        }
        elsif ($is_lv2 > 0)
        {
        }
        else
        {
            print inf $myline;
        }
    }
    close (inf);

}

$tmp = $ARGV[0]."_1";
#mkdir $tmp;

#mirror "$ARGV[0]", "$tmp"; 
my $ARGC = @ARGV;
my $dest_dir = "";
if ($ARGC == 2)
{
    $dest_dir = "E:\\C675_YAX_E4000X6\\MS_Code\\MS_MMI\\source\\mmi_spml\\include";
}
elsif ($ARGC == 3)
{
	$dest_dir = $ARGV[2] . "\\MS_Code\\MS_MMI\\source\\mmi_spml\\include";
}
else
{
    print "para need:cur_file_folder font_num dest_folder\n";
    print "parameter count error!";
    exit;
}

replace_mtk_type "$ARGV[0]", "$ARGV[1]";
merger_file "$ARGV[0]", "$ARGV[1]";
replace_lv_table "$ARGV[0]", "$ARGV[1]", "$dest_dir";
copy_result_file "$ARGV[0]", "$ARGV[1]", "$dest_dir";



