set ns [new Simulator]
set nf [open out2.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out2.nam &
	exit 0 
}

for {set i 0} {$i < 6} {incr i} {
	set n($i) [$ns node]
}

for {set i 0} {$i < 6} {incr i} {
	$ns duplex-link $n($i) $n([expr ($i+1)%6]) 1Mb 10ms DropTail	
}

for {set i 0} {$i < 6} {incr i} {
	set tcp($i) [new Agent/TCP/Reno]
	$ns set window_ 4
	$ns set cwnd_ 4
	$ns set maxcwnd_ 4
	$ns attach-agent $n($i) $tcp($i)
}

for {set i 0} {$i < 6} {incr i} {
	set ftp($i) [new Application/FTP]
	$ftp($i) attach-agent $tcp($i)
}

for {set i 0} {$i < 6} {incr i} {
	set null($i) [new Agent/TCPSink]
	$ns attach-agent $n($i) $null($i)
}

$ns connect $tcp(0) $null(1)
$ns connect $tcp(1) $null(2)
$ns connect $tcp(2) $null(3)
$ns connect $tcp(3) $null(4)
$ns connect $tcp(4) $null(5)
$ns connect $tcp(5) $null(0)


$ns at 0.5 "$ftp(0) start"
$ns at 0.5 "$ftp(1) start"
$ns at 0.5 "$ftp(2) start"
$ns at 0.5 "$ftp(3) start"
$ns at 0.5 "$ftp(4) start"
$ns at 0.5 "$ftp(5) start"

$ns at 4.5 "$ftp(0) stop"
$ns at 4.5 "$ftp(1) stop"
$ns at 4.5 "$ftp(2) stop"
$ns at 4.5 "$ftp(3) stop"
$ns at 4.5 "$ftp(4) stop"
$ns at 4.5 "$ftp(5) stop"
$ns at 5.0 "finish"
$ns run